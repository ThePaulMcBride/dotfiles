{ pkgs, ... }: {
  services = {
    # Ensure gnome-settings-daemon udev rules are enabled.
    udev.packages = with pkgs; [ gnome-settings-daemon ];
    xserver.enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [ pkgs.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
      '';
    };
  };
}
