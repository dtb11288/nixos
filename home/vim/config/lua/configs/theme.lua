vim.opt.background = 'dark'
vim.opt.showmode = false
require('noirbuddy').setup {
  colors = {
    background = BACKGROUND,
    primary = FOREGROUND,
    secondary = COLOR15,

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

    diagnostic_error = COLOR1,
    diagnostic_warning = COLOR3,
    diagnostic_info = COLOR2,
    diagnostic_hint = COLOR6,
    diff_add = COLOR2,
    diff_change = COLOR3,
    diff_delete = COLOR1,
  }
}
local noirbuddy_lualine = require('noirbuddy.plugins.lualine')
require('lualine').setup({
  options = {
    disabled_filetypes = { 'NvimTree', 'packer', 'Mundo', 'ctrlsf', 'toggleterm', 'dbout' },
    icons_enabled = false,
    theme = noirbuddy_lualine.theme,
    component_separators = '|',
    section_separators = '',
  },
  sections = noirbuddy_lualine.sections,
  inactive_sections = noirbuddy_lualine.inactive_sections,
})
require('colorizer').setup()
