+++
author = "nokx"
title = "A short nix story line"
date = "2020-07-01"
description = "Short resume of my PhD"
tags = [ "nix" ]
favorite = true
translationKey = "nix1"

+++

Nix is a great tool towards reproducible code. However the learning curve can be long. In this post, we will resume the different step in our nix usage.

# Install/Uninstall nix

In the following we will use the single user installation to avoid problem of owners and groups. Nix is simple to install (you need `sudo` access to `root`) : 

```bash
curl -L https://nixos.org/nix/install | sh
```

after installing it, you can test the command with ` nix-shell -p hello --run hello`.

To uninstall, simply remove the `rm -rf /nix` folder and associate configuration files `rm -r ~/.nix* ~/.config/nix*`.

# Develop with a nix-shell

The easiest way to start developing with nix is to start with a given template.

Let's save the following in a `shell.nix` file.

```nix
{ pkgs ? import <nixpkgs> { } }: # 1

with pkgs;

mkShell { # 2
  nativeBuildInputs = [ pkgconfig ]; # 3
  buildInputs = [ zlib ]; # 4
}
```

Few remarks at this point.

1. `pkgs = import <nixpkgs> {};` imports a [_channel_]() in the `pkgs` variable corresponding to all available derivations.
2. `pkgs.mkShell {}` creates a shell derivation. This is a simplified `pkgs.mkDerivation`, thus creating a utility for the `nix-shell` command only.
3. `nativeBuildInputs = [ emacs-nox vim ];` are available as native (or at build-time only).
4. `buildInputs = [ boost17x ];` are available as program or library at runtime only. 

We now can enter the development environment using nix. The first time, you will have to wait for nix dependencies download

```bash
nix-shell shell.nix --pure # purity means isolation from the rest of the system
$ pkg-config --list-all
zlib zlib - zlib compression library
$ exit
```

This sounds great ! But even better, try to rerun `nix-shell`, all dependencies are stored in the `/nix/store/` ! :smile:

### Small digression about the nix store

The softwares are stored in `/nix/store/` with prefix hashes using `NAR` deterministic archiving and nix derivations `drv` organization. This means that we can now have multiple version of the same software (`gcc8`, `gcc9`, ...) working without conflicting in nix. The amount of software downloaded can be quite large. Nix provide a cleaning of the nix store using garbage collection.

```bash
nix-collect-garbage -d
```

This will remove all non used derivations in the nix store.

Have a try to rerun the `nix-shell` command.

# More channels

Now that you know how to collect garbage, let's try to update the version of the channel `<nixpkgs>`.





