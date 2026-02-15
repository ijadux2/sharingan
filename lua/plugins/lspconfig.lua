return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
	},
	opts = {
		servers = {
			bashls = {},
			clangd = {
				cmd = { "clangd", "--background-index", "--clang-tidy" },
			},
			ts_ls = {},
			cssls = {},
			tailwindcss = {},
			html = {},
			jsonls = {},
			yamlls = {},
			marksman = {},
			markdown_oxide = {},
			mesonlsp = {},
			vimls = {},
			powershell_es = {},
			zls = {},
			rust_analyzer = {},
			gopls = {},
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = { vim.env.VIMRUNTIME },
						},
					},
				},
			},
		},
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
		})
	end,
}
