/*

						Windows Helper v0.6							
			Getting most out of Windows using Hotkeys				

I have done nothing new....

All this might have been posted over the forums thousands of times.
This is just my compilation of all the best work done by eminent people.

Some of the features have been copied from some or the other source and
I have edited the rest to get the best out of them.

Inspiration:- 7plus by Christian Sander

KeyList:- 
	^BS			--		Delete a Word (forward)
	^Del		--		Delete a Word (backward)
	^v			--		Paste Text Simply in Command Prompt
	^w			--		Same Like Alt+F4
	^+r			--		Reload Windows Helper.ahk
	^+a			--		Run Autohotkey Help File
	^+s			--		Run Currently Opened File in Notepad++
	^+Esc		--		Run TaskManager(after enabling it)
	!^r			--		Run Regedit(enable, delete lastkey)
	!^e			--		Run Restart Explorer
	!^c			--		Run Calculator
	!^s			--		Save Selected Text as a File
	#w			--		Toggle WordWrap in Notepad
	#t			--		Toggle AlwaysOnTop
	#y			--		Toggle File Extensions
	#h			--		Toggle Hidden Files & Folders
	#j			--		Toggle System Hidden Files & Folders
	#c			--		Launch Command Prompt in Current Folder 
	#Space		--		Toggle Transparency & ClickThrough
	
	Windows Snap:- 
		#Numpad1
		#Numpad2
		#Numpad3
		#Numpad4
		#Numpad5
		#Numpad6
		#Numpad7
		#Numpad8
		#Numpad9
		#NumpadAdd
		#NumpadMult	
*/

;Removed Unnecessary Features - 11:17 AM Saturday, September 24, 2011

#Include %A_ScriptDir%\Data\Lib\WinSnap.ahk

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
#KeyHistory 0
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

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
TrayTip, Windows Helper v0.8,
(
I am up and running...

Consult Readme for the list of Hotkeys.	
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
	Gui, Add, Text, x75 y20 w220 h180 , Windows Helper v0.8
	Gui, Font, s11, Calibri
	Gui, Add, Text, x75 y70 w300 h180 , Helping you get most out of Windows.
	Gui, Add, Text, x75 y100 w300 h180 , Coded by - Shadab Zafar.
	IfExist, %A_ScriptDir%\Data\Icons\NewMain.ico
		Gui, Add, Picture, x5 y5 w50 h50, %A_ScriptDir%\Data\Icons\NewMain.ico
	Gui, Show, h256 w338 Center, About WinHelper
Return

;Pressing Ctrl+Shift+X will Exit the Script
;^+x::ExitApp

;Ctrl+Shift+R will reload the Script
;^+r::Reload

;Ctrl+Shift+D will debug the script
;^+d::Menu, Tray, Standard

;######################################################
					;Run Utilities
;######################################################

^Space::
	IfWinExist, My Scriptlet Library
	{
		PostMessage, 0x112, 0xF060,,, My Scriptlet Library
		; WinClose , My Scriptlet Library
	}
	Else
	{
		ScriptletPath = "D:\I, Coder\My Projects\# Dev Zone\My Scriptlet Library\Scriptlet Library.ahk"
		SplitPath, ScriptletPath,,ScriptletDir
		Run, %ScriptletPath%, %ScriptletDir%
	}
Return
	
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
; !^e::
	; RunWait, taskkill /f /im explorer.exe, ,Hide
	; Process, Close, explorer.exe
	; Run, explorer.exe
; Return

;Launch Autohotkey HelpFile
^+a::
	;RunWait, unrar x -y hh.rar, %A_Windir%, Hide
	SplitPath, A_AhkPath,, ahk_dir
	Run, %ahk_dir%\AutoHotkey.chm, , Max
Return

;Launch Lua HelpFile
^+q::
	;RunWait, unrar x -y hh.rar, %A_Windir%, Hide
	Run, D:\I`, Coder\Scripts`, Codes & Tut\Lua\[Help]\Lua\luaaio.chm, , Max
Return

;######################################################
				;Window Ecnhancements
;######################################################

;Make switching between windows easier

;~MButton & WheelDown::AltTab	;MiddleMouseButton + Mouse Wheel Down
;~MButton & WheelUp::ShiftAltTab	;MiddleMouseButton + Mouse Wheel Up

$^w::
	If WinActive("ahk_class Notepad++") or WinActive("ahk_class SciTEWindow")
		Send ^w	
	Else
		Send !{f4}
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

;############################################################################
								;Some Dev Work
;############################################################################

;Run selected text	as script					 Ctrl + E
^e::
	tmp = %ClipboardAll% 	;save clipboard
	Clipboard := "" 		;clear
	Send, ^c 				;copy the selection	
	ClipWait, 3
	selection = %Clipboard% ;save the selection
	Clipboard = %tmp% 		;restore old content of the clipboard
	
	If selection <> 		;if something is selected
	{
		; Create a file
		Random, RandomName, 1, 99999
		FileAppend, SetWorkingDir `%A_Temp`%`n`n, %A_Temp%\DevHelp-Executed-%RandomName%.ahk
		FileAppend, %selection%, %A_Temp%\DevHelp-Executed-%RandomName%.ahk
		
		; Execute it
		Run, %A_Temp%\DevHelp-Executed-%RandomName%.ahk	
	}
Return

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
		InputBox, FileName, Filename, Please enter a filename with extension., ,250, 150
		SplitPath, FileName, , , Ext
		If Ext <>		
			FileAppend, %selection%, %A_Desktop%\%FileName%
		Else
			FileAppend, %selection%, %A_Desktop%\%FileName%.ahk
	}
