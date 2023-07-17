vim.opt.background = 'dark'
vim.opt.showmode = false
require('noirbuddy').setup {
  preset = 'slate',
  colors = {
    background = '#151515',
    primary = '#e8e8d3',
    secondary = '#888888',

    diagnostic_error = '#cf6a4c',
    diagnostic_warning = '#fad07a',
    diagnostic_info = '#99ad6a',
    diagnostic_hint = '#668799',
    diff_add = '#99ad6a',
    diff_change = '#fad07a',
    diff_delete = '#cf6a4c',
  }
}
require('lualine').setup({
  options = {
    disabled_filetypes = { 'NvimTree', 'packer', 'Mundo', 'ctrlsf', 'toggleterm', 'dbout' },
    icons_enabled = false,
    theme = 'nord',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_c = { require('auto-session.lib').current_session_name }
  },
})
require('colorizer').setup()
