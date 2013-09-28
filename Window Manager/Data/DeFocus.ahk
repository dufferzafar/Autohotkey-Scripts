; Defocus - by thewer (http://spider4webdesign.deviantart.com/)
;
;------------------------------------------------------------------------------------------------------------------------------------------------------
; Settings|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;------------------------------------------------------------------------------------------------------------------------------------------------------
DetectHiddenWindows, Off ; They are hidden for a reason...
#WinActivateForce ; So you don't have to click onto the window after taskswitching to REALLY activate it
#NoEnv ;Avoids checking empty variables to see if they are environment variables (recommended for all new scripts)
#SingleInstance, Force ; Not running the script twice and getting in the way
SetBatchLines, -1 ;Determines how fast a script will run - fast
SetKeyDelay, 0
SetWinDelay, 0 ;    Sets the delay that will occur after each windowing command - None
coordmode mouse, screen ;Sets coordinate mode for various commands to be relative to either the active window or the screen
GoSub, ReadIni ; get stored settings
; Variables------------------------------------------------------------------------------------------------
ScriptPaused=0 ;start value (false) for variable stating skript status
Desktop=1 ;start value (true) for variable 'Desktop' - stating if windows have been minimized/restored
Defocused=0 ;start value (false) if a window is defocused = Sub Defocus has been run, is 0 if Sub ShowAll has been run
RLPressed=0 ; start value (false) if Right&Left Mousebuttons have been pressed
Jedi=0 ; start value (false) if Jedifocus is set
JediBottom = 0 ; start value (false) if JediWin is the most bottom one
CurrentDesktop := 2 ;Start value for Desktop (Amount of VirtualDesks = 3, so starting with middle one)
Expose_MaxWin := 20   ;   maximum number of windows to handle/thumbnails be shown for taskswitcher
Expose_Border := 2      ;   border between thumbs
win_list_old :=
;   GUI init ---------------------------------------------------------------------------------------------------------------
Gui, +AlwaysOnTop +Toolwindow +Owner +LastFound ;taskswitcher window: Maybe not Always on Top but bringing to foreground
Gui, Color, 000000
WinSet, Transparent, 225,
Gui, -Caption ; No Frame for taskswitcher window
Gui, Show, Hide w%A_ScreenWidth% h290 x0 y0 , »Expose«
WinGet, Expose_ID , ID
;   Second GUI init for Sliding Windows ------------------------------------------------------------------------------------
Gui, 2:+AlwaysOnTop +Toolwindow +Owner +LastFound
Gui, 2:Color, FF00FF
WinSet, TransColor, FF00FF 200, ;Set TransColor/Transparent before deleting caption to avoid problems
Gui, 2:-Caption ; No Frame
Gui, 2:Add, Picture,, %A_ScriptDir%\skins\%Skin%\BG_Slide.bmp
Gui, 2:Add, Picture,x9 y6, %A_ScriptDir%\skins\%Skin%\Screen_1.bmp
Gui, 2:Add, Picture,x159 y6, %A_ScriptDir%\skins\%Skin%\Screen_2.bmp
Gui, 2:Add, Picture,x309 y6, %A_ScriptDir%\skins\%Skin%\Screen_3.bmp
GuiControl, 2:Hide, %A_ScriptDir%\skins\%Skin%\Screen_1.bmp
GuiControl, 2:Hide, %A_ScriptDir%\skins\%Skin%\Screen_2.bmp
GuiControl, 2:Hide, %A_ScriptDir%\skins\%Skin%\Screen_3.bmp
Gui, 2:Show, Hide w460 h160 Center, »SlideWin«
WinGet, Slide_ID , ID
;   Third GUI init for Jedi Focus --------------------------------------------------------------------------------------
Gui, 3:+Toolwindow +Owner +LastFound +Disabled
Gui, 3:Color, 000000
WinSet, Transparent, %JediTransparency%,
Gui, 3:-Caption
Gui, 3:Show, Hide w%A_ScreenWidth% h%A_ScreenHeight% Center, »JediWin«
WinGet, Jedi_ID , ID
;   global variables for Expose ----------------------------------------------------------------------------------------
   Loop, %Expose_MaxWin% ;Loop over 20 possible windows: Create Texts etc.
  {
      Expose_WIN%A_Index% := true
      Gui, font, cFFFFFF s9, Arial   ;New for Label
      Gui, Add, Text,BackgroundTrans vText%A_Index% center r1 x0 y240,  ;New for Label
   }
   hdc_frontbuffer      := GetDC( Expose_ID )

   hdc_printwindow   := CreateCompatibleDC( hdc_frontbuffer )
   hbm_printwindow   := CreateCompatibleBitmap( hdc_frontbuffer, A_ScreenWidth, A_ScreenHeight )
   hbm_old            := SelectObject( hdc_printwindow, hbm_printwindow)

   hdc_thumbnails      := CreateCompatibleDC( hdc_frontbuffer )
   hbm_thumbnails   := CreateCompatibleBitmap( hdc_frontbuffer, A_ScreenWidth, A_ScreenHeight )
   hbm_old            := SelectObject( hdc_thumbnails, hbm_thumbnails )

   hdc_backbuffer      := CreateCompatibleDC( hdc_frontbuffer )
   hbm_backbuffer      := CreateCompatibleBitmap( hdc_frontbuffer, A_ScreenWidth, A_ScreenHeight )
   hbm_old            := SelectObject( hdc_backbuffer, hbm_backbuffer)

   hdc_desktop         := CreateCompatibleDC( hdc_frontbuffer )
   hbm_desktop         := CreateCompatibleBitmap( hdc_frontbuffer, A_ScreenWidth, A_ScreenHeight )
   hbm_old            := SelectObject( hdc_desktop, hbm_desktop )

; other global variables:
;     Expose_ID
;     Expose_Cols
;     Expose_WIN0
;     Expose_Border
;     win_id
;     x
;     y
;global variables for Working area----------------------------------------------------------------------------------------
;Didn't get 'Sysget to work, hence using DLL-call
;creating a variable (kind of array with 4 fields, each having 4...)) for holding the x1,y1,x2,y2 of the old working area
VarSetCapacity( NWA, 16 )
; SPI_GETWORKAREA for getting the work area used before starting TotalControl
;success :=
DllCall( "SystemParametersInfo", "uint", 0x30, "uint", 0, "uint", &NWA, "uint", 0 )
xleft := NumGet(NWA,0)
xright := NumGet(NWA,8)
yup := NumGet(NWA,4)
ydown := NumGet(NWA,12)
;MsgBox, % NumGet(NWA,0) "`n" NumGet(NWA,4) "`n" NumGet(NWA,8) "`n" NumGet(NWA,12)
; Menu ------------------------------------------------------------------------------------------------
; Menu, Tray, Icon , Defocus.ico ;only for script version - icons in compiled one are added differently
; Create Tray menu
Gosub, CreateMenu
GoSub, MenuCheck ;Checkmark items in menu according to ini-file/settings
; Hotkeys  ---------------------------------------------------------------------------------
Hotkey, LButton, HotLB
Hotkey, RButton Up, HotRBUp ;Hotkey, RButton Up, HotRBDown ;Suppressing rightclick menu after task switching
Hotkey, RButton & MButton, MoveWindow ;Needs bloody well timimg - both buttons must be pressed simultanously with RButton slightly before MButton
Hotkey, MButton & RButton, MoveWindow ;Therefore 2 hotkeys: Once RButton first, then MButton first
Hotkey, RButton & LButton, SlideWindow
;Hotkey, LButton & RButton, SlideWindow ;Using LButton is tricky....
Hotkey, RButton & WheelDown, NextWindow
Hotkey, RButton & WheelUp, LastWindow
If !TaskSwitcher
{
   Hotkey, ~RButton & WheelDown, Off
   Hotkey, ~RButton & WheelUp, Off
   Hotkey, RButton Up, Off
}
Hotkey, IfWinNotActive, ahk_id %Expose_ID% ; IMPORTANT: Hotkey, IfWin... will AFFECT ALL Hotkeys created after that command - for turning off IfWin...: leave out window title
Hotkey, ~MButton & WheelDown , Expose_Show ,AboveNormal
Hotkey, IfWinActive, ahk_id %Expose_ID%
Hotkey, LButton, Expose_Hide
If !ExposeWindows
{
  Hotkey, IfWinNotActive, ahk_id %Expose_ID%
   Hotkey, ~MButton & WheelDown, Off
}
; Events ------------------------------------------------------------------------------------
OnExit , CloseScript ; subroutine for restoring windows' transparency

