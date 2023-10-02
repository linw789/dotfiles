let mapleader=','

inoremap jk <esc>

nnoremap <C-j> 5j
nnoremap <C-k> 5k
nnoremap <leader>y "*y

nnoremap <leader>of <Cmd>call VSCodeNotify('C_Cpp.SwitchHeaderSource')<CR>
nnoremap <leader>q <Cmd>call VSCodeNotify('workbench.action.closeEditorsInGroup')<CR>
nnoremap <leader>b <Cmd>call VSCodeNotify('bookmarks.toggle')<CR>
nnoremap <leader>bs <Cmd>call VSCodeNotify('bookmarksExplorer.focus')<CR>

set ignorecase smartcase
set incsearch
set hlsearch

autocmd Filetype c,cpp set comments^=:///
