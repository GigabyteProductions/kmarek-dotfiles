scriptencoding utf-8

set nohlsearch
set noincsearch
set ts=4

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

"" Show trailing whitepace and spaces before a tab:
"highlight ExtraWhitespace ctermbg=red guibg=red
"autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

let c_space_errors = 1
let java_space_errors = 1
