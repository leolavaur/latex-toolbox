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
      pdfcol
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
      microtype
      inconsolata
      
      # for ieee only
      ieeetran
      biblatex-ieee
      ;

      # editio
      inherit editio_texlive;
  };

  _shellDependencies =  [
    coreutils
    # minted
    which
    python310Packages.pygments
  ];

  pkg = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "latex-editio";
    version = "v0.2.0";
    
    tlType = "run";
    passthru.pkgs = with texlive; 
      lib.lists.foldr (a: b: a.pkgs ++ b) [pkg] [
        latexmk
        biber
        amsfonts        # amssymb
        amsmath
        biblatex
        bigfoot         # suffix
        booktabs
        catchfile
        cleveref
        pdfcol
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
        microtype
        inconsolata
      ];

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

    nativeBuildInputs = [ texlive.combined.scheme-small ] ;

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
  });

  editio_texlive = { pkgs = [ pkg ]; };

  editio_pkg = texlive.combine {
    inherit editio_texlive;
  };

}