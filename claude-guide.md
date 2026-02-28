# Homebrew Python Dev Environment - Starter Kit

## Quick Start (30 minutes to get running)

### 1. Install Homebrew (if needed)
```bash
# Check if you already have it
which brew

# If not installed:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Follow the "Next steps" instructions to add Homebrew to your PATH
```

### 2. Create Your Setup Directory
```bash
mkdir ~/dev-setup
cd ~/dev-setup
```

### 3. Create Your First Brewfile

Create a file called `Brewfile` with these essentials:

```ruby
# Brewfile - Data Science & Automation Environment

# Core Python tools
brew "uv"                    # Fast Python package and version management

# Essential development tools
brew "git"               # Version control
brew "gh"                # GitHub CLI
brew "neovim"            # Text editor
brew "tmux"              # Terminal multiplexer

# Node.js for Claude Code
brew "node"              # Node.js runtime
brew "npm"               # Node package manager

# Data science tools
brew "jupyter"           # Jupyter notebooks
brew "pandoc"            # Document conversion
brew "graphviz"          # Graph visualization
brew "imagemagick"       # Image processing

# Useful utilities
brew "tree"              # Directory visualization
brew "htop"              # Better top command
brew "jq"                # JSON processor
brew "yq"                # YAML processor
brew "curl"              # HTTP client
brew "wget"              # File downloader
brew "ripgrep"           # Fast text search
brew "fd"                # Fast file find
brew "bat"               # Better cat with syntax highlighting
brew "eza"               # Better ls with colors

# Terminal improvements
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "starship"          # Cross-shell prompt

# Database tools
brew "postgresql@15"     # PostgreSQL database
brew "sqlite"            # SQLite database
brew "redis"             # Redis cache/database

# Browser
cask "firefox"           # Fast, privacy-focused browser (pair with Betterfox)

# Terminal and productivity
cask "ghostty"           # Modern terminal
cask "nikitabobko/tap/aerospace"  # Tiling window manager
cask "docker"            # Containerization

# Optional productivity apps
cask "raycast"           # Modern launcher with developer tools (recommended)
# cask "alfred"          # Alternative: traditional launcher
cask "bitwarden"         # Password manager (optional)

# Family/Personal apps
cask "vlc"               # Media player for family videos
cask "zoom"              # Video calls with family

# Database GUI (lighter than TablePlus)
cask "db-browser-for-sqlite"  # SQLite browser

# Mac App Store CLI
brew "mas"

# Optional: Scientific computing support
tap "homebrew/cask-fonts"
cask "font-jetbrains-mono-nerd-font"  # Programming font with icons
```

### 4. Install Everything
```bash
# Install all packages from your Brewfile
brew bundle install --file=Brewfile

# This might take 10-15 minutes depending on your internet speed
```

## Python Environment Setup (15 minutes)

