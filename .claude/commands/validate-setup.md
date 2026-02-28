Run a full validation of the fds-mac-setup repo changes. Execute each check in sequence and report pass/fail:

1. **Shell syntax**: Run `bash -n setup.sh` and `bash -n configure-shell.sh` — report any syntax errors
2. **Brewfile**: Run `brew bundle check --file=Brewfile` — verify all formulae/casks are resolvable
3. **Lua syntax**: Run `luac -p init.lua` and `luac -p plugins.lua` (if luac is available) — check for Lua parse errors
4. **Neovim headless sync**: Run `nvim --headless "+Lazy! sync" +qa` — install/sync plugins and capture any errors
5. **LSP health**: Run `nvim --headless -c "checkhealth lsp" -c "qa"` — report LSP server status
6. **Git safety**: Run `git status` and confirm no .env files or sensitive data are staged

Summarize results as a checklist with ✅/❌ per step.
