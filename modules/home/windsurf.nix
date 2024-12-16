{
  config,
  lib,
  pkgs,
  ...
}:

let
  commandLineArgs = builtins.concatStringsSep " " [
    "--extensions-dir=${config.home.homeDirectory}/.vscode-oss/extensions"
    "--password-store=gnome-libsecret"
    "--proxy-server=socks5://127.0.0.1:1080"
  ];

  settings = pkgs.formats.json { };
in

{
  home.packages = with pkgs; [
    (lib.lowPrio (
      windsurf.override {
        inherit commandLineArgs;
      }
    ))
  ];

  xdg.configFile."Windsurf/User/settings.json".source = (
    settings.generate "settings.json" (
      config.programs.vscode.userSettings
      // {
        "windsurf.autocompleteSpeed" = "fast";
        "windsurf.cascadeOpenOnReload" = false;
      }
    )
  );
}
