
if has('win32') || has('win64')
    let s:vimpath = '~/vimfiles'
else
    let s:vimpath = '~/.vim'
endif

if has('gui_running')
    set guioptions=!erM
endif

" appearance and color
colorscheme desert

" basic settings
set nocompatible
syntax on
set backspace=indent,eol,start

set fileencodings=utf-8,GB2312,GBK,CP936

set incsearch
set ignorecase
set smartcase
set hlsearch

set number
set relativenumber
set wildmenu
set showcmd
set statusline=%f\ %m%=%y\ %{&fileencoding}\ %{&fileformat}\ %P
set laststatus=2
set autoindent

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" keymap
nn <leader><cr> o<esc>
nn <leader>m :CtrlPMRUFiles<cr>

" misc
com! LineNum :call ToggleLineNum()

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

" find
nn <leader>fa :exe 'FindAll '.expand('<cword>').' .'<cr>
nn <leader>ff :CtrlPLine %<cr>

com! -nargs=* FindAll :call FindAll(<f-args>)

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

" fold
nn <leader>zm :call FoldLevelDown()<cr>
nn <leader>zM :call SetFoldLevel(0)<cr>
nn <leader>zr :call FoldLevelUp()<cr>
nn <leader>zR :call SetFoldLevel(99)<cr>

let s:startfoldlevel = 0
let s:maxfoldlevel = 0
let s:curfoldlevel = 0
function! SetFoldLevel(level)
    let s:startfoldlevel = a:level
    call DoFold()
endfunction

function! FoldLevelUp()
    let s:startfoldlevel += 1
    call DoFold()
endfunction

function! FoldLevelDown()
    let s:startfoldlevel -= 1
    call DoFold()
endfunction

function! DoFold()
    if s:startfoldlevel < 0
        let s:startfoldlevel = 0
    endif
    set foldexpr=CheckFoldLevel(v:lnum)
    set foldmethod=expr
    if s:startfoldlevel >= s:maxfoldlevel
        let s:startfoldlevel = s:maxfoldlevel
    else
        execute "%foldclose".expand("<cr>")
    endif
endfunction

function! CheckFoldLevel(lnum)
    if a:lnum == 1
        let s:maxfoldlevel = 0
        let s:curfoldlevel = 0
    endif

    let l:ret = s:curfoldlevel
    let l:line = getline(a:lnum)
    if l:line =~ '{'
        let s:curfoldlevel += 1
        if s:curfoldlevel > s:maxfoldlevel
            let s:maxfoldlevel = s:curfoldlevel
        endif
        let l:ret = s:curfoldlevel - s:startfoldlevel
    elseif l:line =~ '}'
        let l:ret = s:curfoldlevel - s:startfoldlevel
        if s:curfoldlevel > 0
            let s:curfoldlevel -= 1
        endif
    else
        let l:ret = s:curfoldlevel - s:startfoldlevel
    endif

    if l:ret < 0
        let l:ret = 0
    elseif l:ret > 1
        return 1
    endif
    return l:ret
endfunction

" commands
com! DiffLastWrite :w !diff % -

" protobuf
augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

" Vundle
filetype off
let &runtimepath .= ', ' . s:vimpath . '/bundle/Vundle.vim'

call vundle#begin(s:vimpath . '/bundle')
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'google/vim-searchindex'
Plugin 'scrooloose/nerdcommenter'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'ycm-core/YouCompleteMe'
call vundle#end()

filetype plugin indent on

" ctrlp
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = '\v\.(o|so|a)$'
let g:ctrlp_extensions = ['line']

" nerdcommenter
let g:NERDSpaceDelims = 1

" YouCompleteMe
let g:ycm_min_num_of_chars_for_completion = 99

" lsp
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp']})
endif

" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/var/log/vim-lsp.log')
highlight link lspReference CursorLine

inoremap <expr><tab> pumvisible()?"\<c-n>":"\<tab>"
noremap <leader>fr :LspReference<cr>
noremap <leader>fd :LspDefinition<cr>

