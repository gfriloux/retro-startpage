# retro-startpage

This project is a little demo to create a [portable service](https://systemd.io/PORTABLE_SERVICES/)
service of the wonderful [retro startpage](https://github.com/scar45/retro-crt-startpage).

## Building

### Portable service

```
nix build .#oci-systemd
```

You should now have the image into the `result/` dir:
```
.r--r--r-- root root   4.9 MB Thu Jan  1 01:00:01 1970  retro-startpage_1.3.1.raw
```

You can now install it:
```
sudo portablectl reattach --profile trusted --enable --now result/retro-startpage_*.raw
```

### Docker

```
nix build .#oci-docker
docker load <result
```

You should now have the image:
```
IMAGE                    ID             DISK USAGE   CONTENT SIZE   EXTRA
retro-startpage:latest   b18b4631ad9e       12.7MB             0B    U
```
