-- ~/.config/nvim/lua/brandon/config/options.lua
local opt = vim.opt

-- Set leaders before lazy.nvim initializes
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line Numbers & Sign Column
opt.number = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Tabs & Indentation
opt.tabstop = 2
opt.softtabstop = 1
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search Mechanics
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Visual & Display Options
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 300
opt.cmdheight = 1 -- Command line height (Noice overrides if active)
opt.showmode = false -- Hide redundant '-- INSERT --' (lualine handles mode)
opt.conceallevel = 2 -- Conceal markup syntax in Markdown & JSON

-- Whitespace & Window Formatting
opt.list = true
opt.listchars = {
	tab = "   ",
	trail = "·",
	nbsp = "␣",
}
opt.fillchars = {
	eob = " ", -- Remove tilde (~) from empty lines at end of buffer
}

-- Window Splitting Logic
opt.splitbelow = true
opt.splitright = true

-- File & Undo Persistence
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Clipboard Integration (Async Wayland/X11 Support)
opt.clipboard = "unnamedplus"

-- Miscellaneous
opt.mouse = "a"
opt.confirm = true
opt.virtualedit = "block"
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-blinkon500-blinkoff500,r-cr-o:hor20"
