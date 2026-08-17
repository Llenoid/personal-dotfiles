local M = {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },

    config = function()
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      ----------------------------------------------------------------
      -- MOVE
      ----------------------------------------------------------------

      local function next_start(lhs, query)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move.goto_next_start(query, "textobjects")
        end, { desc = "Next " .. query })
      end

      local function next_end(lhs, query)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move.goto_next_end(query, "textobjects")
        end, { desc = "Next end " .. query })
      end

      local function prev_start(lhs, query)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move.goto_previous_start(query, "textobjects")
        end, { desc = "Previous " .. query })
      end

      local function prev_end(lhs, query)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move.goto_previous_end(query, "textobjects")
        end, { desc = "Previous end " .. query })
      end

      next_start("]m", "@function.outer")
      next_end("]M", "@function.outer")

      prev_start("[m", "@function.outer")
      prev_end("[M", "@function.outer")

      next_start("]]", "@class.outer")
      next_end("][", "@class.outer")

      prev_start("[[", "@class.outer")
      prev_end("[]", "@class.outer")

      next_start("gna", "@parameter.outer")
      next_start("gni", "@parameter.inner")

      prev_start("gpa", "@parameter.outer")
      prev_start("gpi", "@parameter.inner")

      ----------------------------------------------------------------
      -- SWAP
      ----------------------------------------------------------------

      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap parameter next" })

      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap parameter previous" })
    end,
  },
}

return M
