call plug#begin('~/.local/share/nvim/plugged')

" Syntax
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'
Plug 'hashivim/vim-terraform'
Plug 'roryokane/detectindent'
Plug 'mhartington/oceanic-next'
Plug 'davidhalter/jedi-vim'
" File system
Plug 'scrooloose/nerdtree'

" Base64
Plug 'christianrondeau/vim-base64'

" Debug
Plug 'dstein64/vim-startuptime'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

" Apply theme into nvim
syntax enable
colorscheme OceanicNext

" Change leader to ,
let mapleader = ','

" NERDCommenter settings
let g:NERDCommentEmptyLines = 1
let g:NERDCompactSexyComs = 1
" leader space instead of leader c space to toggle comment
map <leader><space> <leader>c<space>

" NERDTree settings
nnoremap ² :NERDTreeToggle<CR>
nnoremap <M-²> :NERDTreeFind<CR>
let g:NERDTreeQuitOnOpen=1
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}
let NERDTreeRespectWildIgnore=1

" general config
set number
set cursorline
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set autoread
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*

" tab navigation
map <M-Left> :tabprevious<CR>
map <M-Right> :tabnext<CR>
map <C-N> :tabnew<CR>
map <C-S> :w<CR>
map <C-W> :q<CR>

function! BeautifyJSON()
    %!python -m json.tool
endfunction

command! BJ call BeautifyJSON()

function! ToTupleFunction() range
    silent execute a:firstline . "," . a:lastline . "s/^/'/"
    silent execute a:firstline . "," . a:lastline . "s/$/',/"
    silent execute a:firstline . "," . a:lastline . "join"
    silent execute "normal I("
    silent execute "normal $xa)"
    silent execute "normal ggVGYY"
endfunction

command! -range TT <line1>,<line2> call ToTupleFunction()

set nobackup
set nowritebackup


augroup DetectIndent
   autocmd!
   autocmd BufReadPost *  DetectIndent
augroup END

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

set clipboard+=unnamedplus
