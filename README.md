# Gitit in docker

A Dockerfile to build image with [Gitit Wiki](https://github.com/jgm/gitit).

Additional packages are installed:
*  `graphviz` package for dot file support

## Quickstart

```
docker run --rm --name gitit -p 80:5001 esuarezsantana/gitit
```

## Usage

In real-world use you would mount existing git repository from docker host to the container.
Often the directory is owned by non-root user on host. This image can work with
cases like that. Gitit server runs as `gitit` user which has uid and gid
set to match with host-mounted directory.

Assuming `~/gitit.wiki` has existing gitit data directory. You can start server with

```
docker run --rm --name gitit -p 80:5001 -v ~/gitit.wiki:/gitit esuarezsantana/gitit
```

Image can be used this way to host an always running server or to preview wiki that you have locally.

## SSH

Container runs ssh server by default so that you can push and pull to gitit repository.
Assuming that `gitit.example.com` is the address of the server running gitit container
started with something like:

```
docker run --rm --name gitit -p 80:5001 -p 2201:22 -v ~/gitit.wiki:/gitit esuarezsantana/gitit
```

To deal with custom port in remote address you can add something like this in `~/.ssh/config`:

```
Host gitit.example.com
  User gitit
  Port 2201
```

Then add git clone with:

```
git clone ssh://gitit.example.com:/gitit/var/www/wikidata
```

And then you can push and pull like to any other repository.

## Conf patching and data directory

This container will setup the `/gitit` directory like this (so it can be split in several volumes):

- `etc/` for `gitit.conf` and `authorized_keys`
- `var/cache/` for cache,
- `var/logs/` for `gitit.log`
- `var/lib/` for `gitit-users`
- `var/www/` for `static/`, `templates/` and `wikidata/` (git repo).

These paths will be applied to the config file by patching it. You can modify
the conf file (but the port and patched paths) and let the container to rebuild
your repo as desired.

The container will read the owner/group of the `/gitit/etc/` or the `/gitit`
directory , and will apply this ownership to all the files in the `/gitit`
directory.

## License

MIT
