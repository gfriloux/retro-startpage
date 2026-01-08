{ lib, pkgs, ... }:

pkgs.pkgsStatic.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "littleweb";
  version = "1.4.0";
  src = pkgs.fetchFromGitHub {
    owner = "gfriloux";
    repo = "littleweb";
    rev = "v1.4.0";
    sha256 = "sha256-Y2u2z/N73S5kJnsojNjY5OHTncZujyd8pLjcVSX/Cv4=";
  };
  cargoHash = "sha256-B9iAE5ua1I7kIfX9tBnnp2ewAs4j5oD8ttQqeorF5Xo=";
})
