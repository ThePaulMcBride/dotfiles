{ stdenvNoCC, fetchurl }:
let
  pname = "eden-emulator";
  version = "0.2.1";

  appImageUrl =
    "https://stable.eden-emu.dev/v${version}/Eden-Linux-v${version}-amd64-clang-pgo.AppImage";
  appImageHash = "sha256-eii/mIsGSIMZiXIr26qQqzE3G0A4CBmYE+DqfIslum0=";

  iconUrl = "https://eden-emu.dev/icon-192.png";
  iconHash = "sha256-tUVGIEFcRPDJ9QuDWJF+RB0NWNxy+/TF1tmrz6z+QQ4=";
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