;------------------------------------------------------------------------------------------------------------------------------------------------------
; Main program||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;------------------------------------------------------------------------------------------------------------------------------------------------------
; Restore all minimized windows for getting images to use with Expose
; WinGet, id, list,,, Program Manager
; Loop, %id%
; {
   ; this_id := id%A_Index%
   ; WinGet, MinState , MinMax, ahk_id %this_id%
   ; if (MinState = -1)
      ; WinRestore, ahk_id %this_id%
; }
; Defocs main program -----------------------------------------------------------------------------------------------------------
Loop {
   sleep RefreshTime
   ; Sensing your mousemovements
   ; No action when dragging windows!! - WB compatibility!!!! LButton down stopps transparency see sub 'Defocus'
   GetKeyState, RState, RButton, P ;R&LButton down stop transparency - P: Physical(real) state of the key
   if RState = D ;so far no check for JediFocus
   {
      if Defocused
      GoSub, ShowAll
      continue
   }
   WinGet, ActiveWin, ID, A ;gets handle of active window
  ; If Active window maximized: jump loop and hide JediFocus...
  WinGet, ActiveMax, MinMax, ahk_id %ActiveWin%
  If ActiveMax
  {
    if Jedi
      Gosub, JediOff
    if Defocused
      GoSub, ShowAll
    continue
  }
   MouseGetPos,,, MouseWin
   WinGetClass, MouseWin_class, ahk_id %MouseWin% ;maybe put classes in exclusion list as well?
   WinGetTitle, MouseWin_title, ahk_id %MouseWin%
   ; Make WB borders 'untraced': N_FRAME= Windowblinds' frames
   ; Check: Hovered Window is non-active window and not a WB-Frame
   If (ActiveWin <> MouseWin AND MouseWin_class <> "N_FRAME") ; AND MouseWin_title not in %NonFocus_list% : creates error if 'not in... is used with AND
   {
    ; Disable JediFocus at once or all other windows won't be recognized... OR: Send it to bottom and check if it's still hovered over
    WinSet, Bottom,, »JediWin« 
    JediBottom := 1 ; So one can check if it must send to the top again...
      ; Check: Hovered Window is non-active window AND not a WB-Frame AND not in NonFocus-list (Workaround)
      if HoverTime <> 0
         sleep HoverTime ;Time to activate 'Focus'
      MouseGetPos,,, MouseWin_2
    WinGetTitle, MouseWin_2_title, ahk_id %MouseWin_2%
    ;msgbox %MouseWin_2_title%
    if MouseWin_2 = %Jedi_ID% ;JediWin at Bottom - only true if hovering over Desktop
    {
      Gosub, JediOff
      MouseGetPos,,, MouseWin_2 ;Else MouseWin_2 = %MouseWin% will be true for JediWin, if hovering over Desktop/not hovering over a window
    }
;         msgbox %MouseWin_2%
      If MouseWin_title not in %NonFocus_list% ;JediWin is NOT in list
      {
         ; Checks if within the Hovertime Mousefocus has changed - only will 'defocus' if Mousefocus hasn't changed, so you must hover over a window for the Hovertime till Transparency takes effect
         If MouseWin_2 = %MouseWin% ;not true if hovering over desktop, see above...
         {
        WinGetPos,jx,jy,jw,jh, ahk_id %MouseWin%
        jx2 = jx + jw
        jy2 = jy+jh
        WinSet,Region, 0-0 A_ScreenWidth-0 A_ScreenWidth-A_ScreenHeight 0-A_ScreenHeight 0-0   jx-jy jx2-jy jx2-jy2 jx-jy2 jx-jy, »JediWin«
            if Autofocus
        {
          if JediFocus
          {
            ;WinSet,Region, 0-0 A_ScreenWidth-0 A_ScreenWidth-A_ScreenHeight 0-A_ScreenHeight 0-0   jx-jy jx2-jy jx2-jy2 jx-jy2 jx-jy, »JediWin«
            Gui 3:Show, NA
            WinSet, AlwaysOnTop, On, »JediWin«
            WinSet, AlwaysOnTop, Off, »JediWin«
            WinActivate ahk_id %MouseWin%       
            Gui 3:Show, NoActivate
            ;WinSet, Transparent, %JediTransparency%, »JediWin«
            Jedi=1
            JediBottom=0
          }
          Else
          {
            WinActivate ahk_id %MouseWin%
          }
        }
            else ;if !Defocused
        {
               Gosub, Defocus
        }
         }
      }
      ; Check: Hovered Window is non-active desktop
      Else if MouseWin_title = Program Manager ;Jedi is off then
      {
         ; make all windows transparent if no key pressed - if key pressed: Program Manager is active window
         if !Autofocus
         {   
            MouseGetPos,,, MouseWin
            ;if !Defocused
            Gosub, Defocus
         }   
      }
   }
  ;WORKAROUND NEEDED: 'if MouseWin_title not in %NonFocus_list% AND' : creates error if 'NOT IN'... is used with 'AND'
  ; Either use if...if...if syntax OR
  ; if MouseWin_title not in %NonFocus_list% => listcheck:= true else false
  ; if listcheck AND ....
   ; MouseWin_title = ActiveWinTitle OR MouseWin is WB-Frame, BUT IS NOT in NonFocus_list - both if all windows are still opaque and if some windows are already transparent
   Else if MouseWin_title not in %NonFocus_list% ;Desktop is in list - so hovering over it won't trigger that one
   {
    if (!Jedi Or JediBottom) ;OR if Jedi at the bottom...
    ;if !Jedi ;OR if Jedi at the bottom...
    {
      Gosub, JediOn 
      ;msgbox jb
    }
      if !Autofocus
    {
         if Defocused
        GoSub, ShowAll   ; if MouseWin_title = ActiveWinTitle OR MouseWin_title is in NonFocus_list (not Desktop) OR MouseWin is WB-Frame: make all windows opaque
    }
   }
   Else if MouseWin_class = WorkerW ;WorkerW is class of Desktop, if show desktop has been triggered...
   {   
    ; Gosub, JediOff not needed as should be hidden anyway
      GetKeyState, Deskstate, LButton
      if Deskstate = D
         Send #d ;Click on Desktop will minimize/restore all all open windows         
   }
  else if MouseWin_title = »JediWin« ;JediWin top of all others - maybe not disable it but deactivate it...
  {
    ;Gosub, JediOff
    SendInput ^{TAB}
  }
}

