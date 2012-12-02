Menu, TRAY, Icon, Mouse Gestures.ico
Menu, TRAY, Tip, Mouse Gestures


; Step 1: Load Startup Settings
;===============================================================
#SingleInstance force
WindowID = 0
CoordMode, Mouse, Screen
Disabled = 0

; Load Startup Settings
;-------------------------------------------------------------
INIRead, ScriptTimeStart, Mouse Gestures.ini, Settings, TimeStart, 100
INIRead, ScriptTimeEnd, Mouse Gestures.ini, Settings, TimeEnd, 0
INIRead, MouseSensitivityAngle, Mouse Gestures.ini, Settings, SensitivityAngle, 40
INIRead, MouseSensitivityPoints, Mouse Gestures.ini, Settings, SensitivityPoints, 5

; Load Shotcuts
;-------------------------------------------------------------
GestureNumber = 0
Loop
{
  GestureNumber++

  INIRead, GestureName, Mouse Gestures.ini, Gesture %GestureNumber%, Name, *
  If GestureName = *
    Break

  INIRead, GestureShortcut, Mouse Gestures.ini, Gesture %GestureNumber%, Shortcut, ERROR
  If GestureShortcut <>
    If GestureShortcut <> 0
	  If GestureShortcut <> ERROR
	    Hotkey, %GestureShortcut%, GestureShortcut
}

; Step 2: Gather Mouse Positionment Information
;===============================================================
~Ctrl::
  If Disabled = 0
  {
    Menu, TRAY, Icon, Mouse Gestures4.ico
    Menu, TRAY, Tip, Mouse Gestures (disabled)
    Hotkey, RButton, Off
    Disabled = 1
  }
  Else
  {
    Menu, TRAY, Icon, Mouse Gestures.ico
    Menu, TRAY, Tip, Mouse Gestures
    Hotkey, RButton, On
    Disabled = 0
  }
Return

