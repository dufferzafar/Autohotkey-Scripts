/*
  Start Button Virus

  Author(s):-     pSych0 C0d3r		 
  Contact:-  pSych0.C0d3r@gmail.com  

  Description:- 
	Moves The Start Button
*/

#NoEnv	
#SingleInstance Force
#Persistent
#NoTrayIcon

OnExit, ExitSub

SetBatchLines -1 ;For Speed

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Code Begins

CoordMode, Mouse, Screen
SysGet, WorkArea, MonitorWorkArea, 1 ;Avoid the taskbar

;Get StartButton Info
ControlGet, hStartButton, Hwnd, , Button1, ahk_class Shell_TrayWnd
hButtonParent := GetParent(hStartButton)

;Show our GUI
Gui, -Caption +LastFound +AlwaysOnTop +ToolWindow
Gui, Show, w95 h30, Shadab
hwnd1 := WinExist()

;Cut StartButton to our window
SetParent(hStartButton, hwnd1)

SetTimer, Move, 450

Return	 ;End of Auto Execute Section
;_____________________________________________

Move:
	Random, Xcord , 0, %WorkAreaRight%
	Random, Ycord , 0, %WorkAreaBottom%
	WinMove, ahk_id %hwnd1%, , Xcord, Ycord
Return 

GetParent(hControl)
{
  Return DllCall("GetParent", "UInt", hControl)
}

SetParent(hControl, hNewParent)
{
  Return DllCall("SetParent", "UInt", hControl, "UInt", hNewParent)
}

~a::
	InputBox, pass, Enter Passkey, Enter passkey to unlock., ,250, 150
	
	if (pass = "amit aswal")
	{
		WinShow, ahk_class Shell_TrayWnd
		SetParent(hStartButton, hButtonParent)
		Exitapp	
	}
Return

q & m::
ExitSub:
	MsgBox,, Amit Rocks!! , Amit is your Daddy.......
Exitapp
