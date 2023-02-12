{
  description = "Base template for LaTeX documents.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    editio = {
      url = "..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, editio }:

    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        deps = with pkgs; [
          (texlive.combine {
            inherit (texlive) scheme-small;
            inherit (editio.helpers.${system}.mkPkg {});
          })
          which python310Packages.pygments
          coreutils 
        ];
      in rec {
        
        packages = rec {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "document";
            src = ./src;

            buildInputs = deps;

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
          buildInputs = deps ++ [ pkgs.tectonic ];
        };

      }
    );

}