;------------------------------------------------------------------------------------------------------------------------------------------------------
; Subs Defocus ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;------------------------------------------------------------------------------------------------------------------------------------------------------

;Create Menu items
CreateMenu:
  Menu, tray, add, AutoFocus, MenuItem_AF
  Menu, tray, add, DeFocus, MenuItem_DF
  Menu, tray, add, JediFocus, MenuItem_JF
  Menu, tray, add, Show Desktop, MenuItem_SD
  Menu, tray, add, Minimize Mode, MenuItem_MM
  Menu, tray, add, Task Switcher, MenuItem_TS
  Menu, tray, add, Expose Windows, MenuItem_EW
  Menu, tray, add, Resize Windows, MenuItem_RW
  Menu, tray, add, Slide Windows, MenuItem_SW
  Menu, tray, add, Change Settings, MenuItem_CS
  Menu, tray, add, About, MenuItem_About
  Menu, tray, add, Pause Script, PauseScript
  Menu, tray, add, Exit, CloseScript
  Menu, tray, NoStandard
Return

;Read ini files for settings
ReadIni:
  IniRead, Skin   , Defocus.ini, Settings, Skin, default
  IniRead, HotkeyDelay   , Defocus.ini, Settings, HotkeyDelay, 100
  IniRead, MinGestureLength   , Defocus.ini, Settings, MinGestureLength, 5
  IniRead, DefocusWin   , Defocus.ini, Settings, DefocusWin, 1
  IniRead, Autofocus   , Defocus.ini, Settings, Autofocus, 0
  IniRead, ShowDesktop   , Defocus.ini, Settings, ShowDesktop, 1
  IniRead, MinimizeMode   , Defocus.ini, Settings, MinimizeMode, 1
  IniRead, TaskSwitcher   , Defocus.ini, Settings, TaskSwitcher, 1
  IniRead, ExposeWindows   , Defocus.ini, Settings, ExposeWindows, 1
  IniRead, WResize   , Defocus.ini, Settings, WResize, 1
  IniRead, Sliding   , Defocus.ini, Settings, Sliding, 1
  IniRead, HoverTime   , Defocus.ini, Settings, HoverTime, 0
  IniRead, RefreshTime   , Defocus.ini, Settings, RefreshTime, 100
  IniRead, Transparency   , Defocus.ini, Settings, Transparency, 50
  IniRead, MainTransparency   , Defocus.ini, Settings, MainTransparency, 255
  IniRead, JediTransparency   , Defocus.ini, Settings, JediTransparency, 180
  IniRead, JediFocus   , Defocus.ini, Settings, JediFocus, 1 
  IniRead, Steps   , Defocus.ini, Settings, Steps, 8
  IniRead, Exclusion_list, Defocus.ini, Settings, Exclusion_list
  IniRead, NonFocus_list, Defocus.ini, Settings, NonFocus_list
  IniRead, NonExposed_list, Defocus.ini, Settings, NonExposed_list 
  IniRead, NonSlided_list, Defocus.ini, Settings, NonSlided_list 
Return

