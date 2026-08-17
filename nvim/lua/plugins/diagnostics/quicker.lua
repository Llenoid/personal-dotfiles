local M = {
	"stevearc/quicker.nvim",
	keys = {
		{
			"<leader>q",
			function()
				require("quicker").toggle()
			end,
			desc = "Toggle Quickfix",
		},
	},
	opts = {},
}
return M
