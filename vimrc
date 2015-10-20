" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible
set autoread "reload files changed outside vim
set autowrite     " Automatically :write before running commands
set backspace=2   " Backspace deletes like most programs in insert mode
set history=50
set hls
set ignorecase
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set nobackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set nowritebackup
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set smartcase
set nowrap " don't wrap lines
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
set number
set numberwidth=5
set textwidth=80 " Make it obvious where 80 characters is
set colorcolumn=+1 " Make it obvious where 80 characters is
set splitbelow " Open new split panes to right and bottom, which feels more natural
set splitright " Open new split panes to right and bottom, which feels more natural

" autosave on focus out
:au FocusLost * :wa

" Leader
let mapleader = ","

"strip trailing whitespace on save for certain files
"(add more file types seperated by commas)
autocmd FileType ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

" Colorscheme
syntax enable
set background=dark
colorscheme molokai
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Cucumber navigation commands
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Highlight Ruby files
  autocmd BufRead,BufNewFile *.jbuilder set filetype=ruby
  autocmd BufRead,BufNewFile *.thor set filetype=ruby
  autocmd BufRead,BufNewFile *.god set filetype=ruby
  autocmd BufRead,BufNewFile Gemfile* set filetype=ruby
  autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby
  autocmd BufRead,BufNewFile soloistrc set filetype=ruby
augroup END

" Display extra whitespace
if has("gui_running")
  set listchars=trail:·
else
  set listchars=tab:»\ ,trail:~,nbsp:·
endif

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" vim-rspec mappings
nnoremap <Leader>c :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>a :call RunAllSpecs()<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

"fast saving
nnoremap <leader>w :w!<cr>

"alt-ruby.vim fast file toggling
nnoremap <leader>at :AlternateToggle<cr>
nnoremap <leader>av :AlternateVerticalSplit<cr>
nnoremap <leader>as :AlternateHorizontalSplit<cr>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" copy current filename into system clipboard - mnemonic: (c)urrent(f)ilename
" this is helpful to paste someone the path you're looking at
nnoremap <silent> <leader>cf :let @* = expand("%:~")<CR>
nnoremap <silent> <leader>cn :let @* = expand("%:t")<CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Disable highlight when <leader><space> is pressed
nnoremap <leader><space> :noh<cr>

" NERDTree mappings
nnoremap \ :NERDTreeToggle<CR>
nnoremap <bar> :NERDTreeFind<CR> " aka shift+\

" CtrlP mappings
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>m :CtrlPMRU<CR>
nnoremap <leader>b :CtrlPBuffer<CR>

" use jk instead of escape
inoremap jk <esc>

" NERDCommenter mappings to comment/uncomment lines
map <leader>/   <plug>NERDCommenterToggle
map <D-/>       <plug>NERDCommenterToggle
imap <D-/>      <Esc><plug>NERDCommenterToggle i

" Git blame
map <leader>g   :Gblame<CR>

" RSpec.vim mappings
map <leader>RT :call RunCurrentSpecFile()<CR>
map <leader>RS :call RunNearestSpec()<CR>
map <leader>RL :call RunLastSpec()<CR>
map <leader>RA :call RunAllSpecs()<CR>

" ctags: open definition in a new vertical split
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" configure vim-rspec to work with tmux and tslime
let g:rspec_runner = "os_x_iterm"
let g:rspec_command = 'call Send_to_Tmux("bundle exec rspec {spec}\n")'

" change default NERDTree window width
let g:NERDTreeWinSize = 50

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
