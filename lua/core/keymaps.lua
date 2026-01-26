-- General keybindings

-- snacks.nvim
vim.keymap.set("n", "<leader><leader>", ":lua Snacks.dashboard.pick('files')<CR>")
vim.keymap.set("n", "<leader>g", ":lua Snacks.picker.grep()<CR>", { desc = "Live grep" })
vim.keymap.set(
	"n",
	"<leader>l",
	":lua Snacks.picker.lsp_definitions(opts)<CR>",
	{ desc = "Search LSP workspace symbols" }
)
vim.keymap.set("n", "<leader>t", function()
	require("snacks").terminal()
end, { desc = "Split terminal" })
vim.keymap.set("n", "<leader>h", ":lua Snacks.picker.colorschemes(opts)<CR>")
vim.keymap.set("n", "<C-c>", ":lua Snacks.picker.command_history(opts)<CR>")
vim.keymap.set("n", "<S-r>", ":lua Snacks.picker.recent(opts)<CR>")
vim.keymap.set("n", "<leader>d", ":lua Snacks.picker.diagnostics(opts)<CR>")

-- navigation
vim.keymap.set("n", "<S-s>", "50k")
vim.keymap.set("n", "<S-d>", "50j")

-- Bufferline navigation
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

-- Comment.nvim keybindings
vim.keymap.set("v", "<leader>c", function()
	require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment for selection" })

vim.keymap.set("n", "<leader>.", ":source %<CR>")
