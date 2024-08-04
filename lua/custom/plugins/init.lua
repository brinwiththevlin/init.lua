-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'lervag/vimtex',

  {
    'rebelot/kanagawa.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    name = 'kanagawa',
    opts = {
      transparent = true,
      styles = {
        sidbars = 'transparent',
        floats = 'transparent',
      },
      config = function()
        require('kanagawa').setup {
          transparent = true,
          theme = 'default',
        }
      end,
    },
  },

  {
    'theprimeagen/harpoon',
    config = function()
      local mark = require 'harpoon.mark'
      local ui = require 'harpoon.ui'

      vim.keymap.set('n', '<leader>a', mark.add_file)
      vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

      vim.keymap.set('n', '<C-h>', function()
        ui.nav_file(1)
      end)
      vim.keymap.set('n', '<C-j>', function()
        ui.nav_file(2)
      end)
      vim.keymap.set('n', '<C-k>', function()
        ui.nav_file(3)
      end)
      vim.keymap.set('n', '<C-l>', function()
        ui.nav_file(4)
      end)
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'j-hui/fidget.nvim',
    },

    config = function()
      local cmp = require 'cmp'
      local cmp_lsp = require 'cmp_nvim_lsp'
      local capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

      require('fidget').setup {}
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'lua_ls',
          'rust_analyzer',
          'gopls',
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require('lspconfig')[server_name].setup {
              capabilities = capabilities,
            }
          end,

          zls = function()
            local lspconfig = require 'lspconfig'
            lspconfig.zls.setup {
              root_dir = lspconfig.util.root_pattern('.git', 'build.zig', 'zls.json'),
              settings = {
                zls = {
                  enable_inlay_hints = true,
                  enable_snippets = true,
                  warn_style = true,
                },
              },
            }
            vim.g.zig_fmt_parse_errors = 0
            vim.g.zig_fmt_autosave = 0
          end,
          ['lua_ls'] = function()
            local lspconfig = require 'lspconfig'
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = 'Lua 5.1' },
                  diagnostics = {
                    globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
                  },
                },
              },
            }
          end,
        },
      }

      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete(),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        }, {
          { name = 'buffer' },
        }),
      }

      vim.diagnostic.config {
        -- update_in_insert = true,
        float = {
          focusable = false,
          style = 'minimal',
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      }
    end,
  },
  'theprimeagen/refactoring.nvim',

  'mbbill/undotree',

  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

      local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup('ThePrimeagen_Fugitive', {})

      local autocmd = vim.api.nvim_create_autocmd
      autocmd('BufWinEnter', {
        group = ThePrimeagen_Fugitive,
        pattern = '*',
        callback = function()
          if vim.bo.ft ~= 'fugitive' then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set('n', '<leader>p', function()
            vim.cmd.Git 'push'
          end, opts)

          -- rebase always
          vim.keymap.set('n', '<leader>P', function()
            vim.cmd.Git { 'pull', '--rebase' }
          end, opts)

          -- NOTE: It allows me to easily set the branch i am pushing and any tracking
          -- needed if i did not set the branch up correctly
          vim.keymap.set('n', '<leader>t', ':Git push -u origin ', opts)
        end,
      })

      vim.keymap.set('n', 'gu', '<cmd>diffget //2<CR>')
      vim.keymap.set('n', 'gh', '<cmd>diffget //3<CR>')
    end,
  },
}
