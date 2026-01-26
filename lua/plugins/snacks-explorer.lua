return {
	{ "echasnovski/mini.icons", version = false },
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			explorer = {
				enabled = true,
				git = {
					status = false, -- Hides the [M], [A], [U] indicators
				},
				win = {
					inner = {
						border = "rounded", -- Options: "none", "single", "double", "rounded"
						title = " Explorer ",
						title_pos = "center",
					},
				},
			},
			picker = {
				enabled = true,
				ui_select = true,
				win = {
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
						},
					},
				},
				icons = {
					enabled = true,
					files = { enabled = true },
					dirs = { enabled = true },
				},
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)
			-- Set up mini.icons for snacks
			require("mini.icons").setup()
			vim.keymap.set("n", "\\", function()
				require("snacks").explorer()
			end, { desc = "File Explorer" })
		end,
	},
}
