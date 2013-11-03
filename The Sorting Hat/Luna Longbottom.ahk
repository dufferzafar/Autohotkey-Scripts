/*
				The Sorting Hat  			
		A File Sorter For Your Daily Needs	
				Version RC 1.3

Tools used -
	Autohotkey_L - The Compiler
	Notepad++ for coding
	GIMP 2.8 for logo design

Released On - 10/08/2012
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

;############################################################# Dependencies

#Include, dep.gui.Wizard.ahk


;############################################################# Global Variables
Name := "The Sorting Hat", Version := "v1.4", CodeName := "Luna Longbottom"

isDestShown := False		;Used by - DestinationDDL

cGui := 1

;######################################################### The Tray Menu & Icon
{
Menu, Tray, NoStandard
Menu, Tray, Icon, Data\Main.ico
Menu, Tray, Tip, The Sorting Hat

; Menu, Tray, Add, Restore, GuiShow
Menu, Tray, Add
Menu, Tray, Add, Exit, CloseMe

; Menu, Tray, Click, 1
; Menu, Tray, Default, Restore
}

;############################################################## Create Main GUI

GoSub, createWizard

; Gui, 1:Show, x432 y139 h416 w491, New GUI Window
; GuiControl, Focus, NextBtn
Return

;#########################################################
				 ;Wizard Events Labels
;#########################################################

NextBtn:
	cGui++
	Gui, %cGui%:Show
Return

PrevBtn:

Return

CancelBtn:

Return

;#########################################################
				 ;Tray Menu Events Labels
;#########################################################

;Menu Functions
GuiClose:
CloseMe:
 ExitApp

;Show Settings Dialog
Settings:
	Gui, 1:Show
Return