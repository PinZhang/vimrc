set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set langmenu=none
language messages none 

set guifont=Consolas:h12
set guifontwide=MingLiU:h12

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

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
" call pathogen#infect() 

" 字符编码设置
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,prc,taiwan,latin-1
set termencoding=utf-8
set fileformats=dos,unix

if has("win32")
  set fileencoding=chinese
else
  set fileencoding=utf-8
endif

"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"解决consle输出乱码
language messages zh_CN.utf-8

" show line number
set number

" nowrap
set nowrap

" Show current line
au WinLeave * set cursorline nocursorcolumn
au WinEnter * set cursorline nocursorcolumn
set cursorline nocursorcolumn

" Jump to next line automatically when cursor move to the end of the current line.
set whichwrap+=h,l

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
" autocmd! bufwritepost .vimrc source ~/.vimrc

" ======================
" Configure editor with tabs
" ======================
" set autoindent    " copy indent from current line when starting a new line
set smartindent
" set autoindent
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

" ======================
" Windows move
" ======================
nmap <C-J> <C-w>j
nmap <C-K> <C-w>k
nmap <C-H> <C-w>h
nmap <C-L> <C-w>l

" make hjkl movements accessible from insert mode via the <Alt> modifier key
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l

" Show space and tab character
" set list listchars=tab:→\ ,trail:·

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
command! -bar Hexmode call ToggleHex()
 
" helper function to toggle hex mode
function! ToggleHex()
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


" ========================
" Source xmledit with file type: html, xsl
" ========================
au Filetype html,xml,xsl source $VIMRUNTIME/plugin/xml.vim

" ==========================
" Behave like mswin, like <C-c> <C-v> to copy and paste
" ==========================
" source $VIMRUNTIME/mswin.vim
" behave mswin
" keep file type as unix file.
" set ff=unix

" =================
" Close bracelet, quote etc.
" =================
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap < <><ESC>i
:inoremap > <c-r>=ClosePair('>')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i

function ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endf

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