### 5. Configure Shell (Optional but Recommended)
```bash
# Add uv shell completion and ensure ~/.local/bin is in PATH
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# Configure Starship prompt
if ! grep -q 'eval "$(starship init zsh)"' ~/.zshrc; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

# Create Starship config directory and basic config
mkdir -p ~/.config
cat > ~/.config/starship.toml << 'EOF'
# Starship configuration for data science workflow
add_newline = true

format = """
$directory\
$git_branch\
$git_status\
$python\
$nodejs\
$cmd_duration\
$line_break\
$character"""

[directory]
style = "blue"
truncation_length = 3

[git_branch]
symbol = " "
style = "bright-green"

[git_status]
ahead = "⇡${count}"
behind = "⇣${count}"

[python]
symbol = "🐍 "
style = "yellow"

[nodejs]
symbol = "⬢ "
style = "green"

[cmd_duration]
min_time = 2_000
style = "yellow"
format = '⚡[$duration]($style) '

[character]
success_symbol = "[❯](purple)"
error_symbol = "[❯](red)"
EOF

# Add useful aliases only if not already present
if ! grep -q "# Useful aliases (using eza for better ls)" ~/.zshrc; then
    cat >> ~/.zshrc << 'EOF'

# Useful aliases (using eza for better ls)
alias ll="eza -la --header --git"
alias la="eza -a"
alias l="eza -F"
alias ls="eza"

# Git aliases
alias gst="git status"
alias gco="git checkout"
alias gaa="git add ."
alias gcm="git commit -m"
alias gps="git push"
alias gpl="git pull"
alias glg="git log --oneline --graph --decorate"

# Data science aliases
alias jl="uv run --env-file .env jupyter lab"
alias jn="uv run --env-file .env jupyter notebook"
alias py="uv run --env-file .env python"
alias ipy="uv run --env-file .env ipython"
alias uvr="uv run --env-file .env"
alias activate="source .venv/bin/activate"

# System aliases
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias cls="clear"
alias h="history"
alias grep="grep --color=auto"

# Modern CLI tools
alias cat="bat --paging=never"
# Use "command cat" or "\cat" for original cat when needed
# Note: fd has different syntax than find, use fd directly

# Project management
alias newproject="mkdir \$1 && cd \$1 && uv init"
alias activate-env="source .venv/bin/activate"
EOF
fi

# Reload shell
source ~/.zshrc

# Test installations
uv --version
starship --version
echo "✅ Shell configured with aliases!"
```

### 6. Install Global Python Tools for Data Science
```bash
# Create a global virtual environment using uv
uv venv ~/.local/share/uv/global --python 3.11

# Install data science and automation tools using system uv
uv pip install --python ~/.local/share/uv/global/bin/python \
    jupyter \
    jupyterlab \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn \
    requests \
    click \
    rich \
    typer \
    polars \
    duckdb \
    pytest \
    ruff

# Create convenient symlinks for global access
mkdir -p ~/.local/bin
ln -sf ~/.local/share/uv/global/bin/jupyter ~/.local/bin/jupyter
ln -sf ~/.local/share/uv/global/bin/jupyter-lab ~/.local/bin/jupyter-lab
ln -sf ~/.local/share/uv/global/bin/ruff ~/.local/bin/ruff
ln -sf ~/.local/share/uv/global/bin/python ~/.local/bin/python
ln -sf ~/.local/share/uv/global/bin/python ~/.local/bin/python3

ln -sf ~/.local/share/uv/global/bin/python ~/.local/bin/python
ln -sf ~/.local/share/uv/global/bin/python ~/.local/bin/python3

# Verify installations
jupyter --version
ruff --version
python -c "import sys; print(f'Using Python: {sys.executable}')"
```

## Create Automation Scripts

### 7. Setup Script
Create `setup.sh`:

