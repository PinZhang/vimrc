" set colorscheam
color evening
" change to ron color scheme when vimdiff
if &diff
    set t_Co=256
    set background=dark
    colorscheme ron
else
    colorscheme evening
endif


" plugin to manage plugins
call pathogen#infect() 

" 字符编码设置
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,prc,taiwan,latin-1
set termencoding=utf-8
set fileformats=dos,unix

" show line number
set number

" nowrap
set nowrap

" Show current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline nocursorcolumn
set cursorline nocursorcolumn

" 自动检测语法
syntax on

" ======================
" Run command automatically when read/edit/save files
" ======================
" Python 文件的一般设置，比如不要 tab 等
autocmd FileType python setlocal et | setlocal sta | setlocal sw=4

" Python Unittest 的一些设置
" 可以让我们在编写 Python 代码及 unittest 测试时不需要离开 vim
" 键入 :make 或者点击 gvim 工具条上的 make 按钮就自动执行测试用例
autocmd FileType python setlocal makeprg=python\ ./alltests.py
autocmd BufNewFile,BufRead test*.py setlocal makeprg=python\ %

" associate file type
autocmd BufEnter,BufReadPre *.jsm set filetype=javascript

" auto reload .vimrc
autocmd! bufwritepost .vimrc source ~/.vimrc

" ======================
" Configure editor with tabs
" ======================
set textwidth=120 " break lines when line length increases
set tabstop=4     " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4  " number of spaces to use for auto indent
set autoindent    " copy indent from current line when starting a new line

" ======================
" Windows move
" ======================
nmap <C-J> <C-w>j
nmap <C-K> <C-w>k
nmap <C-H> <C-w>h
nmap <C-L> <C-w>l


" ===========
" Git
" ===========
" git-vim
set laststatus=2 " Enables the status line at the bottom of Vim
set statusline=”%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]\ %=[%{GitBranch()}]“

" ===============================
" NERDTree settings
" ===============================
map <F5> :NERDTree<cr>
map <F6> :NERDTreeClose<cr>
map ,n :NERDTreeFind<cr>

" Open NERDTree automatically
" au VimEnter *  NERDTree

" ===============================
" Change to Hexmode
" =============================== 
" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()
" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
