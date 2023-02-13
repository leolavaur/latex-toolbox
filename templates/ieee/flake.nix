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

  outputs = { self, nixpkgs, utils, editio } @ inputs:

    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        editio = import inputs.editio { inherit pkgs; };
      in rec {
        
        packages = rec {
          document = pkgs.stdenvNoCC.mkDerivation {
            name = "document";
            src = ./src;

            buildInputs = 
              with pkgs; [

                (texlive.combine {
                  inherit (texlive) scheme-small
                    IEEEtran
                    biblatex-ieee
                  ;
                  # sty and its dependencies
                  inherit editio;

                })
                
                # other shell dependencies
                editio.deps.env

              ];

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

        devShells = {
          default = pkgs.mkShell {
            buildInputs = packages.document.buildInputs 
              ++ [ pkgs.tectonic pkgs.coreutils ];
          };
        };

      }
    );

}
