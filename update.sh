#!/bin/bash
echo "🔄 Updating development environment..."

echo "🍺 Updating Homebrew packages..."
brew update
brew upgrade
brew bundle install --file=Brewfile  # Install any new packages

echo "🐍 Updating Python tools..."
~/.local/share/uv/global/bin/uv pip install --upgrade \
    requests duckdb pytest ruff

# ~/.local/share/uv/global/bin/uv pip install --upgrade \
#     jupyter jupyterlab pandas numpy matplotlib seaborn \
#     scikit-learn click rich typer polars

echo "📦 Updating Node.js packages..."
npm update -g

echo "📱 Updating Mac App Store apps..."
mas upgrade

echo "🧹 Cleaning up..."
brew cleanup
brew autoremove

echo "✅ Update complete!"
