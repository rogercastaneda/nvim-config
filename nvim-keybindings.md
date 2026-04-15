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
| `<Space>D` | Ver **todos** los diagnósticos (errores/warnings) |
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

**Exclusiones:** `node_modules/`, `vendor/`, `.git/`, `.terraform/`, `.terragrunt-cache/`
**Nota:** `<Space>fa` muestra archivos en `.gitignore` como `.env`, `terraform.tfvars`

### Abrir Archivos en la Lista de Telescope

Cuando estás en la lista de resultados de `<Space>f` o `<Space>g`:

| Atajo | Descripción |
|-------|-------------|
| `Enter` | Abrir en el buffer actual |
| `Ctrl+v` | Abrir en split vertical a la **derecha** |
| `Ctrl+x` | Abrir en split horizontal **abajo** |
| `Ctrl+t` | Abrir en nueva pestaña |

---

## 🌳 Explorador de Archivos (nvim-tree)

### Abrir/Cerrar
| Atajo | Descripción |
|-------|-------------|
| `<Space>e` | Abrir/cerrar nvim-tree (explorador lateral) |

### Abrir Archivos (dentro de nvim-tree)
| Atajo | Descripción |
|-------|-------------|
| `Enter` | Abrir archivo/expandir carpeta en buffer actual |
| `Ctrl+v` | Abrir archivo en split **vertical a la derecha** |
| `Ctrl+x` | Abrir archivo en split **horizontal abajo** |
| `Ctrl+t` | Abrir archivo en nueva **tab** |

### Operaciones de Archivos (dentro de nvim-tree)
| Atajo | Descripción |
|-------|-------------|
| `a` | Crear nuevo archivo/carpeta |
| `d` | Eliminar archivo/carpeta |
| `r` | Renombrar archivo/carpeta |
| `c` | Copiar archivo al clipboard de nvim-tree |
| `x` | Cortar archivo |
| `p` | Pegar archivo |
| `m` | Marcar/desmarcar archivo (bookmark) |
| **`bmc`** | **Copiar archivos marcados al clipboard** |
| `bmv` | Mover archivos marcados |
| `-` | Ir al directorio padre |
| `P` | Ir al directorio padre |
| `H` | Mostrar/ocultar archivos ocultos |
| `R` | Refrescar árbol |
| `?` | Ver todos los atajos disponibles |

### Flujo para duplicar un archivo
```
1. c      → Copiar archivo al clipboard
2. p      → Pegar en el mismo directorio (duplica)
          O navegar a otro directorio y pegar ahí
```

### Flujo para copiar múltiples archivos
```
1. m      → Marca archivo1
2. ↓ m    → Marca archivo2
3. ↓ m    → Marca archivo3
4. bmc    → Copia los 3 al clipboard (verás notificación)
5. Navega a carpeta destino
6. p      → Pega los 3 archivos
```

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

**Linux/Windows:**
| Atajo | Descripción |
|-------|-------------|
| `Ctrl+↑` | Aumentar altura |
| `Ctrl+↓` | Disminuir altura |
| `Ctrl+←` | Disminuir ancho |
| `Ctrl+→` | Aumentar ancho |

**macOS:**
| Atajo | Descripción |
|-------|-------------|
| `Option+↑` | Aumentar altura |
| `Option+↓` | Disminuir altura |
| `Option+←` | Disminuir ancho |
| `Option+→` | Aumentar ancho |

> **Nota macOS**: Se usa `Option` (Alt) en lugar de `Ctrl` porque macOS usa `Ctrl+Arrow` para Mission Control.

### Crear y cerrar splits
| Comando | Descripción |
|---------|-------------|
| `:split` o `:sp` | Split horizontal (se abre **abajo**) |
| `:vsplit` o `:vs` | Split vertical (se abre a la **derecha**) |
| `Ctrl+w s` | Split horizontal (atajo, se abre **abajo**) |
| `Ctrl+w v` | Split vertical (atajo, se abre a la **derecha**) |
| `:q` | Cerrar split actual |
| `Ctrl+w q` | Cerrar split actual (atajo) |
| `Ctrl+w o` | Cerrar todos menos el actual |

> **Nota:** Todos los splits (horizontal y vertical) se abren automáticamente en la posición natural: horizontales **abajo** y verticales a la **derecha**.

---

## 📑 Tabs (Pestañas)

