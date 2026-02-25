{ pkgs, lib, config, inputs, ... }:
let
    gatewayServiceOption = lib.types.submodule {
        options = {
            recordName = lib.mkOption {
                type = lib.types.str;
            };

            proxyConnection = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
            };

            VPNOnly = lib.mkOption {
                type = lib.types.bool;
                default = true;
            };

            staticContent = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
            };
        };
    };
    cfg = config.gateway;
    gatewayServices = builtins.attrValues cfg.services;


    ################
    # nginx config #
    ################
    nginxProxyServiceConfig = (svc: ''
        server {
            listen 80;
            server_name ${svc.recordName};

            ${lib.optionalString svc.VPNOnly ''
            allow 10.0.0.0/24;
            deny all;
            ''}

            location / {
                return 301 https://$host$request_uri;
            }
        }

        server {
            listen 443 ssl;
            server_name             ${svc.recordName};
            ssl_certificate         /etc/certificates/${svc.recordName}/cert.pem;
            ssl_certificate_key     /etc/certificates/${svc.recordName}/key.pem;

            ${lib.optionalString svc.VPNOnly 
            ''
            allow 10.0.0.0/24; 
            deny all;
            ''}

            location / {
                proxy_pass http://${svc.proxyConnection};
                proxy_read_timeout 300s;
                proxy_connect_timeout 10s;
                proxy_set_header Host $host;
                proxy_redirect http:// https://;
                proxy_http_version 1.1;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
            }
        }
    '');
    nginxStaticServiceConfig = (svc: ''
        server {
            listen 80;
            server_name ${svc.recordName};

            ${lib.optionalString svc.VPNOnly 
            ''
            allow 10.0.0.0/24; 
            deny all;
            ''}

            location / {
                return 301 https://$host$request_uri;
            }
        }

        server {
            listen 443 ssl;
            server_name             ${svc.recordName};
            ssl_certificate         /etc/certificates/${svc.recordName}/cert.pem;
            ssl_certificate_key     /etc/certificates/${svc.recordName}/key.pem;

            ${lib.optionalString svc.VPNOnly 
            ''
            allow 10.0.0.0/24; 
            deny all;
            ''}

            root   /usr/share/${svc.recordName};

            location / {
                index  index.html;
                try_files $uri /index.html =404;
            }
        }
    '');
    nginxConfig = pkgs.writeText "nginx-config" (
        ''
        map $http_upgrade $connection_upgrade {
            default upgrade;
            '''      close;
        }

        server {
            listen 80;

            location / {
                root   /usr/share/nginx/html;
                index  index.html index.htm;
            }
        }
        ''
        + "\n\n\n\n"
        + (lib.concatStringsSep "\n\n\n\n\n" (builtins.map nginxProxyServiceConfig (builtins.filter (svc: svc.proxyConnection != null) gatewayServices)))
        + "\n\n\n\n"
        + (lib.concatStringsSep "\n\n\n\n\n" (builtins.map nginxStaticServiceConfig (builtins.filter (svc: svc.staticContent != null) gatewayServices)))
        # + staticConfig
    );

    ##################
    # pdnsctl config #
    ##################
    zones = cfg.zones;
    servicesByZone = builtins.foldl' 
        (acc: zone: 
            acc // {
                ${zone + "."} = (
                    builtins.filter 
                    (svc: (builtins.match ''^.*${zone}$'' svc.recordName) != null) 
                    gatewayServices
                );
            }
        ) {} zones;
    pdnsctlZoneService = (zone: services:
        {
            script = builtins.concatStringsSep "\n" (
                builtins.map (svc: ''${pkgs.pdnsctl}/bin/create-rrset ${svc.recordName + "."} ${if svc.VPNOnly then cfg.internalIP else cfg.externalIP}'') services
            );

            environment = {
                ZONE = "${zone}";
            };
            serviceConfig = {
                EnvironmentFile = config.age.secrets."pdnsctl-${zone}".path;
                PassEnvironment = [ 
                    "PDNS_API_KEY" 
                    "ZONE" 
                    "PDNS_SERVER" 
                ];
                Type = "oneshot";
                User = "root";
                RemainAfterExit = true;
            };

            wantedBy = ["multi-user.target"];
        }
    );
    pdnsctlServices = builtins.foldl' (acc: zone:
        let
            services = servicesByZone.${zone};
        in
        acc // {
            "pdnsctl-${zone}" = pdnsctlZoneService zone services;
        }
    ) {} (builtins.attrNames servicesByZone);

    ########
    # ACME #
    ########
    acmeCerts = builtins.foldl' (acc: svc: 
        acc // {
            "${svc.recordName}" = {
                domain = svc.recordName;
                dnsPropagationCheck = false;
            };
        }
    ) {} gatewayServices;

    ###############
    # pdnsctl age #
    ###############
    pdnsctlAgeFiles = builtins.foldl' (acc: zone:
        acc // {
            "pdnsctl-${zone}".file = ../../../secrets/pdnsctl-${zone}.age;
        } 
    ) {} (builtins.attrNames servicesByZone);

    ###################
    # static services #
    ###################
    staticServiceVolumeMapping = builtins.map (svc: "${svc.staticContent}:/usr/share/${svc.recordName}:ro") (builtins.filter (svc: svc.staticContent != null) gatewayServices);
in
{
    options = {
        gateway.services = lib.mkOption {
            type = lib.types.attrsOf gatewayServiceOption;
        };
        gateway.zones = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
        };
        gateway.externalIP = lib.mkOption {
            type = lib.types.str;
        };
        gateway.internalIP = lib.mkOption {
            type = lib.types.str;
        };
    };

    config = { 
        assertions = [
            { assertion = config.virtualisation.docker.enable == true; message = "docker should be enabled"; }
            { 
                assertion = 
                    ! builtins.any 
                    (cond: cond) 
                    (
                        builtins.map 
                        (svc: (svc.proxyConnection != null) && (svc.staticContent != null))
                        gatewayServices
                    ); 
                message = "gateway.service.<name>: staticContent AND proxyConnection cannot both be set"; 
            }
        ];

        age.secrets = {
            lego-pdns.file = ../../../secrets/lego-pdns.age;
        } // pdnsctlAgeFiles;

        systemd.services = pdnsctlServices 
            # docker-nginx should restart if the acme services complete successfully
            //  { 
                    # docker-nginx should run after the acme services
                    "docker-nginx".serviceConfig.After = builtins.map (svc: "acme-finished-${svc.recordName}.target") gatewayServices; 
                    # We create an nginx reloader service to be triggered on renewal success
                    "nginx-reloader" = {
                        script = ''
                            ${pkgs.docker}/bin/docker exec nginx nginx -s reload
                        '';
                        serviceConfig.Type = "oneshot";
                    };
                }
            //  builtins.foldl' (acc: svc: 
                    acc // {
                        "acme-${svc.recordName}" = {
                            unitConfig = {
                                OnSuccess = "nginx-reloader.service";
                            };
                            serviceConfig = {
                                # ACME services should run after pdnsctl
                                After = builtins.map (zone: "pdnsctl-${zone}.service") cfg.zones;
                            };
                        };
                    }
                ) {} gatewayServices
        ;

        security.acme = {
            acceptTerms = true;
            defaults = {
                email = "diogo.hewitt.landau@hotmail.com";
                environmentFile = config.age.secrets.lego-pdns.path;
                dnsProvider = "pdns";
            };
            certs = acmeCerts;
        };

        virtualisation.oci-containers.containers.nginx = {
            image = "nginx:stable-alpine3.21";
            ports = [
                "80:80"
                "443:443"
            ];
            volumes = [ 
                "${nginxConfig}:/etc/nginx/conf.d/nginx.conf:ro" 
                "/var/lib/acme:/etc/certificates:ro"
            ] ++ staticServiceVolumeMapping;
        };
    };
}
