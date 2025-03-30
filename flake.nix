{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-utils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        treeFmtEval = treefmt-nix.lib.evalModule pkgs (
          { pkgs, ... }:
          {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.mdformat = {
              enable = true;
              settings = {
                wrap = 80;
              };
            };
          }
        );
      in
      {

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
          ];
        };

        formatter = treeFmtEval.config.build.wrapper;
      }
    );
}
