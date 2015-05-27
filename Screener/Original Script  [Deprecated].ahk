/*

						The Screener
					Screenshots Made Easy

		Made for my friend Ravi Kumar and his brother Shubham.

Inspiration:- The Superb Tool 'IrfanView' by Irfan Skiljan

*/

#NoEnv  								;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent							;Keep running until the user asks to exit.
#NoTrayIcon							;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%	;Ensures a consistent starting directory.
SendMode Input  					;Recommended due to its superior speed and reliability.

#WinActivateForce

;Script Settings
Version = 0.9

;########################################################### Extract Dependencies
FileInstall, Main.ico, %A_Temp%\Main.tmp, 1
Menu, Tray, Icon, %A_Temp%\Main.tmp
Menu, Tray, Icon

;Let the user know that the utility has started
TrayTip, Screener v%Version%,
(
Initializing....
)

FileInstall, Suspend.ico, %A_Temp%\Suspend.tmp, 1

FileInstall, iview32.exe, %A_WinDir%\System32\iview32.exe, 1

FileCreateDir, %A_WinDir%\System32\Plugins
FileInstall, Plugins\Effects.dll, %A_WinDir%\System32\Plugins\Effects.dll, 1
FileInstall, Plugins\RegionCapture.dll, %A_WinDir%\System32\Plugins\RegionCapture.dll, 1

;########################################################## The Tray Menu & Icon
Menu, Tray, NoStandard

Menu, Tray, Tip, Screener..

;Create Extras Sub Menu
	Menu, ExtrasMenu, Add, Save Image from Clipboard, SaveClipboard

;Create the tray menu
	Menu, Tray, Add, &Extras, :ExtrasMenu
	Menu, Tray, Add
	Menu, Tray, Add, &Settings, Settings
	Menu, Tray, Add
	Menu, Tray, Add, &About..., AboutMe
	Menu, Tray, Add
	Menu, Tray, Add, &Suspend, SuspendMe
	Menu, Tray, Add, &Exit, CloseMe

Menu, Tray, Default, &Settings

Menu, Tray, Icon, &About..., %A_Temp%\Main.tmp

Menu, Tray, Icon
;################################################ Load Previously Saved Settings
GoSub, LoadSettings

;####################################################### Create About Dialog Box
{
	Gui, -MaximizeBox -MinimizeBox +AlwaysOnTop

	Gui, Add, Picture, x5 y8 w45 h45 , %A_ScriptDir%\Main.ico
	Gui, Font, s19, Tahoma
	Gui, Add, Text, x90 y20 h30 , Screener v%Version%
	Gui, Font, s14, Tahoma
	Gui, Add, Text, x260 y25 w230 h30 , - Screenshots Made Easy!
	Gui, Add, Text, x6 y70 w70 h30 , Shouts:
	Gui, Add, Text, x6 y140 w60 h30 , Usage:
	Gui, Add, Text, x286 y330 w220 h30 , Coded by - Shadab Zafar
	Gui, Font, s11, Tahoma
	Gui, Add, Text, x56 y100 w440 h30 , Created for my friend 'Ravi' and his brother 'Shubham'.
	Gui, Add, Text, x56 y170 w470 h20 , 1.) Press Windows + PrintScreen to automatically save a screenshot.
	Gui, Add, Text, x56 y200 w450 h40 , 2.) Press Windows + Left Mouse Button and Drag Mouse to select area.
	Gui, Add, Text, x76 y240 w430 h40 , 2.1) Upon releasing the Button the selected area will be saved as a screenshot.
	Gui, Add, Text, x56 y290 w450 h30 , 3.) Do Not forget to tweaks the settings.
}

