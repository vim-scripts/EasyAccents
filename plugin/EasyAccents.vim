" EasyAccents.vim: converts a` a' etc during insert mode
"
"  Author:  Charles E. Campbell, Jr. (PhD)
"  Date:    Nov 18, 2003
"  Version: 6
"  License: GPL (Gnu Public License)
"
"  Usage:
"
"   These maps all work during insert mode.
"   Type a' a` A' c, etc and accented characters result.
"   ([aeioubcAEIOUBC], then accent)
"
"   If you want a vowel (or [bBcC]) to be followed by an accent,
"   use a backslash to escape it:  a\'  for example will become a'
"
"   Sourcing this file acts as a toggle to switch EasyAccents on
"   and off.  By default, the mapping <Leader>ea will toggle
"   EasyAccents, too, by calling <Plug>ToggleEasyAccents .
"
"   If g:EasyAccents_VowelFirst is set to zero in your <.vimrc>,
"     then         'a `a `A ,b ,c  etc.
"     will map to   á  à  À  ß  ç
"     (accent, then [aeioubcAEIOUBC])
"
"   If g:EasyAccents_VowelFirst is set to one in your <.vimrc> (also default)
"     then         a' a` A` b, c,  etc.
"     will map to  á  à  À  ß  ç
"     ([aeioubcAEIOUBC], then accent)
"
"   New with version 6:
"     Also    a@ A@ D@ e@ E@ N~ p@ u@ x@
"     map to  å  Å  Ð  æ  Æ  Ñ  Þ  µ  ×
"
"  Caveat: the maps will not work if "set paste" is on, so that's
"          another way to bypass EasyAccents as needed.
"
"  Installation:
"
"   EasyAccents is now designed to be toggled on and off.  When on
"   it may interfere with programming languages which often use
"   characters such as single-quotes, backquotes, etc.
"
" "For I am convinced that neither death nor life, neither angels nor demons,
"  neither the present nor the future, nor any powers, nor height nor depth,
"  nor anything else in all creation, will be able to separate us from the
"  love of God that is in Christ Jesus our Lord."  Rom 8:38
"
"	History:
"	v6 Nov 18, 2003 : maps for a@ A@ D@ e@ E@ N~ p@ u@ x@ now included
"   v5 Aug 21, 2003 : * included g:EasyAccents_VowelFirst option
"                     * fixed insert vs append bug
" =======================================================================

" prevent re-load
if !exists("g:loaded_EasyAccents")
 let g:loaded_EasyAccents= 0

 if !exists("g:EasyAccents_VowelFirst")
  let g:EasyAccents_VowelFirst= 1
 endif

 if !hasmapto('<Plug>ToggleEasyAccents')
  map  <unique> <Leader>ea <Plug>ToggleEasyAccents
  imap <unique> <Leader>ea <Plug>InsToggleEasyAccents
 endif
 map  <silent> <script> <Plug>ToggleEasyAccents    :set lz<CR>:call <SID>ToggleEasyAccents()<CR>:set nolz<CR>
 imap <silent> <script> <Plug>InsToggleEasyAccents <c-o>:set lz<bar>:call <SID>ToggleEasyAccents()<bar>:set nolz<CR>

 " ---------------------------------------------------------------------

 " EasyAccents:
 fun! <SID>EasyAccents()
  if col(".") < 3
   return
  endif
  let akeep  = @a
  let bkeep  = @b
  let vekeep = &ve
  set ve=
  let didinsert= 0
  if col(".") < col("$")-1
   " inserting inside a line
   norm! h
   let didinsert= 1
  endif
  norm! "ayhl
  norm! v"by

  " not an accent and accent first
  if !g:EasyAccents_VowelFirst && @a !~ "[`'^:~,]"
   let @a = akeep
   let @b = bkeep
   let &ve= vekeep
   if !g:EasyAccents_VowelFirst || (&ve != "" && &ve != "block")
    norm! l
   endif
   return
  endif

  if didinsert
   norm! hx
  else
   norm! x
  endif

  " get accent and vowel
  if g:EasyAccents_VowelFirst
   let accent = @b
   let vowel  = @a
  else
   let accent = @a
   let vowel  = @b
  endif

  " change (some) accents
  let origaccent= accent
  if accent == "`"
   let accent= "!"
  elseif accent == "^"
   let accent= ">"
  elseif accent == "~"
   let accent= "?"
  endif
