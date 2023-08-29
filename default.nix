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

  # This is the script that will boot NixOS with kexec
  kexec-script = pkgs.writeScript "nixos-kexec" ''
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
  '';
in
# Generate a tarball that will include the script and the whole system
pkgs.callPackage (pkgs.path + "/nixos/lib/make-system-tarball.nix") {
  storeContents = [
    { object = kexec-script; symlink = "/nixos-kexec"; }
  ];
  contents = [ ];
}
