" =============================================================================
"                               General settings
" =============================================================================

set nocompatible        " iMproved.
set hidden              " Allow for putting dirty buffers in background.
set ignorecase          " Case-insensitive search
set smartcase           " Override ignorecase when searching uppercase.
set modeline            " Enables modelines.
set wildmode=longest,list:full " How to complete <Tab> matches.
"set tildeop             " Makes ~ an operator.
set virtualedit=block   " Support moving in empty space in block mode.

" Low priority for these files in tab-completion.
set suffixes+=.aux,.bbl,.blg,.dvi,.log,.pdf,.fdb_latexmk     " LaTeX
set suffixes+=.info,.out,.o,.lo

set viminfo='20,\"500

" No header when printing.
set printoptions+=header:0

scriptencoding utf-8

if has("spell")
  set spelllang=en,de,fr
  set spellfile=~/.vim/spellfile.add
endif

" =============================================================================
"                                   Styling
" =============================================================================

set background=dark     " Syntax highlighting for a dark terminal background.
set hlsearch            " Highlight search results.
set showbreak=…         " Highlight non-wrapped lines.
set showcmd             " Display incomplete command in bottom right corner.

if has('gui_running')
    set columns=80
    set lines=25
    set guioptions-=T   " Remove the toolbar.
    set guifont=MesloLGM\ Nerd\ Font:h12

    " Disable MacVim-specific Cmd/Alt key mappings.
    if has("gui_macvim")
      let macvim_skip_cmd_opt_movement = 1
    endif
endif

" Folding
if version >= 600
    set foldenable
    set foldmethod=marker
endif

" =============================================================================
"                                  Formatting
" =============================================================================

set formatoptions=tcrqn " See :h 'fo-table for a detailed explanation.
set nojoinspaces        " Don't insert two spaces when joining after [.?!].
set copyindent          " Copy the structure of existing indentation
set expandtab           " Expand tabs to spaces.
set tabstop=2           " number of spaces for a <Tab>.
"set softtabstop=2       " Number of spaces that a <Tab> counts for.
set shiftwidth=2        " Tab indention
set textwidth=79        " Text width

" Indentation Tweaks.
" l1  = align with case label isntead of steatement after it in the same line.
" N-s = Do not indent namespaces.
" t0  = do not indent a function's return type declaration.
" (0  = line up with next non-white character after unclosed parentheses...
" W2  = ...but not if the last character in the line is an open parenthesis.
set cinoptions=l1,N-s,t0,(0,W2

" =============================================================================
"                                 Key Bindings
" =============================================================================

let mapleader = ' '

" vv to generate new vertical split
nnoremap <silent> vv <C-w>v
nnoremap <silent> v2 :set columns=161<CR><C-w>v
nnoremap <silent> v3 :set columns=242<CR><C-w>v<C-w>v

" Clear last search highlighting
nnoremap <CR> :noh<CR><CR>

" Toggle list mode (display unprintable characters).
nnoremap <F11> :set list!<CR>

" Toggle paste mode.
set pastetoggle=<F12>

" Quicker navigation for non-wrapped lines.
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

" Helper function to preserve history and cursor position.
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business.
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Remove trailing whitespace.
nmap <Leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

" Indent entire file.
nmap <Leader>= :call Preserve("normal gg=G")<CR>

" Highlight text last pasted.
nnoremap <expr> <Leader>p '`[' . strpart(getregtype(), 0, 1) . '`]'

" Reverse letters in a word, e.g, "foo" -> "oof".
vnoremap <silent> <Leader>r :<C-U>let old_reg_a=@a<CR>
 \:let old_reg=@"<CR>
 \gv"ay
 \:let @a=substitute(@a, '.\(.*\)\@=',
 \ '\=@a[strlen(submatch(1))]', 'g')<CR>
 \gvc<C-R>a<Esc>
 \:let @a=old_reg_a<CR>
 \:let @"=old_reg<CR>

" =============================================================================
"                                    Plugins
" =============================================================================

" Install Plug if not present.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'lervag/vimtex'
Plug 'rhysd/vim-clang-format'
Plug 'rstacruz/sparkup'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'jalvesaq/Nvim-R'
call plug#end()

" -- Lightline ---------------------------------------------------------------

" Check :h lightline-problem-9 for font issues.
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filetype': 'IconizedFiletype',
      \   'fileformat': 'IconizedFileformat'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }


function! IconizedFiletype()
  if winwidth(0) > 70
    if strlen(&filetype)
      return &filetype . ' ' . WebDevIconsGetFileTypeSymbol()
    else
      return 'no ft'
    endif
  else
    return ''
  endif
endfunction

function! IconizedFileformat()
  if winwidth(0) > 70
    return &fileformat . ' ' . WebDevIconsGetFileFormatSymbol()
  else
    return ''
  endif
endfunction

function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "\ue0a2"
  else
    return ""
  endif
