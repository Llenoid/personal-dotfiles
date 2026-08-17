local M = {
	{
		"saghen/blink.compat",
		-- use v2.* for blink.cmp v1.*
		version = "2.*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		build = "cargo build --release",
		lazy = false,
		dependencies = {
			{ "folke/lazydev.nvim" },
			{ "nvim-mini/mini.icons" },
			{ "L3MON4D3/LuaSnip" },
			{ "kristijanhusak/vim-dadbod-completion" },
		},
		opts = {
			snippets = { preset = "luasnip" },
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
			sources = {
				default = { "lsp", "buffer", "snippets", "path", "lazydev" },
				per_filetype = {
					lua = { inherit_defaults = true, "lazydev" },
					sql = { "dadbod" },
				},
				providers = {
					lazydev = { name = "lazydev", module = "blink.compat.source" },
					dadbod = { module = "vim_dadbod_completion.blink" },
					lsp = {
						name = "lsp",
						module = "blink.cmp.sources.lsp",
						fallbacks = { "buffer" },
						transform_items = function(_, items)
							return vim.tbl_filter(function(item)
								return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
							end, items)
						end,
						opts = { tailwind_color_icon = "██" },
					},
					path = {
						name = "path",
						module = "blink.cmp.sources.path",
						score_offset = 3,
						opts = {
							trailing_slash = true,
							label_trailing_slash = true,
							get_cwd = function(context)
								return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
							end,
							show_hidden_files_by_default = true,
						},
					},
					buffer = {
						name = "buffer",
						module = "blink.cmp.sources.buffer",
						min_keyword_length = 3,
						opts = {
							get_bufnrs = function()
								return { vim.api.nvim_get_current_buf() }
							end,
						},
					},
					snippets = {
						module = "blink.cmp.sources.snippets",
						score_offset = 80, -- Give snippets higher priority so they appear at the top
						opts = {
							-- friendly_snippets = true,
							-- extended_filetypes = {
							--   markdown = { 'jekyll' },
							-- }
						},
					},
				},
			},
			signature = {
				enabled = true,
				trigger = {
					enabled = false,
					show_on_keyword = false,
					show_on_trigger_character = false,
					show_on_insert = false,
					show_on_insert_on_trigger_character = false,
					blocked_trigger_characters = {},
					blocked_retrigger_characters = {},
				},
				window = {
					min_width = 1,
					max_width = 100,
					max_height = 10,
					border = "rounded",
					winblend = 0,
					winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
					scrollbar = false,
					direction_priority = { "n", "s" },
					treesitter_highlighting = true,
					show_documentation = false,
				},
			},
			completion = {
				trigger = {
					show_on_insert_on_trigger_character = false,
				},
				ghost_text = {
					enabled = true,
					show_with_selection = true,
					show_without_selection = true,
					show_with_menu = true,
					show_without_menu = true,
				},
				documentation = {
					auto_show = false,
				},
				menu = {
					auto_show = false,
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							source_name = {
								text = function(ctx)
									return " [" .. ctx.source_name .. "] "
								end,
							},
						},
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
							{ "source_name" },
						},
					},
				},
			},
			cmdline = {
				enabled = true,
				keymap = { preset = "inherit" },
				completion = {
					list = { selection = { preselect = false } },
					menu = {
						auto_show = function(ctx)
							return vim.fn.getcmdtype() == ":"
						end,
					},
					ghost_text = { enabled = true },
				},
			},
			keymap = {
				preset = "none",
				["<C-n>"] = { "select_next", "fallback_to_mappings" },
				["<C-p>"] = { "select_prev", "fallback_to_mappings" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-d>"] = { "show_documentation", "hide_documentation" },
				["<C-M-l>"] = { "snippet_forward", "fallback" },
				["<C-M-h>"] = { "snippet_backward", "fallback" },

				["<C-y>"] = { "select_and_accept" },
				["<C-Space>"] = { "show", "hide" },
				["<C-e>"] = { "cancel" },
				["<C-k>"] = {
					"show_signature",
					"hide_signature",
				},
				-- ["<Tab>"] = { "select_next_or_fallback", },
				-- ["<S-Tab>"] = { "select_prev_or_fallback", },
				-- ["<C-d>"] = { "show_signature", "hide_signature", "fallback" },
			},
		},
	},
}

return M
