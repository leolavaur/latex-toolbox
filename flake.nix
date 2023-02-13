{
  description = "LaTeX editing tools, templates, and workflows using Nix.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }: {
    
    templates = {
      
      base = {
        path = ./templates/base;
        description = "Base template for LaTeX documents.";
      };

      ieee = {
        path = ./templates/ieee;
        description = "Base template with IEEEtran.";
      };

      vanilla = {
        path = ./templates/vanilla;
        description = "Base template with vanilla LaTeX.";
      };

      default = self.templates.base;

    };

  };

}