```bash
#!/bin/bash
set -e

echo "🚀 Setting up Python development environment..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install it first:"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

echo "🍺 Installing Homebrew packages..."
brew bundle install --file=Brewfile

echo "🐍 Setting up Python environments..."
# Create global uv environment with Python 3.11
uv venv ~/.local/share/uv/global --python 3.11

echo "📦 Installing global Python tools with uv..."
# Install data science tools using system uv, not the venv one
uv pip install --python ~/.local/share/uv/global/bin/python \
    jupyter jupyterlab pandas numpy matplotlib seaborn \
    scikit-learn requests click rich typer polars duckdb \
    pytest ruff

# Create symlinks for global access
mkdir -p ~/.local/bin
ln -sf ~/.local/share/uv/global/bin/jupyter ~/.local/bin/jupyter
ln -sf ~/.local/share/uv/global/bin/jupyter-lab ~/.local/bin/jupyter-lab
ln -sf ~/.local/share/uv/global/bin/ruff ~/.local/bin/ruff

echo "🌐 Setting up Firefox with Betterfox..."
echo "📝 Manual step: After Firefox first run, install Betterfox:"
echo "   1. Start Firefox to create profile"
echo "   2. Download: curl -o ~/Downloads/user.js https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js"
echo "   3. Copy to profile: ~/Library/Application Support/Firefox/Profiles/*/user.js"
echo "   4. Restart Firefox"

echo "🖥️ Setting up terminal environment..."
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code

# Install Tmux Plugin Manager
if [ ! -d ~/.config/tmux/plugins/tpm ]; then
    echo "📦 Installing Tmux Plugin Manager..."
    mkdir -p ~/.config/tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    # Create backward compatibility symlink
    mkdir -p ~/.tmux/plugins
    ln -sf ~/.config/tmux/plugins/tpm ~/.tmux/plugins/tpm
fi

# Configure enhanced tmux
echo "⚙️ Setting up enhanced tmux configuration..."
cat > ~/.tmux.conf << 'EOF'
# Enhanced Tmux Configuration for Data Science

# Enable mouse support
set -g mouse on

# Set prefix to Ctrl-a
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Split panes with | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# Start windows and panes at 1
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Enable vi mode for copy mode
setw -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# Pane navigation with hjkl
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Pane resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Quick window switching
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5

# Create new window in current path
bind c new-window -c "#{pane_current_path}"

# Create new panes in current path
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# Increase scrollback buffer
set -g history-limit 10000

# Set terminal colors
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color*:Tc"

# Reduce escape time for neovim
set -sg escape-time 10

# Plugin Manager
set -g @plugin 'tmux-plugins/tpm'

# Essential plugins for data science workflow
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g @plugin 'sainnhe/tmux-fzf'
set -g @plugin 'fcsonline/tmux-thumbs'

# Beautiful status bar
set -g @plugin 'wfxr/tmux-power'
set -g @tmux_power_theme 'sky'

# Plugin configurations
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'
set -g @tmux-fzf-launch-key 'C-f'
set -g @thumbs-key F

# Resurrect settings for data science tools
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-processes 'jupyter jupyter-lab python3 node npm'

# Status bar configuration
set -g status-position top
set -g status-interval 2

# Custom key bindings for data science workflow
bind D new-session -d -s data-analysis -c ~/data
bind A new-session -d -s automation -c ~/scripts
bind J new-window -n jupyter 'cd ~/notebooks && jupyter lab'

# Initialize TMUX plugin manager (keep this line at the very bottom)
run '~/.tmux/plugins/tpm/tpm'
EOF

# Install tmux plugins automatically
echo "📦 Installing tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins

echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Test Python: python --version"
echo "3. Create project directories: mkdir -p ~/data ~/scripts ~/notebooks"
echo "4. Test tmux: tmux new-session -s test"
echo "5. Install tmux plugins: Prefix + I (Ctrl-a then Shift+i)"
echo "6. Open Neovim: nvim test.py"
```

### 8. Update Script
Create `update.sh`:

```bash
#!/bin/bash
echo "🔄 Updating development environment..."

echo "🍺 Updating Homebrew packages..."
brew update
brew upgrade
brew bundle install --file=Brewfile  # Install any new packages

echo "🐍 Updating Python tools..."
~/.local/share/uv/global/bin/uv pip install --upgrade \
    jupyter jupyterlab pandas numpy matplotlib seaborn \
    scikit-learn requests click rich typer polars duckdb \
    pytest black ruff

echo "📦 Updating Node.js packages..."
npm update -g

echo "📱 Updating Mac App Store apps..."
mas upgrade

echo "🧹 Cleaning up..."
brew cleanup
brew autoremove

echo "✅ Update complete!"
```

### 9. Make Scripts Executable
```bash
chmod +x setup.sh update.sh
```

## Test Your Setup

### 10. Quick Test
```bash
# Test uv
uv --version

# Test global tools
jupyter --version

# Test Node.js
node --version
claude-code --version

# Test Docker
docker --version
```

