{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.nim
    pkgs.nimble
    pkgs.openssl
  ];

  shellHook = ''
    echo "Nixpkgs environment initialized."
    alias hi="echo "Hi""
  '';
}
