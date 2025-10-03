-- Linting configuration using nvim-lint (LazyVim's preferred way)
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      -- Python
      python = { "mypy" },
      -- C/C++
      c = { "cppcheck" },
      cpp = { "cppcheck" },
      -- Go
      go = { "golangcilint" },
    },
    linters = {
      mypy = {
        args = {
          "--ignore-missing-imports",
          "--show-column-numbers",
          "--show-error-end",
          "--hide-error-codes",
          "--hide-error-context",
          "--no-color-output",
          "--no-error-summary",
          "--no-pretty",
        },
      },
      cppcheck = {
        args = {
          "--enable=all",
          "--inline-suppr",
          "--quiet",
          "--template=gcc",
        },
      },
    },
  },
}