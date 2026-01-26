# Neovim Configuration

A modern Neovim configuration using the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager with a focus on productivity and aesthetics.

## 🎨 Features

- **Theme**: Catppuccin (Mocha flavor) with transparent background support
- **Plugin Manager**: lazy.nvim for fast and efficient plugin management
- **LSP**: Full Language Server Protocol support with Mason for easy installation
- **Completion**: nvim-cmp with snippet support via LuaSnip
- **File Explorer**: nvim-tree.lua for intuitive file navigation
- **Status Line**: lualine.nvim for a beautiful status bar
- **Git Integration**: gitsigns.nvim for git decorations and operations
- **Session Management**: auto-session with session-lens for workspace persistence
- **Dashboard**: Snacks.nvim dashboard for quick access to recent files and sessions
- **Linting & Formatting**: nvim-lint and conform.nvim for code quality
- **Terminal**: Built-in terminal support with keybindings
- **Markdown**: Preview support with markdown-preview.nvim

## 📁 Structure

```
.
├── init.lua                    # Entry point - bootstraps lazy.nvim and loads modules
├── keybind.md                  # Comprehensive keybinding documentation
├── lazy-lock.json             # Plugin lock file for reproducible builds
└── lua/
    ├── core/
    │   ├── keymaps.lua        # Global key mappings
    │   └── options.lua        # Neovim options and settings
    └── plugins/
        ├── autopairs.lua      # Auto-close brackets, quotes, etc.
        ├── bufferline.lua     # Buffer tabs
        ├── catppuccin.lua     # Theme configuration
        ├── cmp.lua            # Completion configuration
        ├── comment.lua        # Toggle comments
        ├── conform.lua        # Code formatting
        ├── gitsigns.lua       # Git integration
        ├── indent-blankline.lua # Indentation guides
        ├── lazydev.lua        # Lua development
        ├── lint.lua           # Linting configuration
        ├── love2d.lua         # LÖVE development support
        ├── lspconfig.lua      # LSP configuration
        ├── lualine.lua        # Status line
        ├── luasnip.lua        # Snippet engine
        ├── markdown.lua       # Markdown preview
        ├── mason-lspconfig.lua # LSP server management
        ├── mason.lua          # Package manager for LSP tools
        ├── mini.lua           # Mini.nvim utilities
        ├── noice.lua          # UI improvements
        ├── nvim-tree.lua      # File explorer
        ├── snacks.lua         # Dashboard and utilities
        └── treesitter.lua     # Syntax highlighting
```

## 🚀 Quick Start

1. **Install Neovim** (v0.9.0+)
2. **Backup** your existing Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```
3. **Clone** this repository:
   ```bash
   git clone https://github.com/ijadux2/nvim-for-me.git ~/.config/nvim
   ```
4. **Launch** Neovim - lazy.nvim will automatically install all plugins:
   ```bash
   nvim
   ```

## ⚙️ Requirements

- **Neovim**: v0.9.0 or higher
- **Git**: Required for plugin installation
- **Nerd Font**: JetBrainsMono Nerd Font (configured in options.lua)

## 🔧 Key Bindings

All keybindings are documented in `keybind.md`. Here are the most important ones:

### General

- `<leader><leader>` - Open file picker
- `<leader>t` - Open terminal
- `<leader>e` - Open file explorer
- `\` - Toggle NvimTree

### LSP

- `gd` - Go to definition
- `gr` - Go to references
- `K` - Show documentation
- `<leader>ca` - Code actions

### Session Management

- `<leader>ss` - Search sessions
- `<leader>sl` - Load session
- `<leader>sn` - Save current session

## 🎯 Highlights

### Custom Configuration

- **Leader key**: Set to `<Space>` for ergonomic access
- **Line numbers**: Both absolute and relative enabled
- **Clipboard**: System clipboard integration
- **Diagnostics**: Configured to show warnings and errors (no spelling hints)
- **Netrw**: Configured for tree-like file browsing

### Language Support

- **Lua Development**: lazydev.nvim for Neovim plugin development
- **LÖVE 2D**: love2d.nvim for game development
- **General**: Treesitter provides syntax highlighting for most languages

### Performance Optimizations

- **Lazy loading**: All plugins load on-demand
- **Lock file**: Ensures reproducible plugin versions
- **Minimal startup**: Only essential configurations loaded initially

## 📚 Documentation

- **Full Keybinding Reference**: See `keybind.md` for complete documentation
- **Plugin Documentation**: Each plugin file contains inline documentation
- **Configuration Details**: Comments in `lua/core/options.lua` explain each setting

## 🛠️ Maintenance

- **Update plugins**: Run `:Lazy` to update all plugins
- **Check health**: Run `:checkhealth` to verify installation
- **Clean lock file**: Remove `lazy-lock.json` to regenerate with latest plugin versions

## 🤝 Contributing

Feel to fork, modify, and adapt this configuration to your needs. This is designed as a solid foundation for a productive Neovim setup.

## 📄 License

This configuration is provided as-is for educational and personal use. Feel free to adapt it for your own workflow.
