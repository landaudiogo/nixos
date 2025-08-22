# MediaServer

This mostly follows the [YAMS](https://yams.media/) setup. Lookup the configuration instructions for each service to configure your media server. 

The mediaserver runs: 

* gluetun: Runs the wireguard interface that connects to a Mullvad VPN service. Any service that interacts with public indexers (i.e. prowlarr, radarr, sonarr, qbittorrent) will be placed in gluetun's network namespace such all their networking goes through the VPN;
* prowlarr: Manages the indexers for both Radarr and Sonarr;
* sonarr: Used to manage the requested TV shows, and requests qbittorrent to download;
* radarr: Used to manage the requested movies, and requests qbittorrent to download;
* bazarr: Downloads subtitles for the downloaded content via Open Subtitles;
* qbittorrent: Downloads a given torrent;
* jellyseerr: Used to forward movie or TV show requests automatically to radarr or sonarr respectively.
* jellyfin: Media server that streams the content to the connected devices.
