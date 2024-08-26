vim.opt.background = 'light'
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.mouse = ''
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true

vim.cmd.colorscheme('PaperColor')

require('lualine').setup {
  options = {
    icons_enabled = false
  }
}

require('nvim-lastplace').setup {
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true
  },
  incremental_selection = {
    enable = true
  },
  indent = {
    enable = true
  }
}

require("which-key").setup {
}
