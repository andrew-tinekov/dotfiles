vim.g.mapleader = " "

vim.g.loaded_2html_plugin = 0
vim.g.loaded_gzip = 0
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0
vim.g.loaded_remote_plugins = 0
vim.g.loaded_tarPlugin = 0
vim.g.loaded_zipPlugin = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- UI
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 8
vim.o.showmode = false
vim.o.laststatus = 3
vim.o.cmdheight = 0
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.wrap = false
vim.o.list = true
vim.opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣", extends = "…", precedes = "…" }

-- Editing
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.inccommand = "split"

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Behaviour
vim.o.mouse = "a"
vim.o.confirm = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
