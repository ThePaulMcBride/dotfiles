{ stdenvNoCC, fetchurl }:
let
  pname = "eden-emulator";
  version = "0.2.0";

  appImageUrl =
    "https://stable.eden-emu.dev/v${version}/Eden-Linux-v${version}-amd64-clang-pgo.AppImage";
  appImageHash = "sha256-aMi1rOl3KwAWpzx3CJlouEcI2s4GrlyaRy4h+rAwRl8=";
in stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = appImageUrl;
    hash = appImageHash;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/eden-emulator"
    ln -s eden-emulator "$out/bin/eden"

    runHook postInstall
  '';
}
