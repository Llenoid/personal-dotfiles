-- lua/plugins/linting.lua
return {
  {
    "mfussenegger/nvim-lint",

    event = {
      "BufReadPre",
      "BufNewFile",
    },

    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        markdown = { "markdownlint" },
      }

      local group =
        vim.api.nvim_create_augroup(
          "nvim-lint",
          { clear = true }
        )

      vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufWritePost",
        "InsertLeave",
      }, {
        group = group,
        callback = function()
          if not vim.bo.modifiable then
            return
          end

          lint.try_lint()
        end,
      })
    end,
  },
}
