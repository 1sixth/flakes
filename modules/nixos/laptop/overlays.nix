{ config, inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.hyprland.overlays.default
    (final: prev: {
      inherit (inputs.nix-index-database.packages.${prev.system}) nix-index-with-db;
      inherit
        (inputs.nix-vscode-extensions.extensions.${prev.system}.forVSCodeVersion
          config.home-manager.users.one6th.programs.vscode.package.version
        )
        vscode-marketplace
        ;

      impala = prev.impala.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.writeText "impala.patch" ''
            diff --git a/src/app.rs b/src/app.rs
            index 8d245f0..742c9ef 100644
            --- a/src/app.rs
            +++ b/src/app.rs
            @@ -127,11 +127,7 @@ impl App {

                     let agent_manager = session.register_agent(agent).await?;

            -        let color_mode = match terminal_light::luma() {
            -            Ok(luma) if luma > 0.6 => ColorMode::Light,
            -            Ok(_) => ColorMode::Dark,
            -            Err(_) => ColorMode::Dark,
            -        };
            +        let color_mode = ColorMode::Dark;

                     Ok(Self {
                         running: true,

          '')
        ];
      });
    })
  ];
}
