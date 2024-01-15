{ pkgs }:
{
  latex = import ./latex.nix { inherit pkgs; };
}