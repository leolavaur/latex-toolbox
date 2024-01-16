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
        description = "Nix flake for LaTeX documents.";
      };

      ieee = {
        path = ./templates/ieee;
        description = "Template for IEEE articles.";
      };

      custom = {
        path = ./templates/custom;
        description = "Template for LaTeX document with custom package.";
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
        textb = pkgs.callPackage ./package.nix { };
      };
    }
  ));
}