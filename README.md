# ❄️ NixOS kexec

A Nix flake used to build a bootable kexec NixOS system

This code is mostly a curated version of [cleverca22's nix-tests kexec](https://github.com/cleverca22/nix-tests/tree/master/kexec) implementation.

## Usage

You can use this flake in 3 different manners:

- Using `nix build`, it will build the system and the startup script.
.ou will then be able to execute `result/bin/nixos-kexec` as root to boot into the NixOS medium.
This is useful if you don't have a way to build the tarball on another system and send it to the target system.
However expects that you have been able to install the nix package manager and enable `nix-commands` and `flakes` experimental features succesfully.

- Using `nix run`, it will run the script after building it.
This is the same requirements as above.
be aware that you will need to run this as root, since it needs to run `kexec`

- Finally, using `nix build .#tarball`, it will build everything and compile it into a `.tar.gz` archive.
You will then be able to unpack the archive on the target machine and run the script.
This do not require nix to be installed on the target machine, but you need another machine with nix to build the archive.
**Warning**: Cross-compilation isn't supported here (for now at least), so you need to have the same processor type in the build machin and the target machine for this to work !!!

### Step by step

1) Modify `configuration.nix` according to the comments.
Here you can add whatever you want or need to be available on the live environment.

2) Build the environment.
Either `nix build`, `nix build .#tarball` or `nix run`.
Don't forget to run `nix run` with root privileges, or it will not work !

#### `nix build`

When the `nix build` finished, you can run `result/bin/nixos-kexec` as root, and it will boot into a live environment of NixOS.

#### `nix build .#tarball`

After the build finishes, you will find the tarball at `result/tarball/nixos-system-[YOUR SYSTEM].tar.gz`.
to use it, unpack it at the root of the target machine:
```bash
tar xfv nixos-system-[YOUR SYSTEM].tar.gz --directory=/
```

then you can simply run `/nixos-kexec/bin/nixos-kexec` as root, and it will work !

Now you are on the NixOS installation medium, fully running from ram !!!
You can proceed to install NixOS.

## Motivations

The main one is being able to change the os on remote servers.

I have an Oracle cloud server, and apart from Oracle Linux, Ubuntu or some RHEL flavours, you couldn't do much....
And loading a custom image seems like a nightmare (I spent days in this ui help ;-;).

So now, with this tool I can just load a simple Ubuntu instance, build a NixOS tarball, put it on the server and install NixOS like i want !!

## Future plans

- Further documentation
- Ability to cross-compile/cross-build the tarball between architectures
