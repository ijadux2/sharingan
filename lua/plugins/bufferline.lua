return {
	"akinsho/bufferline.nvim",
	enabled = true,
	event = "BufReadPost",
	opts = {
		options = {
			mode = "buffers",
			numbers = "none",
			close_command = "bdelete! %d",
			right_mouse_command = "bdelete! %d",
			left_mouse_command = "buffer %d",
			indicator = { icon = "▎" },
			buffer_close_icon = "󰅖",
			modified_icon = "●",
			close_icon = "",
			left_trunc_marker = "",
			right_trunc_marker = "",
			max_name_length = 18,
			max_prefix_length = 15,
			tab_size = 18,
			diagnostics = "nvim_lsp",
			show_buffer_icons = true,
			show_buffer_close_icons = true,
			show_close_icon = false,
			show_tab_indicators = true,
			separator_style = "thin",
			always_show_bufferline = true,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "left",
					separator = true,
				},
			},
		},
	},
	config = function(_, opts)
		if (vim.g.colors_name or ""):find("catppuccin") then
			opts.highlights = require("catppuccin.special.bufferline").get_theme()
		end
		require("bufferline").setup(opts)
	end,
}