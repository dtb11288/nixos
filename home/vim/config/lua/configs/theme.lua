vim.opt.background = 'dark'
vim.opt.showmode = false
require('noirbuddy').setup {
  colors = {
    background = '#151515',
    primary = '#888888',
    secondary = '#e8e8d3',

    noir_0 = '#ffffff',
    noir_1 = '#f5f5f5',
    noir_2 = '#d5d5d5',
    noir_3 = '#b4b4b4',
    noir_4 = '#a7a7a7',
    noir_5 = '#949494',
    noir_6 = '#737373',
    noir_7 = '#535353',
    noir_8 = '#323232',
    noir_9 = '#212121',

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
