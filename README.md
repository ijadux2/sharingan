# 🚀 nvim-for-me

A collection of Neovim configurations with two distinct setups:

1. **LazyVim Base** - A feature-rich configuration built on LazyVim
2. **Standalone** - A minimal, self-contained configuration

## 📁 Repository Structure

```
nvim-for-me/
├── lazyvim_base/          # LazyVim-based configuration
│   ├── init.lua          # Entry point
│   ├── lua/
│   │   ├── config/       # Core configuration files
│   │   │   ├── autocmds.lua
│   │   │   ├── keymaps.lua
│   │   │   ├── lazy.lua
│   │   │   └── options.lua
│   │   └── plugins/      # Plugin configurations
│   │       ├── catppuccin.lua
│   │       ├── lsp.lua
│   │       ├── lualine.lua
│   │       ├── mason.lua
│   │       ├── snacks.lua
│   │       ├── treesitter.lua
│   │       └── ...
│   ├── README.md         # Detailed LazyVim README
│   └── ...
└── standalone/           # Modular standalone configuration
    ├── init.lua         # Entry point with core setup
    ├── lua/
    │   ├── core/        # Core configuration
    │   │   ├── keymaps.lua
    │   │   └── options.lua
    │   └── plugins/     # Individual plugin configs
    │       ├── autopairs.lua
    │       ├── bufferline.lua
    │       ├── catppuccin.lua
    │       ├── cmp.lua
    │       ├── comment.lua
    │       ├── conform.lua
    │       ├── gitsigns.lua
    │       ├── indent-blankline.lua
    │       ├── lazydev.lua
    │       ├── lint.lua
    │       ├── love2d.lua
    │       ├── lspconfig.lua
    │       ├── lualine.lua
    │       ├── luasnip.lua
    │       ├── markdown.lua
    │       ├── mason.lua
    │       ├── mason-lspconfig.lua
    │       ├── mini.lua
    │       ├── noice.lua
    │       ├── nvim-tree.lua
    │       ├── snacks.lua
    │       └── treesitter.lua
    ├── keybind.md        # Keybinding documentation
    └── lazy-lock.json    # Plugin lockfile
```

## 🔧 Configurations

### LazyVim Base
Built on top of [LazyVim](https://github.com/LazyVim/LazyVim) with extensive customizations:

- **Theme**: Catppuccin with transparent background
- **LSP**: Full language server support with Mason
- **Game Dev**: LÖVE2D integration
- **UI**: Custom dashboard, status line, and file explorer
- **Tools**: Linting, formatting, completion, and snippets

**Installation**: See [lazyvim_base/README.md](./lazyvim_base/README.md)

### Standalone
A modular, well-organized configuration perfect for:

- Quick setups on new machines
- Learning Neovim configuration structure
- Customizable editing environments
- Understanding plugin management

**Features**:
- Modular architecture with separate config files
- Essential plugins (Treesitter, LSP, completion)
- Catppuccin theme with multiple variants
- Full LSP support with Mason
- File explorer (NvimTree)
- LÖVE2D game development support
- Advanced UI components (bufferline, lualine, noice)
- Code quality tools (linting, formatting)
- Git integration (gitsigns)
- Snippet support (LuaSnip)
- Markdown editing enhancements

**Installation**:
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Copy standalone config
cp -r standalone ~/.config/nvim

# Launch Neovim
nvim
```

## 🎮 Common Features

Both configurations include:

- **LÖVE2D Support**: Game development tools with keybindings:
  - `<leader>v` - LÖVE2D menu (Lua files)
  - `<leader>vv` - Run LÖVE2D project
  - `<leader>vs` - Stop LÖVE2D project

- **Catppuccin Theme**: Soothing pastel colors with multiple flavor options

- **Modern Development Stack**:
  - LSP with Mason for language server management
  - Intelligent completion with nvim-cmp
  - Syntax highlighting with Treesitter
  - Code formatting and linting
  - Git integration with Gitsigns

- **Enhanced UI**: Buffer lines, status bars, and notification systems

## 🚀 Getting Started

1. Choose your configuration:
   - **LazyVim Base** for full-featured development
   - **Standalone** for minimal setup

2. Follow the installation instructions for your chosen config

3. Customize as needed by editing the relevant files

## 🛠️ Customization

### LazyVim Base
- Edit files in `lua/config/` for core settings
- Add plugins in `lua/plugins/`
- Modify keymaps in `lua/config/keymaps.lua`

### Standalone
- Edit core settings in `lua/core/` (options.lua, keymaps.lua)
- Add/modify plugins in `lua/plugins/` (individual plugin files)
- Each plugin has its own configuration file for easy management

## 📚 Learn More

- [LazyVim Documentation](https://lazyvim.github.io/installation)
- [Neovim Documentation](https://neovim.io/doc/)
- [Catppuccin Theme](https://github.com/catppuccin/nvim)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [LÖVE2D Game Engine](https://love2d.org/)
- [Mason LSP Manager](https://github.com/williamboman/mason.nvim)

## 🔍 Key Reference

For detailed keybindings and configuration options, see `standalone/keybind.md` in the repository.

---

**Built with ❤️ for personalized Neovim experience**