Defocus:
  ; if Jedi
    ; Gosub, JediOff
  if DefocusWin
  {
     GetKeyState, state, LButton ;LButton down stops transparency
     if state <> D
     {
        if MouseWin_title not in %Exclusion_list%
           WinSet, Transparent, %MainTransparency%, ahk_id %MouseWin% ; Make sure Hover-Window gets opaque
        WinGet id, list
        ; Change transparency of all windows exept hovered and excluded ones
        Loop %id%
        {
           win_id := id%A_Index% ; A_index: Nr. of Loop iteration => this_id = id1, id2, ...
           WinGetTitle, this_title, ahk_id %win_id%
           WinGetClass, this_class, ahk_id %win_id%
           WinGet, this_transp, Transparent, ahk_id %win_id%
           if win_id = %MouseWin%
              break ; Breaks Loop - only windows above focused one are made transparent
           if this_title not in %Exclusion_list%
           {
              if this_class <> "N_FRAME"
              {
                 if this_transp <> %Transparency%
                    WinSet, Transparent, %Transparency%, ahk_id %win_id%            
              }
           }
        }
     }   
    Defocused=1
  }
Return

ShowAll:
   WinGet id, list ; Set all windows 100% Transparency
   Loop %id% ;stores all window handles in an array 'id' with id1 = first element, id2= second element, ... id1: topmost window
   {
      win_s_id := id%A_Index% ; %A_Index% is cycle nr of loop, so win_s_id is 'loop_NR'th element of id-array
      WinGetTitle, s_title, ahk_id %win_s_id%
      WinGetClass, s_class, ahk_id %win_s_id%
      WinGet, s_transp, Transparent, ahk_id %win_s_id%
      ; Fehlermeldung ...%Exclusion_list% contains an illegal character: due to wrong if-syntax
      If s_title not in %Exclusion_list%
      {
         If s_class <> "N_FRAME"
         {
            if s_transp <> %MainTransparency%
               WinSet, Transparent, %MainTransparency%, ahk_id %win_s_id%   
         }
      }
   }    
  Defocused=0
return

MinMaxWin:
   If (Desktop & ShowDesktop) {
      if MinimizeMode {
         WinMinimizeAll
      }
      else {
         Send #d
      }
      Desktop := 0
      sleep, 200
   }
   Else {
      if MinimizeMode {
         WinMinimizeAllUndo
      }
      else {
         ;msgbox wind
         Send #d
      }
      Desktop := 1
      WinGet, NowActiveWin, ID, A
      WinSet, Top,, ahk_id %NowActiveWin%
      sleep, 200
   }
return

NextWindow:
   WinGet nid, list ;stores all window handles in an array 'id' with id1 = first element, id2= second element, ... id1: topmost window %id%:Nr. of windows
  ;Make sure JediWin is not in list - either because in NonFocus list or because excluded here
   Loop %nid%
   {
      next_id := nid%A_Index% ; %A_Index% is cycle nr of loop, so win_s_id is 'loop_NR'th element of id-array
      WinGetTitle, next_title, ahk_id %next_id%
      If next_title not in %NonFocus_list%
         GroupAdd, WindowList, ahk_id %next_id%
   }    
   GroupActivate WindowList
  WinGet, MouseWin, ID, A ; So that JediOn is focussing on the newly activated window
  Gosub, JediOn
return

LastWindow:
   WinGet nid, list ;stores all window handles in an array 'id' with id1 = first element, id2= second element, ... id1: topmost window %id%:Nr. of windows
   Loop %nid%
   {
      ; last_nr := nid - A_Index + 1
      ; last_id := nid%last_nr%
      last_id := nid%A_Index%
      WinGetTitle, last_title, ahk_id %last_id%
      If last_title not in %NonFocus_list%
      {
         IfWinNotActive ahk_id %last_id%   
            GroupAdd, WindowList, ahk_id %last_id%      
      }
   }    
   GroupActivate, WindowList, R
  WinGet, MouseWin, ID, A ; So that JediOn is focussing on the newly activated window
  Gosub, JediOn
return

MoveWindow:
   MouseGetPos, xstart, ystart, MouseWinMove
  WinGetPos, xwin, ywin, wwin, hwin, ahk_id %MouseWinMove%
  sleep 100
  Stick_left := 0
  Stick_right := 0
  Stick_up := 0
  Stick_down := 0
  Loop
  {
    ;GetKeyState, RState, RButton, P
    GetKeyState, MState, MButton, P
    if MState = D
    {
      WinGetPos, xwin_now, ywin_now, wwin_now, hwin_now, ahk_id %MouseWinMove%
      MouseGetPos, xnew, ynew
      dx := xstart - xnew
      dy := ystart - ynew
      dx2 := dx
      dy2 := dy     
      dw := 0
      dh := 0
      if xwin_now+0 < xleft ; Sticking left
      {
        if Stick_left
        {
          if WResize
          {
            xwin := xleft-1
            dw := dx ; if sticking right: dw := dw-dx = dx-dx = 0       
            dx2 := 0 ; dx = 0 would disable sticking right...
          }
          Else
          {
            xwin := xleft-1
            dx2 := 0
          }
        }
        else
        {
          if dx > 0
          {
            MouseGetPos, xstart
            Stick_left := 1
          }
        }
      }
      if xwin_now+wwin_now > xright ; Sticking right
      {
        if Stick_right
        {
          if WResize
          {
            dw := dw-dx
            if Stick_left ; if sticking left, too: wwin_new := wwin_now = full wide, dx2 = dw = 0
              wwin := wwin_now
          }
          Else
          {
            dx2 := 0
          }
        }
        else
        {
          if dx < 0
          {
            MouseGetPos, xstart
            xwin := xwin_now
            Stick_right := 1
          }
        }     
      }
      if ywin_now+0 < yup ; Sticking up
      {
        if Stick_up
        {
          if WResize
          {
            ywin := yup-1
            dh := dy ; if sticking down: dh := dh-dy = dy-dy = 0       
            dy2 := 0 ; dy = 0 would disable sticking down...
          }
          Else
          {
            ywin := yup-1
            dy2 := 0
          }
        }
        else
        {
          if dy > 0
          {
            MouseGetPos, ,ystart
            Stick_up := 1
          }
        }
      } 
      if ywin_now+hwin_now > ydown ; Sticking down
      {
        if Stick_down
        {
          if WResize
          {
            dh := dh-dy
            if Stick_up ; if sticking left, too: wwin_new := wwin_now = full wide, dx2 = dw = 0
              hwin := hwin_now
          }
          Else
          {
            dy2 := 0
          }
        }
        else
        {
          if dy < 0
          {
            MouseGetPos, ,ystart
            ywin := ywin_now
            Stick_down := 1
          }
        }           
      }   
      xwin_new := xwin-dx2
      ywin_new := ywin-dy2
      wwin_new := wwin-dw
      hwin_new := hwin-dh
      WinMove, ahk_id %MouseWinMove% , , xwin_new, ywin_new, wwin_new, hwin_new
      ;MouseGetPos, xlast, ylast
    }
    else
    {
      break
    }
  }
