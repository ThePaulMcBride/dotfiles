{ pkgs, specialArgs, ... }: {

  environment.systemPackages = [
  ];

  homebrew = {
    brews = [
    ];

    casks = [
      "steam"
    ];
  };
}
