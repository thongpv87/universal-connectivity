{
  description = "Universal";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-23.05"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (pkgs.lib) optional optionals;
        pkgs = import nixpkgs {
          inherit system;
          # Makes the config pure as well. See <nixpkgs>/top-level/impure.nix:
          config = { allowBroken = true; };
        };

      in with pkgs; {
        devShell = pkgs.mkShell {
          shellHook = ''
            export PATH=$PATH
          '';

          buildInputs = [ rustc go nodejs ]
            ++ optional stdenv.isLinux inotify-tools
            ++ optional stdenv.isDarwin terminal-notifier
            ++ optionals stdenv.isDarwin
            (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]);
        };
      });
}
