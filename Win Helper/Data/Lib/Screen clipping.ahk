;===Description========================================================================
/*
Put together by:    Learning one
Thanks:             Sean, wilhberg, and others...

Screen clipping script. Saves selected area to clipboard.

To select area:
1. press Control + Left mouse button
2. drag mouse
3. release Control and Left mouse button
This area will be saved to clipboard.
Press Control + v to paste it.

Press Esc to exit.
*/


;===Auto-execute========================================================================
Menu, Tray, Icon, Shell32.dll, 140      ; photo icon
TrayTip, Screen clipping, 
(
1. press Control + Left mouse button
2. drag mouse
3. release Control and Left mouse button
This area will be saved to clipboard.
Press Control + v to paste it.

Press Esc to exit.
), 10



;===Hotkeys=========================================================================
^Lbutton::
Area := SelectArea("cLime")
StringReplace, Area, Area, |, `,, All
Sleep, 100   ; if omitted, GUI sometimes stays in picture
CaptureScreen(Area)   ; Saves selected area without cursor in Clipboard.
Return

Escape::
Suspend
ExitApp


;===Functions==========================================================================
SelectArea(Options="") {	; by Learning one
   /*
   Returns selected area. Return example: 22|13|243|543
   Options: (White space separated)
   - c color. Default: Blue.
   - t transparency. Default: 50.
   - g GUI number. Default: 99.
   - m CoordMode. Default: s. s = Screen, r = Relative
   */
   CoordMode, Mouse, Screen
   MouseGetPos, MX, MY
   CoordMode, Mouse, Relative
   MouseGetPos, rMX, rMY
   CoordMode, Mouse, Screen
   loop, parse, Options, %A_Space%
   {
      Field := A_LoopField
      FirstChar := SubStr(Field,1,1)
      if FirstChar contains c,t,g,m
      {
         StringTrimLeft, Field, Field, 1
         %FirstChar% := Field
      }
   }
   c := (c = "") ? "Blue" : c, t := (t = "") ? "50" : t, g := (g = "") ? "99" : g , m := (m = "") ? "s" : m
   Gui %g%: Destroy
   Gui %g%: +AlwaysOnTop -caption +Border +ToolWindow +LastFound
   WinSet, Transparent, %t%
   Gui %g%: Color, %c%
   Hotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W)")
   While, (GetKeyState(Hotkey, "p"))
   {
      Sleep, 10
      MouseGetPos, MXend, MYend
      w := abs(MX - MXend), h := abs(MY - MYend)
      X := (MX < MXend) ? MX : MXend
      Y := (MY < MYend) ? MY : MYend
      Gui %g%: Show, x%X% y%Y% w%w% h%h% NA
   }
   Gui %g%: Destroy
   if m = s	; Screen
   {
      MouseGetPos, MXend, MYend
      If ( MX > MXend )
      temp := MX, MX := MXend, MXend := temp
      If ( MY > MYend )
      temp := MY, MY := MYend, MYend := temp
      Return MX "|" MY "|" MXend "|" MYend
   }
   else	; Relative
   {
      CoordMode, Mouse, Relative
      MouseGetPos, rMXend, rMYend
      If ( rMX > rMXend )
      temp := rMX, rMX := rMXend, rMXend := temp
      If ( rMY > rMYend )
      temp := rMY, rMY := rMYend, rMYend := temp
      Return rMX "|" rMY "|" rMXend "|" rMYend
   }
}

CaptureScreen(aRect)    ; by Sean (Thank you!)
{
   StringSplit, rt, aRect, `,, %A_Space%%A_Tab%
   nL := rt1
   nT := rt2
   nW := rt3 - rt1
   nH := rt4 - rt2
   znW := rt5
   znH := rt6

   mDC := DllCall("CreateCompatibleDC", "Uint", 0)
   hBM := CreateDIBSection(mDC, nW, nH)
   oBM := DllCall("SelectObject", "Uint", mDC, "Uint", hBM)
   hDC := DllCall("GetDC", "Uint", 0)
   DllCall("BitBlt", "Uint", mDC, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", hDC, "int", nL, "int", nT, "Uint", 0x40000000 | 0x00CC0020)
   DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
   DllCall("SelectObject", "Uint", mDC, "Uint", oBM)
   DllCall("DeleteDC", "Uint", mDC)
   SetClipboardData(hBM)
}

CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "")    ; by Sean (Thank you!)
{
   NumPut(VarSetCapacity(bi, 40, 0), bi)
   NumPut(nW, bi, 4)
   NumPut(nH, bi, 8)
   NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
   NumPut(0,  bi,16)
   Return   DllCall("gdi32\CreateDIBSection", "Uint", hDC, "Uint", &bi, "Uint", 0, "UintP", pBits, "Uint", 0, "Uint", 0)
}

SetClipboardData(hBitmap)    ; by Sean (Thank you!)
{
   DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
   hDIB :=   DllCall("GlobalAlloc", "Uint", 2, "Uint", 40+NumGet(oi,44))
   pDIB :=   DllCall("GlobalLock", "Uint", hDIB)
   DllCall("RtlMoveMemory", "Uint", pDIB, "Uint", &oi+24, "Uint", 40)
   DllCall("RtlMoveMemory", "Uint", pDIB+40, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44))
   DllCall("GlobalUnlock", "Uint", hDIB)
   DllCall("DeleteObject", "Uint", hBitmap)
   DllCall("OpenClipboard", "Uint", 0)
   DllCall("EmptyClipboard")
   DllCall("SetClipboardData", "Uint", 8, "Uint", hDIB)
   DllCall("CloseClipboard")
}