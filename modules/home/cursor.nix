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
      settings.generate "settings.json" config.programs.vscode.userSettings
    );
    desktopEntries.cursor = {
      exec = builtins.toString (
        pkgs.writeShellScript "cursor" ''
          cursor ${commandLineArgs} --no-sandbox
        ''
      );
      icon = "cursor";
      name = "Cursor";
    };
  };
}
