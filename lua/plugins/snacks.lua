return {
	"folke/snacks.nvim",
	priority = 999,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		picker = {
			enabled = true,
			hidden = true, -- shows dotfiles
			ignored = true, -- show ignored files
			exclude = { ".git" }, -- exclude .git directory
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
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
 
this is not the power of your creation
          ]],
				keys = {
					{ icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "f",
						desc = "Find file",
						action = ":lua Snacks.dashboard.pick('files')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},

					{ icon = " ", key = "c", desc = "Settings", action = ":e $MYVIMRC" },
					{ icon = "󰈆 ", key = "q", desc = "Quit", action = ":qa" },
					{ icon = "󰏗 ", key = "l", desc = "lazy", action = ":Lazy" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
			animate = {
				enabled = true,
				fps = 60,
				easing = "outCubic",
			},
		},
		notifier = {
			enabled = true,
			timeout = 3000,
			style = "fancy",
			icons = {
				error = "",
				warn = "",
				info = "",
				debug = "",
				trace = "󱕆",
			},
			top_down = true,
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
		-- Set snacks.nvim as the default notify handler
		vim.notify = require("snacks").notifier.notify

		-- Open dashboard on startup with error handling
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 0 then
					local ok, err = pcall(require("snacks").dashboard)
					if not ok then
						vim.notify("Error opening dashboard: " .. tostring(err), vim.log.levels.ERROR)
					end
				end
			end,
		})
	end,
}
