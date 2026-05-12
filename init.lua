-- =======================
--     CONFIG BÁSICA
-- =======================
vim.opt.number = true
vim.opt.relativenumber = false  -- números absolutos en todas las líneas
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false  -- Desactivar wrapping (scroll horizontal para líneas largas)
vim.opt.clipboard = "unnamedplus"  -- Usar clipboard del sistema
vim.opt.mouse = "a"  -- Habilitar mouse

-- OSC52: Permite copiar al clipboard del sistema a través de SSH
-- Funciona con terminales modernos (iTerm2, Terminal.app, Alacritty, Kitty, etc.)
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

-- Balance automático de ventanas
vim.opt.equalalways = true  -- Mantener ventanas del mismo tamaño
vim.opt.eadirection = "both"  -- Igualar en ambas direcciones (vertical y horizontal)
vim.opt.winwidth = 10  -- Ancho mínimo de ventana
vim.opt.winminwidth = 5  -- Ancho mínimo absoluto
vim.opt.sidescroll = 1  -- Scroll horizontal suave
vim.opt.sidescrolloff = 8  -- Mantener contexto al hacer scroll horizontal

-- Comportamiento de splits
vim.opt.splitbelow = true  -- Nuevos splits horizontales se abren abajo
vim.opt.splitright = true  -- Nuevos splits verticales se abren a la derecha

-- Folding (plegado de código)
vim.opt.foldmethod = "indent"  -- Plegar basado en indentación
vim.opt.foldlevel = 99  -- Abrir todos los folds por defecto
vim.opt.foldenable = true