;########################################################### Create Settings GUI
{
Gui,2: Add, Button, x190 y330 w100 h25 gRestoreDefaults, Restore Defaults
Gui,2: Add, Button, x310 y330 w50 h25 g2GuiClose, OK
Gui,2: Add, Button, x377 y330 w50 h25 gApplySettings, Apply

Gui,2: Add, Tab, x2 y3 w425 h320 , Save File|ScreenShots|Effects

Gui,2: Tab, Save File
	Gui,2: Add, GroupBox, x6 y30 w410 h50 , Save Files To
		Gui,2: Add, Edit, x16 y50 w320 h20 vSavePath +ReadOnly, %SavePath%
		Gui,2: Add, Button, x346 y50 w60 h20 gBrowseDir, Browse

	Gui,2: Add, GroupBox, x6 y90 w410 h110 , File Name
		Gui,2: Add, Text, x16 y110 w50 h20 , Preview
			;Gui,2: Add, Edit, x66 y110 w340 h20 +ReadOnly vFilePattern
		Gui,2: Add, Text, x16 y140 w50 h20 , Prefix
			Gui,2: Add, Edit, x66 y140 w120 h20 vPrefix gCreateFilePattern, %Prefix%
		Gui,2: Add, Text, x236 y140 w50 h20 , Suffix
			Gui,2: Add, Edit, x286 y140 w120 h20 vSuffix gCreateFilePattern, %Suffix%

		Gui,2: Add, CheckBox, x16 y170 w40 h20 vDay gCreateFilePattern Checked%Day%, Day
		Gui,2: Add, CheckBox, x71 y170 w50 h20 vMon gCreateFilePattern Checked%Mon%, Month
		Gui,2: Add, CheckBox, x136 y170 w50 h20 vYear gCreateFilePattern Checked%Year%, Year
		Gui,2: Add, CheckBox, x216 y170 w50 h20 vHour gCreateFilePattern Checked%Hour%, Hour
		Gui,2: Add, CheckBox, x276 y170 w60 h20 vMin gCreateFilePattern Checked%Min%, Minute
		Gui,2: Add, CheckBox, x346 y170 w60 h20 vSec gCreateFilePattern Checked%Sec%, Second

	Gui,2: Add, GroupBox, x6 y210 w410 h80 , File Extension
		Gui,2: Add, Text, x16 y230 w390 h20 , Extension determines the quality. So be wise!! (I prefer PNG)
		Gui,2: Add, Text, x16 y262 w70 h20 , Extension
			Gui,2: Add, DropDownList, x106 y260 w100 vExtension, PNG||JPG|GIF|BMP|TIF|ICO

Gui,2: Tab, ScreenShots
	Gui,2: Add, GroupBox, x6 y30 w410 h110 , Windows + PrintScreen
		Gui,2: Add, Text, x16 y50 h20 , What do you want to do with the screenshot??
			Gui,2: Add, Radio, x16 y70 w100 h20 vpSave Checked%pSave%, AutoSave to File
			Gui,2: Add, Radio, x127 y70 w140 h20 vpOpen Checked%pOpen%, Open in Paint for editing
			Gui,2: Add, Radio, x278 y70 w130 h20 vpCopy Checked%pCopy%, Copy to Clipboard Only

		Gui,2: Add, Text, x16 y110 w70 h20 , Region :-
			Gui,2: Add, DropDownList, x80 y107 w180 vRegion, Full Screen||Active Window|Active Window's Client Area

		Gui,2: Add, CheckBox, x328 y107 w80 h20 vHideMouse Checked%HideMouse%, Hide Mouse

	Gui,2: Add, GroupBox, x6 y150 w410 h70 , Windows + Left Mouse Button
		Gui,2: Add, Text, x16 y170 h20 , What do you want to do with the screenshot??
			Gui,2: Add, Radio, x16 y190 w100 h20 vlSave Checked%lSave%, AutoSave to File
			Gui,2: Add, Radio, x126 y190 w140 h20 vlOpen Checked%lOpen%, Open in Paint for editing
			Gui,2: Add, Radio, x276 y190 w130 h20 vlCopy Checked%lCopy%, Copy to Clipboard Only

Gui,2: Tab, Effects
	Gui,2: Add, GroupBox, x6 y30 w410 h100 , Simple Effects
		Gui,2: Add, CheckBox, x16 y50 w70 h20 vGray Checked%Gray%, GrayScale
		Gui,2: Add, CheckBox, x126 y50 w160 h20 vSwapBW Checked%SwapBW%, Swap Black and White Colors
		Gui,2: Add, CheckBox, x336 y50 w70 h20 vNegative Checked%Negative%, Negative

		Gui,2: Add, CheckBox, x16 y90 w70 h20 gCheckStatus vChkSharp Checked%ChkSharp%, Sharpen
			Gui,2: Add, Edit, x86 y90 w30 h20 +Disabled vSharpVal, 33
		Gui,2: Add, CheckBox, x156 y90 w70 h20 gCheckStatus vChkCont Checked%ChkCont%, Contrast
			Gui,2: Add, Edit, x226 y90 w30 h20 +Disabled vContVal, 33
		Gui,2: Add, CheckBox, x296 y90 w80 h20 gCheckStatus vChkBright Checked%ChkBright%, Brightness
			Gui,2: Add, Edit, x376 y90 w30 h20 +Disabled vBrightVal, 33

	Gui,2: Add, GroupBox, x6 y140 w410 h110, Resize
		Gui,2: Add, CheckBox, x16 y160 w70 h20 vChkResize gCheckStatus, Resize
			Gui,2: Add, Text, x106 y162 w40 h20, Width
				Gui,2: Add, Edit, x146 y160 w40 h20 +Disabled vResizeWidth, %ResizeWidth%
			Gui,2: Add, Text, x226 y162 w40 h20, Height
				Gui,2: Add, Edit, x266 y160 w40 h20 +Disabled vResizeHeight, %ResizeHeight%

		Gui,2: Add, CheckBox, x296 y198 w110 h20 +Disabled vAspectRatio Checked%AspectRatio%, Keep Aspect Ratio
		Gui,2: Add, CheckBox, x296 y218 w70 h20 +Disabled vResample Checked%Resample%, Resample
		Gui,2: Add, Text, x16 y200 w50 h20 , Notes:-
		Gui,2: Add, text, x60 y200 h20 , 1.) Resize to 128x128 or 256x256 for an Icon.
		Gui,2: Add, Text, x60 y220 w170 h20 , 2.) Resample increases the quality.

	Gui,2: Add, GroupBox, x6 y260 w410 h50 , Rotate and/or Flip
		Gui,2: Add, Text, x16 y282 w60 h20 , Rotate
			Gui,2: Add, DropDownList, x76 y280 w100 vRotate, None||Left|Right
		Gui,2: Add, Text, x266 y282 w30 h20 , Flip
			Gui,2: Add, DropDownList, x296 y280 w100 vFlip, None||Horizontal|Vertical

}

