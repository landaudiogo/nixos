{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ./wireguard.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    "insecure-registries" = ["federer.ad.dlandau.nl:30002"];
  };

  networking.search = [ "ad.dlandau.nl" ];
  networking.hostName = "workstation"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

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
    openFirewall = false;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
      comment = "workstation";
    }];
  };
  programs.ssh = {
    extraConfig = ''
        Host root-federer
          Port 22
          IdentitiesOnly yes
          User root
          HostName 10.0.0.1
          IdentityFile ${config.age.secrets.root-ed25519.path}
        Host root-djokovic
          Port 22
          IdentitiesOnly yes
          User root
          HostName 10.0.0.5
          IdentityFile ${config.age.secrets.root-ed25519.path}
        Host root-sinner
          Port 22
          IdentitiesOnly yes
          User root
          HostName 10.0.0.2
          IdentityFile ${config.age.secrets.root-ed25519.path}
        Host root-nadal
          Port 22
          IdentitiesOnly yes
          User root
          HostName 192.168.2.53
          IdentityFile ${config.age.secrets.root-ed25519.path}
        Host k8s-master
          Port 22
          IdentitiesOnly yes
          User root
          HostName 192.168.2.22
          IdentityFile ${config.age.secrets.root-ed25519.path}
        Host k8s-worker1
          Port 22
          IdentitiesOnly yes
          User root
          HostName 192.168.2.23
          IdentityFile ${config.age.secrets.root-ed25519.path}
        Host k8s-worker2
          Port 22
          IdentitiesOnly yes
          User root
          HostName 192.168.2.36
          IdentityFile ${config.age.secrets.root-ed25519.path}
        Host k8s-worker3
          Port 22
          IdentitiesOnly yes
          User root
          HostName 192.168.2.35
          IdentityFile ${config.age.secrets.root-ed25519.path}
    '';
  };

    # printing
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."landaudiogo".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1COVqebDaCGC+bD3A7MgmFYMf5lMrHDUz+MBUn/oej landaudiogo"
  ];
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

  programs.zsh.enable = true;

  # temporary
  programs.nix-ld.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?

  age.secrets.root-ed25519 = {
    file = ../../secrets/root-ed25519.age;
    path = "/etc/root/.ssh/id_ed25519";
    owner = "landaudiogo";
  };
  environment.etc = {
    "root/.ssh/id_ed25519.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWjd0HS5ustz5grB4u8vtQcz1aINzESPu1ybrN+u6dy root";
  };

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
            inputs.agenix.homeManagerModules.default
            ../../home-manager
            ./home-manager
        ];

        home.username = "landaudiogo";
        home.homeDirectory = "/home/landaudiogo";
        home.stateVersion = "25.05";
        home.file.".ssh/id_ed25519.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1COVqebDaCGC+bD3A7MgmFYMf5lMrHDUz+MBUn/oej landaudiogo";

        role.dev.enable = true;
    };
}
