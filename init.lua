-- Disable unused legacy remote plugin providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- ~~~~~~~~~~~~~~ PORTED BASIC SETTINGS ~~~~~~~~~~~~~~
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.updatetime = 300

-- ~~~~~~~~~~~~~~ PORTED DIRECTORY SETUP ~~~~~~~~~~~~~~
local config_path = vim.fn.stdpath("config")
local dirs = { "backup", "undo" }
for _, dir in ipairs(dirs) do
    local path = config_path .. "/" .. dir
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p", 0700)
    end
end
opt.backup = true
opt.undofile = true

-- ~~~~~~~~~~~~~~ PORTED KEYMAPS ~~~~~~~~~~~~~~
vim.g.mapleader = " "
local key = vim.keymap
key.set("n", "<leader>w", ":w<CR>")
key.set("n", "<leader>q", ":q<CR>")
key.set("n", "<C-h>", "<C-w>h")
key.set("n", "<C-j>", "<C-w>j")
key.set("n", "<C-k>", "<C-w>k")
key.set("n", "<C-l>", "<C-w>l")
key.set({ "x", "s" }, "<C-c>", '"+y', { noremap = true, desc = "Copy selection to clipboard without cutting" })
key.set({ "x", "s" }, "<D-c>", '"+y', { noremap = true, desc = "Copy selection to clipboard without cutting (Cmd+C)" })

-- ~~~~~~~~~~~~~~ PLUGIN SETUP (LAZY.NVIM) ~~~~~~~~~~~~~~
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", { rocks = { enabled = false } })
