set nohlsearch
set ts=4

set listchars=eol:¶,trail:·,space:·,tab:»\ ,nbsp:%
highlight SpecialKey ctermfg=grey guifg=grey70
highlight NonText ctermfg=grey guifg=grey70

"" Show trailing whitepace and spaces before a tab:
"highlight ExtraWhitespace ctermbg=red guibg=red
"autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

let c_space_errors = 1
let java_space_errors = 1
