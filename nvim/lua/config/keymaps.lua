-- ~/.config/nvim/lua/brandon/config/keymaps.lua
local keymap = vim.keymap.set

-- Clear search highlight on ESC
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Better Movement on Wrapped Lines (Preserves jump count for 10j/10k)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Window Navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

-- Window Splitting & Management
keymap("n", "<leader>w", "<C-w>", { desc = "Window prefix", remap = true })
keymap("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
keymap("n", "<leader>_", "<cmd>split<CR>", { desc = "Split window horizontally" })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })

-- Window Resizing (Ctrl + Arrow Keys)
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Scrolling & Viewport Positioning
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center viewport" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center viewport" })
keymap("n", "J", "mzJ`z", { desc = "Join lines while keeping cursor position" })

-- Search Mechanics (Vim-Galore Direction Lock + Centering)
-- 'n' ALWAYS moves down file, 'N' ALWAYS moves up file, regardless of / or ?
keymap("n", "n", "'Nn'[v:searchforward] . 'zzzv'", { expr = true, desc = "Next search result (centered)" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward] . 'zzzv'", { expr = true, desc = "Prev search result (centered)" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Visual Mode Line Shifting
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual block down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual block up" })

-- Registers & System Clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
keymap("x", "<leader>p", [["_dP]], { desc = "Paste over selection without clobbering register" })
keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole register" })

-- Undo Breakpoints in Insert Mode
keymap("i", ",", ",<c-g>u", { desc = "Undo breakpoint on comma" })
keymap("i", ".", ".<c-g>u", { desc = "Undo breakpoint on period" })
keymap("i", ";", ";<c-g>u", { desc = "Undo breakpoint on semicolon" })

-- Buffer & Quickfix Navigation
keymap("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })
keymap("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous quickfix item" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
keymap("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix window" })
keymap("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix window" })

-- Terminal Mode Escape
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
