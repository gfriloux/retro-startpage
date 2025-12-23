
build_systemd:
	nix build .#oci-systemd

build_docker:
	nix build .#oci-docker

install_systemd: build_systemd
	sudo portablectl reattach --profile trusted --enable --now result/retro-startpage_*.raw

install_docker: build_docker
	docker load <result

status:
	sudo systemctl status startpage
