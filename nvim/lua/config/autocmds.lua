-- ~/.config/nvim/lua/brandon/config/autocmds.lua

local function augroup(name)
	return vim.api.nvim_create_augroup("brandon_" .. name, { clear = true })
end

-------------------------------------------------------------------------------
-- FS HYGIENE: AUTO-CREATE DIRECTORIES ON SAVE
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if vim.bo[event.buf].filetype == "oil" or event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-------------------------------------------------------------------------------
-- DISABLE AUTO-INSERTING COMMENTS ON NEW LINES
-------------------------------------------------------------------------------
-- Strips 'c', 'r', and 'o' from formatoptions to stop automatic comment leader continuation
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("no_comment_newline"),
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-------------------------------------------------------------------------------
-- DISABLE COMMAND-LINE WINDOW TRAP
-------------------------------------------------------------------------------
-- Prevents accidental entry into the 'q:' command history window
vim.api.nvim_create_autocmd("CmdWinEnter", {
	group = augroup("no_cmd_window"),
	callback = function()
		vim.cmd("quit")
	end,
})

-------------------------------------------------------------------------------
-- CURSOR RESTORATION
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(args)
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if line_count <= 1 then
			return
		end

		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-------------------------------------------------------------------------------
-- YANK HIGHLIGHTING
-------------------------------------------------------------------------------

local yank_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })

-- Define custom yank highlight specs
local set_yank_hl = function()
	vim.api.nvim_set_hl(0, "CustomYank", { bg = "#ffc4a8", fg = "#1a1a1a", bold = true })
end

-- Initialize highlight group
set_yank_hl()

-- Re-apply highlight group when switching colorschemes (prevents theme resets from wiping CustomYank)
vim.api.nvim_create_autocmd("ColorScheme", {
	group = yank_group,
	callback = set_yank_hl,
})

-- Highlight on yank using version-agnostic API
vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	callback = function()
		local highlight_fn = vim.hl.hl_op or vim.hl.on_yank or vim.highlight.on_yank
		highlight_fn({
			higroup = "CustomYank",
			timeout = 150,
		})
	end,
})

-------------------------------------------------------------------------------
-- TERMINAL TITLE SYNC
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup("set_terminal_title"),
	pattern = "*",
	callback = function()
		local dirname = vim.fn.getcwd():match("([^/]+)$")
		vim.opt.titlestring = dirname
	end,
})

-------------------------------------------------------------------------------
-- EPHEMERAL BUFFER ERGONOMICS & QUICK-CLOSE
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"DressingSelect",
		"Jaq",
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"git",
		"gitsigns-blame",
		"help",
		"lir",
		"lspinfo",
		"man",
		"netrw",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		local opts = { buffer = event.buf, silent = true, nowait = true }
		vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
		vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", opts)
	end,
})

-------------------------------------------------------------------------------
-- QUICKFIX PREVIEW NAVIGATION
-------------------------------------------------------------------------------
-- Instantly jump and center preview file from QF list without losing window focus
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("quickfix_nav"),
	pattern = "qf",
	callback = function(event)
		local opts = { buffer = event.buf, silent = true, nowait = true }
		vim.keymap.set("n", "<C-j>", "j<CR>zz<C-w>p", opts)
		vim.keymap.set("n", "<C-k>", "k<CR>zz<C-w>p", opts)
		vim.keymap.set("n", "<C-n>", "j<CR>zz<C-w>p", opts)
		vim.keymap.set("n", "<C-p>", "k<CR>zz<C-w>p", opts)
	end,
})

-------------------------------------------------------------------------------
-- LUASNIP STATE CLEANUP ON IDLE
-------------------------------------------------------------------------------
-- Prevents active snippet jump traps when moving away from expansion points
vim.api.nvim_create_autocmd("CursorHold", {
	group = augroup("luasnip_unlink"),
	callback = function()
		local status, luasnip = pcall(require, "luasnip")
		if status and luasnip.expand_or_jumpable() then
			luasnip.unlink_current()
		end
	end,
})

-------------------------------------------------------------------------------
-- LAYOUT AUTO-BALANCE
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-------------------------------------------------------------------------------
-- PROSE / DOCUMENTATION OVERRIDES
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown", "text", "NeogitCommitMessage" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-------------------------------------------------------------------------------
-- QUIT SPECIFIED BUFFERS
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("quick_quit"),
	pattern = {
		"netrw",
		"Jaq",
		"qf",
		"git",
		"help",
		"man",
		"lspinfo",
		"oil",
		"spectre_panel",
		"lir",
		"DressingSelect",
		"tsplayground",
	},
	callback = function(event)
		local opts = { buffer = event.buf, silent = true, nowait = true }
		-- Map both Esc and q for instant exit
		vim.keymap.set("n", "<Esc>", function()
			pcall(vim.api.nvim_win_close, 0, true)
		end, opts)
		vim.keymap.set("n", "q", function()
			pcall(vim.api.nvim_win_close, 0, true)
		end, opts)
		vim.opt_local.buflisted = false
	end,
})

-- https://github.com/folke/lazy.nvim/issues/1951
local lazy_group = vim.api.nvim_create_augroup("LazyGroup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = lazy_group,
	pattern = "lazy_backdrop",
	callback = function(ctx)
		local win = vim.fn.win_findbuf(ctx.buf)[1]
		vim.api.nvim_win_set_config(win, { border = "none" })
	end,
})

local mason_group = vim.api.nvim_create_augroup("MasonGroup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = mason_group,
	pattern = "mason",
	callback = function()
		vim.wo.cursorline = false
	end,
})

vim.api.nvim_create_user_command("Notifications", function()
	local ok, Snacks = pcall(require, "snacks")
	if ok then
		Snacks.notifier.show_history()
	end
end, {
	desc = "Show notification history",
})
