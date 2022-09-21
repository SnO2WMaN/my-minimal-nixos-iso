{
  # main
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # dev
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-generators,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = with inputs; [];
        };
      in {
        packages.minimal-iso = nixos-generators.nixosGenerate {
          inherit system pkgs;
          modules = [
            ./modules
          ];
          format = "install-iso";
        };
        packages.default = self.packages.${system}.minimal-iso;
      }
    );
}