;######################################################### Apply Settings to GUI
GuiControl, 2:ChooseString, Extension, %Extension%
GuiControl, 2:ChooseString, Region, %Region%
GuiControl, 2:ChooseString, Rotate, %Rotate%
GuiControl, 2:ChooseString, Flip, %Flip%
;Enable/Disable Controls based on the Checkbox status
GoSub, CheckStatus
;Create File Pattern based on the checkbox Status
GoSub, CreateFilePattern
;Now Create FilePattern Edit
Gui,2: Tab, Save File
	Gui,2: Add, Edit, x66 y110 w340 h20 +ReadOnly vFilePattern, %FilePattern%

TrayTip	 ;Hide The TrayTip

Return	 ;End of Auto Execute Section
;_____________________________________________

;############################################################################
						;Labels For GUI Event Handling
;############################################################################

BrowseDir:
	FileSelectFolder, TargetFolder, *%SavePath%, 3, Select the folder to which the file(s) would be copied.
	If TargetFolder =
		Return
	GuiControl,, SavePath, %TargetFolder%
Return

RestoreDefaults:
	Msgbox, 36, Continue??, Do you really want to restore the settings.
	IfMsgBox, Yes
	{
		RegDelete, HKCU, Software\Screener
		Msgbox, 64, Restore Complete, You need to restart Screener for the changes to take effect.
	}
Return

