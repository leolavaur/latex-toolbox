{ 
  pkgs, ...
}: {
  # mkDocument :: { name::str, src::path, main::str, deps::combinable } -> derivation
  #   name (str): name of the document (will be used as the name of the pdf file).
  #   src (path): path to the source directory.
  #   main (str): name of the main tex file.
  #   deps (combinable): list of dependencies that can be combined with the texlive
  #       package set.
  mkDocument = {
      name ? "document",
      src ? ./.,
      main ? "main.tex",
      deps ? {},
    }:
    pkgs.stdenvNoCC.mkDerivation {

      name = name;   
      src = src;

      buildInputs = 
        [

          (pkgs.texlive.combine ({
            inherit (pkgs.texlive)
              scheme-small
              latexmk
            ;
          } // deps))

        ];

      buildPhase = ''
        mkdir -p .cache/texmf-var
        env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
        latexmk -interaction=nonstopmode -shell-escape -pdf \
        -jobname=${name} \
        ${main}
      '';

      installPhase = ''
        mkdir -p $out
        install -m 644 ${name}.pdf $out/
      '';
    };
}