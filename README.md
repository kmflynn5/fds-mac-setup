# fds-mac-setup

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
