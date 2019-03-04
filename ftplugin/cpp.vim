" My own cpp features

" search definition in header
nn <leader>fa :exe 'FindAll '.expand('<cword>').' . cpp cxx cc c h hpp'<cr>
nn <leader>ft :YcmCompleter GetType<cr>
nn <F11> :call youcompleteme#GotoDefinitionCpp()<cr><c-l>zz

