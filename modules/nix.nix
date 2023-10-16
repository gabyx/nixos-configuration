{ config, pkgs, ... }:

{
  ### Nix Specific Settings ===================================================
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-12.2.3"
      ];
    };
  };
  # ===========================================================================
}
