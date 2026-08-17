-- lua/plugins/formatting.lua
return {
  {
    "stevearc/conform.nvim",

    event = { "BufWritePre" },

    cmd = { "ConformInfo" },

    keys = {
      {
        "<leader>mp",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end,
        mode = { "n", "v" },
        desc = "Format Buffer",
      },
    },

    opts = {
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },

      formatters_by_ft = {
        lua = { "stylua" },

        go = { "goimports", "gofumpt" },

        python = { "isort", "black" },

        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },

        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },

        rust = { "rustfmt" },

        c = { "clang-format" },
        cpp = { "clang-format" },
      },

      formatters = {
        clang_format = {
          prepend_args = { "-style=file" },
        },
      },
    },
  },
}
