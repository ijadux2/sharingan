return {
	{
		"laytan/cloak.nvim",
		config = function()
			require("cloak").setup({
				enabled = true,
				cloak_character = "*",
				-- The highlight group to use for the masking
				highlight_group = "Comment",
				patterns = {
					{
						-- Match any file starting with '.env'
						file_pattern = ".env*",
						-- Match everything after the = sign and replace with asterisks
						cloak_pattern = "=.+",
					},
				},
			})
		end,
	},
}
