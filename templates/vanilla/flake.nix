{
  description = "Base template for LaTeX documents.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:

    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        latexpkgs = with pkgs; (texlive.combine {
          inherit (texlive) scheme-small
            latexmk;
        });
      in
      {
        packages = rec {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "document";
            src = ./.;

            buildInputs = with pkgs; [
              latexpkgs
              coreutils
            ];

            buildPhase = ''
              mkdir -p .cache/texmf-var
              env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              latexmk -interaction=nonstopmode -pdf \
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
          buildInputs = with pkgs; [
            latexpkgs
            coreutils
          ];
        };

      }
    );

}
