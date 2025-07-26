-- File: lua/plugins/nvim-tree.lua
-- Plugin specification for nvim-tree (file explorer)
return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
        require("nvim-tree").setup({
            disable_netrw = true,
            hijack_netrw  = true,
            view          = {
                width = 30,
                side = "left",
            },
            filters       = {
                dotfiles = true,
                git_ignored = false,
                custom = { "^.git$" },
            },
            renderer      = {
                icons = {
                    show = {
                        git = true,
                        folder = true,
                        file = true,
                        folder_arrow = true,
                    },
                },
            },
        })
    end,
}
