{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {} }:
let
  sourcePaths = import ./sources.nix { inherit pkgs; }
    // sourcesOverride;

  iohkNix = import sourcePaths.iohk-nix {};

  # use our own nixpkgs if it exists in our sources,
  # otherwise use iohkNix default nixpkgs.
  nixpkgs = if (sourcePaths ? nixpkgs)
    then sourcePaths.nixpkgs
    else iohkNix.nixpkgs;

  overlays = (import ../overlays sourcePaths false) ++
    [ (import ../globals-deployers.nix)
    ];

  pkgs = import nixpkgs {
    inherit config system crossSystem overlays;
  };

in pkgs
