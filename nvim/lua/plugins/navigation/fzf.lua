local M = {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-mini/mini.icons" },
  cmd = "FzfLua",
  keys = {
    { "<leader>,", function() require('fzf-lua').buffers() end, desc = "Buffers", },
    { "<leader>/", function() require('fzf-lua').live_grep() end, desc = "Grep", },
    { "<leader>:", function() require('fzf-lua').command_history() end, desc = "Command History", },
    { "<leader><space>", function() require('fzf-lua').files() end, desc = "Find Files", },
    { "<leader>bb", function() require('fzf-lua').buffers() end, desc = "Buffers", },
    { "<leader>fc", function() require('fzf-lua').files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File", },
    { "<leader>sf", function() require('fzf-lua').files() end, desc = "Find Files", },
    { "<leader>fg", function() require('fzf-lua').git_files() end, desc = "Find Git Files", },
    { "<leader>fr", function() require('fzf-lua').oldfiles() end, desc = "Recent", },
    { "<leader>gc", function() require('fzf-lua').git_commits() end, desc = "Git Log", },
    { "<leader>gs", function() require('fzf-lua').git_status() end, desc = "Git Status", },
    { "<leader>sb", function() require('fzf-lua').lines() end, desc = "Buffer Lines", },
    { "<leader>sB", function() require('fzf-lua').grep_buffers() end, desc = "Grep Open Buffers", },
    { "<leader>sg", function() require('fzf-lua').live_grep() end, desc = "Grep", },
    { "<leader>sw", function() require('fzf-lua').grep_cword() end, desc = "Visual selection or word", mode = { "n", "x" }, },
    { "<leader>sW", function() require('fzf-lua').grep_cWORD() end, desc = "Visual selection or word", mode = { "n", "x" }, },
    { '<leader>s"', function() require('fzf-lua').registers() end, desc = "Registers", },
    { "<leader>sa", function() require('fzf-lua').autocmds() end, desc = "Autocmds", },
    { "<leader>sc", function() require('fzf-lua').command_history() end, desc = "Command History", },
    { "<leader>sC", function() require('fzf-lua').commands() end, desc = "Commands", },
    { "<leader>sh", function() require('fzf-lua').help_tags() end, desc = "Help Pages", },
    { "<leader>sH", function() require('fzf-lua').highlights() end, desc = "Highlights", },
    { "<leader>sj", function() require('fzf-lua').jumps() end, desc = "Jumps", },
    { "<leader>sk", function() require('fzf-lua').keymaps() end, desc = "Keymaps", },
    { "<leader>sl", function() require('fzf-lua').loclist() end, desc = "Location List", },
    { "<leader>sM", function() require('fzf-lua').man_pages() end, desc = "Man Pages", },
    { "<leader>sm", function() require('fzf-lua').marks() end, desc = "Marks", },
    { "<leader>sR", function() require('fzf-lua').resume() end, desc = "Resume", },
    { "<leader>sq", function() require('fzf-lua').quickfix() end, desc = "Quickfix List", },
    { "<leader>uC", function() require('fzf-lua').colorschemes() end, desc = "Colorschemes", },
    { "<leader>qp", function() require('fzf-lua').projects() end, desc = "Projects", },
    -- Definitions
    { "gd", function() require("fzf-lua").lsp_definitions() end, desc = "Goto Definition", },
    -- Declaration
    { "gD", function() vim.lsp.buf.declaration() end, desc = "Goto Declaration", },
    -- References
    { "gr", function() require("fzf-lua").lsp_references() end, desc = "Goto References", },
    -- Implementations
    { "gi", function() require("fzf-lua").lsp_implementations() end, desc = "Goto Implementation", },
    -- Type Definitions
    { "gy", function() require("fzf-lua").lsp_typedefs() end, desc = "Goto Type Definition", },
    -- Document Symbols
    { "gO", function() require("fzf-lua").lsp_document_symbols() end, desc = "Document Symbols", },
    -- Workspace Symbols
    { "gW", function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Workspace Symbols", },
    -- Incoming Calls
    { "<leader>ci", function() require("fzf-lua").lsp_incoming_calls() end, desc = "Incoming Calls", },
    -- Outgoing Calls
    { "<leader>co", function() require("fzf-lua").lsp_outgoing_calls() end, desc = "Outgoing Calls", },
    -- Code Actions
    { "<leader>ca", function() require("fzf-lua").lsp_code_actions() end, mode = { "n", "x" }, desc = "Code Actions", },
    -- Diagnostics (workspace)
    { "<leader>sd", function() require("fzf-lua").diagnostics() end, desc = "Diagnostics", },
    -- Diagnostics (current buffer)
    { "<leader>sD", function() require("fzf-lua").diagnostics_document() end, desc = "Buffer Diagnostics", },
    { "<leader>ss", function() require("fzf-lua").lsp_document_symbols() end, desc = "Document Symbols", }
  },
  config = function()
    local fzf = require("fzf-lua")
    local path = require("fzf-lua.path")

    fzf.setup({
      fzf_bin = "sk",
      file_icon_padding = " ",

      winopts = {
        fullscreen = true,
        border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
        preview = {
          layout = "horizontal",
          horizontal = "right:60%",
          border = { "─", "─", "┐", "│", "┘", "─", "─", "│" },
        },
      },

      fzf_opts = {
        ["--info"] = "inline",
      },

      files = {
        prompt = "Files❯ ",
        multiprocess = true,
        git_icons = false,
        file_icons = true,
        color_icons = true,
        path_shorten = 6,
        find_opts = [[-type f -not -path '*/.git/*']],
        rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --glob "!.git/*"]],
        fd_opts = [[--color=never --hidden --type f --type l --exclude .git]],
        cwd_prompt = true,
        cwd_prompt_shorten_len = 30,
        toggle_ignore_flag = "--no-ignore",
        toggle_hidden_flag = "--hidden",
        toggle_follow_flag = "-L",
        hidden = true,
        follow = false,
        no_ignore = false,
        absolute_path = false,
      },

      git = {
        files = {
          prompt = "GitFiles❯ ",
          cmd = "git ls-files --exclude-standard",
          multiprocess = true,
          git_icons = true,
          file_icons = true,
          color_icons = true,
        },
        status = {
          prompt = "GitStatus❯ ",
          cmd = "git -c color.status=false --no-optional-locks status --porcelain=v1 -u",
          multiprocess = true,
          file_icons = true,
          color_icons = true,
          previewer = "git_diff",
          actions = {
            ["default"] = {
              fn = function(selected, opts)
                local entry = path.entry_to_file(selected[1], opts)
                if entry and entry.path then
                  vim.cmd.DiffviewOpen({ args = { entry.path } })
                end
              end,
              desc = "diffview-git-file",
            },
          },
        },
        diff = {
          cmd = "git --no-pager diff --name-only {ref}",
          ref = "HEAD",
          preview = "git diff {ref} {file}",
          file_icons = true,
          color_icons = true,
          fzf_opts = { ["--multi"] = true },
        },
        hunks = {
          cmd = "git --no-pager diff --color=always {ref}",
          ref = "HEAD",
          file_icons = true,
          color_icons = true,
          fzf_opts = {
            ["--multi"] = true,
            ["--delimiter"] = ":",
            ["--nth"] = "3..",
          },
        },
        commits = {
          prompt = "Commits❯ ",
          cmd = [[git log --color --pretty=format:"%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset"]],
          preview = "git show --color {1}",
        },
        bcommits = {
          prompt = "BCommits❯ ",
          cmd = [[git log --color --pretty=format:"%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {file}]],
          preview = "git show --color {1} -- {file}",
        },
        blame = {
          prompt = "Blame> ",
          cmd = [[git blame --color-lines {file}]],
          preview = "git show --color {1} -- {file}",
        },
        branches = {
          prompt = "Branches❯ ",
          cmd = "git branch --all --color",
          preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
          remotes = "local",
          cmd_add = { "git", "branch" },
          cmd_del = { "git", "branch", "--delete" },
        },
        tags = {
          prompt = "Tags> ",
          cmd = [[git for-each-ref --color --sort="-taggerdate" --format "%(color:yellow)%(refname:short)%(color:reset) %(color:green)(%(taggerdate:relative))%(color:reset) %(subject) %(color:blue)%(taggername)%(color:reset)" refs/tags]],
          preview = [[git log --graph --color --pretty=format:"%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {1}]],
        },
        stash = {
          prompt = "Stash> ",
          cmd = "git --no-pager stash list",
          preview = "git --no-pager stash show --patch --color {1}",
        },
        icons = {
          ["M"] = { icon = "M", color = "yellow" },
          ["D"] = { icon = "D", color = "red" },
          ["A"] = { icon = "A", color = "green" },
          ["R"] = { icon = "R", color = "yellow" },
          ["C"] = { icon = "C", color = "yellow" },
          ["T"] = { icon = "T", color = "magenta" },
          ["?"] = { icon = "?", color = "magenta" },
        },
      },

      grep = {
        prompt = "Grep❯ ",
        input_prompt = "Grep For❯ ",
        multiprocess = true,
        git_icons = false,
        file_icons = true,
        color_icons = true,
        grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        hidden = false,
        follow = false,
        no_ignore = false,
        rg_glob = true,
        glob_flag = "--iglob",
        glob_separator = "%s%-%-",
        no_header = false,
        no_header_i = false,
      },

      args = {
        prompt = "Args❯ ",
        files_only = true,
      },

      oldfiles = {
        prompt = "History❯ ",
        cwd_only = false,
        stat_file = true,
        include_current_session = false,
        ignore_current_buffer = true,
      },

      buffers = {
        prompt = "Buffers❯ ",
        file_icons = true,
        color_icons = true,
        sort_lastused = true,
        show_unloaded = true,
        cwd_only = false,
        cwd = nil,
      },

      tabs = {
        prompt = "Tabs❯ ",
        tab_title = "Tab",
        tab_marker = "<<",
        locate = true,
        file_icons = true,
        color_icons = true,
        fzf_opts = {
          ["--delimiter"] = "[\\):]",
          ["--with-nth"] = "2..",
        },
      },

      lines = {
        prompt = "Lines❯ ",
        file_icons = true,
        show_bufname = true,
        show_unloaded = true,
        show_unlisted = false,
        no_term_buffers = true,
        sort_lastused = true,
        winopts = { treesitter = true },
        fzf_opts = {
          ["--multi"] = true,
          ["--delimiter"] = "[\t]",
          ["--tabstop"] = "1",
          ["--tiebreak"] = "index",
          ["--with-nth"] = "2..",
          ["--nth"] = "4..",
        },
      },

      tags = {
        prompt = "Tags❯ ",
        ctags_file = nil,
        multiprocess = true,
        file_icons = true,
        color_icons = true,
        rg_opts = "--no-heading --color=always --smart-case",
        grep_opts = "--color=auto --perl-regexp",
        fzf_opts = { ["--tiebreak"] = "begin" },
        no_header = false,
        no_header_i = false,
      },

      btags = {
        prompt = "BTags❯ ",
        ctags_file = nil,
        ctags_autogen = true,
        multiprocess = true,
        file_icons = false,
        rg_opts = "--color=never --no-heading",
        grep_opts = "--color=never --perl-regexp",
        fzf_opts = { ["--tiebreak"] = "begin" },
      },

      colorschemes = {
        prompt = "Colorschemes❯ ",
        live_preview = true,
        winopts = { height = 0.55, width = 0.30 },
      },

      awesome_colorschemes = {
        prompt = "Colorschemes❯ ",
        live_preview = true,
        max_threads = 5,
        winopts = { row = 0, col = 0.99, width = 0.50 },
        fzf_opts = {
          ["--multi"] = true,
          ["--delimiter"] = "[:]",
          ["--with-nth"] = "3..",
          ["--tiebreak"] = "index",
        },
      },

      keymaps = {
        prompt = "Keymaps> ",
        winopts = { preview = { layout = "vertical" } },
        fzf_opts = { ["--tiebreak"] = "index" },
        ignore_patterns = { "^<SNR>", "^<Plug>" },
        show_desc = true,
        show_details = true,
      },

      nvim_options = {
        prompt = "Nvim Options> ",
        separator = "│",
        color_values = true,
      },

      quickfix = {
        file_icons = true,
        valid_only = false,
      },

      quickfix_stack = {
        prompt = "Quickfix Stack> ",
        marker = ">",
      },

      lsp = {
        prompt_postfix = "❯ ",
        cwd_only = false,
        async_or_timeout = 5000,
        file_icons = true,
        git_icons = false,
        jump1 = true,
        includeDeclaration = true,
        symbols = {
          locate = false,
          async_or_timeout = true,
          symbol_style = 1,
          symbol_icons = {
            File = "󰈙",
            Module = "",
            Namespace = "󰦮",
            Package = "",
            Class = "󰆧",
            Method = "󰊕",
            Property = "",
            Field = "",
            Constructor = "",
            Enum = "",
            Interface = "",
            Function = "󰊕",
            Variable = "󰀫",
            Constant = "󰏿",
            String = "",
            Number = "󰎠",
            Boolean = "󰨙",
            Array = "󱡠",
            Object = "",
            Key = "󰌋",
            Null = "󰟢",
            EnumMember = "",
            Struct = "󰆼",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰗴",
          },
          symbol_hl = function(s)
            return "@" .. s:lower()
          end,
          symbol_fmt = function(s, _)
            return "[" .. s .. "]"
          end,
          child_prefix = true,
          fzf_opts = { ["--tiebreak"] = "begin" },
        },
        code_actions = {
          prompt = "Code Actions> ",
          async_or_timeout = 5000,
          previewer = "codeaction",
        },
        finder = {
          prompt = "LSP Finder> ",
          file_icons = true,
          color_icons = true,
          async = true,
          silent = true,
          separator = "| ",
          includeDeclaration = true,
          providers = {},
        },
      },

      diagnostics = {
        prompt = "Diagnostics❯ ",
        cwd_only = false,
        file_icons = false,
        git_icons = false,
        color_headings = true,
        diag_icons = true,
        diag_source = true,
        diag_code = true,
        icon_padding = "",
        multiline = 2,
      },

      marks = {
        marks = "",
      },

      complete_path = {
        cmd = nil,
        word_pattern = nil,
      },

      complete_file = {
        cmd = nil,
        file_icons = true,
        color_icons = true,
        word_pattern = nil,
        winopts = { preview = { hidden = true } },
      },

      zoxide = {
        cmd = "zoxide query --list --score",
        scope = "global",
        git_root = false,
        formatter = "path.dirname_first",
        fzf_opts = {
          ["--no-multi"] = true,
          ["--delimiter"] = "[\t]",
          ["--tabstop"] = "4",
          ["--tiebreak"] = "end,index",
          ["--nth"] = "2..",
        },
      },

      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100,
        },
      },

      hls = {
        normal = "Normal",
        preview_normal = "Normal",
        border = "Function",
        preview_border = "Function",
      },

      helptags = {
        prompt = ":",
        winopts = {
          title = " help 💡 ",
          title_pos = "center",
          width = 0.8,
          height = 0.6,
          preview = {
            hidden = "nohidden",
            layout = "horizontal",
            horizontal = "down:40%",
          },
        },
      },

      keymap = {
        builtin = {
          ["<Esc>"] = "hide",
          ["<F1>"] = "toggle-help",
          ["<F2>"] = "toggle-fullscreen",
          ["<F3>"] = "toggle-preview-wrap",
          ["<F4>"] = "toggle-preview",
          ["<F5>"] = "toggle-preview-cw",
          ["<F6>"] = "toggle-preview-behavior",
          ["<F7>"] = "toggle-preview-ts-ctx",
          ["<F8>"] = "preview-ts-ctx-dec",
          ["<F9>"] = "preview-ts-ctx-inc",
          ["<S-Left>"] = "preview-reset",
          ["<S-down>"] = "preview-page-down",
          ["<S-up>"] = "preview-page-up",
          ["<C-b>"] = "preview-down",
          ["<C-f>"] = "preview-up",
        },
        fzf = {
          ["ctrl-z"] = "abort",
          ["ctrl-d"] = "half-page-down",
          ["ctrl-u"] = "half-page-up",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
          ["alt-a"] = "toggle-all",
          ["alt-g"] = "first",
          ["alt-G"] = "last",
          ["f3"] = "toggle-preview-wrap",
          ["f4"] = "toggle-preview",
          ["shift-down"] = "preview-page-down",
          ["shift-up"] = "preview-page-up",
        },
      },

      highlights = {
        prompt = "highlights: ",
        winopts = {
          title = " highlights 🎨 ",
          title_pos = "center",
          width = 0.8,
          height = 0.6,
          preview = {
            hidden = "nohidden",
            layout = "horizontal",
            horizontal = "down:40%",
            wrap = "wrap",
          },
        },
      },

      registers = {
        prompt = "registers: ",
        filter = "%a",
        winopts = {
          title = " registers 🏷️ ",
          title_pos = "center",
          width = 0.8,
        },
      },

      actions = {
        ["default"] = fzf.actions.file_edit_or_qf,
        files = {
          ["default"] = fzf.actions.file_edit_or_qf,
          ["ctrl-q"] = fzf.actions.file_sel_to_qf,
        },
        grep = {
          ["default"] = fzf.actions.file_edit_or_qf,
          ["ctrl-q"] = fzf.actions.file_all_to_qf,
        },
      },
    })
  end,
}

return M
