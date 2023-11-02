{ config, pkgs, ... }:

{
  boot = {
    # Bootloader ================================================================
    loader.grub = { 
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      enableCryptodisk = true;
    };
    # ===========================================================================

    # Encryption ================================================================
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
    initrd.luks.devices."luks-b71db585-62d5-4ab7-ac2b-f3a3495561ab".keyFile = "/crypto_keyfile.bin";
    # ===========================================================================

    ### Temp Files ==============================================================
    tmp.useTmpfs = true;
    tmp.cleanOnBoot = true;
    # ===========================================================================
  };
}
