-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "zig", "nix", "nu", "bash", "fish" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
   },
      -- Mini indentscope for animations
      {
        "echasnovski/mini.indentscope",
        version = false,
        config = function()
          require("mini.indentscope").setup({
            symbol = "│",
            options = { try_as_border = false },
          })
        end,
      },

     -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          nvimtree = true,
        },
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Lualine statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
      })
    end,
  },

  -- Nvim Tree file manager
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        renderer = {
          indent_markers = {
            enable = true,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
      })
      vim.keymap.set("n", "\\", ":NvimTreeToggle<CR>")
    end,
  },

  -- ToggleTerm for terminal support
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup()
    end,
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Nvim notify
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- Bufferline for tab-like buffer management


  -- Snacks dashboard
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

Wake up to reality !
 -- ijadux2
          ]],
          keys = {
            { icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
            { icon = "󰈞 ", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "s", desc = "Settings", action = ":e $MYVIMRC" },
            { icon = "󰅚 ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
        animate = {
          enabled = true,
          fps = 30,
          easing = "outCubic",
        },
      },
      picker = {
        enabled = true,
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "fancy",
        icons = {
          error = "",
          warn = "",
          info = "",
          debug = "",
          trace = "",
        },
        top_down = false,
      },
    },
  },

  -- Telescope for fuzzy finding (used in dashboard)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Web devicons for icons
  "nvim-tree/nvim-web-devicons",

  -- Which-key for command palette
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  -- Auto-pairing
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
   },

   -- LSP
   {
     "williamboman/mason.nvim",
     version = "*",
     config = function()
       require("mason").setup()
     end,
   },
   {
     "williamboman/mason-lspconfig.nvim",
     version = "*",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "zls", "nil_ls" },
        automatic_installation = true,
        handlers = {
          function(server_name)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("lspconfig")[server_name].setup({ capabilities = capabilities })
          end,
          lua_ls = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "love" },
                  },
                  workspace = {
                    library = {
                      ["${3rd}/love2d/library"] = true,
                    },
                  },
                },
              },
            })
          end,
        },
      })
    end,
   },

   -- Formatting with conform
   {
     "stevearc/conform.nvim",
     config = function()
       require("conform").setup({
         formatters_by_ft = {
           lua = { "stylua" },
           python = { "black" },
           javascript = { "prettier" },
           typescript = { "prettier" },
           json = { "prettier" },
           css = { "prettier" },
           html = { "prettier" },
           yaml = { "prettier" },
           markdown = { "prettier" },
         },
         format_on_save = {
           timeout_ms = 500,
           lsp_fallback = true,
         },
       })
     end,
   },

})
-- Basic Neovim settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h15"
vim.opt.cursorline = true
vim.opt.pumblend = 50 -- blur for nvim
vim.opt.winblend = 50  -- blur for nvim as window

-- Keybindings
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")


