{ ... }:
{
    services.jellyfin = {
        enable = true;
        user = "1000";
        group = "100";
        cacheDir = "/var/lib/mediaserver/install/config/jellyfin/cache";
        configDir = "/var/lib/mediaserver/install/config/jellyfin/config";
        logDir = "/var/lib/mediaserver/install/config/jellyfin/log";
        dataDir = "/var/lib/mediaserver/install/config/jellyfin/data";
    };
    systemd.services.jellyfin.serviceConfig.CPUQuota = "200%";

    networking.firewall.interfaces.wg0.allowedTCPPorts = [ 8096 ];
}
