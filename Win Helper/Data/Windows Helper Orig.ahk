/*

						Windows Helper v0.6							
			Getting most out of Windows using Hotkeys				

I have done nothing new....

All this might have been posted over the forums thousands of times.
This is just my compilation of all the best work done by eminent people.

Some of the features have been copied from some or the other source and
I have edited the rest to get the best out of them.

Inspiration:- 7plus by Christian Sander

*/

#Include %A_ScriptDir%\Data\Lib\WinSnap.ahk

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.
;SendMode Input  				;Recommended due to its superior speed and reliability.

OnExit, ExitSub

;Create a group of explorer windows
GroupAdd, Explorer, ahk_class CabinetWClass
GroupAdd, Explorer, ahk_class Progman

;Modify the Menu
Menu, Tray, NoStandard
Menu, Tray, Tip, Windows Helper v0.3

Menu, Tray, Add, &About..., AboutMe
Menu, Tray, Add
Menu, Tray, Add, &Suspend, SuspendMe
Menu, Tray, Add, &Exit, CloseMe

Menu, Tray, Default, &About...

;Set the icon if the exist
IfExist, %A_ScriptDir%\Data\Icons\KBMain.ico
	Menu, Tray, Icon, %A_ScriptDir%\Data\Icons\KBMain.ico
IfExist, %A_ScriptDir%\Data\Icons\Main.ico
	Menu, Tray, Icon, &About..., %A_ScriptDir%\Data\Icons\Main.ico
IfExist, %A_ScriptDir%\Data\Icons\Main.ico
	Menu, Tray, Icon, &Exit, %A_ScriptDir%\Data\Icons\Exit.ico
	
Menu, Tray, Icon	;else show default icon

;Let the user know that the utility has started
TrayTip, Windows Helper v0.7,
(
I am up and running...
	
Consult Readme for the list of Hotkeys.	
Press Ctrl+Shift+X to Exit.
)
SetTimer, RemoveTrayTip, 1000

Return	 ;End of Auto Execute Section
;_____________________________________________

;Menu Functions
CloseMe:
	ExitApp

SuspendMe:
	Suspend, Toggle
	Menu, Tray, ToggleCheck, &Suspend
	If A_IsSuspended = 1
		Menu, Tray, Icon, %A_ScriptDir%\Data\Icons\KBRed.ico, ,1
	Else
		Menu, Tray, Icon, %A_ScriptDir%\Data\Icons\KBMain.ico, ,1
Return

AboutMe:
	Gui, -MaximizeBox -MinimizeBox +AlwaysOnTop
	Gui, Font, s19, Calibri
	Gui, Add, Text, x75 y20 w220 h180 , Windows Helper v0.7
	Gui, Font, s11, Calibri
	Gui, Add, Text, x75 y70 w300 h180 , Helping you get most out of Windows.
	Gui, Add, Text, x75 y100 w300 h180 , Coded by - Shadab Zafar.
	IfExist, %A_ScriptDir%\Data\Icons\NewMain.ico
		Gui, Add, Picture, x5 y5 w50 h50, %A_ScriptDir%\Data\Icons\NewMain.ico
	Gui, Show, h256 w338 Center, About WinHelper
Return

;Pressing Ctrl+Shift+X will Exit the Script
^+x::ExitApp

;Ctrl+Shift+R will reload the Script
^+r::Reload

;Ctrl+Shift+D will debug the script
;^+d::Menu, Tray, Standard

;######################################################
					;Run Utilities
;######################################################

;Block Right Key
;Right::
;Return

;Launch Notepad											Win+N
#n::Run, notepad.exe, , UseErrorLevel
	If ErrorLevel
	{
		Soundplay, *-1
		Return
	}

;Launch Microsoft Paint									Win+P
#p::Run, mspaint.exe, , UseErrorLevel
	If ErrorLevel
	{
		Soundplay, *-1
		Return
	}

;Launch Windows Media Player						Alt+Win+M
!^m::Run, wmplayer.exe, , UseErrorLevel
	If ErrorLevel
	{
		Soundplay, *-1
		Return
	}

;Launch Internet Explorer								Win+I
#i::Run, iexplore.exe, , UseErrorLevel
	If ErrorLevel
	{
		Soundplay, *-1
		Return
	}
	
;Launch Calculator									Alt+Ctrl+C
!^c::
	IfWinExist, Calculator	
	{
		WinKill, Calculator
		SetNumLockState, Off
	}
	Else
	{
		Run, calc.exe
		SetNumLockState, On		
	}
