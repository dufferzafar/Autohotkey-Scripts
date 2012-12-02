#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.

;##########################################################

;The Path
thePath := "D:\Games"
hiddenFolder := thePath "\7154~1"

;The Password
thePass := 357412987536

; Loop %thePath%,1
	; MyDoc := A_LoopFileShortPath

; If !FileExist( hiddenFolder ) 
; {
    ; FileCreateDir, \\?\%thePath%\...
    ; FileSetAttrib, +SH, \\?\%thePath%\...
; }
SetNumLockState, On
InputBox, inputPass, Enter a Number, Please enter a number between 1 and 1000, Hide, 270, 150

If (inputPass = thePass)
{
	DllCall( "DefineDosDevice", UInt,0, Str,"X:", Str, hiddenFolder )
	Msgbox, , Secret Drive Visible, Use My Computer to access your new secret drive.
	OnExit, QuitScript
}
Else
{
	If inputPass is not number
		Msgbox, , Number Please, Please enter a NUMBER between 1 and 1000.
	Else If inputPass not between 1 and 1000
		Msgbox, , Mind the Range, Please enter a number BETWEEN 1 and 1000.
	Else
		Msgbox, , Congrats!, You Entered %inputPass%, which is between 1 and 1000.
	ExitApp
}

SetNumLockState, Off
Return

!x::ExitApp
; ^#x::Run X:\,,Max

QuitScript:
	Msgbox, , Secret Drive InVisible, Run this script again to show it.
ExitApp, % DllCall( "DefineDosDevice", UInt,1|2, Str,"X:", Int,0 )
