return {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"html",
				"cssls",
				"jsonls",
				"yamlls",
				"bashls",
				"mesonlsp",
				"ts_ls",
				"tailwindcss",
				"rust_analyzer",
			},
		})
	end,
}