### Navegación entre tabs
| Atajo | Descripción |
|-------|-------------|
| `<Space>tn` | Siguiente tab |
| `<Space>tp` | Tab anterior |
| `Alt+1` a `Alt+9` | Ir directamente a tab 1-9 |
| `gt` | Siguiente tab (atajo nativo) |
| `gT` | Tab anterior (atajo nativo) |

### Gestión de tabs
| Atajo | Descripción |
|-------|-------------|
| `<Space>tt` | Nueva tab vacía (se abre al final, a la derecha de todas) |
| `<Space>tc` | Cerrar tab actual |
| `<Space>to` | Cerrar todas las otras tabs (solo mantener actual) |
| `Ctrl+t` | Abrir archivo en nueva tab (desde nvim-tree o Telescope) |

---

## 💻 Terminal

### Abrir terminal
| Atajo | Descripción |
|-------|-------------|
| `<Space>th` | Terminal horizontal (abajo) |
| `<Space>tv` | Terminal vertical (derecha) |
| `<Space>tb` | Terminal en buffer actual |

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
| `gd` | Ir a definición (mismo buffer) |
| `<Space>gd` | Ir a definición en split **vertical a la derecha** |
| `gi` | Ir a implementación |
| `gr` | Ver referencias en **modal flotante** (Telescope) |
| `K` | Mostrar documentación (hover) |
| `<Space>q` | Cerrar lista de referencias/quickfix |

**Modal de referencias (después de `gr`):**
- **Navegación**: `j/k` o flechas para moverte entre referencias
- **Búsqueda**: Escribe para filtrar resultados dentro del modal
- **Enter**: Abre la referencia en **split vertical a la derecha** automáticamente
- **Esc**: Cerrar modal sin seleccionar

### Diagnósticos (Errores y Warnings)

**Marcas en el margen izquierdo:**
| Marca | Significado | Color |
|-------|-------------|-------|
| **E** | Error (debe corregirse) | Rojo |
| **W** | Warning (advertencia) | Amarillo |
| **I** | Info (información) | Azul |
| **H** | Hint (sugerencia) | Gris |

**Navegar entre diagnósticos:**
| Atajo | Descripción |
|-------|-------------|
| `]d` | Ir al siguiente diagnóstico (error/warning) |
| `[d` | Ir al diagnóstico anterior |
| `<Space>d` | Mostrar diagnóstico completo en float |
| `K` | Ver mensaje de error completo (sobre línea con E/W) |

**Ver todos los diagnósticos:**
| Atajo | Descripción |
|-------|-------------|
| `<Space>D` | Ver **todos** los diagnósticos del proyecto (atajo rápido) |
| `:Telescope diagnostics` | Comando completo (equivalente) |

**Desde lista de diagnósticos:**
- `Enter` - Ir al error en buffer actual
- `Ctrl+v` - Abrir error en split vertical a la **derecha**
- `Ctrl+x` - Abrir error en split horizontal **abajo**
- `Ctrl+t` - Abrir error en nueva pestaña

**Ejemplo**: Si ves `E` al lado de la línea 66, significa que ESLint o TypeScript detectó un error en esa línea.

### Refactorización
| Atajo | Descripción |
|-------|-------------|
| `<Space>rn` | Renombrar símbolo |
| `<Space>a` | Acciones de código (code actions, ESLint fixes) |

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

## ⚡ Flash (Navegación Rápida)

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `s` | Normal, Visual, Operator | Saltar a cualquier lugar visible en pantalla |
| `S` | Normal, Visual, Operator | Selección por treesitter |

**¿Cómo funciona?**
1. Presionás `s` en modo normal
2. Escribís 2-3 letras del lugar al que querés ir
3. Flash muestra etiquetas (letras resaltadas) junto a cada match
4. Presionás la etiqueta y saltás directo ahí

**Nota:** Solo funciona con lo que está visible en pantalla. Para navegar a otra parte del archivo primero usá `/búsqueda` y luego flash para precisión.

---

## 🔴 Trouble (Diagnósticos LSP)

| Atajo | Descripción |
|-------|-------------|
| `<Space>xx` | Panel de diagnósticos de todo el proyecto |
| `<Space>xf` | Diagnósticos del archivo actual |
| `<Space>xl` | Location list |
| `<Space>xq` | Quickfix list |

**Dentro del panel Trouble:**
- `j/k` — navegar entre items
- `Enter` — ir al error/warning
- `q` o `<Esc>` — cerrar panel

