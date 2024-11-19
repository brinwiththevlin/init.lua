return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup()
        vim.keymap.set("x", "<leader>re", ":Refactor extract ", {desc = "extract"})
        vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", {desc = "extract to file"})

        vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", {desc = "extract var"})

        vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", {desc = "inline var"})

        vim.keymap.set("n", "<leader>rI", ":Refactor inline_func", {desc = "inline func"})

        vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", {desc = "extract block"})
        vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file", {desc = "extract block to file"})
    end,
}
