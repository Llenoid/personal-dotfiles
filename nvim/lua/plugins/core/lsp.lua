local highlight_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

local M = {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{ "mason-org/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUpdate" }, opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = highlight_group,
			callback = require("plugins.core.lsp.keymaps").on_attach,
		})

		local diagnostics = require("plugins.core.lsp.diagnostics")
		vim.diagnostic.config(diagnostics)

		local servers = require("plugins.core.lsp.servers")

		local ensure_installed = {
			-- LSPs
			"lua-language-server",
			"gopls",
			"pyright",
			"rust-analyzer",
			"tsc",

			-- Formatters
			"stylua",
			"goimports",
			"gofumpt",
			"black",
			"isort",
			"prettierd",
			"eslint_d",
			"clang-format",

			-- Linters
			"markdownlint",
		}

		require("mason").setup()
		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
		})
		require("mason-lspconfig").setup({
			automatic_installation = true,
		})
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		for name, config in pairs(servers) do
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
			vim.lsp.config(name, config)
			vim.lsp.enable(name)
		end
	end,
}

return M
