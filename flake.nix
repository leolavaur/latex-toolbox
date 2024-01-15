{
  description = "LaTeX editing tools, templates, and workflows using Nix.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: ({
    
    templates = {
      
      base = {
        path = ./templates/base;
        description = "Base template for LaTeX documents.";
      };

      ieee = {
        path = ./templates/ieee;
        description = "Base template with IEEEtran.";
      };

      vanilla = {
        path = ./templates/vanilla;
        description = "Base template with vanilla LaTeX.";
      };

      default = self.templates.base;

    };

  } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      
      # We can pass "lib" as an argument here if we want to use it in other files. 
      # It is currently not necessary as we only have the "latex" sub-library.
      # Remeber to replicate the "lib" argument in "default.nix" if done.
      lib = import ./lib { inherit pkgs; };

    in {
      inherit lib;

      packages = {
        default = pkgs.callPackage ./package.nix { };
      };
    }
  ));
}