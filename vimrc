scriptencoding utf-8

" explicitly enable vim/non-vi behavior
set nocompatible

" hide vim welcome screen
set shm+=I

" disable modelines
set nomodeline

" enable desired vim status messages
" (shown on the command-line / bottom of the screen)
set showmode
set showcmd
set ruler

" don't highlight searches
set nohlsearch
set noincsearch

" tab size
set ts=4 sw=4

" preserve missing eol if file was already missing eol
" (this is important to avoid creating unnecessary changes in SCM)
if has("patch-7.4.785") " introduction of fixeol
	set nofixeol
endif

" use some fancy unicode characters when showing invisible characters
" TODO: check for terminal unicode support
if has("patch-7.4.710") " introduction of lcs-space
	set listchars=eol:¶,trail:·,space:·,tab:»\ ,nbsp:%
else
	set listchars=eol:¶,trail:·,tab:»\ ,nbsp:%
endif


" allow opening a lot more files at once
set tabpagemax=100

" allow GUI-like text-selection, navigation, and operation
set selectmode=key,mouse
set keymodel=startsel,stopsel
set mousemodel=popup
set whichwrap=b,s,<,>,[,]
set backspace=indent,eol,start

" allow the cursor to remain at the end of a line when leaving insert mode
" (this is important for <c-o>"+gP at tne end of a line)
set virtualedit=onemore

" store things in ~/.vim/
" (this will avoid creating extra files on Google drive and stuff like that)
set backupdir=~/.vim/backup/
set directory=~/.vim/swap/
set undodir=~/.vim/undo/

" make the above directories if they don't exist
for dir in [&backupdir,&directory,&undodir]
	if !isdirectory(dir)
		call mkdir(dir,'p')
	endif
endfor

" don't violate my explicit usage of tabs to appease the Python developers
" (this is also important to avoid mixing indentation in existing files)
" TODO: check VIM version
let g:python_recommended_style = 0

" enable some built-in whitespace error checks
" TODO: check VIM version
let c_space_errors = 1
let java_space_errors = 1

" Import functions to set remote clipboard using OSC 52
"
" Note: OSC 52 is defined by xterm but implemented in several terminals
" See: https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
let g:oscyank_silent = 1
let g:oscyank_term = 'default'
source ~/.vim/oscyank.vim


let g:kmarek_want_exclusive_selection = 0

if has("gui")
	" automatically set selection=exclusive for select mode
	if has("kmarek_bugfix_selection_exclusive_word_boundary")
		let g:kmarek_want_exclusive_selection = 1
	endif
endif


" Use xterm control sequencees to set cursor shape
if &term =~ "xterm"

" start insert mode (bar cursor shape)
let &t_SI = "\e[5 q"

" start replace mode (underline cursor shape)
let &t_EI = "\e[1 q"

" end insert or replace mode (block cursor shape)
let &t_SR = "\e[3 q"

" vim only uses t_EI when entering normal mode by leaving insert mode,
" and instead uses t_VS at the very beginning. However, vim doesn't send
" t_VS if t_vs is not also set. Set them both to t_EI so we get a
" block cursor when vim starts.
let &t_vs = &t_EI
let &t_VS = &t_EI

" reset cursor shape when vim exits
autocmd VimLeave * call echoraw("\e[0 q")

" fix visual mode highlight
if has("kmarek_term_allowinvcur")
	set allowinvcur
endif

" automatically set selection=exclusive for select mode
if has("kmarek_term_allowinvcur") && has("kmarek_bugfix_selection_exclusive_word_boundary") && has("kmarek_term_visual_cursor_t_SI")
	let g:kmarek_want_exclusive_selection = 1
endif

endif " &term =~ "xterm"


" set cursors for linux tty
"
" See: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/Documentation/VGA-softcursor.txt?h=v2.6.12
if &term =~ "linux"

" start insert mode (using standard underline in linux tty)
let &t_SI = "\e[?2c"
" start replace mode (using thick underline in linux tty)
let &t_SR = "\e[?3c"
" end insert or replace mode (block cursor shape)
let &t_EI = "\e[?8c"

" vim only uses t_EI when entering normal mode by leaving insert mode,
" and instead uses t_VS at the very beginning. However, vim doesn't send
" t_VS if t_vs is not also set. Set them both to t_EI so we get a
" block cursor when vim starts.
let &t_vs = &t_EI
let &t_VS = &t_EI