ApplySettings:
{
	Gui,2: Submit, NoHide

	;Check SavePath
	If SavePath =
	{
		Msgbox, 16, In-Appropriate Path, Please Select a Valid Path where the ScreenShots will be saved.
		Return
	}

	;Check FilePattern
	If FilePattern =
	{
		Msgbox, 16, In-Appropriate File Pattern, Please Select a Valid Pattern based on which the ScreenShots will be named.
		Return
	}

	;Prepare FlieName Preview
	StringReplace, FilePattern, FilePattern, `%A_DD`%, %A_DD%
	StringReplace, FilePattern, FilePattern, `%A_MMM`%, %A_MMM%
	StringReplace, FilePattern, FilePattern, `%A_YYYY`%, %A_YYYY%
	StringReplace, FilePattern, FilePattern, `%A_Hour`%, %A_Hour%
	StringReplace, FilePattern, FilePattern, `%A_Min`%, %A_Min%
	StringReplace, FilePattern, FilePattern, `%A_Sec`%, %A_Sec%
	StringLower, Extension, Extension

	;Prepare the Capture Options
	If Region = Full Screen
		CapOp = 0
	Else If Region = Active Window
		CapOp = 1
	Else If Region = Active Window's Client Area
		CapOp = 2

	CaptureOptions = /capture=%CapOp%

	;Add Simple Effects
	If Gray
		CaptureOptions = %CaptureOptions% /gray
	If SwapBW
		CaptureOptions = %CaptureOptions% /swap_bw
	If Negative
		CaptureOptions = %CaptureOptions% /invert

	If ChkSharp
	{
		Bind(SharpVal, 1, 99)
		CaptureOptions = %CaptureOptions% /sharpen=%SharpVal%
	}
	If ChkCont
	{
		Bind(ContVal, -127, 127)
		CaptureOptions = %CaptureOptions% /contrast=%ContVal%
	}
	If ChkBright
	{
		Bind(BrightVal, 0, 255)
		CaptureOptions = %CaptureOptions% /bright=%BrightVal%
	}

	;Apply Resize Options
	If ChkResize
	{
		CaptureOptions = %CaptureOptions% /resize=(%ResizeWidth%,%ResizeHeight%)

		If Resample
			CaptureOptions = %CaptureOptions% /resample
		If AspectRatio
			CaptureOptions = %CaptureOptions% /aspectratio
	}

	;Apply Rotate and/or Flip Options
	If Rotate <> None
	{
		If Rotate = Left
			CaptureOptions = %CaptureOptions% /rotate_l
		If Rotate = Right
			CaptureOptions = %CaptureOptions% /rotate_r
	}
	If Flip <> None
	{
		If Flip = Horizontal
			CaptureOptions = %CaptureOptions% /hflip
		If Flip = Vertical
			CaptureOptions = %CaptureOptions% /vflip
	}

	;Msgbox, "%SavePath%\%FilePattern%.%Extension%"
	;Msgbox, %CaptureOptions%
}
Return

CheckStatus:
{
	;Get Simple Effects
	GuiControlGet, ChkSharp  , 2:
	GuiControlGet, ChkCont   , 2:
	GuiControlGet, ChkBright , 2:

	;Apply Simple Effects
	GuiControl, 2:Enable%ChkSharp%  , SharpVal
	GuiControl, 2:Enable%ChkCont%   , ContVal
	GuiControl, 2:Enable%ChkBright% , BrightVal

	;Resize Options
	GuiControlGet, ChkResize, 2:

	GuiControl, 2:Enable%ChkResize%  , ResizeWidth
	GuiControl, 2:Enable%ChkResize%  , ResizeHeight
	GuiControl, 2:Enable%ChkResize%  , Resample
	GuiControl, 2:Enable%ChkResize%  , AspectRatio
	GuiControl,, Resample, %ChkResize%
	GuiControl,, AspectRatio, %ChkResize%
}
Return

CreateFilePattern:
{
	Gui,2: Submit, NoHide

	StringLen, prefixLen, Prefix
	StringLen, suffixLen, Suffix

	StringTrimLeft, dynamicFilePattern, Prefix, prefixLen
	StringTrimRight, dynamicFilePattern, dynamicFilePattern, suffixLen

	If Day
		dynamicFilePattern .= `%A_DD`%
	If Mon
		dynamicFilePattern .= "-"`%A_MMM`%
	If Year
		dynamicFilePattern .= "-"`%A_YYYY`%
	If Hour
		dynamicFilePattern .= "-"`%A_Hour`%
	If Min
		dynamicFilePattern .= "-"`%A_Min`%
	If Sec
		dynamicFilePattern .= "-"`%A_Sec`%

	FilePattern := Prefix "" dynamicFilePattern "" Suffix

	GuiControl,, FilePattern, %FilePattern%
}
Return

