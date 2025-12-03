# Neovim - Guía de Atajos

**Leader Key:** `<Space>` (barra espaciadora)

---

## 📂 Navegación y Búsqueda (Telescope)

| Atajo | Descripción |
|-------|-------------|
| `<Space>f` | Buscar archivos (respeta `.gitignore`) |
| `<Space>fa` | Buscar **TODOS** los archivos (incluye `.env`, `.tfvars`) |
| `<Space>g` | Buscar texto dentro de archivos (live grep) |
| `<Space>b` | Ver buffers abiertos |
| `:Telescope keymaps` | Ver todos los atajos disponibles |

### Búsqueda de Texto con Filtro de Carpeta

**Flujo de trabajo:**
```
1. <Space>g              → Abre live grep
2. Escribe: "environment {"  → Muestra todos los resultados
3. Ctrl+f               → Aparece: "Filtrar por carpeta:"
4. Escribe: _v1         → Filtra solo carpetas con "_v1"
5. ✅ Resultados filtrados dinámicamente
```

**Ejemplo práctico:**
- Buscar "environment {" solo en carpetas `*_v1*`
- Buscar "resource" solo en carpetas `terraform/`
- Buscar "function" solo en carpetas `src/`

**Exclusiones:** `node_modules/`, `vendor/`, `.git/`, `.terraform/`
**Nota:** `<Space>fa` muestra archivos en `.gitignore` como `.env`, `terraform.tfvars`

---

## 🌳 Explorador de Archivos (Neotree)

### Abrir/Cerrar
| Atajo | Descripción |
|-------|-------------|
| `<Space>e` | Abrir/cerrar Neotree (explorador lateral) |

### Operaciones de Archivos (dentro de Neotree)
| Atajo | Descripción |
|-------|-------------|
| `r` | Renombrar archivo/carpeta |
| `d` | Eliminar archivo/carpeta |
| `a` | Crear nuevo archivo |
| `A` | Crear nueva carpeta |
| `c` | Copiar archivo |
| `x` | Cortar archivo |
| `p` | Pegar archivo |
| `y` | Copiar nombre del archivo |
| `Y` | Copiar ruta relativa |
| `Enter` | Abrir archivo/expandir carpeta |

---

## 🪟 Splits y Ventanas

### Moverse entre splits
| Atajo | Descripción |
|-------|-------------|
| `Ctrl+h` | Ir al split izquierdo |
| `Ctrl+j` | Ir al split de abajo |
| `Ctrl+k` | Ir al split de arriba |
| `Ctrl+l` | Ir al split derecho |

### Redimensionar splits
| Atajo | Descripción |
|-------|-------------|
| `Ctrl+↑` | Aumentar altura |
| `Ctrl+↓` | Disminuir altura |
| `Ctrl+←` | Disminuir ancho |
| `Ctrl+→` | Aumentar ancho |

### Crear y cerrar splits
| Comando | Descripción |
|---------|-------------|
| `:split` o `:sp` | Split horizontal |
| `:vsplit` o `:vs` | Split vertical |
| `Ctrl+w s` | Split horizontal (atajo) |
| `Ctrl+w v` | Split vertical (atajo) |
| `:q` | Cerrar split actual |
| `Ctrl+w q` | Cerrar split actual (atajo) |
| `Ctrl+w o` | Cerrar todos menos el actual |

---

## 💻 Terminal

### Abrir terminal
| Atajo | Descripción |
|-------|-------------|
| `<Space>th` | Terminal horizontal (abajo) |
| `<Space>tv` | Terminal vertical (derecha) |
| `<Space>tt` | Terminal en buffer actual |

### Salir de terminal mode
| Atajo | Descripción |
|-------|-------------|
| `Esc` | Salir de terminal mode a modo normal |
| `Ctrl+h/j/k/l` | Salir de terminal Y moverte a otro split |

---

## 🔧 LSP (Language Server Protocol)

### Navegación de código
| Atajo | Descripción |
|-------|-------------|
| `gd` | Ir a definición |
| `gi` | Ir a implementación |
| `gr` | Ver referencias |
| `K` | Mostrar documentación (hover) |

### Refactorización
| Atajo | Descripción |
|-------|-------------|
| `<Space>rn` | Renombrar símbolo |
| `<Space>a` | Acciones de código (code actions) |
| `<Space>d` | Mostrar diagnósticos (errores/warnings) |

**Language Servers instalados:**
- TypeScript/JavaScript (ts_ls)
- PHP (intelephense, phpactor)
- HTML, CSS
- Bash, YAML
- Docker, Terraform
- Python (pyright)
- Go (gopls)
- Typst (tinymist)

---

## ✍️ Autocompletado

| Atajo | Descripción |
|-------|-------------|
| `Tab` | Siguiente sugerencia |
| `Shift+Tab` | Anterior sugerencia |
| `Enter` | Confirmar sugerencia |

**Fuentes:** LSP, buffer, rutas de archivos

---

## 💬 Comentarios

### Modo normal
| Atajo | Descripción |
|-------|-------------|
| `gcc` | Comentar/descomentar línea actual |
| `gbc` | Comentar/descomentar bloque |
| `5gcc` | Comentar 5 líneas |

### Modo visual
| Atajo | Descripción |
|-------|-------------|
| `gc` | Comentar/descomentar selección |
| `gb` | Comentar bloque seleccionado |

**Detecta automáticamente el lenguaje** (usa `#` para Terraform, `//` para JS, etc.)

---

## 🤖 AI Code Suggestions (Claude/Gemini)

| Atajo | Descripción |
|-------|-------------|
| `<Space>ai` | Menú de acciones AI |
| `<Space>ac` | Abrir/cerrar chat AI |
| `<Space>an` | Nuevo chat AI |
| `<Space>aa` | Agregar selección al chat (modo visual) |

