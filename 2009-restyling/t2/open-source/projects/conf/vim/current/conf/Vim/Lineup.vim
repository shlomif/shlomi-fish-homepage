" Author:       Gergely Kontra <kgergely@mcl.hu>
" Version:      0.1
" Description:  A simple text aligner
" Installation: Drop it into your plugin directory
"
" Usage:
"    If you want to lineup eg. your declarations, just select them
"    visually, press space, then =
"
"    If you want more precise lineup, then press shift-space, and specify your
"    regexp
"
"    There are 2 commands defined, to make life easier
"    So you can write
"      :'<,'>Lineup =
"        to align your definitions and
"      :'<,'>LineupRE \S\+\s\+\zs.
"        to lineup the second words.
"    This approach is better to define mappings
"
" History:
"    0.1: Initial release
fu! <SID>Lineup(what,...)
  " get the longest match
  let max = -1
  let i=a:firstline | while i<=a:lastline
    if a:0 | let idx=match(getline(i),a:what)
    else | let idx=stridx(getline(i),a:what)
    endif
    if idx > max | let max = idx | endif
    let i = i + 1
  endw

  if max <= 0 | echo 'Nothing to align' | return | endif

  "align other lines
  let i=a:firstline
  while i<=a:lastline
    let curline = getline(i)
    if a:0
      let mat = match(getline(i),a:what)
    else
      let mat = stridx(getline(i),a:what)
    endif
    if mat != -1
      let res = strpart(curline,0,mat)
      let j = mat
      while j < max
	let j = j + 1
	let res = res .' '
      endw
      let res = res . strpart(curline,mat)
      call setline(i,res)
    endif
    let i = i + 1
  endw
endf



"Damned ranges, we must write functions...
fu! <SID>LineupPrompt() range
  echo 'Enter char to align!' | let c= nr2char(getchar())
  exe a:firstline.','.a:lastline.'call Lineup(c)'
endf
vmap <Space> :call <SID>LineupPrompt()<CR>

fu! <SID>LineupREPrompt() range
  let re=inputdialog('Enter RE to lineup!')
  exe a:firstline.','.a:lastline."call Lineup(re)"
endf
vmap <S-Space> :call <SID>LineupREPrompt()<CR>

com! -range -nargs=* Lineup <line1>,<line2>call <SID>Lineup(<q-args>)
com! -range -nargs=* LineupRE <line1>,<line2>call <SID>Lineup(<q-args>,1)
