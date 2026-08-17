local M = {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	event = "InsertEnter",
	dependencies = { { "rafamadriz/friendly-snippets", lazy = true } },
	config = function(_, opts)
		local ls = require("luasnip")
		ls.setup(opts)
		ls.filetype_extend("javascript", { "javascriptreact", "html", "jsdoc" })
		ls.filetype_extend("javascriptreact", { "html" })
		ls.filetype_extend("typescript", { "tsdoc" })
		vim.schedule(function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
		end)
	end,
	opts = {
		history = true,
		delete_check_events = "TextChanged",
		enable_autosnippets = true,
		region_check_events = "InsertEnter",
	},
}

return M