Return

;###################################################### It is advisable to put this
				;Context-Sensitive Hotkeys			    section at the end to avoid
;###################################################### disabling of some hotkeys.

;Improve Functionality of Delete & Backspace
; #If ActiveControlIsOfClass("Edit")
	; ^BS::Send ^+{Left}{Del}
	; ^Del::Send ^+{Right}{Del}
	; !D::
		; FormatTime, Stamp, ,d-M-yyyy h-mm-tt
		; Send, %A_Space% %Stamp%
	; Return
; #If
;Get the class of current control


#IfWinActive ahk_group Explorer
	$BS::
		If ActiveControlIsOfClass("Edit")
			Send {BS}
		Else
			PostMessage, 0x111, 40994,,,ahk_class CabinetWClass
	Return


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
	; #h::
		; RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
		; If HiddenFiles_Status = 2
			; RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
		; Else
			; RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
		; Refresh()
	; Return

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

	;Rename Files - Add Text
	; ^r::
		; InputBox, FileType, FileType, Enter the extension of files that you want to be renamed., ,250, 150
		
		; If FileType <> 
			; InputBox, AddWhat, Text to Add, Enter the text that you want to be added to all files., ,350, 150
		
		; If AddWhat <>
		; {
			; Loop, %A_ScriptDir%\*.%FileType%
			; {
				; StringTrimRight, FileName, A_LoopFileName, StrLen(A_LoopFileExt) + 1
				; LoopFileName = %FileName%-%AddWhat%
				; FileMove, %A_LoopFileFullPath%, %A_ScriptDir%\%LoopFileName%.%A_LoopFileExt%
			; }
		; }

#If

; #IfWinActive ahk_class ConsoleWindowClass
	; Paste just like any other window					Ctrl+V
	; ^v::
		; SendRaw %clipboard%
	; Return	
; #If

; #IfWinActive ahk_class Notepad

	; Toggle Wordwrap									Win+W
	; #w::
		; Send !ow
	; Return
	
; #If

#IfWinActive ahk_class Notepad++

	;Run opened script						 Ctrl + Shift + S
	^+s::
		Send ^s
		Sleep 100
		WinGetTitle, wTitle, ahk_class Notepad++
		StringTrimRight, ScriptPath, wTitle, 12
		If InStr(wTitle, ".lua") or InStr(wTitle, ".ahk")
		{
			SplitPath, wTitle,,workingDir			
			Run, %ScriptPath%, %workingDir%
		}
		Else
		{
			Run, %ScriptPath%
		}
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

ActiveControlIsOfClass(Class)
{
	ControlGetFocus, FocusedControl, A
	ControlGet, FocusedControlHwnd, Hwnd,, %FocusedControl%, A
	WinGetClass, FocusedControlClass, ahk_id %FocusedControlHwnd%
	return (FocusedControlClass=Class)
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
