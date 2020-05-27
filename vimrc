"source /apollo/env/envImprovement/var/vimrc

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tomasiser/vim-code-dark'
Plugin 'MattesGroeger/vim-bookmarks'

Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/vim-easy-align'

Plugin 'ycm-core/YouCompleteMe'

Plugin 'ericcurtin/CurtineIncSw.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let g:ycm_path_to_python_interpreter = '/apollo/env/YouCompleteMeBuilder/bin/ycm-python'

let termdebugger = "/apollo/env/GDBStandalone/bin/gdb"

let mapleader=","

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

" mappings for junegunn's Easy-Align plugin
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Fix the backspace issue where it won't delete from end-of-line.
set backspace=indent,eol,start

set number relativenumber

set expandtab
set nojoinspaces
set shiftwidth=4

set ignorecase smartcase
set incsearch
set hlsearch
set cursorline

set nowrap

set noswapfile

" always show filename in status bar even only one buffer is present
set laststatus=2

" Auto refresh content if modified outside vim. Have to set both of the
" following two lines.
set autoread
au CursorHold * checktime

syntax on

set t_Co=256
set t_ut=
colorscheme codedark

" change search highlight background color
hi Search ctermbg=89

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
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
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[1 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[1 q"
endif

" use alternative screen
set t_ti=[?1049h
set t_te=[?1049l

set rtp+=~/.fzf

" Set up Find command using ripgrep and fzf. Reference: https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --no-ignore --hidden --follow --glob "!.git/*" --glob "!*/build/*" --type cpp --type rust --type ruby --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
