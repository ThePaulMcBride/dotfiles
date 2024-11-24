{ pkgs, specialArgs, ... }: {

  environment.systemPackages = with pkgs; [
  ];

  homebrew = {
    brews = [
      "nvm"
      "rbenv"
      "ruby-build"
    ];

    casks = [
      "asana"
      "google-chrome"
      "google-cloud-sdk"
      "loom"
    ];
  };
}
