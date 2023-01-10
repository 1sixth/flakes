{ pkgs, ... }:

{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    extraConfig = ''
      :source ${./res/neovim.lua}
    '';
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-lastplace
      papercolor-theme
      which-key-nvim
      (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-c
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
    ];
    viAlias = true;
    vimAlias = true;
    withRuby = false;
  };
}
