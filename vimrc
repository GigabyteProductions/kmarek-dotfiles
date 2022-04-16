scriptencoding utf-8

set nohlsearch
set noincsearch
set ts=4
set sw=4

if has("patch-7.4.785") " introduction of fixeol
	set nofixeol
endif

if has("patch-7.4.710") " introduction of lcs-space
	set listchars=eol:¶,trail:·,space:·,tab:»\ ,nbsp:%
else
	set listchars=eol:¶,trail:·,tab:»\ ,nbsp:%
endif

highlight SpecialKey ctermfg=grey guifg=grey70
highlight NonText ctermfg=grey guifg=grey70

" functiton to setup my highlights
function! MyHighlights()

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

" TODO: check VIM version
let c_space_errors = 1
let java_space_errors = 1

" TODO: check VIM version
let g:python_recommended_style = 0

set tabpagemax=100

map <up>    gk
map <down>  gj
map <right> l
map <left>  h

" See: https://stackoverflow.com/questions/5172137/vim-retab-spaces-at-the-beginning-of-lines-only/5173322#5173322

"autocmd BufWritePre * :RetabIndents
command! -range Retab call Retab(<line1>,<line2>)

function! Retab(line1,line2)
	let l:saved_view = winsaveview()

	" Doesn't handle mixes of tabs and spaces well
	"execute a:line1.",".a:line2.'s@^\(\t*\)\(\ \{'.&ts.'\}\)\+@\=repeat("\t", len(submatch(2))/'.&ts.')@e'

	" My bash script
	"execute a:line1.",".a:line2.'!retab.sh '.&ts

	" use the `unexpand` program
	execute a:line1.",".a:line2.'!unexpand --first-only -t'.&ts

	call winrestview(l:saved_view)
endfunction
