{ stdenvNoCC
, fetchurl
, pkgs
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:
let
  pname = "lichii";
  version = "build-386";

  src = fetchurl {
    url = "https://github.com/zortos293/Lichii/releases/download/${version}/lichii-linux-x86_64-pgo.AppImage";
    hash = "sha256-C2jINT1P4nutvix0G0RpxnXrkTd28knvx00cik2yAiI=";
  };

  appimage-run = pkgs.appimage-run.override {
    extraPkgs = pkgs: [ pkgs.libgpg-error ];
  };

  iconSrc = fetchurl {
    url = "https://raw.githubusercontent.com/zortos293/Lichii/build-386/dist/branding/lichii_icon.png";
    hash = "sha256-Sh+2AvybzCWZpU0yRzlpZ0J7Fls2rN5XEcLC+3smorg=";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Lichii";
      comment = "Experimental Nintendo Switch and Switch 2 emulator";
      exec = "lichii";
      icon = "lichii";
      terminal = false;
      categories = [ "Game" "Emulator" ];
    })
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/libexec/lichii.AppImage"
    makeWrapper "${appimage-run}/bin/appimage-run" "$out/bin/lichii" \
      --add-flags "$out/libexec/lichii.AppImage"
    install -Dm644 "${iconSrc}" \
      "$out/share/icons/hicolor/512x512/apps/lichii.png"

    runHook postInstall
  '';
}
