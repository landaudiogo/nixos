{ pkgs, ... }:

{
    imports = [ 
        ./alacritty.nix
        ./tmux.nix 
        ./git.nix
        ./desktop.nix
    ];

    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
    };

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "landaudiogo";
    home.homeDirectory = "/home/landaudiogo";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.05";
    home.packages = with pkgs; [
        zsh
        lunarvim
        rustup
        rustc
        musl
        llvm
        pkg-config
        openssl
        openssl.dev
        clang
        elfutils

        eza
        xclip
        gnumake
        patchelf
    ];

    # Let Home Manager install and manage itself.
    # programs.home-manager.enable = true;
}
