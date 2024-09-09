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
      nvim-treesitter.withAllGrammars
      papercolor-theme
      which-key-nvim
    ];
    viAlias = true;
    vimAlias = true;
    withRuby = false;
  };
}