**Configuración actual:** Anthropic Claude
**Cambiar a Gemini:** Editar `init.lua` líneas 143-144

---

## 🎯 Comandos Útiles

### Ver comandos disponibles
| Comando | Descripción |
|---------|-------------|
| `<Space>` (esperar) | Which-key muestra comandos disponibles |
| `:Telescope keymaps` | Buscar todos los atajos |
| `:map` | Ver todos los keymaps |

### Edición básica
| Atajo | Descripción |
|-------|-------------|
| `i` | Modo insert |
| `v` | Modo visual (carácter) |
| `V` | Modo visual (línea) |
| `Esc` | Salir a modo normal |
| `u` | Deshacer |
| `Ctrl+r` | Rehacer |
| `:w` | Guardar |
| `:q` | Salir (una ventana) |
| `:qa` | **Salir de TODO** (cierra Neovim completo) |
| `:qa!` | Salir de TODO sin guardar (forzar) |
| `:wqa` | Guardar todo y salir |
| `:wq` | Guardar y salir |
| `ZZ` | Guardar y salir (atajo) |

### Manejar Archivos
| Comando | Descripción |
|---------|-------------|
| `:e archivo.txt` | Abrir/Editar archivo |
| `:saveas nuevo.txt` | Guardar como nuevo nombre |
| `:!mv % nuevo.txt` | Renombrar archivo actual |
| `:!rm %` | Eliminar archivo actual |
| **Neotree `r`** | Renombrar (más fácil) |
| **Neotree `d`** | Eliminar (más fácil) |

### Navegación
| Atajo | Descripción |
|-------|-------------|
| `h/j/k/l` | Izquierda/Abajo/Arriba/Derecha |
| `w` | Siguiente palabra |
| `b` | Palabra anterior |
| `0` | Inicio de línea |
| `$` | Final de línea |
| `gg` | Inicio del archivo |
| `G` | Final del archivo |
| `Ctrl+u` | Media página arriba |
| `Ctrl+d` | Media página abajo |

---

## 📋 Clipboard (Portapapeles del Sistema)

**✅ Configurado para usar clipboard del sistema automáticamente!**

| Atajo | Descripción |
|-------|-------------|
| `y` | Copiar (va al clipboard del sistema) |
| `yy` | Copiar línea completa |
| `p` | Pegar (desde clipboard del sistema) |
| `P` | Pegar antes del cursor |

**Ahora funciona:**
- Copiar en navegador (`Ctrl+C`) → Pegar en Neovim (`p`)
- Copiar en Neovim (`y` en visual) → Pegar en navegador (`Ctrl+V`)

---

## 📁 Folding (Plegar Código)

| Atajo | Descripción |
|-------|-------------|
| `za` | Toggle fold bajo el cursor |
| `zo` | Abrir fold bajo el cursor |
| `zc` | Cerrar fold bajo el cursor |
| `zR` | Abrir TODOS los folds |
| `zM` | Cerrar TODOS los folds |
| `zf` | Crear fold (modo visual) |

**Método:** Plegado por indentación
**Por defecto:** Todos los folds abiertos

---

## 💾 Sesiones (Persistencia Automática)

**✅ Auto-Session activado:** Guarda y restaura automáticamente tus archivos y splits por proyecto!

### ¿Cómo funciona?
- **Guardado automático:** Al salir de Neovim (`:q`, `:qa`)
- **Restauración automática:** Al abrir Neovim en el mismo directorio
- **Por proyecto:** Cada directorio tiene su propia sesión

### Flujo de trabajo típico
```bash
# Día 1: Trabajando en un proyecto
cd ~/git/ov/balance-reporting
nvim
# Abres varios archivos, creas splits...
:qa  # Al salir, se guarda automáticamente

# Día 2: Volver al proyecto
cd ~/git/ov/balance-reporting
nvim  # ✨ Se restauran tus archivos y splits automáticamente!
```

### Comandos manuales (opcional)
| Comando | Descripción |
|---------|-------------|
| `:SessionSave` | Guardar sesión manualmente |
| `:SessionRestore` | Restaurar sesión manualmente |
| `:SessionDelete` | Eliminar sesión del directorio actual |

**Nota:** Directorios excluidos: `~/`, `~/Downloads`, `/` (no guardan sesión)

---

## 🔄 Recarga de Configuración

```vim
:source ~/.config/nvim/init.lua
```

O cierra y reabre Neovim.

---

## 📦 Plugins Instalados

- **Lazy.nvim** - Package manager
- **Catppuccin** - Theme (frappe flavor)
- **Telescope** - Fuzzy finder
- **Neo-tree** - File explorer
- **Treesitter** - Syntax highlighting
- **Typst.vim** - Typst language support
- **Mason** - LSP installer
- **nvim-cmp** - Autocompletado
- **Comment.nvim** - Comentarios inteligentes
- **Which-key** - Muestra atajos disponibles
- **Auto-Session** - Persistencia de sesiones por proyecto
- **CodeCompanion** - AI code suggestions (Claude/Gemini)

---

## 💡 Tips

1. **Which-key:** Presiona `<Space>` y espera 0.5s para ver comandos disponibles
2. **Telescope:** Usa fuzzy search - no necesitas escribir el nombre completo
3. **Terminal:** `Esc` para salir, luego navegación normal de Neovim
4. **Splits:** `Ctrl+w o` para enfocarte en uno solo
5. **LSP:** `K` dos veces para entrar al hover popup
6. **Comentarios:** Funcionan en cualquier lenguaje automáticamente

---

**Archivo de configuración:** `~/.config/nvim/init.lua`
**Fecha actualización:** 2025-12-02
