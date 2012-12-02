/*

		  Developer Helper v0.6			
			Develop Easily!				

To Do:
¯¯¯¯¯¯
-

Revision History:
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
# v0.1 [3]-[06]-[2011]
* initial release

*/

;Settings
#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.
SendMode Input  				;Recommended due to its superior speed and reliability.

#Warn

OnExit, ExitSub

;Set the icon if the exist
IfExist, %A_ScriptDir%\Data\Icons\Sec.ico
	Menu, Tray, Icon, %A_ScriptDir%\Data\Icons\Sec.ico
	
Menu, Tray, Icon	;else show default icon

;Variables
Version = 0.1

;############################################################################
							;Basic Code Completion
;############################################################################

#Hotstring r EndChars `n

;Basic If-Commands
:o:if::If{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:ifexist::IfExist{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:ifnotexist::IfNotExist{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:ifwinexist::IfWinExist{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:ifwinnotexist::IfWinNotExist{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:ifwinactive::IfWinActive{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:ifwinnotactive::IfWinNotActive{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:else::Else{Enter}{Tab}{{}{Enter}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:elseif::Else{Space}If{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}

;Flow of Control
:o:while::While{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Up 3}{End}{Space}
:o:loop::Loop{Enter}{{}{Enter}{Tab}{Enter}{BS}{}}{Enter 2}{BS}Until{Space}{Up 5}{End}{Space}  

;Block
;:o:{::{{}{Enter}{Tab}{Enter}{Bs}{}}{Up}{End}

;Commands I use
:o:AutoExe::
	Send {#}NoEnv{Enter}{#}SingleInstance Force{Enter}SetWorkingDir `%A_ScriptDir`%
	Send {Enter 2}Return{Space};End of AutoExecute Section{Enter};{_ 41}{Enter}
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
		;Create a file
		Random, RandomName, 1, 99999
		FileAppend, SetWorkingDir `%A_Temp`%`n`n, %A_Temp%\DevHelp-Executed-%RandomName%.ahk
		FileAppend, %selection%, %A_Temp%\DevHelp-Executed-%RandomName%.ahk
		
		;Execute it
		Run, %A_Temp%\DevHelp-Executed-%RandomName%.ahk	
	}
Return

;Save selected text as a file				    Ctrl + E
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
		InputBox, FileName, Filename, Please enter a filename with extension.
		FileAppend, %selection%, %A_Desktop%\%FileName%
	}
Return

;############################################################################
							;Context Sensetive
;############################################################################

#IfWinActive ahk_class Notepad++

	;Run opened script						 Ctrl + Shift + S
	^+s::
		Send ^s
		Sleep 100
		WinGetTitle, wTitle, ahk_class Notepad++
		StringTrimRight, ScriptPath, wTitle, 12
		Run, %ScriptPath%
	Return

#If

;############################################################################
							;Miscellaneous Labels
;############################################################################

ExitSub:
	Loop, %A_Temp%\*.ahk
		FileDelete, %A_LoopFileFullPath%
ExitApp
