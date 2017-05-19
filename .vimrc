" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" After selecting something in visual mode and shifting, I still want that"
" selection intact **"
vmap > >gv
vmap < <gv
" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <F1> :noh<return><esc>
map <F6> <C-W>w

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
" tabs -> spaces
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set ch=2		" Make command line two lines high
set mousehide		" Hide the mouse when typing text
" Do not create any backup files 
set nobackup
set nowritebackup
" Status line definition.
set statusline=[%n]\ %<%f%m%r\ %w\ %y\ \ <%{&fileformat}>%=[%o]\ %l,%c%V\/%L\ \ %P
set laststatus=2 " always show the status line
set pastetoggle=<F2>

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv


" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" use 256 colors in Console mode if we think the terminal supports it
if &term =~? 'mlterm\|xterm'
	set t_Co=256
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
"se grepprg=c:\\cygwin2\\bin\\grep\ -n\ -r
map î :cn
map ð :cp
" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
"Set to auto read when a file is changed from the outside
set autoread
map! <S-Insert> <MiddleMouse>

nnoremap <silent> <CR> :noh<CR><CR>
map <silent> <F12> :set invhls<CR>
map <silent> <F11> :bd<CR>
map <silent> <F9> :TlistToggle<CR>
map <silent> ,r :%s/ *$//g<CR>
map <silent> ,t :%s/\t/    /g<CR>
map <silent> ,m :%s/\r//g<CR>
map <C-e>  :silent !explorer %:p:h:gs?\/?\\\\\\?<CR> 
map <silent> ,e :Explore<CR>
map  <C-Up> :bn<Return>
map  <C-Down> :bp<Return> 
nmap <silent> ,k :cs kill 0<CR>
nmap <silent> ,a :cs add cscope.out<CR>
nmap <silent> <F10> :cs add $CSCOPE_DB\cscope.out $CSCOPE_DB<CR>

let windows10=$WINDOWS10
if windows10 == '0'
  set t_ku=OA 
  set t_kd=OB 
  set t_kr=OC 
  set t_kl=OD
endif

""""""""""""""""""""""""""""""
" Yank Ring
""""""""""""""""""""""""""""""
map <silent> ,y :YRShow<cr>

colorscheme desert

augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=black guibg=#342342
  autocmd BufEnter * match OverLength /\%80v.*/
augroup END

fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>

"Fold all ifdef blocks
autocmd FileType *.[ch]{,pp} call FoldPreprocessor()
function! FoldPreprocessor()
    set foldmarker=#ifdef,#endif
    set foldmethod=marker
endfunction
