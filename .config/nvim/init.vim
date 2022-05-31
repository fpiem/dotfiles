" TODO: properly configure coc
set hidden
set termguicolors

set tabstop=4
set shiftwidth=4

set expandtab  " convert tabs to spaces, more convenient for python
set autoindent

set mouse=a  " Make the mouse work in all modes

set ignorecase smartcase

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Line numbers
set number
highlight LineNr ctermfg=Gray
set relativenumber

set foldmethod=marker
set nofoldenable

" When in a comment and pressing <CR>, do not autocomment the next line
set fo-=ro
autocmd BufNewFile,BufRead,FileType,OptionSet * set formatoptions-=cro
autocmd BufNewFile,BufRead,FileType,OptionSet * setlocal formatoptions-=cro

" Use comma as leader (space is used by whichkey)
let g:mapleader = "," " map leader to comma

let g:camelcasemotion_key = '<leader>'

" Make vim-sneak respect nvim's case sentitiveness
let g:sneak#use_ic_scs = 1

" {{{ functions
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [],'for': [] })
endfunction

function! ToggleRelativeNumbers()
    if (&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunction
" }}}

" {{{ Plugins
call plug#begin('~/local/share/nvim/plugged')
Plug 'akinsho/toggleterm.nvim'
Plug 'bkad/CamelCaseMotion'  " leader + motion moves over camel/snake case words
Plug 'christoomey/vim-sort-motion'  " gs motion to sort
Plug 'christoomey/vim-system-copy'  " cp and cv motions to copy/paste from the system clipboard
Plug 'ggandor/lightspeed.nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'jeetsukumaran/vim-pythonsense'  " text objects for Python development
Plug 'jiangmiao/auto-pairs'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-line'  " line text object defined by 'l'
Plug 'kana/vim-textobj-function'  " function text object defined by 'f'
Plug 'kana/vim-textobj-user'  " used by other plugins to define custom text objects
Plug 'Konfekt/vim-CtrlXA'
Plug 'machakann/vim-highlightedyank'
Plug 'machakann/vim-swap'
Plug 'matze/vim-move'
Plug 'michaeljsmith/vim-indent-object'  " indent text object
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'rhysd/clever-f.vim'
Plug 'sainnhe/sonokai'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'  " makes Ctrl+A and Ctrl+X work on dates
Plug 'tpope/vim-surround'
Plug 'tweekmonster/braceless.vim'  " text object and motion support for braceless languages such as Python
Plug 'unblevable/quick-scope'
Plug 'vim-scripts/ReplaceWithRegister'  " replace text with register contents without visual mode
Plug 'wellle/targets.vim'

" PyCharm integration
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'beeender/Comrade'

" Use regular easymotion when in Vim mode
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" Use VSCode easymotion when in VSCode
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })

" Plugins that should not be activated if running in VSCode
" Using Cond instead of an if block, as in regular Vim Plug will try to remove unused packages
Plug 'airblade/vim-gitgutter', Cond(!exists('g:vscode'))
Plug 'kien/ctrlp.vim', Cond(!exists('g:vscode'))
" Plug 'TaDaa/vimade', Cond(!exists('g:vscode'))   " Fade inactive windows
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree' |
    \ Plug 'Xuyuanp/nerdtree-git-plugin' |
    \ Plug 'ryanoasis/vim-devicons', Cond(!exists('g:vscode'))
Plug 'itchyny/lightline.vim', Cond(!exists('g:vscode'))
" vim-trailing-whitespace acts weird in VSCode
Plug 'bronson/vim-trailing-whitespace', Cond(!exists('g:vscode'))
call plug#end()

" Allows vim-matchup to leverage treesitting syntax
lua <<EOF
require'nvim-treesitter.configs'.setup {
  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
  },
}
EOF
" }}}

" {{{ VSCode integration
if exists('g:vscode')
    nnoremap <silent> o <Cmd>call VSCodeNotify('editor.action.insertLineAfter')<CR>i
    nnoremap <silent> O <Cmd>call VSCodeNotify('editor.action.insertLineBefore')<CR>i

    " Navigate through VSCode windows as in Vim
    nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
    xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

    nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
    xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>

    function! s:manageEditorSize(...)
        let count = a:1
        let to = a:2
        for i in range(1, count ? count : 1)
            call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
        endfor
    endfunction

    function! s:vscodeCommentary(...) abort
        if !a:0
            let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
            return 'g@'
        elseif a:0 > 1
            let [line1, line2] = [a:1, a:2]
        else
            let [line1, line2] = [line("'["), line("']")]
        endif

        call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
    endfunction

    function! s:openVSCodeCommandsInVisualMode()
        normal! gv
        let visualmode = visualmode()
        if visualmode == "V"
            let startLine = line("v")
            let endLine = line(".")
            call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
        else
            let startPos = getpos("v")
            let endPos = getpos(".")
            call VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
        endif
    endfunction

    function! s:openWhichKeyInVisualMode()
        normal! gv
        let visualmode = visualmode()
        if visualmode == "V"
            let startLine = line("v")
            let endLine = line(".")
            call VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
        else
            let startPos = getpos("v")
            let endPos = getpos(".")
            call VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
        endif
    endfunction

    nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>

    " Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
    xnoremap <expr> <C-/> <SID>vscodeCommentary()
    nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'

    nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

    nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
    xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>

    xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>

    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine

    " Use tab to cycle through buffers in the same group
    " NOTE: This was done via vscode keybinds, to avoid problems with windows such as
    " the settings UI, which steals focus
    " nmap <Tab> :gt<CR>
    " nmap <S-Tab> :gT<CR>

    " Test - changing remote button color based on NeoVim mode
    " ! Waiting for neovim to support the ModeChanged autocmd event
    " autocmd InsertEnter * :call VSCodeNotify('settings.cycle.neovimInsertModeColor')
    " autocmd InsertLeave * :call VSCodeNotify('settings.cycle.neovimNormalModeColor')
    " nnoremap v :call VSCodeNotify('settings.cycle.neovimVisualModeColor')<CR>v

