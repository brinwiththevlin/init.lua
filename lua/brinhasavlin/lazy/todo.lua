return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("todo-comments").setup {
            -- tell it to capture “(author)” after the keyword
            highlight = {
                -- KEYWORDS = TODO, FIXME, etc
                -- (\([^)]+\))? = optional “(anything but ))” after them
                -- :         = require the trailing colon
                pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
                comments_only = true,
                keyword = "wide", -- highlight the whole keyword+scope
            },
            -- optional: make the in-file search use the same pattern
            search = {
                pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
            }
        }

        -- your existing mappings
        vim.keymap.set("n", "]t", require("todo-comments").jump_next, { desc = "next todo" })
        vim.keymap.set("n", "[t", require("todo-comments").jump_prev, { desc = "prev todo" })
    end,
}
