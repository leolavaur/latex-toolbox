{
  description = "Template for LaTeX document with additional packages.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    latex-toolbox = {
      url = "github:phdcybersec/latex-toolbox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, latex-toolbox } @ inputs:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { 
          inherit system;
        };
        latex = inputs.latex-toolbox.lib.${system}.latex;
      in rec {
        
        packages = rec {
          document = latex.mkDocument { 
            src = ./src;
            main = "main.tex";
            deps = {
              inherit (pkgs.texlive)
                ieeetran
                biblatex-ieee
                biblatex
                biber
                courier
              ;
            };
          };
          default = document;
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = packages.document.buildInputs;
          };
        };

      }
    );
}