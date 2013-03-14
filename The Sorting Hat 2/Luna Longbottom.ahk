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

;##### Wizard Screen - 1
Gui, 1:Color, FFFFFF
Gui, 1:Add, Picture, x12 y8, Data\Main.png
Gui, 1:Font, W550 s16
Gui, 1:Add, Text, x170 y8 w285 h50, Welcome to The Sorting Hat Wizard
Gui, 1:Font
Gui, 1:Font, s8, Verdana
Gui, 1:Add, Text, x170 y87 w285 , This wizard will help you sort your files.  Just answer a few simple questions and the hat does the rest.
Gui, 1:Add, Text, xp yp+60 wp , If you don't wat to use this wizard, simply press Cancel and you will have access to the advanced features of sorting hat.
Gui, 1:Add, Checkbox, x12  y388, &Do not show this Wizard on startup.
Gui, 1:Add, Button,   x245 yp-4 w75 Disabled, < &Back
Gui, 1:Add, Button,   xp+75 yp wp vNextBtn gNextBtn, &Next >
Gui, 1:Add, Button,   xp+85 yp wp gGuiClose, Cancel

;##### Wizard Screen - 2



Gui, 1:Show, x137 y95 h416 w489 Center, Sorting Hat Wizard

GuiControl, Focus, NextBtn
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