{ pkgs, config, ... }:
let
    timeLogger = pkgs.fetchzip {
        url = "https://github.com/user-attachments/files/21853327/static.zip"; 
        sha256 = "sha256-arbg3s/ey3cBi5kigKXWyXkqRA9dWhqykLw2tz8zlts="; 
    };
    homePublicIP = "84.106.119.23";
in
{
    imports = [ 
        ./pdns 
        ./gateway.nix
    ];

    gateway = {
        zones = [ "ad.dlandau.nl" ];
        defaultRecordIP = "10.0.0.1";
        services = { 
            flatnotes = {
                recordName = "flatnotes.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:8080";
            };
            koffan = {
                recordName = "koffan.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:3122";
            };
            ana-koffan = {
                recordName = "ana.koffan.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:3122";
                requireClientCertificate = true;
                allowRanges = ["0.0.0.0/0"];
                DNSRecordIP = homePublicIP;
            };
            home-assistant = {
                recordName = "ha.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:8123";
            };
            ana-homeassistant = {
                recordName = "anaha.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:8123";
                requireClientCertificate = true;
                allowRanges = ["0.0.0.0/0"];
                DNSRecordIP = homePublicIP;
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
            tasks = {
                recordName = "tasks.ad.dlandau.nl";
                proxyConnection = "10.0.0.5:3456";
            };
            timer = {
                recordName = "timer.ad.dlandau.nl";
                staticContent = timeLogger;
                allowRanges = ["0.0.0.0/0"];
                DNSRecordIP = homePublicIP;
            };
            jvfJellyfin = {
                recordName = "jellyfin-jvf.ad.dlandau.nl";
                DNSRecordIP = "192.168.0.36";
                proxyConnection = "10.0.0.5:8096";
                allowRanges = [ "192.168.0.0/24" ];
            };
            jvfJellyseerr = {
                recordName = "jellyseerr-jvf.ad.dlandau.nl";
                DNSRecordIP = "192.168.0.36";
                proxyConnection = "10.0.0.5:5055";
                allowRanges = [ "192.168.0.0/24" ];
            };
        };
    };
}
