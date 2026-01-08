build:
	nix build .#littleweb .#retro-crt-startpage .#startpage .#website .#startpage-portable .#startpage-docker --log-format internal-json -v |& nom --json

vm:
	nix build .#nixosConfigurations.vm.config.system.build.vm
