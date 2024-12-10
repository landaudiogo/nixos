# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager = {
    gnome = {
      enable = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.landaudiogo = {
    isNormalUser = true;
    description = "Diogo Landau";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
      lunarvim
      google-chrome
      tmux
      alacritty
      zsh
      eza
      rustc
      cargo
      rustfmt
      rust-analyzer
      clang
      clippy
      xclip
      gnumake
      texliveFull
      unzip
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    ntfs3g
    home-manager
  ];
  services.xserver.dpi = 180;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "2";
  };

  programs.git.config = {
    user.email = "diogo.hewitt.landau@hotmail.com";
    user.name = "landaudiogo";
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [tmuxPlugins.yank];
    extraConfig = ''
# Set prefix to space.
unbind C-b
set -g prefix C-Space

set-option -g default-shell ${pkgs.zsh}/bin/zsh

# tmux copy mode vim bindings
setw -g mode-keys vi

# Bindings:
# - to see current bindings:
#   list-keys -t {vi,emacs}-{edit,choice,copy}

# Open new/split panes with the path of the current pane.
unbind c
bind c new-window -c '#{pane_current_path}'
unbind %
bind % split-window -h -c '#{pane_current_path}'
unbind '"'
bind '"' split-window -v -c '#{pane_current_path}'

# Vim-like key bindings for pane navigation (default uses cursor keys).
unbind h
bind h select-pane -L
unbind j
bind j select-pane -D
unbind k
bind k select-pane -U
unbind l # normally used for last-window
bind l select-pane -R

# Resizing (mouse also works).
unbind Left
bind -r Left resize-pane -L 5
unbind Right
bind -r Right resize-pane -R 5
unbind Down
bind -r Down resize-pane -D 5
unbind Up
bind -r Up resize-pane -U 5

# Move tmux windows
bind-key -n C-M-h "swap-window -t -1; previous-window"
bind-key -n C-M-l "swap-window -t +1; next-window"

# Fast toggle (normally prefix-l).
bind ^space last-window

# Intuitive window-splitting keys.
bind | split-window -h -c '#{pane_current_path}' # normally prefix-%
# bind \ split-window -h -c '#{pane_current_path}' # normally prefix-%
bind - split-window -v -c '#{pane_current_path}' # normally prefix-"

# Status bar.
set -g status-bg '#343d46'
set -g status-fg white
set -g status-left-length 40
set -g status-left '#[fg=yellow]#S ⧉ '
set -g status-right "#[fg=yellow]$USER@#h #[fg=magenta]%l:%M %p"
set -g status-interval 60 # Default is 15.

# Automatically renumber window numbers on closing a pane (tmux >= 1.7).
set -g renumber-windows on

# Highlight active window.
# set -w -g window-status-current-bg red

# Mouse can be used to select panes, select windows (by clicking on the status
# bar), resize panes. For default bindings see `tmux list-keys` and `tmux
# list-keys -t vi-copy`.
set -g mouse on

# Restore pre-2.1 behavior of scrolling with the scrollwheel in Vim, less, copy
# mode etc, otherwise entering copy mode if not already in it.
#
#   if in copy mode (pane_in_mode) || using the mouse already (mouse_any_flag)
#     pass through mouse events to current pane (send -Mt=)
#   elsif in alternate screen mode
#     send `Up` key
#   else
#     enter copy mode (-e exits if we scroll to the bottom)
#   end
#
bind-key -T root WheelUpPane \
  if-shell -Ft= '#{?pane_in_mode,1,#{mouse_any_flag}}' \
    'send -Mt=' \
    'if-shell -Ft= "#{alternate_on}" "send -t= Up" "copy-mode -et="'
bind-key -T root WheelDownPane \
  if-shell -Ft = '#{?pane_in_mode,1,#{mouse_any_flag}}' \
    'send -Mt=' \
    'if-shell -Ft= "#{alternate_on}"  "send -t= Down" "send -Mt="'

# Slightly more useful width in "main-vertical" layout; enough room for 3-digit
# line number gutter in Vim + 80 columns of text + 1 column breathing room
# (default looks to be about 79).
set -w -g main-pane-width 85

set -g default-terminal "tmux-256color"
set -ga terminal-overrides ',xterm-256color:Tc'

set -g history-limit 10000

# Start window and pane numbering at 1, (0 is too hard to reach).
set -g base-index 1
set -g pane-base-index 1

# Don't wait for an escape sequence after seeing C-a.
set -s escape-time 0

# Dynamically update iTerm tab and window titles.
set -g set-titles on

# Needed as on tmux 1.9 and up (defaults to off).
# Added in tmux commit c7a121cfc0137c907b7bfb.
set -g focus-events on

# But don't change tmux's own window titles.
set -w -g automatic-rename off

# Don't wrap searches; it's super confusing given tmux's reverse-ordering of
# position info in copy mode.
set -w -g wrap-search off

# #T      = standard window title (last command, see ~/.bash_profile)
# #h      = short hostname
# #S      = session name
# #W      = tmux window name
#
# (Would love to include #(pwd) here as well, but that would only print the
# current working directory relative to the session -- ie. always the starting
# cwd -- which is not very interesting).
set -g set-titles-string "#T : #h > #S > #W"

# Show bells in window titles.
# set -g window-status-bell-style fg=yellow,bold,underscore

# Clipper.
bind-key y run-shell "tmux save-buffer - | xclip -selection clipboard"

# Load plugins
${lib.concatStrings (map (x: "run-shell ${x.rtp}\n") [pkgs.tmuxPlugins.yank])}
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira-code
  ];
  home-manager.users.landaudiogo = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

}
