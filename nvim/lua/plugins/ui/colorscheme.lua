local P = {
	"ramojus/mellifluous.nvim",
	version = "v0.*", -- uncomment for stable config (some features might be missed if/when v1 comes out)
	config = function()
		require("mellifluous").setup({}) -- optional, see configuration section.
	end,
	init = function()
		vim.cmd.colorscheme("mellifluous")
	end,
}

local S = {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	init = function()
		vim.cmd.colorscheme("catppuccin-frappe")
	end,
}

local T = {
	"rmehri01/onenord.nvim",
	name = "onenord",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("onenord")
		local custom_colors = {
			fg = "#2e3440", -- Matches your dark OneNord background for max legibility
			bg = "#ffc4a8", -- Warm Nordic Orange (Bright but matte, no blinding neon)
			bold = true,
		}
		-- local targets = { "SubsPreview", "Substitute", "CurSearch", "Search" }
		local targets = { "Search" }

		for _, group in ipairs(targets) do
			vim.api.nvim_set_hl(0, group, custom_colors)
		end
	end,
}

return S
