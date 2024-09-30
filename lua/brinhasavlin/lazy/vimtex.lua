return {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
        vim.g.vimtex_view_general_viewer = "/mnt/c/Program Files/Okular/okular.exe"
        vim.g.vimtex_view_method = 'general'
        vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
    end

}
