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

  -- dracula color theme
  use 'maxmx03/dracula.nvim'

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
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

-- below lsp config is taken from https://github.com/VonHeikemen/lsp-zero.nvim?tab=readme-ov-file#quickstart-for-the-impatient
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- provides
-- support for golang, c, and typescript
require('lspconfig').gopls.setup({})
require('lspconfig').clangd.setup({})
require('lspconfig').ts_ls.setup({})

local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Esc>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<M-Tab>'] = cmp.mapping.select_next_item(),
    ['<M-S-Tab>'] = cmp.mapping.select_prev_item(),
 }),
})

vim.opt.tabstop = 4        -- number of spaces a tab counts for
vim.opt.shiftwidth = 4     -- number of spaces to use for autoindent
vim.opt.expandtab = true   -- convert tabs to spaces
vim.opt.softtabstop = 4    -- number of spaces a tab counts for while editing

-- smart parentheses autoappend with identation
vim.keymap.set('i', '<CR>', function()
    local line = vim.fn.getline('.')
    local cursor_col = vim.fn.col('.')
    local before_cursor = line:sub(cursor_col - 1, cursor_col - 1)
    local after_cursor = line:sub(cursor_col, cursor_col)

    -- if cursor is between brackets
    if (before_cursor == '{' and after_cursor == '}') or
       (before_cursor == '(' and after_cursor == ')') or
       (before_cursor == '[' and after_cursor == ']') then
        -- get current line's indentation
        local current_indent = vim.fn.indent('.')
        -- convert indent level to spaces
        local indent_string = string.rep(' ', current_indent + vim.opt.shiftwidth:get())
        return '<CR><CR><Up>' .. indent_string
    end

    return '<CR>'
end, { expr = true, desc = 'Smart CR with bracket indent' })
vim.keymap.set('i', '{', '{}<Left>', { desc = 'Auto-close curly braces' })
vim.keymap.set('i', '(', '()<Left>', { desc = 'Auto-close parentheses' })
vim.keymap.set('i', '[', '[]<Left>', { desc = 'Auto-close square brackets' })

local function smart_quotes(open_quote)
    return function()
        local line = vim.fn.getline('.')
        local col = vim.fn.col('.')
        local before_cursor = line:sub(1, col - 1)
        local after_cursor = line:sub(col)

        -- check if there's already a quote to the left
        if before_cursor:match(open_quote.."$") then
            return open_quote
        end

        -- check if there are only whitespace characters to the right
        if after_cursor:match("^%s*$") then
            return open_quote .. open_quote .. "<Left>"
        end

        return open_quote
    end
end

vim.keymap.set('i', '"', smart_quotes('"'), { expr = true })
vim.keymap.set('i', "'", smart_quotes("'"), { expr = true })
vim.keymap.set('i', "`", smart_quotes("`"), { expr = true })

-- highlight trailing whitespaces
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg = '#ff5555' })
vim.cmd([[match TrailingWhitespace /\s\+$/]])

-- function to trim trailing whitespace by pressing \w
vim.keymap.set('n', '<leader>w', function()
    -- save cursor position
    local save_cursor = vim.fn.getpos(".")
    -- remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- restore cursor position
    vim.fn.setpos(".", save_cursor)
end, { desc = 'Remove trailing whitespace' })
