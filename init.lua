vim.o.compatible = false
vim.opt.backspace = { "indent", "eol", "start" }
vim.o.ruler = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.cursorline = true
vim.o.wrap = true
vim.o.laststatus=2 -- always show filename in status bar even only one buffer is present

vim.g.mapleader = ','

vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('n', '<C-j>', '5j', { noremap = true })
vim.keymap.set('n', '<C-k>', '5k', { noremap = true })

------------------------------------------------------------------
-- 'lazy.nvim' package manager: https://github.com/folke/lazy.nvim
------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            { 
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -B build -D CMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
            }
        }
    }
})

----------------------------------------------------------------------------------
-- configure 'telescope.nvim': https://github.com/nvim-telescope/telescope.nvim
----------------------------------------------------------------------------------

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {noremap = true})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {noremap = true})

