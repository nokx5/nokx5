{ pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; } }:

with pkgs;
mkShell {
  nativeBuildInputs = [ typora ];
  buildInputs = [ hugo ];
}
