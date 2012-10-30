#SingleInstance, Force
#NoEnv
#NoTrayIcon
SetBatchLines, -1

If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

Width := A_ScreenWidth, Height := A_ScreenHeight

pBitmap := Gdip_CreateBitmapFromFile("gear.png")
nWidth := Gdip_GetImageWidth(pBitmap), nHeight := Gdip_GetImageHeight(pBitmap)

Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
Gui, 1: Show, NA
hwnd1 := WinExist()

hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetInterpolationMode(G, 7)

pBrush := Gdip_BrushCreateSolid(0xEE606986)

/*
Font = Calibri
If !hFamily := Gdip_FontFamilyCreate(Font)
{
   MsgBox, 48, Font error!, The font you have specified does not exist on the system
   ExitApp
}
Gdip_DeleteFontFamily(hFamily)
*/

Gdip_FillRectangle(G, pBrush, 0, 0, Width, Height)
Gdip_DrawImage(G, pBitmap, (Width-nWidth)//2, (Height-nHeight)//2, nWidth, nHeight)
;Gdip_TextToGraphics(G, "Shadab Zafar", "x75 y300 cff000000 r4 s140", Font)


UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)

SelectObject(hdc, obm), DeleteObject(hbm)
DeleteDC(hdc), Gdip_DeleteGraphics(G)
Gdip_DeleteBrush(pBrush)
Return

;#######################################################################

Esc::
Exit:
Gdip_Shutdown(pToken)
ExitApp
