# fds-mac-setup

Opinionated macOS development environment for Python data engineering and automation. Built around modern, fast tooling: `uv` for Python, `lazy.nvim` for Neovim, `tmux` for terminal workflow.

## Prerequisites

Before running setup:

```bash
# 1. Install Xcode CLI tools
xcode-select --install

# 2. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Quick Setup

```bash
git clone <this-repo> fds-mac-setup
cd fds-mac-setup
./setup.sh
./configure-shell.sh
```

Then restart your terminal.

## What's Included

### Python
- **uv** — fast package and project management (replaces pip, virtualenv, pyenv)
- Global Python 3.11 environment at `~/.local/share/uv/global`
- `ruff`, `mypy`, `basedpyright`, `pytest`, `duckdb`, `requests` pre-installed globally

### Neovim (lazy.nvim)
- **gruvbox** colorscheme + **lualine** status bar
- **LSP** via Neovim 0.11+ native API:
  - `basedpyright` — Python type checking
  - `ruff` — Python linting and code actions
  - `sourcekit-lsp` — Swift support
- **blink.cmp** — completion engine
- **conform.nvim** — format on save (`ruff_format` + `ruff_organize_imports` for Python)
- **Telescope** — fuzzy file/grep/buffer finder
- **nvim-tree** — file explorer sidebar
- **gitsigns** + **vim-fugitive** — Git integration
- **Comment.nvim** + **nvim-surround** — editing utilities

#### Key Neovim Bindings

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>fb` | Buffers (Telescope) |
| `<leader>fo` | Recent files (Telescope) |
| `<leader>n` | Toggle file tree |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>r` | Rename symbol |
| `<leader>w` | Save |
| `<C-h/j/k/l>` | Navigate splits |

Plugin management: `:Lazy` / `:Lazy sync` / `:Lazy clean`

### Terminal
- **tmux** with TPM plugin manager
  - Session persistence (tmux-resurrect + tmux-continuum)
  - Prefix: `Ctrl-a`
- **Ghostty** terminal
- **Starship** prompt
- **Aerospace** tiling window manager
- **Karabiner-Elements** keyboard remapping (see below)

### CLI Tools
- `ripgrep`, `fd`, `bat`, `eza`, `jq`, `yq`, `tree`, `htop`
- `gh` — GitHub CLI
- `cloudflared`, `flyctl`, `wrangler` — cloud deployment
- `bun` — fast JS runtime

### Shell (zsh)
- PATH includes `~/.local/bin` for uv-managed tools
- Aliases: `ll`, `la`, `gst`, `gco`, `py`, `jl`, `uvr`, `activate`
- `vim` aliased to `nvim`

## Project Workflow

```bash
# New Python project
mkdir my-project && cd my-project
uv init
uv add pandas duckdb

# Run with env file loaded
uvr python my_script.py

# Start Jupyter Lab
jl

# New tmux session
tmux new-session -s my-project
```

## Keyboard Configuration (65% keyboards)

On 60%/65% keyboards (e.g. Keychron K6), the top-left key sends `ESC` instead of backtick/grave. This means `Shift+ESC` produces an escape sequence rather than `~`, breaking `cd ~/` and any path using tilde.

Karabiner-Elements is included to fix this. After installing and granting Input Monitoring permissions, add the following to `~/.config/karabiner/karabiner.json` under your profile:

```json
"complex_modifications": {
    "rules": [
        {
            "description": "Shift+Escape to Tilde (65% keyboard)",
            "manipulators": [
                {
                    "type": "basic",
                    "from": {
                        "key_code": "escape",
                        "modifiers": { "mandatory": ["shift"] }
                    },
                    "to": [
                        {
                            "key_code": "grave_accent_and_tilde",
                            "modifiers": ["shift"]
                        }
                    ]
                }
            ]
        }
    ]
}
```

This maps `Shift+ESC` → `~` while leaving `ESC` alone.

## Firefox

Pair with [Betterfox](https://github.com/yokoffing/Betterfox) for speed and privacy:

1. Start Firefox to create a profile
2. `curl -o ~/Downloads/user.js https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js`
3. Copy to `~/Library/Application Support/Firefox/Profiles/*/user.js`
4. Restart Firefox and install uBlock Origin
