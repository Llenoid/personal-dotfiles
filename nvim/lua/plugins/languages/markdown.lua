local M = {
	"MeanderingProgrammer/render-markdown.nvim",
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
	ft = { "markdown", "codecompanion" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	opts = function(_, opts)
		table.insert(opts, {
			enabled = true,
		})

		vim.api.nvim_create_user_command("MarkdownDisable", function(args)
			vim.cmd("lua require('render-markdown').disable()")
		end, {
			desc = "Disable markdown rendering",
			bang = true,
		})

		vim.api.nvim_create_user_command("MarkdownEnable", function()
			vim.cmd("lua require('render-markdown').enable()")
		end, {
			desc = "Re-enable markdown rendering",
		})
	end,
	opts = {
		enabled = false,
	},
}

local N = {
	"SCJangra/table-nvim",
	ft = "markdown",
	opts = {
		padd_column_separators = true, -- Insert a space around column separators.
		mappings = { -- next and prev work in Normal and Insert mode. All other mappings work in Normal mode.
			next = "<TAB>", -- Go to next cell.
			prev = "<S-TAB>", -- Go to previous cell.
			insert_row_up = "<A-k>", -- Insert a row above the current row.
			insert_row_down = "<A-j>", -- Insert a row below the current row.
			move_row_up = "<A-S-k>", -- Move the current row up.
			move_row_down = "<A-S-j>", -- Move the current row down.
			insert_column_left = "<A-h>", -- Insert a column to the left of current column.
			insert_column_right = "<A-l>", -- Insert a column to the right of current column.
			move_column_left = "<A-S-h>", -- Move the current column to the left.
			move_column_right = "<A-S-l>", -- Move the current column to the right.
			insert_table = "<A-t>", -- Insert a new table.
			insert_table_alt = "<A-S-t>", -- Insert a new table that is not surrounded by pipes.
			delete_column = "<A-d>", -- Delete the column under cursor.
		},
	},
}

local O = {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		-- add options here
		-- or leave it empty to use the default settings
	},
	keys = {
		-- suggested keymap
		{ "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
}

return { M, N, O }
