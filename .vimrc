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

" set instant search and highlight search
set is
set hls

" plugin to manage plugins
call pathogen#infect() 

" open filetype plugin
filetype plugin on 

" 字符编码设置
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,prc,taiwan,latin-1
set termencoding=utf-8
set fileformats=unix,dos

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

" 80 column layout
highlight OverLength ctermbg=darkred ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
set textwidth=0
set cc=+1
highlight ColorColumn guibg=#2d2d2d ctermbg=246

" ======================
" Run command automatically when read/edit/save files
" ======================
" Python 文件的一般设置，比如不要 tab 等
autocmd FileType python setlocal et | setlocal sta | setlocal sw=4
" Do not show .pyc files
let NERDTreeIgnore = ['\.pyc$']

" For Java file, keep tab
autocmd FileType java,c,cpp setlocal noet

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
" set cindent
set smartindent
" set autoindent
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
" set cinkeys=0{,0},:,0#,!,!^F

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
set list listchars=tab:→\ ,trail:·

" ===========
" Git
" ===========
" git-vim
set laststatus=2 " Enables the status line at the bottom of Vim
set statusline=”%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]\ %=[%{GitBranch()}]“

" ===============================
" NERDTree settings
" ===============================
" map <F5> :NERDTree<cr>
" map <F6> :NERDTreeClose<cr>
map ,n :NERDTreeFind<cr>

" Open and close the NERD_tree.vim separately
nmap <F5>  :TrinityToggleNERDTree<CR> 
" Open and close the taglist.vim separately
nmap <F6>  :TrinityToggleTagList<CR>
" Open and close the srcexpl.vim separately
nmap <F7>   :TrinityToggleSourceExplorer<CR>
" Open and close all the three plugins on the same time
nmap <F8>   :TrinityToggleAll<CR>

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
au Filetype html,xml,xsl source ~/.vim/bundle/xmledit/plugin/xml.vim

" ==========================
" Behave like mswin, like <C-c> <C-v> to copy and paste
" ==========================
" source $VIMRUNTIME/mswin.vim
" behave mswin

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

" Search files in subdirectory
function! Find(name)
  let l:list=system("find . -name '".a:name."' | grep -v \".svn/\" | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("<args>")

" Jump html tag
runtime macros/matchit.vim

" Fix the difficult-to-read default setting for diff text highlighting.  The
" " bang (!) is required since we are overwriting the DiffText setting. The
" highlighting
" " for "Todo" also looks nice (yellow) if you don't like the "MatchParen"
" colors.
highlight! link DiffText MatchParen

