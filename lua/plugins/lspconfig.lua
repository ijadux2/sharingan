return {
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
}