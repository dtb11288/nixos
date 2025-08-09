local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', '<leader>me', require("ferris.methods.expand_macro"),
  { noremap = true, silent = true, buffer = bufnr, desc = 'Expand macro' })
vim.keymap.set('n', '<leader>ml', require("ferris.methods.view_memory_layout"),
  { noremap = true, silent = true, buffer = bufnr, desc = 'View memory layout' })
