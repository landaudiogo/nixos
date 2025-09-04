{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ./wireguard.nix
    ./services
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "djokovic"; # Define your hostname.
  networking.networkmanager.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  
  services.printing.enable = true;
  services.logind.lidSwitch = "ignore";
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
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
    wireguard-tools
  ];

  system.stateVersion = "22.11"; # Did you read the comment?

  programs.zsh.enable = true;
  users.users.landaudiogo = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Diogo Landau";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };

  users.users.landaudiogo.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1COVqebDaCGC+bD3A7MgmFYMf5lMrHDUz+MBUn/oej landaudiogo"
  ];
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWjd0HS5ustz5grB4u8vtQcz1aINzESPu1ybrN+u6dy root"
  ];

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
