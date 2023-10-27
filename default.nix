{ pkgs
  , withMinted ? false
  , withBib ? false,
}: 
  
pkgs.stdenvNoCC.mkDerivation (finalAttrs: with pkgs; 

rec {
  
  pname = "latex-editio";
  version = "v0.3.7";
  
  passthru.tlType = "run";
  passthru.pkgs = with texlive; 
    lib.lists.foldr (a: b: a.pkgs ++ b)
      [ finalAttrs.finalPackage ]
      passthru.deps.tex
    ;

  srcs = [
    ./textb.sty
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

  passthru.deps = {

    tex = with pkgs.texlive; [

      # tools
      biber
      latexdiff
      latexmk

      # packages
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
      inconsolata     
      listingsutf8
      makecell
      mfirstuc
      microtype
      mkjobtexmf
      pdfcol
      preprint        # balance
      psnfss          # helvet
      tcolorbox
      xcolor
      xfor
      xstring

    ] 
      ++ pkgs.lib.lists.optionals withMinted [ minted ]
    ;

    env = with pkgs; [ ]
      ++ lib.lists.optionals withMinted [ 
        which
        python310Packages.pygments
      ]
    ;
      
  };

})
