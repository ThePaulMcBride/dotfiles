{ stdenv, stdenvNoCC, fetchurl, unzip, gnutar, autoPatchelfHook, makeWrapper
, makeDesktopItem, copyDesktopItems, freetype, SDL2, gtk3, }:
let
  pname = "zelda64recomp";
  version = "1.2.2";

  src = fetchurl {
    url =
      "https://github.com/Zelda64Recomp/Zelda64Recomp/releases/download/v${version}/Zelda64Recompiled-v${version}-Linux-X64.zip";
    hash = "sha256-3osZzbTjrQwQ/W2BJ/emzCqeuhBticdTQ5F4txiIfEI=";
  };

  iconSrc = fetchurl {
    url =
      "https://raw.githubusercontent.com/Zelda64Recomp/Zelda64Recomp/v${version}/icons/512.png";
    hash = "sha256-5cBzDu3v63VD36lba2BVHAd3wH6XxM7y7QQpswDsC30=";
  };

in stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs =
    [ unzip gnutar autoPatchelfHook makeWrapper copyDesktopItems ];

  buildInputs = [ freetype SDL2 gtk3 stdenv.cc.cc.lib ];

  desktopItems = [
    (makeDesktopItem {
      name = "zelda64recomp";
      desktopName = "Zelda 64: Recompiled";
      exec = "zelda64recomp";
      icon = "io.github.zelda64recomp.zelda64recomp";
      terminal = false;
      categories = [ "Game" ];
      startupNotify = true;
    })
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    workdir="$TMPDIR/work"
    mkdir -p "$workdir"
    unzip -q "$src" -d "$workdir"
    tar -xzf "$workdir/Zelda64Recompiled.tar.gz" -C "$workdir"

    install -Dm755 "$workdir/Zelda64Recompiled" "$out/libexec/zelda64recomp/Zelda64Recompiled"
    cp -r "$workdir/assets" "$out/libexec/zelda64recomp/"
    install -Dm644 "$workdir/recompcontrollerdb.txt" "$out/libexec/zelda64recomp/recompcontrollerdb.txt"

    makeWrapper "$out/libexec/zelda64recomp/Zelda64Recompiled" "$out/bin/zelda64recomp" \
      --chdir "$out/libexec/zelda64recomp"

    install -Dm644 "${iconSrc}" \
      "$out/share/icons/hicolor/512x512/apps/io.github.zelda64recomp.zelda64recomp.png"

    runHook postInstall
  '';
}
