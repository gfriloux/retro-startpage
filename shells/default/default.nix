{
  lib,
  inputs,

  namespace,

  pkgs,
  mkShell,
  ...
}:

mkShell {
  packages = with pkgs; [
    glow
    just
    fzf-make
    nix-output-monitor
  ];
  shellHook = ''
    glow README.direnv.md
  '';
}
