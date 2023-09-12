# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];

  # Allow proprietary software (such as the NVIDIA drivers).
  nixpkgs.config.allowUnfree = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "US/Eastern";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.autorun = true;

  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.plasma5.enable = true;
  # Window Managers
  #services.xserver.windowManager.stumpwm.enable = true;
  #services.xserver.windowManager.ratpoison.enable = true;
  #services.xserver.windowManager.exwm.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      mako # notification daemon
      grim
     #kanshi
      slurp
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  programs.waybar.enable = true;

  # QT
  programs.qt5ct.enable = true;


  # Graphics settings
  #services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.videoDrivers = [ "nouveau" ];

  hardware.opengl.driSupport32Bit = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kevin = {
    isNormalUser = true;
    # Add libvirtd if using virt-manager
    extraGroups = [ "wheel" "disk" "libvirtd" "docker" "audio" "video" "input" "systemd-journal" "networkmanager" "network" "davfs2" ];
  };
  users.extraGroups.vboxusers.members = [ "kevin" ];
  # For VR (Simula)
  nix.trustedUsers = [ "root" "kevin"];

  # Fonts
  fonts.fonts = with pkgs; [
    fira-code
    fira
    cooper-hewitt
    ibm-plex
    jetbrains-mono
    iosevka
    # bitmap
    spleen
    fira-code-symbols
    powerline-fonts
    nerdfonts
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # editors
    # emacs
    emacsPgtkGcc
    mg
    neovim-nightly
    jetbrains.rider
    jetbrains.datagrip
    jetbrains.idea-ultimate
    # development
    dbeaver
    postman
    postgresql
    # tools
    gparted
    kdiff3
    remmina
    wezterm
    unclutter
    picom
    nitrogen
    dmenu
    rofi
    tmux
    dunst
    pcmanfm
    filezilla
    libreoffice
    zoom-us
    vlc
    etcher
    # art
    krita
    # wacom
    xf86_input_wacom
    wacomtablet
    libwacom
    # gaming/vr
    openhmd
    # virtualisation
    spice
    docker-compose
    virt-manager
    gnome3.dconf # needed for saving settings in virt-manager
    libguestfs # needed to virt-sparsify qcow2 files
    libvirt
    # virtualbox
    #gnome.gnome-boxes
    # docker
    # dockertools
    # cli
    coreutils
    binutils
    pciutils
    dmidecode
    autoconf
    gcc
    gnumake
    llvm
    libclang
    clang
    cmake
    linuxPackages.nvidia_x11
    libGLU libGL
    xorg.libXi xorg.libXmu freeglut
    xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
    libtool
    libvterm
    ncurses5
    stdenv.cc
    wget
    curl
    gitAndTools.gitFull
    gitAndTools.grv
    git-lfs
    man
    mkpasswd
    unzip
    direnv
    lshw
    pandoc
    mlocate
    fzf
    file
    scrot
    image_optim
    ffmpeg
    killall
    xclip
    fd
    ripgrep
    ripgrep-all
    silver-searcher
    screenfetch
    redshift
    appimage-run
    transmission
    transmission-gtk
    stumpish
    openvpn
    # protonmail
    protonvpn-gui
    protonvpn-cli
    protonmail-bridge
    # programming
    ccls
    gcc
    gdb
    rustup
    openjdk
    nodejs
    python3Full
    php
    php74Packages.composer
    mono
    msbuild
    dotnet-sdk_5
    omnisharp-roslyn
    gradle
    jdk
    # webdav
    davfs2
    autofs5
    fuse
    sshfs
    cadaver
    # node packages
    nodePackages.typescript-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vls
    nodePackages.gulp-cli
    nodePackages.tern
    # unity
    unity3d
    unityhub
    # dictionary
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    hunspell
    hunspellDicts.en-us
    # latex
    texlive.combined.scheme-full
    # browsers
    firefox
    chromium
    # media
    spotify
    # gtk
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
    # nix
    nixpkgs-lint
    nixpkgs-fmt
    nixfmt
    # emacs
    (emacsWithPackagesFromUsePackage {
      config = /home/kevin/.emacs.el;

      alwaysEnsure = true;
      alwaysTangle = true;

      # Optionally provide extra packages not in the configuration file.
      # extraEmacsPackages = epkgs: [
      #   epkgs.vterm
      # ];

      # Optionally override derivations.
      # override = epkgs: epkgs // {
      #   weechat = epkgs.melpaPackages.weechat.overrideAttrs(old: {
      #     patches = [ ./weechat-el.patch ];
      #   });
      # };
    })
  ];

  # Emacs
  services.emacs.enable = true;
  services.emacs.package = pkgs.emacsPgtkGcc;
  # services.emacs.package = import /home/kevin/.emacs.d { pkgs = pkgs; };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
    (self: super: {
     neovim = super.neovim.override {
       viAlias = true;
       vimAlias = true;
     };
   })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Virtmanager settings
  programs.dconf.enable = true;
  services.qemuGuest.enable = true;
  #boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.kernelModules = [ "kvm-intel" ];

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  # Docker
  virtualisation.docker.enable = true;
  #virtualisation.docker.enableOnBoot = true;

  # Mount extra drive
   fileSystems."/mnt/sdb1" = {
   device = "/dev/sdb1";
   fsType = "auto";
   options = [ "defaults" "user" "rw" "utf8" "noauto" "umask=000" ];
   };

   # Steam
   programs.steam.enable = true;

  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # services.xrdp.enable = true;
  # services.xrdp.defaultWindowManager = "startplasma-x11";
  # networking.firewall.allowedTCPPorts = [ 3389 ];
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
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "21.05";

}
