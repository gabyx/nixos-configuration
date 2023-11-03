{ config, pkgs, ... }:

{
  ### Fonts ================================================================
  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;

    fonts = with pkgs; [
      corefonts
      ubuntu_font_family
  
      # Waybar
      font-awesome
      cantarell-fonts
      noto-fonts
      noto-fonts-emoji

      fira
      meslo-lgs-nf
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ];})
    ];
  };
  # ===========================================================================
}
