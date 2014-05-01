" vimrc_hebrew - some settings for hebrew vim support
" to use those settings - add the following file to the end of your
" .vimrc (in your home directory)


" select hebrew font for gvim
" set guifont=heb8x13

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" some key bindings
" Allow revins (CTRL-_) - toggles visual hebrew editing at insert mode
" note that I put here a key mapping for F10 to do that (and also not
" in insert mode)
set allowrevins

" toggle both direction and hebrew keyboard mapping
" this is useful for logical-order hebrew editing
map <F9>   :set invrl<CR>:set invhk<CR>
" do it when in insert mode as well (and return to insert mode)
imap <F9> <Esc>:set invrl<CR>:set invhk<CR>a

" toggle both reverse insertion and hebrew keyboard mapping
" this is useful for visual-order hebrew editing
map <F10>   :set invrevins<CR>:set invhk<CR>
" do it when in insert mode as well (and return to insert mode)
"imap <F10> <Esc>:set invrevins<CR>:set invhk<CR>a
imap <F10> <C-_>

"toggle comand line language
cmap  <S-F9>  <C-_>

" toggle language and add at EOL
map <C-F9>   :set invrl<CR>:set invhk<CR>
" do it when in insert mode as well (and return to insert mode)
imap <C-F9> <Esc>:set invrl<CR>:set invhk<CR>A
"""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" some key bindings
" Allow revins (CTRL-_)
" (for some reason I can't get Ctrl+Shift+\- to work for me)
set allowrevins

" toggle both direction and hebrew keyboard mapping
map <F9>   :set invrl<CR>:set invhk<CR>
" do it when in insert mode as well (and return to insert mode)
imap <F9> <Esc>:set invrl<CR>:set invhk<CR>a

map <C-B><C-l> <F9>


"toggle comand line language
cmap  <S-F9>  <C-_>
" toggle language and add at EOL
map <C-F9>   :set invrl<CR>:set invhk<CR>
" do it when in insert mode as well (and return to insert mode)
imap <C-F9> <Esc>:set invrl<CR>:set invhk<CR>A
"""""""""""""""""""""""""""""""""""""""""""""


" TODO: condition this with the availability of bidi support
nmenu Heb&rew.&Toggle\ Heb<->Eng\ \(F9\)	:set invrightleft<CR>:set hkmap<CR>
vmenu Heb&rew.&Toggle\ Heb<->Eng\ \(F9\)	<ESC>:set invrightleft<CR><ESC>:set hkmap<CR>
imenu Heb&rew.&Toggle\ Heb<->Eng\ \(F9\)	<C-O>:set invrightleft<CR><C-O>:set hkmap<CR>
cmenu Heb&rew.&Toggle\ Heb<->Eng\ \(F9\)	<C-C>:set invrightleft<CR><C-C>:set hkmap<CR>
omenu Heb&rew.&Toggle\ Heb<->Eng\ \(F9\)	<ESC>:set invrightleft<CR><ESC>:set hkmap<CR>
tmenu Heb&rew.&Toggle\ Heb<->Eng\ \(F9\)	Switch between english mode and hebrew mode
nmenu Heb&rew.Toggle\ &Visual\ \(F10\)		:set invrevins<CR>:set invhk<CR>
imenu Heb&rew.Toggle\ &Visual\ \(F10\)		<C-_>
amenu Heb&rew.-sep1-				<nul>

" The follwing can serve to demonstrate exactly what can be done,
" but it is quite useless...
" note that "rl" can be a shorthand for "rightleft"
amenu Heb&rew.RTL\ Display			:set rightleft<CR>
amenu Heb&rew.LTR\ Display			:set norightleft<CR>
amenu Heb&rew.Toggle\ RTL-LTR\ &Display		:set invrightleft<CR>
amenu Heb&rew.-sep2-				<nul>
" note that "hk" can be a shorthand for "hkmap"
amenu Heb&rew.Hebrew\ Keyboard			:set hkmap<CR>
amenu Heb&rew.English\ Keyboard			:set nohkmap<CR>
amenu Heb&rew.Toggle\ &Keyboard			:set invhkmap<CR>
amenu Heb&rew.-sep3-                      	<nul>
" useful for editing visual-hebrew texts:
" note that "ri" can be a shorthand for "revins"
amenu Heb&rew.Inverted\ Keyboard 		:set revins<CR>
amenu Heb&rew.Normal\ Keyboard	 		:set norevins<CR>
amenu Heb&rew.Toggle\ &Inverted\ Keyboard	:set invrevins<CR>
amenu Heb&rew.-sep4-				<nul>
" note that "ari" can be a shorthand for "allowrevins"
amenu Heb&rew.Enable\ ^-_			:set allowrevins<CR>
amenu Heb&rew.Disable\ ^-_			:set noallowrevins<CR>
amenu Heb&rew.Toggle\ ^-_			:set invallowrevins<CR>


" I'm not sure that the following is needed(or maybe only leave the
" "toggle" button), and if it is there bound to be a way to make it more
" elegant. Anyway - I have not bothered to create icons yet...

" Add heb&rew buttons to the toolbar
nmenu 1.1000 ToolBar.English	:set norightleft<CR>:set nohkmap<CR>
vmenu 1.1000 ToolBar.English	<Esc>:set norightleft<CR><Esc>:set nohkmap<CR>
imenu 1.1000 ToolBar.English	<C-O>:set norightleft<CR><C-O>:set nohkmap<CR>
cmenu 1.1000 ToolBar.English	<C-C>:set norightleft<CR><C-C>:set nohkmap<CR>
omenu 1.1000 ToolBar.English	<Esc>:set norightleft<CR><Esc>:set nohkmap<CR>

tmenu ToolBar.English		Switch to English

" the following item does not seem to work. I can't figure out why
amenu 1.1010 ToolBar.TogHeb	<C-_>
"nmenu 1.1010 ToolBar.TogHeb	:set invrightleft<CR>:set invhkmap<CR>
"vmenu 1.1010 ToolBar.TogHeb	<Esc>:set invrightleft<CR><Esc>:set invhkmap<CR>
"imenu 1.1010 ToolBar.TogHeb	<C-O>:set invrightleft<CR><C-O>:set invhkmap<CR>
"cmenu 1.1010 ToolBar.TogHeb	<C-C>:set invrightleft<CR><C-C>:set invhkmap<CR>
"omenu 1.1010 ToolBar.TogHeb	<Esc>:set invrightleft<CR><Esc>:set invhkmap<CR><Esc>
tmenu ToolBar.TogHeb		Toggle Hebrew <-> English

nmenu 1.1020 ToolBar.TogHeb	:set rightleft<CR>:set hkmap<CR>
vmenu 1.1020 ToolBar.Hebrew	<Esc>:set rightleft<CR><Esc>:set hkmap<CR>
imenu 1.1020 ToolBar.Hebrew	<C-O>:set rightleft<CR><C-O>:set hkmap<CR>
cmenu 1.1020 ToolBar.Hebrew	<C-C>:set rightleft<CR><C-C>:set hkmap<CR>
omenu 1.1020 ToolBar.Hebrew	<Esc>:set rightleft<CR><Esc>:set hkmap<CR><Esc>
tmenu ToolBar.Hebrew		Switch to Hebrew

" add a hebrew help item (:help hebrew) to the help menu
amenu 9999.25 &Help.He&brew		:help hebrew<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