return

SlideWindow:
  ;MsgBox, L+R
  MouseGetPos, x1, y1, WindowMaxRest
  sleep %HotkeyDelay%
  MouseGetPos, x2, y2
  deltaX := x2 - x1
  deltaY := y2 - y1
  ;Msgbox %deltaX% , %deltaY%
  if (deltaY < 0 and abs(deltaY) > abs(deltaX) and abs(deltaY) > %MinGestureLength%)
  {
    WinMaximize, A ;ahk_id WindowMaxRest   
  }
  else if (deltaY > %MinGestureLength% and abs(deltaY) > abs(deltaX))
  {
    WinGet, Maximized, MinMax, A
    if Maximized
    {
      WinRestore, A ;ahk_id WindowMaxRest
    }
    else
    {
      WinMinimize, A
    }
  }
  Else
    if deltaX > %MinGestureLength%
    {
      if Sliding
        Gosub, ShiftWindows_right
    }
    Else if deltaX < -%MinGestureLength%
    {
      if Sliding
        Gosub, ShiftWindows_left
    }
return

ShiftWindows_left:
  if CurrentDesktop < 3
  {
    CurrentDesktop := CurrentDesktop + 1
    GuiControl, 2:Show, %A_ScriptDir%\skins\%Skin%\Screen_%CurrentDesktop%.bmp
    Gui, 2:Show,, »SlideWin«   
    WinGet winsid, list
    Loop %winsid%
    {
      wins_id := winsid%A_Index% ; A_index: Nr. of Loop iteration => this_id = id1, id2, ...
      WinGetTitle, current_title, ahk_id %wins_id%
      WinGetPos, current_xwin,,current_wwin,, ahk_id %wins_id%
      WinGet, current_state, MinMax, ahk_id %wins_id%
      if current_title not in %NonSlided_list%
      {
        if current_state = -1 ;Do nothing with minimized windows? Minimized windows can't be moved, winactivate before - or: Hide, Unhide according to desktop?
        {
        }
        Else
        {
          Loop %Steps%
          {
            xwins_new := current_xwin - Floor(A_ScreenWidth / Steps * A_Index)
            WinMove, ahk_id %wins_id% , , xwins_new
            WinGetPos, c_xwin,,,, ahk_id %wins_id%
          }
        }
      }   
    }
  }
  Else
  {
    GuiControl, 2:Show, %A_ScriptDir%\skins\%Skin%\Screen_%CurrentDesktop%.bmp
    Gui, 2:Show,, »SlideWin«   
  }
  sleep, 100
  GuiControl, 2:Hide, %A_ScriptDir%\skins\%Skin%\Screen_%CurrentDesktop%.bmp
  Gui, 2:Hide 
Return

ShiftWindows_right:
  if CurrentDesktop > 1
  { 
    CurrentDesktop := CurrentDesktop - 1
    GuiControl, 2:Show, %A_ScriptDir%\skins\%Skin%\Screen_%CurrentDesktop%.bmp
    Gui, 2:Show,, »SlideWin«     
    WinGet winsid, list
    Loop %winsid%
    {
      wins_id := winsid%A_Index% ; A_index: Nr. of Loop iteration => this_id = id1, id2, ...
      WinGetTitle, current_title, ahk_id %wins_id%
      WinGetPos, current_xwin,,,, ahk_id %wins_id%
      if current_title not in %NonSlided_list%
      {
        if current_state = -1 ;Do nothing with minimized windows? Minimized windows can't be moved - or: Hide, Unhide according to desktop?
        {
        }
        Else
        {
          Loop %Steps%
          {
            xwins_new := current_xwin + Floor(A_ScreenWidth / Steps * A_Index)
            WinMove, ahk_id %wins_id% , , xwins_new
            WinGetPos, c_xwin,,,, ahk_id %wins_id%
          }
        }
      }   
    }
  }
  Else
  {
    GuiControl, 2:Show, %A_ScriptDir%\skins\%Skin%\Screen_%CurrentDesktop%.bmp
    Gui, 2:Show,, »SlideWin«   
  }
  sleep, 100
  GuiControl, 2:Hide, %A_ScriptDir%\skins\%Skin%\Screen_%CurrentDesktop%.bmp
  Gui, 2:Hide
Return

ShiftWindowIn:
  ;works ONLY if window not minimized... check with Expose_Hide
  if (Active_X < -20 AND Active_X > -2.2*%A_ScreenWidth%)
  {
    DShift := 0+(Floor(abs(Active_X) / A_ScreenWidth)+1)*A_ScreenWidth
    Loop %Steps%
    {
      xwins_new := Active_X + Floor(DShift / Steps * A_Index)
      WinMove, ahk_id %Active_id%, , xwins_new
    }
  }
  else if Active_X > %A_ScreenWidth%
  {
    DShift := 0+(Floor(Active_X / A_ScreenWidth))*A_ScreenWidth
    Loop %Steps%
    {
      xwins_new := Active_X - Floor(DShift / Steps * A_Index)
      WinMove, ahk_id %Active_id%, , xwins_new
    }
  }
  ; WinGetPos, Active_X, eY, eW, eH, ahk_id %Active_id%
  ; nmX := Active_X + eW/2
  ; nmY := eY + eH/2
  ; DllCall("SetCursorPos", int, nmX, int, nmY) 
Return

JediOff:
  Gui, 3:Show, Hide
  Jedi=0
Return

