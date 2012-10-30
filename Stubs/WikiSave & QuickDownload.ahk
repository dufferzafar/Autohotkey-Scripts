#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#IfWinActive ahk_class Chrome_WidgetWin_0
; #IfWinActive ahk_class #32770

	; #LButton::
		; Send, {RButton}v
		; WinWaitActive, ahk_class #32770
		; Send, {Enter}
	; Return
	
	^q::
		Send, ^s
		WinWaitActive, ahk_class #32770
		Send, {End}{BS 35}{Enter}
	Return

#If