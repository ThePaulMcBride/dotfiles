{ ... }:
{

  environment.systemPackages = [
  ];

  homebrew = {
    brews = [
      "talosctl"
    ];

    casks = [
      "calibre"
      "steam"
    ];
  };
}
