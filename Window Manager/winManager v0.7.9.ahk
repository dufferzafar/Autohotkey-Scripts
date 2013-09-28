/*
			ahkWinManager v0.7 beta

	Usage:-
		Press Right Mouse Button while the cursor is above Maximize button of any window.
		DoubleClick on the thumbnail again to show window.
		The thumbnail can be dragged simply.

	To-DO:-
		Remove the bugs in re-structuring the arrays.
		Create thumbnails with rounded corners (GDI+).
		Thumbnail should disappear when the associated window is closed (by other means - taskmgr)
		Similar windows could be clubbed.

	I urge you to please Correct(if you can) the Restructuring of Arrays.
 */

#NoEnv
#SingleInstance Force
#Persistent

CoordMode, Mouse, Screen
OnExit, ExitSub

Menu, Tray, Icon, %A_WinDir%\System32\Shell32.dll, 19

;Let the user know that the utility has started
TrayTip, AHK - winManager,
(
I am up and running...

Press Esc to Exit.
)
SetTimer, RemoveTrayTip, 1000

; Start GDI+
If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start.
   ExitApp
}

;Global Variables
guiCount := 0
maxGuiCount := 5
size := 0.15		;Ratio of WindowImage to Thumbnail
Matrix = 1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|0.9|0|0|0|0|0|0

exceptions :=

guiArrayX := A_ScreenWidth - 1
guiArrayY := A_ScreenHeight - 35

Return	 ;End of Auto Execute Section
;_____________________________________________

;The Hotkey
;#v::
$RButton::
	MouseGetPos, x, y, z
	If IsOverTitleButtons(x, y, z)
	{
		WinGetClass, class, A
		If (class in Shell_TrayWnd,DV2ControlHost,Progman) Or (guiCount > %maxGuiCount%)
			Return

		guiCount++

		;Get Necessary Info about current window
		WinGet, winID%guiCount%, ID, A

		;Create a gui (we'll update it later)
		Gui, %guiCount%: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
		Gui, %guiCount%: Show, NA
		gID%guiCount% := WinExist(), OnMessage(0x201, "WM_LBUTTONDOWN"), OnMessage(0x203, "WM_LBUTTONDBLCLK")

		;Get a Screenshot of Current Window
		;WinGetPos, X, Y, W, H, A
		;pBitmap := Gdip_BitmapFromScreen(X "|" Y "|" W "|" H)
		pBitmap := Gdip_BitmapFromHWND(winID%guiCount%)
		Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
		newWidth := Round(Width*Size), newHeight := Round(Height*Size)
		BorderWidth := 2

		;Normal GDI+ routines that i never understood
		hbm := CreateDIBSection(newWidth, newHeight), hdc := CreateCompatibleDC()
		obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc)
		Gdip_SetInterpolationMode(G, 7)

		;The pen with will we'll create the border
		color = 0x6f808080		;Gray - Default

		If class = CabinetWClass
			color = 0x6fff0000	;Red
		Else If (class in MSPaintApp,Notepad)
			color = 0x6f008000	;Green

		hPen := Gdip_CreatePen(color, BorderWidth)

		;Draw Our Image
			Gdip_DrawImage(G, pBitmap, 0, 0, newWidth, newHeight,  -2, -2, Width+2, Height+2, Matrix)
			Gdip_DrawRoundedRectangle(G, hPen, BorderWidth//2, BorderWidth//2, newWidth-BorderWidth, newHeight-BorderWidth, 0)

		;Generate Coords
		gX := guiArrayX - newWidth
		prevGui := guiCount-1
		if prevGui = 0
			gY%guiCount% := guiArrayY - newHeight
		else
			gY%guiCount% := gY%prevGui% - newHeight - 5

		;Its Showtime baby
			UpdateLayeredWindow(gID%guiCount%, hdc, gX, gY%guiCount%, newWidth, newHeight)

		;Hide Associated Window
		thisID := winID%guiCount%
		WinHide, ahk_id %thisID%

		;Normal GDI+ Cleanup
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap)
		;Gdip_DeletePen(hPen)
	}
	Else
		Send, {RButton}
Return

;################################################
;################################################

WM_LBUTTONDBLCLK()
{
	Global

	;Msgbox, % A_GUI

	;Show Hidden Window
	thisID := winID%A_GUI%
	WinShow, ahk_id %thisID%

	;Destroy GUI
	guiCount--
	Gui, %A_GUI%: Destroy

	;Re-Structure all those arrays including the Thumbnails positions
	;Completely Buggy.. :( Doesn't works as I want

	/*
		I am Used to C++ styled arrays.
		Here is what i think should work

		for(i = A_GUI, i < guiCount, i++)
		{
			winID[i] = winID[i+1]
			gY[i] = gY[i-1] - 5 - gHeight[i+1]
			gID[i] = gID[i+1]

			WinMove, ahk_id gID[i], gX, gY[i]
		}
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
	*/
}

WM_LBUTTONDOWN()
{
	;Drag Gui
	PostMessage, 0xA1, 2
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

IsOverTitleButtons(x, y, hWnd)
{
   SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
   return (ErrorLevel == 8) or (ErrorLevel == 9) or (ErrorLevel == 20)
}
