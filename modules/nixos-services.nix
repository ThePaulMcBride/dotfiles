{ pkgs, ... }: {
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };

    udev.packages = with pkgs; [ game-devices-udev-rules ];
    udev.extraRules = ''
      KERNEL=="uhid", MODE="0660", TAG+="uaccess", GROUP="uinput"
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
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      applications = {
        apps = [
          {
            name = "Desktop";
            "image-path" = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            "image-path" = "steam.png";
            detached = [
              "env -u XDG_ACTIVATION_TOKEN -u DESKTOP_STARTUP_ID setsid steam steam://open/bigpicture"
            ];
            "prep-cmd" = [
              {
                undo = "env -u XDG_ACTIVATION_TOKEN -u DESKTOP_STARTUP_ID setsid steam steam://close/bigpicture";
              }
            ];
          }
          {
            name = "Sleep";
            "image-path" = "desktop.png";
            detached = [ "systemctl suspend" ];
          }
          {
            name = "Reboot";
            "image-path" = "desktop.png";
            detached = [ "systemctl reboot" ];
          }
          {
            name = "Shutdown";
            "image-path" = "desktop.png";
            detached = [ "systemctl poweroff" ];
          }
        ];
      };
    };
  };

  hardware.uinput.enable = true;

  security.rtkit.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
}
