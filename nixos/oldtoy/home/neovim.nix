{ pkgs, ... }:

{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    extraConfig = ''
      :source ${./res/neovim.lua}
    '';
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-cmake
            tree-sitter-cpp
            tree-sitter-fish
            tree-sitter-html
            tree-sitter-lua
            tree-sitter-json
            tree-sitter-markdown
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-yaml
          ]
      ))
      editorconfig-nvim
      lualine-nvim
      nvim-lastplace
      papercolor-theme
      which-key-nvim
    ];
    viAlias = true;
    vimAlias = true;
    withRuby = false;
  };
}
