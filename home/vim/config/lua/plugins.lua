local lazypath = VIM_HOME .. "/plugins/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  root = VIM_HOME .. "/plugins",
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  spec = {
    -- File explorer
    'nvim-tree/nvim-tree.lua',

    -- Terminal
    'akinsho/toggleterm.nvim',

    -- Perfomance
    'lewis6991/impatient.nvim',

    -- Git support
    'nvim-lua/plenary.nvim',
    'lewis6991/gitsigns.nvim',
    'sindrets/diffview.nvim',

    -- Autocomplete
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'saadparwaiz1/cmp_luasnip',
    'j-hui/fidget.nvim',

    -- AI
    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'zbirenbaum/copilot.lua',
      },
    },

    -- Rust
    'vxpm/ferris.nvim',

    -- Haskell
    'MrcJkb/haskell-tools.nvim',

    -- Javascript
    'nvimtools/none-ls.nvim',
    'MunifTanjim/eslint.nvim',

    -- KDL
    'imsnif/kdl.vim',

    -- Liquid template
    'tpope/vim-liquid',

    -- Ron
    'ron-rs/ron.vim',

    -- Control
    'ibhagwan/fzf-lua',
    'dyng/ctrlsf.vim',
    'windwp/nvim-spectre',

    -- Editor
    'numToStr/Comment.nvim',
    'mg979/vim-visual-multi',
    'kylechui/nvim-surround',
    'junegunn/vim-easy-align',
    'cappyzawa/trim.nvim',
    'moll/vim-bbye',
    'jiangmiao/auto-pairs',
    'L3MON4D3/LuaSnip',
    'folke/which-key.nvim',
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      event = { "BufReadPre", "BufNewFile" },
    },
    'djoshea/vim-autoread',
    {
      'rachartier/tiny-inline-diagnostic.nvim',
      event = 'VeryLazy',
      priority = 1000,
    },
    -- History & Session
    { 'rmagatti/auto-session', dependencies = 'nvim-telescope/telescope.nvim' },
    'simnalamburt/vim-mundo',

    -- Theme
    { 'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },
    {
      "jesseleite/nvim-noirbuddy",
      dependencies = { "tjdevries/colorbuddy.nvim", branch = "dev" }
    },
    'aditya-azad/candle-grey',
    'shaunsingh/nord.nvim',
    'norcalli/nvim-colorizer.lua'
  },
})
