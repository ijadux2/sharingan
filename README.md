# Sharingan - Neovim Configuration

> A highly customized Neovim configuration built on LazyVim, designed for a powerful and productive development experience on Linux with Wayland.

![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?style=flat&logo=neovim)
![Lua](https://img.shields.io/badge/Lua-5.1+-2C2D72?style=flat&logo=lua)
![LazyVim](https://img.shields.io/badge/LazyVim-15+-57A143?style=flat)

## Overview

Sharingan provides an enhanced "vision" for developers with:

- Application launcher
- Web search from within Neovim
- Fuzzy finding for files, buffers, commands, keymaps
- Git integration (branch switching, commits, log)
- System controls (power, media, brightness)
- Text-based web browser in Neovim
- Screenshot utilities
- Todo/notes viewer

## Requirements

- Neovim 0.10+
- Linux with Wayland
- [LazyVim](https://lazyvim.tech/) starter
- Dependencies: `w3m`, `grim`, `slurp`, `brightnessctl`, `wpctl`, `playerctl`, `maim`, `xclip`, `nmcli`, `rfkill`, `redshift`

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone Sharingan
git clone https://github.com/yourusername/sharingan ~/.config/nvim

# Open Neovim and let LazyVim install plugins
nvim
```

## Keybindings

| Keybinding            | Description          |
| --------------------- | -------------------- |
| `<leader>a` / `<M-p>` | Application Launcher |
| `<leader>s` / `<M-s>` | Web Search           |
| `<leader>gg`          | Git Picker           |
| `<leader>gb`          | Git Switch Branch    |
| `<leader>gc`          | Git Commit           |
| `<leader>gl`          | Git Log              |
| `<leader>f` / `<M-f>` | Fuzzy Finder         |
| `<leader>w`           | Text Browser (w3m)   |
| `<leader>td`          | Todo/Notes Viewer    |
| `<leader>sp`          | Screenshot           |
| `<leader>pm`          | Power Commands       |
| `<M-,>`               | Media Controls       |
| `<M-.>`               | Brightness           |

## Custom Plugins

### Application Launcher (`lua/app-launcher.lua`)

Scans `.desktop` files from standard locations (`/usr/share/applications`, `~/.local/share/applications`) and launches applications via a picker UI.

**Functions:**

- `pick()` - Opens application picker

### Web Search (`lua/web-search.lua`)

Search the web using various engines and open results in browser or text browser.

**Supported Engines:**

- DuckDuckGo
- Wikipedia
- YouTube
- GitHub
- Stack Overflow
- Reddit
- Web (minimal)
- Browse in Neovim (w3m)

**Functions:**

- `search()` - Opens search prompt and engine picker

### Fuzzy Finder (`lua/fuzzy.lua`)

Multi-purpose fuzzy finder for:

- Files (recursive search up to 4 levels)
- Git Files (untracked + git ls-files)
- Buffers (with filetype)
- Recent Files
- Commands
- Keymaps (Normal, Insert, Visual)
- Help Tags
- Grep (ripgrep)

**Functions:**

- `pick()` - Opens main fuzzy finder menu

### Git Integration (`lua/git.lua`, `lua/git-branch.lua`, `lua/git-commit.lua`)

**Functions:**

- `pick()` - Git picker menu
- `switch_branch()` - Switch between branches with stash support
- `commit()` - Commit changes to selected branch
- `log()` - View git log in floating window

### Power Commands (`lua/power-commands.lua`)

System controls via picker:

**Power:**

- Shutdown, Reboot, Sleep, Hibernate
- Lock Screen (hyprlock), Logout

**Media:**

- Play/Pause, Next, Previous, Stop
- Volume Up/Down, Mute/Unmute

**Brightness:**

- Brightness Up/Down

**Screenshot:**

- Full Screen, Selection, Copy to Clipboard

**System:**

- Toggle WiFi, Toggle Bluetooth
- Night Light (redshift), Reset Night Light
- Kill Wayland

**Functions:**

- `pick()` - Opens power commands menu
- `media()` - Opens media controls picker
- `brightness_pick()` - Opens brightness picker

### Todo/Notes Viewer (`lua/todo.lua`)

Opens a notes file in a floating window.

**Configuration:**

```lua
require("todo").setup({
    target_file = "~/notes/Markdowns/example.md",
    border = "single",
    width = 0.8,
    height = 0.8,
    position = "center",
}, "<leader>td")
```

**Functions:**

- `setup(opts, keybind)` - Configure todo viewer
- `open()` - Open with default options

### Screenshot (`lua/screenshot.lua`)

Screenshot capture using `grim` and `slurp`.

**Features:**

- Window/Selection/Fullscreen capture
- Save to file or copy to clipboard

**Functions:**

- `pick()` - Opens screenshot options
- `capture_window()`, `capture_selection()`, `capture_fullscreen()`
- `capture_window_clipboard()`, etc.

### Text Browser (`lua/text-browser.lua`)

w3m-based terminal web browser in Neovim.

**Functions:**

- `browse(url?)` - Open URL or prompt for URL
- `back()`, `forward()`, `reload()`, `home()`

## Plugins

| Plugin                    | Description                                     |
| ------------------------- | ----------------------------------------------- |
| **snacks.nvim**           | UI framework (picker, dashboard, notifications) |
| **telescope.nvim**        | Fuzzy finder                                    |
| **nvim-lspconfig**        | LSP client configuration                        |
| **mason.nvim**            | LSP server installer                            |
| **nvim-treesitter**       | Syntax highlighting                             |
| **conform.nvim**          | Code formatting                                 |
| **gitsigns.nvim**         | Git integration                                 |
| **noice.nvim**            | Notification UI                                 |
| **lualine.nvim**          | Statusline                                      |
| **bufferline.nvim**       | Buffer/tab management                           |
| **catppuccin**            | Color scheme (Mocha theme)                      |
| **mini.ai**               | textobject                                      |
| **mini.pairs**            | Auto-pairs                                      |
| **Comment.nvim**          | Commenting                                      |
| **indent-blankline.nvim** | Indentation guides                              |
| **LuaSnip**               | Snippets                                        |
| **nvim-cmp**              | Autocompletion                                  |
| **trouble.nvim**          | Diagnostics viewer                              |
| **yazi.nvim**             | File manager                                    |
| **oil.nvim**              | File explorer                                   |
| **which-key.nvim**        | Keybinding hints                                |
| **lazydev.nvim**          | Lazy.nvim helper                                |
| **plenary.nvim**          | Utility functions                               |
| **markdown.nvim**         | Markdown support                                |
| **image.nvim**            | Image viewer                                    |

## Directory Structure

```
lua/
├── core/
│   ├── options.lua     # Editor settings
│   └── keymaps.lua    # Global keybindings
├── plugins/           # Plugin configurations (35+ files)
├── app-launcher.lua   # Application launcher
├── fuzzy.lua          # Fuzzy finder
├── git.lua            # Git integration
├── git-branch.lua     # Branch switcher
├── git-commit.lua     # Git commit
├── power-commands.lua # System controls
├── screenshot.lua     # Screenshot utility
├── text-browser.lua  # w3m browser
├── todo.lua          # Notes viewer
└── web-search.lua    # Web search
```

## Theme

Using **Catppuccin** with the Mocha flavor. The configuration includes:

- Transparent background
- Custom statusline integration
- Syntax highlighting overrides

## License

MIT
