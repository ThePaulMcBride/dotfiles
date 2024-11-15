{ pkgs, specialArgs, ... }: {

  environment.systemPackages = [
  ];

  homebrew = {
    brews = [
      "nvm"
      "neofetch"
    ];

    casks = [
      "asana"
      "google-chrome"
      "google-cloud-sdk"
    ];
  };
}