---

## 🔍 Búsqueda y Reemplazo (Spectre)

| Atajo | Descripción |
|-------|-------------|
| `<Space>sr` | Search & Replace en todo el proyecto |
| `<Space>sw` | Buscar palabra bajo el cursor |
| `<Space>sf` | Search & Replace en archivo actual |

**Dentro de Spectre:**
- Escribir texto a buscar en la primera línea
- Escribir reemplazo en la segunda línea
- `<Space>R` para reemplazar todos
- `dd` en una línea para excluirla del reemplazo

---

## 🎯 Git (LazyGit)

| Atajo | Descripción |
|-------|-------------|
| `<Space>lg` | Abrir LazyGit (interfaz git) |
| `q` (dentro de LazyGit) | Cerrar LazyGit |

**Dentro de LazyGit:**
- Navegación visual completa de git
- `Esc` funciona normalmente para cancelar operaciones
- Consulta la documentación de LazyGit para más atajos

---

## ✍️ Autocompletado

**Dos sistemas de autocompletado con teclas separadas:**

### 🤖 Codeium (Sugerencias AI inline - texto gris)
| Atajo | Descripción |
|-------|-------------|
| `Tab` | Aceptar sugerencia AI (ghost text gris) |
| `Alt+]` | Siguiente sugerencia AI |
| `Alt+[` | Sugerencia anterior AI |
| `Ctrl+x` | Cancelar sugerencia AI |

### 📋 nvim-cmp (Menú LSP - popup con opciones)
| Atajo | Descripción |
|-------|-------------|
| `Ctrl+n` | Siguiente opción en menú |
| `Ctrl+p` | Anterior opción en menú |
| `Enter` | Confirmar selección del menú |
| `Ctrl+Space` | Abrir menú manualmente |
| `Ctrl+e` | Cerrar menú |

**Fuentes nvim-cmp:** LSP, buffer, rutas de archivos

---

### 💡 Ejemplo de uso:

**Escenario 1: Solo Codeium (ghost text gris)**
```
Escribes: const user =
Codeium sugiere: { name: 'John', age: 30 }  ← texto gris
Presionas: Tab → Se acepta la sugerencia
```

**Escenario 2: Solo menú nvim-cmp**
```
Escribes: console.l
Aparece menú: log, error, warn, info...
Presionas: Ctrl+n (bajar) o Ctrl+p (subir) → Enter para confirmar
```

**Escenario 3: Ambos aparecen al mismo tiempo**
```
Codeium: muestra sugerencia gris completa
nvim-cmp: muestra menú con opciones

Opción A: Tab → Acepta sugerencia de Codeium (ignora menú)
Opción B: Ctrl+e → Cierra menú, luego Tab → Acepta Codeium
Opción C: Ctrl+n/p → Navega menú, Enter → Acepta del menú (ignora Codeium)
```

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

## 🤖 AI Inline Completions (Codeium)

**Sugerencias de código en tiempo real - GRATIS**

Codeium muestra sugerencias de código completo mientras escribes (aparece como texto gris/transparente después del cursor).

**Atajos:** Ver sección "✍️ Autocompletado" arriba para todos los atajos de Codeium y nvim-cmp.

---

## 💬 AI Code Assistant (Claude/Gemini)

| Atajo | Descripción |
|-------|-------------|
| `<Space>ai` | Menú de acciones AI |
| `<Space>ac` | Abrir/cerrar chat AI |
| `<Space>an` | Nuevo chat AI |
| `<Space>aa` | Agregar selección al chat (modo visual) |

**Configuración actual:** Anthropic Claude
**Cambiar a Gemini:** Editar `init.lua` sección codecompanion

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

### Selección y Operaciones de Texto

**Seleccionar palabras:**
| Atajo | Descripción |
|-------|-------------|
| `viw` | Seleccionar palabra bajo el cursor (inner word, sin espacios) |
| `vaw` | Seleccionar palabra + espacios adyacentes (a word) |
| `v` + `w` | Modo visual + seleccionar hasta siguiente palabra |
| `v` + `e` | Modo visual + seleccionar hasta final de palabra |

