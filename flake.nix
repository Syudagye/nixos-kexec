{
  description = "Boot NixOS with kexec";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      kexecTarball = import ./tarball.nix;
      kexecScript = import ./script.nix;
    in
    {
      packages = {
        x86_64-linux =
          let
            system = "x86_64-linux";
          in
          rec {
            script = kexecScript {
              inherit system nixpkgs;
            };
            tarball = kexecTarball {
              inherit system nixpkgs;
            };
            default = script;
          };

        aarch64-linux =
          let
            system = "aarch64-linux";
          in
          rec {
            script = kexecScript {
              inherit system nixpkgs;
            };
            tarball = kexecTarball {
              inherit system nixpkgs;
            };
            default = script;
          };
      };
    };
}
