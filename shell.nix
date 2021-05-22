{ pkgs ? import <nokxpkgs> { } }:

with pkgs;

mkShell {
  nativeBuildInputs = [ typora git ];
  buildInputs = [ hugo ];
}
