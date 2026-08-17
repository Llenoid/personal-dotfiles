local icons_opts = {
	file = {
		[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
		["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
	},
	filetype = {
		dotenv = { glyph = "", hl = "MiniIconsYellow" },
	},
}

local split_join_opts = {
	mappings = {
		toggle = "<space>tsj",
		split = "",
		join = "",
	},
}

local surround_opts = {
	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsc", -- Replace surrounding
		update_n_lines = "gsn", -- Update `n_lines`

		suffix_last = "l", -- Suffix to search with "prev" method
		suffix_next = "n", -- Suffix to search with "next" method
	},
}

local align_opts = {
	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		start = "ga",
		start_with_preview = "gA",
	},
}

local M = {
	"nvim-mini/mini.nvim",
	version = "*",
	event = "VeryLazy",
	config = function()
		local ai = require("mini.ai")
		local ai_opts = {
			n_lines = 50,
			custom_textobjects = {
				f = ai.gen_spec.treesitter({
					a = "@function.outer",
					i = "@function.inner",
				}),

				c = ai.gen_spec.treesitter({
					a = "@class.outer",
					i = "@class.inner",
				}),

				a = ai.gen_spec.treesitter({
					a = "@parameter.outer",
					i = "@parameter.inner",
				}),

				o = ai.gen_spec.treesitter({
					a = { "@conditional.outer", "@loop.outer" },
					i = { "@conditional.inner", "@loop.inner" },
				}),
			},
		}

		require("mini.icons").setup(icons_opts)

		vim.schedule(function()
			require("mini.ai").setup(ai_opts)
			require("mini.align").setup(align_opts)
			require("mini.surround").setup(surround_opts)
			require("mini.splitjoin").setup(split_join_opts)
			require("mini.extra").setup({})
			require("mini.comment").setup({})
		end)
	end,
}
return M
