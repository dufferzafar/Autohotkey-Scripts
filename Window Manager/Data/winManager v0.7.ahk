/*
         ahkWinManager by ShadabSofts.   v0.7 beta
   
   Changes:-
      I have re-modelled the hotkeys to avoid using Keyboard.
      Removed 2 bugs.... :)
   
   Usage:-
      Right Click above Maximize button of a window to Minimize it to a thumbnail.
      DoubleClick on the thumbnail again to show window.   
      The thumbnail can be dragged simply.
   
   To-DO:-
      Remove the bugs in re-structuring the arrays.
      Create thumbnails with rounded corners (GDI+).
      Thumbnail should disappear when the associated window is closed (by other means - taskmgr)
      Similar windows could be clubbed.
   
   I urge you to please Correct(if you can) the Restructuring of Arrays.
 */

#NoEnv                    ;Recommended for performance.
#SingleInstance Force         ;Make Single instance application.
#Persistent                  ;Keep running until the user asks to exit.

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
size := 0.1      ;Ratio of WindowImage to Thumbnail
Matrix = 1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|0.9|0|0|0|0|0|0

guiArrayX := A_ScreenWidth - 1
guiArrayY := A_ScreenHeight - 35

Return    ;End of Auto Execute Section
;_____________________________________________

;The Hotkey
~RButton::
if WM_NCHITTEST() = "MAXBUTTON"
{
   if guiCount > %maxGuiCount%
   {
      Return
   }
   
   guiCount++   

   ;Create a gui (we'll update it later)
   Gui, %guiCount%: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow
   Gui, %guiCount%: Show, NA
   gID%guiCount% := WinExist(), OnMessage(0x201, "WM_LBUTTONDOWN"), OnMessage(0x203, "WM_LBUTTONDBLCLK")
   
   ;Get Necessary Info about current window
   WinGet, winID%guiCount%, ID, A
   
   ;Get a Screenshot of Current Window
   pBitmap := Gdip_BitmapFromHWND(winID%guiCount%)
   Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
   newWidth := Round(Width*Size), newHeight := Round(Height*Size)
   
   ;Normal GDI+ routines that i never understood
   hbm := CreateDIBSection(newWidth, newHeight), hdc := CreateCompatibleDC()
   obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc)
   Gdip_SetInterpolationMode(G, 7)

   ;Draw Our Image
      Gdip_DrawImage(G, pBitmap, 0, 0, newWidth, newHeight,  0, 0, Width, Height, Matrix)

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
}
Return

;################################################
;################################################

WM_LBUTTONDBLCLK()
{
   Global
   
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
   */
   i = A_GUI
   Loop, %guiCount%
   {
      next := i+1
      hWnd%i% := hWnd%next%   ;windowHandles
      winID%i% := winID%next%   ;windowUIDs
      gY%i% := gY%next%      ;Y Coords
      i++
      
      temp := hWnd%next%
      y := gY%next%
      
      WinMove, ahk_id %temp%, , gX, y
   }
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

WM_NCHITTEST()
{
   CoordMode, Mouse, Screen
   MouseGetPos, x, y, z
   SendMessage, 0x84, 0, (x&0xFFFF)|(y&0xFFFF)<<16,, ahk_id %z%
   RegExMatch("ERROR TRANSPARENT NOWHERE CLIENT CAPTION SYSMENU SIZE MENU HSCROLL VSCROLL MINBUTTON MAXBUTTON LEFT RIGHT TOP TOPLEFT TOPRIGHT BOTTOM BOTTOMLEFT BOTTOMRIGHT BORDER OBJECT CLOSE HELP", "(?:\w+\s+){" . ErrorLevel+2&0xFFFFFFFF . "}(?<AREA>\w+\b)", HT)
   Return HTAREA
}