RButton::
  ; Load Startup Settings
  ;-------------------------------------------------------------
  INIRead, ScriptTimeStart, Mouse Gestures.ini, Settings, TimeStart, 100
  INIRead, ScriptTimeEnd, Mouse Gestures.ini, Settings, TimeEnd, 0
  INIRead, MouseSensitivityAngle, Mouse Gestures.ini, Settings, SensitivityAngle, 40
  INIRead, MouseSensitivityPoints, Mouse Gestures.ini, Settings, SensitivityPoints, 5

  ; Load Shotcuts
  ;-------------------------------------------------------------
  GestureNumber = 0
  Loop
  {
    GestureNumber++
  
    INIRead, GestureName, Mouse Gestures.ini, Gesture %GestureNumber%, Name, *
    If GestureName = *
      Break
  
    INIRead, GestureShortcut, Mouse Gestures.ini, Gesture %GestureNumber%, Shortcut, ERROR
    If GestureShortcut <>
      If GestureShortcut <> 0
        If GestureShortcut <> ERROR
          Hotkey, %GestureShortcut%, GestureShortcut
  }

  ; Detect if the mouse button is being hold or being released
  ;-------------------------------------------------------------
  GetKeyState, ButtonState, RButton, P
  If ButtonState = U
  {
    WindowID = 0
    Return
  }

  ; Detect if the mouse button is being pressed or released for the first time
  ;-------------------------------------------------------------
  If WindowID = 0
  {
    MousePosNumber = 0
    MouseGetPos, MousePosX%MousePosNumber%, MousePosY%MousePosNumber%, WindowID

    StringTrimLeft, MousePosXMin, MousePosX%MousePosNumber%, 0
    StringTrimLeft, MousePosXMax, MousePosX%MousePosNumber%, 0
    StringTrimLeft, MousePosYMin, MousePosY%MousePosNumber%, 0
    StringTrimLeft, MousePosYMax, MousePosY%MousePosNumber%, 0
  }

  SetTimer, ButtonHold, 10
  Return

  ButtonHold:

  ; Detect Points and Rectangle Extremes
  ;-------------------------------------------------------------
  MousePosNumberPrev = %MousePosNumber%
  MousePosNumber++

  MouseGetPos, MousePosX%MousePosNumber%, MousePosY%MousePosNumber%
  StringTrimLeft, MousePosX, MousePosX%MousePosNumber%, 0
  StringTrimLeft, MousePosY, MousePosY%MousePosNumber%, 0
  StringTrimLeft, MousePosXPrev, MousePosX%MousePosNumberPrev%, 0
  StringTrimLeft, MousePosYPrev, MousePosY%MousePosNumberPrev%, 0

  If MousePosX = %MousePosXPrev%
    If MousePosY = %MousePosYPrev%
    {
      MousePosX%MousePosNumber% = -1
      MousePosY%MousePosNumber% = -1
      MousePosNumber--
    }

  If MousePosX > -1
  {
    If MousePosXMax <= %MousePosX%
      MousePosXMax = %MousePosX%

    If MousePosXMin >= %MousePosX%
      MousePosXMin = %MousePosX%
  }

  If MousePosY > -1
  {
    If MousePosYMax <= %MousePosY%
      MousePosYMax = %MousePosY%

    If MousePosYMin >= %MousePosY%
      MousePosYMin = %MousePosY%
  }

  ; Detect if the mouse button is being hold or being released
  ;-------------------------------------------------------------
  GetKeyState, MouseButtonState2, RButton, P
  If MouseButtonState2 = D
  {
     TimeOfActivation = %A_TimeSinceThisHotkey%
     Goto, ButtonHold
  }

  SetTimer, ButtonHold, off

  ; Make normal clicks work (still needs improvement)
  ;-------------------------------------------------------------
  If ScriptTimeStart = 0
    ScriptTimeStart = 100
  If TimeOfActivation <= %ScriptTimeStart%
  {
    MouseClick, RIGHT, %MousePosX0%, %MousePosY0%, 1, 0, D
    MouseClick, RIGHT, %MousePosX%, %MousePosY%, 1, 0, U
    MousePosNumber = 0
    WindowID = 0
    Return
  }

  If TimeOfActivation >= %ScriptTimeEnd%
  {
    If ScriptTimeEnd <> 0
    {
      MouseClick, RIGHT, %MousePosX0%, %MousePosY0%, 1, 0, D
      MouseClick, RIGHT, %MousePosX%, %MousePosY%, 1, 0, U

      MousePosNumber = 0
      WindowID = 0
      Return
    }
  }

  If MousePosX1 = -1
  {
    MouseClick, RIGHT, 0, 0, 1, 0,, R
    MousePosNumber = 0
    WindowID = 0
    Return
  }

  ; Calculate the total number of movements and rect extremes
  ;-------------------------------------------------------------
  MousePosNumberTotal = %MousePosNumber%

  MousePosNumber = 0
  WindowID = 0

  MouseRectWidth = %MousePosXMax%
  MouseRectWidth -= %MousePosXMin%
  MouseRectHeight = %MousePosYMax%
  MouseRectHeight -= %MousePosYMin%

