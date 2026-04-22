{ config, ... }:
{
    age.secrets.koffan.file = ../../../../secrets/koffan.age;
    virtualisation.oci-containers.containers = {
        koffan = {
            image = "ghcr.io/pansalut/koffan@sha256:ba942d46332356dceb1f498a7d06e9c5ea8b260ac75f725aabad3d1828bab1cf";
            ports = [ "10.0.0.5:3122:80" ];
            volumes = [
                "/var/lib/koffan:/data"
            ];
            environmentFiles = [
                config.age.secrets.koffan.path
            ];
        };
    };
}
