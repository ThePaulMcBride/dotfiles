{ pkgs, ... }: {
  programs.niri.enable = true;
  programs.waybar.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = { };

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    swaylock
    mako
    swayidle
  ];
}