; Step 3: Gather Gestures and Symbols Information from INI File
;===============================================================
  GestureNumber = 0

  Loop
  {
    Init:

  ; Read Gesture Settings
  ;-------------------------------------------------------------
    GestureNumber++

    INIRead, GestureName, Mouse Gestures.ini, Gesture %GestureNumber%, Name, *
    If GestureName = *
      Goto SymbolNotRecognized
    INIRead, GestureSymbol, Mouse Gestures.ini, Gesture %GestureNumber%, SymbolNumber, *
    If GestureSymbol = *
      Goto SymbolNotRecognized
    Else
      SymbolNumber = %GestureSymbol%
    INIRead, GestureShortcut, Mouse Gestures.ini, Gesture %GestureNumber%, Shortcut, ERROR
    If GestureShortcut <> 0
      If GestureShortcut <>
        If GestureShortcut <> ERROR
          Hotkey, %GestureShortcut%, GestureShortcut

  ; Read Symbol Settings
  ;-------------------------------------------------------------
    SymbolPosNumber = -1
    SymbolININumber = 0

    INIRead, SymbolName, Mouse Gestures.ini, Symbol %SymbolNumber%, Name, *
    If SymbolName = *
      Return

  ; Detect Symbol Points and Rect Extremes
  ;-------------------------------------------------------------
    Loop
    {
      SymbolPosNumberPrev = %SymbolPosNumber%
      If SymbolPosNumberPrev <= -1
        SymbolPosNumberPrev = 0
      SymbolPosNumber++
      SymbolININumber++

      INIRead, SymbolPos, Mouse Gestures.ini, Symbol %SymbolNumber%, Pos%SymbolININumber%,*
      If SymbolPos = *
      {
        SymbolPosNumber--
        SymbolININumber--
        Break
      }

      StringGetPos, Temp, SymbolPos,.
      If ErrorLevel = 1
        Return
      StringLeft, SymbolPosX%SymbolPosNumber%, SymbolPos, %Temp%
      StringLen, Temp2, SymbolPos
      Temp2--
      Temp2 -= %Temp%
      StringRight, SymbolPosY%SymbolPosNumber%, SymbolPos, %Temp2%

      StringTrimLeft, SymbolPosX, SymbolPosX%SymbolPosNumber%, 0
      StringTrimLeft, SymbolPosY, SymbolPosY%SymbolPosNumber%, 0

      If SymbolPosNumber = 0
      {
        StringTrimLeft, SymbolPosX, SymbolPosX%SymbolPosNumber%, 0
        SymbolPosXMax = %SymbolPosX%
        SymbolPosXMin = %SymbolPosX%
        StringTrimLeft, SymbolPosY, SymbolPosY%SymbolPosNumber%, 0
        SymbolPosYMax = %SymbolPosY%
        SymbolPosYMin = %SymbolPosY%
      }
      Else
      {
        StringTrimLeft, SymbolPosXPrev, SymbolPosX%SymbolPosNumberPrev%, 0
        StringTrimLeft, SymbolPosYPrev, SymbolPosY%SymbolPosNumberPrev%, 0
	    If SymbolPosX = %SymbolPosXPrev%
	      If SymbolPosY = %SymbolPosYPrev%
	      {
		    SymbolPosX%SymbolPosNumber% = -1
		    SymbolPosY%SymbolPosNumber% = -1
		    SymbolPosNumber--
	      }

	    If SymbolPosX > -1
	    {
	      If SymbolPosXMax <= %SymbolPosX%
		    SymbolPosXMax = %SymbolPosX%

	      If SymbolPosXMin >= %SymbolPosX%
		    SymbolPosXMin = %SymbolPosX%
	    }

	    If SymbolPosY > -1
	    {
	      If SymbolPosYMax <= %SymbolPosY%
		    SymbolPosYMax = %SymbolPosY%

	      If SymbolPosYMin >= %SymbolPosY%
		    SymbolPosYMin = %SymbolPosY%
	    }
      }
    }

  ; Calculate the total number of movements and rect extremes
  ;-------------------------------------------------------------
    SymbolPosNumberTotal = %SymbolPosNumber%
    SymbolPosNumberTotal++

    SymbolRectWidth = %SymbolPosXMax%
    SymbolRectWidth -= %SymbolPosXMin%
    SymbolRectHeight = %SymbolPosYMax%
    SymbolRectHeight -= %SymbolPosYMin%

    SymbolPosNumber = 0

  ; Adjust the points to match the user's screen:
  ; X = 0 -> 800 (example) from left (already correct).
  ; Y = 0 -> 640 (example) from bottom.
  ;-------------------------------------------------------------
    Loop
    {
      If SymbolPosNumber >= %SymbolPosNumberTotal%
        Break
      StringTrimLeft, SymbolPosY, SymbolPosY%SymbolPosNumber%, 0
      Y = %SymbolPosY%
      YMax = %SymbolPosYMax%
      YMin = %SymbolPosYMin%
      Gosub, InvertPoint
      SymbolPosY%SymbolPosNumber% = %ResultY%
      SymbolPosNumber++
    }

; Step 4: Integrate The Information To Detect If The Symbol
; The User Activated Exists
;===============================================================
    MouseTransNumPoints = 0

  ; Quit if the movements aren't enough (Needs to be reconsiderated)
  ;-------------------------------------------------------------
    SymbolPosNumber = 0
    MousePosNumber = 0

    Loop
    {
      If MousePosX%MousePosNumber% = -1
	    If MousePosY%MousePosNumber% = -1
	      Break

      MousePosNumberTotal--
      SymbolPosNumberTotal--
      If SymbolPosNumber >= %SymbolPosNumberTotal%
        If MousePosNumber >= %MousePosNumberTotal%
          Goto SymbolRecognized
      MousePosNumberTotal++
      SymbolPosNumberTotal++

      MousePosNumberTotal--
      If MousePosNumber >= %MousePosNumberTotal%
      {
        MousePosNumberTotal++
	    Break
	  }
      MousePosNumberTotal++

      SymbolPosNumberTotal--
      If SymbolPosNumber >= %SymbolPosNumberTotal%
	    SymbolPosNumber--
      SymbolPosNumberTotal++

      MousePosNumber++
      StringTrimLeft, X1, MousePosX%MousePosNumber%, 0
      StringTrimLeft, Y1, MousePosY%MousePosNumber%, 0
      MousePosNumber--
      StringTrimLeft, X2, MousePosX%MousePosNumber%, 0
      StringTrimLeft, Y2, MousePosY%MousePosNumber%, 0
      Gosub, AngleDetection
      MousePosAngle = %Result%

      SymbolPosNumber++
      StringTrimLeft, X1, SymbolPosX%SymbolPosNumber%, 0
      StringTrimLeft, Y1, SymbolPosY%SymbolPosNumber%, 0
      SymbolPosNumber--
      StringTrimLeft, X2, SymbolPosX%SymbolPosNumber%, 0
      StringTrimLeft, Y2, SymbolPosY%SymbolPosNumber%, 0
      Gosub, AngleDetection
      SymbolPosAngle = %Result%

      MouseTransAngle = %MousePosAngle%
      MouseTransAngle -= %SymbolPosAngle%
      If MouseTransAngle < 0
	    MouseTransAngle *= -1

      If MouseTransAngle > 180
      {
	    MouseTransAngle -= 360
	    MouseTransAngle *= -1
      }

      ;MsgBox %GestureName%: "%MouseTransNumPoints% & %SymbolPosNumberTotal%" %MousePosAngle% - %SymbolPosAngle% = %MouseTransAngle% < %MouseSensitivityAngle%

      If MouseTransNumPoints > %MouseSensitivityPoints%
        Break

      If MouseTransAngle <= %MouseSensitivityAngle%
      {
	    SymbolPosNumber++
	    MouseTransNumPoints = 0
	  }
	  Else
	    MouseTransNumPoints++

      MousePosNumber++
    }
  }

  SymbolRecognized:
  Menu, TRAY, Icon, Mouse Gestures2.ico
  Menu, TRAY, Tip, %GestureName% executed
  
  ; Action Implementation
  ;-------------------------------------------------------------
  ;Create temporary file to execute action
  CodeLinesNumber = 0
  Loop
  {
    CodeLinesNumber++

    INIRead, CodeLine, Mouse Gestures.ini, Gesture %GestureNumber%, %CodeLinesNumber%, *
    If CodeLine =
      Break
    If CodeLine = 0
      Break
    If CodeLine = *
      Break

    If CodeLinesNumber = 1
    {
      FileAppend, #NoTrayIcon`r`n, Mouse Gestures Temp.ahk
    }
    FileAppend, %CodeLine%`r`n, Mouse Gestures Temp.ahk
  }
  ;Run and wait until it's completed
  If CodeLinesNumber > 1
  {
    RunWait, Mouse Gestures Temp.ahk
  ;Delete it after being closed
    FileDelete, Mouse Gestures Temp.ahk
  }

  SetTimer, RestoreIcon, 3500
  Return

  SymbolNotRecognized:
  Menu, TRAY, Icon, Mouse Gestures3.ico
  Menu, TRAY, Tip, Symbol not recognized
  SetTimer, RestoreIcon, 3500
  Return
  
  RestoreIcon:
  SetTimer, RestoreIcon, off
  Menu, TRAY, Icon, Mouse Gestures.ico
  Menu, TRAY, Tip, Mouse Gestures
  Return

