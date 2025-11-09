{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
  };

  users.users.paul.extraGroups = [ "docker" ];
}

