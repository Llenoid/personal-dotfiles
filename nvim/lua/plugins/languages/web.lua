local tailwind_colorizer = {
	"roobert/tailwindcss-colorizer-cmp.nvim",
	event = "InsertEnter",
	ft = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	config = function()
		require("tailwindcss-colorizer-cmp").setup({
			color_square_width = 2,
		})
	end,
}

local ts_autotag = {
	"windwp/nvim-ts-autotag",
	opts = {
		enable_rename = true,
		enable_close = true,
		enable_close_on_slash = true,
	},
	ft = {
		"html",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"svelte",
		"vue",
		"tsx",
		"jsx",
		"rescript",
		"xml",
		"php",
		"markdown",
		"astro",
		"glimmer",
		"handlebars",
		"hbs",
	},
}

return { tailwind_colorizer, ts_autotag }
