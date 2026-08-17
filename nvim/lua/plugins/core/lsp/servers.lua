local servers = {
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },

        diagnostics = {
          globals = { "vim" },
        },

        workspace = {
          checkThirdParty = false,
        },

        telemetry = {
          enable = false,
        },
      },
    },
  },
  dartls = {
    cmd = { "dart", "language-server", "--protocol=lsp"},
    filetypes = { "dart" },
    init_options = {
      closingLabels = true,
      flutterOutline = true,
      onlyAnalyzeProjectsWithOpenFiles = true,
      outline = true,
      suggestFromUnimportedLibraries = true,
    },
    settings = {
      dart = {
        completeFunctionCalls = true,
        showTodos = true,
      }
    }
  },
}

return servers
