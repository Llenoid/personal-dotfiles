local M = {
		"stevearc/oil.nvim",
		lazy = false,
    event = function(self, event)
      if vim.fn.isdirectory(vim.fn.expand("%:p")) == 1 then
        return "VimEnter"
      end
    end,
    cmd = "Oil",
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    keys = {
      {
        '-',
        "<cmd>lua require('oil').open_float(nil)<CR>",
        desc = 'Open Oil nvim in float',
      },
    },
		opts = {
      use_default_keymaps = false,
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['L'] = 'actions.select',
        ['<C-\\>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-->'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['E'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['H'] = { 'actions.parent', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
			},
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			prompt_save_on_select_new_entry = true,
			view_options = {
				show_hidden = true,
				is_hidden_file = function(name, _)
					return vim.startswith(name, ".") and name ~= ".."
				end,
				is_always_hidden = function(name, _)
					return name == ".git"
				end,
			},
      float = {
        -- Padding around the floating window
        padding = 2,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.9,
        max_height = 0.9,
        -- border = 'rounded',
        border = 'single',
        win_options = {
          winblend = 0,
        },
        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
        get_win_title = nil,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = 'auto',
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
		},
	}

return M
