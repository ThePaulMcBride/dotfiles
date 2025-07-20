{ ... }: {
  services = {
    desktopManager.plasma6 = { enable = true; };
    xserver.enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
  programs.hyprland.enable = true;
}
