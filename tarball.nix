{ system
, nixpkgs
, ...
} @ inputs:

let
  # Load packages for the specified system
  pkgs = import nixpkgs {
    inherit system;
  };

  # Load the script
  kexec-script = import ./script.nix;
in
# Generate a tarball that will include the script and the whole system
pkgs.callPackage (pkgs.path + "/nixos/lib/make-system-tarball.nix") {
  storeContents = [
    { object = kexec-script; symlink = "/nixos-kexec"; }
  ];
  contents = [ ];
}
