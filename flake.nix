{
  description = "retro-startpage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bombon.url = "github:nikstur/bombon";
    bombon.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, flake-parts, bombon }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        supportedSystems = [ "x86_64-linux" "aarch64-darwin" "aarch64-linux" "x86_64-darwin" ];
        forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
        pkgs = nixpkgsFor.${system}.pkgsStatic;
      in
      rec {
      devShells.default = with pkgs;
        mkShell {
          name = "Default developpement shell";
          packages = [
            glow
            just
            fzf-make
          ];
          shellHook = ''
            glow README.direnv.md
          '';
        };
      packages = {
        littleweb = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
          pname = "littleweb";
          version = "1.3.0";
          src = pkgs.fetchFromGitHub {
            owner = "gfriloux";
            repo = "littleweb";
            rev = "main";
            sha256 = "sha256-d8RMawyFbYZdnaMmjZupLTibA5POW8HRr1NiXtZfpjo=";
          };
          cargoHash = "sha256-DMAm9amtwhc33l0QqxN4B/H8YaB2m2YeO3b4C2uUHok=";
        });
        website = pkgs.stdenv.mkDerivation rec {
          title = "retro-crt-startpage";
          description = "HTML5-based layout for a personalized retro CRT startpage.";
          name = "retro-crt-startpage";
          version = "1.3.1";
          src = pkgs.fetchzip {
            url = "https://github.com/scar45/retro-crt-startpage/releases/download/v1.3.1/retro-crt-startpage-v1.3.1-release.zip";
            hash = "sha256-UmYyfEy2BVMavAdEqlEYNT5A6dPXuxViAZ18n1fxCfc=";
          };
          nativebuildInputs = [ pkgs.zip ];
          installPhase = ''
            mkdir -p $out
            cp -r css fonts images js *.png *.html *.xml *.txt *.mp3 $out/
            cp ${./links.json} $out/links.json
          '';
        };

        links = pkgs.stdenv.mkDerivation rec {
          title = "links";
          description = "Links file";
          name = "retro-startpage-links";
          version = "1.0.0";
          src = ./.;
          installPhase = ''
            mkdir -p $out
            cp -r links.json $out/
          '';
        };

        unit = pkgs.writeText "retro-startpage.service" ''
          [Unit]
          After=network.target
          Description=Retro Bookmark Manager
          
          [Service]
          ExecStart=${packages.littleweb}/bin/littleweb ${packages.website}/
          Type=simple
          DynamicUser=yes
          
          [Install]
          WantedBy=multi-user.target
          '';

        oci-systemd = pkgs.portableService {
          pname = "retro-startpage";
          inherit ( packages.website ) version;
          units = [ packages.unit ];
          contents = with pkgs; [ packages.website packages.links ];
          homepage = "https://github.com/gfriloux/retro-startpage";
        };
        oci-systemd-sbom = bombon.lib.${system}.buildBom packages.oci-systemd {
          extraPaths = [ ];
        };
        oci-docker = pkgs.dockerTools.buildLayeredImage {
          name = "retro-startpage";
          tag = "latest";
          contents = with pkgs; [ packages.website ];
          config.Cmd = ["${packages.littleweb}/bin/littleweb" "${packages.website}/"];
          uid = 1000;
          gid = 1000;
        };
        oci-docker-sbom = bombon.lib.${system}.buildBom packages.oci-docker {
          extraPaths = [ ];
        };
      };
    }
  );
}
