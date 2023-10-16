{ config, pkgs, ... }:

{
  ### User Settings ==========================================================
  users = {
    users.nixos = {
      shell = pkgs.zsh;
      useDefaultShell = false;

      isNormalUser = true;

      extraGroups = [ 
        "wheel" 
        "disk" 
        "libvirtd" 
        "docker" 
        "audio" 
        "video" 
        "input" 
        "systemd-journal" 
        "networkmanager" 
        "network" 
        "davfs2" ];
    };
  };
  # ===========================================================================
}
