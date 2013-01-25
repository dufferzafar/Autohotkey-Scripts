/*
						Screener 2						
	  An improved, fast and lightweight screenshot tool	
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1				;We Need Speed

;Variables
Path := "C:\Users\dufferzafar\Pictures\Screenshots"

If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
   ExitApp
}
OnExit, Exit

PrintScreen::
    SaveScreen(1.00,"png","Screen")
Return

+PrintScreen::
    SaveScreen(1.00,"png","Window")
Return

SaveScreen(Size,FileType,Type)
{
	Global Path
	sW := A_ScreenWidth, sH := A_ScreenHeight
	WinGetPos, X, Y, W, H, A
	If (Type = "Window") 
	{
		pBitmap := Gdip_BitmapFromScreen((X>0?X:0) "|" (Y>0?Y:0) "|" (W<sW?W:sW) "|" (H<(sH-40)?H:(sH-40)))
		FileName = Window-%A_DD%-%A_MMM%-%A_YYYY%-%A_Hour%-%A_Min%-%A_Sec%
	} 
	Else 
	{
		pBitmap := Gdip_BitmapFromScreen()
		FileName = Screen-%A_DD%-%A_MMM%-%A_YYYY%-%A_Hour%-%A_Min%-%A_Sec%
	}

	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
	PBitmapResized := Gdip_CreateBitmap(Round(Width*Size), Round(Height*Size))
	G := Gdip_GraphicsFromImage(pBitmapResized), Gdip_SetInterpolationMode(G, 7)
	Gdip_DrawImage(G, pBitmap, 0, 0, Round(Width*Size), Round(Height*Size), 0, 0, Width, Height)
	
	; ToolTip, % "Saving To - " Path "\" FileName "." FileType
	; SetTimer, RemoveToolTip, 1000
	Gdip_SaveBitmapToFile(PBitmapResized, Path "\" FileName "." FileType)	;Save to file

	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapResized), Gdip_DisposeImage(pBitmap)
}

Esc::
	Msgbox, Bye! from GDI+
Exit:
	Gdip_Shutdown(pToken)
ExitApp

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
Return