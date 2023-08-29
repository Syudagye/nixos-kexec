# ❄️ NixOS kexec

A Nix flake used to build a bootable kexec NixOS system

This code is mostly a curated version of [cleverca22's nix-tests kexec](https://github.com/cleverca22/nix-tests/tree/master/kexec) implementation.

## Usage

1) Modify `configuration.nix` according to the comments

2) Build the tarball with `nix build` (The resulting tarball will be in `result/tarball/`)

3) Untar the archive at the root of the distribution you want to boot from, and simply execute `./nixos-kexec`.

4) Wait until the machine fully booted NixOS (wait for it to respond to pings for example), and login into it (maybe with ssh).

Now you are on the NixOS installation medium, fully running from ram !!!
You can proceed to install normally.

## Motivations

Being able to change the os on remote servers.

I have an Oracle cloud server, and apart from Oracle Linux, Ubuntu or some RHEL flavours, you couldn't do much....
And loading a custom image seems like a nightmare (I spent days in this ui help ;-;).

So now, with this tool I can just load a simple Ubuntu instance, build a NixOS tarball, put it on the server and install NixOS like i want !!

## Future plans

- Further documentation
- Ability to cross-compile/cross-build the tarball between architectures
