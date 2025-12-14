-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
	-- Tree-sitter for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false, -- last release is way too old and doesn't work on Windows
		build = function()
			local TS = require("nvim-treesitter")
			if not TS.get_installed then
				vim.notify(
					"Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.",
					vim.log.levels.ERROR
				)
				return
			end
			-- make sure we're using the latest treesitter util
			package.loaded["nvim-treesitter"] = nil
			TS.update(nil, { summary = true })
		end,
		event = { "BufReadPost", "BufNewFile", "VeryLazy" },
		cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
		opts_extend = { "ensure_installed" },
		opts = {
			-- LazyVim config for treesitter
			indent = { enable = true },
			highlight = { enable = true },
			folds = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
				"css",
			},
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter")

			-- some quick sanity checks
			if not TS.get_installed then
				return vim.notify("Please use `:Lazy` and update `nvim-treesitter`", vim.log.levels.ERROR)
			elseif type(opts.ensure_installed) ~= "table" then
				return vim.notify("`nvim-treesitter` opts.ensure_installed must be a table", vim.log.levels.ERROR)
			end

			-- setup treesitter
			TS.setup(opts)

			-- install missing parsers
			local install = vim.tbl_filter(function(lang)
				return not pcall(require, "nvim-treesitter.parsers." .. lang)
			end, opts.ensure_installed or {})
			if #install > 0 then
				vim.defer_fn(function()
					TS.install(install, { summary = true })
				end, 100)
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
				callback = function(ev)
					local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
					if not pcall(require, "nvim-treesitter.parsers." .. ft) then
						return
					end

					---@param feat string
					---@param query string
					local function enabled(feat, query)
						local f = opts[feat] or {}
						return f.enable ~= false
							and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
							and pcall(require, "nvim-treesitter.parsers." .. ft)
					end

					-- highlighting
					if enabled("highlight", "highlights") then
						pcall(vim.treesitter.start, ev.buf)
					end

					-- indents
					if enabled("indent", "indents") then
						vim.opt_local.indentexpr = "nvim_treesitter#indent()"
					end

					-- folds
					if enabled("folds", "folds") then
						if vim.opt_local.foldmethod:get() ~= "expr" then
							vim.opt_local.foldmethod = "expr"
							vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
						end
					end
				end,
			})
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"akinsho/bufferline.nvim",
		optional = true,
		opts = function(_, opts)
			if (vim.g.colors_name or ""):find("catppuccin") then
				opts.highlights = require("catppuccin.special.bufferline").get_theme()
			end
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
			},
		},
	},

	-- Catppuccin theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				integrations = {
					nvimtree = true,
					notify = true,
					lazy = true,
					lsp = true,
					meson = true,
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},

	-- Lualine statusline
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
			})
		end,
	},

	-- Nvim Tree file manager
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				disable_netrw = true,
				hijack_netrw = true,
				view = {
					width = 35,
					side = "left",
				},
				renderer = {
					indent_width = 2,
					indent_markers = {
						enable = true,
						inline_arrows = true,
						icons = {
							corner = "└",
							edge = "│",
							item = "│",
							bottom = "─",
							none = " ",
						},
					},
					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
							modified = true,
						},
						glyphs = {
							default = "",
							symlink = "",
							bookmark = "",
							modified = "●",
							folder = {
								arrow_closed = "",
								arrow_open = "",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
							git = {
								unstaged = "✗",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
								ignored = "◌",
							},
						},
						git_placement = "before",
						modified_placement = "after",
					},
				},
				filters = {
					dotfiles = false,
					custom = { ".git" },
				},
				git = {
					enable = true,
					ignore = false,
				},
				actions = {
					open_file = {
						quit_on_open = false,
					},
				},
			})
			vim.keymap.set("n", "\\", ":NvimTreeToggle<CR>")
		end,
	},

	{
		"S1M0N38/love2d.nvim",
		event = "VeryLazy",
		version = "2.*",
		opts = {},
		keys = {
			{ "<leader>v", ft = "lua", desc = "LÖVE" },
			{ "<leader>vv", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
			{ "<leader>vs", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
		},
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"onsails/lspkind.nvim",
			"ray-x/cmp-treesitter",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- Arrow keys for navigation
					["<Down>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Up>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					-- Tab for snippet expansion
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
					}),
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip" },
					{ name = "treesitter" },
					{ name = "path" },
				}, {
					{ name = "buffer", keyword_length = 0 },
				}),
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
				},
			})

			-- Cmdline completion for searching
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Cmdline completion for commands
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local luasnip = require("luasnip")
			-- Load VSCode-style snippets
			require("luasnip.loaders.from_vscode").lazy_load()
			-- Load snippets from snipmate format
			require("luasnip.loaders.from_snipmate").lazy_load()
			-- LuaSnip configuration
			luasnip.config.set_config({
				history = true,
				update_events = "TextChanged,TextChangedI",
				enable_autosnippets = true,
			})
		end,
	},

	-- Auto-pairing
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- LSP
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "html", "cssls", "jsonls", "yamlls", "bashls", "mesonlsp" },
			})
		end,
	},
	-- neodev.nvim disabled - replaced by lazydev.nvim
	-- {
	-- 	"folke/neodev.nvim",
	-- 	ft = "lua",
	-- 	opts = {
	-- 		library = {
	-- 			vimruntime = true,
	-- 			types = true,
	-- 			plugins = true,
	-- 		},
	-- 	},
	-- },
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Try to get cmp_nvim_lsp capabilities if available
			local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				capabilities = cmp_nvim_lsp.default_capabilities()
			end

			-- Enable snippet support
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.completion.completionItem.resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			}

			-- Setup lua_ls (lazydev.nvim handles this automatically)
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "love", "vim" },
							disable = { "different-requires" },
						},
						completion = {
							callSnippet = "Replace",
							keywordSnippet = "Replace",
						},
						workspace = {
							library = {
								["${3rd}/love2d/library"] = true,
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
							maxPreload = 2000,
							preloadFileSize = 1000,
						},
						telemetry = {
							enable = false,
						},
						hint = {
							enable = true,
							setType = true,
							paramType = true,
							paramName = "All",
							semicolon = "Disable",
							arrayIndex = "Disable",
						},
					},
				},
			})
		end,
	},

	-- Snacks dashboard
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = {
				enabled = true,
				preset = {
					header = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
          ]],
					keys = {
						{ icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
						{
							icon = "󰈞 ",
							key = "f",
							desc = "Find file",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{ icon = " ", key = "s", desc = "Settings", action = ":e $MYVIMRC" },
						{ icon = "󰅚 ", key = "q", desc = "Quit", action = ":qa" },
						{ icon = " ", key = "l", desc = "lazy", action = ":Lazy" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
				animate = {
					enabled = true,
					fps = 30,
					easing = "outCubic",
				},
			},
			picker = {
				enabled = true,
			},
			notifier = {
				enabled = true,
				timeout = 3000,
				style = "fancy",
				icons = {
					error = "",
					warn = "",
					info = "",
					debug = "",
					trace = "",
				},
				top_down = false,
			},
		},
	},

	-- Noice UI
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		-- stylua: ignore
		keys = {
			{ "<leader>sn", "", desc = "+noice"},
			{ "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
			{ "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
			{ "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
			{ "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
			{ "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
			{ "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
			{ "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
			{ "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
		},
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == "lazy" then
				vim.cmd([[messages clear]])
			end
			require("noice").setup(opts)
		end,
	},

	-- Linting with nvim-lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "InsertLeave" },
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				fish = { "fish" },
				lua = { "luacheck" },
				html = { "htmlhint" },
				bash = { "shellcheck" },
				sh = { "shellcheck" },
				python = { "pylint", "flake8" },
				javascript = { "eslint" },
				typescript = { "eslint" },
				json = { "jsonlint" },
				yaml = { "yamllint" },
				markdown = { "markdownlint" },
				css = { "stylelint" },
				-- Use to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use to run linters on filetypes that don't have other linters configured.
				-- ['_'] = { 'fallback linter' },
				-- ["*"] = { "typos" },
			},
			-- LazyVim extension to easily override linter options
			-- or add custom linters.
			---@type table<string,table>
			linters = {
				-- -- Example of using selene only when a selene.toml file is present
				-- selene = {
				--   -- `condition` is another LazyVim extension that allows you to
				--   -- dynamically enable/disable linters based on the context.
				--   condition = function(ctx)
				--     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
				--   end,
				-- },
			},
		},
		config = function(_, opts)
			local M = {}

			local lint = require("lint")
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
					if type(linter.prepend_args) == "table" then
						lint.linters[name].args = lint.linters[name].args or {}
						vim.list_extend(lint.linters[name].args, linter.prepend_args)
					end
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = opts.linters_by_ft

			function M.debounce(ms, fn)
				local timer = vim.uv.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			function M.lint()
				-- Use nvim-lint's logic first:
				-- * checks if linters exist for the full filetype first
				-- * otherwise will split filetype by "." and add all those linters
				-- * this differs from conform.nvim which only uses the first filetype that has a formatter
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)

				-- Create a copy of the names table to avoid modifying the original.
				names = vim.list_extend({}, names)

				-- Add fallback linters.
				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				-- Add global linters.
				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				-- Filter out linters that don't exist or don't match the condition.
				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						print("Linter not found: " .. name)
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				-- Run linters.
				if #names > 0 then
					lint.try_lint(names)
				end
			end

			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = M.debounce(100, M.lint),
			})
		end,
	},

	-- Formatting with conform
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
})
-- LSP diagnostics configuration
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- LSP keybindings and setup
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Basic Neovim settings
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h15"
vim.opt.cursorline = true
vim.opt.pumblend = 50 -- blur for nvim
vim.opt.winblend = 50 -- blur for nvim as window
vim.opt.showtabline = 2
vim.opt.linebreak = true
-- vim.opt.guicursor = "n-v-c-i:block"
-- Keybindings
vim.keymap.set("n", "<leader><leader>", ":lua Snacks.dashboard.pick('files')<CR>")
vim.keymap.set("n", "<leader>t", ":terminal<CR>")
vim.keymap.set("n", "<leader>l", ":%<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
