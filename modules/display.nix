{ config, pkgs, ... }:

{
  ### Color Shifting ==========================================================
  services.redshift = {
    enable = true;

    temperature = {
      day = 5700;
      night = 4600;
    };
  };
  # ==========================================================================
}
