{ pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; } }:

with pkgs;
mkShell {
  nativeBuildInputs = [ lftp typora ];
  buildInputs = [ hugo ];
}
