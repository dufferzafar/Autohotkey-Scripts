SetBatchLines -1

WinGet ID, ID, ahk_class Shell_TrayWnd

; WinShow, ahk_class DV2ControlHost

s := "start"

Loop
{
	ControlSetText,,% SubStr( s, 1, Mod( A_Index, StrLen(s)+1 ) ), ahk_id %ID%
	Sleep 500
}

Esc::
Exitapp
