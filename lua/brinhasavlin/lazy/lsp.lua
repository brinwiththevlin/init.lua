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
        -- CORRECTED: This is the recommended way to fix the position_encoding warnings.
        -- It sets a global standard for how Neovim handles diagnostics from all LSP servers.
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics,
            {
                position_encoding = "utf-16",
            }
        )

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")

        -- This more robustly merges capabilities from both the LSP
        -- protocol and nvim-cmp.
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        -- While the handler above is the main fix, setting it in capabilities
        -- is also good practice for clients that check for it directly.
        capabilities.general.positionEncodings = { "utf-16" }

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "basedpyright",
                "clangd", -- Added clangd for C++ support
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        handlers = {
                            ["textDocument/hover"] = function(_, result, ctx, config)
                                local util = vim.lsp.util
                                config = config or {}
                                config.border = "rounded"
                                config.focus_id = ctx.method

                                if not (result and result.contents) then
                                    return
                                end

                                local contents = util.convert_input_to_markdown_lines(result.contents)
                                contents = util.trim_empty_lines(contents)
                                if vim.tbl_isempty(contents) then
                                    return
                                end

                                return util.open_floating_preview(contents, "markdown", config)
                            end,

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

                basedpyright = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.basedpyright.setup({
                        capabilities = capabilities,
                        settings = {
                            basedpyright = {
                                analysis = {
                                    autoImportCompletion = true,
                                    autoSearchPaths = true,
                                    diagnosticMode = 'openFilesOnly',
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = 'recommended',
                                    exclude = { "**/.venv", "**/__pycache__", "**/**cache", "**/build", "**/dist", "**/.git", "**/basedpyright", "**/envs" },
                                    diagnosticSeverityOverrides = {
                                        reportUnusedVariable = "true", -- Should report unused variables
                                        reportUnusedFunction = "true", -- Should report unused functions
                                        reportExplicitAny = "none",
                                        reportAny = "none",
                                        reportGenrealTypeIssue = "true",
                                        reportMissingTypeStubs = "none", -- Suppress missing type stubs
                                        strictDictionaryInference = "none",
                                        strictListInference = "none",
                                        strictSetInference = "none",
                                    }
                                }
                            }
                        },

                    })
                end,

                ["sqls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.sqls.setup({
                        capabilities = capabilities,
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

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function()
                local util = vim.lsp.util
                local pretty_hover = require("pretty_hover")

                local html_entities = {
                    ["&nbsp;"] = " ",
                    ["&lt;"] = "<",
                    ["&gt;"] = ">",
                    ["&amp;"] = "&",
                }

                local function clean_entities(lines)
                    for i, line in ipairs(lines) do
                        for entity, replacement in pairs(html_entities) do
                            line = line:gsub(entity, replacement)
                        end
                        -- Also fix escaped underscores
                        line = line:gsub("\\_", "_")
                        lines[i] = line
                    end
                    return lines
                end

                require("pretty_hover").hover = function()
                    local util = vim.lsp.util
                    local params = util.make_position_params()
                    vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, ctx, _)
                        if not (result and result.contents) then
                            return
                        end

                        local contents = util.convert_input_to_markdown_lines(result.contents)
                        contents = util.trim_empty_lines(contents)
                        if vim.tbl_isempty(contents) then
                            return
                        end

                        contents = clean_entities(contents)

                        util.open_floating_preview(contents, "markdown", {
                            border = "rounded",
                            focus_id = ctx.method,
                        })
                    end)
                end
            end,
        })
    end
}
