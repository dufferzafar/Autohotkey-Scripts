#SingleInstance, Force
#NoEnv
#Persistent
#NoTrayIcon

SetBatchLines, -1
BlockInput, On

;SetTimer, update, 250
Gdip_Startup()

Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA
hwnd1 := WinExist() ;, OnMessage(0x201, "WM_LBUTTONDOWN")

pBitmap := Gdip_BitmapFromScreen(0 "|" 0 "|" 1024 "|" 768)
Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)

hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetInterpolationMode(G, 7)

Matrix = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
Gdip_DrawImage(G, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height, Matrix)
; Gdip_DrawImage(G, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height)


UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)

SelectObject(hdc, obm), DeleteObject(hbm)
DeleteDC(hdc), Gdip_DeleteGraphics(G)
Gdip_DisposeImage(pBitmap), Gdip_Shutdown(pToken)
Return


; This is called on left click to allow to drag
WM_LBUTTONDOWN()
{
   PostMessage, 0xA1, 2
}

q & m::
ExitApp

;update:
;	UpdateLayeredWindow(hwnd1, hdc, 200, 200, Width, Height)
;return
