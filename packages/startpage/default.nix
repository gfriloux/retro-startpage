{ lib, pkgs, ... }:

pkgs.stdenv.mkDerivation {
  title = "startpage";
  description = "Our bookmarks";
  name = "startpage";
  version = "1.0.0";
  src = ./.;
  nativebuildInputs = [ pkgs.zip ];
  installPhase = ''
    mkdir -p $out/images
    cp     ${../../src/links.json} $out/links.json
    cp -fr ${../../src/icons}      $out/images/icons/
  '';
}
