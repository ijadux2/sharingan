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
	config = function(_, opts)
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		for server, server_opts in pairs(opts.servers) do
			local config = vim.tbl_deep_extend("force", {
				capabilities = capabilities,
			}, server_opts)
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end
	end,
}
