{ lib, ... }:
let
  mediaServices = [
    "docker-qbittorrent"
    "docker-radarr"
    "docker-sonarr"
    "docker-bazarr"
    "jellyfin"
  ];
in
{
    imports = [ ./compose.nix ];
    systemd.services = lib.genAttrs mediaServices (_: {
        unitConfig.RequiresMountsFor = "/var/lib/mediaserver/media";
    });
}
