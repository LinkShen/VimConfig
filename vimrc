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
set wildmenu
set showcmd
set ruler
set autoindent

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" keymap
nn <leader><cr> o<esc>
nn <leader>fa :grep! -r <cword> .<cr><cr>:copen<cr>

" commands
com! DiffLastWrite :w !diff % -

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
call vundle#end()

filetype plugin indent on

" YouCompleteMe
let g:ycm_python_binary_path = '/usr/bin/python'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_invoke_completion = '<c-f>'
nn <f12> :YcmCompleter GoTo<cr>

" ctrlp
let g:ctrlp_working_path_mode = 'a'
