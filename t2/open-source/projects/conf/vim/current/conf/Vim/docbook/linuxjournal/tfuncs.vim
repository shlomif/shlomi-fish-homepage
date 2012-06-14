" tfuncs.vim
"
" Tag related functions.


"**********************************************************

" Patterns for XML tags and for words.
let s:XMLTag="</\\{0,1}[^>]\\{1,}>"
let s:Word="</\\{0,1}[^>]\\{1,}>\\|[^ \\t]\\{1,}"


"**********************************************************
" Find start and end of tag if it exists surrounding position tpos.
" The arguments spos and epos should be strings with containing variable names.
" the return value is a string that can be executed to set the variable names.
function! FindTag(str, tpos, spos, epos)

	" Find beginning and end of tag.
	let st = match(a:str, s:XMLTag)
	let et = matchend(a:str, s:XMLTag)
	while st != -1  &&  et != -1  &&  et < a:tpos
		let st = match(a:str, s:XMLTag, et)
		let et = matchend(a:str, s:XMLTag, st)
	endwhile

	return "let " . a:spos . "=" . st . " | let " . a:epos . "=" . et
endfunction


"**********************************************************
" Find start and end of word if it exists surrounding position tpos.
" The arguments spos and epos should be strings with containing variable names.
" the return value is a string that can be executed to set the variable names.
function! FindWord(str, tpos, spos, epos)

	" Look for start and end of word.
	let sw = match(a:str, s:Word)
	let ew = matchend(a:str, s:Word)
	while sw != -1  &&  ew != -1  &&  ew < a:tpos
		let tsw = match(a:str, s:Word, ew)
		if tsw >= a:tpos
			break
		endif
		let sw = tsw
		let ew = matchend(a:str, s:Word, sw)
	endwhile

	return "let " . a:spos . "=" . sw . " | let " . a:epos . "=" . ew
endfunction


"**********************************************************
" If the cursor is positioned over a tag, delete it.
function! DeleteTag()
	let n = line(".")
	let c = col(".")
	let s = getline(n)

	" Find beginning and end of tag.
	execute FindTag(s, c, "st", "et")

	" Delete tag if cursor is on tag.
	if c > st  &&  c <= et
		let t = strpart(s, 0, st)
		let u = strpart(s, et)
		call setline(n, t.u)
		call cursor(n, st)
	else
		echo "Cursor not on a tag"
	endif
endfunction


"**********************************************************
" If the cursor is positioned over a tag, change it to a different tag.
function! ChangeTag(stag, etag)
	let n = line(".")
	let c = col(".")
	let s = getline(n)

	" Find beginning and end of tag.
	execute FindTag(s, c, "st", "et")

	" Change tag if cursor is on a tag.
	if c > st  &&  c <= et
		let t = strpart(s, 0, st)
		let u = strpart(s, et)
		let tag = a:stag
		if s[st+1] == '/'
			let tag = a:etag
		endif

		call setline(n, t.tag.u)
		call cursor(n, c)
	else
		echo "Cursor not on a tag"
	endif
endfunction


"**********************************************************
" Tag current word.
function! TagWord(stag, etag)
	let n = line(".")
	let c = col(".")-1
	let s = getline(n)

	" Look for start and end of word at cursor.
	execute FindWord(s, c, "sw", "ew")

	if c >= sw  &&  c < ew
		let t = strpart(s, 0, sw)
		let u = strpart(s, ew)
		let w = strpart(s, sw, ew-sw)
		let v = t . a:stag . w . a:etag . u
		call setline(n, v)
		call cursor(n, c + strlen(a:stag) + 3)
	else
		echo "Cursor not on a word"
	endif
endfunction


"**********************************************************
" Tag range.
function! TagRange(stag, etag) range
	if a:firstline == a:lastline
		let s = getline(a:firstline)
		let v = a:stag . s . a:etag
		call setline(a:firstline, v)
	else
		call append(a:lastline, a:stag)
		call append(a:firstline-1, a:etag)
	endif
endfunction


"**********************************************************
" If the cursor is on a tag, move it to the left by one word.
function! MoveTagLeft()
	let n = line(".")
	let c = col(".")
	let s = getline(n)

	" Find beginning and end of tag.
	execute FindTag(s, c, "st", "et")

	" If cursor is on a tag move it to the left of the preceding word.
	if c > st  &&  c <= et

		" Look for start and end of word preceding tag.
		execute FindWord(s, st, "sw", "ew")

		if ew > st
			let ew = st
		endif

		if sw != -1  &&  ew != -1  &&  ew > sw
			let t = strpart(s, 0, sw)		" upto word
			let u = strpart(s, sw, st-sw)		" word
			let v = strpart(s, st, et-st)		" tag
			let w = strpart(s, et)			" after tag
			call setline(n, t.v.u.w)
			call cursor(n, c-st+sw)
		else
			" Move tag to end of previous line.
			if n > 1
				let t = strpart(s, st, et-st)	" tag
				let u = strpart(s, et)		" after tag
				call setline(n, u)
				let s = getline(n-1)
				call setline(n-1, s.t)
				call cursor(n-1, strlen(s)+c-st+sw)
			else
				echo "No words to left of tag"
			endif
		endif
	else
		echo "Cursor not on tag"
	endif
endfunction


