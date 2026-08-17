return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	keys = {
		{
			"<CR>",
			function()
				require("kulala").run()
			end,
			desc = "Run HTTP Request",
			ft = "http",
		},
		{
			"<leader>i",
			function()
				require("kulala").toggle()
			end,
			desc = "Toggle HTTP Response Window",
			ft = "http",
		},
	},
	config = function()
		require("kulala").setup({
			-- Forces Kulala to render into a standard split buffer panel rather than a float [1]
			default_view = "body",

			-- Set this to true if you want your cursor to stay in your .http file after running
			-- Set to false if you want your cursor to immediately focus the split output
			split_open_each_execution = false,
		})

		-- Keep window navigation working inside the split panel
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "kulala_ui",
			callback = function()
				vim.keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>", { buffer = true, silent = true })
				vim.keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>", { buffer = true, silent = true })
				vim.keymap.set("n", "q", "<Cmd>bdelete<CR>", { buffer = true, silent = true })
			end,
		})
	end,
}
