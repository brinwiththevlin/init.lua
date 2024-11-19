return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            -- Add this section to configure pickers
            pickers = {
                colorscheme = {
                    enable_preview = true,  -- Enable live preview for color schemes
                },
            },
        })

        local builtin = require('telescope.builtin')

        -- Keybindings
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "find files" })
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "git files" })
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "grep word" })
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "grep WORD" })
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "grep" })
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "help tags" })

        -- Custom keybinding to quickly access Neovim config files
        vim.keymap.set('n', '<leader>nc', function()
            builtin.find_files({
                prompt_title = "< neovim config > ",
                cwd = "~/.config/nvim/",
                hidden = true,
            })
        end, { desc = "neovim config" })

        -- Keybinding to open the colorscheme picker with live preview
        vim.keymap.set('n', '<leader>cs', builtin.colorscheme, { desc = "colorscheme picker" })
    end
}

