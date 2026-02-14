-- General keybindings

-- Application Launcher
vim.keymap.set("n", "<leader>a", function()
	require("app-launcher").pick()
end, { desc = "Application Launcher" })
vim.keymap.set("n", "<M-p>", function()
	require("app-launcher").pick()
end, { desc = "Application Launcher (Alt+p)" })

-- Web Search
vim.keymap.set("n", "<leader>s", function()
	require("web-search").search()
end, { desc = "Web Search" })
vim.keymap.set("n", "<M-s>", function()
	require("web-search").search()
end, { desc = "Web Search (Alt+s)" })

-- Screenshot
vim.keymap.set("n", "<leader>ps", function()
	require("screenshot").pick()
end, { desc = "Screenshot" })
vim.keymap.set("n", "<M-p><M-s>", function()
	require("screenshot").capture_window()
end, { desc = "Quick Screenshot (Window)" })

vim.keymap.set("n", "<leader>g", ":lua Snacks.picker.grep()<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>t", function()
	require("snacks").terminal()
end, { desc = "Split terminal" })
vim.keymap.set("n", "<leader>h", ":lua Snacks.picker.colorschemes(opts)<CR>")
vim.keymap.set("n", "<C-c>", ":lua Snacks.picker.command_history(opts)<CR>")
vim.keymap.set("n", "<S-r>", ":lua Snacks.picker.recent(opts)<CR>")
vim.keymap.set("n", "<leader>d", ":lua Snacks.picker.diagnostics(opts)<CR>")

-- navigation
vim.keymap.set("n", "<S-s>", "24k")
vim.keymap.set("n", "<S-d>", "24j")

-- Bufferline navigation
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>.", ":source %<CR>")
-- command_history
vim.keymap.set("n", "<S-l>", ":Shell<CR>")
vim.keymap.set("n", "<C-q>", ":wqa<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>")
-- oil.nvim
-- vim.keymap.set("n", "<C-q>", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- shell commands
vim.keymap.set("n", "<s-b>", ":Shell ", { desc = "Shell Command" })
vim.keymap.set("n", "<C-x>", ":cd ", { desc = "chnage dir" })
