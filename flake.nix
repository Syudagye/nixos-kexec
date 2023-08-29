{
  description = "Boot NixOS with kexec";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      kexec = import ./.;
    in
    {
      packages = {
        x86_64-linux =
          let
            system = "x86_64-linux";
          in
          rec {
            x86_64 = kexec {
              inherit system nixpkgs;
            };
            default = x86_64;
          };

        aarch64-linux =
          let
            system = "aarch64-linux";
          in
          rec {
            aarch64 = kexec {
              inherit system nixpkgs;
            };
            default = aarch64;
          };
      };
    };
}
