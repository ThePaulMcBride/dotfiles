{ pkgs, specialArgs, ... }: {

  environment.systemPackages = [
  ];

  homebrew = {
    brews = [
      "nvm"
      "neofetch"
    ];

    casks = [
      "google-chrome"
      "google-cloud-sdk"
    ];
  };
}
