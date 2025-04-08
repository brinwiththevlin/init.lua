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
        dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
        dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
        dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

        dap.set_log_level("TRACE")

        -- Golang configuration with nvim-dap-go (no extra setup arguments needed)
        require('dap-go').setup()

        -- Python DAP setup
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

        -- Add event listeners to apply Delve configurations if needed
        -- dap.listeners.after.event_initialized['dap_default'] = function()
        --     -- Set Delve to skip certain paths by default to prevent stepping into Go's standard library or module cache
        --     dap.repl.run_command('config substitute-path /usr/local/go/src /non-existent-path')
        --     dap.repl.run_command('config skipFiles /usr/local/go/src/*')
        --     dap.repl.run_command('config skipFiles /go/pkg/mod/*')
        -- end
    end,
}
