{ pkgs }: with pkgs; rec {
  
  _latexDependencies = texlive.combine {
    inherit (texlive) scheme-small
      latexmk
      latexdiff
      biber
      amsfonts        # amssymb
      amsmath
      biblatex
      bigfoot         # suffix
      booktabs
      catchfile
      cleveref
      datatool
      enumitem
      environ
      etoolbox
      float
      fontspec
      framed
      fvextra
      glossaries
      hyperref
      iftex
      listingsutf8
      makecell
      mfirstuc
      minted
      mkjobtexmf
      preprint      # balance
      psnfss        # helvet
      tcolorbox
      xcolor
      xfor
      xstring
      ;
  };

  _shellDependencies =  [
    coreutils
    # minted
    which
    python310Packages.pygments
  ];

  editio_run = stdenvNoCC.mkDerivation {
    pname = "latex-editio";
    version = "v0.2.0";
    passthru.tlType = "run";

    srcs = [
      ./editio.sty
    ];

    unpackPhase = ''
      runHook preUnpack

      for _src in $srcs; do
        cp "$_src" $(stripHash "$_src")
      done

      runHook postUnpack
    '';

    nativeBuildInputs = [ _latexDependencies ] ++ _shellDependencies ;

    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      path="$out/tex/latex/editio"
      mkdir -p "$path"
      cp *.{cls,def,clo,sty} "$path/"

      runHook postInstall
    '';

    meta = with lib; {
      description = "LaTeX editing tools, templates, and workflows using Nix.";
      license = licenses.mit;
      maintainers = with maintainers; [ phdcybersec ];
      platforms = platforms.all;
    };
  };

  editio_texlive = { pkgs = [ editio_run ]; };

  editio_pkg = texlive.combine {
    editio = { pkgs = [ editio_run ]; };
  };

}