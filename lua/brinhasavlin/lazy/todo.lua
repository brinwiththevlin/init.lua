return {
    "folke/todo-comments.nvim",
    depencencies = { " nvim-lua/plenary.nvim" },
    config = function()
        local todo = require("todo-comments")
        todo.setup {}

        vim.keymap.set("n", "]t", todo.jump_next, { desc = "next todo"})
        vim.keymap.set("n", "[t", todo.jump_prev, { desc = "prev todo"})
    end
}
