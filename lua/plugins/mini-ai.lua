return {
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		config = function()
			local ai = require("mini.ai")

			ai.setup({
				n_lines = 500,
				custom_textobjects = {
					-- Code blocks
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),

					-- Function
					f = ai.gen_spec.treesitter({
						a = "@function.outer",
						i = "@function.inner",
					}),

					-- Class
					c = ai.gen_spec.treesitter({
						a = "@class.outer",
						i = "@class.inner",
					}),

					-- HTML / XML tags
					t = {
						"<([%p%w]-)%f[^<%w][^<>]->.-</%1>",
						"^<.->().*()</[^/]->$",
					},

					-- Digits
					d = { "%f[%d]%d+" },

					-- Word with case
					e = {
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},

					-- Whole buffer (SAFE replacement for LazyVim.mini.ai_buffer)
					g = function()
						return { from = { line = 1, col = 1 }, to = { line = vim.fn.line("$"), col = math.huge } }
					end,

					-- Function call (usage)
					u = ai.gen_spec.function_call(),

					-- Function call without dot
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
				},
			})
		end,
	},
}
