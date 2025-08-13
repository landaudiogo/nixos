{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  
  services.printing.enable = true;
  services.logind.lidSwitch = "ignore";
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.openssh = {
    enable = true;
    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
      comment = "djokovic";
    }];
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    ntfs3g
    home-manager
    unzip
    file
    bash
    wireshark
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
  
  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
  ];

  users.users.landaudiogo = {
    isNormalUser = true;
    description = "Diogo Landau";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.landaudiogo = 
    { pkgs, ... }:
    {
        imports = [ 
            ../../home-manager
        ];

        home.username = "landaudiogo";
        home.homeDirectory = "/home/landaudiogo";
        home.stateVersion = "25.05";

        role.dev.enable = true;
    };
}