;-------------------------------------------------------------
  GestureShortcut:
    GestureNumber = 0

    Loop
    {
      GestureNumber++
      INIRead, GestureName, Mouse Gestures.ini, Gesture %GestureNumber%, Name, *
      If GestureName = *
        HotKey, %A_ThisHotkey%, Off

      INIRead, GestureShortcut, Mouse Gestures.ini, Gesture %GestureNumber%, Shortcut
      If GestureShortcut = %A_ThisHotkey%
      {
        Goto SymbolRecognized
      }
    }


InvertPoint:
;InvertPoint
;
;Input:
;
;(X,Y)
;XMax, YMax
;XMin, YMin

;Output:
;ResultX, ResultY
ResultY = %YMax%
ResultY -= %Y%
ResultY += %YMin%
Return

DistanceFormula:
;Distance Formula
;Result = Sqrt((X2 - X1)² + (Y2 + Y1)²)

XResult = %X2%
XResult -= %X1%
If XResult < 0
  XResult *= -1
Transform, XResult, Pow, %XResult%, 2

YResult = %Y2%
YResult -= %Y1%
If YResult < 0
  YResult *= -1
Transform, YResult, Pow, %YResult%, 2

Result = %XResult%
Result += %YResult%
Transform, Result, Pow, %Result%, 0.5
Return