JediOn:
  if JediFocus
  {
    if !JediBottom ; or if Jedi ?
      WinSet, Transparent, 0, »JediWin«
    WinGetPos,jx,jy,jw,jh, ahk_id %MouseWin%
    jx2 = jx + jw
    jy2 = jy+jh
    WinSet,Region, 0-0 A_ScreenWidth-0 A_ScreenWidth-A_ScreenHeight 0-A_ScreenHeight 0-0   jx-jy jx2-jy jx2-jy2 jx-jy2 jx-jy, »JediWin«
    Gui 3:Show,
    ;WinActivate ahk_id %Jedi_ID%
    WinSet, AlwaysOnTop, On, »JediWin«
    ;WinSet, Top,, »JediWin«
    WinSet, AlwaysOnTop, Off, »JediWin«
    WinActivate ahk_id %MouseWin%
    WinSet, Transparent, %JediTransparency%, »JediWin«
    ;Gui 3:Show, NoActivate
    Jedi=1
    JediBottom=0
    ;msgbox jon
  }
Return

HotLB:
  sleep %HotkeyDelay% ; prolong if people having difficulties with pressing buttons simultaneously - or state in ini.file
  GetKeyState, RLState, RButton, P
  ;msgbox %MouseWin_class%
  if RLState = D
  {
    RLPressed := 1
    Gosub, SlideWindow
    return
  }
  ; MouseWin_title has been assigned to in main program - maybe better not to check again (as will cost time) - or assign again in first line of sub before sleep
  if MouseWin_title = Program Manager
  {
    GoSub, MinMaxWin
  }
  Else if MouseWin_class = Shell_TrayWnd ; Check if Taskbar is left clicked... workaround for task button click
  {
    Click down left
    KeyWait, LButton
    Click up left
    sleep 200
    WinGet, Active_id, ID, A
    WinGetPos, Active_X,,,, ahk_id %Active_id%
    lb := -10
    ub := A_Screenwidth+10
    if Active_X not between %lb% and %ub%
      GoSub, ShiftWindowIn
  }
  else
  {
    Click down left
    KeyWait, LButton
    Click up left
  }
  ;KeyWait, RButton
  ;Gosub, HotRBUp
return

HotRBUp:
  if !RLPressed
    Send {RButton} ; Click down right: would HOLD down right button till released (click up right)
  RLPressed := 0
return
;------------------------------------------------------------------------------------------------------------------------------------------------------
; Subs Expose ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;------------------------------------------------------------------------------------------------------------------------------------------------------
; Mod from holomind's/smurth's Expose scripts
; For MINIMIZED WINDOWS:
; Maybe Try
; winlist ID...
; If Win minimized
; WinHide
; WinRestore;
; Screenshot
; WinMinimize
; Winshow....
Expose_Show:
   if Expose_ListWin() {            ; show thumbs only if there's at least one window
      SetStretchBltMode( hdc_thumbnails, 4 )
      Gui Show ;,, »Expose«
      ;WinSet, AlwaysOnTop, On, »Expose«
      Expose_ShowWin()
      MouseMove, A_ScreenWidth/2, 145
   }
Return


Expose_ListWin()
{

Global   Expose_ID ; Define Globals - Functions can only access those variables created outside of them that are defined as globals
Global   NonExposed_list
   WinGet id, list
   win_list :=
   Loop %id% {
      win_id := id%A_Index%
     WinGetTitle, this_title, ahk_id %win_id%
;      WinGet, style, Style, ahk_id %win_id%         ; ignore windows without title bar
;     if ( style & 0xC00000 ) and ( win_id <> Expose_ID ) {
     if ( win_id <> Expose_ID ) {
      if this_title not in %NonExposed_list%
         win_list := win_list . win_id . ","
    }
   }
   StringTrimRight win_list, win_list, 1
   Sort win_list, D,   ; keep positions of thumbnails
   Return win_list
}


Expose_ShowWin()
{
Global   Expose_ID  ; Define Globals - Functions can only access those variables created outside of them that are defined as globals
      , Expose_Cols
      , Expose_WIN0
      , Expose_MaxWin
      , Expose_Border
      , hdc_frontbuffer
      , hdc_backbuffer
      , hdc_printwindow
      , hdc_thumbnails
      , win_list_old
      , hdc_desktop
  Gosub, JediOff
  win_list := Expose_ListWin()         ; get list of windows' id
  StringSplit, num_win, win_list, `,
  num_win := num_win0               ; count windows
  Expose_Cols := ceil(num_win)
  thumb_w := A_ScreenWidth  // Expose_Cols
  thumb_h := 240
  screen_ratio := A_ScreenWidth / 240 / Expose_Cols
  Loop Parse, win_list, `,
  {
    Expose_WIN%A_Index% := A_LoopField         ; store window's id
    WinGetPos,,, w%A_Index%, h%A_Index%, ahk_id %A_LoopField%
    win_ratio := w%A_Index% / h%A_Index%
    If (win_ratio < screen_ratio)
    {      ; tall window
      thumb_h%A_Index% := thumb_h - 2*Expose_Border
      thumb_w%A_Index% := Floor(thumb_w * win_ratio / screen_ratio) - 2*Expose_Border
    }
    Else
    {                                 ; wide window
      thumb_w%A_Index% := thumb_w - 2*Expose_Border
      thumb_h%A_Index% := Floor(thumb_h * screen_ratio / win_ratio) - 2*Expose_Border
    }
    if ( thumb_w%A_Index% > w%A_Index% or thumb_h%A_Index% > h%A_Index% )
    {
      thumb_w%A_Index% := w%A_Index%
      thumb_h%A_Index% := h%A_Index%
    }
  }
  BitBlt( hdc_thumbnails, 0, 0, A_ScreenWidth, 240, hdc_desktop, 0, 0 , 0xCC0020)
  ;Get values for old images case a window is minimized
  StringSplit, num_win_old, win_list_old, `,
  num_win_old := num_win_old0               ; count windows
   Expose_Cols_old := ceil(num_win_old)
  thumb_w_old := A_ScreenWidth  // Expose_Cols_old
  thumb_h_old := 240
  Loop %num_win%
  {
    pos_x := thumb_w * Mod(A_Index-1,Expose_Cols)
    pos_y := 0
    Win_Index := Expose_WIN%A_Index%
      WinGetTitle, this_title, ahk_id %Win_Index%; Getting window's id for label
    WinGet, state, MinMax, ahk_id %Win_Index%      ; Paint something else for minimized windows - see Expose_Show comments for alternate solution
    if ( state = "-1" )
    {
         Loop Parse, win_list_old, `,
         {
            if (Win_Index = A_LoopField)
        {
               win_ratio_old := thumb_w_old / thumb_h_old
               If (win_ratio_old < screen_ratio)
          {      ; tall window
                  thumb_h_new := thumb_h ; - 2*Expose_Border
                  thumb_w_new := Floor(thumb_w * win_ratio_old / screen_ratio) ; - 2*Expose_Border
               }
               Else
          {                                 ; wide window
                  thumb_w_new := thumb_w ; - 2*Expose_Border
                  thumb_h_new := Floor(thumb_h * screen_ratio / win_ratio_old) ; - 2*Expose_Border
               }
               if ( thumb_w_new > thumb_w_old or thumb_h_new > thumb_h_old )
          {  ;Maybe too much - leave out this case???
                  thumb_w_new := thumb_w_old
                  thumb_h_new := thumb_h_old
               }
               hdc_target := hdc_thumbnails
               StretchBlt( hdc_target , pos_x + ( thumb_w - thumb_w_new ) // 2
                   , pos_y + ( thumb_h - thumb_h_new ) // 2
                   , thumb_w_new
                   , thumb_h_new
                   ,hdc_backbuffer, (A_Index - 1) * thumb_w_old, 0, thumb_w_old, thumb_h_old ,0xCC0020) ; SRCCOPY          
            }
         }
      }         
      Else
    {
      PrintWindow( Expose_WIN%A_Index%, hdc_printwindow, 0) ; 0=window, 1=Child(no toolbars)
      hdc_target := hdc_thumbnails
      StretchBlt( hdc_target , pos_x + ( thumb_w - thumb_w%A_Index% ) // 2
                     , pos_y + ( thumb_h - thumb_h%A_Index% ) // 2
                     , thumb_w%A_Index%
                     , thumb_h%A_Index%
                     ,hdc_printwindow, 0, 0, w%A_Index%, h%A_Index% ,0xCC0020) ; SRCCOPY
      }
    BitBlt( hdc_frontbuffer, 0 , 0 , A_ScreenWidth, 240 ,hdc_thumbnails,  0 , 0 , 0xCC0020) ;( hdc_frontbuffer, 0 , 0 , A_ScreenWidth, A_ScreenHeight ,hdc_thumbnails,  0 , 0 , 0xCC0020) ; flip
     GuiControl, Move, Text%A_Index%, center x%pos_x% w%thumb_w%
     GuiControl, Text, Text%A_Index%, %this_title%
  }
   EmptyLabels := Expose_MaxWin - num_win
   Loop, %EmptyLabels%
  {
      nr := A_Index+num_win ; +1
      GuiControl, Text, Text%nr%,
   }
   win_list_old := win_list ;Store winlist for getting images of minimized windows
   BitBlt( hdc_backbuffer, 0 , 0 , A_ScreenWidth, 240 ,hdc_frontbuffer,  0 , 0 , 0xCC0020)
}


