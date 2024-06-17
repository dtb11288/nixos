local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', '<leader>me', require('rust-expand-macro').expand_macro, { noremap = true, silent = true, buffer = bufnr, desc = 'Expand macro' })
