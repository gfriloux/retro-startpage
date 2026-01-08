{ lib, pkgs, ... }:

pkgs.stdenv.mkDerivation {
  title = "retro-crt-startpage";
  description = "HTML5-based layout for a personalized retro CRT startpage.";
  name = "retro-crt-startpage";
  version = "1.3.1";
  src = pkgs.fetchzip {
    url = "https://github.com/scar45/retro-crt-startpage/releases/download/v1.3.1/retro-crt-startpage-v1.3.1-release.zip";
    hash = "sha256-UmYyfEy2BVMavAdEqlEYNT5A6dPXuxViAZ18n1fxCfc=";
    stripRoot = false;
  };
  nativebuildInputs = [ pkgs.zip ];
  installPhase = ''
    mkdir -p $out
    rm -fr images/icons
    cp -r css fonts images js *.png *.html *.xml *.txt *.mp3 $out/
    mkdir -p $out/images/icons
  '';
}