-- Título del terminal (muestra nombre del proyecto)
vim.opt.title = true
vim.opt.titlestring = "nvim - %{fnamemodify(getcwd(), ':t')}"

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
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Desactivar netrw para evitar conflictos
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Función custom para copiar archivos marcados (bookmarked)
      local function copy_bookmarked()
        local api = require("nvim-tree.api")
        local marks = api.marks.list()

        if #marks == 0 then
          vim.notify("No hay archivos marcados", vim.log.levels.WARN)
          return
        end

        -- Copiar archivos marcados al clipboard de nvim-tree
        for _, node in ipairs(marks) do
          api.fs.copy.node(node)
        end

        -- Limpiar marcas después de copiar
        api.marks.clear()

        vim.notify(string.format("Copiados %d archivo(s) al clipboard", #marks), vim.log.levels.INFO)
      end

      -- Callback para agregar keymaps custom
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        -- Usar los defaults de nvim-tree
        api.config.mappings.default_on_attach(bufnr)

        -- Agregar custom mapping: bmc para copiar bookmarks
        vim.keymap.set('n', 'bmc', copy_bookmarked, {
          desc = "Copy bookmarked files",
          buffer = bufnr,
          noremap = true,
          silent = true,
        })
      end

      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 35,
          side = "left",
        },
        renderer = {
          group_empty = true,
          highlight_opened_files = "name",
        },
        filters = {
          dotfiles = false,  -- Mostrar archivos ocultos por defecto
        },
        update_focused_file = {
          enable = true,      -- Seguir archivo actual
          update_root = false,
        },
        sync_root_with_cwd = false,  -- No cambiar raíz de nvim-tree cuando cambia el cwd
        respect_buf_cwd = false,     -- No respetar el cwd del buffer
        actions = {
          open_file = {
            quit_on_open = false,
            window_picker = {
              enable = true,  -- Habilita selección inteligente de ventana
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          change_dir = {
            enable = false,  -- Deshabilitar cambio de directorio al navegar
            global = false,
          },
        },
        on_attach = on_attach,  -- Registrar custom keymaps
      })

      -- Variable global para coordinar con auto-session
      vim.g.nvimtree_session_restored = false

      -- nvim-tree se abre via auto-session post_restore_cmds
      -- Para directorios sin sesión guardada:
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            -- Solo abrir si no hay sesión restaurada por auto-session
            if not vim.g.nvimtree_session_restored then
              local nvim_tree_open = false
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
                if ft == "NvimTree" then
                  nvim_tree_open = true
                  break
                end
              end
              if not nvim_tree_open then
                pcall(vim.cmd, "NvimTreeOpen")
              end
            end
          end, 300)
        end,
      })
    end,
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
            "%.terragrunt%-cache",
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

  -- nvim-treesitter removido: archivado, nvim 0.12+ tiene treesitter built-in

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

  -- FORMATEO Y LINTING (none-ls)
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- JavaScript/TypeScript (prettier para formateo, eslint via LSP)
          null_ls.builtins.formatting.prettier.with({
            prefer_local = "node_modules/.bin",
          }),

          -- PHP (requiere phpcs y phpcbf instalados: composer global require squizlabs/php_codesniffer)
          null_ls.builtins.formatting.phpcbf,
          null_ls.builtins.diagnostics.phpcs,

          -- Python (requiere black y pylint: pip install black pylint)
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.pylint,

          -- Go (requiere gofmt - viene con Go)
          null_ls.builtins.formatting.gofmt,

          -- Shell (requiere shfmt: brew install shfmt)
          null_ls.builtins.formatting.shfmt,
        },
      })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },

  -- HIGHLIGHT DE REFERENCIAS (resalta variables/funciones bajo cursor)
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",         -- Usa LSP para referencias semánticas
          "treesitter",  -- Fallback a treesitter
          "regex",       -- Fallback a regex
        },
        delay = 100,  -- Delay en ms antes de resaltar
        filetypes_denylist = {
          "neo-tree",
          "TelescopePrompt",
          "lazy",
        },
        under_cursor = true,  -- Resalta también la palabra bajo el cursor
        min_count_to_highlight = 2,  -- Mínimo 2 referencias para resaltar
      })
    end,
  },

  -- COMENTARIOS: eliminado Comment.nvim, Neovim 0.10+ tiene gc/gcc nativo

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

  -- NOICE (UI mejorada: cmdline, mensajes, notificaciones)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- Evitar conflictos con otros plugins LSP
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,       -- cmdline de búsqueda abajo
          command_palette = true,     -- cmdline centrada al usar :
          long_message_to_split = true, -- mensajes largos van a split
          lsp_doc_border = true,      -- borde en el hover de LSP
        },
      })
    end,
  },

  -- FLASH (navegación rápida por pantalla)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup()
    end,
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash: saltar a cualquier lugar" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash: selección treesitter" },
    },
  },

  -- TROUBLE (panel de diagnósticos LSP)
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: diagnósticos del proyecto" },
      { "<leader>xf", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: diagnósticos del archivo" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: quickfix list" },
    },
    config = function()
      require("trouble").setup()
    end,
  },

  -- STATUSLINE
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",  -- detecta catppuccin automáticamente
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true,  -- Una sola statusline para todas las ventanas
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },  -- path=1: ruta relativa
          lualine_x = { "encoding", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- AUTO PAIRS (cierra brackets, quotes automáticamente)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,  -- Usa treesitter para contexto
      })

      -- Integración con cmp: agrega ")" al aceptar una función
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- GIT SIGNS + INLINE BLAME (como GitLens en VSCode)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,  -- Blame inline en línea activa
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",  -- Al final de la línea
          delay = 300,            -- ms antes de mostrar
          ignore_whitespace = false,
        },
        current_line_blame_formatter = " <author>, <author_time:%d %b %Y> • <abbrev_sha>: <summary>",
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "▁" },
          topdelete    = { text = "▔" },
          changedelete = { text = "▎" },
        },
      })

      -- Toggle inline blame con <leader>gb
      vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame inline" })
      -- Ver blame completo del archivo con <leader>gB
      vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "Git blame (archivo completo)" })
    end,
  },

  -- LAZYGIT (git UI via snacks.nvim)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      lazygit = {
        configure = true,
        config = {
          os = { editPreset = "nvim-remote" },
          gui = { nerdFontsVersion = "3" },
        },
      },
    },
    keys = {
      { "<leader>lg", function() Snacks.lazygit() end, desc = "LazyGit" },
      { "<leader>lf", function() Snacks.lazygit.log_file() end, desc = "LazyGit log (archivo actual)" },
    },
  },

  -- SEARCH & REPLACE (UI visual)
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace (proyecto)" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search palabra bajo cursor" },
      { "<leader>sf", function() require("spectre").open_file_search() end, desc = "Search & Replace (archivo actual)" },
    },
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
        auto_session_use_git_branch = false,
        session_lens = {
          load_on_setup = true,
        },
        -- Cerrar nvim-tree antes de guardar sesión para evitar conflictos
        pre_save_cmds = {
          "NvimTreeClose",
        },
        -- Hook para restaurar nvim-tree y filetypes después de cargar sesión
        post_restore_cmds = {
          function()
            -- Marcar que auto-session está restaurando
            vim.g.nvimtree_session_restored = true

            -- Restaurar filetypes
            vim.cmd("filetype detect")
            vim.cmd("doautocmd BufRead")

            -- Abrir nvim-tree después de un delay para evitar conflictos
            vim.defer_fn(function()
              -- Verificar que haya ventanas válidas antes de abrir nvim-tree
              local has_valid_window = false
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_is_valid(win) then
                  local buf = vim.api.nvim_win_get_buf(win)
                  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
                  if ft ~= "NvimTree" then
                    has_valid_window = true
                    break
                  end
                end
              end

              if has_valid_window then
                pcall(vim.cmd, "NvimTreeOpen")
              end
            end, 100)
          end,
        },
      })
    end,
  },

  -- MARKDOWN RENDER (colores y preview in-buffer)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    config = function()
      require("render-markdown").setup({
        heading = { enabled = true },
        code = { enabled = true },
        bullet = { enabled = true },
        checkbox = { enabled = true },
        table = { enabled = true },
      })
    end,
  },

  -- AI INLINE COMPLETIONS (Codeium - gratis)
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
      -- Tab para aceptar sugerencia de Codeium (sugerencias inline/ghost text)
      vim.keymap.set("i", "<Tab>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })

      -- Alt+] para siguiente sugerencia
      vim.keymap.set("i", "<M-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true })

      -- Alt+[ para sugerencia anterior
      vim.keymap.set("i", "<M-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })

      -- Ctrl+x para cancelar sugerencia
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
    end,
  },

  -- AI CODE SUGGESTIONS (Claude/Gemini)
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0", -- Pin a versión estable
    dependencies = {
      "nvim-lua/plenary.nvim",
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
              local keys = require("api_keys")
              return require("codecompanion.adapters").extend("anthropic", {
                env = {
                  api_key = keys.anthropic,
                },
              })
            end,
            gemini = function()
              local keys = require("api_keys")
              return require("codecompanion.adapters").extend("gemini", {
                env = {
                  api_key = keys.gemini,
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
--   TREESITTER NATIVO (nvim 0.12+)
-- =======================
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- =======================
--   KEYMAPS SPLITS/WINDOWS
-- =======================
-- Moverse entre splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- =======================
--   KEYMAPS TABS
-- =======================
-- Navegación entre tabs
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "Siguiente tab" })
vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>", { desc = "Tab anterior" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Cerrar tab actual" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Cerrar todas las otras tabs" })
vim.keymap.set("n", "<leader>tt", ":$tabnew<CR>", { desc = "Nueva tab (al final)" })

-- Ir a tab específica con Alt+número (como en navegadores)
for i = 1, 9 do
  vim.keymap.set("n", "<A-" .. i .. ">", i .. "gt", { desc = "Ir a tab " .. i })
end

-- Redimensionar splits (detecta OS)
-- macOS usa Option+Arrow (Ctrl+Arrow está ocupado por Mission Control)
-- Linux/Windows usa Ctrl+Arrow
local is_mac = vim.fn.has("macunix") == 1 or vim.fn.has("mac") == 1
local resize_mod = is_mac and "A" or "C"  -- A = Alt/Option, C = Ctrl

vim.keymap.set("n", "<" .. resize_mod .. "-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<" .. resize_mod .. "-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<" .. resize_mod .. "-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<" .. resize_mod .. "-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Rebalancear ventanas manualmente
vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Igualar tamaño de ventanas" })

-- Terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: move to left split" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: move to bottom split" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: move to top split" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: move to right split" })

-- Abrir terminal
vim.keymap.set("n", "<leader>th", ":belowright split | terminal<CR>", { desc = "Terminal horizontal (abajo)" })
vim.keymap.set("n", "<leader>tv", ":belowright vsplit | terminal<CR>", { desc = "Terminal vertical (derecha)" })
vim.keymap.set("n", "<leader>tb", ":terminal<CR>", { desc = "Terminal en buffer actual" })

-- =======================
--   KEYMAPS TELESCOPE
-- =======================
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", { desc = "Find files (respeta .gitignore)" })
vim.keymap.set("n", "<leader>fa", ":Telescope find_files no_ignore=true<CR>", { desc = "Find ALL files (incluye .env, .tfvars)" })
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>", { desc = "Live grep (buscar texto)" })
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>", { desc = "Ver buffers" })
vim.keymap.set("n", "<leader>D", ":Telescope diagnostics<CR>", { desc = "Ver todos los diagnósticos" })
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Mostrar directorio actual
vim.keymap.set("n", "<leader>pwd", function()
  local cwd = vim.fn.getcwd()
  vim.notify("Directorio actual: " .. cwd, vim.log.levels.INFO)
  print(cwd)
end, { desc = "Mostrar directorio actual" })

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
    "tinymist",  -- Typst Language Server
    "tailwindcss",  -- Tailwind CSS Language Server
    "eslint"  -- ESLint Language Server (diagnostics + code actions)
  }
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- === LSP API MODERNA PARA NEOVIM 0.11+ ===
local function setup_lsp(server)
  vim.lsp.config(server, { capabilities = capabilities })
end

-- Registra servidores
setup_lsp("ts_ls")           -- JavaScript/TypeScript
setup_lsp("intelephense")    -- PHP (principal)
setup_lsp("phpactor")        -- PHP (alternativo)
setup_lsp("html")            -- HTML
setup_lsp("cssls")           -- CSS/SCSS
setup_lsp("bashls")          -- Bash/Shell
setup_lsp("yamlls")          -- YAML
setup_lsp("terraformls")     -- Terraform
setup_lsp("dockerls")        -- Docker
setup_lsp("pyright")         -- Python
setup_lsp("gopls")           -- Go
setup_lsp("tinymist")        -- Typst
setup_lsp("tailwindcss")     -- Tailwind CSS
vim.lsp.config("eslint", {   -- ESLint (diagnostics + code actions)
  capabilities = capabilities,
  settings = {
    eslint = {
      experimental = {
        useFlatConfig = true,
      },
    },
  },
  handlers = {
    -- Suppress circular JSON error from @typescript-eslint flat config (vscode-langservers-extracted bug)
    ["textDocument/diagnostic"] = function(err, result, ctx, config)
      if err then return end
      local default = vim.lsp.handlers["textDocument/diagnostic"]
      if default then default(err, result, ctx, config) end
    end,
  },
})

-- =======================
--    AUTOCOMPLETE CMP
-- =======================
local cmp = require("cmp")
cmp.setup({
  mapping = {
    -- Ctrl+n: Siguiente sugerencia en menú cmp
    ["<C-n>"] = cmp.mapping.select_next_item(),

    -- Ctrl+p: Anterior sugerencia en menú cmp
    ["<C-p>"] = cmp.mapping.select_prev_item(),

    -- Enter: Confirmar selección de cmp (solo si está visible)
    ["<CR>"] = cmp.mapping.confirm({ select = false }),

    -- Ctrl+Space: Abrir manualmente el menú de cmp
    ["<C-Space>"] = cmp.mapping.complete(),

    -- Ctrl+e: Cerrar menú de cmp
    ["<C-e>"] = cmp.mapping.abort(),
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
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })

-- LSP References en modal flotante con Telescope (abre en split vertical)
vim.keymap.set("n", "gr", function()
  require("telescope.builtin").lsp_references({
    show_line = false,  -- Ocultar preview de línea en resultados
    include_declaration = false,  -- No mostrar la declaración, solo referencias
    layout_strategy = "vertical",  -- Layout vertical para mejor visualización
    layout_config = {
      height = 0.8,
      width = 0.7,
      prompt_position = "top",
    },
    -- Al presionar Enter, abrir en vsplit a la derecha
    attach_mappings = function(_, map)
      local actions = require("telescope.actions")

      local open_entry = function(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        vim.cmd("vsplit")
        if entry.bufnr and vim.api.nvim_buf_is_valid(entry.bufnr) then
          vim.api.nvim_win_set_buf(0, entry.bufnr)
        else
          vim.cmd("edit " .. vim.fn.fnameescape(entry.filename))
        end
        vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
      end

      map("i", "<CR>", open_entry)
      map("n", "<CR>", open_entry)

      return true
    end,
  })
end, { desc = "Go to references (Telescope modal)" })

vim.keymap.set("n", "K",  vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>a",  vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>d",  vim.diagnostic.open_float, { desc = "Show diagnostics" })

-- Abrir definición en split vertical a la derecha
vim.keymap.set("n", "<leader>gd", function()
  vim.cmd("rightbelow vsplit")
  vim.lsp.buf.definition()
end, { desc = "Go to definition (split derecha)" })

-- Cerrar quickfix/location list (lista de referencias)
vim.keymap.set("n", "<leader>q", function()
  vim.cmd("cclose")
  vim.cmd("lclose")
end, { desc = "Close quickfix/location list" })

-- =======================
--   KEYBINDINGS PARA QUICKFIX/LOCATION LIST (lista de referencias)
-- =======================
-- Configurar keybindings cuando se abre una ventana de quickfix o location list
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    local opts = { buffer = true, silent = true }

    -- Ctrl+v para abrir en split vertical a la derecha
    vim.keymap.set("n", "<C-v>", function()
      local line = vim.fn.line(".")
      vim.cmd("wincmd p")  -- Volver a la ventana anterior
      vim.cmd("vsplit")  -- splitright ya está configurado
      vim.cmd("wincmd p")  -- Volver a quickfix
      vim.cmd(line .. "cc") -- Abrir el item
    end, vim.tbl_extend("force", opts, { desc = "Open in vertical split (derecha)" }))

    -- Ctrl+x para abrir en split horizontal abajo
    vim.keymap.set("n", "<C-x>", function()
      local line = vim.fn.line(".")
      vim.cmd("wincmd p")  -- Volver a la ventana anterior
      vim.cmd("split")  -- splitbelow ya está configurado
      vim.cmd("wincmd p")  -- Volver a quickfix
      vim.cmd(line .. "cc") -- Abrir el item
    end, vim.tbl_extend("force", opts, { desc = "Open in horizontal split (abajo)" }))

    -- Ctrl+t para abrir en nueva pestaña
    vim.keymap.set("n", "<C-t>", function()
      local line = vim.fn.line(".")
      vim.cmd("tabnew")
      vim.cmd("wincmd p")  -- Volver a quickfix
      vim.cmd(line .. "cc") -- Abrir el item
    end, vim.tbl_extend("force", opts, { desc = "Open in new tab" }))
  end,
})