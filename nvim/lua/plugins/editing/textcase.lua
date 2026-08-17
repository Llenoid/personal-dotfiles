local M = {
	"johmsalas/text-case.nvim",
	keys = {
		"gtc", -- Default invocation prefix
		{ "gtc.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
	},
	cmd = {
		-- NOTE: The Subs command name can be customized via the option "substitude_command_name"
		"Subs",
		"TextCaseOpenTelescope",
		"TextCaseOpenTelescopeQuickChange",
		"TextCaseOpenTelescopeLSPChange",
		"TextCaseStartReplacingCommand",
	},
	dependencies = { "nvim-telescope/telescope.nvim", cmd = "Telescope" },
	config = function()
		require("textcase").setup({
			default_keymappings_enabled = true,
			substitute_command_name = "S",
			prefix = "gtc",
		})
		require("telescope").load_extension("textcase")
	end,
}

return M
