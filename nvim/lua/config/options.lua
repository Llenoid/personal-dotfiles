-- ~/.config/nvim/lua/brandon/config/options.lua
local o = vim.opt

-- Set leaders before lazy.nvim initializes
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line Numbers & Sign Column
o.number = true
o.signcolumn = "yes"
o.cursorline = true

-- Tabs & Indentation
o.tabstop = 2
o.softtabstop = 1
o.shiftwidth = 2
o.expandtab = true
o.autoindent = true
o.smartindent = true

-- Search Mechanics
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

-- Visual & Display Options
o.termguicolors = true
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8
o.updatetime = 250
o.timeoutlen = 300
o.cmdheight = 1 -- Command line height (Noice overrides if active)
o.showmode = false -- Hide redundant '-- INSERT --' (lualine handles mode)
o.conceallevel = 2 -- Conceal markup syntax in Markdown & JSON
o.inccommand = split -- split preview for commands
o.cmdwinheight = 20

-- Whitespace & Window Formatting
o.list = true
o.listchars = { tab = "   ", trail = "·", nbsp = "␣" }
o.fillchars = {
	eob = " ", -- Remove tilde (~) from empty lines at end of buffer
}

-- Window Splitting Logic
o.splitbelow = true
o.splitright = true

-- File & Undo Persistence
o.undofile = true
o.swapfile = false
o.backup = false

-- Clipboard Integration (Async Wayland/X11 Support)
o.clipboard = "unnamedplus"

-- Miscellaneous
o.mouse = "a"
o.confirm = true
o.virtualedit = "block"
o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-blinkon500-blinkoff500,r-cr-o:hor20"
