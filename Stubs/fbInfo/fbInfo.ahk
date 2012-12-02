#SingleInstance, Off
#NoEnv
SetBatchLines, -1

; Start gdi+
If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
   ExitApp
}
OnExit, Exit

;Create a gui (we'll update it later)
Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop
Gui, 1: Show, NA
hwnd1 := WinExist()

; Get a bitmap from the image
If !pBitmap := Gdip_CreateBitmapFromFile("11.png")
{
   MsgBox, 48, File loading error!, Could not load the GUIimage specified
   ExitApp
}

;Dimensions of our Image
Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)

;Normal GDI+ Sh!t that i never understood
hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc),
Gdip_SetInterpolationMode(G, 7)

Font = Segoe UI
If !hFamily := Gdip_FontFamilyCreate(Font)
{
   MsgBox, 48, Font error!, The font you have specified does not exist on the system
   ExitApp
}
Gdip_DeleteFontFamily(hFamily)

; Create a partially transparent, black brush (ARGB = Transparency, red, green, blue) to draw a rounded rectangle with


;Draw the image on the canvas
	Gdip_DrawImage(G, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height)
	Gdip_TextToGraphics(G, "82", "x-10 y-11 cffffffff r4 s85", Font, Width, Height)
	Gdip_TextToGraphics(G, "likes", "x95 y31 cffffffff r4 s45", Font, Width, Height)
	
	; Gdip_TextToGraphics(G, "fb", "x5p cffffffff r4 s90", Font, Width, Height)
	; Gdip_TextToGraphics(G, "75", "x165 y1 cffffffff r4 s85", Font, Width, Height)
	; Gdip_TextToGraphics(G, "likes", "x280 y35 cffffffff r4 s50", Font, Width, Height)
	; Gdip_TextToGraphics(G, "Shadab Softs", "x5 y110 cffffffff r4 s65 SemiBold", Font, Width, Height)
	; Gdip_FillRoundedRectangle(G, Gdip_BrushCreateSolid(0x11ffffff), 0, 0, Width, Height, 20)

;Handles Window Drag
; OnMessage(0x201, "WM_LBUTTONDOWN")

;Update Our Window (Show Image)
UpdateLayeredWindow(hwnd1, hdc, (A_ScreenWidth-Width-5), (A_ScreenHeight-Height-45), Width, Height)

;Normal GDI+ Cleanup
SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap)
Return

;#######################################################################
WM_LBUTTONDOWN() {
	PostMessage, 0xA1, 2 
}

Esc::
Exit:
	Gdip_Shutdown(pToken)
ExitApp 