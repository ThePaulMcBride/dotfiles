{ stdenvNoCC, fetchurl, dpkg, }:
let
  pname = "eden-emulator";
  version = "0.2.0-rc2";

  appImageUrl =
    "https://stable.eden-emu.dev/v${version}/Eden-Linux-v${version}-amd64-clang-pgo.AppImage";
  appImageHash = "sha256-/4qSE97tO9klkmliAJzR4UnnYPrdSqmzrwItFoQaiAU=";

  debUrl =
    "https://stable.eden-emu.dev/v${version}/Eden-Debian-13-v${version}-amd64.deb";
  debHash = "sha256-9qqe1qaRNhaYwlMqaE3KaQXUH7/TJJoxtEHB8fVeEwg=";
in stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = appImageUrl;
    hash = appImageHash;
  };

  debSrc = fetchurl {
    url = debUrl;
    hash = debHash;
  };

  dontUnpack = true;

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/eden-emulator"
    ln -s eden-emulator "$out/bin/eden"

    debRoot="$TMPDIR/eden-deb"
    mkdir -p "$debRoot"
    dpkg-deb -x "$debSrc" "$debRoot"

    install -Dm644 \
      "$debRoot/usr/share/icons/hicolor/scalable/apps/dev.eden_emu.eden.svg" \
      "$out/share/icons/hicolor/scalable/apps/dev.eden_emu.eden.svg"

    install -Dm644 \
      "$debRoot/usr/share/applications/dev.eden_emu.eden.desktop" \
      "$out/share/applications/dev.eden_emu.eden.desktop"

    substituteInPlace "$out/share/applications/dev.eden_emu.eden.desktop" \
      --replace-fail "Exec=eden" "Exec=eden-emulator" \
      --replace-fail "TryExec=eden" "TryExec=eden-emulator"

    substituteInPlace "$out/share/applications/dev.eden_emu.eden.desktop" \
      --replace "TryExec=eden-emulator-emulator" "TryExec=eden-emulator"

    runHook postInstall
  '';
}
