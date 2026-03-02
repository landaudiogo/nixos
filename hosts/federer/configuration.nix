# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ./wireguard.nix
    ./services
    ./k8s-master.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "federer"; # Define your hostname.
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.logind.lidSwitch = "ignore";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.printing.enable = true;
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
    openFirewall = false;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
      comment = "federer";
    }];
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
  users.users.landaudiogo = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Diogo Landau";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };

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

  users.users."landaudiogo".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1COVqebDaCGC+bD3A7MgmFYMf5lMrHDUz+MBUn/oej landaudiogo"
  ];
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWjd0HS5ustz5grB4u8vtQcz1aINzESPu1ybrN+u6dy root"
  ];

  system.stateVersion = "22.11"; # Did you read the comment?

  age.secrets.landaudiogo-ed25519 = {
    file = ../../secrets/landaudiogo-ed25519.age;
    path = "/home/landaudiogo/.ssh/id_ed25519";
    owner = "landaudiogo";
  };
  
  home-manager.extraSpecialArgs = { inherit inputs; };
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
        home.file.".ssh/id_ed25519.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1COVqebDaCGC+bD3A7MgmFYMf5lMrHDUz+MBUn/oej landaudiogo";

        role.dev.enable = true;
    };
}
