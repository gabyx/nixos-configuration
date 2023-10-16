{ config, pkgs, ... }:

{
  ### Program Settings ========================================================
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    zsh.enable = true;
    
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    git = {
      enable = true;
      package = pkgs.gitFull;
      ## TODO: Install GCM Core
      config.credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };

    seahorse.enable = true;
  };
  # ===========================================================================
}

