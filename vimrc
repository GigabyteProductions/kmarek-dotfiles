scriptencoding utf-8

" explicitly enable vim/non-vi behavior
set nocompatible

" hide vim welcome screen
set shm+=I

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

" explicitly set selection=inclusive (this is the default)
" Note: this means the character *at* the cursor position is included
"
" See gvimrc for automatic switching to selection=exclusive for select
" mode (for vim GUI, only)
set selection=inclusive

" allow the cursor to remain at the end of a line when leaving insert mode
" (this is important for <c-o>"+gP at tne end of a line)
set virtualedit=onemore

" don't violate my explicit usage of tabs to appease the Python developers
" (this is also important to avoid mixing indentation in existing files)
" TODO: check VIM version
let g:python_recommended_style = 0

" enable some built-in whitespace error checks
" TODO: check VIM version
let c_space_errors = 1
let java_space_errors = 1

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
"       - <c-a> in insert mode will select all instead of repeating
"         previous insertion
"
"       - <c-z> will undo instead of putting vim in the background
"         use :call feedkeys("\<c-z>", 'n') to put vim in background)
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

" make left and right not cancel visual when keymodel=stopsel
" TODO: check for keymodel=stopsel
xnoremap <left> h
xnoremap <right> l

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

" select-all
" Note: these are character-wise rather than line-wise
nnoremap <c-a> gggh<c-o>G<c-o>$
inoremap <c-a> <c-o>gg<c-o>gh<c-o>G<c-o>$
xnoremap <c-a> ggoG$<c-g>
snoremap <c-a> <c-o>gg<c-o>o<c-o>G<c-o>$
if has('gui_running')
nnoremap <c-s-a> gggh<c-o>G<c-o>$
inoremap <c-s-a> <c-o>gg<c-o>gh<c-o>G<c-o>$
xnoremap <c-s-a> ggoG$<c-g>
snoremap <c-s-a> <c-o>gg<c-o>o<c-o>G<c-o>$
endif

" copy
" TODO: apply ctrl-c to smap and not xmap
"       (to allow ctrl-c to exit visual mode)
vnoremap <c-c> "+ygv
if has('gui_running')
vnoremap <c-s-c> "+ygv
vnoremap <c-insert> "+ygv
endif

" paste
"noremap <c-v> "+gP
snoremap <c-v> <c-o>"+gP
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
xnoremap <c-v> "+gP
snoremap <c-v> <c-o>"+gP
if has('gui_running')
inoremap <c-s-v> <c-g>u<c-o>"+gP
inoremap <s-insert> <c-g>u<c-o>"+gP
vnoremap <c-s-v> <c-o>"+gP
vnoremap <s-insert> <c-o>"+gP
endif

" undo
noremap <c-z> u
inoremap <c-z> <c-o>u

" redo
noremap <c-y> <c-r>
inoremap <c-y> <c-o><c-r>

" evim makes ctrl-l in insert mode go to normal mode
inoremap <c-l> <c-\><c-n>



" The following three functions are my way of clearing &keymodel
" when using visual mode, because I only want keymodel=stopsel for
" select mode.

function! KmarekUiEnterVisual()
	if ! exists("g:KmarekUiEnterVisual_keymodel")
		let g:KmarekUiEnterVisual_keymodel = &keymodel
	endif
	set keymodel=
endfunction

function! KmarekUiLeaveVisual()
	if exists("g:KmarekUiEnterVisual_keymodel")
		let &keymodel=g:KmarekUiEnterVisual_keymodel
		unlet g:KmarekUiEnterVisual_keymodel
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

" automatically fix &keymodel when entering/exiting visual mode
autocmd InsertEnter * silent! call KmarekUiMaybeVisual()
autocmd InsertLeave * silent! call KmarekUiMaybeVisual()
autocmd SafeState * silent! call KmarekUiMaybeVisual()
autocmd CursorMoved * silent! call KmarekUiMaybeVisual()


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
