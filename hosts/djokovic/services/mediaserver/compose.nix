# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, config, ... }:

{
  imports = [ ./jellyfin.nix ];

  age.secrets.gluetun-env.file = ../../../../secrets/gluetun-env.age;

  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."bazarr" = {
    image = "lscr.io/linuxserver/bazarr";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/lib/mediaserver/install/config/bazarr:/config:rw"
      "/var/lib/mediaserver/media:/data:rw"
    ];
    ports = [
      "10.0.0.5:6767:6767/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=bazarr"
      "--network=mediaserver_default"
    ];
  };
  systemd.services."docker-bazarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mediaserver_default.service"
    ];
    requires = [
      "docker-network-mediaserver_default.service"
    ];
    partOf = [
      "docker-compose-mediaserver-root.target"
    ];
    wantedBy = [
      "docker-compose-mediaserver-root.target"
    ];
  };
  virtualisation.oci-containers.containers."gluetun" = {
    image = "qmcgaw/gluetun:v3";
    environmentFiles = [ config.age.secrets.gluetun-env.path ];
    ports = [
      "10.0.0.5:8888:8888/tcp"
      "10.0.0.5:8388:8388/tcp"
      "10.0.0.5:8388:8388/udp"
      "10.0.0.5:9696:9696/tcp"
      "10.0.0.5:8989:8989/tcp"
      "10.0.0.5:7878:7878/tcp"
      "10.0.0.5:8081:8081/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--network-alias=gluetun"
      "--network=mediaserver_default"
    ];
  };
  systemd.services."docker-gluetun" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mediaserver_default.service"
    ];
    requires = [
      "docker-network-mediaserver_default.service"
    ];
    partOf = [
      "docker-compose-mediaserver-root.target"
    ];
    wantedBy = [
      "docker-compose-mediaserver-root.target"
    ];
  };
  virtualisation.oci-containers.containers."jellyseerr" = {
    image = "fallenbagel/jellyseerr:latest";
    environment = {
      "PGID" = "1000";
      "PORT" = "5055";
      "PUID" = "1000";
      "TZ" = "Asia/Tashkent";
    };
    volumes = [
      "/var/lib/mediaserver/install/config/jellyseerr:/app/config:rw"
    ];
    ports = [
      "10.0.0.5:5055:5055/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=jellyseerr"
      "--network=mediaserver_default"
    ];
  };
  systemd.services."docker-jellyseerr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "docker-network-mediaserver_default.service"
    ];
    requires = [
      "docker-network-mediaserver_default.service"
    ];
    partOf = [
      "docker-compose-mediaserver-root.target"
    ];
    wantedBy = [
      "docker-compose-mediaserver-root.target"
    ];
  };
  virtualisation.oci-containers.containers."prowlarr" = {
    image = "lscr.io/linuxserver/prowlarr";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/lib/mediaserver/install/config/prowlarr:/config:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."docker-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-mediaserver-root.target"
    ];
    wantedBy = [
      "docker-compose-mediaserver-root.target"
    ];
  };
  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "lscr.io/linuxserver/qbittorrent:4.6.3";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "WEBUI_PORT" = "8081";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/lib/mediaserver/install/config/qbittorrent:/config:rw"
      "/var/lib/mediaserver/media:/data:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."docker-qbittorrent" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-mediaserver-root.target"
    ];
    wantedBy = [
      "docker-compose-mediaserver-root.target"
    ];
  };
  virtualisation.oci-containers.containers."radarr" = {
    image = "lscr.io/linuxserver/radarr";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/lib/mediaserver/install/config/radarr:/config:rw"
      "/var/lib/mediaserver/media:/data:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."docker-radarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-mediaserver-root.target"
    ];
    wantedBy = [
      "docker-compose-mediaserver-root.target"
    ];
  };
  virtualisation.oci-containers.containers."sonarr" = {
    image = "lscr.io/linuxserver/sonarr";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/lib/mediaserver/install/config/sonarr:/config:rw"
      "/var/lib/mediaserver/media:/data:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."docker-sonarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-mediaserver-root.target"
    ];
    wantedBy = [
      "docker-compose-mediaserver-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-mediaserver_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f mediaserver_default";
    };
    script = ''
      docker network inspect mediaserver_default || docker network create mediaserver_default
    '';
    partOf = [ "docker-compose-mediaserver-root.target" ];
    wantedBy = [ "docker-compose-mediaserver-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-mediaserver-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
