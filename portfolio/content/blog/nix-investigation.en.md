+++
author = "nokx"
title = "A short nix story for beginners"
date = "2021-06-01"
description = "nix for beginners"
tags = [ "nix" ]
favorite = true

+++


Nix is a great tool towards reproducible code. However the learning curve can be long. In this post, we will resume the different step we encounter and give motivation to start with nix.

### Install/Uninstall nix

In the following we will use the single user installation to avoid problems of owners and groups. Nix is simple to install (you need `sudo` access to `root`)

```bash
$ curl -L https://nixos.org/nix/install | sh
```

You can test that nix works with a command like 

```bash
$ nix-shell -p hello --run hello
```

To uninstall, simply remove the `/nix` folder and associate configuration files.

 ```bash
 $ rm -rf /nix ~/.nix* ~/.config/nix*
 ```

# Develop with a nix-shell

The easiest way to start developing with nix is to copy a working template.

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

1. `pkgs = import <nixpkgs> {};` uses a nixpkgs [_channel_](#more-channels) loaded in the `pkgs` variable corresponding to all available derivations.
2. `pkgs.mkShell {}` creates a shell. This is a simplified version of the generic derivation `pkgs.mkDerivation`. This means that `mkShell` will works for the `nix-shell` command only.
3. `nativeBuildInputs = [ emacs-nox vim ];` are available as native (at build-time).
4. `buildInputs = [ boost17x ];` are available as program or library (at runtime). 

We now can enter the development environment using nix. The first time, you will have to wait for the nix dependencies to be downloaded

```bash
$ nix-shell shell.nix --pure # purity means isolation from the rest of the system
> pkg-config --list-all
zlib zlib - zlib compression library
> exit
```

This sounds great ! But even better, try to rerun `nix-shell`, all dependencies are stored in the `/nix/store/`  already ! :smile:

### Small digression about the nix store

The softwares are stored in `/nix/store/` with prefix hashes using `NAR` deterministic archiving and nix derivations `drv` organization. This means that we can now have multiple version of the same software (`gcc8`, `gcc9`, ...) working without conflicting in nix. The amount of software downloaded can be quite large. Nix provide a cleaning of the nix store using garbage collection for useless legacy dependencies.

```bash
$ nix-collect-garbage -d
```

This will remove all non used derivations in the nix store.

Have a try and rerun the `nix-shell` command.

# More channels

Now that you know how to collect garbage, let's try to update the version of the channel `<nixpkgs>`. But first what is `<nixpkgs>`

```bash
$ nix-channel --list
nixpkgs https://nixos.org/channels/nixpkgs-unstable
```

here, `<nixpkgs>` will point to the `nixpkgs-unstable` branch of the official nixpkgs repository. The _unstable_ here means that this branch evolve fast. This means that if you update the channel a week later, 

```bash
$ nix-channel --update
```

any default software could have been upgraded meanwhile, which force you to download the software again with a new `hash` in the `/nix/store/`.

In order to avoid changing the software while developing, one can pin a specific channel version and freeze the whole environment (this become always reproducible). Here is an example.

```nix
{ pkgs ? import (fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/5272327b81ed355bbed5659b8d303cf2979b6953.tar.gz";
  sha256 = "sha256:0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
}) { } }:

pkgs.mkShell { nativeBuildInputs = [ pkgs.nix ]; }
```

Funny, we can download nix in nix. Providing a `sha256` ensure that nix remain pure since it knows at that moment, that the `NAR hash` of that channel could not conflict. This channel corresponds to the `NixOS 20.03` release and all `pkgs` there are pinned to that release. You could run this in two years, no problem for nix.



If you do not want to pin a specific version but you would like to jump from the unstable to the stable channel for a try, you can set the nix-channel for a specific command using the first `shell.nix` example.

```bash
$ nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/5272327b81ed355bbed5659b8d303cf2979b6953.tar.gz
```



# This nix warm-up stops here.

With this tutorial, I hope I gave newcomers motivation to start with nix, there is still a long obscure path towards mastering those tools. You can start reading the [nix pills](https://nixos.org/guides/nix-pills/), read it slowly and carefully, don't get discouraged.

I would encourage you to learn after the nix pills the following in the right order.

1. start using the nix-shell for your own development (more bash/C/C++ oriented)
2. learn nix language and use the `nix repl`.
3. write your first simple package (bash/C/C++).
4. play with `nix-shell`, `nix-build` and channels for different languages (python/ruby/rust/go/...), hack, hack, hack.
5. learn about __overlays__ to overwrite in-place (overwrite specific `pkgs`).
6. the holly Grail but still an experimental feature, forget about all what you learned and use nix flakes.

Please note that if you jump one steps, you will lose multiple weeks. Enjoy your coding !

