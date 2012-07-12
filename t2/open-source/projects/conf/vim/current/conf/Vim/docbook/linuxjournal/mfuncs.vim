" mfuncs.vim
"
" Mapping related functions.


" *********************************************************

let s:InsertTagTemplateKey	= "<F2>"
let s:InsertSymbolKey		= "<F3>"
let s:InsertForeignCharKey	= "<F4>"
let s:InsertStartTagKey		= "<F5>"
let s:InsertEndTagKey		= "<F6>"
let s:TagWordKey		= "<F7>"
let s:TagRangeKey		= "<F7>"
let s:ChangeTagKey		= "<F8>"


" *********************************************************
" Create mappings for:
"   - Inserting a tag template (start tag, end tag).
"   - Inserting a start tag.
"   - Inserting an end tag.
"   - Tagging a word with a start tag and end tag.
"   - Tagging a range of lines with a start tag and end tag.
"   - Change a tag.

function! MapTagKey(key, snewline, enewline, tag, stagx)

	" Command/leadin text depends on whether or not the tag should be on a new line.
	let sicmd = a:snewline ? " <CR>" : " "
	let sncmd = a:snewline ? " o" : " a"
	let eicmd = a:enewline ? " <CR>" : " "
	let encmd = a:enewline ? " o" : " a"
	let ticmd = a:enewline ? "<CR><CR>" : ""
	let cr    = "<CR>"

	" Create tag text (check for special tags).
	if a:tag == "CDATA"
		let stag = "<![CDATA["
		let etag = "]]>"
	elseif a:tag == "COMMENT"
		let stag = "<!--"
		let etag = "-->"
	else
		let stag = "<" . a:tag . a:stagx . ">"
		let etag = "</" . a:tag . ">"
	endif

	" Map keys for template tag (check for predefined template string).

	if exists("g:Template_" . a:tag)
		let tmpl = g:Template_{a:tag}

		" Template string exists
		let icmd = "imap " . s:InsertTagTemplateKey . a:key . sicmd . tmpl . "\<Esc>?-:-<CR>3xi"
		let ncmd = "nmap " . s:InsertTagTemplateKey . a:key . sncmd . tmpl . "\<Esc>?-:-<CR>3xi"
	else
		let icmd = "imap " . s:InsertTagTemplateKey . a:key . sicmd . stag . ticmd . etag
		let ncmd = "nmap " . s:InsertTagTemplateKey . a:key . sncmd . stag . ticmd . etag

		" Reposition cursor between tags after insert.
		if strlen(ticmd) == 0
			let i = 0
			let n = strlen(etag)
			while i < n
				let icmd = icmd . "<left>"
				let ncmd = ncmd . "<left>"
				let i = i + 1
			endwhile
		else
			let icmd = icmd . "<up>"
			let ncmd = ncmd . "<up>"
		endif
	endif

	execute icmd
	execute ncmd

	" Map keys for start tag.
	execute "imap " . s:InsertStartTagKey . a:key . sicmd . stag
	execute "nmap " . s:InsertStartTagKey . a:key . sncmd . stag

	" Map keys for end tag.
	execute "imap " . s:InsertEndTagKey . a:key . eicmd . etag
	execute "nmap " . s:InsertEndTagKey . a:key . encmd . etag

	let stag = escape(stag, "\"")
	let etag = escape(etag, "\"")

	" Map key for tagging a word.
	execute "nmap " . s:TagWordKey . a:key . " :call TagWord(\"" . stag . "\", \"" . etag "\")" . cr

	" Map key for tagging a range.
	execute "cmap " . s:TagRangeKey . a:key . " :call TagRange(\"" . stag . "\", \"" . etag "\")" . cr

	" Map key for changing tag.
	execute "nmap " . s:ChangeTagKey . a:key . " :call ChangeTag(\"" . stag . "\", \"" . etag "\")" . cr

endfunction


" *********************************************************
" Create mapping for symbol.

function! MapSymbolKey(key, sym)

	execute "imap " . s:InsertSymbolKey . a:key . " " . a:sym
	execute "nmap " . s:InsertSymbolKey . a:key . " a" . a:sym

endfunction


" *********************************************************
" Create mapping for foreign characater.

function! MapForeignCharKey(key, fchar)

	execute "imap " . s:InsertForeignCharKey . a:key . " " . a:fchar
	execute "nmap " . s:InsertForeignCharKey . a:key . " a" . a:fchar

endfunction