endfunction

function! LightlineFugitive()
  if exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? "\ue0a0 ".branch : ''
  endif
  return ''
endfunction

" -- vimtex ------------------------------------------------------------------

let g:vimtex_view_method = 'skim'

" -- Tmuxline ----------------------------------------------------------------

let g:tmuxline_theme = 'lightline_insert'
" We use :TmuxlineSnapshot to generate the file .tmux/tmuxline.conf.
" Thereafter, we need to do a bit of patching to improve the integration of
" tmxu-mem-cpu-load.
let g:tmuxline_preset = {
  \'a'    : '#S',
  \'b'    : '#(whoami)',
  \'c'    : ['%Y-%m-%d', '%H:%M'],
  \'win'  : ['#I', '#W'],
  \'cwin' : ['#I', '#W'],
  \'x'    : '#(tmux-mem-cpu-load -q -g 5 -m 2 -i 2)',
  \'y'    : '#h'}

" -- Solarized colors --------------------------------------------------------

let g:solarized_menu = 0
let g:solarized_termtrans = 1
let g:solarized_contrast = 'high'
let g:solarized_hitrail = 1

if !has('gui_running')
  let g:solarized_termcolors = 256
end

colorscheme solarized

" -- Tmux Navigator ----------------------------------------------------------

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

" -- Vimux -------------------------------------------------------------------

" Combine VimuxZoomRunner and VimuxInspectRunner in one function.
function! VimuxZoomInspectRunner()
  if exists("g:VimuxRunnerIndex")
    call _VimuxTmux("select-"._VimuxRunnerType()." -t ".g:VimuxRunnerIndex)
    call _VimuxTmux("resize-pane -Z -t ".g:VimuxRunnerIndex)
    call _VimuxTmux("copy-mode")
  endif
endfunction

map <Leader>vc :VimuxPromptCommand<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vo :call VimuxOpenRunner()<CR>
map <Leader>vp :call VimuxSendKeys("C-p Enter")<CR>
map <Leader>vc :VimuxInterruptRunner<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxCloseRunner<CR>
map <Leader>vz :VimuxZoomRunner<CR>
map <Leader>vm :VimuxRunCommand("make")<CR>
map <Leader>vn :VimuxRunCommand("ninja")<CR>
map <Leader>v<Space> :call VimuxZoomInspectRunner()<CR>

" -- vim-dispatch ------------------------------------------------------------

" Build via make.
nmap <Leader>b :Make<CR>

" -- Nvim-R ------------------------------------------------------------------

" Make sure we can communicate with the plugin.
let R_in_buffer = 0
let R_applescript = 0
let R_tmux_split = 1
let R_min_editor_width = 42 "trigger vertical split

" Do not replace '_' with '<-'.
let R_assign = 0

" Use existing tmux.conf.
let R_notmuxconf = 1

" -- Clang Format ------------------------------------------------------------

map <Leader>f :ClangFormat<CR>

" =============================================================================
"                                Filetype Stuff
" =============================================================================

" R stuff
autocmd BufNewFile,BufRead *.[rRsS] set ft=r
autocmd BufRead *.R{out,history} set ft=r

autocmd BufRead,BufNewFile *.dox      set filetype=doxygen
autocmd BufRead,BufNewFile *.mail     set filetype=mail
autocmd BufRead,BufNewFile *.bro      set filetype=bro
autocmd BufRead,BufNewFile *.pac2     set filetype=ruby
autocmd BufRead,BufNewFile *.ll       set filetype=llvm
autocmd BufRead,BufNewFile *.kramdown set filetype=markdown
autocmd BufRead,BufNewFile Portfile   set filetype=tcl

" Respect (Br|D)oxygen comments.
autocmd FileType c,cpp set comments-=://
autocmd FileType c,cpp set comments+=:///
autocmd FileType c,cpp set comments+=://
autocmd FileType bro set comments-=:#
autocmd FileType bro set comments+=:##
autocmd FileType bro set comments+=:#
autocmd FileType bro set noexpandtab cino='>1s,f1s,{1s'
autocmd Filetype mail set sw=4 ts=4 tw=72
autocmd Filetype tex set iskeyword+=:

" Bro-specific coding style.
augroup BroProject
  autocmd FileType bro set noexpandtab cino='>1s,f1s,{1s'
  au BufRead,BufEnter ~/code/bro/**/*{cc,h} set noexpandtab cino='>1s,f1s,{1s'
augroup END

if has("spell")
  autocmd BufRead,BufNewFile *.dox  set spell
  autocmd Filetype mail             set spell
  autocmd Filetype tex              set spell
endif

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff <wouter@blub.net>
augroup encrypted
    autocmd!
    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg set bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt 2> /dev/null
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg set nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost  *.gpg u
augroup END

" vim: set fenc=utf-8 sw=2 sts=2 foldmethod=marker :