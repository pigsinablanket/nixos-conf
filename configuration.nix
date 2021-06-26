{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  users.extraUsers.pigs = {
    isNormalUser = true;
    home = "/home/pigs";
    extraGroups = [ "wheel" "audio" "docker" ];
    shell = pkgs.fish;
  };
  security.sudo.enable = true;

  networking.hostName = "pigs-laptop"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
    displayManager = {
      defaultSession = "none+xmonad";
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  nixpkgs.config.allowUnfree = true; # for zoom :(

  # for emacs 28
  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  ];
  services.emacs.package = pkgs.emacsUnstable;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Utilities
    wget
    pkgs.emacsGcc
    mosh
    fish
    git
    gnumake
    ag
    rlwrap
    htop
    ripgrep # doom-emacs dependency
    coreutils
    fd

    # Muse
    git-crypt
    direnv

    # Languages
    ocaml
    python39
    python39Packages.pip
    python39Packages.setuptools
    gcc

    # UI
    firefox
    lxterminal
    zoom-us
    pavucontrol
    arandr
    flameshot
    googleearth

    # XMonad
    haskellPackages.xmobar
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    dmenu
    xscreensaver
    xorg.xf86inputsynaptics
  ];

  # List services that you want to enable:

  services.openssh.enable = true;
  services.xserver.libinput.enable = true;
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Inconsolata" ]; })
  ];

}
