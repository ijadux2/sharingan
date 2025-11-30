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
	-- Treesitter for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "python", "zig", "nix", "nu", "bash", "fish", "html", "css" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
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
					root_folder_label = false,
					highlight_git = true,
					highlight_opened_files = "name",
					special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },
					icons = {
						webdev_colors = true,
						git_placement = "before",
						modified_placement = "after",
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
							modified = true,
						},
						glyphs = {
							default = "󰈚",
							symlink = "",
							bookmark = "󰆤",
							modified = "●",
							folder = {
								arrow_closed = "",
								arrow_open = "",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
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

	-- ToggleTerm for terminal support
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup()
		end,
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({
				signs = true,
				sign_priority = 8,
				keywords = {
					FIX = {
						icon = " ",
						color = "error",
						alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
					},
					TODO = {
						icon = " ",
						color = "info",
					},
					HACK = {
						icon = " ",
						color = "warning",
					},
					WARN = {
						icon = " ",
						color = "warning",
						alt = { "WARNING", "XXX" },
					},
					PERF = {
						icon = "󰅒 ",
						color = "default",
						alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
					},
					NOTE = {
						icon = "󰍨 ",
						color = "hint",
						alt = { "INFO" },
					},
					TEST = {
						icon = "󰙨 ",
						color = "test",
						alt = { "TESTING", "PASSED", "FAILED" },
					},
					DEPRECATED = {
						icon = " ",
						color = "warning",
						alt = { "DEPRECATED" },
					},
					SECURITY = {
						icon = "󰒃 ",
						color = "error",
						alt = { "SECURITY", "VULN", "VULNERABILITY" },
					},
					DOC = {
						icon = "󰈙 ",
						color = "hint",
						alt = { "DOCS", "DOCUMENTATION" },
					},
					REFACTOR = {
						icon = "󰑖 ",
						color = "info",
						alt = { "REFACTOR", "CLEANUP" },
					},
					COMMENT = {
						icon = "󰆉 ",
						color = "default",
						alt = { "COMMENT" },
					},
				},
				gui_style = {
					fg = "BOLD",
					bg = "BOLD",
				},
				merge_keywords = true,
				highlight = {
					multiline = true,
					multiline_pattern = "^.",
					multiline_context = 10,
					before = "",
					keyword = "wide",
					after = "fg",
					pattern = [[.*<(KEYWORDS)\s*:]],
					comments_only = true,
					max_line_len = 400,
					exclude = {},
				},
				colors = {
					error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
					warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
					info = { "DiagnosticInfo", "#2563EB" },
					hint = { "DiagnosticHint", "#10B981" },
					default = { "Identifier", "#7C3AED" },
					test = { "Identifier", "#FF00FF" },
				},
				search = {
					command = "rg",
					args = {
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
					},
					pattern = [[(KEYWORDS):]],
				},
			})
			-- Set up keybindings for todo-comments
			vim.keymap.set("n", "<leader>td", ":TodoTelescope<CR>", { desc = "Todo Telescope" })
			vim.keymap.set("n", "<leader>tq", ":TodoQuickFix<CR>", { desc = "Todo QuickFix" })
			vim.keymap.set("n", "]t", function()
				require("todo-comments").jump_next()
			end, { desc = "Next todo comment" })
			vim.keymap.set("n", "[t", function()
				require("todo-comments").jump_prev()
			end, { desc = "Previous todo comment" })
		end,
	},

	-- Nvim notify
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				-- Animation style
				stages = "fade",
				-- Default timeout
				timeout = 3000,
				-- Max width for messages
				max_width = 50,
				-- Max height for messages
				max_height = 10,
				-- Render function
				render = "compact",
				-- Icons for notification levels
				icons = {
					ERROR = "",
					WARN = "",
					INFO = "",
					DEBUG = "",
					TRACE = "󰆉",
				},
				-- Notification placement
				top_down = true,
				-- Minimum width
				minimum_width = 30,
				-- Background opacity
				background_colour = "#000000",
				-- FPS for animations
				fps = 60,
				-- Level-specific timeouts
				level = vim.log.levels.INFO,
				-- on_open callback
				on_open = function(win)
					vim.api.nvim_win_set_config(win, { border = "rounded" })
				end,
			})
			vim.notify = require("notify")
			-- Keybinding to dismiss all notifications
			vim.keymap.set("n", "<leader>nd", function()
				require("notify").dismiss({ silent = true, pending = true })
			end, { desc = "Dismiss notifications" })
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
 ▐ ▄ ▄▄▄ .       ▌ ▐·▪  • ▌ ▄ ·. 
•█▌▐█▀▄.▀·▪     ▪█·█▌██ ·██ ▐███▪
▐█▐▐▌▐▀▀▪▄ ▄█▀▄ ▐█▐█•▐█·▐█ ▌▐▌▐█·
██▐█▌▐█▄▄▌▐█▌.▐▌ ███ ▐█▌██ ██▌▐█▌
▀▀ █▪ ▀▀▀  ▀█▄▀▪. ▀  ▀▀▀▀▀  █▪▀▀▀
-- ijadux2
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

	-- Telescope for fuzzy finding (used in dashboard)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"chikko80/error-lens.nvim",
		event = "BufRead",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
	},

	-- Web devicons for icons
	"nvim-tree/nvim-web-devicons",

	--mini.ai
	{
		"nvim-mini/mini.ai",
		version = "*",
	},

	-- Which-key for command palette
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup()
		end,
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
					keyword_length = 1,
					completeopt = "menu,menuone,noinsert",
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "nvim_lsp_signature_help", priority = 800 },
					{ name = "luasnip", priority = 900 },
					{ name = "treesitter", priority = 700 },
					{ name = "path", priority = 550 },
				}, {
					{ name = "buffer", keyword_length = 0, priority = 650 },
				}),
				experimental = {
					ghost_text = true,
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
		version = "*",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		version = "*",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- Enable snippet support
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.completion.completionItem.resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			}

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "zls", "nil_ls", "html", "mesonlsp" },
				automatic_installation = true,
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({ capabilities = capabilities })
					end,
					lua_ls = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									diagnostics = {
										globals = { "love" },
									},
									workspace = {
										library = {
											["${3rd}/love2d/library"] = true,
										},
									},
								},
							},
						})
					end,
					mesonlsp = function()
						require("lspconfig").mesonlsp.setup({
							capabilities = capabilities,
							filetypes = { "meson" },
							root_dir = require("lspconfig").util.root_pattern("meson.build", "meson_options.txt"),
						})
					end,
				},
			})
		end,
	},

	-- using lazy.nvim
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
-- Basic Neovim settings
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
-- Keybindings
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
