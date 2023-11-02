{ config, pkgs, ... }:

{
  boot = {
    # Bootloader ================================================================
    loader.grub = { 
      enable = true;
      device = "/dev/sdc";
      useOSProber = false; # Do not detect other operating systems.
      efiSupport = true;
      enableCryptodisk = true;
    };
    # ===========================================================================

    # Encryption ================================================================
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/1da45f3f-30b9-4d7e-8f81-4f4d945040ed";
        preLVM = true;
        allowDiscards = true;
      };
    };
   # ===========================================================================

    ### Temp Files ==============================================================
    tmp.useTmpfs = true;
    tmp.cleanOnBoot = true;
    # ===========================================================================
  };
}
