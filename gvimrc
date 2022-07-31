scriptencoding utf-8

"colorscheme industry
colorscheme default
"set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar

" gvim will match the size of the parent process's tty
" but I don't want gvim to do that
set columns=80 lines=24

if 0
" use exclusive selection "by default" for correct double-click selections
" (my hook in ~/.vimrc will automatically use inclusive for visual mode)
set selection=exclusive
endif " 0

" sloppily workaround a bug in gvim/evim where "-- INSERT --" is not
" shown at first when starting in insert mode
autocmd InsertEnter * ++once call feedkeys("\<c-\>\<c-n>`^i")
