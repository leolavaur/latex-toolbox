{
  description = "Base template for LaTeX documents.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    editio = {
      url = "github:phdcybersec/editio";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, editio }:

    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        requiredPackages = editio.helpers.${system}.requiredPackages ++ [
          (pkgs.texlive.combine {
            inherit (pkgs.texlive) ieeetran;
          })
        ];
      in rec {
        
        packages = rec {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "document";
            src = ./src;

            buildInputs = requiredPackages;

            buildPhase = ''
              mkdir -p .cache/texmf-var
              env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              latexmk -interaction=nonstopmode -shell-escape -pdf \
              document.tex
            '';

            installPhase = ''
              mkdir -p $out
              install -m 644 document.pdf $out/
            '';
          };
          default = document;
        };

        devShell = pkgs.mkShell {
          buildInputs = requiredPackages ++ [ pkgs.tectonic ];
        };

      }
    );

}
