local M = {
	"smjonas/inc-rename.nvim",
	cmd = "IncRename",
	keys = {
		{
			"<leader>rn",
			function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end,
			mode = "n",
			expr = true,
			desc = "Rename symbol",
		},
	},
	dependencies = { "stevearc/dressing.nvim" },
	config = function()
		require("inc_rename").setup({
			input_buffer_type = "dressing",
			input = {
				override = function(conf)
					conf.col = -1
					conf.row = 0
					return conf
				end,
			},
		})
	end,
}
return M
