{ lib, config, ...}:
let
    cfg = config.services.nginx;
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
                        "10.0.0.1:80:80"
                        "10.0.0.1:443:443"
                    ];
                    volumes = [ 
                        "${cfg.nginxConfig}:/etc/nginx/conf.d:ro" 
                        "/var/lib/acme:/etc/certificates:ro"
                    ];
                };
            };
        };
        systemd.services.docker-nginx.after = [ 
            "acme-finished-flatnotes.ad.dlandau.nl.target" 
            "acme-finished-paperless.ad.dlandau.nl.target" 
        ];
        systemd.services.docker-nginx.requires = [ 
            "acme-finished-flatnotes.ad.dlandau.nl.target" 
            "acme-finished-paperless.ad.dlandau.nl.target" 
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
        };
    };
}
