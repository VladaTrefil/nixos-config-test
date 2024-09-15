# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, callPackage, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.loader.systemd-boot.enable = true;

  environment.pathsToLink = ["/libexec"];

  environment.sessionVariables = {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  # networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    ffmpeg
    monitor
    ibus
    ibus-engines.mozc
    git

    zlib

    gnupg
    clang
    gcc
    # gcc-multilib

    # QT Theme
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.lightly
  ];

  users.users.vlada = {
    isNormalUser = true;
    home = "/home/vlada";
    extraGroups = ["wheel" "networkmanager"];
    packages = with pkgs; [
      neovim
      lens
      awscli2
      gh # github cli
      lazygit
      zsh
      oh-my-zsh

      mise

      kdePackages.konsole
      kdePackages.spectacle
      kdePackages.dolphin
      kdePackages.ark
      kdePackages.skanlite

      brave
      qbittorrent-qt5
      yt-dlp

      anki-bin

      thunderbird
      telegram-desktop

      virtualbox
      # virtualboxExtpack

      libreoffice-qt
      krita
      inkscape

      strawberry-qt6
      spotify # replace with spotify-qt
      picard
      vlc
      mpv

      python3

      bat
      bc
      ripgrep
      unzip
      xclip
      ifstat-legacy
      jq
      moreutils
      rename
      speedtest-cli
      playerctl
      brightnessctl
      readline

      haskellPackages.mason

      # python3Full
      # python312Packages.pip
      lua53Packages.lua

      # Sinfin development
      postgresql_12
      libpqxx
      imagemagick
      perl536Packages.ImageExifTool
      rubber
      texlivePackages.xetex
      libsodium
      pdftk
      ghostscript
      redis
      vips
      gifsicle
      libwebp
    ];
  };

  services = {
    syncthing = {
      enable = true;
      user = "vlada";
      dataDir = "/home/vlada/sync";
      configDir = "/home/vlada/.config/syncthing";
    };

    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = true;
      };
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          picom-pijulius
          dmenu
          i3status
          feh
          dunst
          rofi
          eww
        ];
      };
    };

    displayManager = {
      defaultSession = "none+i3";
    };
  };

  services.picom.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  fonts.packages = with pkgs; [
    iosevka
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "breeze";
  };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Rose-Pine";
  #     package = pkgs.rose-pine-gtk-theme;
  #   };
  #   # iconTheme = {
  #   #   name = "TokyoNight-SE";
  #   #   package = tokyo-night-icons;
  #   # };
  # };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      la = "ls -la --group-directories-first --color=always";
      ".." = "cd ..";
      python = "python3";
      python2 = "python3";
    };
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "vi-mode"
      ];
      theme = "robbyrussell";
    };
  };


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";


  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

