return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "ruff",
                "gopls",
                "basedpyright",
                "clangd" -- Added clangd for C++ support
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        handlers = {
                            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                                border = "rounded",
                                focusable = true,
                                style = "minimal",
                                source = "always",
                                header = "",
                                prefix = "",
                            }),
                            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                                border = "rounded"
                            }),
                        }
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,

                ruff_lsp = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ruff_lsp.setup({
                        capabilities = capabilities,
                        init_options = {
                            settings = {
                                args = {}, -- Any specific arguments to Ruff
                            },
                        },
                        settings = {
                            ruff = {
                                -- Enable workspace mode
                                diagnosticMode = "workspace",
                                args = {
                                    "--select", "RET"
                                }
                                -- Optionally add more specific settings here
                            },
                        },
                        root_dir = lspconfig.util.root_pattern(".git"), -- Set root directory for the workspace
                    })
                end,

                basedpyright = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.basedpyright.setup({
                        capabilities = capabilities,
                        settings = {
                            basedpyright = {
                                analysis = {
                                    autoImportCompletion = true,
                                    autoSearchPaths = true,
                                    diagnosticMode = 'workspace',
                                    -- useLibraryCodeForTypes = true,
                                    typeCheckingMode = 'strict',
                                    ignore = { "~/.local/share/nvim/mason/packages/basedpyright/", "anaconda3/envs/research/lib/python3.12/site-packages/" },
                                    exclude = { "~/.local/share/nvim/mason/packages/basedpyright/", "anaconda3/envs/research/lib/python3.12/site-packages/" },
                                    diagnosticSeverityOverrides = {
                                        reportUnusedVariable = true, -- Should report unused variables
                                        reportUnusedFunction = true, -- Should report unused functions
                                        reportUntypedFunctionDecorator = false,
                                        reportUntyedClassDecorator = false,
                                        reportImplicitOverride = false,
                                        reportMissingTypeStubs = false, -- Suppress missing type stubs
                                        reportMissingTypeArgument = false,
                                        reportUnknownMemberType = false,
                                        reportUnknownVariableType = false,
                                        reportUnknownParameterType = false,
                                        reportUnknownArgumentType = false,
                                        strictDictionaryInference = false,
                                        strictListInference = false,
                                        strictSetInference = false,
                                    }
                                }
                            }
                        },

                    })
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ["clangd"] = function() -- Added clangd-specific setup for C++ support
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup({
                        capabilities = capabilities,
                        cmd = { "clangd", "--background-index", "--clang-tidy", "--suggest-missing-includes" },
                        root_dir = lspconfig.util.root_pattern(".git", "compile_commands.json", "Makefile"),
                        filetypes = { "c", "cpp", "objc", "objcpp" },
                        settings = {
                            clangd = {
                                completion = {
                                    detailedLabel = true
                                },
                                diagnostics = {
                                    severity = {
                                        unused_variable = "warning",
                                    },
                                },
                            },
                        },
                    })
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
