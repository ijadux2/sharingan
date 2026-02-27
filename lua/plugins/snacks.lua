return {
	"folke/snacks.nvim",
	priority = 999,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		picker = {
			enabled = true,
			hidden = true,
			ignored = true,
			exclude = { ".git" },
			sources = {
				files = {
					enabled = true,
					exclude = { ".git" },
				},
				oldfiles = { enabled = true },
			},
		},
		dashboard = {
			enabled = true,
			preset = {
				header = [[
╭────────────────────────────────────────────────────────────╮
│  ╭─╮╭─╮                                                    │
│  ╰─╯╰─╯  Sharingan.nvim  v0.0.1                            │
│  █ ▘▝ █  built to defeat emacs :} hehe                     │
│   ▔▔▔▔                                                     │
│  this is not the power of your creation                    │
│  built by ijadux2 {kumar}                                  │
╰────────────────────────────────────────────────────────────╯
]],
				keys = {
					{ icon = "󰈆 ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
					{ icon = "󰈔 ", key = "r", desc = "Recent", action = ":lua Snacks.picker.oldfiles()" },
					{ icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.picker.grep()" },
					{ icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
					{ icon = " ", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
			},
		},
		notifier = {
			enabled = true,
			timeout = 3000,
		},
	},
	config = function(_, opts)
		if require("snacks").config._did_setup then
			return
		end
		require("snacks").setup(opts)
		vim.notify = require("snacks").notifier.notify

		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = function()
				if vim.fn.argc() == 0 then
					pcall(require("snacks").dashboard)
				end
			end,
		})
	end,
}
