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

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
match ExtraWhitespace /\s\+$\| \+\ze\t/

" TODO: check VIM version
let c_space_errors = 1
let java_space_errors = 1

" TODO: check VIM version
let g:python_recommended_style = 0

set tabpagemax=100
