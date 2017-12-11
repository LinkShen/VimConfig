" My own cpp features

" search definition in header
nn <leader>fa :exe 'silent grep! -r --include=*.{cpp,h} '.expand('<cword>').' .' \| copen<cr><c-l>
nn <leader>ft :YcmCompleter GetType<cr>

