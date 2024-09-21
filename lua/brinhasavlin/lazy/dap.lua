return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
        'leoluz/nvim-dap-go',
        'mfussenegger/nvim-dap-python',
    },
    keys = function(_, keys)
        local dap = require 'dap'
        local dapui = require 'dapui'
        return {
            -- Basic debugging keymaps, feel free to change to your liking!
            { '<F5>',      dap.continue,          desc = 'Debug: Start/Continue' },
            { '<F1>',      dap.step_into,         desc = 'Debug: Step Into' },
            { '<F2>',      dap.step_over,         desc = 'Debug: Step Over' },
            { '<F3>',      dap.step_out,          desc = 'Debug: Step Out' },
            { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
            {
                '<leader>B',
                function()
                    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
                end,
                desc = 'Debug: Set Breakpoint',
            },
            { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
            unpack(keys),
        }
    end,
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'
        require('mason-nvim-dap').setup {
            automatic_installation = true,
            handlers = {},
            ensure_installed = {
                'delve',
                'debugpy',
                'cpptools',
            },
        }

        dapui.setup {}

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Golang specific config
        require('dap-go').setup {
            delve = {
                detached = vim.fn.has 'win32' == 0,
            },
        }

        -- Python specific config
        require('dap-python').setup('/usr/bin/python3')

        -- C++ specific config
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
            options = {
                detached = false,
            }
        }

        -- C++ debug configuration
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                setupCommands = {
                    {
                        text = '-enable-pretty-printing',
                        description = 'Enable pretty printing',
                        ignoreFailures = false
                    },
                    -- Skip standard library functions
                    {
                        text = 'skip -function std::*',
                        description = 'Skip functions in std namespace',
                        ignoreFailures = false
                    },
                    -- Skip system includes (e.g., C++ standard library headers)
                    {
                        text = 'skip -file /usr/include/*',
                        description = 'Skip system include files',
                        ignoreFailures = false
                    },
                    -- You can add more skips here if necessary
                },
            },
        }
    end,
}
