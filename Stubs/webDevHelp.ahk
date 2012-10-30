
#IfWinActive ahk_class Notepad++
	^q::
		WinGetTitle, wTitle, ahk_class Notepad++
		If InStr(wTitle, "css")
		{
			
		
		}
		Else If InStr(wTitle, "htm")
		{
		
		}
	Return
#If
