-- Formatting configuration using conform.nvim (LazyVim's preferred way)
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Python
      python = { "black", "isort" },
      -- C/C++
      c = { "clang_format" },
      cpp = { "clang_format" },
      -- Go
      go = { "gofumpt", "goimports" },
    },
    formatters = {
      black = {
        prepend_args = { "--line-length", "120" },
      },
      isort = {
        prepend_args = { "--profile", "black" },
      },
      clang_format = {
        prepend_args = { "--style", "file" },
      },
    },
  },
}