{ pkgs, inputs, ... }:
{
    virtualisation.oci-containers = {
        containers = {
            webcam = {
                imageFile = inputs.toolshed.images.${pkgs.system}.webcam;
                image = "jvf-webcam";
                volumes = [
                    "/dev/video2:/dev/video2"
                ];
                ports = [
                  "10.0.0.5:8084:8000/tcp"
                  "10.0.0.5:8085:8081/tcp"
                ];
                environment = {
                    "WEBCAM_ADDRESS" = "http://10.0.0.5:8085";
                };
                privileged = true;
            };

        };
    };
}
