local M = {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },

        dependencies = {
            "OXY2DEV/markview.nvim",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },

        opts = {},

        config = function(_, opts)
            local ts = require("nvim-treesitter")

            ts.setup(opts)

            ts.install({
                "bash",
                "c",
                "cpp",
                "diff",
                "elixir",
                "go",
                "heex",
                "html",
                "javascript",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "rust",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local buf = args.buf
                    local filetype = args.match

                    local lang = vim.treesitter.language.get_lang(filetype)
                    if not lang then
                        return
                    end

                    if not vim.treesitter.language.add(lang) then
                        return
                    end

                    vim.treesitter.start(buf, lang)
                end,
            })
        end,
    },
}

return M