"  call Decho("accent<".accent."> vowel<".vowel.">")

  if accent == ","

   if vowel =~ "[cC]"
    exe "norm! r\<c-k>".vowel.accent
   elseif vowel =~ "[bB]"
    exe "norm! r\<c-k>ss"
   elseif vowel == '\'
	exe "norm! r".accent
   elseif g:EasyAccents_VowelFirst == 1
	exe "norm! R".vowel.origaccent
   else
	exe "norm! R".origaccent.vowel
   endif

  elseif accent == '@'
   if vowel =~ "[aA]"	" thanks to Martin Karlsson
   	exe "norm! r\<c-k>".vowel.vowel
   elseif vowel =~ "e"
   	exe "norm! r\<c-k>ae"
   elseif vowel =~ "E"
   	exe "norm! r\<c-k>AE"
   elseif vowel =~ "?"
   	exe "norm! r\<c-k>?I"
   elseif vowel =~ "O"
   	exe "norm! r\<c-k>O/"
   elseif vowel =~ "p"
   	exe "norm! r\<c-k>TH"
   elseif vowel =~ "u"
   	exe "norm! r\<c-k>My"
   elseif vowel =~ "D"
   	exe "norm! r\<c-k>D-"
   elseif vowel =~ "x"
   	exe "norm! r\<c-k>*X"
   elseif g:EasyAccents_VowelFirst == 1
	exe "norm! R".vowel.origaccent
   else
	exe "norm! R".origaccent.vowel
   endif

  else

   if vowel =~ "[aAeEiIoOuU]"
    exe "norm! r\<c-k>".vowel.accent
   elseif vowel =~ "N" && accent == '?'
    exe "norm! r\<c-k>".vowel.accent
  
   elseif vowel == '\'
   	exe "norm! r".origaccent
   elseif g:EasyAccents_VowelFirst == 1
	exe "norm! R".vowel.origaccent
   else
	exe "norm! R".origaccent.vowel
   endif
  endif
 
  let @a = akeep
  let @b = bkeep
  let &ve= vekeep
  if !g:EasyAccents_VowelFirst || (&ve != "" && &ve != "block")
   norm! l
  endif
 endfun

 " ---------------------------------------------------------------------

 " ToggleEasyAccents:
 fun! <SID>ToggleEasyAccents()
  if g:loaded_EasyAccents == 0 " -----------------------------------------
   " Turn EasyAccents on
   let g:loaded_EasyAccents= 1
   
   if g:EasyAccents_VowelFirst
    " this function provides the preceding character with an accent mark
    inoremap <silent> `  `<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> '  '<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> ^  ^<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> :  :<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> ~  ~<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> ,  ,<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> @  @<c-o>:call <SID>EasyAccents()<CR>

   else
    " this function examines the preceding character for accent mark
    inoremap <silent> a  a<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> A  A<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> b  b<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> B  B<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> c  c<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> C  C<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> D  D<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> e  e<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> E  E<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> i  i<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> I  I<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> N  N<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> o  o<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> O  O<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> p  p<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> u  u<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> U  U<c-o>:call <SID>EasyAccents()<CR>
    inoremap <silent> x  x<c-o>:call <SID>EasyAccents()<CR>
   endif
  
   echo "EasyAccents enabled"
   
  else " -----------------------------------------------------------------
   " Turn EasyAccents off
   let g:loaded_EasyAccents= 0
   if g:EasyAccents_VowelFirst
    iunmap `
    iunmap '
    iunmap ^
    iunmap :
    iunmap ~
    iunmap ,
   else
   	iunmap a
   	iunmap A
   	iunmap b
   	iunmap B
   	iunmap c
   	iunmap C
   	iunmap D
   	iunmap e
   	iunmap E
   	iunmap i
   	iunmap I
   	iunmap N
   	iunmap o
   	iunmap O
   	iunmap p
   	iunmap u
   	iunmap U
   	iunmap x
   endif
  
   echo "EasyAccents disabled"
  endif " ----------------------------------------------------------------
 endfun

 finish
endif

call <SID>ToggleEasyAccents()
" HelpExtractor:
set lz
let docdir = substitute(expand("<sfile>:r").".txt",'\<plugin[/\\].*$','doc','')
if !isdirectory(docdir)
 if has("win32")
  echoerr 'Please make '.docdir.' directory first'
  unlet docdir
  finish
 elseif !has("mac")
  exe "!mkdir ".docdir
 endif
endif

let curfile = expand("<sfile>:t:r")
let docfile = substitute(expand("<sfile>:r").".txt",'\<plugin\>','doc','')
exe "silent! 1new ".docfile
silent! %d
exe "silent! 0r ".expand("<sfile>:p")
silent! 1,/^" HelpExtractorDoc:$/d
exe 'silent! %s/%FILE%/'.curfile.'/ge'
exe 'silent! %s/%DATE%/'.strftime("%b %d, %Y").'/ge'
norm! Gdd
silent! wq!
exe "helptags ".substitute(docfile,'^\(.*doc.\).*$','\1','e')

exe "silent! 1new ".expand("<sfile>:p")
1
silent! /^" HelpExtractor:$/,$g/.*/d
silent! wq!

set nolz
unlet docdir
unlet curfile
"unlet docfile
finish

" ---------------------------------------------------------------------
" Put the help after the HelpExtractorDoc label...
" HelpExtractorDoc:
*EasyAccents.txt*	EasyAccents				Apr 02, 2004

Author:  Charles E. Campbell, Jr.  <NdrOchip@ScampbellPfamily.AbizM>
	  (remove NOSPAM from Campbell's email first)

==============================================================================
1. Contents    				*easyaccents* *easyaccents-contents*

	1. Contents.................: |easyaccents-contents|
	2. EasyAccents Manual.......: |easyaccents-manual|
	4. EasyAccents History......: |easyaccents-history|

==============================================================================

2. EasyAccents Manual  					*easyaccents-manual*
	
	 These maps all work during insert mode.  Type a' a` A' c, etc and
	 accented characters result.  ([aeioubcAEIOUBC], then accent)
	
	 If you want a vowel (or [bBcC]) to be followed by an accent,
	 use a backslash to escape it:  a\'  for example will become a'
	
	 Sourcing this file acts as a toggle to switch EasyAccents on
	 and off.  By default, the mapping <Leader>ea will toggle
	 EasyAccents, too, by calling <Plug>ToggleEasyAccents .
	
	 If g:EasyAccents_VowelFirst is set to zero in your <.vimrc>,
	   then         'a `a `A ,b ,c  etc.
	   will map to   á  à  À  ß  ç
	   (accent, then [aeioubcAEIOUBC])
	
	 If g:EasyAccents_VowelFirst is set to one in your <.vimrc> (also default)
	   then         a' a` A` b, c,  etc.
	   will map to  á  à  À  ß  ç
	   ([aeioubcAEIOUBC], then accent)
	
	 New with version 6:
	   Also    a@ A@ D@ e@ E@ N~ p@ u@ x@
	   map to  å  Å  Ð  æ  Æ  Ñ  Þ  µ  ×
	
	Caveat: the maps will not work if "set paste" is on, so that's
	        another way to bypass EasyAccents as needed.


==============================================================================

3. EasyAccents History					*easyaccents-history*

v6 Nov 18, 2003 : * maps for a@ A@ D@ e@ E@ N~ p@ u@ x@ now included
v5 Aug 21, 2003 : * included g:EasyAccents_VowelFirst option
                  * fixed insert vs append bug


==============================================================================
vim:tw=78:ts=8:ft=help
