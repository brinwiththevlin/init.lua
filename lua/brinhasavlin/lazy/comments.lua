-- File: lua/plugins/comment.lua
-- Plugin specification for Comment.nvim (comment toggling)
return {
  "numToStr/Comment.nvim",
  event = "BufReadPre", -- lazy load on buffer read
  keys = {
    { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
    { "gcc", mode = "n", desc = "Toggle line comment" },
    { "gbc", mode = "n", desc = "Toggle block comment" },
  },
  opts = {
    -- Add operator-pending mappings and extra options here
    padding = true,
    sticky = true,
    ignore = nil,
  },
  config = function(_, opts)
    require("Comment").setup(opts)
  end,
}

