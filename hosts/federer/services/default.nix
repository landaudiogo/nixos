{ pkgs, ... }:
let
    timeLogger = pkgs.fetchzip {
        url = "https://github.com/user-attachments/files/21853327/static.zip"; 
        sha256 = "sha256-arbg3s/ey3cBi5kigKXWyXkqRA9dWhqykLw2tz8zlts="; 
    };
in
{
    imports = [ 
        ./pdns 
        ./gateway.nix
    ];

    gateway = {
        zones = [ "ad.dlandau.nl" ];
        externalIP = "77.171.239.251";
        internalIP = "10.0.0.1";
        services = { 
            flatnotes = {
                recordName = "flatnotes.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:8080";
            };
            home-assistant = {
                recordName = "ha.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:8123";
            };
            jellyfin = {
                recordName = "jellyfin.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:8096";
            };
            jellyseerr = {
                recordName = "jellyseerr.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:5055";
            };
            sonarr = {
                recordName = "sonarr.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:8989";
            };
            radarr = {
                recordName = "radarr.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:7878";
            };
            bazarr = {
                recordName = "bazarr.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:6767";
            };
            prowlarr = {
                recordName = "prowlarr.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:9696";
            };
            qbit = {
                recordName = "qbit.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:8081";
            };
            timer = {
                recordName = "timer.ad.dlandau.nl";
                staticContent = timeLogger;
                VPNOnly = false;
            };
        };
    };
}
