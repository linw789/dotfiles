set nocompatible              " be iMproved, required
set encoding=utf-8

set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
"
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'

Plug 'tomasiser/vim-code-dark'

Plug 'ycm-core/YouCompleteMe'

Plug 'LunarWatcher/auto-pairs', { 'tag': '*'  }

" Toggle between *.c* and *.h* buffers.
Plug 'ericcurtin/CurtineIncSw.vim'

Plug 'christianfosli/wsl-copy'

Plug 'pprovost/vim-ps1'

" Initialize plugin system
call plug#end()

""""""""""""""""""""""""
" Global Vairables
""""""""""""""""""""""""

let g:ycm_path_to_python_interpreter = 'C:\Python39\python.exe'
" let g:ycm_show_diagnostics_ui = 0
let g:ycm_auto_hover = ''
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_goto_buffer_command = 'same-buffer'
let g:ycm_language_server =
\ [
\   {
\     'name': 'rust',
\     'cmdline': ['rust-analyzer'],
\     'filetypes': ['rust'],
\     'project_root_files': ['Cargo.toml']
\   }
\ ]
" Disable diagnostics ui for c/c++ files, because it's inaccurate.
let g:ycm_show_diagnostics_ui = 0

set completeopt-=preview

let g:bookmark_auto_close = 1

let g:AutoPairsCompatibleMaps = 0

let mapleader=','

inoremap jk <Esc>
nnoremap <C-j> 5j
nnoremap <C-k> 5k

" credit: https://jesseleite.com/posts/2/its-dangerous-to-vim-alone-take-fzf
nnoremap <leader>f :Files<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>ss :Find 
" below is necessary for using <c-w>: https://vi.stackexchange.com/questions/16090/trouble-using-cword-in-mapping
nnoremap <leader>sc :execute 'Find (struct\|class\|enum) (.+ )*?<c-r><c-w>'<cr>
nnoremap <leader>sw :execute 'Find <c-r><c-w>'<cr>
nnoremap <leader>of :call CurtineIncSw()<CR>

nnoremap <leader>ex :Explore<CR>

"YouCompleteMe functionalities
nnoremap <F12> :YcmCompleter GoToDefinition<cr>

" mappings for junegunn's Easy-Align plugin
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Fix the backspace issue where it won't delete from end-of-line.
set backspace=indent,eol,start

set number relativenumber

set expandtab
set nojoinspaces
set shiftwidth=4
set tabstop=4

set ignorecase smartcase
set incsearch
set hlsearch
set cursorline

set nowrap

set noswapfile

" always show filename in status bar even only one buffer is present
set laststatus=2

" Auto refresh content if modified outside vim. Have to set both of the following two lines.
set autoread
au CursorHold * checktime

syntax on

set t_Co=256
set t_ut=
colorscheme codedark

let g:termdebug_wide=1

" change search highlight background color
hi Search ctermbg=89

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists('w:SavedBufView')
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr('%')] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr('%')
    if exists('w:SavedBufView') && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
            if atStartOfFile && !&diff
                call winrestview(w:SavedBufView[buf])
            endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" Change cursor shape in insert and normal modes.
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\e[7 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI="\<CSI>5\ q"
    let &t_SR="\<CSI>7\ q"
    let &t_EI="\<CSI>2\ q"
endif

" use alternative screen
set t_ti=[?1049h
set t_te=[?1049l

" disable beeping
set vb t_vb=

" mouse support
set mouse=a

" Set up Find command using ripgrep and fzf. Reference: https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --no-ignore --hidden --follow --glob "!.git/*" --glob "!*/build/*" --type c --type cpp --type rust --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
