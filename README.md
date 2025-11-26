# Neovim Configuration

A modern, feature-rich Neovim configuration with Lazy as the package manager, Catppuccin Mocha theme, and comprehensive tooling for development.

## Preview

![Screenshot](screenshot_20251126_204707.png)

## Features

- **Package Manager**: Lazy.nvim for efficient plugin management
- **Theme**: Catppuccin Mocha with integrated theming for plugins
- **Syntax Highlighting**: Tree-sitter for Lua, Python, Zig, Nix, and Nu
- **File Manager**: nvim-tree with toggle key `\`
- **Statusline**: lualine with rounded separators
- **Dashboard**: alpha-nvim with custom banner
- **Autocompletion**: nvim-cmp with LSP, snippets, and buffer completion
- **Snippets**: LuaSnip with friendly-snippets
- **LSP Support**: Mason-managed LSP servers for Lua (with Love2D), Python, Zig, and Nix
- **Command Palette**: which-key for keybinding hints
- **Leader Key**: Space

## Installation

1. Ensure Neovim 0.9+ is installed
2. Backup your existing Neovim config if any: `mv ~/.config/nvim ~/.config/nvim.bak`
3. Copy `init.lua` to `~/.config/nvim/init.lua`
4. Launch Neovim: `nvim`
5. Lazy will automatically install all plugins and LSP servers

## Keybindings

- `<Space>`: Leader key (shows which-key menu)
- `\`: Toggle nvim-tree file explorer
- `<C-Space>`: Trigger autocompletion
- `<CR>`: Confirm completion selection

## LSP Servers

The following LSP servers are automatically installed and configured:

- **lua_ls**: Lua with Love2D support
- **pyright**: Python
- **zls**: Zig
- **nil_ls**: Nix

## Customization

The entire configuration is contained in a single `init.lua` file for easy modification. Edit the file to add/remove plugins or change settings.

## Requirements

- Neovim 0.9 or later
- Git
- curl (for downloading plugins)

## Troubleshooting

If plugins fail to install, ensure you have internet access and git is properly configured.

For LSP issues, check `:Mason` to verify server installation.

## License

This configuration is provided as-is for personal use.