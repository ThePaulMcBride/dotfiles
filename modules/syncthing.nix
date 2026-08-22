{ user, ... }: {
  services.syncthing = {
    enable = true;
    user = user.name;
    group = "users";
    dataDir = user.homeDirectory;
    configDir = "${user.homeDirectory}/.config/syncthing";
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
