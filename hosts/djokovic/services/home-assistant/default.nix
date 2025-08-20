{ pkgs, ... }:
{
    virtualisation.oci-containers = {
        containers = {
            home-assistant = {
                image = "ghcr.io/home-assistant/home-assistant:stable";
                environment = {
                    "TZ" = "Europe/Amsterdam";
                };
                volumes = [
                    "/var/lib/config:/config"
                    "/run/dbus:/run/dbus:ro"
                ];
                privileged = true;
                extraOptions = ["--network=host"];
            };

        };
    };
    systemd.services.docker-home-assistant.postStart = "
        ${pkgs.iptables}/bin/iptables -t filter -I INPUT -j ACCEPT -p tcp -s 10.0.0.0/24 --dport 8123 
    ";

    systemd.services.docker-home-assistant.postStop = "
        ${pkgs.iptables}/bin/iptables -t filter -D INPUT -j ACCEPT -p tcp -s 10.0.0.0/24 --dport 8123 
    ";

}
