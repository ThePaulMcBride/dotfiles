{ lib, pkgs, ... }: {
  services = {
    desktopManager.plasma6 = { enable = true; };
    xserver.enable = true;
  };

  programs.ssh.askPassword =
    lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  programs.hyprland.enable = true;
}
