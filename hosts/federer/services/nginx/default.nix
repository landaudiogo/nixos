{ lib, config, pkgs, ...}:
let
    cfg = config.services.nginx;
    timeLogger = pkgs.fetchzip {
        url = "https://github.com/user-attachments/files/21853327/static.zip"; sha256 = "sha256-arbg3s/ey3cBi5kigKXWyXkqRA9dWhqykLw2tz8zlts="; 
    };
in
{

    options = {
        services.nginx.nginxConfig = lib.mkOption {
            type = lib.types.path;
        };
    };

    config = {
        services.nginx.nginxConfig = ./conf.d;
        virtualisation.oci-containers = {
            containers = {
                nginx = {
                    image = "nginx:stable-alpine3.21";
                    ports = [
                        "80:80"
                        "443:443"
                    ];
                    volumes = [ 
                        "${cfg.nginxConfig}:/etc/nginx/conf.d:ro" 
                        "/var/lib/acme:/etc/certificates:ro"
                        "${timeLogger}:/usr/share/time-logger"
                    ];
                };
            };
        };
        systemd.services.docker-nginx.after = [ 
            "acme-finished-flatnotes.ad.dlandau.nl.target" 
            "acme-finished-paperless.ad.dlandau.nl.target" 
            "acme-finished-timer.ad.dlandau.nl.target" 
        ];
        systemd.services.docker-nginx.requires = [ 
            "acme-finished-flatnotes.ad.dlandau.nl.target" 
            "acme-finished-timer.ad.dlandau.nl.target" 
        ];

        age.secrets.lego-pdns.file = ../../../../secrets/lego-pdns.age;
        security.acme.acceptTerms = true;
        security.acme.defaults.email = "diogo.hewitt.landau@hotmail.com";
        security.acme.certs = {
            "flatnotes.ad.dlandau.nl" = {
                domain = "flatnotes.ad.dlandau.nl";
                dnsProvider = "pdns";
                environmentFile = config.age.secrets.lego-pdns.path;
                # We don't need to wait for propagation since this is a local DNS server
                dnsPropagationCheck = false;
            };
            "paperless.ad.dlandau.nl" = {
                domain = "paperless.ad.dlandau.nl";
                dnsProvider = "pdns";
                environmentFile = config.age.secrets.lego-pdns.path;
                # We don't need to wait for propagation since this is a local DNS server
                dnsPropagationCheck = false;
            };
            "timer.ad.dlandau.nl" = {
                domain = "timer.ad.dlandau.nl";
                dnsProvider = "pdns";
                environmentFile = config.age.secrets.lego-pdns.path;
                # We don't need to wait for propagation since this is a local DNS server
                dnsPropagationCheck = false;
            };
        };
    };
}
