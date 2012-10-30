/*
				AHK- HulaGirl				
	 Yahoo! Widget Re-Written in AutoHotKey 
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Off				;Make Multi Instance Application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1				;We Need Speed

If !pToken := Gdip_Startup()
{
	MsgBox, 48, Gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

;Variables
Index = 0
Started := true
Matrix = 1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|0.9|0|0|0|0|0|0

;Create Bitmaps from Files
SetWorkingDir %A_ScriptDir%\Images
Loop, *.png
{
	pBitmap%A_Index% := Gdip_CreateBitmapFromFile(A_LoopFileName)
}
SetWorkingDir %A_ScriptDir%

;Dimensions of the images
nWidth := Gdip_GetImageWidth(pBitmap1), nHeight := Gdip_GetImageHeight(pBitmap1)

;Create a GUI
Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
Gui, 1: Show, NA
hwnd1 := WinExist(), OnMessage(0x204, "WM_RBUTTONDOWN") , OnMessage(0x201, "WM_LBUTTONDOWN")

;Normal GDI+ Routines
hbm := CreateDIBSection(nWidth, nHeight), hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetInterpolationMode(G, 7)

X:= (A_ScreenWidth-nWidth)//2
Y:= (A_ScreenHeight-nHeight)//2

;Begin
SetTimer, Animate, 50

Return	 ;End of Auto Execute Section
;_____________________________________________

;The Main Label
Animate:
	Index++, Index := mod(Index, 82) = 0 ? 1 : mod(Index, 82)
	
	Gdip_DrawImage(G, pBitmap%Index%, 0, 0, nWidth, nHeight, 0, 0, nWidth, nHeight)
	UpdateLayeredWindow(hwnd1, hdc, X, Y, nWidth, nHeight)
	Gdip_GraphicsClear(G)
Return

;Drag Gui
WM_LBUTTONDOWN()
{	
	Global
	PostMessage, 0xA1, 2	
	WinGetPos, X, Y, , , ahk_id hwnd1
}

;Toggle Animation State
WM_RBUTTONDOWN()
{
	Global
	If Started	;Pause
	{
		SetTimer, Animate, Off
		Started := false
	}
	Else		;Play
	{
		SetTimer, Animate, 50
		Started := true
	}
}

;Exit
Esc::
Exit:
	SelectObject(hdc, obm), DeleteObject(hbm)
	DeleteDC(hdc), Gdip_DeleteGraphics(G)
	Gdip_DeleteBrush(pBrush), Gdip_Shutdown(pToken)
ExitApp 