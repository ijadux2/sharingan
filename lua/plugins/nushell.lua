return {
	"LhKipp/nvim-nu",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	ft = { "nu" },
	config = function()
		require("nu").setup({
			use_lsp_features = false,
			-- Register nu files as nushell
			all_cmd_names = [[^#\s*script-execution-hash\s*.*$\n]],
		})
	end,
}