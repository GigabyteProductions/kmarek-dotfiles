colorscheme industry
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