### 11. Create a Test Data Science Project
```bash
# Create a new project directory
mkdir test-data-project
cd test-data-project

# Initialize with uv (automatically detects/downloads Python)
uv init

# Add data science dependencies
uv add pandas numpy matplotlib seaborn jupyter

# Create a simple test script
cat > analyze.py << 'EOF'
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Create sample data
data = pd.DataFrame({
    'x': np.random.randn(100),
    'y': np.random.randn(100)
})

print("✅ Data science environment working!")
print(f"Dataset shape: {data.shape}")
print(f"Pandas version: {pd.__version__}")

# Create a simple plot
plt.figure(figsize=(8, 6))
plt.scatter(data['x'], data['y'], alpha=0.6)
plt.xlabel('X values')
plt.ylabel('Y values')
plt.title('Sample Data Visualization')
plt.savefig('sample_plot.png', dpi=150, bbox_inches='tight')
print("📊 Plot saved as sample_plot.png")
EOF

# Test the environment
uv run python analyze.py

# Test Jupyter (starts in background)
echo "🚀 Starting Jupyter Lab..."
echo "Access it at: http://localhost:8888"
uv run jupyter lab --no-browser --port=8888 &
JUPYTER_PID=$!
echo "Jupyter PID: $JUPYTER_PID (use 'kill $JUPYTER_PID' to stop)"
```

## Version Control Your Setup

### 12. Initialize Git Repository
```bash
cd ~/dev-setup

# Create .gitignore
cat > .gitignore << EOF
.DS_Store
Brewfile.lock.json
*.log
EOF

# Initialize repository
git init
git add .
git commit -m "Initial Mac development environment setup"

# Optional: Push to GitHub
# git remote add origin https://github.com/yourusername/mac-dev-setup.git
# git push -u origin main
```

### 14. Create Documentation
Create `README.md`:

```markdown
# My Mac Development Environment

Automated setup for Python development on macOS.

## Quick Setup

1. Clone this repository
2. Run `./setup.sh`
3. Restart terminal
4. Start coding!

## What's Included

- Python 3.11 & 3.12 with pyenv
- uv for fast dependency management
- Essential data science libraries (pandas, numpy, matplotlib, etc.)
- Firefox with Betterfox optimization for speed and privacy
- Neovim for text editing
- Tmux for terminal multiplexing
- Node.js and Claude Code CLI
- Ghostty terminal
- Useful CLI tools (ripgrep, fd, bat, eza)

## Regular Maintenance

Run `./update.sh` weekly to keep everything current.

## Quick Commands

```bash
# Start a new data science project
mkdir my-analysis && cd my-analysis
uv init
uv add pandas numpy matplotlib jupyter

# Run Jupyter Lab
uv run jupyter lab

# Open optimized Firefox
open -a Firefox

# Create a tmux session for a project
tmux new-session -s analysis
```

## Customization

Edit `Brewfile` to add/remove packages, then run:
```bash
brew bundle install --file=Brewfile
```
```

## Next Steps & Customization

### 15. Customize Your Brewfile
Based on your specific needs, consider adding:

```ruby
# For web development
brew "node"
brew "yarn"
cask "firefox"

# For data science
brew "r"
cask "rstudio"

# For mobile development
cask "android-studio"

# For design/frontend
cask "figma"
cask "sketch"
```

### 15. VS Code Extensions
After setup, install useful VS Code extensions:

```bash
# Python development
code --install-extension ms-python.python
code --install-extension ms-python.flake8
code --install-extension ms-python.black-formatter

# General development
code --install-extension eamodio.gitlens
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension bradlc.vscode-tailwindcss
```

## Troubleshooting Common Issues

### Tmux Not Starting
```bash
# Check tmux installation
which tmux

# Start a new session
tmux new-session -s main

# Common tmux commands:
# Ctrl-a + | : split vertically
# Ctrl-a + - : split horizontally
# Ctrl-a + d : detach session
# tmux attach -t main : reattach to session
```

