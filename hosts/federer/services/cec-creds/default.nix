{ config, inputs, pkgs, ... }:
{
    age.secrets.cec-creds.file = ../../../../secrets/cec-creds-env.age;
    virtualisation.oci-containers = {
        containers = {
            cec-creds = {
                imageFile = inputs.cec-infrastructure.images.${pkgs.system}.backend;
                image = "dclandau/cec-creds-backend";
                volumes = [
                    "/var/lib/cec-creds/creds:/creds"
                    "/var/lib/cec-creds/data:/data"
                ];
                extraOptions = [
                    "--network=container:nginx"
                ];
                environmentFiles = [
                    config.age.secrets.cec-creds.path
                ];
            };

        };
    };
}
