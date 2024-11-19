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
    keys = {
        { '<F5>',      function() require('dap').continue() end,                                             desc = 'Debug: Start/Continue' },
        { '<F1>',      function() require('dap').step_into() end,                                            desc = 'Debug: Step Into' },
        { '<F2>',      function() require('dap').step_over() end,                                            desc = 'Debug: Step Over' },
        { '<F3>',      function() require('dap').step_out() end,                                             desc = 'Debug: Step Out' },
        { '<leader>b', function() require('dap').toggle_breakpoint() end,                                    desc = 'Debug: Toggle Breakpoint' },
        { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Debug: Set Breakpoint' },
        { '<F7>',      function() require('dapui').toggle() end,                                             desc = 'Debug: Toggle UI' },
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        -- Mason DAP setup
        require('mason-nvim-dap').setup {
            automatic_installation = true,
            ensure_installed = { 'delve', 'debugpy', 'cpptools' },
        }

        dapui.setup()

        -- Auto open/close DAP UI during debug sessions
        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Golang configuration with nvim-dap-go
        require('dap-go').setup {
            delve = {
                initialize_timeout_sec = 20,
                port = "${port}",
            },
        }

        dap.configurations.go = {
            {
                type = "delve",
                name = "Debug",
                request = "launch",
                program = "${file}",
                cwd = "${fileDirname}",
            },
            {
                type = "delve",
                name = "Debug test",
                request = "launch",
                mode = "test",
                program = "${file}",
            },
            {
                type = "delve",
                name = "Debug test (go.mod)",
                request = "launch",
                mode = "test",
                program = "./${relativeFileDirname}",
            }
        }

        require('dap-python').setup('/usr/bin/python3')

        -- C++ DAP setup
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
            options = { detached = false }
        }

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
                    { text = '-enable-pretty-printing',   description = 'Enable pretty printing',          ignoreFailures = false },
                    { text = 'skip -function std::*',     description = 'Skip functions in std namespace', ignoreFailures = false },
                    { text = 'skip -file /usr/include/*', description = 'Skip system include files',       ignoreFailures = false },
                },
            },
        }
    end,
}
