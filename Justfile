build:
	nix build .#littleweb .#retro-crt-startpage .#startpage .#website .#startpage-portable --log-format internal-json -v |& nom --json

status:
	sudo systemctl status startpage
