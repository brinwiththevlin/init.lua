-- File: lua/plugins/noice.lua
-- Plugin specification for noice.nvim (enhanced UI for messages, cmdline, and popup menus)
return {
  "folke/noice.nvim",
  event = "VimEnter",  -- load on startup
  dependencies = {
    "MunifTanjim/nui.nvim",        -- UI component library
    "rcarriga/nvim-notify",       -- optional notification backend
  },
  opts = {
    -- Override the default lsp markdown renderer
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      hover = { enabled = true },      -- enable hover docs
      signature = { enabled = false }, -- disable signature help
    },
    -- Use native notification window
    notify = { enabled = true, view = "notify" },
    -- Configure the command-line UI
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      format = {
        cmdline = { pattern = "^:", icon = ":", lang = "vim" },
      },
    },
    -- Enable the popup menu, e.g., for completion
    popupmenu = { enabled = true, backend = "nui" },
    -- Route messages through the noice UI
    messages = {
      enabled = true,
      view = "mini",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    -- optional: route vim.notify to noice
    vim.notify = require("noice").api.notify
  end,
}

