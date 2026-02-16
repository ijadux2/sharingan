return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			transparent_background = true,
			term_colors = true,
			-- Corrected: Moved these out of the "opts" nest
			custom_highlights = function(colors)
				return {
					-- Applying the undercurls you wanted via custom highlights
					DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
					DiagnosticUnderlineHint = { sp = colors.teal, undercurl = true },
					DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },
					DiagnosticUnderlineInfo = { sp = colors.sky, undercurl = true },
				}
			end,
			color_overrides = {
				mocha = {
					base = "#181425",
					mantle = "#161320",
					crust = "#110f1a",
					surface0 = "#2d2a3e",
					text = "#cdd6f4",
					subtext0 = "#a69db1",
					lavender = "#b4befe",
					mauve = "#cba6f7",
					sapphire = "#89dceb",
					blue = "#89b4fa",
				},
			},
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				oil = true,
				dashboard = true,
				flash = true,
				fzf = true,
				gitsigns = true,
				grug_far = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				lazy = true,
				leap = true,
				mason = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				snacks = true,
				telescope = { enabled = true },
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
