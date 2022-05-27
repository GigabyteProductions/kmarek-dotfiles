"colorscheme industry
colorscheme default
"set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar

" The following two functions are my way of using selection=exclusive
" for select-mode in gvim, specifically. See map commands, below.

function! KmarekGuiEnterSelect()
	if ! exists("g:KmarekGuiEnterSelect_selection")
		let g:KmarekGuiEnterSelect_selection = &selection
	endif
	set selection=exclusive
endfunction

function! KmarekGuiLeaveSelect()
	if exists("g:KmarekGuiEnterSelect_selection")
		let &selection=g:KmarekGuiEnterSelect_selection
		unlet g:KmarekGuiEnterSelect_selection
	endif
endfunction

" restore &selection when going back into plain normal mode
autocmd InsertLeave * if mode(1) == "n" | call KmarekGuiLeaveSelect() | endif

if has("gui_running")

	" TODO: update ctrl/shift-insert shortcuts

	" copy
    map  <silent>  <C-Insert>  "+y
    imap <silent>  <C-Insert>  <Esc>"+ya
	" paste
    map  <silent>  <S-Insert>  "+p
    imap <silent>  <S-Insert>  <Esc>"+pa

	"
	" BEGIN select mode customization
	"

	" The following mappings make shift-arrows and shift-home/end behave
	" line they do on a typical GUI text editor, while allowing for
	" selection=inclusive to be used for visual-mode.

	" TODO: Use autocmd ModeChanged if available
	"       (this would allow for similar behavior with selectmode=mouse)

	" TODO: Why do these not work in evim?

	" shift-arrows from normal mode
	nnoremap <silent> <s-up> :call KmarekGuiEnterSelect()<cr>gh<up>
	nnoremap <silent> <s-down> :call KmarekGuiEnterSelect()<cr>gh<down>
	nnoremap <silent> <s-left> :call KmarekGuiEnterSelect()<cr>gh<left>
	nnoremap <silent> <s-right> :call KmarekGuiEnterSelect()<cr>gh<right>
	nnoremap <silent> <s-home> :call KmarekGuiEnterSelect()<cr>gh<home>
	nnoremap <silent> <s-end> :call KmarekGuiEnterSelect()<cr>gh<end>

	" shift-arrows from insert mode
	inoremap <silent> <s-up> <C-O>:call KmarekGuiEnterSelect()<cr><c-o>gh<up>
	inoremap <silent> <s-down> <C-O>:call KmarekGuiEnterSelect()<cr><c-o>gh<down>
	inoremap <silent> <s-left> <C-O>:call KmarekGuiEnterSelect()<cr><c-o>gh<left>
	inoremap <silent> <s-right> <C-O>:call KmarekGuiEnterSelect()<cr><c-o>gh<right>
	inoremap <silent> <s-home> <C-O>:call KmarekGuiEnterSelect()<cr><c-o>gh<home>
	inoremap <silent> <s-end> <C-O>:call KmarekGuiEnterSelect()<cr><c-o>gh<end>

	" explicitly entering select mode from visual
	vnoremap <silent> <c-g> <esc>:call KmarekGuiEnterSelect()<cr>gv<c-g>

	" must continue to use shift key when continuing to select
	snoremap <silent> <s-up> <up>
	snoremap <silent> <s-down> <down>
	snoremap <silent> <s-left> <left>
	snoremap <silent> <s-right> <right>
	snoremap <silent> <s-home> <home>
	snoremap <silent> <s-end> <end>

	" go to insert mode when backspacing from plain select mode
	snoremap <silent> <bs> <bs>i

	" normal arrow keys leaves select mode and restores selection setting
	snoremap <silent> <up> <esc>:call KmarekGuiLeaveSelect()<cr><up>
	snoremap <silent> <down> <esc>:call KmarekGuiLeaveSelect()<cr><down>
	snoremap <silent> <left> <esc>:call KmarekGuiLeaveSelect()<cr><left>
	snoremap <silent> <right> <esc>:call KmarekGuiLeaveSelect()<cr><right>
	snoremap <silent> <home> <esc>:call KmarekGuiLeaveSelect()<cr><home>
	snoremap <silent> <end> <esc>:call KmarekGuiLeaveSelect()<cr><end>

	" restore selection setting when leaving
	snoremap <silent> <esc> <esc>:call KmarekGuiLeaveSelect()<cr>
	snoremap <silent> <c-o> <esc>:call KmarekGuiLeaveSelect()<cr>gv
	snoremap <silent> <c-g> <esc>:call KmarekGuiLeaveSelect()<cr>gv

	" use select-mode instead of visual-mode when highligting with mouse
	set selectmode=mouse

	"
	" END select mode customization
	"

	" restore cursor position when leaving insert mode
	" (don't move left by one)
	inoremap <silent> <esc> <esc>:normal! `^<cr>

	" allow the cursor to remain at the end of a line when leaving
	" insert mode
	set virtualedit=onemore

	" allow wrapped line navigation like GUIs usually do
	set whichwrap=b,s,<,>

	" ctrl-v paste in insert mode
    exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']

	" ctrl-v paste over a selection
    snoremap <C-V> <bs>:call KmarekGuiLeaveSelect()<cr>i<C-\><C-O>"+gP

	" don't make ctrl-c leave insert mode
	inoremap <C-C> <nop>

	" ctrl-c copy a selection, keep selection
	snoremap <C-C> <c-o>"+ygv<c-g>

	" map ctrl-L like evim does in case I keep mixing it up...
	imap <C-L> <esc>
	nnoremap <C-L> <nop>

	" CTRL-Z is Undo; not in cmdline though
	noremap <C-Z> u
	inoremap <C-Z> <C-O>u

	" CTRL-Y is Redo (although not repeat); not in cmdline though
	noremap <C-Y> <C-R>
	inoremap <C-Y> <C-O><C-R>

	" ctrl-shift-z is redo, in case I mix my GUI shortcuts up...
	noremap <C-S-Z> <C-R>
	inoremap <C-S-Z> <C-O><C-R>
endif


"
" BEGIN ctrl-shift-c and ctrl-shift-v shortcuts
"

" the following bits were taken from mswin.vim, but with <C-C> and
" <C-V> corrected to <C-S-C> and <C-S-V>

if has("clipboard")
    " CTRL-C and CTRL-Insert are Copy
    " TODO: Why doesn't visual-mode C-S-C work in gvim?
    "       (it works in select-mode)
    vnoremap <C-S-C> "+y

    " CTRL-V and SHIFT-Insert are Paste
    map <C-S-V>		"+gP

    cmap <C-S-V>		<C-R>+
endif


" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
" Use CTRL-G u to have CTRL-Z only undo the paste.

if 1
    exe 'inoremap <script> <C-S-V> <C-G>u' . paste#paste_cmd['i']
    exe 'vnoremap <script> <C-S-V> ' . paste#paste_cmd['v']
endif

"
" END ctrl-shift-c and ctrl-shift-v shortcuts
"

" gvim will match the size of the parent process's tty
" but I don't want gvim to do that
set columns=80 lines=24

" sloppily workaround a bug in gvim/evim where "-- INSERT --" is not
" shown at first when starting in insert mode
autocmd InsertEnter * ++once call feedkeys("\<esc>`^i")
