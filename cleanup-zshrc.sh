#!/bin/bash
# Clean up .zshrc duplicates and reorganize

set -e

echo "🧹 Cleaning up .zshrc duplicates..."

# Backup current .zshrc
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
echo "📁 Backup created: ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"

# Remove our specific duplicates
echo "🔍 Removing duplicate entries..."

# Create temporary file with duplicates removed
cat ~/.zshrc | \
    grep -v 'export PATH="$HOME/.local/bin:$PATH"' | \
    grep -v 'eval "$(starship init zsh)"' | \
    awk '!seen[$0]++' > ~/.zshrc.tmp

# Remove any existing alias blocks we might have added
sed -i '' '/# Useful aliases (using eza for better ls)/,/# Project management/d' ~/.zshrc.tmp 2>/dev/null || true

# Move cleaned file back
mv ~/.zshrc.tmp ~/.zshrc

echo "✅ Duplicates removed"
echo "📝 You can now re-run your setup script to add clean configurations"
echo ""
echo "💡 To see what was removed, compare:"
echo "   diff ~/.zshrc.backup.* ~/.zshrc"