Return
	
;Launch TaskMnager after enabling it		   Ctrl+Shift+Esc
^+Esc::
    RegDelete, HKCU, Software\Microsoft\Windows\CurrentVersion\Policies
	RegDelete, HKCU, Software\Microsoft\Windows NT\CurrentVersion\TaskManager
	
	RegDelete, HKLM, Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
	
	RegDelete, HKLM, SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon, DisableCAD
	RegDelete, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System, DisableTaskMgr
	
	Run Taskmgr.exe	
Return

;Launch Regedit after enabling it		   		   Alt+Ctrl+R
!^r::
	RegDelete, HKCU, Software\Microsoft\Windows\CurrentVersion\Policies
	RegDelete, HKCU, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey
	
	Run Regedit.exe, , Max
Return

;Launch Regedit after enabling it		   		   Alt+Ctrl+R
!^e::
	;RunWait, taskkill /f /im explorer.exe, ,Hide
	Process, Close, explorer.exe
	Run, explorer.exe
Return

;Lookup Google for the selected text					Win+G
#g::	
	tmp = %ClipboardAll% 	;save clipboard
	Clipboard := "" 		;clear
	Send, ^c 				;copy the selection
	selection = %Clipboard% ;save the selection
	Clipboard = %tmp% 		;restore old content of the clipboard
	
    If selection <> 		;if something is selected
        Run, "http://www.google.com/search?q=%selection%", , UseErrorLevel
    Else					;if nothing is selected
        Run, "http://www.google.com/", , UseErrorLevel

	If ErrorLevel
	{
		Soundplay, *-1
		Return
	}		
Return

;Automatically save a screenshot						Win+PrintScreen
#PRINTSCREEN::
	Send {PRINTSCREEN}
	Run, mspaint.exe
	WinWaitActive, untitled - Paint
	{		
		;Set Bitmap Size to 1*1 to remove any white spaces
		Send ^e	
		Send 1{TAB}1{ENTER}
		;Paste
		Send ^v	
		;Save
		Send ^s	
		;Name of the screenshot file
		Send Screenshot-%A_DD%-%A_MMM%-%A_YYYY%-%A_Hour%-%A_Min%-%A_Sec%
		;Change File format to PNG
		Send {TAB}P{ENTER}
	}
	Sleep 1500
	WinKill, ahk_class MSPaintApp
Return

^+a::
	;RunWait, unrar x -y hh.rar, %A_Windir%, Hide
	SplitPath, A_AhkPath,, ahk_dir
	Run, %ahk_dir%\AutoHotkey.chm, , Max
Return

;######################################################
				;Window Ecnhancements
;######################################################

;Make switching between windows easier

;~MButton & WheelDown::AltTab	;MiddleMouseButton + Mouse Wheel Down
;~MButton & WheelUp::ShiftAltTab	;MiddleMouseButton + Mouse Wheel Up

;Easier MaxMin
#WheelDown::					;			   Win + Mouse Wheel Down
	WinMinimizeAll
Return

#WheelUp::						;			   Win + Mouse Wheel Up
	WinMinimizeAllUndo
Return

;Advanced Windows Snapping
#Numpad1::Win__QuarterBottomLeft("A")
#Numpad2::Win__HalfBottom("A")
#Numpad3::Win__QuarterBottomRight("A")
#Numpad4::Win__HalfLeft("A")
#Numpad5::Win__Centre("A")
#Numpad6::Win__HalfRight("A")
#Numpad7::Win__QuarterTopLeft("A")
#Numpad8::Win__HalfTop("A")
#Numpad9::Win__QuarterTopRight("A")

;Maximize Active Window
#NumpadAdd::WinMaximize, A

;Minimize Active Window
#NumpadSub::
	IfWinActive ahk_class Shell_TrayWnd
		Return ;Spare the Taskbar
	WinMinimize, A
Return

;Windows 7 like Snap
;*~LButton::Win__MouseMove()

;Drag from anywhere in a window							   Win+LButton
;#LButton::Win__Drag()

;Resize from anywhere in a window						   Win+RButton
;#RButton::Win__Resize()

;Grid All windows of same type						  	 Win+0 & Win+.
#Numpad0::Win__Gridder(true)
#NumpadDot::Win__Gridder(false)

