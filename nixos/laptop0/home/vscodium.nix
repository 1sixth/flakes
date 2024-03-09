{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions =
      (with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
      ])
      ++ (with pkgs.vscode-marketplace; [
        davidanson.vscode-markdownlint
        editorconfig.editorconfig
        huacnlee.autocorrect
        golang.go
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        pkief.material-icon-theme
        redhat.vscode-xml
        redhat.vscode-yaml
        vscodevim.vim
      ]);
    mutableExtensionsDir = false;
    package = pkgs.vscodium.override {
      commandLineArgs = builtins.concatStringsSep " " [
        "--enable-wayland-ime"
        "--ozone-platform-hint=auto"
        "--proxy-server=socks5://127.0.0.1:1080"
      ];
    };
    userSettings = {
      "[nix]"."editor.formatOnSave" = true;
      "autocorrect.formatOnSave" = false;
      "editor.fontFamily" = "monospace";
      "editor.fontSize" = 20;
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "extensions.ignoreRecommendations" = true;
      "files.enableTrash" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "lldb.suppressUpdateNotifications" = true;
      "markdownlint.config" = {
        MD010 = false;
        MD024.siblings_only = true;
        MD028 = false;
        MD040 = false;
        MD041 = false;
      };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings".nil.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
      "redhat.telemetry.enabled" = false;
      "security.workspace.trust.enabled" = false;
      "terminal.integrated.copyOnSelection" = true;
      "update.mode" = "none";
      "update.showReleaseNotes" = false;
      "vim.useCtrlKeys" = false;
      "window.menuBarVisibility" = "toggle";
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Solarized Light";
      "workbench.enableExperiments" = false;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.settings.enableNaturalLanguageSearch" = false;
      "workbench.startupEditor" = "none";
    };
  };
}
