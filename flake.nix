{
  description = "retro startpage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall = {
        namespace = "startpage";
        meta = {
          name = "startpage";
          title = "Portable startpage";
        };
      };
      alias = {
        packages.default = "startpage-portable";
      };
      checks = {
      	retro-startpage-vm = ./checks/vm/default.nix;
      };
    };
}
