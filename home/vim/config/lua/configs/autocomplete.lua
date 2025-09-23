-- Load snippets
require('luasnip.loaders.from_snipmate').lazy_load()

-- Diagnostic
vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = BORDER,
  }
})

require('tiny-inline-diagnostic').setup({
  preset = 'minimal',
})

-- Cmp config
local cmp = require('cmp')
local select_opts = { behavior = cmp.SelectBehavior.Insert }
local luasnip = require('luasnip')
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = {
      border = BORDER,
      winhighlight = "Normal:CmpNormal",
    },
    documentation = {
      border = BORDER,
      winhighlight = "Normal:CmpDocNormal",
    },
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = '[L]',
        luasnip = '[S]',
        buffer = '[B]',
        path = '[P]',
        cmdline = '[C]',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-f>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'codecompanion' },
    { name = 'buffer' },
  }, {
    { name = 'buffer' },
  })
})


require('copilot').setup({
  copilot_node_command = NODEJS,
  suggestion = {
    enabled = true,
    auto_trigger = true,   -- Show suggestions as you type
    debounce = 75,         -- Debounce time in ms
    keymap = {
      accept = "<C-J>",    -- Accept suggestion
      accept_word = false, -- Disable accept by word
      accept_line = false, -- Disable accept by line
      next = "<C-L>",      -- Next suggestion
      prev = "<C-H>",      -- Previous suggestion
      dismiss = "<C-K>",   -- Dismiss suggestion
    },
  }
})

require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = 'copilot',
    },
    inline = {
      adapter = 'copilot',
    },
    agent = {
      adapter = 'copilot',
    },
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local fzf = require('fzf-lua')

-- Set up lspconfig.
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(args)
    local bufnr = args.buf
    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = true, desc = desc, noremap = true, silent = true })
    end

    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    nmap('gD', fzf.lsp_declarations, 'Goto declaration')
    nmap('gd', fzf.lsp_definitions, 'Goto definition')
    nmap('K', '<Nop>')
    nmap('<leader>k', function()
      vim.lsp.buf.hover({ border = BORDER })
    end, 'Hover documentation')
    nmap('gi', fzf.lsp_implementations, 'Goto implementation')
    nmap('<leader>cl', vim.lsp.codelens.run, 'Codelens')
    nmap('<leader>i', fzf.lsp_incoming_calls, 'Goto incoming calls')
    nmap('<leader>o', fzf.lsp_outgoing_calls, 'Goto outgoing calls')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace add folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace remove folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'Workspace List Folders')
    nmap('gy', fzf.lsp_typedefs, 'Type definition')
    nmap('<leader>r', vim.lsp.buf.rename, 'Rename')
    nmap('<leader>a', fzf.lsp_code_actions, 'Code action')
    nmap('gr', fzf.lsp_references, 'Goto references')
    nmap('<leader>d', fzf.diagnostics_document, 'Search diagnostics')
    nmap('<leader>D', fzf.diagnostics_workspace, 'Search diagnostics for whole workspace')
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
    nmap('<leader>F', ':Format<CR>', 'Format current buffer with LSP')
  end
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  capabilities
)

-- Small UI for progress
require('fidget').setup()

-- Haskell
require('haskell-tools')
vim.g.haskell_tools = {}

-- Nix
vim.lsp.enable('nixd')

-- Rust
vim.lsp.enable('rust_analyzer')

-- Docker
vim.lsp.enable('dockerls')

-- HTML
vim.lsp.enable('html')

-- Lua
vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      }
    }
  }
})

-- Protobuf
vim.lsp.enable('protols')

-- Javascript
vim.lsp.enable('ts_ls')

require('null-ls').setup()
require('eslint').setup({
  bin = 'eslint', -- or `eslint_d`
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { 'directive', 'problem', 'suggestion', 'layout' },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line", -- or `same_line`
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = 'type', -- or `save`
  },
})