;Roll up the active window to its title bar						 Win+*
#NumpadMult::
	IfWinActive ahk_class DV2ControlHost
		Return ;Spare the StartMenu

	;Get the active Window's ID
	WinGet, ws_ID, ID, A
	
	Loop, Parse, ws_IDList, |
	{
		IfEqual, A_LoopField, %ws_ID%
		{
			; Match found, so this window should be restored (unrolled):
			StringTrimRight, ws_Height, ws_Window%ws_ID%, 0
			WinMove, ahk_id %ws_ID%,,,,, %ws_Height%
			StringReplace, ws_IDList, ws_IDList, |%ws_ID%
			return
		}
	}
	
	WinGetPos,,,, ws_Height, A
	ws_Window%ws_ID% = %ws_Height%
	WinMove, ahk_id %ws_ID%,,,,, 25
	ws_IDList = %ws_IDList%|%ws_ID%	
Return

;Toggle the topmost window's AlwaysOnTop status					 Win+T
#t::
	WinSet, AlwaysOnTop, Toggle, A
Return

;Toggle the topmost window's Transparency status 		Win+Space
#Space::		
WinGet, Trans, Transparent, A

If WinActive("ahk_class Shell_TrayWnd") or WinActive("ahk_class Progman") or WinActive("ahk_class DV2ControlHost")
		Return	;Spare the Taskbar, Desktop & StartMenu

Else If Trans = 50	;Window is already transparent
	{	
		I := WinExist("A")		
        WinSet, Transparent, Off, % "ahk_id " I
        WinSet, ExStyle, -0x20, % "ahk_id " I
		
	}
Else		;Window is not transparent, Make it
	{	
		I := WinExist("A")
        WinSet, Transparent, 50, % "ahk_id " I
        WinSet, ExStyle, +0x20, % "ahk_id " I
	}
Return

;######################################################
					;Tweak Settings
;######################################################

;Toggle Extensions										Win+Y
#y::
    RegRead, FileExt_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
    If FileExt_Status = 1
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
    Else
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
	Refresh()
Return


;Toggle Hidden Files & Folders							Win+H
#h::
    RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
    If HiddenFiles_Status = 2
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
    Else
        RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
	Refresh()
Return


;Toggle System Hidden Files & Folders					Win+J
#j::
    RegRead, SuperHidden_Status, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden
    If SuperHidden_Status = 0
		{
			RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
			RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 1
		}
    Else
		{
			RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
			RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 0
		}
	Refresh()
Return

;############################################################################
								;Some Dev Work
;############################################################################

;Run selected text	as script					 Ctrl + E
/*
^e::
	tmp = %ClipboardAll% 	;save clipboard
	Clipboard := "" 		;clear
	Send, ^c 				;copy the selection	
	ClipWait, 3
	selection = %Clipboard% ;save the selection
	Clipboard = %tmp% 		;restore old content of the clipboard
	
	If selection <> 		;if something is selected
	{
		;Create a file
		Random, RandomName, 1, 99999
		FileAppend, SetWorkingDir `%A_Temp`%`n`n, %A_Temp%\DevHelp-Executed-%RandomName%.ahk
		FileAppend, %selection%, %A_Temp%\DevHelp-Executed-%RandomName%.ahk
		
		;Execute it
		Run, %A_Temp%\DevHelp-Executed-%RandomName%.ahk	
	}
Return
*/

;Run selected text as script					  Alt + Ctrl + S
!^s::
	tmp = %ClipboardAll% 	;save clipboard
	Clipboard := "" 		;clear
	Send, ^c 				;copy the selection	
	ClipWait, 3	
	selection = %Clipboard% ;save the selection
	Clipboard = %tmp% 		;restore old content of the clipboard
	
	If selection <> 		;if something is selected
	{
		;Create a file
		InputBox, FileName, Filename, Please enter a filename with extension., ,350, 150
		FileAppend, %selection%, %A_Desktop%\%FileName%
	}
Return

;###################################################### It is advisable to put this
				;Context-Sensitive Hotkeys			    section at the end to avoid
;###################################################### disabling of some hotkeys.

;Improve Functionality of Delete & Backspace
#If ActiveControlIsOfClass("Edit")
	^BS::Send ^+{Left}{Del}		;			   Ctrl + Bkspace
	^Del::Send ^+{Right}{Del}	;			    Ctrl + Delete

	;Get the class of current control
	ActiveControlIsOfClass(Class)
	{
		ControlGetFocus, FocusedControl, A
		ControlGet, FocusedControlHwnd, Hwnd,, %FocusedControl%, A
		WinGetClass, FocusedControlClass, ahk_id %FocusedControlHwnd%
		return (FocusedControlClass=Class)
	}
