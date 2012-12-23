" Yannick LM .vimrc

" {{{ Simple vim settings
syntax on
filetype plugin on
set nocompatible
set history=10000
set mouse=a
set encoding=utf-8
set showcmd
set showmode
set ruler
set backspace=2
set virtualedit=block
set autowriteall
set shiftround

" Nicer scrolling
set scroll=5
set scrolloff=2

" This is nice if you have something
" that reset the title of you term at
" each command, othersize it's annoying ...
set title

" Allow completion on filenames right after a '='.
" Uber-useful when editing bash scripts
set isfname-==

" Disable ex
nnoremap Q gq

" No more annoying bell
set visualbell t_vb=

" Disable useless ctrl+space behavior:
imap <Nul> <Space>

" Always display statusline
set laststatus=2

" nice menu to navigate through possible completions
set wildmenu

" smarter behavior of 'J' (join lines)
set nojoinspaces

" highlight search
set hlsearch

" search as you type
set incsearch

" Remove menu bar from GUI
let did_install_default_menus = 1

" I've always find it weird that it was not this way ...
set splitbelow

" More logical, but not vi-compatible
noremap Y y$
set gdefault
map Q gq

" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" |
  \ endif

" Always load those useful plugins:
runtime! macros/matchit.vim
runtime! plugin/imaps.vim
runtime! ftplugin/man.vim

" These are overloaded in the various ftplugin/ scripts
set shiftwidth=2
set expandtab
set smarttab
set smartindent
set tabstop=4

" }}}
" {{{ Colors
let os=substitute(system('uname'), '\n', '', '')
" has('mac') only works on macvim ...
if os == 'Darwin' || os == 'Mac'
  set background=light
else
  se background=dark
endif
" Note that GUI stuff is handled in .gvimrc anyway
" }}}
" {{{ Custom functions
" Remove trailing whitespace
function! CleanWhiteSpace()
  let _s=@/
  let l = line(".")
  let c = col(".")
  :%s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction()

command! -nargs=0 CleanWhiteSpace :call CleanWhiteSpace()


" Convert DOS line endings to UNIX line endings

function! FromDos()
  %s/\r//e
endfunction

command! FromDos call FromDos()

" Automatically give executable permissions if file begins with #! and
" contains '/bin/' in the path
function! MakeScriptExecuteable()
  if getline(1) =~ "^#!.*/bin/"
    silent !chmod +x <afile>
  endif
endfunction


" Used to create missing directories before writing a
" buffer
function! MkdirP()
  :!mkdir -p %:h
endfunction

command! MkdirP call MkdirP()

" }}}
" {{{ Plugins customizations

" Tell NerdCommenter to shut up:
let g:NERDShutUp=1

" Tell snippy to use <C-Space> (tab conflicts with
" supetab)
if has("gui_running")
  let g:snippetsEmu_key = "<C-Space>"
else
  " for some reason when in a term, c-space
  " is interpreted as c-@
  let g:snippetsEmu_key = "<C-@>"
endif

" Prevent YankRing.vim from polluting $HOME:
let g:yankring_history_dir = expand('$HOME') . '/.vim'
if ! isdirectory(g:yankring_history_dir)
  call mkdir(g:yankring_history_dir, "p")
endif

" Status line (requires VimBuddy plugin to be present)
set statusline=%{VimBuddy()}\ [%n]\ %<%f\ %{fugitive#statusline()}%h%m%r%=%-14.(%l,%c%V%)\ %P\ %a

" Fix go syntax file:
let g:go_highlight_array_whitespace_error=0
let g:go_highlight_chan_whitespace_error=0
let g:go_highlight_extra_types=0
let g:go_highlight_space_tab_error=0
let g:go_highlight_trailing_whitespace_error=0

" I find it annoying that fugitive does not define this
function! GAdd()
  w
  !git add %
endfunction

command! GAdd call GAdd()

" }}}
" {{{ Autocommands
" Remove trailing whitespaces when saving:
autocmd bufwritepre * :CleanWhiteSpace
au BufWritePost * call MakeScriptExecuteable()

" Spell checking
augroup spell
  autocmd!
  autocmd filetype rst  :setlocal spell spelllang=en
  autocmd filetype tex  :setlocal spell spelllang=en
  autocmd filetype gitcommit  :setlocal spell spelllang=en
augroup end

" Special settings from vim files
augroup filetype_vim
  autocmd!
  autocmd filetype vim setlocal foldmethod=marker
  autocmd bufwritepost *.vim :source %
augroup END
" }}}
" {{{ Mapping and abbreviations

" I always make mistakes in these words
abbreviate swith switch
abbreviate wich which
abbreviate lauch launch
abbreviate MSCV MSVC

" I prefer , for mapleader rather than \
let mapleader=","

" I prefer running make! to make, but
" typing :make is much too long anyway
nnoremap <leader>m :make!<cr>

" Simpler way to go to normal mode from insert mode
inoremap jj <Esc>

" « it's one less key to hit every time I want to save a file »
"     -- Steve Losh (again)
nnoremap ; :
vnoremap ; :

" use begging-of-history inside command mode
" with ctrl+n ctrl+p
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap %% <C-R>=expand('%h').'/'<cr>

" 'cd' towards the dir in which the current file is edited
" but only change the path for the current window
map <leader>cd :lcd %:h<CR>

" edit the alternate file
nmap <leader><leader> <C-^>

" Open files located in the same dir in with the current file is edited
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Navigate through the buffer's list with alt+up, alt+down
nnoremap <M-Down>  :bp<CR>
nnoremap <M-Up>    :bn<CR>

" Man page for work under cursor
nnoremap K :Man <cword> <CR>

" Spell check
cmap spc setlocal spell spelllang=

" Bubble single lines
nmap <C-Up> ddkP
nmap <C-Down> ddp

" Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]

" Call chmod +x on a file when necessary:
nmap <leader>! :call FixSheBang(@%) <CR>

" }}}

" {{{ hard core settings
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>

inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>

inoremap <Esc> <Nop>
nnoremap <Esc> :echo don't do that

" }}}
