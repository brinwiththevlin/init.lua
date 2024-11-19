return {
    'kkoomen/vim-doge',
    -- build = ':DogeInstall', -- Installs the Doge dependencies automatically
    config = function()
        -- Set the docstring standard for Python to Google style
        vim.g.doge_doc_standard_python = 'google'
    end,
}
