-- lua/my_colorscheme/palette.lua
-- This file holds all our raw hex color definitions.

local M = {} -- Our module table for the palette

M.colors = {
	-- Base UI colors (from VSCode 'colors' section or inferred)
	bg = "#292A2B",
	fg = "#E6E6E6",
	selection_bg = "#FFB86C", -- Editor.selectionBackground
	cursor_fg = "#FF4B82", -- editorCursor.foreground
	line_highlight_bg = "#31353a", -- editor.lineHighlightBackground

	-- Semantic/Syntax colors (from 'tokenColors' section)
	comment = "#676B79",
	keyword = "#FF75B5",
	operator = "#E6E6E6",
	import_variable = "#E6E6E6",
	constant = "#FFB86C",
	variable = "#E6E6E6",
	function_name = "#6FC1FF",
	function_declaration = "#FFB86C",
	type_name = "#19f9d8",
	string_literal = "#19f9d8", -- The second 'string' in your JSON

	-- Other useful colors from the 'colors' section
	error_fg = "#FF4B82", -- errorForeground, editorError.foreground
	warning_fg = "#FFCC95", -- editorWarning.foreground
	info_fg = "#6FC1FF", -- editorOverviewRuler.infoForeground
}

return M
