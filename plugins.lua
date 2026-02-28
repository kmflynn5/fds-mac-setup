return {
    -- Appearance
    { "gruvbox-community/gruvbox", config = function() vim.cmd.colorscheme("gruvbox") end },
    { "nvim-lualine/lualine.nvim", opts = { options = { theme = 'gruvbox' } } },

    -- Navigation
    { "nvim-tree/nvim-tree.lua", opts = {}, keys = { { "<leader>n", ":NvimTreeToggle<CR>" } } },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help tags" },
            { "<leader>fo", "<cmd>Telescope oldfiles<cr>",    desc = "Recent files" },
        },
    },

    -- Git
    { "lewis6991/gitsigns.nvim", opts = {} },
    { "tpope/vim-fugitive" },

    -- Editing
    { "numToStr/Comment.nvim", opts = {} },
    { "kylechui/nvim-surround", opts = {} },

    -- LSP & Completion (Neovim 0.11+ API)
    {
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp" },
        config = function()
            -- Python: config must precede enable per 0.11+ docs
            vim.lsp.config('basedpyright', {
                settings = { python = { pythonPath = vim.fn.getcwd() .. '/.venv/bin/python' } }
            })
            vim.lsp.enable('basedpyright')

            -- Ruff: linting and code actions (let basedpyright handle hover)
            vim.lsp.config('ruff', {
                on_attach = function(client)
                    client.server_capabilities.hoverProvider = false
                end,
            })
            vim.lsp.enable('ruff')

            -- Swift
            vim.lsp.enable('sourcekit')

            -- LSP keybindings
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
                end,
            })
        end
    },

    -- Completion Engine
    { "saghen/blink.cmp", version = '*', opts = { keymap = { preset = 'default' } } },

    -- Formatting
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                python = { "ruff_format", "ruff_organize_imports" },
                swift = { "swiftlint" },
            },
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
        },
    },
}
