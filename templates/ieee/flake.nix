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
        ed = editio.helpers.${system};
        deps = [ ed._latexDependencies ] ++ ed._shellDependencies;
      in rec {
        
        packages = rec {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "document";
            src = ./src;

            buildInputs = deps;

            buildPhase = ''
              mkdir -p .cache/texmf-var
              env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
                SOURCE_DATE_EPOCH=${toString self.lastModified} \
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
