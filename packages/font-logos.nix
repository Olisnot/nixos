{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "font-logos";
  version = "1.2.0";

  src = ../assets/font-logos-1.2.0.zip;

  unpackPhase = ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 font-logos/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
