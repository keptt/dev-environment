-----------------------------------------------------------
-- Integrated Neovim Configuration
-- (Kickstart base with first config’s plugins, keymaps, and options)
-----------------------------------------------------------

-- Set <backslash> as the leader key explicitely. However, this is a default anyway (must be set before plugins load)
vim.g.mapleader = "\"
vim.g.maplocalleader = "\"

-- Basic Options (merging Kickstart and first config)
vim.opt.number = true
vim.opt.relativenumber = true -- from first config
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10

-- Clipboard: merge system clipboard (first config uses append)
vim.opt.clipboard:append("unnamedplus")

-- Tab settings from first config
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

-----------------------------------------------------------
-- Bootstrap lazy.nvim (using Kickstart code)
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- Plugin Setup via lazy.nvim
-----------------------------------------------------------
require("lazy").setup({
	-- Basic utility plugin
	"tpope/vim-sleuth",

	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Which-key to show pending keybinds
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					--Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	-- Telescope (using tag from first config) and its dependencies
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8", -- from first config (instead of branch '0.1.x')
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
		end,
	},

	-- Harpoon from first config
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Dracula color scheme from first config
	"maxmx03/dracula.nvim",
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	-- LSP and related plugins
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local servers = {
				gopls = {},
				clangd = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
						},
					},
				},
			}
			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, { "stylua" })
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	-- Autoformatting via conform.nvim
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"
				return { timeout_ms = 500, lsp_format = lsp_format_opt }
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				c = { "clang-format" },
				go = { "gofmt" },
			},
		},
	},

	-- Autocompletion with nvim-cmp and LuaSnip
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						-- Using LuaSnip (Kickstart uses LuaSnip by default)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<M-q>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<M-Tab>"] = cmp.mapping.select_next_item(),
					["<M-S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = {
					{ name = "nvim_lsp" },
				},
			})
		end,
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- Additional plugins from Kickstart (mini, treesitter, etc.)
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = { "ruby" } },
			indent = { enable = true, disable = { "ruby" } },
		},
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-----------------------------------------------------------
-- Additional settings & keymaps (from first config)
-----------------------------------------------------------

-- (Override any conflicting mappings below – we favor the first config.)

-- Set custom statuscolumn (if using a custom sign/number group)
vim.o.statuscolumn = "%#MySigns#%s %#MyLineNr#%l %#MyRelative#%r  "

-- Colorscheme and transparency (from first config)
vim.o.termguicolors = true
vim.cmd("colorscheme dracula")
vim.api.nvim_set_hl(0, "MyRelative", { fg = "#6272a4" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#bd93f9" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f1fa8c", bold = true })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })

vim.keymap.set("n", ".", "<Space>")
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "Scroll up and center" })
-- Telescope keymaps (from first config)
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })

-- Harpoon keymaps (from first config)
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", harpoon_mark.add_file, { desc = "Harpoon add file" })
vim.keymap.set("n", "<C-e>", harpoon_ui.toggle_quick_menu, { desc = "Harpoon toggle quick menu" })
vim.keymap.set("n", "<leader>ga", function()
	harpoon_ui.nav_file(1)
end, { desc = "Harpoon navigate file 1" })
vim.keymap.set("n", "<leader>gs", function()
	harpoon_ui.nav_file(2)
end, { desc = "Harpoon navigate file 2" })
vim.keymap.set("n", "<leader>gd", function()
	harpoon_ui.nav_file(3)
end, { desc = "Harpoon navigate file 3" })
vim.keymap.set("n", "<leader>gf", function()
	harpoon_ui.nav_file(4)
end, { desc = "Harpoon navigate file 4" })

-- Smart <CR> mapping for auto-indenting when inside brackets
vim.keymap.set("i", "<CR>", function()
	local line = vim.fn.getline(".")
	local cursor_col = vim.fn.col(".")
	local before_cursor = line:sub(cursor_col - 1, cursor_col - 1)
	local after_cursor = line:sub(cursor_col, cursor_col)
	if (before_cursor == "{") or (before_cursor == "(") or (before_cursor == "[") then
		local current_indent = vim.fn.indent(".")
		local indent_string = string.rep(" ", current_indent + vim.opt.shiftwidth:get())
		return "<CR><CR><Up>" .. indent_string
	end
	return "<CR>"
end, { expr = true, desc = "Smart CR with bracket indent" })

-- Highlight trailing whitespace and keymap to trim it
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#ff5555" })
vim.cmd([[match TrailingWhitespace /\s\+$/]])
vim.keymap.set("n", "<leader>w", function()
	local save_cursor = vim.fn.getpos(".")
	vim.cmd([[%s/\s\+$//e]])
	vim.fn.setpos(".", save_cursor)
end, { desc = "Remove trailing whitespace" })

-- LSP keybindings (override Kickstart’s mappings with first config’s)
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions (first config overrides)",
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "x" }, "<F3>", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
		vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
	end,
})