;RoundUpwards:
;;Round Upwards
;ErrorLevel = 0
;StringGetPos, DotPos, X, .
;
;If ErrorLevel <> 1
;{
;  StringLeft, Integer, X, %DotPos%
;  DotPos++
;  StringTrimLeft, Decimal, X, %DotPos%
;  If Decimal > 0
;    Integer++
;  Result = %Integer%
;}
;Else
;  Result = %X%
;Return

AngleDetection:
;Angle Detection
;
;Input:
;
;(X1,Y1) (X2,Y2)

;Output:
;Result
Gosub, DistanceFormula

;Sine = (opp/hyp) OR IN OTHER WORDS
;Sine = ((Y2-Y1)/Result)

;1: (Y2-Y1) -> has to be positive
Sine = %Y2%.0
Sine -= %Y1%

;Cosine = (adj/hyp) OR IN OTHER WORDS
;Cosine = ((X2-X1)/Result)

;1: (X2-X1) -> has to be positive
Cosine = %X2%.0
Cosine -= %X1%

Sine /= %Result%
Cosine /= %Result%

;Convert values to degrees (on counter-clockwise)

If Sine > 0
{
  ;0-90
  If Cosine >= 0
  {
	Transform, Result, ASin, %Sine%
	Result *= 57.29578
	Result -= 180
	Result *= -1
	Goto AngleDetectionEnd
  }

  ;90-180
  If Cosine <= 0
  {
	Transform, Result, ACos, %Cosine%
	Result *= 57.29578
	Result -= 180
	Result *= -1
	Goto AngleDetectionEnd
  }
}

If Sine < 0
{
  ;180-270
  If Cosine <= 0
  {
	Transform, Result, ACos, %Cosine%
	Result *= 57.29578
	Result += 180
	Goto AngleDetectionEnd
  }

  ;270-360
  If Cosine >= 0
  {
	Transform, Result, ACos, %Cosine%
	Result *= 57.29578
	Result += 180
	Goto AngleDetectionEnd
  }
}

If Sine = 0
{
  ;0
  If Cosine <= 0
  {
	Result = 0.000000
	Goto AngleDetectionEnd
  }

  ;180
  If Cosine >= 0
  {
	Result = 180.000000
	Goto AngleDetectionEnd
  }
}

AngleDetectionEnd:
Return