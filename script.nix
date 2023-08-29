{ system
, nixpkgs
, ...
}:

let
  # Load packages for the specified system
  pkgs = import nixpkgs {
    inherit system;
  };

  # this imports the `eval-config` function that evaluates and validates every NixOS configurations
  eval = import (nixpkgs.outPath + "/nixos");

  # Load the user's config alongside the netboot-minimal config for building the environement
  config = (eval {
    inherit system;
    configuration = { pgks, config, ... }: {
      imports = [
        (pkgs.path + "/nixos/modules/installer/netboot/netboot-minimal.nix")
        ./configuration.nix
      ];
    };
  }).config;
in
# This is the script that will boot NixOS with kexec
pkgs.writeScriptBin "nixos-kexec" ''
    #!${pkgs.stdenv.shell}
    set -xe

    export PATH=${pkgs.kexec-tools}/bin:$PATH

    kexec \
      -l ${config.system.build.kernel}/${config.system.boot.loader.kernelFile} \
      --initrd=${config.system.build.netbootRamdisk}/initrd \
      --append="init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams}"

    if systemctl --version >/dev/null 2>&1; then
      systemctl kexec
    else
      kexec -e
    fi
  ''
