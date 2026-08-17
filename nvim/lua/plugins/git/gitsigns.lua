local M = {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		numhl = true,
		sign_priority = 15,
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged_enable = true,
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			follow_files = true,
		},
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 500,
			ignore_whitespace = false,
			virt_text_priority = 100,
			use_focus = true,
		},
		preview_config = {
			border = "single",
			style = "minimal",
			-- Position relative to the cursor, editor, win
			relative = "cursor",
			row = 1,
			col = 0,
			-- Size constraints
			width = 80,
			height = 10,
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, desc)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, desc)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git [c]hange" })

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git [c]hange" })

			-- Actions
			map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
			map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })

			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "stage git hunk" })

			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "reset git hunk" })

			map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
			map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [u]ndo stage hunk" })
			map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
			map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview [H]unk [I]nline" })

			map("n", "<leader>tb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "git [b]lame line" })

			map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })

			map("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, { desc = "git [D]iff against last commit" })

			map("n", "<leader>hQ", function()
				gitsigns.setqflist("all")
			end, { desc = "Set Quickfix list All" })
			map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set Quickfix list" })

			-- Toggles
			map("n", "<leader>hb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
			map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
			map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "[T]oggle [W]ord diff" })

			-- Text object
			map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select [H]unk" })
		end,
	},
}

return M
