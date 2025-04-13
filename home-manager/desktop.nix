{ pkgs, ... }:

{
    home.packages = with pkgs; [ 
        stremio
        alacritty
        firefox
        google-chrome
        evince
        xournalpp
    ];

    xdg.mimeApps = {
        enable = true;
        defaultApplications = {
            "application/pdf" = [ "org.gnome.Evince.desktop" ];
            "text/html" = [ "google-chrome.desktop" ];
            "x-scheme-handler/http"=["google-chrome.desktop"];
            "x-scheme-handler/https"=["google-chrome.desktop"];
            "x-scheme-handler/about"=["google-chrome.desktop"];
            "x-scheme-handler/unknown"=["google-chrome.desktop"];
        };
    };
}
