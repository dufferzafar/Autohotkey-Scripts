;mousePrank.ahk
;
;Script by Chimi, 2012
;
;Configurable mouse-manipulating prank script
;
;Instructions
;
; 1. Configure settings below.
; 2. Save .ahk file and open.
; 3. Start movements with Ctrl+Alt+Q
; 4. a. Pause and unpause script with Ctrl+Alt+W
;    b. Exit script with Ctrl+Alt+E
;
;   C O N F I G U R A T I O N      S E C T I O N
;-=-=-=- -=-=-=- -=-=-=-
;* moveType -
;
;  VALUE    | DESCRIPTION               | RANGE
; 0/default | Move to any position      | screen
; 1         | Move randomly within area | specified
; 2         | Move to specific position | specified
;
;        | MOVETYPE VALUE
;        | 0       | 1           | 2
; move1x | nothing | top left x  | x value
; move2x |    "    | top left y  | y value
; move1y |    "    | lwr right x | nothing
; move2y |    "    | lwr right y |    "   

moveType :=
move1x :=
move1y :=
move2x :=
move2y :=


;* minPause - sets the lowest possible delay time.
; Defaults to 2000. MS measures. Set min and max
; to equal values to force constant delay time.
minPause :=

;* maxPause - sets the highest possible delay time.
; defaults to 10000.
maxPause :=

;* hideTray - determines whether or not to show the
; tray icon. 0 for show, 1 for hide. Defaults to
; show.
hideTray :=

;* mSpeed - sets the speed at which the cursor will
; move. 0 is instantaneous. Defaults to 5.
mSpeed :=

; E N D   C O N F I G U R A T I O N   S E C T I O N
;-=-=-=- -=-=-=- -=-=-=-

;Process configuration settings
If (moveType = "") {
   moveType := 0
}
If (moveType >= 1) {
   If (move1x = "") {
      move1x := 0
   }
   If (move1y = "") {
      move1y := 0
   }
   If (moveType = 2) {
      If (move2x = "") {
         move2x := A_ScreenWidth
      }
      If (move2y = "") {
         move2y := A_ScreenHeight
      }
   }
}
If (minPause = "") {
   minPause := 2000
}
If (maxPause = "") {
   maxPause := 10000
}
If (hideTray = 1) {
   menu, tray, noicon
}
If (mSpeed = "") {
   mSpeed := 5
}
If (mSpeed < 0) {
   mSpeed := 0
}





;Mouse movements relative to screen
CoordMode, Pixel, Screen
;Force exactly one instance
#SingleInstance force
;Ctrl+Alt+Q
^!Q::
;Loop through functionality, will pause on Ctrl+Alt+W
Loop {
   Random(x) ;Set random x screen value
   Random(y) ;Set random y screen value
   Random(s) ;Set random sleep value
   MouseMove, xpos, ypos, mSpeed ;Move to random screen values
   Sleep, sval ;Sleep for random sleep value
} ;end loop





Random(val) {
   global xpos, ypos, sval, moveType, minPause, maxPause, move1x, move1y, move2x, move2y
   If (moveType = 0) {
      If (val = x) {
         Random, xpos, 0, A_ScreenWidth
      }
      If (val = y) {
      Random, ypos, 0, A_ScreenHeight
      }
   }
   If (moveType = 1) {
      If (val = x) {
         Random, xpos, move1x, move2x
      }
      If (val = y) {
         Random, ypos, move1y, move2y
      }
   }
   If (moveType = 2) {
      xpos := move1x
      ypos := move1y
   }
   If (val = s) {
      Random, sval, minPause, maxPause
   }
} ;end Random function
return

;Pause script on Ctrl+Alt+W
;-=-=-=-
^!W::Pause

;Exit script on Ctrl+Alt+E
;-=-=-=-
^!E::ExitApp