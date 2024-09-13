return {
    "jose-elias-alvarez/null-ls.nvim",
    setup = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- Python
                null_ls.builtins.formatting.black.with({
                    extra_args = { "--line-length", "120" },
                }),
                null_ls.builtins.formatting.isort.with({
                    extra_args = { "--profile", "black" },

                }).
                    null_ls.builtins.diagnostics.ruff.with({
                    extra_args = { "--ignore", "E501" },
                }),
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = { "--ignore-missing-imports" },
                }),
                null_ls.builtins.code_actions.ruff,

                -- C/C++
                null_ls.builtins.formatting.clang_format.with({
                    extra_args = { "--style", "file" }, -- Use .clang-format file if available
                }),
                null_ls.builtins.diagnostics.cpplint,
                null_ls.builtins.diagnostics.cppcheck.with({
                    extra_args = { "--enable=all" }, -- Enable all checks
                }),

                -- Go
                null_ls.builtins.formatting.gofmt,
                null_ls.builtins.formatting.goimports,
                null_ls.builtins.diagnostics.golangci_lint,
            },
        })
    end,
}
