{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      davidanson.vscode-markdownlint
      dotjoshjohnson.xml
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
      matklad.rust-analyzer
      pkief.material-icon-theme
      vadimcn.vscode-lldb
      vscodevim.vim
    ];
    mutableExtensionsDir = false;
    package = pkgs.vscodium;
    userSettings = {
      "editor.bracketPairColorization.enabled" = true;
      "editor.fontFamily" = "monospace";
      "editor.fontSize" = 20;
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "markdownlint.config" = {
        "MD024" = false;
        "MD029" = false;
        "MD033" = false;
        "MD040" = false;
        "MD041" = false;
        "MD045" = false;
      };
      "nix.enableLanguageServer" = true;
      "security.workspace.trust.enabled" = false;
      "update.mode" = "none";
      "update.showReleaseNotes" = false;
      "vim.useCtrlKeys" = false;
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Solarized Light";
      "workbench.enableExperiments" = false;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.settings.enableNaturalLanguageSearch" = false;
      "workbench.startupEditor" = "none";
    };
  };
}
