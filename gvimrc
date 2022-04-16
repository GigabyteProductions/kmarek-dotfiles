"colorscheme industry
colorscheme default
"set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar

if has("gui_running")
	" copy
    map  <silent>  <C-Insert>  "+y
    imap <silent>  <C-Insert>  <Esc>"+ya
	" paste
    map  <silent>  <S-Insert>  "+p
    imap <silent>  <S-Insert>  <Esc>"+pa
endif


"
" BEGIN ctrl-shift-c and ctrl-shift-v shortcuts
"

" the following bits were taken from mswin.vim, but with <C-C> and
" <C-V> corrected to <C-S-C> and <C-S-V>

if has("clipboard")
    " CTRL-C and CTRL-Insert are Copy
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
