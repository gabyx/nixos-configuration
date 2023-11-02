{ config, pkgs, ... }:

{
  ### Nix Specific Settings ===================================================
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    extraOptions = ''
    experimental-features = nix-command flakes
    use-xdg-base-directories = true
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-19.1.9"
      ];
    };
  };
  # ===========================================================================
}
