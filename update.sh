#!/bin/bash
echo "🔄 Updating development environment..."

echo "🍺 Updating Homebrew packages..."
brew update
brew upgrade
brew bundle install --file=Brewfile  # Install any new packages

echo "🐍 Updating Python and uv tools..."
uv python upgrade      # latest patch release of each managed Python
uv tool upgrade --all  # ruff, mypy, basedpyright, ...
uv cache prune

echo "📦 Updating Node.js packages..."
npm update -g

echo "📱 Updating Mac App Store apps..."
mas upgrade

echo "🧹 Cleaning up..."
brew cleanup
brew autoremove

echo "✅ Update complete!"
