require("brinhasavlin.set")
require("brinhasavlin.remap")
require("brinhasavlin.shell")

local augroup = vim.api.nvim_create_augroup
local BrinhasavlinGroup = augroup("Brinhasavlin", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.cmd([[
  autocmd FileType python command! Lint :silent! call LintPython()
]])

function LintPython()
    -- Execute your linting command here
    -- For example, using PyLint:
    vim.cmd([[silent! ! pylint --disable=E501 %]])
end

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = BrinhasavlinGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

require("toggleterm").setup({
    size = 10,           -- Set the size of the toggleterm window to 10 lines
    open_mapping = "<c-s>", -- Set the key mapping to open the toggleterm window
})
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.opt.textwidth = 120
vim.g.black_linelength = 120
