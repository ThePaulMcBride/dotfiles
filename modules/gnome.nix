{ pkgs, ... }: {
  services = {
    # Ensure gnome-settings-daemon udev rules are enabled.
    udev.packages = with pkgs; [ gnome-settings-daemon ];
    xserver.enable = true;
    displayManager = {
      gdm = {
        enable = true;
      };
    };
    desktopManager.gnome.enable = true;
  };
  programs.hyprland.enable = true;
}
