-- Example from a LazyVim setup (e.g., in lua/plugins/lsp.lua)
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  opts = {
    -- This is the key part!
    -- Add the servers you want to use here
    servers = {
      pyright = {},
      ruff = {},
      tsserver = {},
      html = {},
      gopls = {},
      clangd = {},
      -- Add other language servers here
    },
  },
}
