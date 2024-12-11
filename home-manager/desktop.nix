{ pkgs, ... }:

{
    home.packages = with pkgs; [ 
        stremio
        alacritty
        firefox
        zsh
    ];
}