;############################################################################
								;Hotkeys
;############################################################################

;Automatically save a screenshot						Win+PrintScreen
#PRINTSCREEN::
	;fScreen := 0 "," 0 "," A_ScreenWidth "," A_ScreenHeight
	;CaptureScreen(fScreen) ;would also do the same job
	;Send {PRINTSCREEN}

	GoSub, ApplySettings

	;Msgbox, %CaptureOptions% --DEBUG

	If HideMouse
    {
		MouseGetPos, MhideX, MhideY
		MouseMove, %A_ScreenWidth%, %A_ScreenHeight% , 0
    }

	If pCopy = 1
	{
		RunWait, iview32.exe /silent %CaptureOptions% /clipcopy /killmesoftly
		;msgbox, iview32.exe /silent %CaptureOptions% /clipcopy /killmesoftly
	}

	Else If pOpen = 1
	{
		RunWait, iview32.exe /silent %CaptureOptions% /clipcopy /killmesoftly
		;ClipWait
		Run, mspaint.exe, , UseErrorLevel, paintPID		;Run Paint
		If ErrorLevel
		{
			Msgbox, 16, Paint Not Found!!, Microsoft Paint (mspaint.exe) was not found in it's directory.
			Return
		}

		;Make Sure Paint is Active
		WinWaitActive, ahk_pid %paintPID%
			{
				;Paste the ScreenShot
				Send !ia
				Send 1{TAB}1{ENTER}
				Send !ep
			}
	}

	Else If pSave = 1
	{
		Gui, Submit
		RunWait, iview32.exe /silent %CaptureOptions% /convert="%SavePath%\%FilePattern%.%Extension%" /killmesoftly
	}

	If HideMouse
		MouseMove, %MhideX%, %MhideY% , 0
Return

