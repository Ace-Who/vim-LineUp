" Change the 'cpoptions' option temporarily {{{
" Set to its Vim default value and restore it later.
" This is to enable line-continuation within this script.
" Refer to :help use-cpo-save.
let s:save_cpoptions = &cpoptions
set cpoptions&vim
" }}}

function! LineUp#On() "{{{
  if g:LineUp_On
    echohl Error
    echo 'LineUp is already on.'
    echohl NONE
    return
  endif
  augroup LineUp
    autocmd!
    " !!Note!! Undo and redo also change the text, triggering this autocmd,
    " which changes the effect of undo and BREAKS further REDO if making new
    " text changes. So we don't move lines in these cases.
    autocmd TextChanged,TextChangedI *
    \ if !s:isUndoRedo() | call s:move() | endif
    autocmd BufEnter,InsertLeave * call s:upMaxChangeNr()
  augroup END
  call s:upMaxChangeNr()
  call s:saveMapping() " Save mappings for later restoring.
  call s:setMapping()
  call s:markState(1)
endfunction "}}}

function! LineUp#Off() "{{{
  if !g:LineUp_On
    echohl Error
    echo 'LineUp is already off.'
    echohl NONE
    return
  endif
  augroup LineUp
    autocmd!
  augroup END
  call s:delMapping()
  call s:loadMapping() " Restore the mappings saved earlier.
  call s:markState(0)
endfunction "}}}

function! LineUp#Reverse() "{{{
  call s:reverse()
endfunction "}}}

function! s:isUndoRedo() "{{{
  return changenr() <= b:LineUp_MaxChangeNr
endfunction "}}}

function! s:move() "{{{
  if getline('.') =~ '^ *$' | return | endif  " Ignore blank lines
  " Remember the cursor position relative to current indent for restoring after
  " moving the line.
  let l:curpos = col('.') - indent('.')
  " Move upward
  while line('.') > 1
    let l:width = strdisplaywidth(getline('.'))
    let l:prevWidth = strdisplaywidth(getline(line('.') - 1))
    " Never moves across a blank line.
    if l:prevWidth == 0 | break | endif
    if !g:LineUp_Reverse
      if l:prevWidth > l:width | move-2 | else | break | endif
    else
      if l:prevWidth < l:width | move-2 | else | break | endif
    endif
  endwhile
  " Move downward
  while line('.') < line('$')
    let l:width = strdisplaywidth(getline('.'))
    let l:nextWidth = strdisplaywidth(getline(line('.') + 1))
    " Never moves across a blank line.
    if l:nextWidth == 0 | break | endif
    if !g:LineUp_Reverse
      if l:nextWidth < l:width | move+1 | else | break | endif
    else
      if l:nextWidth > l:width | move+1 | else | break | endif
    endif
  endwhile
  " Put cursor back on the same char it is on before moving.
  call cursor('.', l:curpos + indent('.'))
  " An ongoing change in Insert mode or Replace mode is not taken as a new
  " change if updating the 'b:LineUp_MaxChangeNr' during this time. To avoid
  " this, wait until it is done, i.e., the autocmd event 'InsertLeave' occurs.
  if mode() !~ '^[iR]'
    call s:upMaxChangeNr()
  endif
endfunction "}}}

function! s:opMove(type) "{{{
  '[,']center
endfunction "}}}

function! s:setMapping() "{{{

  " (1) In Insert mode with some kind of mapping for <CR> existing, Vim
  " doesn't update the value of line() and getline() after typing <CR>, making
  " the new lines ignored. So we have to unmap it.
  " silent! iunmap <CR> 

  " Update:
  " (2) For an unknown reason, inserting <CR> in some condition changes the
  " undo history. Seems a Vim's bug. The following mapping can avoid this.
  inoremap <CR> <C-G>u<CR>
  " Notice the following mapping brings the earliest bug(1) back again.
  " inoremap <CR> <C-\><C-O>i<CR>

  " <NL>, or <C-J>, has the same issue.
  inoremap <NL> <C-G>u<NL>

endfunction "}}}

function! s:delMapping() "{{{
endfunction "}}}

function! s:loadMapping() "{{{
  " This requires the 'SaveMapping' plugin
  " (https://github.com/Ace-Who/vim-MappingMem).
  if exists(':LoadMapping') == 2
    silent LoadMapping '<CR>', 'i', 'global'
  endif
endfunction "}}}

function! s:saveMapping() "{{{
  " This requires the 'SaveMapping' plugin
  " (https://github.com/Ace-Who/vim-MappingMem).
  if exists(':SaveMapping') == 2
    silent SaveMapping '<CR>', 'i', 'global'
  endif
endfunction "}}}

function! s:markState(state) "{{{
  unlockvar g:LineUp_On
  let g:LineUp_On = a:state
  lockvar g:LineUp_On
endfunction "}}}

function! s:reverse(...) "{{{
  unlockvar g:LineUp_Reverse
  if a:0
    let g:LineUp_Reverse = a:1
  else
    let g:LineUp_Reverse = !g:LineUp_Reverse
  endif
  lockvar g:LineUp_Reverse
endfunction "}}}

function! s:upMaxChangeNr() "{{{
  unlockvar b:LineUp_MaxChangeNr
  let l:undolist = split(execute('undolist'), "\n")
  let b:LineUp_MaxChangeNr = split(l:undolist[-1], ' \+')[0]
  lockvar b:LineUp_MaxChangeNr
endfunction "}}}

if !exists('g:LineUp_On') | call s:markState(0) | endif
if !exists('g:LineUp_Reverse') | call s:reverse(0) | endif

" Restore 'cpoptions' setting {{{
let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
" }}}
