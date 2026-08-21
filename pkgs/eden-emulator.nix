{ stdenvNoCC, fetchurl }:
let
  pname = "eden-emulator";
  version = "nightly-2026-08-16-dc95cd09ee";

  appImageUrl =
    "https://nightly.eden-emu.dev/v1786904188.dc95cd09ee/Eden-Linux-dc95cd09ee-amd64-clang-pgo.AppImage";
  appImageHash = "sha256-DFixtIVSbXto8eEjYDOBdcwyCmateyPXWjjb6svT2WY=";

  iconUrl = "https://eden-emu.dev/assets/logos/logo.png";
  iconHash = "sha256-Z+QpF1AX5UZKqPuBM4U1nzAbrAhr1IBhy4RApW/kLOc=";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = appImageUrl;
    hash = appImageHash;
  };

  iconSrc = fetchurl {
    url = iconUrl;
    hash = iconHash;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/eden-emulator"
    ln -s eden-emulator "$out/bin/eden"

    install -Dm644 "$iconSrc" \
      "$out/share/icons/hicolor/192x192/apps/dev.eden_emu.eden.png"

    install -Dm644 /dev/stdin "$out/share/applications/dev.eden_emu.eden.desktop" <<'EOF'
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=Eden Emulator
    Comment=Nintendo Switch emulator
    Exec=eden-emulator
    TryExec=eden-emulator
    Icon=dev.eden_emu.eden
    Categories=Game;Emulator;
    Terminal=false
    EOF

    runHook postInstall
  '';
}
