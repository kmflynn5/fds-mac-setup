" Neovim Configuration for Python and Swift Development
" Place this file at ~/.config/nvim/init.vim or ~/.vimrc

" Basic Settings
set number relativenumber           " Show line numbers (relative)
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab    " 4 spaces for tabs
set autoindent smartindent          " Auto and smart indentation
set wrap                           " Wrap lines
set hlsearch incsearch             " Search highlighting and incremental search
set ignorecase smartcase           " Smart case searching
set mouse=a                        " Mouse support
set clipboard=unnamedplus          " Use system clipboard
set updatetime=300                 " Faster completion
set timeoutlen=500                 " Faster key sequence completion
set hidden                         " Allow hidden buffers
set splitbelow splitright          " Natural split behavior
set termguicolors                  " True color support
set backspace=indent,eol,start     " Better backspace behavior

" Create directories if they don't exist
if !isdirectory($HOME."/.config")
    call mkdir($HOME."/.config", "", 0770)
endif
if !isdirectory($HOME."/.config/nvim")
    call mkdir($HOME."/.config/nvim", "", 0700)
endif
if !isdirectory($HOME."/.config/nvim/backup")
    call mkdir($HOME."/.config/nvim/backup", "", 0700)
endif
if !isdirectory($HOME."/.config/nvim/undo")
    call mkdir($HOME."/.config/nvim/undo", "", 0700)
endif

" Backup and undo settings
set backup
set backupdir=~/.config/nvim/backup
set undofile
set undodir=~/.config/nvim/undo

" Plugin Management with vim-plug
" Install vim-plug if not already installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

" Essential plugins
Plug 'dense-analysis/ale'                    " Asynchronous Lint Engine
Plug 'preservim/nerdtree'                    " File explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                      " Fuzzy finder
Plug 'tpope/vim-commentary'                  " Easy commenting
Plug 'tpope/vim-surround'                    " Surround text with quotes, brackets, etc.
Plug 'tpope/vim-fugitive'                    " Git integration
Plug 'airblade/vim-gitgutter'                " Git diff in gutter
Plug 'vim-airline/vim-airline'               " Status line
Plug 'vim-airline/vim-airline-themes'        " Status line themes

" Python-specific plugins
Plug 'neovim/nvim-lspconfig'                 " Modern fork of Pyright
Plug 'saghen/blink.cmp'                      " Python autocompletion

" Swift-specific plugins
Plug 'keith/swift.vim'                       " Swift syntax and indentation
Plug 'apple/sourcekit-lsp'                   " Swift language server support

" Git enhancements
Plug 'lewis6991/gitsigns.nvim'               " Better git integration for nvim
Plug 'sindrets/diffview.nvim'                " Better git diff views

" Color schemes
Plug 'gruvbox-community/gruvbox'
Plug 'morhetz/gruvbox'

call plug#end()

" Color scheme
set background=dark
colorscheme gruvbox

" Key mappings
let mapleader = " "                          " Space as leader key

" General mappings
nnoremap <leader>w :w<CR>                    " Save file
nnoremap <leader>q :q<CR>                    " Quit
nnoremap <leader>wq :wq<CR>                  " Save and quit
nnoremap <C-h> <C-w>h                        " Navigate splits
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" FZF
nnoremap <leader>p :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>/ :Rg<CR>

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" ALE Configuration
let g:ale_enabled = 1
let g:ale_completion_enabled = 0  " Disable to avoid conflicts
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'never'  " Only lint on save for performance
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1

" ALE signs
let g:ale_sign_error = '_'
let g:ale_sign_warning = '_'
let g:ale_sign_info = '_'
let g:ale_sign_style_error = '✗'
let g:ale_sign_style_warning = '⚠'

" Python linters and fixers
let g:ale_linters = {
\   'python': ['ruff', 'mypy'],
\   'swift': ['swiftlint'],
\   'markdown': ['markdownlint'],
\}

let g:ale_fixers = {
\   'python': ['ruff'],
\   'swift': ['swiftlint'],
\   'markdown': ['prettier'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

" Auto-fix on save
let g:ale_fix_on_save = 1

" Better error display
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_loclist_msg_format = '[%linter%] %s [%severity%]'

" ALE navigation
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)
nmap <silent> <leader>d <Plug>(ale_detail)
nmap <silent> <leader>af <Plug>(ale_fix)
nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gr <Plug>(ale_find_references)

" Python-specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType python setlocal textwidth=88  " Black's line length
autocmd FileType python nnoremap <leader>r :!python %<CR>
autocmd FileType python nnoremap <leader>t :!python -m pytest<CR>

" Swift-specific settings
autocmd FileType swift setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType swift setlocal textwidth=120  " SwiftLint line length
autocmd FileType swift setlocal commentstring=//\ %s
autocmd FileType swift nnoremap <leader>r :!swift %<CR>
autocmd FileType swift nnoremap <leader>sl :!swiftlint lint --quiet %<CR>
autocmd FileType swift nnoremap <leader>sf :!swiftlint autocorrect %<CR>
autocmd FileType swift nnoremap <leader>sb :!cd %:h && !swift build<CR>
autocmd FileType swift nnoremap <leader>st :!cd %:h && !swift test<CR>
autocmd FileType swift nnoremap <leader>x :!open -a Xcode %<CR>
autocmd FileType swift nnoremap <leader>ios :!cd ios-app && xcodebuild -project GroundedPhotos.xcodeproj -scheme GroundedPhotos -destination 'platform=iOS Simulator,name=iPhone 15' build<CR>
autocmd FileType swift nnoremap <leader>sim :!open -a Simulator<CR>

lua << EOF
-- 1. Configure Completion (Blink)
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})

-- 2. Modern LSP Setup (Neovim 0.11+ style)
-- This replaces the old require('lspconfig').basedpyright.setup{}
vim.lsp.enable('basedpyright')

-- 3. Configure the server to find your 'uv' virtualenv
vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        autoImportCompletions = true,
      },
      python = {
        -- Automatically find the .venv/bin/python created by uv
        pythonPath = vim.fn.getcwd() .. '/.venv/bin/python'
      }
    }
  }
})

-- 4. Keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    -- Jedi-style habits
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)     -- Go to definition
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)          -- Show docs
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)  -- Rename
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)     -- Show usages
  end,
})
EOF

" Jedi-vim configuration
let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0  " Use ALE for completions
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = "1"
let g:jedi#show_call_signatures_delay = 0

" Jedi mappings
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = "<leader>s"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>u"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>rn"

" Airline configuration
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'gruvbox'

" NERDTree configuration
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Auto-pairs for brackets, quotes, etc.
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Enable syntax highlighting
syntax enable
filetype plugin indent on

" Swift file templates
function! SwiftTemplate()
    if line('$') == 1 && getline(1) == ''
        call setline(1, [
        \ '//',
        \ '//  ' . expand('%:t'),
        \ '//  GroundedPhotos',
        \ '//',
        \ '//  Created by ' . $USER . ' on ' . strftime('%m/%d/%Y') . '.',
        \ '//',
        \ '',
        \ 'import Foundation',
        \ 'import SwiftUI',
        \ ''
        \ ])
        normal! G
    endif
endfunction

autocmd BufNewFile *.swift call SwiftTemplate()

" Custom status line (ALE info is shown via airline extension)
" Airline already displays ALE info, so we don't need a custom statusline
