{
  description = "Testing flake for LaTeX documents.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    latex-toolbox = {
      url = "..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, latex-toolbox } @ inputs:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { 
          inherit system;
        };
        textb = inputs.latex-toolbox.packages.${system}.default;
        latex = inputs.latex-toolbox.lib.${system}.latex;
      in rec {
        
        packages.default = latex.mkDocument { src = ./src; main = "main.tex"; };

        packages.withtb = latex.mkDocument {
          src = ./src;
          main = "main.tex";
          deps = { inherit textb; };
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = packages.document.buildInputs 
              ++ [ pkgs.tectonic pkgs.coreutils ];
          };
        };

      }
    );

}
