vim.o.compatible = false
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.o.ruler = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4 -- See ':h tabstop' on how to use tabs.
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.cindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.cursorline = true
vim.o.wrap = true
vim.o.laststatus = 2 -- always show filename in status bar even only one buffer is present
vim.o.modified = false -- avoid warning when closing terminal buffer

if vim.loop.os_uname().sysname == "Windows_NT" then
  vim.o.shell = 'pwsh'
else
  vim.o.shell = 'fish'
end

vim.g.mapleader = ','

vim.keymap.set('i', 'jk', '<esc>', { noremap = true })
vim.keymap.set('n', '<C-j>', '5j', { noremap = true })
vim.keymap.set('n', '<C-k>', '5k', { noremap = true })
vim.keymap.set('n', '<leader>ex', '<cmd>Ex<cr>', { noremap = true })
vim.keymap.set('n', '<leader>er', '<cmd>e $MYVIMRC<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fd', vim.diagnostic.open_float, { noremap = true })
-- yank to system clipboard.
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true })
-- '"_d' deletes and copies the selected to the void register so that the default register 
-- default register, after which the cursor is at the right of the deleted. 'P' pastes before
-- the cursor.
vim.keymap.set('x', '<leader>p', '"_dP', { noremap = true })
vim.keymap.set('n', '<leader>v', '<C-v>', { noremap = true })

vim.keymap.set('n', '<A-t>', function() 
  local win_count = #(vim.api.nvim_list_wins())
  if win_count == 1 then
    vim.api.nvim_open_win(0, true, { split = 'left', win = 0 })
  end
end, 
{ noremap = true }) 

local set_indent = function(n)
  vim.opt_local.shiftwidth = n
  vim.opt_local.softtabstop = n
  vim.opt_local.smartindent = true
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function() set_indent(2) end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'javascript',
  callback = function() set_indent(2) end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typescript',
  callback = function() set_indent(2) end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'json',
  callback = function() set_indent(2) end
})

-- Cannot use 'FileType' because *.wxml is not a recognized file type in vim. 
-- We can add wxml as a new file type, but it's too much trouble.
vim.api.nvim_create_autocmd({'BufEnter', 'BufNewFile'}, {
  pattern = {'*.wxml', '*.wxss', '*.wxs'},
  -- callback = function() vim.schedule(function() print('debug linw') end) end
  callback = function() set_indent(2) end
})

-----------------------------------------------------------------------------------------------------------------------
-- 'lazy.nvim'
-----------------------------------------------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nordic').load()
    end
  },
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      { 
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -B build -D CMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      },
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
      require('telescope').load_extension('live_grep_args')
    end
  },
  'neovim/nvim-lspconfig',
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lsp'
    }
  }
})

-----------------------------------------------------------------------------------------------------------------------
-- configure 'telescope.nvim'
-----------------------------------------------------------------------------------------------------------------------

local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
local lga_actions = require('telescope-live-grep-args.actions')

telescope.setup({
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        ['<C-s>'] = lga_actions.quote_prompt({ postfix = " --iglob " }),
      }
    }
  }
})

vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {noremap = true})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {noremap = true})
vim.keymap.set('n', '<leader>fs', telescope.extensions.live_grep_args.live_grep_args, {noremap = true})
vim.keymap.set('v', '<leader>fs', function()
  local text = '""'
  local _, start_row, start_col, _ = unpack(vim.fn.getpos('v'))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos('.'))
  if start_row == end_row then
    local visual = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
    if visual[1] then
      text = '"' .. visual[1] .. '"'
    end
  end
  local scope = ''
  if vim.bo.filetype == 'cpp' then
    scope = ' -tcpp'
  elseif vim.bo.filetype == 'py' then
    scope = ' -tpy'
  elseif vim.bo.filetype == 'cmake'then
    scope = ' -tcmake'
  else
    local buf_name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
    if buf_name == 'CMakeLists.txt' then
        scope = ' -tcmake'
    end
  end
  text = text .. scope
  telescope.extensions.live_grep_args.live_grep_args({ default_text = text })
end, {noremap = true})

-----------------------------------------------------------------------------------------------------------------------
-- configure 'nvim-cmp'
-----------------------------------------------------------------------------------------------------------------------

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_behavior = { behavior = cmp.SelectBehavior.Insert }
cmp.setup({ 
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  completion = { autocomplete = {cmp.TriggerEvent.TextChanged} },
  sources = { 
    { name = 'buffer', keyword_length = 2 },
    { name = 'nvim_lsp', keyword_length = 2 },
    { name = 'path', keyword_length = 2 },
  },
  window = { documentation = cmp.config.window.bordered() },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item(select_behavior)
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_behavior)
      else
        fallback()
      end
    end, {'i', 's'}),
  }
})

-----------------------------------------------------------------------------------------------------------------------
-- configure 'nvim-cmp-lsp'
-----------------------------------------------------------------------------------------------------------------------

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-----------------------------------------------------------------------------------------------------------------------
-- configure 'nvim-lspconfig'
-----------------------------------------------------------------------------------------------------------------------

local lspconfig = require('lspconfig')

lspconfig.clangd.setup({
  capabilities = capabilities
})

lspconfig.pylsp.setup({
  capabilities = capabilities
})

lspconfig.rust_analyzer.setup({
  capabilities = capabilities
})

-----------------------------------------------------------------------------------------------------------------------
-- set lsp keymappings
-----------------------------------------------------------------------------------------------------------------------

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.definitionProvider then
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { buffer = args.buf })
      vim.keymap.set('n', '<leader>gc', vim.lsp.buf.hover, { buffer = args.buf })
    end
    if client.name == 'clangd' then
      -- see: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/clangd.lua#L4
      vim.keymap.set('n', '<leader>hs', '<cmd>ClangdSwitchSourceHeader<cr>', { buffer = args.buf })
    end
  end,
})

-----------------------------------------------------------------------------------------------------------------------
-- configure lsp diagnostics
-----------------------------------------------------------------------------------------------------------------------

-- https://neovim.io/doc/user/lsp.html#vim.lsp.diagnostic.on_publish_diagnostics()
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, 
  {
    underline = false, -- Windows terminal doesn't support squiggly underline.
    virtual_text = true, 
    update_in_insert = false, 
    signs = false,
  }
)
