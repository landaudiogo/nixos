{ pkgs, lib, inputs, ... }:
let
    execConditionScript = pkgs.writeShellApplication {
        name = "check-webcam";
        runtimeInputs = [ pkgs.v4l-utils ];
        text = ''
            v4l2-ctl --list-devices | grep "C505e HD Webcam"
        '';
    };
    webcamDeviceScript = pkgs.writeShellApplication {
        name = "webcam-device";
        runtimeInputs = [ 
            pkgs.v4l-utils 
            pkgs.gawk 
        ];
        text = ''
            v4l2-ctl --list-devices |
                awk '
                    /^C505e HD Webcam/ {
                        capture=1; next
                    }
                    capture && /\/dev\/video/ {
                        print $1; 
                        exit;
                    }
                '
        '';
    };
in
{
    virtualisation.oci-containers = {
        containers = {
            webcam = {
                imageFile = inputs.toolshed.images.${pkgs.system}.webcam;
                image = "jvf-webcam";
            };
        };
    };

    systemd.services.docker-webcam = {
        serviceConfig = {
            ExecCondition = [ "${execConditionScript}/bin/check-webcam" ];
        };
        script = lib.mkForce ''
            exec docker  \
              run \
              --name=webcam \
              --log-driver=journald \
              -e WEBCAM_ADDRESS=http://10.0.0.5:8085 \
              -p 10.0.0.5:8084:8000/tcp \
              -p 10.0.0.5:8085:8081/tcp \
              --rm \
              --pull missing \
              --device "$(${webcamDeviceScript}/bin/webcam-device)" \
              -e VIDEO_DEVICE="$(${webcamDeviceScript}/bin/webcam-device)" \
              jvf-webcam
        '';
    };
}
