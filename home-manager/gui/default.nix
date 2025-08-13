{config, lib, pkgs, nixosConfig, ...}:
let
    cfg = config.role.gui;
in
{
    options.role.gui = {
        browse = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = true;
            description = "Whether the device is used to browse";
        };

        pdfViewer = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = true;
            description = "Whether the device is used to view PDFs";
        };

        mediaPlayer = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Whether the device is used to play media";
        };

        mediaServer = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Whether the device is serves media";
        };

        eWriter = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Whether the device is used as an E-Writer";
        };
    };

    # imports = [./];
    config = lib.mkIf nixosConfig.services.xserver.enable {
        home.packages = with pkgs; [ 
            eza
            xclip
        ]
            ++ lib.optionals cfg.browse [ pkgs.unstable.google-chrome ]
            ++ lib.optionals cfg.pdfViewer [ evince ]
            ++ lib.optionals (cfg.mediaPlayer || cfg.mediaServer) [ stremio ]
            ++ lib.optionals cfg.eWriter [ xournalapp ];

        xdg.mimeApps = {
            enable = true; 
            defaultApplications = {
                "application/pdf" = [ "org.gnome.Evince.desktop" "google-chrome.desktop" ];
                "text/html" = [ "google-chrome.desktop" ];
                "x-scheme-handler/http" = [ "google-chrome.desktop" ];
                "x-scheme-handler/https" = [ "google-chrome.desktop" ];
                "x-scheme-handler/about" = [ "google-chrome.desktop" ];
                "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];
            };
        };
    };
}
