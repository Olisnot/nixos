{
  lib,
  stdenvNoCC,
  fetchgit,
}:

stdenvNoCC.mkDerivation rec {
  pname = "yet-another-monochrome-icon-set";
  version = "unstable-2026-01-28";

  src = fetchgit {
    url = "https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set.git";
    rev = "05p4058j06hfp8scvmy1xlspr0b5x3fil5bvfz6rgf9vai3d86ac";
    hash = "sha256-TBnURlQ7uZfNd3sVGt3oZYF8Ne3B1800ug4aIFEB5BY=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    themeRoot="$(dirname "$(find . -name index.theme -print -quit)")"
    if [ -z "$themeRoot" ] || [ ! -f "$themeRoot/index.theme" ]; then
      echo "ERROR: Couldn't find index.theme in source tree."
      exit 1
    fi

    outDir="$out/share/icons/${pname}"
    mkdir -p "$outDir"
    cp -r "$themeRoot"/* "$outDir/"
    test -f "$outDir/index.theme"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet Another Monochrome Icon Set (icon theme)";
    homepage = "https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set/src/main/";
    platforms = platforms.all;
  };
}
