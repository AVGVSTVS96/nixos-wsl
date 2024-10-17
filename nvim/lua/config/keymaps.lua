-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- map Q to q so both quit regardless of casing
vim.cmd("command! Q q")

-- map page up and down keys to be same as ctrl-u and ctrl-d
vim.keymap.set("n", "<PageUp>", "<C-u>",   { noremap = true, silent = true })
vim.keymap.set("n", "<PageDown>", "<C-d>", { noremap = true, silent = true })
