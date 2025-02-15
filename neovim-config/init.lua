require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'ThePrimeagen/harpoon',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'maxmx03/dracula.nvim'
end)


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


local telescope = require('telescope')
telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      --'--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
  }
}


local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>ga", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>gs", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>gd", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>gf", function() ui.nav_file(4) end)


vim.opt.clipboard:append("unnamedplus")
vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.statuscolumn = '%#MySigns#%s %#MyLineNr#%l %#MyRelative#%r  '
vim.opt.cursorline = true

vim.o.termguicolors = true
vim.cmd("colorscheme dracula")
vim.api.nvim_set_hl(0, "MyRelative", { fg = "#6272a4" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#bd93f9" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f1fa8c", bold = true })
-- make background transparent
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })

