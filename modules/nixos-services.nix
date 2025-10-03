{ pkgs, ... }: {
  services = {
    udev.packages = with pkgs; [ game-devices-udev-rules ];
    udev.extraRules = ''
      # 2.4GHz/Dongle
      KERNEL=="hidraw*", ATTRS{idProduct}=="6012", ATTRS{idVendor}=="2dc8", MODE="0660", TAG+="uaccess", GROUP="input"
      # Bluetooth
      KERNEL=="hidraw*", KERNELS=="*2DC8:6012*", MODE="0660", TAG+="uaccess", GROUP="input"
    '';
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
