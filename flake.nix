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
          version = "1.4.0";
          src = pkgs.fetchFromGitHub {
            owner = "gfriloux";
            repo = "littleweb";
            rev = "v1.4.0";
            sha256 = "sha256-Y2u2z/N73S5kJnsojNjY5OHTncZujyd8pLjcVSX/Cv4=";
          };
          cargoHash = "sha256-B9iAE5ua1I7kIfX9tBnnp2ewAs4j5oD8ttQqeorF5Xo=";
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

        unit = pkgs.writeText "retro-startpage.service" ''
          [Unit]
          After=network.target
          Description=Retro Bookmark Manager
          
          [Service]
          ExecStart=${packages.littleweb}/bin/littleweb --host 127.0.0.1 --path ${packages.website}/
          Type=simple
          DynamicUser=yes

          PrivateTmp=true
          NoNewPrivileges=true
          PrivateDevices=true
          DevicePolicy=closed
          ProtectSystem=strict
          ProtectControlGroups=true
          ProtectKernelModules=true
          ProtectKernelTunables=true
          ProtectProc=invisible
          RestrictNamespaces=true
          RestrictRealtime=true
          RestrictSUIDSGID=true
          MemoryDenyWriteExecute=true
          LockPersonality=true
          ProtectClock=true
          ProtectHostname=true
          ProtectHome=true
          ProtectKernelLogs=true
          ReadOnlyPaths=/
          NoExecPaths=/
          ExecPaths=-${packages.littleweb}/bin/littleweb
          PrivateUsers=true
          
          InaccessiblePaths=-/boot
          InaccessiblePaths=-/lost+found
          InaccessiblePaths=-/etc
          InaccessiblePaths=-/home
          InaccessiblePaths=-/var
          InaccessiblePaths=-/root
          InaccessiblePaths=-/usr
          
          #CapabilityBoundingSet=CAP_NET_BIND_SERVICE
          CapabilityBoundingSet=
          RestrictAddressFamilies=AF_INET AF_INET6
          
          SystemCallFilter=~@clock
          SystemCallFilter=~@cpu-emulation
          SystemCallFilter=~@debug
          SystemCallFilter=~@module
          SystemCallFilter=~@mount
          SystemCallFilter=~@obsolete
          SystemCallFilter=~@privileged
          SystemCallFilter=~@raw-io
          SystemCallFilter=~@reboot
          SystemCallFilter=~@resources
          SystemCallFilter=~@swap
          
          [Install]
          WantedBy=multi-user.target
          '';

        oci-systemd = pkgs.portableService {
          pname = "retro-startpage";
          inherit ( packages.website ) version;
          units = [ packages.unit ];
          contents = with pkgs; [ packages.website ];
          homepage = "https://github.com/gfriloux/retro-startpage";
        };
        oci-systemd-sbom = bombon.lib.${system}.buildBom packages.oci-systemd {
          extraPaths = [ ];
        };
        oci-docker = pkgs.dockerTools.buildLayeredImage {
          name = "retro-startpage";
          tag = "latest";
          contents = with pkgs; [ packages.website ];
          config.Cmd = ["${packages.littleweb}/bin/littleweb" "--host" "0.0.0.0" "--path" "${packages.website}/"];
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
