-- DISTANT.NVIM - Edición remota de archivos vía SSH
return {
  'chipsenkbeil/distant.nvim',
  branch = 'v0.3',
  config = function()
    require('distant'):setup()

    -- Diccionario de servidores frecuentes
    -- Agregar tus servidores aquí
    local servers = {
      ['linux-pc'] = {
        host = 'ssh://usuario@192.168.1.100',
        default_path = '~/',
      },
      ['vps'] = {
        host = 'ssh://root@tu-vps.com',
        default_path = '~/proyectos',
      },
      -- Agregar más servidores según necesites
    }

    -- Función para conectar y abrir directorio en un solo paso
    local function remote_connect_and_open(server_name, custom_path)
      local server = servers[server_name]
      if not server then
        local available = vim.tbl_keys(servers)
        vim.notify('Servidor no encontrado. Disponibles: ' .. table.concat(available, ', '), vim.log.levels.ERROR)
        return
      end

      -- Conectar
      vim.notify('Conectando a ' .. server_name .. '...', vim.log.levels.INFO)
      vim.cmd('DistantConnect ' .. server.host)

      -- Esperar un momento para la conexión y abrir directorio
      vim.defer_fn(function()
        local path = custom_path or server.default_path
        vim.cmd('DistantOpen ' .. path)
        vim.notify('Conectado a ' .. server_name .. ' en ' .. path, vim.log.levels.INFO)
      end, 1000)
    end

    -- Comando principal: :Remote [servidor] [path opcional]
    vim.api.nvim_create_user_command('Remote', function(opts)
      local args = vim.split(opts.args, ' ', { trimempty = true })
      local server_name = args[1]
      local custom_path = args[2]

      if not server_name or server_name == '' then
        -- Mostrar servidores disponibles
        local available = vim.tbl_keys(servers)
        vim.notify('Uso: :Remote [servidor] [path]\nDisponibles: ' .. table.concat(available, ', '), vim.log.levels.INFO)
        return
      end

      remote_connect_and_open(server_name, custom_path)
    end, {
      nargs = '*',
      complete = function()
        return vim.tbl_keys(servers)
      end,
    })

    -- Comando para abrir path adicional (si ya estás conectado)
    vim.api.nvim_create_user_command('RemoteOpen', function(opts)
      local path = opts.args ~= '' and opts.args or '~/'
      vim.cmd('DistantOpen ' .. path)
    end, { nargs = '?' })

    -- Comando para desconectar
    vim.api.nvim_create_user_command('RemoteDisconnect', function()
      vim.cmd('DistantClientStop')
      vim.notify('Desconectado del servidor remoto', vim.log.levels.INFO)
    end, {})

    -- ==================
    -- KEYBINDINGS
    -- ==================
    -- Usar <leader>x como prefix para "eXternal/conexión remota"

    -- <leader>xc: Conectar a servidor (te pide el nombre)
    vim.keymap.set('n', '<leader>xc', function()
      local available = vim.tbl_keys(servers)
      vim.ui.select(available, {
        prompt = 'Selecciona servidor:',
      }, function(choice)
        if choice then
          remote_connect_and_open(choice)
        end
      end)
    end, { desc = 'Remote: Connect to server' })

    -- <leader>xo: Abrir otro path (si ya estás conectado)
    vim.keymap.set('n', '<leader>xo', function()
      vim.ui.input({ prompt = 'Path remoto: ', default = '~/' }, function(path)
        if path then
          vim.cmd('RemoteOpen ' .. path)
        end
      end)
    end, { desc = 'Remote: Open path' })

    -- <leader>xd: Desconectar
    vim.keymap.set('n', '<leader>xd', ':RemoteDisconnect<CR>', { desc = 'Remote: Disconnect' })

    -- <leader>xf: Find files remotos con Telescope (después de conectar)
    vim.keymap.set('n', '<leader>xf', function()
      require('telescope.builtin').find_files()
    end, { desc = 'Remote: Find files' })

    -- <leader>xg: Grep remoto con Telescope (después de conectar)
    vim.keymap.set('n', '<leader>xg', function()
      require('telescope.builtin').live_grep()
    end, { desc = 'Remote: Live grep' })

    -- <leader>xe: Abrir/toggle NvimTree en directorio remoto
    vim.keymap.set('n', '<leader>xe', ':NvimTreeToggle<CR>', { desc = 'Remote: Toggle file tree' })
  end,
}
