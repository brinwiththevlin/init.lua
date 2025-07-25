require("brinhasavlin.set")
require("brinhasavlin.remap")
require("brinhasavlin.lazy_init")

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local BrinhasavlinGroup = augroup('Brinhasavlin', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = BrinhasavlinGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = BrinhasavlinGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
            vim.tbl_extend("force", opts, { desc = "go to definition" }))
        vim.keymap.set("n", "K", require("pretty_hover").hover, vim.tbl_extend("force", opts, { desc = "show hover" }))
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
            vim.tbl_extend("force", opts, { desc = "search workspace symbols" }))
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
            vim.tbl_extend("force", opts, { desc = "open diagnostics" }))
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
            vim.tbl_extend("force", opts, { desc = "code action" }))
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
            vim.tbl_extend("force", opts, { desc = "references" }))
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end,
            vim.tbl_extend("force", opts, { desc = "rename" }))
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
            vim.tbl_extend("force", opts, { desc = "signature help" }))
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end,
            vim.tbl_extend("force", opts, { desc = "next diagnostic" }))
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
            vim.tbl_extend("force", opts, { desc = "previous diagnostic" }))
    end
})

-- Enable spell checking for LaTeX files
autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.opt_local.spell = true
    end,
})
--
-- Disable SQL ftplugin <C-c> mapping interference
autocmd("FileType", {
    pattern = "sql",
    callback = function()
        -- Remove default <C-c> insert mode mapping set by sql.vim
        pcall(vim.keymap.del, 'i', '<C-c>')
    end,
})

vim.api.nvim_create_user_command("NewPyProject", function(opts)
    local project_name = opts.args
    if project_name == "" then
        print("Usage: :NewPyProject <project_name>")
        return
    end

    local files = {
        ".gitignore",
        "README.md",
        "pyproject.toml",
        "requirements.txt",
        project_name .. "/__init__.py",
        "tests/test_example.py",
    }

    for _, file in ipairs(files) do
        local full_path = project_name .. "/" .. file
        local dir = vim.fn.fnamemodify(full_path, ":h")

        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end

        if vim.fn.filereadable(full_path) == 0 then
            vim.fn.writefile({}, full_path)
        end
    end

    print("Project '" .. project_name .. "' initialized.")
end, {
    nargs = 1,
})




vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.loaded_sql_completion = 1
