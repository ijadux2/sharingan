return {
	"neovim/nvim-lspconfig",

	opts = {
		servers = {
			-- Shell
			bashls = {},

			-- C / C++
			clangd = {
				cmd = { "clangd", "--background-index", "--clang-tidy" },
			},

			-- Lua (Neovim)
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			},
			-- Web / React / TypeScript
			ts_ls = {
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},
			cssls = {},
			tailwindcss = {},
			html = {},
			jsonls = {},

			-- Data / Config
			yamlls = {},

			-- Docs
			marksman = {},
			markdown_oxide = {},

			-- Build systems
			mesonlsp = {},

			-- Scripting
			vimls = {},
			powershell_es = {},

			-- Zig
			zls = {},

			-- Rust
			rust_analyzer = {},

			-- Go
			gopls = {},
		},
	},

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
					runtime = {
						-- Tell the language server which version of Lua you're using
						version = "LuaJIT",
					},
					diagnostics = {
						-- Recognizes 'vim' for Neovim and 'love' for LÖVE 2D
						globals = { "vim", "love" },
						disable = { "different-requires" },
					},
					completion = {
						callSnippet = "Replace",
						keywordSnippet = "Replace",
					},
					workspace = {
						-- Logic to pull in Neovim APIs and Love2D libraries
						library = {
							vim.env.VIMRUNTIME,
							-- This includes your config and the 3rd party Love2D lib
							"${3rd}/love2d/library",
							vim.fn.stdpath("config") .. "/lua",
						},
						-- Prevent the LSP from getting overwhelmed by large libraries
						maxPreload = 3000,
						preloadFileSize = 1000,
						checkThirdParty = false,
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
