{ ... }: {
  services.syncthing = {
    enable = true;
    user = "paul";
    group = "users";
    dataDir = "/home/paul";
    configDir = "/home/paul/.config/syncthing";
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}

