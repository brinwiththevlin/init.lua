vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "open vimrc" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move line up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "join line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "center after search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "center after search" })
-- vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- vim.keymap.set("n", "<leader>vwm", function()
--     require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--     require("vim-with-me").StopVimWithMe()
-- end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste over" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "copy to clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "delete without yanking" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "escape with control c" })

vim.keymap.set("n", "Q", "<nop>", { desc = "disable ex mode" })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "open tmux sessionizer" })
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
    vim.cmd("w")
    vim.cmd("e")
    vim.cmd("w")
end, { desc = "format buffer" })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "next quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "prev quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "next location" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "prev location" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "search and replace" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "make executable" })

vim.keymap.set("n", "<leader>dc", '<Cmd>lua require("dapui").close()<CR>',
    { noremap = true, silent = true, desc = "close dapui" })
-- vim.keymap.set(
--     "n",
--     "<leader>ee",
--     "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
-- )

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>",
    { desc = "packer config" });
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "make it rain" });
-- Map """ in insert mode to insert six double quotes and place the cursor in the middle
vim.api.nvim_set_keymap('n', '"""', 'O""""""<Esc>2hi',
    { noremap = true, silent = true, desc = "insert six double quotes" })


vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "source vimrc" })

vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>",
    { desc = "error handling" }
)

vim.keymap.set('n', '<leader>cf', ':!pg_format % -o %<CR>', { desc = 'Format SQL file (pg_format)' })
