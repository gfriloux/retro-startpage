{ lib, pkgs, namespace, ... }:

let
  retro-crt-startpage = pkgs.${namespace}.retro-crt-startpage;
  startpage = pkgs.${namespace}.startpage;
in
pkgs.symlinkJoin {
  name = "website";
  paths = [ startpage retro-crt-startpage ];
}
