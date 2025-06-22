{ pkgs, ... }: {
  services = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [ pkgs.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
      '';
    };
    printing.enable = true;
    udev.packages = with pkgs; [ game-devices-udev-rules ];
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
      # media-session.enable = true;
    };
    pulseaudio.enable = false;
  };

  security.rtkit.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
}
