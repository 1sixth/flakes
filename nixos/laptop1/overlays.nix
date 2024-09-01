{ config, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (inputs.nix-index-database.packages.${prev.system}) nix-index-with-db;
      inherit
        (inputs.nix-vscode-extensions.extensions.${prev.system}.forVSCodeVersion
          config.home-manager.users.one6th.programs.vscode.package.version
        )
        vscode-marketplace
        ;
    })
  ];
}
