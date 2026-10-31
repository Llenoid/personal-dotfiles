-- lua/pandas/init.lua (COMPREHENSIVE VERSION - CORE FOCUS)

local M = {}
local palette = require("pandas.palette").colors

M.options = {
	transparent_background = false, -- Keep your current test settings
	italic_comments = false,
	on_highlights_loaded = nil,
	-- Add more defaults here as needed
}

function M.load()
	-- Clear any old autocommands from previous loads, crucial for robustness
	-- This ensures highlight definitions aren't duplicated on `:colorscheme pandas` calls
	vim.api.nvim_create_augroup("MyColorschemeHighlights", { clear = true })

	vim.opt.termguicolors = true -- Always essential for true colors

	local transparent_bg = M.options.transparent_background
	local italic_comments = M.options.italic_comments

	-- ====================================================================
	-- 1. Base UI and Core Neovim Feature Highlights (Always applied)
	-- These are the fundamental colors of the editor
	-- ====================================================================
	vim.api.nvim_set_hl(0, "Normal", { fg = palette.fg, bg = transparent_bg and "NONE" or palette.bg })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = palette.line_highlight_bg })
	vim.api.nvim_set_hl(0, "CursorLineNr", { link = "CursorLine" }) -- Still explicitly link, as cursorlineopt "both" might not be universally preferred or cover all cases
	vim.api.nvim_set_hl(0, "Visual", { bg = palette.selection_bg })
	vim.api.nvim_set_hl(0, "LineNr", { fg = palette.comment })
	vim.api.nvim_set_hl(0, "SignColumn", { fg = palette.comment, bg = "NONE" })
	vim.api.nvim_set_hl(0, "FoldColumn", { fg = palette.comment, bg = palette.bg })
	vim.api.nvim_set_hl(0, "Folded", { fg = palette.comment, bg = palette.line_highlight_bg, italic = true })
	vim.api.nvim_set_hl(0, "VertSplit", { fg = palette.line_highlight_bg, bg = palette.line_highlight_bg })
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#3A3E45" })
	vim.api.nvim_set_hl(0, "Conceal", { fg = palette.comment })
	vim.api.nvim_set_hl(0, "Whitespace", { fg = palette.comment })
	vim.api.nvim_set_hl(0, "NonText", { fg = palette.comment }) -- '~' at end of buffer

	-- Command-line / Prompt / Popups
	vim.api.nvim_set_hl(0, "CmdLine", { fg = palette.fg, bg = palette.bg })
	vim.api.nvim_set_hl(0, "WildMenu", { fg = palette.bg, bg = palette.info_fg }) -- Autocomplete in cmdline
	vim.api.nvim_set_hl(0, "Pmenu", { fg = palette.fg, bg = palette.line_highlight_bg }) -- Popup menu (cmp, completion)
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = palette.bg, bg = palette.selection_bg }) -- Selected item in popup menu
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = palette.comment }) -- Scrollbar in popup menu
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = palette.info_fg }) -- Thumb in popup menu scrollbar
	vim.api.nvim_set_hl(0, "StatusLine", { fg = palette.fg, bg = palette.line_highlight_bg })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = palette.comment, bg = palette.bg })
	vim.api.nvim_set_hl(0, "MatchParen", { fg = palette.fg, bg = palette.selection_bg, bold = true }) -- Matching parentheses

	-- ====================================================================
	-- 2. Generic Syntax Highlight Groups (Traditional Vim, for fallbacks)
	-- These act as a base if Treesitter is not active for a language or feature.
	-- ====================================================================
	vim.api.nvim_set_hl(0, "Comment", { fg = palette.comment, italic = italic_comments and true or false })
	vim.api.nvim_set_hl(0, "Keyword", { fg = palette.keyword, bold = true })
	vim.api.nvim_set_hl(0, "Statement", { link = "Keyword" })
	vim.api.nvim_set_hl(0, "Operator", { fg = palette.operator })
	vim.api.nvim_set_hl(0, "Constant", { fg = palette.constant })
	vim.api.nvim_set_hl(0, "Number", { link = "Constant" })
	vim.api.nvim_set_hl(0, "Boolean", { link = "Constant" })
	vim.api.nvim_set_hl(0, "Function", { fg = palette.function_name })
	vim.api.nvim_set_hl(0, "Identifier", { fg = palette.variable })
	vim.api.nvim_set_hl(0, "Type", { fg = palette.type_name, italic = true })
	vim.api.nvim_set_hl(0, "String", { fg = palette.string_literal })
	vim.api.nvim_set_hl(0, "PreProc", { fg = palette.keyword })
	vim.api.nvim_set_hl(0, "Define", { link = "PreProc" })
	vim.api.nvim_set_hl(0, "Special", { link = "Function" })
	vim.api.nvim_set_hl(0, "ErrorMsg", { fg = palette.fg, bg = palette.error_fg, bold = true })
	vim.api.nvim_set_hl(0, "WarningMsg", { fg = palette.warning_fg, bold = true })
	vim.api.nvim_set_hl(0, "Info", { fg = palette.info_fg })
	vim.api.nvim_set_hl(0, "Underlined", { underline = true, sp = palette.string_literal })
	vim.api.nvim_set_hl(0, "Todo", { fg = palette.bg, bg = palette.warning_fg, bold = true }) -- For TODO comments

	-- ====================================================================
	-- 3. Treesitter Highlight Groups (Conditional)
	-- Only apply if nvim-treesitter is available and highlighting is enabled.
	-- These are the primary source of granular syntax highlighting.
	-- ====================================================================
	-- Use pcall to safely check if nvim-treesitter can be required
	local has_treesitter, treesitter = pcall(require, "nvim-treesitter")
	local has_treesitter_configs, treesitter_configs = pcall(require, "nvim-treesitter.configs")

	-- Check if nvim-treesitter is available AND its highlight module is enabled
	-- Line 81 (the corrected one):
	if has_treesitter and has_treesitter_configs and treesitter_configs.highlight then
		-- Generic Treesitter Captures (often link to traditional Vim groups or define base)
		vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })
		vim.api.nvim_set_hl(0, "@keyword", { link = "Keyword" })
		vim.api.nvim_set_hl(0, "@operator", { link = "Operator" })
		vim.api.nvim_set_hl(0, "@constant", { link = "Constant" })
		vim.api.nvim_set_hl(0, "@number", { link = "Number" })
		vim.api.nvim_set_hl(0, "@boolean", { link = "Boolean" })
		vim.api.nvim_set_hl(0, "@function", { link = "Function" })
		vim.api.nvim_set_hl(0, "@variable", { link = "Identifier" })
		vim.api.nvim_set_hl(0, "@type", { link = "Type" })
		vim.api.nvim_set_hl(0, "@string", { link = "String" })
		vim.api.nvim_set_hl(0, "@punctuation", { link = "Operator" }) -- General punctuation

		-- More Specific Treesitter Captures (often link to generic TS groups or define unique)
		vim.api.nvim_set_hl(0, "@keyword.function", { fg = palette.function_declaration or palette.keyword })
		vim.api.nvim_set_hl(0, "@keyword.return", { link = "@keyword" })
		vim.api.nvim_set_hl(0, "@keyword.control", { link = "@keyword" })
		vim.api.nvim_set_hl(0, "@keyword.declaration", { fg = palette.keyword })
		vim.api.nvim_set_hl(0, "@keyword.operator", { fg = palette.operator }) -- If distinct from @keyword

		vim.api.nvim_set_hl(0, "@function.call", { link = "@function" })
		vim.api.nvim_set_hl(0, "@function.builtin", { link = "@function" })
		vim.api.nvim_set_hl(0, "@function.macro", { link = "@function" })
		vim.api.nvim_set_hl(0, "@function.method", { link = "@function" })

		vim.api.nvim_set_hl(0, "@variable.builtin", { fg = palette.function_name, italic = true })
		vim.api.nvim_set_hl(0, "@parameter", { link = "@variable" })
		vim.api.nvim_set_hl(0, "@property", { fg = palette.variable })

		vim.api.nvim_set_hl(0, "@tag", { link = "@keyword" }) -- Link HTML/XML tags to keyword if not specifically colored
		vim.api.nvim_set_hl(0, "@tag.attribute", { fg = palette.function_declaration }) -- Use specific palette color or fallback
		vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = palette.function_declaration })

		vim.api.nvim_set_hl(0, "@type.builtin", { link = "@type" })
		vim.api.nvim_set_hl(0, "@constructor", { link = "@type" })

		vim.api.nvim_set_hl(0, "@string.escape", { fg = palette.keyword })
		vim.api.nvim_set_hl(0, "@string.regexp", { fg = palette.info_fg })
		vim.api.nvim_set_hl(0, "@character", { link = "@string" })

		vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = palette.function_declaration or palette.operator })
		vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "@operator" })
		vim.api.nvim_set_hl(0, "@punctuation.special", { fg = palette.keyword })

		-- Markdown / Documentation highlights
		vim.api.nvim_set_hl(0, "@markup.heading", { fg = palette.type_name, bold = true })
		vim.api.nvim_set_hl(0, "@markup.list", { link = "@keyword" })
		vim.api.nvim_set_hl(0, "@markup.bold", { fg = palette.constant, bold = true })
		vim.api.nvim_set_hl(0, "@markup.italic", { fg = palette.keyword, italic = true })
		vim.api.nvim_set_hl(0, "@markup.raw", { fg = palette.string_literal, italic = true })
		vim.api.nvim_set_hl(0, "@markup.link", { fg = palette.info_fg, underline = true })
		vim.api.nvim_set_hl(0, "@markup.quote", { fg = palette.comment, italic = true })

		-- Diff highlights (from Treesitter)
		vim.api.nvim_set_hl(0, "@diff.plus", { fg = palette.info_fg })
		vim.api.nvim_set_hl(0, "@diff.minus", { fg = palette.error_fg })
		vim.api.nvim_set_hl(0, "@diff.delta", { fg = palette.warning_fg })
	end

	-- ====================================================================
	-- 4. LSP Semantic Token Highlights (Conditional)
	-- Requires an active LSP client providing semantic tokens.
	-- ====================================================================
	-- Check if LSP is available and if there are clients attached to current buffer.
	-- `vim.lsp.buf_get_clients(0)` returns a list of clients for the current buffer.
	-- `next()` checks if that list is not empty.
	local lsp_active_clients_found = false
	if vim.lsp then
		for _, client in ipairs(vim.lsp.get_clients()) do
			-- A client is "active" if it's attached to the current buffer.
			-- Check client.attached property which indicates if it's attached to *any* buffer.
			-- More robust: check if client.attached_buffers[vim.api.nvim_get_current_buf()] is true
			-- For a quick check: if client.attached and client.supports_method("textDocument/semanticTokens/full") then
			-- This example prioritizes simply having *any* client for the buffer.
			-- For semantic tokens specifically, you might want to check if the client supports it.
			if client.attached_buffers[vim.api.nvim_get_current_buf()] then
				lsp_active_clients_found = true
				break -- Found at least one, so we can proceed
			end
		end
	end
	if lsp_active_clients_found then
		-- These are standard semantic token types. Language servers decide which to send.
		-- Often, these link to existing Treesitter groups or define subtle variations.
		vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = "@variable" })
		vim.api.nvim_set_hl(0, "@lsp.type.parameter", { link = "@parameter" })
		vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "@function" })
		vim.api.nvim_set_hl(0, "@lsp.type.method", { link = "@function.method" or "@function" })
		vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "@property" })
		vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "@type" })
		vim.api.nvim_set_hl(0, "@lsp.type.interface", { link = "@type" })
		vim.api.nvim_set_hl(0, "@lsp.type.enum", { link = "@type" })
		vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { link = "@constant" })
		vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "@type" })
		vim.api.nvim_set_hl(0, "@lsp.type.typeParameter", { link = "@type" })
		vim.api.nvim_set_hl(0, "@lsp.type.struct", { link = "@type" })

		-- Semantic token modifiers (e.g., readonly, deprecated, definition)
		vim.api.nvim_set_hl(0, "@lsp.mod.readonly", { underline = true }) -- Example: Underline readonly variables
		vim.api.nvim_set_hl(0, "@lsp.mod.deprecated", { strikethrough = true }) -- Example: Strikethrough deprecated items
		vim.api.nvim_set_hl(0, "@lsp.mod.definition", { bold = true }) -- Example: Bold definitions (for the definition of a function/variable)
	end

	-- ====================================================================
	-- 5. LSP Diagnostic Highlights (Always applied, but only visible if LSP active)
	-- These are standard Neovim groups for LSP messages (errors, warnings, etc.).
	-- ====================================================================
	vim.api.nvim_set_hl(0, "LspDiagnosticsError", { fg = palette.error_fg, underline = true, sp = palette.error_fg })
	vim.api.nvim_set_hl(
		0,
		"LspDiagnosticsWarning",
		{ fg = palette.warning_fg, underline = true, sp = palette.warning_fg }
	)
	vim.api.nvim_set_hl(
		0,
		"LspDiagnosticsInformation",
		{ fg = palette.info_fg, underline = true, sp = palette.info_fg }
	)
	vim.api.nvim_set_hl(0, "LspDiagnosticsHint", { fg = palette.comment, italic = true })
	-- These are the underlines for diagnostics, crucial for visual cues.
	vim.api.nvim_set_hl(0, "LspDiagnosticsUnderlineError", { underline = true, sp = palette.error_fg })
	vim.api.nvim_set_hl(0, "LspDiagnosticsUnderlineWarning", { underline = true, sp = palette.warning_fg })
	vim.api.nvim_set_hl(0, "LspDiagnosticsUnderlineInformation", { underline = true, sp = palette.info_fg })
	vim.api.nvim_set_hl(0, "LspDiagnosticsUnderlineHint", { underline = true, sp = palette.comment })

	-- ====================================================================
	-- Standard Neovim options (unchanged from previous)
	-- ====================================================================
	vim.opt.number = true
	vim.opt.cursorline = true
	vim.opt.cursorlineopt = "both" -- Highlights the entire line and its number
	vim.keymap.set("i", "jk", "<ESC>")

	print("pandas loaded with robustness checks!")
	if type(M.options.on_highlights_loaded) == "function" then
		-- Pass the `M` table (your colorscheme module) and the palette
		-- so the user has access to them in their callback.
		M.options.on_highlights_loaded(M, palette)
	end
end

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
	if type(M.options.on_highlights_loaded) ~= "function" then
		M.options.on_highlights_loaded = nil
	end
	M.load()
end

return M
