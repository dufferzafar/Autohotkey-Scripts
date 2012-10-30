/*
			 Magical Desktops  			
		Multiple Desktops Made Easy!!	

features:-
	themes - 
		wallpaper, icons (& their positions)
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
#Persistent						;Keep running until the user asks to exit.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1

;######################################################## Global Variables
Name := "Magic Desk", Version := "v0.1.5", CodeName := ""

layoutsIni := "Data\Layouts.ini"
desksIni := "Data\Desks.ini"

desksDir := A_MyDocuments "\Magical Desktops"
FileCreateDir, %desksDir%\Current

;############################################# Load Settings from IniFiles

IniRead, Layouts, %layoutsIni%, Settings, Layouts
IniRead, Desks, %desksIni%, Settings, Desks

;#################################################### The Tray Menu & Icon
Menu, Tray, NoStandard
Menu, Tray, Icon, Data\Effects.ico
Menu, Tray, Tip, The Magic Desk

Menu, Tray, Add, Save Desktop, SaveDesktop
GoSub, DeskLoadMenu

Menu, Tray, Add
Menu, Tray, Add, Save Layout, SaveLayout
GoSub, LayoutLoadMenu

Menu, Tray, Add
Menu, Tray, Add, Exit, CloseMe

Return
;################################################################ Desktops

SaveDesktop:
	InputBox, desktopName, Save Current Desktop, The name of the desktop, ,200, 120
	newDeskDir := desksDir "\" desktopName
	
	If FileExist(newDeskDir)
	{
		Msgbox, 36, Desktop already exists, Do you want to update it?`nAll previous files and folders would be deleted.
	}
	Else
	{	
		;Copy th current desktop to specified folder
		FileCopyDir, %A_Desktop%, %newDeskDir%
		
		If(Desks)
			Desks := Desks "|" desktopName
		Else
			Desks := desktopName
		
		IniWrite, % Desks, %desksIni%, Settings, Desks
		
		GoSub, DeskLoadMenu
	}	
Return

LoadDesktop:
	;The Wallpaper should be BMP
	; FinalPaper := "pSych0.BMP"
	; DllCall( "SystemParametersInfo", UInt, 0x14, UInt, 0, Str, FinalPaper, UInt, 1 )	
	
	;Move the current desktop to a new place
	; FileDelete,  %desksDir%\Current\*.*
	; FileCopyDir, %A_Desktop%, %desksDir%\Current, 1
	; FileDelete,  %A_Desktop%\*.*
	
	; Sleep, 1500
		
	;Now move our new desktop to the "Desktop" folder
	FileCopyDir, %desksDir%\%A_ThisMenuItem%, %A_Desktop%, 1
	
	Sleep, 1000
	
	; Msgbox, Hey
	
	; Set Default Layout
	IniRead, coords, %layoutsIni%, Simple, IconPos
	DeskIcons(RegExReplace(coords, "`/#`/", "`n"))
Return

DeskLoadMenu:
	If (Desks)
	{
		Loop, Parse, Desks, |
			Menu, DeskLoadMenu, Add, %A_LoopField%, LoadDesktop
		Menu, Tray, Add, Load Desktop, :DeskLoadMenu
	}
	Else
		Menu, Tray, Add, Load Desktop, NoDesktop
Return

NoDesktop:
	Msgbox, 16, No 'Magical' Desktop Exists, Please save a desktop first.
Return
;################################################################# Layouts

SaveLayout:
	InputBox, layoutName, Save Current Layout, The name of the layout.`nIt would be updated if it already exists., ,240, 140
	
	;See If Layout Already Exists
	If InStr(Layouts, layoutName)
		IniWrite, % RegExReplace(DeskIcons(), "`n", "`/#`/"), %layoutsIni%, %layoutName%, IconPos
	Else
	{	
		If(Layouts)
			Layouts := Layouts "|" layoutName
		Else
			Layouts := layoutName
		
		IniWrite, % Layouts, %layoutsIni%, Settings, Layouts	
		IniWrite, % RegExReplace(DeskIcons(), "`n", "`/#`/"), %layoutsIni%, %layoutName%, IconPos	
		
		GoSub, LayoutLoadMenu
	}	
Return

LoadLayout:
	IniRead, coords, %layoutsIni%, %A_ThisMenuItem%, IconPos
	DeskIcons(RegExReplace(coords, "`/#`/", "`n"))
Return

LayoutLoadMenu:
	If (Layouts)
	{
		Loop, Parse, Layouts, |
			Menu, LayoutLoadMenu, Add, %A_LoopField%, LoadLayout
		Menu, Tray, Add, Load Layout, :LayoutLoadMenu
	}
	Else
		Menu, Tray, Add, Load Layout, NoLayout
Return

NoLayout:
	Msgbox, 16, No Layout Exists, Please save a layout first.
Return

;############################################################ Misc. Labels

CloseMe:
Exitapp

MoveFilesAndFolders(Source, Destination, DoOverwrite = false)
{
    ;Move files
    FileMove, %Source%, %Destination%, %DoOverwrite%
    ErrorCount := ErrorLevel
	
    if DoOverwrite = 1
        DoOverwrite = 2
		
    ;Move Folders
    Loop, %Source%, 2
    {
        FileMoveDir, %A_LoopFileFullPath%, %Destination%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
    }
    return ErrorCount
}

#Include Data\DeskIcons.ahk