local M = {
	"Bekaboo/dropbar.nvim",
	event = "BufEnter",
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	keys = {
		{
			"<Leader>;",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Pick symbols",
		},
		{
			"[;",
			function()
				require("dropbar.api").goto_context_start()
			end,
			desc = "Go to start of current context",
		},
		{
			"];",
			function()
				require("dropbar.api").select_next_context()
			end,
			desc = "Select next context",
		},
	},
	opts = {},
}

-- local N = {
--     "LunarVim/breadcrumbs.nvim",
--     dependencies = {
--         {"SmiteshP/nvim-navic"},
--     },
-- }
--
-- function N.config()
--     require("breadcrumbs").setup()
-- end

return M
