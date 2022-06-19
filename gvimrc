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



if 0
" The following three functions are my way of setting selection=exclusive
" during select-mode, specifically. These are only useful for gvim because
" gvim can programmatically switch between beam and block cursors.

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

function! KmarekGuiMaybeSelect()
	"redir >> ~/vim.log
	"echo 'KmarekGuiMaybeSelect ' . mode(0) . ' ' . mode(1)
	"redir END
	if mode(0) == 's'
		call KmarekGuiEnterSelect()
	elseif mode(1) =~ "^ni"
		" ignore one-shot normal mode in insert mode
	else
		call KmarekGuiLeaveSelect()
	endif
endfunction

" automatically fix &selection when entering/exiting select mode
autocmd InsertEnter * silent! call KmarekGuiMaybeSelect()
autocmd InsertLeave * silent! call KmarekGuiMaybeSelect()
autocmd SafeState * silent! call KmarekGuiMaybeSelect()
autocmd CursorMoved * silent! call KmarekGuiMaybeSelect()
endif " 0