### UV/Python Issues
```bash
# Check uv installation
which uv

# Check Python environment
~/.local/share/uv/global/bin/python --version

# Recreate global environment if needed
rm -rf ~/.local/share/uv/global
uv venv ~/.local/share/uv/global --python 3.11
```

## Tmux Plugin Usage Guide

### Essential Key Bindings (Prefix = Ctrl-a)

**Session Management:**
- `Prefix + D` - Create new data analysis session
- `Prefix + A` - Create new automation session  
- `Prefix + J` - Open Jupyter Lab in new window
- `Prefix + Ctrl-f` - Fuzzy find sessions/windows
- `Prefix + d` - Detach from session
- `tmux attach -t session-name` - Reattach to session

**Session Persistence:**
- `Prefix + Ctrl-s` - Save session state
- `Prefix + Ctrl-r` - Restore session state
- Sessions auto-save every 15 minutes

**Quick Text Selection:**
- `Prefix + F` - Activate thumbs mode (click highlighted text)

**Pane Management:**
- `Prefix + |` - Split vertically
- `Prefix + -` - Split horizontally
- `Prefix + h/j/k/l` - Navigate panes (vim-style)
- `Prefix + H/J/K/L` - Resize panes

**Copy Mode:**
- `Prefix + [` - Enter copy mode
- `v` - Start selection (in copy mode)
- `y` - Copy selection to clipboard

### Workflow Examples

**Start Data Science Session:**
```bash
# Method 1: Quick binding
tmux new-session
# Then: Prefix + D (creates data-analysis session)

# Method 2: Manual
tmux new-session -s ml-project -c ~/data
```

**Multi-pane Setup:**
```bash
# Start session
tmux new-session -s analysis

# Split for different tasks:
# Prefix + | (split vertically)
# Left pane: nvim analysis.py  
# Right pane: uv run jupyter lab
# Prefix + - (split right pane horizontally)
# Bottom right: htop (monitor resources)
```

**Save/Restore Workflow:**
```bash
# Working on long analysis, need to close laptop
# Prefix + Ctrl-s (manual save, though auto-save is enabled)
# Close laptop, go home
# tmux attach -t analysis (everything restored exactly as left)
```

---
```bash
# Verify Node.js and npm
node --version
npm --version

# Install/reinstall Claude Code
npm install -g @anthropic-ai/claude-code

# Verify installation
claude-code --version
```

## Success Checklist

After running the setup, verify:

- [ ] `python --version` shows correct version
- [ ] `python --version` shows correct version
- [ ] `uv --version` works
- [ ] `nvim --version` opens Neovim
- [ ] `tmux new-session -s test` creates a tmux session
- [ ] `jupyter lab` starts JupyterLab
- [ ] `claude-code --version` shows Claude Code CLI
- [ ] `ghostty` opens the terminal (if installed)
- [ ] Git is configured with your details
- [ ] `python -c "import pandas, numpy; print('Data science ready!')"` works

## Time Investment

- **Initial setup**: 45-60 minutes
- **Learning curve**: 1-2 days to get comfortable with workflow
- **Weekly maintenance**: 5 minutes running `./update.sh`

## Data Science Workflow Examples

### Quick Analysis Script
```bash
mkdir quick-analysis && cd quick-analysis
uv init
uv add pandas matplotlib seaborn
echo "import pandas as pd; print('Ready for analysis!')" > analyze.py
uv run python analyze.py
```

### Jupyter Notebook Session
```bash
# Start tmux session for organization
tmux new-session -s analysis

# In tmux, start Jupyter
uv run jupyter lab

# Detach from tmux: Ctrl-a + d
# Reattach later: tmux attach -t analysis
```

### Automation Script Development
```bash
mkdir automation-script && cd automation-script
uv init
uv add click rich requests
# Edit with nvim, test with uv run
```

This setup gives you a powerful, lightweight environment optimized for data science and automation work!