;Select screen area to copy to clipboard				Win+LButton
#LButton::
	GoSub, ApplySettings

	CaptureOptions := RegExReplace(CaptureOptions, "/capture=\d+", "")	;Remove /capture=0,1,2

	;Get Selected Area
	Area := SelectArea("cLime")

	;The real co-ords
	;StringReplace, Area, Area, |, `,, All
	;	Sleep, 100
	StringSplit, rt, Area, `|, %A_Space%%A_Tab%
	nW := rt3 - rt1
	nH := rt4 - rt2

	;Copy it to Clipboard
	RunWait, iview32.exe /silent /capture=0 /crop=(%rt1%`,%rt2%`,%nW%`,%nH%) %CaptureOptions% /clipcopy /killmesoftly

	If lCopy = 1
		Return

	Else If lOpen = 1
	{
		Run, mspaint.exe, , UseErrorLevel, paintPID		;Run Paint
		If ErrorLevel
		{
			Msgbox, 16, Paint Not Found!!, Microsoft Paint (mspaint.exe) was not found in it's directory.
			Return
		}

		;Make Sure Paint is Active
		WinWaitActive, ahk_pid %paintPID%
		{
			;Paste the ScreenShot
			Send !ia
			Send 1{TAB}1{ENTER}
			Send !ep
		}
	}

	Else If lSave = 1
	{
		Gui, Submit	;Generate FilePattern

		RunWait, iview32.exe /silent /clippaste %CaptureOptions% /convert="%SavePath%\%FilePattern%.%Extension%" /killmesoftly
	}

Return

SaveClipboard:
	GoSub, ApplySettings

	Gui, Submit	;Generate FilePattern

	RunWait, iview32.exe /silent /clippaste /convert="%SavePath%\%FilePattern%.%Extension%" /killmesoftly
Return

;############################################################################
							;Menu Events Labels
;############################################################################

;Show About Dialog Box
AboutMe:
	Gui, Show, h368 w513 Center, About Screener
Return

;Hide Dialog Box
GuiClose:
	Gui, Hide
Return

;Show Settings Dialog
Settings:
	Gui,2: Show, Center h360 w428, Screener Settings
Return

;Hide Settings Dialog
2GuiClose:
	Gui,2: Hide
Return

;Suspend The Script
SuspendMe:
	Suspend, Toggle
	Menu, Tray, ToggleCheck, &Suspend
	If A_IsSuspended = 1
		Menu, Tray, Icon, %A_Temp%\Suspend.tmp, ,1
	Else
		Menu, Tray, Icon, %A_Temp%\Main.tmp, ,1
Return

;Save Settings and Exit
CloseMe:
	GoSub, SaveSettings
	FileDelete, %A_Temp%\Main.tmp
	FileDelete, %A_Temp%\Suspend.tmp
ExitApp

;############################################################################
						   ;Save & Load Settings
;############################################################################

SaveSettings:
{
	;Save File - Tab
	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, SavePath, %SavePath%

	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Prefix, %Prefix%
	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Suffix, %Suffix%

	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Day  , %Day%
	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Mon  , %Mon%
	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Year , %Year%
	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Hour , %Hour%
	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Min  , %Min%
	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Sec  , %Sec%

	RegWrite, REG_SZ, HKCU, Software\Screener\SaveFile, Extension, %Extension%

	;ScreenShots - Tab
	RegWrite, REG_SZ, HKCU, Software\Screener\ScreenShots, pSave, %pSave%
	RegWrite, REG_SZ, HKCU, Software\Screener\ScreenShots, pOpen, %pOpen%
	RegWrite, REG_SZ, HKCU, Software\Screener\ScreenShots, pCopy, %pCopy%

	RegWrite, REG_SZ, HKCU, Software\Screener\ScreenShots, Region, %Region%
	RegWrite, REG_SZ, HKCU, Software\Screener\ScreenShots, HideMouse, %HideMouse%

	RegWrite, REG_SZ, HKCU, Software\Screener\ScreenShots, lSave, %lSave%
	RegWrite, REG_SZ, HKCU, Software\Screener\ScreenShots, lOpen, %lOpen%
	RegWrite, REG_SZ, HKCU, Software\Screener\ScreenShots, lCopy, %lCopy%

	;Effects - Tab
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, Gray, %Gray%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, SwapBW, %SwapBW%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, Negative, %Negative%

	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, ChkSharp, %ChkSharp%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, ChkCont, %ChkCont%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, ChkBright, %ChkBright%

	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, SharpVal, %SharpVal%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, ContVal, %ContVal%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, BrightVal, %BrightVal%

	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, ChkResize, %ChkResize%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, ResizeWidth, %ResizeWidth%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, ResizeHeight, %ResizeHeight%

	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, AspectRatio, %AspectRatio%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, Resample, %Resample%

	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, Rotate, %Rotate%
	RegWrite, REG_SZ, HKCU, Software\Screener\Effects, Flip, %Flip%
}
Return

LoadSettings:
{
	;Save File - Tab
	RegRead, SavePath, HKCU, Software\Screener\SaveFile, SavePath
	If ErrorLevel
		SavePath = %A_MyDocuments%\My Pictures
	RegRead, Prefix, HKCU, Software\Screener\SaveFile, Prefix
	If ErrorLevel
		Prefix = Screenshot-
	RegRead, Suffix, HKCU, Software\Screener\SaveFile, Suffix
	If ErrorLevel
		Suffix = -by Screener
	RegRead, Day, HKCU, Software\Screener\SaveFile, Day
	If ErrorLevel
		Day = 1
	RegRead, Mon, HKCU, Software\Screener\SaveFile, Mon
	If ErrorLevel
		Mon = 1
	RegRead, Year, HKCU, Software\Screener\SaveFile, Year
	If ErrorLevel
		Year = 1
	RegRead, Hour, HKCU, Software\Screener\SaveFile, Hour
	If ErrorLevel
		Hour = 1
	RegRead, Min, HKCU, Software\Screener\SaveFile, Min
	If ErrorLevel
		Min = 1
	RegRead, Sec, HKCU, Software\Screener\SaveFile, Sec
	If ErrorLevel
		Sec = 1

	RegRead, Extension, HKCU, Software\Screener\SaveFile, Extension
	If ErrorLevel
		Extension = PNG

	;ScreenShots - Tab
	RegRead, pSave, HKCU, Software\Screener\ScreenShots, pSave
	If ErrorLevel
		pSave = 1
	RegRead, pOpen, HKCU, Software\Screener\ScreenShots, pOpen
	If ErrorLevel
		pOpen = 0
	RegRead, pCopy, HKCU, Software\Screener\ScreenShots, pCopy
	If ErrorLevel
		pCopy = 0

	RegRead, Region, HKCU, Software\Screener\ScreenShots, Region
	If ErrorLevel
		Region = Full Screen
	RegRead, HideMouse, HKCU, Software\Screener\ScreenShots, HideMouse
	If ErrorLevel
		HideMouse = 1

	RegRead, lSave, HKCU, Software\Screener\ScreenShots, lSave
	If ErrorLevel
		lSave = 1
	RegRead, lOpen, HKCU, Software\Screener\ScreenShots, lOpen
	If ErrorLevel
		lOpen = 0
	RegRead, lCopy, HKCU, Software\Screener\ScreenShots, lCopy
	If ErrorLevel
		lCopy = 0

	;Effects - Tab
	RegRead, Gray, HKCU, Software\Screener\Effects, Gray
	If ErrorLevel
		Gray = 0
	RegRead, SwapBW, HKCU, Software\Screener\Effects, SwapBW
	If ErrorLevel
		SwapBW = 0
	RegRead, Negative, HKCU, Software\Screener\Effects, Negative
	If ErrorLevel
		Negative = 0

	RegRead, ChkSharp, HKCU, Software\Screener\Effects, ChkSharp
	If ErrorLevel
		ChkSharp = 0
	RegRead, ChkCont, HKCU, Software\Screener\Effects, ChkCont
	If ErrorLevel
		ChkCont = 0
	RegRead, ChkBright, HKCU, Software\Screener\Effects, ChkBright
	If ErrorLevel
		ChkBright = 0

	RegRead, SharpVal, HKCU, Software\Screener\Effects, SharpVal
	If ErrorLevel
		SharpVal = 10
	RegRead, ContVal, HKCU, Software\Screener\Effects, ContVal
	If ErrorLevel
		ContVal = 20
	RegRead, BrightVal, HKCU, Software\Screener\Effects, BrightVal
	If ErrorLevel
		BrightVal = 30

	RegRead, ChkResize, HKCU, Software\Screener\Effects, ChkResize
	If ErrorLevel
		ChkResize = 0
	RegRead, ResizeWidth, HKCU, Software\Screener\Effects, ResizeWidth
	If ErrorLevel
		ResizeWidth = %A_ScreenWidth%
	RegRead, ResizeHeight, HKCU, Software\Screener\Effects, ResizeHeight
	If ErrorLevel
		ResizeHeight = %A_ScreenHeight%

	RegRead, AspectRatio, HKCU, Software\Screener\Effects, AspectRatio
	If ErrorLevel
		AspectRatio = 0
	RegRead, Resample, HKCU, Software\Screener\Effects, Resample
	If ErrorLevel
		Resample = 0

	RegRead, Rotate, HKCU, Software\Screener\Effects, Rotate
	If ErrorLevel
		Rotate = None
	RegRead, Flip, HKCU, Software\Screener\Effects, Flip
	If ErrorLevel
		Flip = None
}
Return

;Helper Function
Bind(Byref Var, LBound, UBound)
{
	If Var < %LBound%
		Var = %LBound%
	Else If Var > %UBound%
		Var = %UBound%
}

;############################################################################
							;Screen Functions
;############################################################################

/*
	SelectArea()
	Returns selected area. Return example: 22|13|243|543
	Options: (White space separated)
	- c color. Default: Blue.
	- t transparency. Default: 50.
	- g GUI number. Default: 99.
	- m CoordMode. Default: s. s = Screen, r = Relative
 */
SelectArea(Options="")
{
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