Expose_Hide:
  MouseGetPos Mx, My
  SendInput ^{TAB}
  Gui, Hide
  Active_id := 1 + Mx*Expose_Cols//A_ScreenWidth + My//A_ScreenHeight * Expose_Cols
  Active_id := Expose_WIN%Active_id%
  Gosub, JediOn
  WinActivate,ahk_id %Active_id%
  WinGetPos, Active_X, eY, eW, eH, ahk_id %Active_id%
  RightBound := A_ScreenWidth-8
  if Active_X < -10
  {
    GoSub, ShiftWindowIn
  }
  else if Active_X > %RightBound%
  {
    GoSub, ShiftWindowIn
  }
  Else
  {
    nmX := Active_X + eW/2
    nmY := eY + eH/2
    DllCall("SetCursorPos", int, nmX, int, nmY)
  }
  ;MouseMove, nmX, nmY
Return

;------------------------------------------------------------------------------------------------------------------------------------------------------
; Menu Items|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;------------------------------------------------------------------------------------------------------------------------------------------------------
MenuCheck:
if Autofocus
   Menu, tray, Check, AutoFocus
else
   Menu, tray, Uncheck, AutoFocus
if DefocusWin and !Autofocus
   Menu, tray, Check, DeFocus
else
   Menu, tray, Uncheck, DeFocus
if JediFocus
   Menu, tray, Check, JediFocus
else
   Menu, tray, Uncheck, JediFocus 
if ShowDesktop
   Menu, tray, Check, Show Desktop
else
   Menu, tray, Uncheck, Show Desktop
if MinimizeMode
   Menu, tray, Check, Minimize Mode
else
   Menu, tray, Uncheck, Minimize Mode
if TaskSwitcher
   Menu, tray, Check, Task Switcher
else
   Menu, tray, Uncheck, Task Switcher
if ExposeWindows
   Menu, tray, Check, Expose Windows
else
   Menu, tray, Uncheck, Expose Windows
if WResize
   Menu, tray, Check, Resize Windows
else
   Menu, tray, Uncheck, Resize Windows
if Sliding
   Menu, tray, Check, Slide Windows
else
   Menu, tray, Uncheck, Slide Windows 
return

MenuItem_AF:
   Autofocus := !Autofocus
   GoSub, MenuCheck
   if Defocused
      GoSub, ShowAll ; Making sure all windows are opaque again before setting Autofocus=true
return

MenuItem_DF:
   DefocusWin := !DefocusWin
   GoSub, MenuCheck
   if Defocused
      GoSub, ShowAll ; Making sure all windows are opaque again before setting DefocusWin=false
return

MenuItem_JF:
   JediFocus := !JediFocus
   GoSub, MenuCheck
return

MenuItem_SD:
   ShowDesktop := !ShowDesktop
   GoSub, MenuCheck
return

MenuItem_MM:
   MinimizeMode := !MinimizeMode
   GoSub, MenuCheck
return

MenuItem_TS:
   TaskSwitcher := !TaskSwitcher
   GoSub, MenuCheck
   If TaskSwitcher
   {
    Hotkey, IfWinActive,
      Hotkey, ~RButton & WheelDown, On
      Hotkey, ~RButton & WheelUp, On
      Hotkey, RButton, On
   }
   else
   {
    Hotkey, IfWinActive,
      Hotkey, ~RButton & WheelDown, Off
      Hotkey, ~RButton & WheelUp, Off
      Hotkey, RButton, Off
   }
