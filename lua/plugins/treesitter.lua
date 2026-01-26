return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	version = false, -- last release is way too old and doesn't work on Windows
	build = function()
		local TS = require("nvim-treesitter")
		if not TS.get_installed then
			vim.notify(
				"Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.",
				vim.log.levels.ERROR
			)
			return
		end
		-- make sure we're using the latest treesitter util
		package.loaded["nvim-treesitter"] = nil
		TS.update(nil, { summary = true })
	end,
	event = { "BufReadPost", "BufNewFile", "VeryLazy" },
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
	opts_extend = { "ensure_installed" },
	opts = {
		-- LazyVim config for treesitter
		skip_install = true,
		indent = { enable = true },
		highlight = { enable = true },
		folds = { enable = true },
		ensure_installed = {
			"bash",
			"c",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"python",
			"toml",
			"vim",
			"yaml",
			"css",
		},
	},
	config = function(_, opts)
		local TS = require("nvim-treesitter")

		-- some quick sanity checks
		if not TS.get_installed then
			return vim.notify("Please use `:Lazy` and update `nvim-treesitter`", vim.log.levels.ERROR)
		elseif type(opts.ensure_installed) ~= "table" then
			return vim.notify("`nvim-treesitter` opts.ensure_installed must be a table", vim.log.levels.ERROR)
		end

		-- setup treesitter
		TS.setup(opts)

		-- install missing parsers
		local install = vim.tbl_filter(function(lang)
			return not pcall(require, "nvim-treesitter.parsers." .. lang)
		end, opts.ensure_installed or {})
		if #install > 0 then
			vim.defer_fn(function()
				TS.install(install, { summary = true })
			end, 100)
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
			callback = function(ev)
				local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
				if not pcall(require, "nvim-treesitter.parsers." .. ft) then
					return
				end

				---@param feat string
				---@param query string
				local function enabled(feat, query)
					local f = opts[feat] or {}
					return f.enable ~= false
						and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
						and pcall(require, "nvim-treesitter.parsers." .. ft)
				end

				-- highlighting
				if enabled("highlight", "highlights") then
					pcall(vim.treesitter.start, ev.buf)
				end

				-- indents
				if enabled("indent", "indents") then
					vim.opt_local.indentexpr = "nvim_treesitter#indent()"
				end

				-- folds
				if enabled("folds", "folds") then
					if vim.opt_local.foldmethod:get() ~= "expr" then
						vim.opt_local.foldmethod = "expr"
						vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
					end
				end
			end,
		})
	end,
}
