# retro-startpage

This project is a little demo to create a [portable service](https://systemd.io/PORTABLE_SERVICES/)
service of the wonderful [retro startpage](https://github.com/scar45/retro-crt-startpage).

## Building

### Portable service

```
nix build .#startpage-portable
```

You should now have the image into the `result/` dir:
```
.r--r--r-- root root   4.9 MB Thu Jan  1 01:00:01 1970  startpage-portable_1.0.0.raw
```

You can now install it:
```
sudo portablectl attach --profile trusted --enable --now result/startpage-portable_*.raw
```
or
```
sudo portablectl reattach --profile trusted --enable --now result/startpage-portable_*.raw
```

### Docker

```
nix build .#startpage-docker
docker load <result
```

You should now have the image:
```
IMAGE                     ID             DISK USAGE   CONTENT SIZE   EXTRA
startpage-docker:latest   2d4751cc460c       13.2MB             0B    U
```
