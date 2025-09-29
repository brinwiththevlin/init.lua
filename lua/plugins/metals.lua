return {
  -- Metals LSP (Scala Language Server)
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap", -- For debugging
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
        },
      }
      metals_config.init_options.statusBarProvider = "on"
      -- LSP keybindings
      metals_config.on_attach = function(_, bufnr)
        require("metals").setup_dap()
        local opts = { buffer = bufnr, noremap = true, silent = true }
        -- Navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        -- Actions
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
        -- Diagnostics
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        -- Metals specific
        vim.keymap.set("n", "<leader>mc", function()
          require("metals").compile_cascade()
        end, opts)
        vim.keymap.set("n", "<leader>mh", function()
          require("metals").hover_worksheet()
        end, opts)
      end
      return metals_config
    end,
  },
}
