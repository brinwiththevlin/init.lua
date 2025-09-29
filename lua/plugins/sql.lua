return {
  -- Core database plugin
  {
    "tpope/vim-dadbod",
    lazy = true,
  },

  -- Database UI
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 30

      -- Configure your databases
      vim.g.dbs = {
        { name = "sudoku_dev", url = "sqlite:database.db" },
        -- Add more connections as needed
      }
    end,
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer in DBUI" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename DBUI buffer" },
      { "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
    },
  },

  -- SQL completion
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = "vim-dadbod",
    ft = { "sql", "mysql", "plsql" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          local cmp = require("cmp")
          cmp.setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
              { name = "luasnip" },
            },
          })
        end,
      })
    end,
  },
}
