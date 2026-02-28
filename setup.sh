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
    requests duckdb pytest ruff

# TODO: install DS extras?
# uv pip install --python ~/.local/share/uv/global/bin/python \
#     jupyter jupyterlab pandas numpy matplotlib seaborn \
#     scikit-learn click rich typer polars

# Create symlinks for global access
mkdir -p ~/.local/bin
# ln -sf ~/.local/share/uv/global/bin/jupyter ~/.local/bin/jupyter
# ln -sf ~/.local/share/uv/global/bin/jupyter-lab ~/.local/bin/jupyter-lab
ln -sf ~/.local/share/uv/global/bin/ruff ~/.local/bin/ruff
ln -sf ~/.local/share/uv/global/bin/python ~/.local/bin/python
ln -sf ~/.local/share/uv/global/bin/python ~/.local/bin/python3

# Create vim -> neovim alias
echo "alias vim=nvim" >> ~/.zshrc

echo "Manual step: run `configure-shell.sh` to setup aliases and starship"

echo "🌐 Setting up Firefox with Betterfox..."
echo ".. https://github.com/yokoffing/Betterfox" 
echo "📝 Manual step: After Firefox first run, install Betterfox:"
echo "   1. Start Firefox to create profile"
echo "   2. Download: curl -o ~/Downloads/user.js https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js"
echo "   3. Copy to profile: ~/Library/Application Support/Firefox/Profiles/*/user.js"
echo "   4. Restart Firefox"
echo "   5. Install Adblocker (uBlock Origin) and setup filters"

echo "🖥️ Setting up terminal environment..."
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code

# Install Tmux Plugin Manager
if [ ! -d ~/.config/tmux/plugins/tpm ]; then
    echo "📦 Installing Tmux Plugin Manager..."
    mkdir -p ~/.config/tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    
    # Create backward compatibility symlinks
    mkdir -p ~/.tmux/plugins
    ln -sf ~/.config/tmux/plugins/tpm ~/.tmux/plugins/tpm
fi

# Configure enhanced tmux
echo "⚙️ Setting up enhanced tmux configuration..."
mkdir -p ~/.config/tmux
cat > ~/.config/tmux/tmux.conf << 'EOF'
# Enhanced Tmux Configuration

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
bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

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
run '~/.config/tmux/plugins/tpm/tpm'
EOF

# Create symlink for backward compatibility
if [ ! -f ~/.tmux.conf ]; then
    ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
fi

# Install tmux plugins automatically
echo "📦 Installing tmux plugins..."
~/.config/tmux/plugins/tpm/bin/install_plugins

echo "📝 Setting up Neovim configuration..."
# Create neovim config directory
mkdir -p ~/.config/nvim

# Install vim-plug if not already installed
if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
    echo "📦 Installing vim-plug..."
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# Copy neovim configuration
cp init.vim ~/.config/nvim/init.vim

# Install additional Python tools for neovim (ruff already installed, just add mypy)
echo "📦 Installing Python tools for IDE support..."
uv pip install --python ~/.local/share/uv/global/bin/python mypy

echo "📝 Installing neovim plugins..."
# Install vim-plug plugins automatically
nvim --headless +PlugInstall +qall

echo "✅ Neovim configuration complete!"
echo "📝 To manually manage plugins later:"
echo "   :PlugInstall - Install new plugins"
echo "   :PlugUpdate  - Update all plugins"
echo "   :PlugClean   - Remove unused plugins"

echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Test Python: python --version"
echo "3. Create project directories: mkdir -p ~/data ~/scripts ~/notebooks"
echo "4. Test tmux: tmux new-session -s test"
echo "5. Install tmux plugins: Prefix + I (Ctrl-a then Shift+i)"
echo "6. Open Neovim: nvim test.py"
