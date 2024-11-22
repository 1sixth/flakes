{ config, pkgs, ... }:

let
  commandLineArgs = builtins.concatStringsSep " " [
    "--enable-wayland-ime"
    "--extensions-dir ${config.home.homeDirectory}/.vscode-oss/extensions"
    "--ozone-platform-hint=auto"
    "--proxy-server=socks5://127.0.0.1:1080"
  ];

  settings = pkgs.formats.json { };
in

{
  home.packages = with pkgs; [
    code-cursor
  ];

  xdg = {
    configFile."Cursor/User/settings.json".source = (
      settings.generate "settings.json" (
        config.programs.vscode.userSettings
        // {
          "cursor.cpp.disabledLanguages" = [
            "markdown"
            "plaintext"
          ];
          "cursor.general.enableShadowWorkspace" = true;
          "workbench.activityBar.orientation" = "vertical";
        }
      )
    );
    desktopEntries.cursor = {
      exec = "cursor ${commandLineArgs} --no-sandbox %U";
      icon = "cursor";
      name = "Cursor";
    };
  };
}
