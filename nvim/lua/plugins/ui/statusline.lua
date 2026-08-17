local function mark_m()
	local mark = vim.api.nvim_get_mark("M", {})
	local line = mark[1]
	local file = vim.fs.basename(mark[4])

	if file == "" then
		return ""
	end

	return " " .. file .. ":" .. line
end

local function mode_hl()
	local mode = vim.fn.mode()

	if mode:match("[vV]") or mode == "\22" then
		return "MiniStatuslineModeVisual"
	elseif mode == "i" then
		return "MiniStatuslineModeInsert"
	elseif mode == "R" then
		return "MiniStatuslineModeReplace"
	elseif mode == "c" then
		return "MiniStatuslineModeCommand"
	else
		return "MiniStatuslineModeNormal"
	end
end

local function recording()
	local reg = vim.fn.reg_recording()

	if reg == "" then
		return ""
	end

	return "REC @" .. reg
end

local M = {
	"nvim-mini/mini.statusline",
	version = "*",
	event = "VeryLazy",
	config = function()
		local statusline = require("mini.statusline")

		statusline.setup({
			use_icons = vim.g.have_nerd_font,

			content = {
				active = function()
					local MiniStatusline = require("mini.statusline")
					local mode = vim.fn.mode():sub(1, 1):upper()

					local rec = recording()
					if rec ~= "" then
						mode = mode .. " " .. rec
					end

					local git = MiniStatusline.section_git({ trunc_width = 40 })
					local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
					local filename = MiniStatusline.section_filename({ trunc_width = 140 })
					local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
					local location = MiniStatusline.section_location({ trunc_width = 75 })

					local mark = mark_m()

					return MiniStatusline.combine_groups({
						{ hl = mode_hl(), strings = { mode } },

						{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },

						"%<",

						{ hl = "MiniStatuslineFilename", strings = { filename } },

						mark ~= "" and { hl = "Comment", strings = { mark } } or "",

						"%=",

						{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
						{ hl = "MiniStatuslineModeNormal", strings = { location } },
					})
				end,
			},
		})

		statusline.section_fileinfo = function(args)
			local ft = vim.bo.filetype

			local upper = {
				json = true,
				jsonc = true,
				yaml = true,
				toml = true,
				html = true,
				css = true,
				scss = true,
			}

			if upper[ft] then
				ft = ft:upper()
			end

			return ft
		end
	end,
}

return M
