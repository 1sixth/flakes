{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./res/neovim.lua}
      EOF
    '';
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      papercolor-theme
      vim-lastplace
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
