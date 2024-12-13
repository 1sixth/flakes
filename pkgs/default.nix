{
  pkgs,
  nixpkgs,
}:

let
  inherit (pkgs) callPackage;
in

{
  windsurf = callPackage ./windsurf.nix { inherit nixpkgs; };
}
