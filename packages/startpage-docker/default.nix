{ pkgs, lib, inputs, namespace, system, ... }:

pkgs.dockerTools.buildLayeredImage {
  name = "startpage-docker";
  tag = "latest";
  config = {
    Cmd = ["${pkgs.${namespace}.littleweb}/bin/littleweb" "--host" "0.0.0.0" "--path" "${pkgs.${namespace}.website}/"];
    User = "1000:1000";
  };
}
