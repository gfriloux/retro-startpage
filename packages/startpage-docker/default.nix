{ pkgs, lib, inputs, namespace, system, ... }:

pkgs.dockerTools.buildLayeredImage {
  name = "startpage-docker";
  tag = "latest";
  config = {
    Cmd = ["${packages.littleweb}/bin/littleweb" "--host" "0.0.0.0" "--path" "${packages.website}/"];
    User = "1000:1000";
  };
};
