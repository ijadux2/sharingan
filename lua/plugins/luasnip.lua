return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local luasnip = require("luasnip")
		-- Load VSCode-style snippets
		require("luasnip.loaders.from_vscode").lazy_load()
		-- Load snippets from snipmate format
		require("luasnip.loaders.from_snipmate").lazy_load()
		-- LuaSnip configuration
		luasnip.config.set_config({
			history = true,
			update_events = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})
	end,
}