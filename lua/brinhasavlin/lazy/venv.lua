return {
  "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
      "sharkdp/fd",
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
  lazy = false,
  branch = "regexp", -- This is the regexp branch, use this for the new version
  config = function()
      require("venv-selector").setup({
            changed_venv_hooks = {
                function(venv_path)
                    require("dap-python").setup(venv_path .. "/bin/python")
                end,
            }
        })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
    },
}
