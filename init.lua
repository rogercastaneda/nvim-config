-- =======================
--     CONFIG BÁSICA
-- =======================
vim.opt.number = true
vim.opt.relativenumber = true  -- puedes desactivarlo si no te gusta
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"  -- Usar clipboard del sistema
vim.opt.mouse = "a"  -- Habilitar mouse

-- Folding (plegado de código)
vim.opt.foldmethod = "indent"  -- Plegar basado en indentación
vim.opt.foldlevel = 99  -- Abrir todos los folds por defecto
vim.opt.foldenable = true

-- Reconocer extensiones personalizadas
vim.filetype.add({
  extension = {
    typst = "typst",  -- Typst markup language
  },
})
-- =======================
--     LAZY PACKAGE LOADER
-- =======================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =======================
--     LEADER KEY
-- =======================
vim.g.mapleader = " "   -- Spacebar líder

-- =======================
--     PLUGINS (Lazy)
-- =======================
require("lazy").setup({

  -- THEME (COLOR SCHEME)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe", -- latte, frappe, macchiato, mocha
        transparent_background = false,
        term_colors = true,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- FILE TREE (EXPLORADOR)
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" }
  },

  -- TELESCOPE (buscador)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules/",
            "vendor/",
            "%.git/",
            "%.terraform/",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
          mappings = {
            i = {
              -- Ctrl+f para filtrar por carpeta durante live_grep
              ["<C-f>"] = function(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local prompt = current_picker:_get_prompt()
                actions.close(prompt_bufnr)

                vim.ui.input({ prompt = "Filtrar por carpeta (ej: _v1): " }, function(folder_pattern)
                  if folder_pattern then
                    require("telescope.builtin").live_grep({
                      default_text = prompt,
                      glob_pattern = "**/*" .. folder_pattern .. "*/**"
                    })
                  end
                end)
              end,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false,
            follow = false,
          },
        },
      })
    end,
  },

  -- TREESITTER (syntax + highlight mejorado)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },

  -- TYPST (markup language para PDFs)
  {
    "kaarmu/typst.vim",
    lazy = false,  -- Cargar siempre (necesario para auto-session)
  },

  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- CMP AUTOCOMPLETE
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",

  -- FORMATEO
  "mhartington/formatter.nvim",

  -- COMENTARIOS
  {
    "numToStr/Comment.nvim",
    lazy = false, -- Cargar inmediatamente
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = "^$", -- Ignorar líneas vacías
        toggler = {
          line = "gcc", -- Toggle línea
          block = "gbc", -- Toggle bloque
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
      })
    end,
  },

  -- WHICH-KEY (muestra comandos disponibles)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        delay = 500, -- milisegundos antes de mostrar el popup
        icons = {
          mappings = false, -- no usar nerd fonts
        },
      })
    end,
  },

  -- SESSION MANAGER (persistencia de sesiones)
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_enable_last_session = false,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        -- Asegurar que todos los buffers se guarden y restauren
        auto_session_use_git_branch = false,
        session_lens = {
          load_on_setup = true,
        },
        -- Hook para forzar carga de filetypes lazy-loaded
        post_restore_cmds = {
          function()
            -- Forzar detección de filetype después de restaurar
            vim.cmd("filetype detect")
            vim.cmd("doautocmd BufRead")
          end
        },
      })
    end,
  },

  -- AI CODE SUGGESTIONS (Claude/Gemini)
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0", -- Pin a versión estable
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Ya lo tienes
      "nvim-telescope/telescope.nvim", -- Ya lo tienes
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "anthropic" }, -- o "gemini"
          inline = { adapter = "anthropic" }, -- o "gemini"
        },
        adapters = {
          http = {
            anthropic = function()
              return require("codecompanion.adapters").extend("anthropic", {
                env = {
                  api_key = os.getenv("ANTHROPIC_API_KEY"),
                },
              })
            end,
            gemini = function()
              return require("codecompanion.adapters").extend("gemini", {
                env = {
                  api_key = os.getenv("GEMINI_API_KEY"),
                },
              })
            end,
          },
        },
      })
    end,
  },
})

-- =======================
--   KEYMAPS SPLITS/WINDOWS
-- =======================
-- Moverse entre splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Redimensionar splits
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: move to left split" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: move to bottom split" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: move to top split" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: move to right split" })

-- Abrir terminal
vim.keymap.set("n", "<leader>th", ":belowright split | terminal<CR>", { desc = "Terminal horizontal (abajo)" })
vim.keymap.set("n", "<leader>tv", ":belowright vsplit | terminal<CR>", { desc = "Terminal vertical (derecha)" })
vim.keymap.set("n", "<leader>tt", ":terminal<CR>", { desc = "Terminal en buffer actual" })

-- =======================
--   KEYMAPS TELESCOPE
-- =======================
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", { desc = "Find files (respeta .gitignore)" })
vim.keymap.set("n", "<leader>fa", ":Telescope find_files no_ignore=true<CR>", { desc = "Find ALL files (incluye .env, .tfvars)" })
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")

-- =======================
--   KEYMAPS AI SUGGESTIONS
-- =======================
-- Namespace "ai" para evitar conflictos
vim.keymap.set({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions Menu" })
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat Toggle" })
vim.keymap.set("n", "<leader>an", "<cmd>CodeCompanionChat<cr>", { desc = "AI Chat New" })
vim.keymap.set("v", "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", { desc = "AI Add to Chat" })

-- Atajo rápido alternativo (opcional)
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { desc = "AI Quick Menu" })

-- =======================
--      MASON + LSP
-- =======================
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls", "intelephense","phpactor",
    "html","cssls","bashls","yamlls",
    "dockerls","terraformls","pyright",
    "gopls",  -- Go Language Server
    "tinymist"  -- Typst Language Server
  }
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- === LSP API MODERNA PARA NEOVIM 0.11+ ===
local function setup_lsp(server)
  vim.lsp.config(server, { capabilities = capabilities })
end

-- Registra servidores
setup_lsp("ts_ls")
setup_lsp("intelephense")
setup_lsp("bashls")
setup_lsp("yamlls")
setup_lsp("gopls")
setup_lsp("tinymist")
-- si quieres más activalos igual: setup_lsp("html") setup_lsp("pyright") etc

-- =======================
--    AUTOCOMPLETE CMP
-- =======================
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"]  = cmp.mapping.confirm({ select = true })
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer"   },
    { name = "path"     },
  }
})

-- =======================
--   ATAJOS LSP
-- =======================
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K",  vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>a",  vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>d",  vim.diagnostic.open_float)
