local M = {
	"danymat/neogen",
	config = true,
	version = "*",
	dependencies = "nvim-mini/mini.snippets",
	version = false,
	cmd = "Neogen",
	keys = {
		{
			"<leader>cn",
			function()
				require("neogen").generate()
			end,
			desc = "Generate Annotations (Neogen)",
		},
	},
}

return M
