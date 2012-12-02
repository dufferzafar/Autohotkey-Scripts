;; --- LAST EDITED BY:- ShadabSofts 
;; ---			   ON:- 21/12/10

;; --- EDITION:-
;; 			 1) Removed Win__NextMonitorNum() & Win__Fling() functions
;; 			 2) Added Win7 Mouse Window Drag Win__MouseMove()
;; 			 2) Added KDE Drag & Resize Win__Drag() Win__Resize()


;; -----------------------------------------------------------------------
;; Verifies that the given window exists. Along the way it also resolves
;; special values of the "WinID" function parameter:
;;		1) The letter "A" means to use the Active window
;;		2) The letter "M" means to use the window under the Mouse
;; The parameter value is checked to see that it corresponds to a valid
;; window, the function returning true or false accordingly.

Win__ResolveWinID(ByRef WinID)
{
	if (WinID = "A")
	{
		; "A" means: Use the Active window
		WinID := WinExist("A")
	}
	else if (WinID = "M")
	{
		; "M" means: Use the window currently under the Mouse
		MouseGetPos,,, WinID	; MouseX, MouseY are not needed
	}

	; Check to make sure we are working with a valid window ID
	IfWinNotExist, ahk_id %WinID%
	{
		; Make a short noise so the user knows to stop expecting something fun to happen.
		SoundPlay, *64

		; Debug Support
		;MsgBox, 16, Error, Specified window does not exist.`nWindow ID = %WinID%

		return false
	}

	return true
}

;; -----------------------------------------------------------------------
;; Set the min/maximized state of the given window.
;;
;; This function serves as a kind of inverse to the built-in function:
;;		WinGet, Var, MinMax, WinID

Win__SetMinMax(TargetMinMaxState, WinID)
{
	WinGet, CurrentMinMaxState, MinMax, ahk_id %WinID%

	if CurrentMinMaxState <> TargetMinMaxState
	{
		if (TargetMinMaxState = 1)
		{
			WinMaximize, ahk_id %WinID%
		}
		else if (TargetMinMaxState = -1)
		{
			WinMinimize, ahk_id %WinID%
		}
		else
		{
			WinRestore, ahk_id %WinID%
		}
	}
}

;; -----------------------------------------------------------------------
;; This function returns the position and dimensions of the monitor which
;; contains (the most screen area of) a specified window.

Win__GetMonitorPosShowingWin(ByRef MonX, ByRef MonY, ByRef MonW, ByRef MonH, ByRef MonN, WinID)
{
	; Compute the dimensions of the subject window
	WinGetPos, WinLeft, WinTop, WinWidth, WinHeight, ahk_id %WinID%
	WinRight  := WinLeft + WinWidth
	WinBottom := WinTop  + WinHeight

	; How many monitors are we dealing with?
	SysGet, MonitorCount, MonitorCount

	; For each active monitor, we get Top, Bottom, Left, Right of the monitor's
	;  'Work Area' (i.e., excluding taskbar, etc.). From these values we compute Width and Height.
	;  As we loop, we track which monitor has the largest overlap (in the sense of screen area)
	;  with the subject window. We call that monitor the window's 'Source Monitor'.

	SourceMonitorNum = 0
	MaxOverlapArea   = 0

	Loop, %MonitorCount%
	{
		MonitorNum    := A_Index		; Give the loop variable a sensible name

		; Retrieve position / dimensions of the monitor's work area
		SysGet, Monitor, MonitorWorkArea, %MonitorNum%
		MonitorWidth  := MonitorRight  - MonitorLeft
		MonitorHeight := MonitorBottom - MonitorTop

		; Check for any overlap with the subject window
		; The following ternary expressions simulate "max(a,b)" and "min(a,b)" type function calls:
		;	max(a,b) <==> (a>b ? a : b)
		;	min(a,b) <==> (a<b ? a : b)
		; The intersection between two windows is characterized as that part below both
		; windows' "Top" values and above both "Bottoms"; similarly to the right of both "Lefts"
		; and to the left of both "Rights". Hence the need for all these min/max operations.

		MaxTop    := (WinTop    > MonitorTop   ) ? WinTop    : MonitorTop
		MinBottom := (WinBottom < MonitorBottom) ? WinBottom : MonitorBottom

		MaxLeft   := (WinLeft   > MonitorLeft  ) ? WinLeft   : MonitorLeft
		MinRight  := (WinRight  < MonitorRight ) ? WinRight  : MonitorRight

		HorizontalOverlap := MinRight  - MaxLeft
		VerticalOverlap   := MinBottom - MaxTop

		if (HorizontalOverlap > 0 and VerticalOverlap > 0)
		{
			OverlapArea := HorizontalOverlap * VerticalOverlap
			if (OverlapArea > MaxOverlapArea)
			{
				SourceMonitorLeft		:= MonitorLeft
				SourceMonitorRight		:= MonitorRight		; not used
				SourceMonitorTop		:= MonitorTop
				SourceMonitorBottom		:= MonitorBottom	; not used
				SourceMonitorWidth		:= MonitorWidth
				SourceMonitorHeight		:= MonitorHeight
				SourceMonitorNum		:= MonitorNum

				MaxOverlapArea      	:= OverlapArea
			}
		}
	}

	if MaxOverlapArea = 0
	{
		; If the subject window wasn't visible in *ANY* monitor, default to the 'Primary'
		SysGet, SourceMonitorNum, MonitorPrimary

		SysGet, SourceMonitor, MonitorWorkArea, %SourceMonitorNum%
		SourceMonitorWidth  := SourceMonitorRight  - SourceMonitorLeft
		SourceMonitorHeight := SourceMonitorBottom - SourceMonitorTop
	}

	MonX := SourceMonitorLeft
	MonY := SourceMonitorTop
	MonW := SourceMonitorWidth
	MonH := SourceMonitorHeight
	MonN := SourceMonitorNum
}

;; -----------------------------------------------------------------------
;; This function is a simplified version of Win__GetMonitorPosShowingWin()
;; for applications that only need the monitor number, not all of its
;; position information.

Win__GetMonitorShowingWin(ByRef MonN, WinID)
{
	Win__GetMonitorPosShowingWin(MonX, MonY, MonW, MonH, MonN, WinID)
}

;; -----------------------------------------------------------------------
;; Prepare a window for any sort of scripted 'move' operation.
;;
;; The first thing to do is to restore the window if it was min/maximized.
;; The reason for this is that the standard min/max window controls don't
;; seem to like it if you script a move / resize while a window is
;; minimized or maximized.
;;
;; After that, we look to see which monitor holds the "most" of the window
;; (in the sense of screen real estate) and we return a bunch of information
;; about that monitor so the caller can figure out the best way to do the move.
;;
;; The original min/max state is also returned in case the window needs to
;; be restored to that state at some future time.
;;
;; The window ID is also resolved, as per the function Win__ResolveWinID().

Win__PrepForMove(ByRef MonX, ByRef MonY, ByRef MonW, ByRef MonH, ByRef MonN, ByRef WinMinMax, ByRef WinID)
{
	if !Win__ResolveWinID(WinID)
	{
		; Subject window doesn't exist
		return false
	}

	; If the subject window started out min/maximized, then we restore it
	; in preparation of it being moved or resized.

	WinGet, WinMinMax, MinMax, ahk_id %WinID%
	if WinMinMax
	{
		WinRestore, ahk_id %WinID%
	}

	Win__GetMonitorPosShowingWin(MonX, MonY, MonW, MonH, MonN, WinID)
	return true
}

;; -----------------------------------------------------------------------
;; Move and resize a window to align it to a specified screen grid.
;;
;; The first two parameters, GridRows and GridCols, determine the granularity
;; of the grid. The other four grid parameters determine which grid cell
;; the window is to fit into and how big it should be in each direction:
;;
;;		GridOffsetUnitsX:	The X coordinate of the top left grid cell, in the range 1..GridCols
;;		GridOffsetUnitsY:	The Y coordinate of the top left grid cell, in the range 1..GridRows
;;		GridUnitsW:			The width  of the window, in units of cells
;;		GridUnitsH:			The height of the window, in units of cells
;;
;; For example, to grid six windows on the screen, three across and two
;; down, each occupying a single grid cell, you might issue the following
;; six commands to six different windows (WinID1 .. WinID6):
;;
;;	 	Win__AlignToGrid( 3, 2,   1, 1,   1, 1,   WinID1 )
;;	 	Win__AlignToGrid( 3, 2,   2, 1,   1, 1,   WinID2 )
;;	 	Win__AlignToGrid( 3, 2,   3, 1,   1, 1,   WinID3 )
;;	 	Win__AlignToGrid( 3, 2,   1, 2,   1, 1,   WinID4 )
;;	 	Win__AlignToGrid( 3, 2,   2, 2,   1, 1,   WinID5 )
;;	 	Win__AlignToGrid( 3, 2,   3, 2,   1, 1,   WinID6 )
;;
;; I've added extra spaces between pairs of related parameters to act as visual
;; clues for the reader. The spaces are, of course, not required.
;;
;; These commands would result in the following gridded window arrangement:
;;
;;		+---------+---------+---------+
;;		|         |         |         |
;;		|    1    |    2    |    3    |
;;		|         |         |         |
;;		+---------+---------+---------+
;;		|         |         |         |
;;		|    4    |    5    |    6    |
;;		|         |         |         |
;;		+---------+---------+---------+
;;
;; As another example, consider the following two commands:
;;
;;	 	Win__AlignToGrid( 3, 2,   1, 1,   2, 2,   WinID7 )
;;	 	Win__AlignToGrid( 3, 2,   3, 1,   1, 2,   WinID8 )
;;
;; Here the windows are larger than a single grid cell, as they were in the first example.
;; The first command asks for a 2x2 window and the second one asks for a 1x2 (1 col, 2 rows)
;; window. This ought to result in the following window arrangement:
;;
;;		+-------------------+---------+
;;		|                   |         |
;;		|                   |         |
;;		|                   |         |
;;		|        7          |    8    |
;;		|                   |         |
;;		|                   |         |
;;		|                   |         |
;;		+-------------------+---------+


Win__AlignToGrid(GridCols, GridRows, GridOffsetUnitsX, GridOffsetUnitsY, GridUnitsW, GridUnitsH, WinID)
{
	if !Win__PrepForMove(MonX, MonY, MonW, MonH, MonN, WinMinMax, WinID)
	{
		return false
	}

	X := Round(MonW * (GridOffsetUnitsX - 1) / GridCols) + MonX
	Y := Round(MonH * (GridOffsetUnitsY - 1) / GridRows) + MonY
	W := Round(MonW *  GridUnitsW            / GridCols)
	H := Round(MonH *  GridUnitsH            / GridRows)

	WinMove, ahk_id %WinID%,, X, Y, W, H
	return true
}

;; -----------------------------------------------------------------------
Win__QuarterTopLeft(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(2, 2,   1, 1,   1, 1,   WinID)
}

;; -----------------------------------------------------------------------

Win__QuarterTopRight(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(2, 2,   2, 1,   1, 1,   WinID)
}

;; -----------------------------------------------------------------------

Win__QuarterBottomLeft(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(2, 2,   1, 2,   1, 1,   WinID)
}

;; -----------------------------------------------------------------------

Win__QuarterBottomRight(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(2, 2,   2, 2,   1, 1,   WinID)
}

;; -----------------------------------------------------------------------
; Mimic Windows-7 Win-Left Key Combination

Win__HalfLeft(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(2, 2,   1, 1,   1, 2, WinID)
}

;; -----------------------------------------------------------------------
; Mimic Windows-7 Win-Right Key Combination

Win__HalfRight(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(2, 2,   2, 1,   1, 2,   WinID)
}

;; -----------------------------------------------------------------------

Win__HalfTop(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(2, 2,   1, 1,   2, 1,   WinID)
}

;; -----------------------------------------------------------------------

Win__HalfBottom(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(2, 2,   1, 2,   2, 1,   WinID)
}

;; -----------------------------------------------------------------------

Win__Fullscreen(WinID)
{
;                    C  R    X  Y    W  H
	Win__AlignToGrid(1, 1,   1, 1,   1, 1,   WinID)
}

;; -----------------------------------------------------------------------

Win__Centre(WinID)
{
	if !Win__PrepForMove(MonX, MonY, MonW, MonH, MonN, MinMax, WinID)
	{
		return false
	}

	WinGetPos, WinX, WinY, WinW, WinH, ahk_id %WinID%

	BorderX := WinW < MonW ? MonW - WinW : 0
	BorderY := WinH < MonH ? MonH - WinH : 0

	X := MonX + BorderX // 2
	Y := MonY + BorderY // 2
	W := MonW - BorderX
	H := MonH - BorderY

	WinMove, ahk_id %WinID%,, X, Y, W, H
	return true
}

;; -----------------------------------------------------------------------
;; Automatically grid all windows of the same type as the active window.
;;
;; This function will intelligently grid / tile all of the open windows
;; having the same type (class) as the active window. To use it, just click on
;; any window (to activate it), then call the function through a hotkey.
;; The function will find all of the windows of the same type and arrange
;; them into a gridded structure, automatically.
;;
;; The type of grid used depends (dynamically) on how many windows there are to grid.
;; The user supplies a set of "gridding rules" that indicate how they want their
;; windows to be gridded. For example, if there are two such windows, the user may
;; decide to tile them side by side, verticaly. If there are four windows, maybe
;; each window is moved / resized to occupy one quadrant of the screen.
;; The actual rules that are used are configurable and are provided using a
;; separate text file.
;;
;; Here's an example of a possible rule for the case of three windows:
;;
;;	3		2	2		1	1		1	2
;;	3		2	2		2	1		1	1
;;	3		2	2		2	2		1	1
;;
;; Note that there are 3 lines making up this rule, corresponding to the 3 windows
;; that are about to be gridded. Each line contains 7 numbers. The first number
;; is the number of windows to which these rule lines apply (in this case, 3).
;; The next six numbers form the numeric arguments to the Win__AlignToGrid()
;; function call, namely:
;;
;;	1) Number of columns in the grid
;;	2) Number of rows    in the grid
;;	3) The X coordinate of a window (in grid units)
;;	4) The Y coordinate of a window (in grid units)
;;	5) The W value (width)  of a window (in grid units)
;;	6) The H value (height) of a window (in grid units)
;;
;; Naturally, there needs to be 3 such lines, one for each window to be gridded.
;; Similarly, a tiling rule for 4 windows would need 4 such lines, etc.
;;
;; In the example for 3 windows above, we see that the windows are not simply given
;; one third of the screen each, as a simpler tiler might do. The first window here is actually
;; double size and is allocated the entire left half of the screen. Meanwhile, the second and
;; third windows are only half as big, occupying the two right screen quadrants,
;; one on top of the other.
;;
;; It isn't necessary for rule lines to all use the same grid size, either. Here is another
;; example where 5 windows are gridded in 2 rows, with 2 quarter-screen sized windows in the
;; upper row and 3 one-sixth sized windows in the lower row:
;;
;;	5		2	2		1	1		1	1
;;	5		2	2		2	1		1	1
;;	5		3	2		1	2		1	1
;;	5		3	2		2	2		1	1
;;	5		3	2		3	2		1	1
;;
;; By default, the rules go into a file named "Gridder.txt" in your AHK working
;; directory (pointed to by the built-in AHK variable %A_WorkingDir%, which is usually
;; set to "My Documents"). A function argument allows you to override
;; this behaviour by specifying an alternate file of your choosing.
;;
;; Some more details on how the function operates:
;;
;;	(a)	The function is "Multi-Monitor Aware". Only windows on the *same* monitor as
;;		the active window will be affected by this function. If you want to include
;;		windows from other monitors, you'll have to collect them all manually on one monitor.
;;		Alternatively, you can grid the windows on each monitor, separately, by
;;		calling the function multiple times with a different active window.
;;
;;	(b)	As mentioned earlier, only windows of the same type (i.e., ahk_class) as the
;;		active window are gridded, or tiled. Any other windows (on the same monitor) are
;;		automatically minimized so that your gridded windows aren't obscured.
;;
;;	(c)	The gridded windows are sorted alphabetically, by title. For example, if you
;;		have 3 explorer windows open looking at drives C:, D: and F:,
;;		the rules in the example above will be applied in that order.
;;		However, if the function parameter "ActiveWinFirst" is set to true, and you're
;;		currently working in the F: drive window, then that window will appear first.
;;		The grid rules are applied to the windows in order. This provides a
;;		way to give special treatment to the window that was
;;		active at the time the function was called. For instance, in the example of
;;		rule lines for 3 windows given above, it would be the active window that enjoys
;;		being the large (half-sized) window on the left. The other two windows being
;;		gridded will only be quarter-sized.
;;
;;	(D)	The gridding rules file can contain comments. Blank lines, as well as lines
;;		whose first non-blank character is either '#' or ';' are considered comments
;;		and ignored. This allows you to experiment with multiple rule sets and quickly
;;		swap them by commenting / uncommenting a few lines.
;;
;;	(e)	The function will complain about a rules mis-match. For example, if there are
;;		only 4 (or for that matter, 6) rule lines given for the case of 5 windows, the
;;		function will let you know you messed up.

Win__Gridder(ActiveWinFirst, GridderFile = "")
{
	; ----------------------------------------------------------
	; If the user didn't provide an gridder file name, we supply a default name
    if GridderFile =
    {
        ifExist, %A_ScriptDir%\Data\Lib\Gridder.txt
        {
            GridderFile = %A_ScriptDir%\Data\Lib\Gridder.txt
        }
        else
        {
			GridderFile = Gridder.txt
        }
    }

	ifNotExist, %GridderFile%
    {
        MsgBox, 0, Non-Existent Gridder File, The specified window gridder file (or the default file) does not exist:`n`t%GridderFile%
        return
    }

	; ----------------------------------------------------------
	; Get various bits of information we'll need about the active window

	ActiveWinID := WinExist("A")

	; Make sure there *is* an active window
	IfWinNotExist, ahk_id %ActiveWinID%
	{
		; Make a short noise so the user knows to stop expecting something fun to happen.
		SoundPlay, *64

		; Debug Support
		;MsgBox, 16, Error, Specified window does not exist.`nWindow ID = %WinID%

		return false
	}
	
	; ----------------------------------------------------------
	; Prevent mess up of all the windows
	DetectHiddenWindows Off

	WinGetClass, ActiveWinClass, ahk_id %ActiveWinID%
	Win__GetMonitorShowingWin(ActiveWinMonitorNum, ActiveWinID)

	; ----------------------------------------------------------
	; Create a list of all windows and figure out which ones are to be gridded.
	; The criteria are that the windows are of the same class and are displayed
	; on the same monitor as the active window.
	;
	; Other windows on the same monitor are minimized to get them out of the way.
	; Windows on other monitors are not touched.

	WinGet, Windows, List

	GridCount := 0
	Loop, %Windows%
	{
		WinID := Windows%A_Index%
		WinGetClass, WinClass, ahk_id %WinID%

		; Don't mess with certain system level windows (such as the tray).
		if WinClass in Button,Shell_TrayWnd,Progman
		{
			continue
		}

		; Only consider windows that are on the same monitor as the active window.
		Win__GetMonitorShowingWin(WinMonitorNum, WinID)
		if (WinMonitorNum <> ActiveWinMonitorNum)
		{
			continue
		}

		; Only grid windows with the same class as the active window
		if (WinClass <> ActiveWinClass)
		{
			; If the window is on the same monitor as the active window but it is
			; not targeted for gridding, just minimize it to get it out of the way.

			WinMinimize, ahk_id %WinID%
			continue
		}

		; We'll need the window title later for sorting purposes
		WinGetTitle, WinTitle, ahk_id %WinID%

		GridCount++
		GridWinID%GridCount% := WinID
		GridTitle%GridCount% := WinTitle
	}

	; ----------------------------------------------------------
	; Sort the list of windows for gridding by title. If the function arguments require it,
	; sift the active window into first place.
	;
	; Programming Note:
	;	With so few windows expected to be in play, an inefficient bubble sort is PLENTY
	;	good enough. In fact, it probably performs BETTER than quicksort for lists
	;	of this size. So, there. Besides, I've forgotten how to code a quicksort...

	OuterIndex := GridCount
	while (OuterIndex > 1)
	{
		InnerIndex := 1
		while (InnerIndex < OuterIndex)
		{
			InnerWinID := GridWinID%InnderIndex%
			InnerTitle := GridTitle%InnderIndex%

			TrialIndex := InnerIndex + 1
			TrialWinID := GridWinID%TrialIndex%
			TrialTitle := GridTitle%TrialIndex%

			; The first part of the following condition checks to see if the titles are in reverse
			; alphabetical order. If so, the two list items "Inner" and "Trial" are marked for a swap.
			; The second part of the condition is there to ensure that the active window sorts
			; lowest (regardless of its title), so that it ends up at the front of the list.

			Swap := (InnerTitle > TrialTitle)

			; Override the sort order when the active window is supposed to be first
			if (ActiveWinFirst)
			{
				if (InnerWinID = ActiveWinID)
				{
					Swap := false
				}
				else if (TrialWinID = ActiveWinID)
				{
					Swap := true
				}
			}

			if (Swap)
			{
				; Swap Inner and Trial

				GridWinID%TrialIndex%	:= InnerWinID
				GridWinID%InnerIndex%	:= TrialWinID

				GridTitle%TrialIndex%	:= InnerTitle
				GridTitle%InnerIndex%	:= TrialTitle
			}

			InnerIndex++
		}

		OuterIndex--
	}

	; ----------------------------------------------------------
	; Read all gridding rules and remember the ones that apply to the observed window count

	GridderRules = 0
	Loop, Read, %GridderFile%
	{
		; Read the next line from the "Gridder Rules" file
		CurrLine = %A_LoopReadLine%
		;LineNumber++

		; Blank lines and comment lines are ignored.
		; Comments may be given in either AutoHotkey style (i.e., with a leading ;)
		; or in Unix shell / Perl style (i.e., with a leading #)

		if RegExMatch(CurrLine, "^\s*([;#]|$)")
		{
			Continue
		}

		; This regexp match finds the first seven numbers on the current rule line.
		;                             Count   Cols    Rows     X       Y       W       H
		if RegExMatch(CurrLine, "^\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)", Tokens)
		{
			; Give the parsed token values some logical names
			Count	:= Tokens1
			Cols	:= Tokens2
			Rows	:= Tokens3
			X		:= Tokens4
			Y		:= Tokens5
			W		:= Tokens6
			H		:= Tokens7

			if (Count = GridCount)
			{
				; We found a rule matching the number of windows we need to grid, so remember it!
				GridderRules++
				GridderCols%GridderRules%	:= Cols
				GridderRows%GridderRules%	:= Rows
				GridderX%GridderRules%		:= X
				GridderY%GridderRules%		:= Y
				GridderW%GridderRules%		:= W
				GridderH%GridderRules%		:= H
			}
		}
	}

	; ----------------------------------------------------------
	; Make sure we found the right number of rules for the number of windows we have.
	; Otherwise, complain bitterly.

	if (GridderRules <> GridCount)
	{
		MsgBox, 0, Rules Mismatch, Found %GridderRule% gridding rules for the case of %GridCount% windows
		return false
	}

	; ----------------------------------------------------------
	; Finally, apply the gridder rules

	Loop, %GridderRules%
	{
		RuleNumber	:= A_Index

		Cols		:= GridderCols%RuleNumber%
		Rows		:= GridderRows%RuleNumber%
		X			:= GridderX%RuleNumber%
		Y			:= GridderY%RuleNumber%
		W			:= GridderW%RuleNumber%
		H			:= GridderH%RuleNumber%

		WinID		:= GridWinID%RuleNumber%

		Win__AlignToGrid(Cols, Rows, X, Y, W, H, WinID)		
	}

	return true
}

;; -----------------------------------------------------------------------
;; Handle Windows 7 like Dragging to Corners.
;;

;Handles Desktop Variables
Win__GetDesktopPos(ByRef X, ByRef Y, ByRef W, ByRef H)
{
	X := 0
	Y := 0
	SysGet, MonitorWorkArea, MonitorWorkArea
	W := A_ScreenWidth-2
	H = %MonitorWorkAreaBottom%
}

;Handles checking & storing of window information
Win__GetIDInformation(ByRef ID, ByRef Width, ByRef Height)
{
	WinGetActiveStats,Title,Width,Height,X,Y
	WinGet,ID,ID,%Title%
	check:=%id%check
	If check=1
	{
		goto,skip
	}
	
	skip:
	sleep 5
}

;Show a preview just like in Win7
Win__SplashSet()
{
	;Make sure file does NOT exist ;)
	SplashImage, XYZ.JPG,hide b2
	WinSet, Transparent, 60, %A_ScriptName%
	x+=3
	y+=3
	w-=6
	h-=6
}