return

MenuItem_EW:
   ExposeWindows := !ExposeWindows
   GoSub, MenuCheck
  If ExposeWindows
   {
    Hotkey, IfWinNotActive, ahk_id %Expose_ID%
      Hotkey, ~MButton & WheelDown, On
   }
   else
   {
    Hotkey, IfWinNotActive, ahk_id %Expose_ID%
      Hotkey, ~MButton & WheelDown, Off
   }
return

MenuItem_RW:
   WResize := !WResize
   GoSub, MenuCheck
return

MenuItem_SW:
   Sliding := !Sliding
   GoSub, MenuCheck
return

MenuItem_CS:
   Run Defocus.ini
return

MenuItem_About:
   Msgbox, Defocus by thewer - http://spider4webdesign.deviantart.com/
return

;------------------------------------------------------------------------------------------------------------------------------------------------------
; Close/Pause Script|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;------------------------------------------------------------------------------------------------------------------------------------------------------

PauseScript:
   ScriptPaused := !ScriptPaused
   if ScriptPaused
  {
      Menu, tray, Check, Pause Script
    Suspend, On
  } 
   else
  {
      Menu, tray, Uncheck, Pause Script      
    Suspend, Off
  }
   WinGet id, list ; Set all windows 100% Transparency
   Loop %id% ;stores all window handles in an array 'id' with id1 = first element, id2= second element, ... id1: topmost window
   {
      win_s_id := id%A_Index% ; %A_Index% is cycle nr of loop, so win_s_id is 'loop_NR'th element of id-array
      WinGetTitle, s_title, ahk_id %win_s_id%
      WinGetClass, s_class, ahk_id %win_s_id%
      WinGet, s_transp, Transparent, ahk_id %win_s_id%
      ; Fehlermeldung ...%Exclusion_list% contains an illegal character: due to wrong if-syntax
      If s_title not in %Exclusion_list%
      {
         If s_class <> "N_FRAME"
         {
            if s_transp <> 255
               WinSet, Transparent, 255, ahk_id %win_s_id%   
         }
      }
   }    
   Pause
Return


; When closing the script
CloseScript:
   ; if Defocused
      ; GoSub, ShowAll
   WinGet id, list ; Set all windows 100% Transparency
   Loop %id% ;stores all window handles in an array 'id' with id1 = first element, id2= second element, ... id1: topmost window
   {
      win_s_id := id%A_Index% ; %A_Index% is cycle nr of loop, so win_s_id is 'loop_NR'th element of id-array
      WinGetTitle, s_title, ahk_id %win_s_id%
      WinGetClass, s_class, ahk_id %win_s_id%
      WinGet, s_transp, Transparent, ahk_id %win_s_id%
      ; Fehlermeldung ...%Exclusion_list% contains an illegal character: due to wrong if-syntax
      If s_title not in %Exclusion_list%
      {
         If s_class <> "N_FRAME"
         {
            if s_transp <> 255
               WinSet, Transparent, 255, ahk_id %win_s_id%   
         }
      }
   }       
  ; Deleting TaskSwitcher GUI, DCs
   Gui, Destroy
   ReleaseDC( Expose_ID, hdc_frontbuffer )
   ReleaseDC( Expose_ID, hdc_copy )
   DeleteObject( hbm_printwindow )
   DeleteDC( hdc_printwindow )
   DeleteObject( hbm_thumbnails )
   DeleteDC( hdc_thumbnails )
   DeleteObject( hbm_backbuffer )
   DeleteDC( hdc_backbuffer )
   DeleteObject( hbm_desktop )
   DeleteDC( hdc_desktop )   
   ExitApp
   
;------------------------------------------------------------------------------------------------------------------------------------------------------
;  Subfunctions for ExposeMod |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||<<
;------------------------------------------------------------------------------------------------------------------------------------------------------
 
GetDC( hw ) {
   return DLLCall("GetDC", UInt, hw )
}

CreateDC( driver,device,output,mode  ) {
   return DLLCall("GetDC", UInt, driver, UInt, device, UInt, output, UInt, mode )
}

SetStretchBltMode( hdc , value ) {
     return DllCall("gdi32.dll\SetStretchBltMode", UInt,hdc, "int",value)
}

CreateCompatibleDC( hdc ) {
   return DllCall("gdi32.dll\CreateCompatibleDC", UInt,hdc)
}

CreateCompatibleBitmap( hdc , w, h ) {
     return DllCall("gdi32.dll\CreateCompatibleBitmap", UInt,hdc, Int,w, Int,h)
}

SelectObject( hdc , hbm ) {
   return DllCall("gdi32.dll\SelectObject", UInt,hdc, UInt,hbm)
}

DeleteObject( hbm ) {
   return DllCall("gdi32.dll\DeleteObject", UInt,hbm)   
}

DeleteDC( hdc ) {
   return DllCall("gdi32.dll\DeleteDC", UInt,hdc )
}

ReleaseDC( hwnd, hdc ) {
   return DllCall("gdi32.dll\ReleaseDC", UInt,hwnd,UInt,hdc )
}

PrintWindow( window_id , hdc , mode ) {
   return DllCall("PrintWindow", UInt, window_id , UInt,hdc, UInt, mode)
}

StretchBlt( hdc_dest , x1, y1, w1, h1, hdc_source , x2, y2, w2, h2 , mode) {
   return DllCall("gdi32.dll\StretchBlt"
          , UInt,hdc_dest  , Int,x1, Int,y1, Int,w1, Int,h1
             , UInt,hdc_source, Int,x2, Int,y2, Int,w2, Int,h2
          , UInt,mode)
}

BitBlt( hdc_dest, x1, y1, w1, h1 , hdc_source, x2, y2 , mode ) {
   return DllCall("gdi32.dll\BitBlt"
          , UInt,hdc_dest   , Int, x1, Int, y1, Int, w1, Int, h1
             , UInt,hdc_source    , Int, x2, Int, y2
          , UInt, mode)
}