**Operaciones directas (sin modo visual):**
| Atajo | Descripción |
|-------|-------------|
| `yiw` | Copiar palabra bajo el cursor |
| `yaw` | Copiar palabra + espacios |
| `diw` | Borrar palabra bajo el cursor |
| `daw` | Borrar palabra + espacios |
| `ciw` | Cambiar palabra (borrar y entrar en insert mode) |
| `caw` | Cambiar palabra + espacios |

**Copiar/Borrar líneas:**
| Atajo | Descripción |
|-------|-------------|
| `yy` | Copiar línea completa |
| `3yy` | Copiar 3 líneas (desde la actual) |
| `dd` | Borrar línea completa |
| `3dd` | Borrar 3 líneas |
| `V` + `↓↓` + `y` | Seleccionar múltiples líneas y copiar |

**Diferencia `iw` vs `aw`:**
```
Texto: "hello world"
       ^cursor aquí

viw → Selecciona: "world"
vaw → Selecciona: " world" (incluye espacio)
```

### Manejar Archivos
| Comando | Descripción |
|---------|-------------|
| `:e archivo.txt` | Abrir/Editar archivo |
| `:saveas nuevo.txt` | Guardar como nuevo nombre |
| `:!mv % nuevo.txt` | Renombrar archivo actual |
| `:!rm %` | Eliminar archivo actual |
| **nvim-tree `r`** | Renombrar (más fácil, abre nvim-tree con `<Space>e`) |
| **nvim-tree `d`** | Eliminar (más fácil, abre nvim-tree con `<Space>e`) |

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

## 📏 Wrapping de Líneas

**✅ Activado por defecto** - Las líneas largas se envuelven visualmente sin modificar el archivo.

### Comportamiento
- `wrap = true` → Las líneas largas se muestran en múltiples líneas visuales
- `linebreak = true` → El wrap ocurre en palabras completas, no en medio de palabras
- `breakindent = true` → Mantiene la indentación en líneas wrapped

### Comandos Temporales

| Comando | Descripción |
|---------|-------------|
| `:set wrap` | Activar wrapping de líneas largas |
| `:set nowrap` | Desactivar wrapping (mostrar línea completa horizontal) |
| `:set wrap!` | Toggle (alternar entre activado/desactivado) |

**Uso práctico:**
- **Activado** (default): Ideal para leer código, documentación, archivos largos
- **Desactivado**: Útil para ver estructura horizontal de código o tablas

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
- **nvim-tree** - File explorer con bookmarks
- **Treesitter** - Syntax highlighting
- **Typst.vim** - Typst language support
- **Mason** - LSP installer
- **nvim-cmp** - Autocompletado
- **Which-key** - Muestra atajos disponibles
- **Lualine** - Statusline con modo, rama, diagnósticos
- **nvim-autopairs** - Cierre automático de brackets y quotes
- **Noice.nvim** - UI moderna para cmdline y notificaciones
- **Flash.nvim** - Navegación rápida por pantalla
- **Trouble.nvim** - Panel de diagnósticos LSP mejorado
- **Gitsigns** - Blame inline y signos de cambios git
- **Auto-Session** - Persistencia de sesiones por proyecto
- **LazyGit.nvim** - Interfaz Git visual
- **nvim-spectre** - Búsqueda y reemplazo avanzado
- **Codeium** - AI inline completions (gratis)
- **CodeCompanion** - AI code suggestions (Claude/Gemini)

---

## 💡 Tips

1. **Which-key:** Presiona `<Space>` y espera 0.5s para ver comandos disponibles
2. **Telescope:** Usa fuzzy search - no necesitas escribir el nombre completo
3. **Abrir en splits:** `Ctrl+v` (vertical) y `Ctrl+x` (horizontal) funcionan en Telescope, nvim-tree y listas de referencias
4. **Terminal:** `Esc` para salir, luego navegación normal de Neovim
5. **Splits:** `Ctrl+w o` para enfocarte en uno solo
6. **LSP:** `K` dos veces para entrar al hover popup
7. **Comentarios:** Funcionan en cualquier lenguaje automáticamente
8. **Diagnósticos:** `]d` y `[d` para navegar entre errores/warnings, `K` para ver detalles
9. **Autocompletado:** `Tab` para Codeium (AI inline), `Ctrl+n/p` para nvim-cmp (menú LSP)
10. **Conflicto de sugerencias:** Si ambos aparecen, `Ctrl+e` cierra el menú y `Tab` acepta Codeium

---

**Archivo de configuración:** `~/.config/nvim/init.lua`
**Fecha actualización:** 2026-04-15
