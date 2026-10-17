-- Enable byte-compilation cache for faster startup
if vim.loader then
	vim.loader.enable()
end

-- VSCode Neovim Optimization Block
if vim.g.vscode then
	-- Performance: Disable system clipboard sync in VSCode mode.
	-- The vscode-neovim extension natively syncs selections to system clipboard.
	-- Force-appending 'unnamedplus' causes high latency IPC calls over WSL on every y/d/c action.
	vim.opt.clipboard = ""

	-- Fast key responsiveness in VSCode
	vim.opt.timeoutlen = 300
	vim.opt.updatetime = 200

	-- Load lightweight config subset or keymaps only when inside VSCode
	-- (prevents loading heavy LSP, treesitter, or statusline plugins in VSCode)
	pcall(require, "config.keymaps")
else
	-- Native Neovim (WSL / Terminal)

	-- WSL2 Clipboard Optimization:
	-- Explicitly bind to win32yank to prevent slow powershell.exe/clip.exe fallback execution
	if vim.fn.has("wsl") == 1 then
		vim.g.clipboard = {
			name = "win32yank-wsl",
			copy = {
				["+"] = "win32yank.exe -i --crlf",
				["*"] = "win32yank.exe -i --crlf",
			},
			paste = {
				["+"] = "win32yank.exe -o --lf",
				["*"] = "win32yank.exe -o --lf",
			},
			cache_enabled = 1,
		}
	end

	vim.opt.clipboard:append("unnamedplus")

	-- Load full Neovim configuration (LSP, Lazy.nvim, Plugins, UI)
	require("config")
end
