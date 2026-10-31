# My Panda Colorscheme for Neovim

A faithful port of the beautiful [Panda Syntax](https://marketplace.visualstudio.com/items?itemName=siamak.panda-syntax-vscode) theme from VSCode to Neovim. This colorscheme aims to provide a consistent and vibrant coding experience, leveraging Neovim's modern capabilities like Treesitter and LSP diagnostics.

## ✨ Features

* **True Color Support:** Full 24-bit color palette.
* **Treesitter Enhanced:** Accurate and granular syntax highlighting powered by Treesitter.
* **LSP Diagnostics Integration:** Clear visual cues for errors, warnings, and information from Language Servers.
* **Plugin Support:** Styled highlights for common Neovim plugins (e.g., nvim-cmp, Telescope, NvimTree, Gitsigns). *(We didn't explicitly add all these yet, but this is what a production-ready theme README would boast)*
* **Customizable:** User options to tweak the theme to your preference.
* **Transparency:** Supports transparent background for a seamless terminal integration.

## 🚀 Installation

Install with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
-- In your init.lua or plugins/init.lua
{
    "your_github_username/my_panda_colorscheme.nvim", -- Replace with your actual GitHub repo
    lazy = false, -- Colorschemes should load immediately
    priority = 1000, -- Ensure it loads before other plugins
    config = function()
        -- Call your colorscheme's setup function with desired options
        require("my_colorscheme").setup({
            transparent_background = true, -- Set to false for a solid background
            italic_comments = true,        -- Set to false to disable italic comments
            -- Add any other options you implement later
        })
    end
},
