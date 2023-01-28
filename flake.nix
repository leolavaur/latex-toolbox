{
  description = "LaTeX editing tools, templates, and workflows using Nix.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: 
    
    (utils.lib.eachDefaultSystem (system:
      let
          pkgs = import nixpkgs { inherit system; };
      in
    {
      
      templates = {
        
        base = {
          path = ./base;
          description = "Base template for LaTeX documents.";
        };

        ieee = {
          path = ./ieee;
          description = "Base template with IEEEtran.";
        };

        vanilla = {
          path = ./vanilla;
          description = "Base template with vanilla LaTeX.";
        };

      };

      defaultTemplate = self.templates.base;

      helpers = import ./editio.nix { inherit pkgs; };
    
    }));
}