{ nixpkgs ? import ./nix/nix.nix }:
let
  pkgs = import nixpkgs {};
  hkg = pkgs.haskellPackages;
  ghc = pkgs.haskell.packages.ghc865.ghcWithPackages (
          ps: with ps; [ cabal-install
                         zlib
                       ]
        );
  ghcjs = pkgs.haskell.packages.ghcjs.ghcWithPackages (
            ps: []
          );
in
  with pkgs;
  mkShell {
    buildInputs = [ binutils
                    curl
                    ghc
                    ghcjs
                    git
                    gnumake
                    hkg.fswatcher
                    hkg.ghcjs-base
                    hkg.hlint
                    less
                    nodejs
                    sourceHighlight
                  ];

    shellHook = ''
      export NIX_PATH="nixpkgs=${nixpkgs}:."
    '';
  }
