{ inputs, lib, pkgs, modulesPath, namespace, ...}:

{
  imports = [
  	"${toString modulesPath}/profiles/qemu-guest.nix"
  ];

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 1024;
      cores = 2;
    };
  };

  boot.loader.grub.enable = false;

  environment.systemPackages = [
  	pkgs.${namespace}.startpage-portable
  ];

  users.users.root = {
  	password = "azerty";
  };

  services.getty.autologinUser = "root";

  system.stateVersion = "25.05";
}