" the default cursor visible/invisible codes include "\e[?c" sequences,
" which reset the cursor shape (preventing t_SI, t_SR, and t_EI from
" working)
let &t_ve = "\e[?25h"
let &t_vi = "\e[?25l"

" reset cursor shape when vim exits
autocmd VimLeave * call echoraw("\e[?c")

" fix visual mode highlight
if has("kmarek_term_allowinvcur")
	set allowinvcur
endif

" automatically set selection=exclusive for select mode
if has("kmarek_term_allowinvcur") && has("kmarek_bugfix_selection_exclusive_word_boundary") && has("kmarek_term_visual_cursor_t_SI")
	let g:kmarek_want_exclusive_selection = 1
endif

endif " &term =~ "linux"


" maybe use exclusive selection by default if the conditions are right
if g:kmarek_want_exclusive_selection
	set selection=exclusive
else
	set selection=inclusive
endif



" functiton to setup my highlights
function! MyHighlights()

	" for listchars
	highlight SpecialKey ctermfg=grey guifg=grey70
	highlight NonText ctermfg=grey guifg=grey70

	" highlight erroneous whitespace in red
	highlight ExtraWhitespace ctermbg=red guibg=red

endfunction

" setup my highlights right now, and also automatically re-setup my
" highlights when :colorscheme clears them...
call MyHighlights()
autocmd ColorScheme * call MyHighlights()

" Show trailing whitepace and spaces before a tab:
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
match ExtraWhitespace /\s\+$\| \+\ze\t/


" Note: several of the following mappings override default behavior
"
"       - <c-c> in visual will copy instead of cancel (use <esc> to cancel)
"
"       - <c-v> in visual will paste over instead of canceling or starting
"         visual block (use <esc> to cancel, <c-v> from normal mode to
"         start visual block)
"
"       - <c-a> in normal mode will select all instead of adding to a
"         number (maybe use g<c-a> in visual mode, instead)
"
"       - <c-a> in insert mode will select all instead of repeating
"         previous insertion
"
"       - <c-z> will undo instead of putting vim in the background
"         use :call feedkeys("\<c-z>", 'n') to put vim in background)
"
"       - <c-y> in normal mode will redo instead of scrolling up
"
"       - shift-arrows will perform GUI-like selection instead of navigating
"         by word boundaries (use w and b instead)
"
" Note: Several of the following mappings only apply to gvim
"       due to the way terminals work, but also need to be guarded
"       with if-statements because they'll confuse vim.
"
"       For example, vim can't tell the difference between <c-a>
"       and <c-s-a> but gvim can
"
"       See: https://catern.com/posts/terminal_quirks.html


" up and down move by screen lines
" (except in select-mode)
" TODO: check for keymodel=stopsel
map <down> g<down>
map <up> g<up>
sunmap <down>
sunmap <up>
imap <down> <c-o>g<down>
imap <up> <c-o>g<up>

" make left and right not cancel visual when keymodel=stopsel
" TODO: check for keymodel=stopsel
xnoremap <left> h
xnoremap <right> l

" ctrl-left and ctrl-right move by word boundaries
" (adjusted to act like GUIs)
nnoremap <c-left> B
nnoremap <c-right> E<right>
inoremap <c-left> <c-o>B
inoremap <c-right> <c-o>E<right>
xnoremap <c-left> B
xnoremap <c-right> El

" shift-up and shift-down in select mode move by screen lines
" TODO: check for selectmode=key keymodel=startsel
snoremap <s-down> <c-o>g<down>
snoremap <s-up> <c-o>g<up>

" shift-up and shift-down start selection
" (and uses shift-up and shift-down in select mode to move by screen line)
" TODO: check for selectmode=key keymodel=startsel
nmap <s-down> gh<s-down>
nmap <s-up> gh<s-up>
" TODO: check for keymodel=startsel
imap <s-down> <c-o>gh<s-down>
imap <s-up> <c-o>gh<s-up>

" shift-left and shift-right start selection
" (but adjusts for cursor position for selection=inclusive)
" TODO: check for selectmode=key keymodel=startsel selection=inclusive
nmap <expr> <s-left> &selection ==? "inclusive" ? "<left>gh" : "<s-left>"
nmap <expr> <s-right> &selection ==? "inclusive" ? "gh" : "<s-right>"
imap <expr> <s-left> &selection ==? "inclusive" ? "<left><c-o>gh" : "<s-left>"
imap <expr> <s-right> &selection ==? "inclusive" ? "<c-o>gh" : "<s-right>"

" ctrl-shift-left and ctrl-shift-right select by words
" (with adjusted selection behavior)
" TODO: check for selectmode=key keymodel=startsel selection=inclusive
nmap <expr> <c-s-left> &selection ==? "inclusive" ? "<left>gh<c-o>B" : "gh<c-o>B"
nmap <c-s-right> gh<c-o>E
imap <expr> <c-s-left> &selection ==? "inclusive" ? "<left><c-o>gh<c-o>B" : "<c-o>gh<c-o>B"
imap <c-s-right> <c-o>gh<c-o>E
function! KmarekVisualExpr(left,right,same)
	let l:pos = getpos('.')[1:2]
	let l:end = getpos('v')[1:2]
	if l:pos[0] < l:end[0]
		return a:left
	elseif l:pos[0] > l:end[0]
		return a:right
	elseif l:pos[1] < l:end[1]
		return a:left
	elseif l:pos[1] > l:end[1]
		return a:right
	else
		return a:same
	endif
endfunction
smap <expr> <c-s-left> &selection ==? "inclusive" ? KmarekVisualExpr("\<c-o>B","\<c-o>B<c-o><left>","\<c-o>B") : KmarekVisualExpr("\<c-o>B","\<c-o>B","\<c-o>B")
smap <expr> <c-s-right> &selection ==? "inclusive" ? KmarekVisualExpr("\<c-o>E<c-o><right>","\<c-o>E","\<c-o>E") : KmarekVisualExpr("\<c-o>E<c-o><right>","\<c-o>E","\<c-o>E<c-o><right>")

" shift-home selects to the left direction, correct initial cursor position
" TODO: check for selectmode=key keymodel=startsel selection=inclusive
nnoremap <s-home> <left><s-home>
inoremap <s-home> <left><s-home>
nnoremap <c-s-home> <left><c-s-home>
inoremap <c-s-home> <left><c-s-home>

" shift-end selects the newline at the end of the line, correct end position
" TODO: check for selectmode=key keymodel=startsel selection=inclusive virtualedit=onemore
nnoremap <s-end> gh<c-o>$<c-o>h
inoremap <s-end> <c-o>gh<c-o>$<c-o>h
snoremap <s-end> <c-o>$<c-o>h

" Select mode will go to insert mode when typing "over" a selection,
" I want similar behavior when backspacing a selection.
snoremap <bs> <space><bs>

" select-all
" Note: these are character-wise rather than line-wise
"nnoremap <c-a> gg0gh<c-o>G<c-o>$
inoremap <c-a> <c-o>gg<c-o>0<c-o>gh<c-o>G<c-o>$
xnoremap <c-a> gg0oG$<c-g>
snoremap <c-a> <c-o>gg<c-o>0<c-o>o<c-o>G<c-o>$
if has('gui_running')
nnoremap <c-s-a> gg0gh<c-o>G<c-o>$
inoremap <c-s-a> <c-o>gg<c-o>0<c-o>gh<c-o>G<c-o>$
xnoremap <c-s-a> gg0oG$<c-g>
snoremap <c-s-a> <c-o>gg<c-o>0<c-o>o<c-o>G<c-o>$
endif

" TODO: use another register when "+ doesn't exist
if has('clipboard')

" copy
" TODO: apply ctrl-c to smap and not xmap
"       (to allow ctrl-c to exit visual mode)
" Note: These vmap ends in <c-g><c-o>o<c-o>o<c-g> so my CursorMoved
"       select-mode hooks kick-in during "(insert) SELECT" mode.
vnoremap <c-c> "+ygv<c-g><c-o>o<c-o>o<c-g>
if has('gui_running')
vnoremap <c-s-c> "+ygv<c-g><c-o>o<c-o>o<c-g>
vnoremap <c-insert> "+ygv<c-g><c-o>o<c-o>o<c-g>
endif

" paste
"noremap <c-v> "+gP
cnoremap <c-v> <c-r>+
if has('gui_running')
noremap <c-s-v> "+gP
noremap <s-insert> "+gP
snoremap <c-s-v> <c-o>"+gP
cnoremap <c-s-v> <c-r>+
cnoremap <s-insert> <c-r>+
endif
" TODO: would I rather rely on paste.vim, like mswin.vim does?
"if 1
"    exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
"    exe 'inoremap <script> <C-S-V> <C-G>u' . paste#paste_cmd['i']
"    exe 'inoremap <script> <s-insert> <C-G>u' . paste#paste_cmd['i']
"    "exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
"    exe 'vnoremap <script> <C-S-V> ' . paste#paste_cmd['v']
"    exe 'vnoremap <script> <s-insert> ' . paste#paste_cmd['v']
"endif
" TODO: why does paste.vim put <c-\> before <c-o> ?
inoremap <c-v> <c-g>u<c-o>"+gP
"xnoremap <c-v> "+gP
snoremap <c-v> <c-o>"_c<c-o>"+gP
if has('gui_running')
inoremap <c-s-v> <c-g>u<c-o>"+gP
inoremap <s-insert> <c-g>u<c-o>"+gP
vnoremap <c-s-v> <c-o>"+gP
vnoremap <s-insert> <c-o>"+gP
endif

" Use OSC 52 to set remote clipboard when in ssh or tmux
"
if $SSH_CLIENT != "" || $TMUX != ""
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif
endif

endif " has('clipboard')

" undo
noremap <c-z> u
inoremap <c-z> <c-o>u

" redo
"noremap <c-y> <c-r>
inoremap <c-y> <c-o><c-r>

" evim makes ctrl-l in insert mode go to normal mode
inoremap <c-l> <c-\><c-n>



" The following three functions are my way of clearing &keymodel
" when using visual mode, because I only want keymodel=stopsel for
" select mode.
"
" Additionally, they switch to selection=inclusive for visual mode
" (this is what I want when my gvim is normally using exclusive for select)

function! KmarekUiEnterVisual()
	if ! exists("g:KmarekUiEnterVisual_keymodel")
		let g:KmarekUiEnterVisual_keymodel = &keymodel
	endif
	if ! exists("g:KmarekUiEnterVisual_selection")
		let g:KmarekUiEnterVisual_selection = &selection
	endif
	set keymodel=
	set selection=inclusive
endfunction

function! KmarekUiLeaveVisual()
	if exists("g:KmarekUiEnterVisual_keymodel")
		let &keymodel=g:KmarekUiEnterVisual_keymodel
		unlet g:KmarekUiEnterVisual_keymodel
	endif
	if exists("g:KmarekUiEnterVisual_selection")
		let &selection=g:KmarekUiEnterVisual_selection
		unlet g:KmarekUiEnterVisual_selection
	endif
endfunction

function! KmarekUiMaybeVisual()
	"redir >> ~/vim.log
	"echo 'KmarekUiMaybeVisual ' . mode(0) . ' ' . mode(1)
	"redir END
	if mode(0) == 'v' || mode(0) == 'V' || mode(0) == "\<C-V>"
		call KmarekUiEnterVisual()
	elseif mode(1) =~ "^ni"
		" ignore one-shot normal mode in insert mode
	else
		call KmarekUiLeaveVisual()
	endif
endfunction

" automatically fix &keymodel and &selection when entering/exiting visual mode
autocmd InsertEnter * silent! call KmarekUiMaybeVisual()
autocmd InsertLeave * silent! call KmarekUiMaybeVisual()
if has("patch-8.1.2044") " introduction of SafeState
autocmd SafeState * silent! call KmarekUiMaybeVisual()
endif
autocmd CursorMoved * silent! call KmarekUiMaybeVisual()



" The following three functions are my way of setting selection=exclusive
" during select-mode, specifically. These are only useful for gvim because
" gvim can programmatically switch between beam and block cursors.

function! KmarekUiEnterSelect()
	if ! exists("g:KmarekUiEnterSelect_selection")
		let g:KmarekUiEnterSelect_selection = &selection
	endif
	if g:kmarek_want_exclusive_selection
		set selection=exclusive
	endif
endfunction

function! KmarekUiLeaveSelect()
	if exists("g:KmarekUiEnterSelect_selection")
		let &selection=g:KmarekUiEnterSelect_selection
		unlet g:KmarekUiEnterSelect_selection
	endif
endfunction

function! KmarekUiMaybeSelect()
	"redir >> ~/vim.log
	"echo 'KmarekUiMaybeSelect ' . mode(0) . ' ' . mode(1)
	"redir END
	if mode(0) == 's'
		call KmarekUiEnterSelect()
	elseif mode(1) =~ "^ni"
		" ignore one-shot normal mode in insert mode
	else
		call KmarekUiLeaveSelect()
	endif
endfunction

" automatically fix &selection when entering/exiting select mode
autocmd InsertEnter * silent! call KmarekUiMaybeSelect()
autocmd InsertLeave * silent! call KmarekUiMaybeSelect()
if has("patch-8.1.2044") " introduction of SafeState
autocmd SafeState * silent! call KmarekUiMaybeSelect()
endif
autocmd CursorMoved * silent! call KmarekUiMaybeSelect()



" Setup the "Retab" command to fix leading indentation "my" way
"
" See: https://stackoverflow.com/questions/5172137/vim-retab-spaces-at-the-beginning-of-lines-only/5173322#5173322

"autocmd BufWritePre * :RetabIndents
command! -range Retab call Retab(<line1>,<line2>)

function! Retab(line1,line2)
	let l:saved_view = winsaveview()

	" use the `unexpand` program
	execute a:line1.",".a:line2.'!unexpand --first-only -t'.&ts

	call winrestview(l:saved_view)
endfunction


" command to reduce terminal I/O, for slow connections

function! Slow()
	set noruler noshowcmd noshowmode nottyfast
	set nohlsearch nospell
	syntax off
	highlight clear
	set t_Co=0
	set cpoptions+=v$
endfunction

command! Slow call Slow()

function Words()
	set laststatus=2 statusline=%{wordcount().words}\ words
endfunction

command! Words call Words()
