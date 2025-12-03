# Neovim Configuration

Configuración personal de Neovim con soporte para múltiples lenguajes, AI code suggestions, y herramientas modernas de desarrollo.

---

## Requisitos Previos

### Linux (Debian/Ubuntu)

```bash
# Neovim (0.9+ requerido, 0.11+ recomendado)
sudo apt update
sudo apt install neovim

# Git (requerido para plugins)
sudo apt install git

# ripgrep (requerido para live_grep en Telescope)
sudo apt install ripgrep

# Node.js (requerido para algunos LSP servers)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs

# Build essentials (para compilar algunos plugins)
sudo apt install build-essential
```

### macOS

```bash
# Homebrew (si no lo tienes)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Neovim
brew install neovim

# Git
brew install git

# ripgrep (requerido para live_grep)
brew install ripgrep

# Node.js (requerido para algunos LSP servers)
brew install node
```

---

## Nerd Fonts (Iconos)

Los iconos del explorador de archivos requieren una Nerd Font instalada.

### Linux

```bash
# Crear directorio de fonts
mkdir -p ~/.local/share/fonts

# Descargar JetBrainsMono Nerd Font
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip

# Actualizar cache de fonts
fc-cache -fv
```

### macOS

```bash
# Usando Homebrew
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

### Configurar Terminal

Después de instalar, configura tu terminal para usar la fuente:
- **Warp**: Settings > Appearance > Font > JetBrainsMono Nerd Font
- **iTerm2**: Preferences > Profiles > Text > Font
- **Terminal.app**: Preferences > Profiles > Font
- **GNOME Terminal**: Preferences > Profile > Custom font

---

## Variables de Entorno (API Keys)

Para usar las funciones de AI (Claude/Gemini), agrega las API keys a tu shell config:

### Bash (~/.bashrc)

```bash
export ANTHROPIC_API_KEY="tu-api-key-de-anthropic"
export GEMINI_API_KEY="tu-api-key-de-gemini"
```

### Zsh (~/.zshrc)

```bash
export ANTHROPIC_API_KEY="tu-api-key-de-anthropic"
export GEMINI_API_KEY="tu-api-key-de-gemini"
```

Después de agregar, recarga tu shell:

```bash
source ~/.zshrc  # o ~/.bashrc
```

### Obtener API Keys

| Servicio | URL |
|----------|-----|
| Anthropic (Claude) | https://console.anthropic.com/settings/keys |
| Google (Gemini) | https://aistudio.google.com/app/apikey |

---

## Instalación

1. **Clonar/Copiar configuración:**
   ```bash
   # Backup de config existente (si tienes)
   mv ~/.config/nvim ~/.config/nvim.backup

   # Copiar init.lua a la ubicación correcta
   mkdir -p ~/.config/nvim
   cp init.lua ~/.config/nvim/
   ```

2. **Abrir Neovim:**
   ```bash
   nvim
   ```

   La primera vez:
   - Lazy.nvim se instalará automáticamente
   - Todos los plugins se descargarán
   - Mason instalará los LSP servers

3. **Verificar instalación:**
   ```vim
   :checkhealth
   ```

---

## Plugins Instalados

| Plugin | Descripción | Uso |
|--------|-------------|-----|
| **lazy.nvim** | Package manager | Gestión automática de plugins |
| **catppuccin** | Theme/colorscheme | Tema visual (flavor: frappe) |
| **neo-tree** | File explorer | Navegación de archivos lateral |
| **telescope** | Fuzzy finder | Búsqueda de archivos y texto |
| **treesitter** | Syntax highlighting | Resaltado de sintaxis mejorado |
| **typst.vim** | Typst support | Soporte para lenguaje Typst |
| **mason** | LSP installer | Instalador de language servers |
| **nvim-cmp** | Autocompletado | Sugerencias de código |
| **Comment.nvim** | Comentarios | Toggle comentarios inteligente |
| **which-key** | Key helper | Muestra atajos disponibles |
| **auto-session** | Session manager | Persistencia de sesiones por proyecto |
| **codecompanion** | AI assistant | Chat con Claude/Gemini |

---

## Language Servers (LSP)

Instalados automáticamente via Mason:

| Server | Lenguaje | Archivo |
|--------|----------|---------|
| ts_ls | TypeScript/JavaScript | .ts, .tsx, .js, .jsx |
| intelephense | PHP | .php |
| phpactor | PHP | .php |
| html | HTML | .html |
| cssls | CSS | .css, .scss |
| bashls | Bash/Shell | .sh, .bash |
| yamlls | YAML | .yaml, .yml |
| dockerls | Docker | Dockerfile |
| terraformls | Terraform | .tf, .tfvars |
| pyright | Python | .py |
| gopls | Go | .go |
| tinymist | Typst | .typst |

---

## Funcionalidades

| Funcionalidad | Descripción |
|---------------|-------------|
| **Clipboard del sistema** | Copiar/pegar integrado con el OS |
| **Folding** | Plegado de código por indentación |
| **Splits** | Navegación y redimensionado de ventanas |
| **Terminal integrado** | Terminal dentro de Neovim |
| **Live grep** | Búsqueda de texto con filtro de carpetas |
| **Sesiones automáticas** | Restaura archivos/splits al reabrir proyecto |
| **AI Chat** | Asistente de código con Claude o Gemini |
| **Autocompletado** | Sugerencias de LSP, buffer y paths |
| **Diagnósticos** | Errores y warnings en tiempo real |

---

## Estructura de Archivos

```
~/.config/nvim/
├── init.lua          # Configuración principal (único archivo necesario)
└── README.md         # Esta documentación
```

---

## Troubleshooting

### "ripgrep is required"
```bash
# Linux
sudo apt install ripgrep

# macOS
brew install ripgrep
```

### LSP no funciona
```vim
:Mason
" Verificar que el server esté instalado (checkmark verde)
" Si no, seleccionarlo y presionar 'i' para instalar
```

### Iconos no se muestran
- Verificar que Nerd Font esté instalada
- Configurar la terminal para usar la Nerd Font

### AI Chat no responde
```bash
# Verificar variables de entorno
echo $ANTHROPIC_API_KEY
echo $GEMINI_API_KEY

# Si están vacías, recargar shell config
source ~/.zshrc
```

### Sesiones no se restauran
- Verificar que estés en el mismo directorio donde guardaste la sesión
- Las sesiones se guardan por directorio de trabajo

---

## Actualización

```vim
" Actualizar plugins
:Lazy sync

" Actualizar LSP servers
:Mason
" Presionar 'U' para actualizar todos
```

---

**Atajos de teclado:** Ver `~/Desktop/nvim-keybindings.md`
