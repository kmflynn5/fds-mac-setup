#!/bin/bash
# Add uv shell completion and ensure ~/.local/bin is in PATH
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# Enable zsh completion system (required before any compdef-based completions)
if ! grep -q 'compinit' ~/.zshrc; then
    echo 'autoload -Uz compinit && compinit' >> ~/.zshrc
fi

# uv / uvx shell completion
if ! grep -q 'uv generate-shell-completion zsh' ~/.zshrc; then
    echo 'eval "$(uv generate-shell-completion zsh)"' >> ~/.zshrc
    echo 'eval "$(uvx --generate-shell-completion zsh)"' >> ~/.zshrc
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

# Project management
alias newproject="mkdir \$1 && cd \$1 && uv init"
alias activate-env="source .venv/bin/activate"
EOF
fi

# zsh plugins from Homebrew (syntax-highlighting must be sourced last)
if ! grep -q 'zsh-autosuggestions.zsh' ~/.zshrc; then
    cat >> ~/.zshrc << 'EOF'

# zsh plugins (keep at end of file; syntax-highlighting must be last)
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
EOF
fi

# Note: this is a bash script, so it can't reload zsh config; restart your terminal instead

# Test installations
uv --version
starship --version
echo "✅ Shell configured with aliases!"
