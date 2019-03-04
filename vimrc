" appearance and color
colorscheme desert

" basic settings
set nocompatible
syntax on
set backspace=indent,eol,start

set encoding=utf-8
set fileencodings=utf-8,GB2312
set termencoding=utf-8

set incsearch
set ignorecase
set smartcase
set hlsearch

set number
set relativenumber
set wildmenu
set showcmd
set ruler
set laststatus=2
set autoindent

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" keymap
nn <leader><cr> o<esc>
nn <leader>fa :exe 'FindAll '.expand('<cword>').' .'<cr>
nn <leader>ff :CtrlPLine %<cr>

" function
function! ToggleLineNum()
    if &number
        set nonumber
    else
        set number
    endif

    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunction

function! FindAll(...)
    let l:pat = expand('<cword>')
    let l:dir = "."
    let l:include = ""
    if a:0 >= 1
        let l:pat = a:1
    endif
    if a:0 >= 2
        let l:dir = a:2
    endif

    if a:0 == 3
        let l:include = "--include=*.".a:3
    elseif a:0 > 3
        let l:include = "--include=*.{".join(a:000[2:-1], ",")."}"
    endif

    execute "silent grep! ".l:include." -i ".l:pat." -r ".l:dir | redraw! | copen
endfunction

" commands
com! DiffLastWrite :w !diff % -
com! LineNum :call ToggleLineNum()
com! -nargs=* FindAll :call FindAll(<f-args>)

" protobuf
augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

" Vundle
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'google/vim-searchindex'
Plugin 'scrooloose/nerdcommenter'
call vundle#end()

filetype plugin indent on

" YouCompleteMe
let g:ycm_python_binary_path = '/usr/bin/python'
" let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_invoke_completion = '<c-f>'
nn <f12> :YcmCompleter GoTo<cr>

" ctrlp
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = '\v\.(o|so|a)$'
let g:ctrlp_extensions = ['line']

" nerdcommenter
let g:NERDSpaceDelims = 1
