" My own cpp features

" search definition in header
nn <leader>fa :exe 'silent grep! -r --include=*.{cpp,h,cc,hpp} '.expand('<cword>').' .' \| copen<cr><c-l>

