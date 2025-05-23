local local_plugins = {
    {
        'ThePrimeagen/harpoon',
        branch = "harpoon2",
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "add to harpoon" })
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                { desc = "toggle harpoon" })

            vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "select harpoon 1" })
            vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = "select harpoon 2" })
            vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = "select harpoon 3" })
            vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = "select harpoon 4" })
            vim.keymap.set("n", "<leader><C-h>", function() harpoon:list():replace_at(1) end,
                { desc = "replace harpoon 1" })
            vim.keymap.set("n", "<leader><C-j>", function() harpoon:list():replace_at(2) end,
                { desc = "replace harpoon 2" })
            vim.keymap.set("n", "<leader><C-k>", function() harpoon:list():replace_at(3) end,
                { desc = "replace harpoon 3" })
            vim.keymap.set("n", "<leader><C-l>", function() harpoon:list():replace_at(4) end,
                { desc = "replace harpoon 4" })
        end
    },
}

return local_plugins
