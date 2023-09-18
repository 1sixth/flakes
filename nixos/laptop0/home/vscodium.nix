{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = (with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      ms-python.python
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
    ]) ++ (with pkgs.vscode-marketplace; [
      asvetliakov.vscode-neovim
      davidanson.vscode-markdownlint
      editorconfig.editorconfig
      golang.go
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
      mkhl.direnv
      ms-pyright.pyright
      ms-python.isort
      pkief.material-icon-theme
    ]);
    mutableExtensionsDir = false;
    package = pkgs.vscodium.override {
      commandLineArgs = builtins.concatStringsSep " " [
        "--enable-wayland-ime"
        "--ozone-platform-hint=auto"
      ];
    };
    userSettings = {
      "editor.bracketPairColorization.enabled" = true;
      "editor.fontFamily" = "monospace";
      "editor.fontSize" = 20;
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "extensions.experimental.affinity"."asvetliakov.vscode-neovim" = 1;
      "extensions.ignoreRecommendations" = true;
      "files.enableTrash" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "isort.check" = true;
      "isort.path" = [ "${pkgs.isort}/bin/isort" ];
      "lldb.suppressUpdateNotifications" = true;
      "markdownlint.config" = {
        "MD024"."siblings_only" = true;
        "MD028" = false;
        "MD040" = false;
        "MD041" = false;
      };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings"."nil"."formatting"."command" = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
      "python.experiments.enabled" = false;
      "python.formatting.blackPath" = "${pkgs.black}/bin/black";
      "python.formatting.provider" = "black";
      "security.workspace.trust.enabled" = false;
      "update.mode" = "none";
      "update.showReleaseNotes" = false;
      "vscode-neovim.neovimClean" = true;
      "vscode-neovim.useCtrlKeysForInsertMode" = false;
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
