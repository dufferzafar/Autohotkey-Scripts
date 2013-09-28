LastActionWasTile := false

^F10::
if LastActionWasTile
   PostMessage, 0x111, 416, 0,, ahk_class Shell_TrayWnd ; "Undo Tile"
else
   PostMessage, 0x111, 405, 0,, ahk_class Shell_TrayWnd ; "Tile Vertically"
LastActionWasTile := not LastActionWasTile  ; Invert
return

!F10::
if LastActionWasTile
   PostMessage, 0x111, 416, 0,, ahk_class Shell_TrayWnd ; "Undo Tile"
else
   PostMessage, 0x111, 404, 0,, ahk_class Shell_TrayWnd ; "Tile Horizontally"
LastActionWasTile := not LastActionWasTile  ; Invert
return