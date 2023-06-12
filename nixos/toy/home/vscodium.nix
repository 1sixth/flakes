{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      davidanson.vscode-markdownlint
      editorconfig.editorconfig
      jnoortheen.nix-ide
      matklad.rust-analyzer
      pkief.material-icon-theme
      vadimcn.vscode-lldb
      vscodevim.vim
    ];
    package = pkgs.vscodium.override {
      commandLineArgs = builtins.concatStringsSep " " [
        "--enable-wayland-ime"
        # VSCodium just shows a white window in XWayland on Hyprland.
        "--ozone-platform-hint=auto"
      ];
    };
    userSettings = {
      "editor.bracketPairColorization.enabled" = true;
      "editor.fontFamily" = "monospace";
      "editor.fontSize" = 20;
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      "extensions.ignoreRecommendations" = true;
      "files.enableTrash" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "markdownlint.config" = {
        "MD024"."siblings_only" = true;
        "MD028" = false;
        "MD040" = false;
      };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings"."nil"."formatting"."command" = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
      "security.workspace.trust.enabled" = false;
      "update.mode" = "none";
      "update.showReleaseNotes" = false;
      "vim.useCtrlKeys" = false;
      "window.menuBarVisibility" = "toggle";
      # Unset the following line and VSCodium would crash
      # in native Wayland on Hyprland. This is weird
      # because other people are reporting crashes
      # when it is set. See: vscode/issues/181533
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Solarized Light";
      "workbench.enableExperiments" = false;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.settings.enableNaturalLanguageSearch" = false;
      "workbench.startupEditor" = "none";
    };
  };
}
