" Special settings for rst files

setlocal suffixesadd=.rst
setlocal linebreak

" Special mapping for rst files
"
noremap <buffer> <leader>h1 yyp^v$r=o<ESC>
noremap <buffer> <leader>h2 yyp^v$r-o<ESC>
noremap <buffer> <leader>h3 yyp^v$r+o<ESC>
noremap <buffer> <leader>h4 yyp^v$r~o<ESC>

" strong is with **
noremap <buffer> <leader>s Bi**<ESC>Ea**<ESC>
" empasis is with *
noremap <buffer> <leader>e Bi*<ESC>Ea*<ESC>
setlocal iskeyword=@,48-57,_,192-255,-
