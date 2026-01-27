return {
	{
		"none",
		virtual = true,
		config = function()
			vim.api.nvim_create_user_command("Shell", function(opts)
				local cmd = opts.args
				local buf = vim.api.nvim_create_buf(false, true)

				-- Dimensions: Narrower and at the bottom to mimic the "command section"
				local width = math.ceil(vim.o.columns * 0.9)
				local height = cmd == "" and math.ceil(vim.o.lines * 0.8) or 10
				local row = vim.o.lines - height - 3
				local col = math.ceil((vim.o.columns - width) / 2)

				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = width,
					height = height,
					row = row,
					col = col,
					style = "minimal",
					border = "rounded",
					title = " " .. (cmd ~= "" and "  " .. cmd or " Zsh ") .. " ",
					title_pos = "left",
				})

				-- Setup terminal
				local exec_args = cmd ~= "" and { "zsh", "-c", cmd } or { "zsh" }

				vim.fn.termopen(exec_args, {
					cwd = vim.fn.getcwd(),
					on_exit = function(_, code)
						if code == 0 and cmd ~= "" then
							-- Optional: Auto-close on successful one-line commands
							-- vim.api.nvim_win_close(win, true)
						end
					end,
				})

				-- Keybind to close the window with 'q' or 'Esc' in normal mode
				vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
				vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true })

				vim.cmd("startinsert")
			end, {
				nargs = "*",
				complete = "shellcmd",
			})

			-- KEYBIND: Pressing 'i' usually enters insert mode,
			-- -- but if you want a shortcut to open this shell:
			vim.keymap.set("n", "<leader>i", ":Shell ", { desc = "Shell Command" })
		end,
	},
}
