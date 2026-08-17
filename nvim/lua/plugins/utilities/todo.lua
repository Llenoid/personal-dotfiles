local M = {
	{
		"folke/todo-comments.nvim",
		-- event = "VeryLazy",
		cmd = { "TodoLocList", "TodoQuickFix", "TodoTelescope", "TodoSnacks" },
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			highlight = {
				before = "",
				keyword = "wide_bg",
				after = "fg",
			},
			colors = {
				error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
				warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
				info = { "DiagnosticInfo", "#2563EB" },
				hint = { "DiagnosticHint", "#10B981" },
				default = { "Identifier", "#7C3AED" },
				test = { "Identifier", "#FF00FF" },
			},
		},
		-- optional = true,
		keys = {
			{
				"<leader>ltd",
				function()
					Snacks.picker.todo_comments()
				end,
				desc = "Todo",
			},
			{
				"<leader>ltD",
				function()
					Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
				end,
				desc = "Todo/Fix/Fixme",
			},
		},
	},
}

return M
