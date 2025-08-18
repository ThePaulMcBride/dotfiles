{ pkgs, ... }: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModprobeConfig = "options bluetooth disable_ertm=1 ";

  hardware = {
    enableAllFirmware = true;
    graphics = { enable = true; };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Name = "Argon";
          ControllerMode = "dual";
          FastConnectable = "true";
          Experimental = "true";
        };
        Policy = { AutoEnable = "true"; };
      };
    };
    xpadneo.enable = true;
    steam-hardware.enable = true;
    uinput.enable = true;
  };
}