endif
" }}}

if !exists('g:vscode')
    " Fade non-focused splits
    let g:vimade = {}
    let g:vimade.fadelevel = 0.78
    let g:vimade.enablesigns = 0
endif

" {{{ CoC
let g:coc_node_path = '/home/francesco/.nvm/versions/node/v17.6.0/bin/node'
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-pyright']
" }}}

" {{{ easymotion
" map m <Plug>(easymotion-bd-w)
" map M <Plug>(easymotion-bd-jk)
" map & <Plug>(easymotion-bd-f)
" }}}

" {{{ toggleterm
lua << EOF
require("toggleterm").setup{
    size = 20,
    open_mapping = [[<C-T>]]  -- TODO: kind of an awkward shortcut to hit, find a better one
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', 'kj', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
end
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
EOF
" }}}

" {{{ theming
syntax on

let g:sonokai_style = 'default'
let g:sonokai_enable_italic = 1
colorscheme sonokai

let g:airline_powerline_fonts = 1
let g:lightline = { 'colorscheme': 'sonokai' }

" Set Vim's background color to that of the terminal
" Mostly done for Hyper compatibility
" Needs terminal and vim themes to be similar
highlight Normal guibg=none guifg=none
highlight EndOfBuffer guibg=none guifg=none
" }}}

" {{{ nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <leader>t :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" }}}

" {{{ maps

" Disable arrow keys - IT'S FOR YOUR OWN GOOD
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>

" Ctrl + D: duplicate line
nnoremap <C-d> yyp
inoremap <C-d> <ESC>yypi

" Use J and K to move between paragraphs
nnoremap J }
vnoremap J }
nnoremap K {
vnoremap K {

" Use H and L to move to the beginning/end of a line in normal mode
noremap H ^
noremap L $

" S to 'Stamp' yanked word over current word
" nmap S griw

" Navigate between panes without Ctrl + w
if !exists('g:vscode')
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>
endif

" Ctrl + backspace to delete the previous word in insert mode
imap <C-BS> <C-W>

" More convenient way of commenting a single line with vim-commentary
nmap gl gcc

" Make Y yank to end of line (without <CR>) to make it more consistent with C and D
nnoremap Y y$

" Swap colon and semicolon, avoid chording shift when entering command mode
nnoremap ; :
nnoremap : ;

" vim-fanfingtastic replaces ; with a custom function to support multiline
" since we want to swap ; and :, we need to explicitly map : to ffts's ;-equivalent
nmap : <Plug>fanfingtastic_;

" Sometimes absolute line numbers are useful => set up binding
" to toggle between relative and absolute
noremap <leader>l :call ToggleRelativeNumbers()<CR>

" Prepend leader key to fold commands (since we're using z for vim-sneak)
nnoremap <silent> <leader>za za
nnoremap <silent> <leader>zc zc
nnoremap <silent> <leader>zd zd
nnoremap <silent> <leader>zf zf
nnoremap <silent> <leader>zo zo
" }}}

" {{{ vim-sneak
nmap m <Plug>Sneak_s
nmap M <Plug>Sneak_S
let g:sneak#s_next = 1
" }}}

" {{{ vim-swap
" Override the default vim-swap keybinds (as I'd rather use
" `gs` for the sort motion)
let g:swap_no_default_key_mappings = 1
nmap g< <Plug>(swap-prev)
nmap g> <Plug>(swap-next)
" }}}

" {{{ dashboard
" TODO: these bindings cause a delay when calling <leader>t , which is the NerdTree toggle
let g:dashboard_default_executive ='telescope'
" nmap <Leader>ss :<C-u>SessionSave<CR>
" nmap <Leader>sl :<C-u>SessionLoad<CR>
" nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
" nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
" nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
" nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
" nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
" nnoremap <silent> <Leader>cn :DashboardNewFile<CR>

" TODO: move this to a separate file for the love of god
let g:dashboard_custom_header = [
\ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
\ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
\ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
\ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
\ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
\ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
\]
" }}}
