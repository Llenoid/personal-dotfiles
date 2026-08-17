if vim.loader then
	vim.loader.enable()
end

require("config")

if vim.g.vscode then
	vim.opt.clipboard:append("unnamedplus")
end
