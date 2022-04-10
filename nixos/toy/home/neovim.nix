{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      " use true color
      set termguicolors

      " show line number
      set number

      " show relative line number
      set relativenumber

      " disable showmode because the mode information is displayed in the statusline
      set noshowmode

      " ignore case when searching
      set ignorecase

      " when searching try to be smart about cases
      set smartcase

      " show matching brackets when text indicator is over them
      set showmatch

      " use spaces instead of tabs
      set expandtab

      " 1 tab == 4 spaces
      set tabstop=4

      " enable Smart indent
      set smartindent

      " move a line of text using ALT+[jk]
      nmap <M-j> mz:m+<cr>`z
      nmap <M-k> mz:m-2<cr>`z

      " only use dark background in tty
      if $TERM != 'linux'
        set background=light
      endif
    '';
    plugins = with pkgs.vimPlugins; [
      {
        config = ''
          let g:lightline = {
                \ 'colorscheme': 'PaperColor',
                \ }
        '';
        plugin = lightline-vim;
      }
      {
        config = "colorscheme PaperColor";
        plugin = papercolor-theme;
      }
      vim-gitgutter
      vim-polyglot
    ];
    viAlias = true;
    vimAlias = true;
  };
}
