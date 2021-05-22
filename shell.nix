{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  nativeBuildInputs = [ typora git ];
  buildInputs = [ hugo ];
}
