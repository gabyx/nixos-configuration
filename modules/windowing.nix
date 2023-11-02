
{ config, pkgs, ... }: {

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  
  # Display Manager
  services.xserver.displayManager = { 
    sddm.enable = false;
    gdm = { enable = true; wayland = true; };
    autoLogin.enable = true;
    autoLogin.user = "nixos";
  };

  # Desktop Manager
  # They interfere with the Window Manager.
  services.xserver.desktopManager.xfce.enable = true;

  # Hyprland Window Manager ===================================================
  programs.hyprland.enable = true;

  # Useful packages.
  environment.systemPackages = with pkgs; [
    hyprland
    
    (
      waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )

    dunst # Notification daemon (needs libnotify).
    libnotify

    swww # Wallpaper daemon for wayland. 

    rofi-wayland # Window switcher.

    grim # Screenshot in Wayland.
    slurp # Wayland region selector.
    playerctl # Player control in waybar.
  ];
  
  # Handle desktop interaction.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs. xdg-desktop-portal-hyprland ];
  };
  # ===========================================================================
  
  # Sway Window Manager
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true; # so that gtk works properly
  #
  #   extraPackages = with pkgs; [
  #     swaylock
  #     swayidle
  #     wl-clipboard
  #     wf-recorder
  #     mako # Notification Daemon.
  #     grim # Screenshot in Wayland.
  #     slurp # Wayland region selector.
  #     rofi # Application Launcher for waybar.
  #     playerctl # Player control in waybar.
  #   ];
  #
  #   extraSessionCommands = ''
  #     export SDL_VIDEODRIVER=wayland
  #     export QT_QPA_PLATFORM=wayland
  #     export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  #     export _JAVA_AWT_WM_NONREPARENTING=1
  #     export MOZ_ENABLE_WAYLAND=1
  #   '';
  # };
  #

  security.polkit.enable = true; # https://discourse.nixos.org/t/sway-does-not-start/22354/5

  programs.waybar.enable = true;

  fonts.fonts= with pkgs; [
    noto-fonts
    font-awesome
  ];

}