;The Main Function
Win__MouseMove()
{
	DetectHiddenWindows On

	CoordMode, Mouse, Screen
	MouseGetPos, x, y, hwnd
	SendMessage, 0x84, 0, (x&0xFFFF) | (y&0xFFFF) << 16,, ahk_id %hwnd%
	RegExMatch("ERROR TRANSPARENT NOWHERE CLIENT CAPTION SYSMENU SIZE MENU HSCROLL VSCROLL MINBUTTON MAXBUTTON LEFT RIGHT TOP TOPLEFT TOPRIGHT BOTTOM BOTTOMLEFT BOTTOMRIGHT BORDER OBJECT CLOSE HELP", "(?:\w+\s+){" . ErrorLevel+2&0xFFFFFFFF . "}(?<AREA>\w+\b)", HT)
	If htarea!=TOP
	   {
	   }
	else
	   {
	   WinGetActiveStats,Title,Width,Height,X,Y
	   winget,ID,ID,%Title%
	   check:=%id%check
	   If check=1
		  {
		  goto,skiptop
		  }
	   %ID%check=1
	   %ID%Width=%width%
	   %ID%Height=%height%
	   %ID%x=%x%
	   skiptop:
	   loop
		  {
		  sleep 5
		  coordmode,mouse,screen
		  MouseGetPos,Mouse_X,Mouse_Y
		  If (mouse_y=0)
			 {
			 Win__GetDesktopPos(X, Y, W, H)
			 Win__SplashSet()
			 wingetactivestats,Title,W,H2,x,Y
			 height:=h-h2-y
			 winmove,%A_ScriptName%,,X,Y+H2,W,height
			 SplashImage, Show, b2,,, SplashImage
			 loop
				{
				sleep 5
				coordmode,mouse,screen
				MouseGetPos,Mouse_X,Mouse_Y
				If (mouse_y>0)
				   {
				   splashimage,off
				   goto,skiptop
				   }
				If (GetKeyState("LButton","P")=0)
				   {
				   splashimage,off
				   Win__GetDesktopPos(X, Y, W, H)
				   winMove,A,,,0,, H
				   return
				   }
				}
			 }
		  If (GetKeyState("LButton","P")=0)
			 {
				 %ID%check=
				 %ID%Width=
				 %ID%Height=
				 %ID%x=
				 return
			 }
		  }
	   }
	If htarea!=BOTTOM
	   {
	   }
	else
	   {
	   WinGetActiveStats,Title,Width,Height,X,Y
	   winget,ID,ID,%Title%
	   check:=%id%check
	   If check=1
		  {
		  goto,skipbottom
		  }
	   %ID%check=1
	   %ID%Width=%width%
	   %ID%Height=%height%
	   %ID%x=%x%
	   skipbottom:
	   loop
		  {
		  sleep 5
		  coordmode,mouse,screen
		  MouseGetPos,Mouse_X,Mouse_Y
		  Win__GetDesktopPos(X, Y, W, H)
		  check:=H-mouse_y-1
		  If (check<3)
			 {
			 Win__GetDesktopPos(X, Y, W, H)
			 Win__SplashSet()
			 wingetactivestats,Title,W,H,x,Y
			 winmove,%A_ScriptName%,,X,0,W,Y
			 SplashImage, Show, b2,,, SplashImage
			 loop
				{
				sleep 5
				coordmode,mouse,screen
				MouseGetPos,Mouse_X,Mouse_Y
				Win__GetDesktopPos(X, Y, W, H)
				check:=H-mouse_y-1
				If (check>3)
				   {
				   splashimage,off
				   goto,skipbottom
				   }
				If (GetKeyState("LButton","P")=0)
				   {
				   splashimage,off
				   Win__GetDesktopPos(X, Y, W, H)
				   winMove,A,,,0,, H
				   return
				   }
				}
			 }
		  If (GetKeyState("LButton","P")=0)
			 {
			 %ID%check=
			 %ID%Width=
			 %ID%Height=
			 %ID%x=
			 return
			 }
		  }
	   }
	If htarea!=CAPTION
	   {
	   Return
	   }
	 MouseGetPos,_x,_y
	 While GetKeyState("LButton","P") && x=_x && y=_y
	   {
	   start:
	   sleep 5
	   wingetactivestats,ActiveTitle,Width,Height,x,Y
	   winget,test,MinMax,%activetitle%
	   If test=1
		  {
		  return
		  }
	   coordmode,mouse,screen
	   MouseGetPos,Mouse_X,Mouse_Y
	   If Mouse_X=0
		  {
		  Win__GetDesktopPos(X, Y, W, H)
		  Win__SplashSet()
		  winmove,%A_ScriptName%,,x,y,w/2,h
		  SplashImage, Show, b2,,, SplashImage
		  loop
			 {
			 sleep 5
			 MouseGetPos,Mouse_X,Mouse_Y
			 If (GetKeyState("LButton","P")=0)
				{
				Win__GetIDInformation(ID,Width,Height)
				%ID%check=1
				%ID%Width=%width%
				%ID%Height=%height%
				ID=
				splashimage,off
				Win__GetDesktopPos(X, Y, W, H)
				WinMove, A,, X, Y, W/2, H
				return
				}
			 If Mouse_X>0
				{
				splashimage,off
				goto,start
				}
			 }
		  }
	   Win__GetDesktopPos(X,Y,Width,Height)   
	   Width-=5
	   If (width < mouse_x)
		  {
		  Win__GetDesktopPos(X, Y, W, H)
		  Win__SplashSet()
		  winmove,%A_ScriptName%,, X + W/2, Y, W/2, H
		  SplashImage, Show, b2,,, SplashImage
		  loop
			 {
			 sleep 5
			 MouseGetPos,Mouse_X,Mouse_Y
			 If (GetKeyState("LButton","P")=0)
				{
				Win__GetIDInformation(ID,Width,Height)
				%ID%check=1
				%ID%Width=%width%
				%ID%Height=%height%
				ID=
				splashimage,off
				Win__GetDesktopPos(X, Y, W, H)
				winMove, A,, X + W/2, Y, W/2, H
				return
				}
			 Win__GetDesktopPos(X,Y,Width,Height)   
			 Width-=5
			 If (width > mouse_x)
				{
				splashimage,off
				goto,start
				}
			 }
		  }
	   If mouse_y=0
		  {
		  Win__GetDesktopPos(X, Y, W, H)
		  Win__SplashSet()
		  winmove,%A_ScriptName%,,X, Y, W, H
		  SplashImage, Show, b2,,, SplashImage
		  loop
			 {
			 sleep 5
			 MouseGetPos,Mouse_X,Mouse_Y
			 If (GetKeyState("LButton","P")=0)
				{
				Win__GetIDInformation(ID,Width,Height)
				%ID%check=1
				%ID%Width=%width%
				%ID%Height=%height%
				ID=
				splashimage,off
				Win__GetDesktopPos(X, Y, W, H)
				winMove, A,, X, Y, W, H
				return
				}
			 If mouse_y>3
				{
				splashimage,off
				goto,start
				}
			 }
		  }
	   WinGetActiveStats,Title,Width,Height,X,Y
	   winget,ID,ID,%Title%
	   check:=%id%check
	   If check=1
		  {
		  WinGetActiveStats,Current_Title,Current_Width,Current_Height,Current_X,Y
		  Win__GetDesktopPos(X,Y,Width,Height) 
		  MouseGetPos,Mouse_Screen
		  winget,ID,ID,%current_Title%
		  Original_width:=%ID%Width
		  Original_height:=%ID%height
		  %ID%check=
		  %ID%Width=
		  %ID%height=
		  coordmode,mouse,relative
		  MouseGetPos,Mouse_Window
		  check:=current_width/2
		  If (mouse_window<check)
			 {
			 ;(left side)
			 check:=original_width/2
			 If (mouse_window<check)
				{
				If (mouse_window>original_width-75)
				   {
				   ;(Center the window left)
				   x:=mouse_screen-(original_width/2)
				   }
				else
				   {
				   ;(align left side)
				   x:=current_x
				   }
				goto,end
				}
			 }
		  check:=current_x+Current_width-Original_width+(original_width/2)
		  If (check<mouse_screen)
			 {
			 ;(align right side)
			 x:=current_x+Current_width-Original_width
			 goto,end
			 }
		  If (Mouse_Window<Current_width-75)
			 {
			 ;(center the window right)
			 x:=mouse_screen-(original_width/2)
			 goto,end
			 }
		  end:
		  winmove,%Current_Title%,,%x%,,%original_width%,%original_height%
		  ID=
		  x=
		  goto,start
		  }
	   If (GetKeyState("LButton","P")=0)
		  {
		  return
		  }
	   goto,start
	   }
	   
	DetectHiddenWindows Off
}

