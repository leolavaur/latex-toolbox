{ pkgs }: rec {
  
  latexDeps = with pkgs; (texlive.combine {
    inherit (texlive) 
      scheme-small
      amsfonts # amssymb 
      amsmath
      biber
      biblatex
      biblatex-ieee
      bigfoot # suffix
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
      latexdiff
      latexmk
      listingsutf8
      makecell
      mfirstuc
      minted
      mkjobtexmf
      preprint # balance
      psnfss # helvet
      tcolorbox
      xcolor
      xfor
      xstring
    ;
  });

  requiredPackages = with pkgs; [
    latexDeps
    coreutils
    which python310Packages.pygments
  ];

}