#If

#IfWinActive ahk_group Explorer

	;Help with creating a shortcut			Ctrl + Shift + C
	^+c::
		Clipboard = 		;Should be empty
		Send ^c				;Copy selected files to clip
		ClipWait 2
		if ErrorLevel
			Return			;Exit if can't copy

		FileList = %Clipboard%
		
		FileSelectFolder, TargetFolder, *%A_Startup%, 3, Select the folder in which the shortcut(s) will be created.
		If TargetFolder =
			Return
			
		Loop, parse, FileList, `n, `r
		{
			SplitPath, A_LoopField, , , , FileName	;FileName with No Extension
			FileCreateShortcut, %A_LoopField%, %TargetFolder%\%FileName%.lnk
		}
	Return	
	
	;Help with creating a quick launch entry		Ctrl + Shift + Q
	^+q::
		Clipboard = 		;Should be empty
		Send ^c				;Copy selected files to clip
		ClipWait 2
		if ErrorLevel
			Return			;Exit if can't copy

		FileList = %Clipboard%
		
		Loop, parse, FileList, `n, `r
		{
			SplitPath, A_LoopField, , , , FileName	;FileName with No Extension
			FileCreateShortcut, %A_LoopField%, %A_AppData%\Microsoft\Internet Explorer\Quick Launch\%FileName%.lnk
		}
	Return
	
	;Enable Windows Picture & Fax Viewer
	!#s::
		FileAppend,
		(
`;`; ReplacerScript
shimgvw.dll,CopyData\shimgvw.dll
		), dllFiles.txt
	
		RunWait, CopyData\Replacer.cmd dllFiles.txt, , Hide
		;RunWait, regedit.exe /s CopyData\restorewpf.reg
		Run, regsvr32 /s /i shimgvw.dll
		
		FileDelete, dllFiles.txt
		Refresh()
	Return	

	;Launch Command Prompt in the current folder	Win+C
	#c::
		;Get the full path from the address bar
		WinGetText, full_path, A

		;Split on newline (`n)
		StringSplit, word_array, full_path, `n
		
		; Take the first element from the array
		full_path = %word_array1%

		;Remove all carriage returns (`r)
		StringReplace, full_path, full_path, `r, , all

		IfInString full_path, \
		{
			Run, cmd /K cd /D "%full_path%"
		}
		else ;If path is not valid
		{
			Run, cmd /K cd /D "C:\ "
		}
	Return
	
	;Launch Command Prompt in the current folder	Win+C
	;BS::
	
	;Return
#If

#IfWinActive ahk_class ConsoleWindowClass

	;Scroll using keyboard in a command window			PageUp or PageDown
	PgUp::
		Send {WheelUp}
	Return

	PgDn::
		Send {WheelDown}
	Return

	;Close CommandPrompt just like any other window		Alt+F
	!F4::
		WinKill ahk_class ConsoleWindowClass
	Return
	
	;Paste just like any other window					Ctrl+V
	^v::
		SendRaw %clipboard%
	Return
	
#If

#IfWinActive ahk_class Notepad

	;Toggle Wordwrap									Win+W
	#w::
		Send !ow
	Return
	
#If

#IfWinActive ahk_class Notepad++

	;Run opened script						 Ctrl + Shift + S
	^+s::
		Send ^s
		Sleep 100
		WinGetTitle, wTitle, ahk_class Notepad++
		StringTrimRight, ScriptPath, wTitle, 12
		If InStr(wTitle, ".lua")
		{
			SplitPath, wTitle,,workingDir			
			Run, %ScriptPath%, %workingDir%
		}
		Else
			Run, %ScriptPath%
	Return

#If

;######################################################
					;Subroutines
;######################################################

RemoveTrayTip:
	SetTimer, RemoveTrayTip, Off
	TrayTip
Return

Refresh()
{
    WinGetClass, eh_Class, A
    If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
        Send, {F5}
	Else PostMessage, 0x111, 28931,,, A
}

ExitSub:
Loop, Parse, ws_IDList, |
{
    if A_LoopField =  ; First field in list is normally blank.
        continue      ; So skip it.
    StringTrimRight, ws_Height, ws_Window%A_LoopField%, 0
    WinMove, ahk_id %A_LoopField%,,,,, %ws_Height%
}
ExitApp