;; -----------------------------------------------------------------------
;; The KDE Drag & Resize.
;;
Win__Drag()
{
	SetWinDelay,5
	CoordMode,Mouse

	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos,KDE_X1,KDE_Y1,KDE_id
	WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
	If KDE_Win
		return
	; Get the initial window position.
	WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
	Loop
	{
		GetKeyState,KDE_Button,LButton,P ; Break if button has been released.
		If KDE_Button = U
			break
		MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
		KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
		KDE_Y2 -= KDE_Y1
		KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
		KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
		WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.
	}
	return
}

Win__Resize()
{
	SetWinDelay,5
	CoordMode,Mouse

	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos,KDE_X1,KDE_Y1,KDE_id
	WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
	If KDE_Win
		return
	; Get the initial window position and size.
	WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
	; Define the window region the mouse is currently in.
	; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
	If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
	   KDE_WinLeft := 1
	Else
	   KDE_WinLeft := -1
	If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
	   KDE_WinUp := 1
	Else
	   KDE_WinUp := -1
	Loop
	{
		GetKeyState,KDE_Button,RButton,P ; Break if button has been released.
		If KDE_Button = U
			break
		MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
		; Get the current window position and size.
		WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
		KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
		KDE_Y2 -= KDE_Y1
		; Then, act according to the defined region.
		WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
								, KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
								, KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
								, KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
		KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
		KDE_Y1 := (KDE_Y2 + KDE_Y1)
	}
}