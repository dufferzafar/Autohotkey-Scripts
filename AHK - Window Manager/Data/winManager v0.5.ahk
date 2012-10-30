/* 
		ahkWinManager by ShadabSofts.	
	
	Usage:-
		Press Win+V to Minimize window to a thumbnail.
		Click on the thumbnail again to show window.
	
		The thumbnail can be dragged by holding Shift.
	
	To-DO:-
		Remove the bugs in re-structuring the arrays.
		Create thumbnails with rounded corners (GDI+).
		Thumbnail should disappear when the associated window is closed.		
		Similar windows could be clubbed.
		
 */

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.

OnExit, ExitSub
Menu, Tray, Icon, %A_WinDir%\System32\Shell32.dll, 19

;Let the user know that the utility has started
TrayTip, AHK - winManager,
(
I am up and running...

Press Esc to Exit.
)
SetTimer, RemoveTrayTip, 1000

; Start gdi+
If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start.
   ExitApp
}

;Global Variables
guiCount := 0
maxGuiCount := 5
size := 0.15		;Ratio of WindowImage to Thumbnail

guiArrayX := A_ScreenWidth - 1
guiArrayY := A_ScreenHeight - 35

Return	 ;End of Auto Execute Section
;_____________________________________________

;The Hotkey
#v::
	if guiCount > %maxGuiCount%
	{
		Return
	}
	
	guiCount++	

	;Create a gui (we'll update it later)
	Gui, %guiCount%: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
	Gui, %guiCount%: Show, NA
	hWnd%guiCount% := WinExist(), OnMessage(0x201, "WM_LBUTTONDOWN")
	
	;Get Necessary Info about current window
	WinGet, winID%guiCount%, ID, A
	WinGetPos, X, Y, W, H, A
	
	;Get a Screenshot of Current Window
	pBitmap := Gdip_BitmapFromScreen(X "|" Y "|" W "|" H)	
	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
	newWidth := Round(Width*Size), newHeight := Round(Height*Size)
	
	;Normal GDI+ Sh!t that i never understood
	hbm := CreateDIBSection(newWidth, newHeight), hdc := CreateCompatibleDC()
	obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetInterpolationMode(G, 7)

	;Draw Our Image, Matrix Adds Transparency
	Matrix = 1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|0.9|0|0|0|0|0|0
		Gdip_DrawImage(G, pBitmap, 0, 0, newWidth, newHeight,  0, 0, Width, Height, Matrix)

	;Generate Coords
	;Bug: S**ks when the thumbnails are of different heights
	gX := guiArrayX - newWidth
	gY%guiCount% := (guiArrayY - newHeight * guiCount)
	
	;Its Showtime baby
		UpdateLayeredWindow(hWnd%guiCount%, hdc, gX, gY%guiCount%, newWidth, newHeight)
	
	;Hide Associated Window
	thisID := winID%guiCount%
	WinHide, ahk_id %thisID%
	
	;Normal GDI+ Cleanup
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap)
Return

;################################################
;################################################

WM_LBUTTONDOWN()
{
	Global
	
	If GetKeyState("Shift", "P")
	{	;If Shift is pressed --- Drag Gui
		Loop
		{
			Sleep, 10
			GetKeyState, state, Shift, P
			If state = U
				break			
			PostMessage, 0xA1, 2
		}
	}
	Else
	{	;Show Hidden Window	
		thisID := winID%A_GUI%
		WinShow, ahk_id %thisID%
		
		;Destroy GUI
		guiCount--
		Gui, %A_GUI%: Destroy
		
		;Re-Structure all those arrays including the Image Array
		;Completely Buggy.. :( Doesn't works as I want
		i = A_GUI
		Loop, %guiCount%
		{
			next := i+1
			hWnd%i% := hWnd%next%	;windowHandles
			winID%i% := winID%next%	;windowUIDs
			gY%i% := gY%next%		;Y Coords
			i++
			
			temp := hWnd%next%
			y := gY%next%
			
			WinMove, ahk_id %temp%, , gX, y
		}
	}
}

Esc::
ExitSub:
	;We're signing off, So show every hidden window
	Loop, %guiCount%
	{
		thisID := winID%A_Index%
		WinShow, ahk_id %thisID%
	}
Exitapp

RemoveTrayTip:
	SetTimer, RemoveTrayTip, Off
	TrayTip
Return
