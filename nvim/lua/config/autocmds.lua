-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--   pattern = { "*" },
--   command = "silent! wall",
--   nested = true,
-- })

-- Set window separator highlight for all cases
vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
  callback = function()
    vim.cmd([[highlight WinSeparator guifg=#3C3F47]])
  end,
})

-- Disable autoformatting for nix files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "nix" },
  callback = function()
    vim.b.autoformat = false
  end,
})
