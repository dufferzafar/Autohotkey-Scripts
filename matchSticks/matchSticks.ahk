/*
		The match sticks problem
There are 13 matches, The game starts with you picking no more than 3 match.
Then the computer picks some matches.
The process continues until the last match remains.
The player who picks the last match loses.

Your task is to defeat the Computer, which is impossible, is it?


Works best with a 1368 * 768 display
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1

;############################################################# Global Variables
; Start gdi+
If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
   ExitApp
}
OnExit, Exit

;Create a gui (we'll update it later)
Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
Gui, 1: Show, NA
hwnd1 := WinExist()

; Get a bitmap from the image
If !pBitmap := Gdip_CreateBitmapFromFile("match.png")
{
   MsgBox, 48, File loading error!, Could not load the GUIimage specified
   ExitApp
}

Font = Segoe UI
If !hFamily := Gdip_FontFamilyCreate(Font)
{
   MsgBox, 48, Font error!, The font you have specified does not exist on the system
   ExitApp
}
Gdip_DeleteFontFamily(hFamily)

;Dimensions of our Image
Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)

;Gap Between matches
gap := 100

;Dimensions of canvas
cWidth := gap*13

;Normal GDI+ Sh!t that i never understood
hbm := CreateDIBSection(cWidth, Height), hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc),
Gdip_SetInterpolationMode(G, 7)

;Create Buttons GUI
Gui, 2: Font, s18
Gui, 2: Add, Text,   x12, How many match(es) do you want to pick? 
Gui, 2: Add, Button, xp+80   yp+50 w80 h50 gTakeMatch1, 1
Gui, 2: Add, Button, xp+110  yp  wp  hp    gTakeMatch2, 2
Gui, 2: Add, Button, xp+110  yp  wp  hp    gTakeMatch3, 3
Gui, 2: +AlwaysOnTop +ToolWindow +LastFound
Gui, 2: Show, x100 y500, Choose Matches
mainGuiID := WinExist()
RemoveMenu(hWnd, 0xF010) ;Disable Moving

matches := 13
GoSub, DrawMatches


Gui, 3: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
Gui, 3: Show, NA
hwnd3 := WinExist()

;Normal GDI+ Sh!t that i never understood
hbm2 := CreateDIBSection(500, 300), hdc2 := CreateCompatibleDC()
obm2 := SelectObject(hdc2, hbm2), G2 := Gdip_GraphicsFromHDC(hdc2),
Gdip_SetInterpolationMode(G2, 7)

ShowMessage("Your turn")

Return

;#######################################################################
TakeMatch1:
	pick := 1
	GoSub, TakeMatch
Return

TakeMatch2:
	pick := 2
	GoSub, TakeMatch
Return

TakeMatch3:
	pick := 3
	GoSub, TakeMatch
Return

TakeMatch:
	Gui, 2:Cancel
	
	matches := matches - pick	
	GoSub, DrawMatches
	
	ShowMessage("You Picked " . pick)
	
	Sleep, 2000	
	
	ShowMessage("I Pick " . 4-pick)
	
	Sleep, 1000
	
	matches := matches - (4-pick)
	GoSub, DrawMatches
	
	If matches = 1
	{
		ShowMessage("Your turn")
		Msgbox, 0, You Lose AGAIN!!, 1 Match Remains`n`n You have to pick it up`n`n So, You LOSE!!`n`nBetter Luck Next Time..........
		ExitApp
	}
	Else
	{	
		ShowMessage("Your turn")
		Gui, 2:Show
	}
		
Return

DrawMatches:
	Gdip_GraphicsClear(G)

	;Dimensions of canvas
	; cWidth := gap*matches
	
	;Draw the matchsticks on the canvas
	thisX := 0
	Loop, % matches
	{
		Gdip_DrawImage(G, pBitmap, thisX, 0, Width, Height)
		thisX += gap
	}
	
	UpdateLayeredWindow(hwnd1, hdc, (A_ScreenWidth-cWidth)//2 + 30, (A_ScreenHeight-Height)//2 - 125, cWidth, Height)
Return

ShowMessage(msg)
{
	global
	
	Gdip_GraphicsClear(G2)
	Gdip_TextToGraphics(G2, msg, "cff000000 r4 s80", Font, 500, 300)
	UpdateLayeredWindow(hwnd3, hdc2, (A_ScreenWidth-550), (A_ScreenHeight-250), 500, 300)	
}

;#######################################################################

GetSystemMenu(ByRef hWnd, Revert = False)  ; Get system menu handle
{
  hWnd := hWnd ? hWnd : WinExist("A")  ; Active window handle
  Return DllCall("GetSystemMenu", "UInt", hWnd, "UInt", Revert)
}
DrawMenuBar(hWnd)  ; Internal function: this is needed to apply menu changes
{
  Return DllCall("DrawMenuBar", "UInt", hWnd)
}
RemoveMenu(hWnd, Position, Flags = 0)  ; MF_BYCOMMAND = 0x0000
{
  DllCall("RemoveMenu", "UInt", GetSystemMenu(hWnd), "UInt", Position, "UInt", Flags)
  Return DrawMenuBar(hWnd)
}

;#######################################################################
WM_LBUTTONDOWN() {
	PostMessage, 0xA1, 2 
}

Esc::
Exit:	
	;Normal GDI+ Cleanup
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
ExitApp 

2GuiClose:
ExitApp