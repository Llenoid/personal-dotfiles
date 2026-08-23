return {
	"folke/snacks.nvim",
	priority = 1000,
	event = "VeryLazy",
	keys = {
		-- Notification History & Management
		{
			"<leader>nh",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>nd",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},

		-- Transient Scratch Buffers
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
	},
	---@type snacks.Config
	opts = {
		bigfile = {
			enabled = true,
			size = 1.5 * 1024 * 1024,
		},

		dashboard = { enabled = false },
		explorer = { enabled = false },

		indent = {
			enabled = true,
			priority = 1, -- Keep it low so text renders first
			char = "│",
			only_scope = true, -- ONLY calculate the current scope (massive speed boost)
			only_current = true,
		},
		input = { enabled = false },
		image = { enabled = true },
		notifier = { enabled = true, timeout = 3000 },
		scratch = { enabled = true },
		terminal = { enabled = false },
		quickfile = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		picker = {
			enabled = true,
			ui_select = true, -- Automatically intercepts Mason list into a centered floating UI
		},
	},
}
