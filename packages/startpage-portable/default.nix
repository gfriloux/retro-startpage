{ pkgs, lib, inputs, namespace, system, ... }:
let
  pname   = "startpage-portable";
  version = "1.0.0";

  littleweb = pkgs.${namespace}.littleweb;
  website = pkgs.${namespace}.website;

  unit = pkgs.writeText "startpage-portable.service" ''
    [Unit]
    After=network.target
    Description=Retro Bookmark Manager

    [Service]
    ExecStart=${littleweb}/bin/littleweb --host 127.0.0.1 --path ${website}/
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
    #NoExecPaths=/
    #ExecPaths=-${littleweb}/bin/littleweb
    PrivateUsers=true

    InaccessiblePaths=-/etc
    InaccessiblePaths=-/var

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
in
pkgs.portableService {
  inherit pname version;
  units = [ unit ];

  contents = [ littleweb website ];

  homepage = "https://gitlab.datasolution.fr/gfriloux/nix-startpage";
}