"**********************************************************
" If the cursor is on a tag, move it to the right by one word.
function! MoveTagRight()
	let n = line(".")
	let c = col(".")
	let s = getline(n)

	" Find beginning and end of tag.
	execute FindTag(s, c, "st", "et")

	" If cursor is on a tag move it to the right of the following word.
	if c > st  &&  c <= et

		" Look for start and end of word following tag.
		let sw = match(s, s:Word, et)
		let ew = matchend(s, s:Word, sw)

		if sw != -1  &&  ew != -1
			let t = strpart(s, 0, st)		" upto start of tag
			let u = strpart(s, st, et-st)		" tag
			let v = strpart(s, et, ew-et)		" word
			let w = strpart(s, ew)			" after word
			call setline(n, t.v.u.w)
			call cursor(n, c+ew-et)
		else
			" Move tag to beginning of next line.
			if n < line("$")
				let t = strpart(s, 0, st)	" upto start of tag
				let u = strpart(s, st)		" tag
				call setline(n, t)
				let s = getline(n+1)
				call setline(n+1, u.s)
				call cursor(n+1, c-st)
			else
				echo "No words to right of tag"
			endif
		endif
	else
		echo "Cursor not on tag"
	endif
endfunction

"**********************************************************
" If the cursor is on a tag, delete all whitespace to the left of it.
function! TightenTagLeft()
	let n = line(".")
	let c = col(".")
	let s = getline(n)

	" Find beginning and end of tag.
	execute FindTag(s, c, "st", "et")

	" If cursor is on a tag remove whitespace to the left.
	if c > st  &&  c <= et

		" Look for start and end of word preceding tag.
		execute FindWord(s, st, "sw", "ew")

		if ew > st
			let ew = st
		endif

		if sw != -1  &&  ew != -1  &&  ew > sw
			let t = strpart(s, 0, ew)		" to end of word
			let u = strpart(s, st)			" tag to end of line
			call setline(n, t.u)
			call cursor(n, c-st+ew)
		else
			" Delete preceding blank lines.
			if n > 1
				while n > 1  &&  match(getline(n-1), "^[ \\t]*$") != -1
					let n = n - 1
					execute n "delete"
				endwhile
			else
				echo "No whitespace to left of tag"
			endif
		endif
	else
		echo "Cursor not on tag"
	endif
endfunction


"**********************************************************
" If the cursor is on a tag, delete all whitespace to the right of it.
function! TightenTagRight()
	let n = line(".")
	let c = col(".")
	let s = getline(n)

	" Find beginning and end of tag.
	execute FindTag(s, c, "st", "et")

	" If cursor is on a tag move it to the right of the preceding word.
	if c > st  &&  c <= et

		" Look for start and end of word following tag.
		let sw = match(s, s:Word, et)
		let ew = matchend(s, s:Word, sw)

		if sw != -1  &&  ew != -1
			let t = strpart(s, 0, et)		" upto end of tag
			let u = strpart(s, sw)			" word to end of line
			call setline(n, t.u)
			call cursor(n, c)
		else
			" Delete following blank lines.
			if n < line("$")
				let n = n + 1
				while n < line("$")  &&  match(getline(n), "^[ \\t]*$") != -1
					execute n "delete"
				endwhile
			else
				echo "No whitespace to right of tag"
			endif
		endif
	else
		echo "Cursor not on tag"
	endif
endfunction


"**********************************************************
" If the cursor is on a tag, insert the argument string before it.
function! InsertStringLeftOfTag(str)
	let n = line(".")
	let c = col(".")
	let s = getline(n)

	" Find beginning and end of tag.
	execute FindTag(s, c, "st", "et")

	" See if cursor is on a tag.
	if c > st  &&  c <= et

		let t = strpart(s, 0, st)		" to start of tag
		let u = strpart(s, st)			" tag to end of line
		call setline(n, t.a:str.u)
		call cursor(n, c+strlen(a:str))
	else
		echo "Cursor not on tag"
	endif
endfunction


"**********************************************************
" If the cursor is on a tag, insert the argument string after it.
function! InsertStringRightOfTag(str)
	let n = line(".")
	let c = col(".")
	let s = getline(n)

	" Find beginning and end of tag.
	execute FindTag(s, c, "st", "et")

	" See if cursor is on a tag.
	if c > st  &&  c <= et

		let t = strpart(s, 0, et)		" upto end of tag
		let u = strpart(s, et)			" to end of line
		call setline(n, t.a:str.u)
	else
		echo "Cursor not on tag"
	endif
endfunction


"**********************************************************
" Move right by tags.
" If the cursor is currently on a tag move to the end of the tag.
" If the cursor is not on a tag move to the next tag.
function! CursorRightByTag()
	let srch = 1

	" See if cursor is on a tag.
	let n = line(".")
	let c = col(".")
	let s = getline(n)
	execute FindTag(s, c, "st", "et")

	if st != -1  &&  et != -1
		" If the cursor is not at the end of the tag, move to end.
		if c != et
			call cursor(n, et)
			let srch = 0
		endif
	endif

	if srch
		let n = search(s:XMLTag, "")
	endif
endfunction


"**********************************************************
" Move cursor left by tags.
" If the cursor is currently on a tag move to the beginning of the tag.
" If the cursor is not on a tag move to the previous tag.
function! CursorLeftByTag()
	let srch = 1

	" See if cursor is on a tag.
	let n = line(".")
	let c = col(".")
	let s = getline(n)
	execute FindTag(s, c, "st", "et")

	if st != -1  &&  et != -1
		" If the cursor is not at the start of the tag, move to start.
		if c-1 != st
			call cursor(n, st+1)
			let srch = 0
		endif
	endif

	if srch
		let n = search(s:XMLTag, "b")
		if n != 0
			call search(">", "")
		endif
	endif
endfunction

