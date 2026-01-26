-- General keybindings
vim.keymap.set("n", "<leader><leader>", ":lua Snacks.dashboard.pick('files')<CR>")
vim.keymap.set("n", "<leader>t", ":terminal<CR>")
vim.keymap.set("n", "<leader>l", ":%<CR>")
vim.keymap.set("n", "<S-s>", "30k")
vim.keymap.set("n", "<S-d>", "30j")

-- LSP keybindings and setup
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	end,
})

-- Bufferline navigation
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

-- Comment.nvim keybindings
vim.keymap.set("v", "<leader>c", function()
	require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment for selection" })

-- Session management keybindings
vim.keymap.set("n", "<leader>ss", ":SessionSearch<CR>", { desc = "Search sessions" })
vim.keymap.set("n", "<leader>sl", ":SessionLoad<CR>", { desc = "Load session" })
vim.keymap.set("n", "<leader>sd", ":SessionDelete<CR>", { desc = "Delete session" })
vim.keymap.set("n", "<leader>sr", ":SessionRestore<CR>", { desc = "Restore last session" })
vim.keymap.set("n", "<leader>sn", ":SessionSave<CR>", { desc = "Save current session" })

