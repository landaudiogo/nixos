{ ... }:
{
    virtualisation.oci-containers.containers = {
        vikunja = {
            image = "vikunja/vikunja@sha256:84b56920e2860c67cb889bce0e0950aa529e42838b45bdf81eb2422178e90cc7";
            ports = [ "10.0.0.5:3456:3456" ];
            volumes = [
                "/var/lib/vikunja/files:/app/vikunja/files"
                "/var/lib/vikunja/db:/db"
            ];
            environment = {
                VIKUNJA_SERVICE_PUBLICURL = "https://tasks.ad.dlandau.nl";
                VIKUNJA_DATABASE_TYPE = "sqlite";
                VIKUNJA_DATABASE_USER = "vikunja";
                VIKUNJA_DATABASE_DATABASE = "vikunja";
                # VIKUNJA_SERVICE_JWTSECRET = <fake-secret>
            };
        };
    };
}
