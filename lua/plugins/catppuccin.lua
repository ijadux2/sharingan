return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = false,
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
}

