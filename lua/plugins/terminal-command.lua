vim.api.nvim_create_user_command("Shell", function(opts)
	local cmd = opts.args
	-- Default to zsh if no specific command is provided
	local shell_cmd = cmd ~= "" and cmd or "zsh"

	-- 1. Create a scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- 2. Calculate dimensions for a centered window
	local width = math.ceil(vim.o.columns * 0.8)
	local height = math.ceil(vim.o.lines * 0.8)
	local row = math.ceil((vim.o.lines - height) / 2 - 1)
	local col = math.ceil((vim.o.columns - width) / 2)

	-- 3. Open the floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " " .. (cmd ~= "" and "Exec: " .. cmd or "zsh") .. " ",
		title_pos = "center",
	})

	-- 4. Launch the process
	-- Using 'zsh -c' for one-liners ensures your zsh aliases/environment are used
	local exec_args
	if cmd ~= "" then
		exec_args = { "zsh", "-c", cmd }
	else
		exec_args = { "zsh" }
	end

	vim.fn.termopen(exec_args, {
		cwd = vim.fn.getcwd(),
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then
				print("Process exited with error code: " .. exit_code)
			end
		end,
	})

	-- 5. Terminal behavior & Keymaps
	vim.cmd("startinsert")

	-- Press 'q' in Normal Mode to close the window
	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, silent = true })
end, {
	nargs = "*",
	complete = "shellcmd",
	desc = "Run zsh command or interactive shell in a float",
})
