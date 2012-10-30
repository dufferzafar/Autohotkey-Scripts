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

;########################################################## Global Variables
Name := "The Sorting Hat", Version := "RC 1.3", CodeName := "Release Cycle"

isDestShown := False		;Used by - DestinationDDL
;########################################################## The Tray Menu & Icon
{
Menu, Tray, NoStandard
Menu, Tray, Icon, Data\Main.ico
Menu, Tray, Tip, The Sorting Hat

Menu, Tray, Add, Restore, GuiShow
Menu, Tray, Add
Menu, Tray, Add, Exit, CloseMe

Menu, Tray, Click, 1
Menu, Tray, Default, Restore
}

;############################################################## Create Main GUI
{
Gui, 1:Add, Tab2, x-1 y0 h460 w480 vTabName, Main|Files && Folders*|About

Gui, 1:Tab, Main
	Gui, 1:Add, GroupBox, Section x6 y30 w460 h51, Source
		Gui, 1:Add, Edit, x15 ys+20 w370 h20 vSourceFolder, Drag 'n' Drop or Browse
		Gui, 1:Add, Button, x396 yp w60 h22 vBrowseSource gBrowseFolder, Browse
	
	Gui, 1:Add, GroupBox, Section x6 ys+61 w460 h108, FileTypes
		Gui, 1:Add, Text, xs+10 ys+22 h20, Select the filetypes that should be processed during the sort
	
		Gui, 1:Add, CheckBox, xs+10 yp+25, Audio
		Gui, 1:Add, CheckBox, xp+58 yp, Video
		Gui, 1:Add, CheckBox, xp+58 yp, Pictures
		Gui, 1:Add, CheckBox, xp+70 yp, Documents
		Gui, 1:Add, CheckBox, xp+88 yp, Compressed
		Gui, 1:Add, CheckBox, xp+90 yp, Executables
		
		Gui, 1:Add, CheckBox, xs+10 yp+30, Scripts
		
		Gui, 1:Add, CheckBox, x380 y168 gHTMLCheckBox Disabled, Webpages
		
		Gui, 1:Add, CheckBox, x74 y168 vAdvChecked gAdvancedCheckBox, Advanced Filters -
		Gui, 1:Add, Edit, x184 y165 w107 vAdvancedFilter Disabled, chm,pdf
	
	Gui, 1:Add, GroupBox, Section x6 ys+118 w460 h87, Sort Method
		Gui, 1:Add, Text, xs+10 ys+25, Sort method to use -
		Gui, 1:Add, DropDownList, x+6 yp-3 w160 vSortType gSortDDL, Copy|Move||Delete|Teracopy*
		Gui, 1:Add, Text, xs+10 yp+35, Do with same file names -
		Gui, 1:Add, DropDownList, x+6 yp-3 w135 vSameNameType, Ask*|Skip*|Rename*||Overwrite*|Keep newer*
		Gui, 1:Add, Text, x+60 yp-32 Disabled, Sort Engine: 
		Gui, 1:Add, Radio, xp+25 yp+20 Disabled, Quick		
		Gui, 1:Add, Radio, xp yp+20 Disabled, File Genie
	
	Gui, 1:Add, GroupBox, Section x6 ys+97 w460 h87, Destination
		Gui, 1:Add, Text, xs+10 ys+25 vDestinationLabel w170, Sorted files would be moved to    -
		Gui, 1:Add, DropDownList, x+6 yp-3 w160 vDestinationType gDestinationDDL, Same Folder||Use Folder Profiles*|Use Specified Folder
		Gui, 1:Add, Edit, xs+10 yp+30 w370 vDestinationFolder Disabled, Drag 'n' Drop or Browse
		Gui, 1:Add, Button, x396 yp w60 h22 vBrowseDest gBrowseFolder Disabled, Browse

	Gui, 1:Add, CheckBox, xs y+30 vOpenDest, Open destination directory after sorting.
	Gui, 1:Add, Button, xs+381 yp-8 w80 h30 gReadGuiSettings, Sort
	
Gui, 1:Tab,Files && Folders*
	Gui, 1:Add, GroupBox, Section x6 y30 w460 h182, Folder Paths
		Gui, 1:Add, Text, xs+10 ys+20, Profile   -
		Gui, 1:Add, DropDownList, x+11 yp-4, Default||Downloads|Custom
		Gui, 1:Add, Button, x+111 yp-2 w70 h25 Disabled, New
		Gui, 1:Add, Button, x+20 yp w70 h25 Disabled, Delete
		Gui, 1:Add, ListView, xs+10 yp+30 w442 h125 -Multi gLV_Click vPathLV, Folder|Path
	
	Gui, 1:Add, GroupBox, Section x6 ys+195 w460 h162, FileType Extensions
		Gui, 1:Add, ListView, xs+10 ys+25 w442 h125 -Multi gLV_Click vExtLV, FileType|Folder Name|Extensions
	
	Gui, 1:Add, Button, xs+386 y+25 w75 h30 Disabled, Save
	
	Gui, 1:Add, Picture, Section xs+100 yp-10, Data\UnderDev.png
	Gui, 1:Font, s12
	Gui, 1:Add, Text, x+10 yp+14, Under Development !!
	Gui, 1:Font
	
Gui, 1:Tab,About
	Gui, 1:Add, Picture, Section x7 y30, Data\Logo.png
	
	Gui, 1:Font, s10, Verdana
	Gui, 1:Add, Text, x8 y140, Written in
	Gui, 1:Add, Text, x277 y140, Completely
	Gui, 1:Add, Text, x427 y140, Code
	
	Gui, 1:Add, Text, x8 y180, Uses code fragments from:
	Gui, 1:Add, Text, xp+10 y+5, 'Sort Any Folder' script by Aaron Bewza
	Gui, 1:Add, Text, xp y+5, 'MoveOut' by Skrommel
	Gui, 1:Add, Text, xp-10 y+25, Fields, Disabled Or Marked by an asterisk * don't work.
	Gui, 1:Add, Text, xp y+5, Released only because of a special request by a friend.
	
	Gui, 1:Add, Text, x352 y390, by
	Gui, 1:Add, Text, xs yp Disabled, Version %Version% Beta
	Gui, 1:Add, Text, xp y+10 Disabled, Released 10/8/2012
	
	Gui, 1:Font, CBlue
	Gui, 1:Add, Text, x372 y390 gShadabZafar, Shadab Zafar
	Gui, 1:Add, Text, x80 y140 gAutohotkey, Autohotkey
	Gui, 1:Add, Text, x353 y140 gUnlicensed, Unlicensed	
	
	Gui, 1:Font, Strike
	Gui, 1:Add, Text, x180 y415 gGoogleCode Disabled, http://code.google.com/p/the-sorting-hat
	
	Gui, 1:Font
	
Gui, 1:Add, StatusBar,,	
}

;Show Main Gui
Gui, +LastFound
Gui, 1:Show, h465 w472 Center, %Name% - "%CodeName%"
mainGuiID := WinExist()

hCurs := DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE")
OnMessage(0x112, "WM_SYSCOMMAND")

GuiControl, Focus, BrowseSource

;############################################################ Create Edit Gui's
{
;For SysListView321
	Gui, 2:+Owner1
	Gui, 2:Add, Text,   x6 y8, Please enter an existing folder path to replace.
	Gui, 2:Add, Edit,   xs yp+23 w360 vNewFolderPath,
	Gui, 2:Add, Button, xs yp+30 w120 h30, Browse Folder
	Gui, 2:Add, Button, xp+120 yp wp hp gConfirm, Confirm
	Gui, 2:Add, Button, xp+120 yp wp hp g2GuiClose, Cancel
	
;For SysListView322
	Gui, 3:+Owner1
	Gui, 3:Add, Text, x6 y10, Extensions
	Gui, 3:Add, Edit, xp+70 yp-2 w290 vNewExtensions,
	Gui, 3:Add, Text, xs y40, Folder Name
	Gui, 3:Add, Edit, xp+70 yp-2 w290 vNewFolderName,

	Gui, 3:Add, Button, xs y70 w160 h30 gConfirm, Confirm
	Gui, 3:Add, Button, xp+200 yp wp hp g3GuiClose, Cancel
}

GoSub, ReadLV

SB_Message("OK","Ready...")

Return	 ;End of Auto Execute Section
;_____________________________________________

;#########################################################
				   ;Files & Folders Tab
;#########################################################

LV_Click:
	If (A_GuiEvent = "DoubleClick") And (A_EventInfo)
	{
		If (A_GuiControl = "PathLV")
		{
			Gui, ListView, SysListView321
			
			RowNum := A_EventInfo
		
			LV_GetText(Type, RowNum, 1)
			LV_GetText(FolderPath, RowNum, 2)
			
			GuiControl, 2:, NewFolderPath, % FolderPath
			
			Gui, 1:+Disabled
			Gui, 2:Show, w373, Edit '%Type%' Folder Path
			GuiControl, 2:Focus, Button2
		}
		Else If (A_GuiControl = "ExtLV")
		{
			Gui, ListView, SysListView322
		
			RowNum := A_EventInfo
	
			LV_GetText(Type, RowNum, 1)
			LV_GetText(FolderName, RowNum, 2)			
			LV_GetText(Extensions, RowNum, 3)
			
			GuiControl, 3:, NewExtensions, % Extensions
			GuiControl, 3:, NewFolderName, % FolderName
			
			Gui, 1:+Disabled
			Gui, 3:Show, w373, Edit '%Type%' Extensions
			GuiControl, 3:Focus, Button1
		}
	}
Return

Confirm:	
	Gui, 1:Default
	
	If (A_Gui = 2)
	{
		Gui, ListView, SysListView321
		Gui, 2:Submit, NoHide
		
		WinGetTitle, Title, A		
		RegExMatch(Title, "Edit '(.*)' Folder Path", Type)		
		
		If InStr(FileExist(NewFolderPath), "D")
			LV_Modify(RowNum, "", Type1, NewFolderPath)
		
		GoSub, 2GuiClose
	}
	Else If (A_Gui = 3)
	{
		Gui, ListView, SysListView322
		Gui, 3:Submit, NoHide
		
		WinGetTitle, Title, A
		RegExMatch(Title, "Edit '(.*)' Extensions", Type)	
	
		If (NewExtensions) And (NewFolderName)
			LV_Modify(RowNum, "", Type1, NewFolderName, NewExtensions)
		
		GoSub, 3GuiClose
	}
Return

ReadLV:
	Gui, ListView, SysListView321
	Loop, 9
	{
		i := A_Index + 3
		
		;Read Ini File
		ControlGetText, cbText, button%i%, ahk_id %mainGuiID%
		IniRead,FolderPath, Data\Settings.ini, Default, %cbText%
		
		If FolderPath = Error
			Continue
			
		LV_ADD("",cbText,RegExReplace(FolderPath, "MyDocuments", A_MyDocuments))
	}
	LV_ModifyCol()
	
	Gui, ListView, SysListView322
	Loop, 9
	{
		i := A_Index + 3
		
		;Read Ini File
		ControlGetText, cbText, button%i%, ahk_id %mainGuiID%
		IniRead,FileTypeLine, Data\Settings.ini, FileTypes, %cbText%
		
		If FileTypeLine = Error
			Continue
		
		;Read File Types
		DelimPos	:= InStr(FileTypeLine, "#")
		FolderName	:= SubStr(FileTypeLine, 1, DelimPos-1)
		Extensions	:= SubStr(FileTypeLine, DelimPos+1)
		
		LV_ADD("",cbText,FolderName,Extensions)
	}
	LV_ModifyCol()
Return

2GuiClose:
	Gui, 1:-Disabled
	Gui, 2:Hide
Return

3GuiClose:
	Gui, 1:-Disabled
	Gui, 3:Hide
Return

;#########################################################
			   ;Settings Gui Events Labels
;#########################################################

;Read Gui Settings and Perform Sort
ReadGuiSettings:
	Gui, Submit, NoHide
	
;While Debugging
; SourceFolder := "D:\Testing Sorter"
	
	;Source
	If Not InStr(FileExist(SourceFolder), "D") {
		SB_Message("Error","Select an existing source folder to sort.")
		Return
	}
	Else If (DestinationType = "Use Specified Folder") And (Not InStr(FileExist(DestinationFolder), "D")) {
		SB_Message("Error","Select an existing destination folder.")
		Return
	}
	
	;FileTypes
	typesCount := 0
	Loop, 8
	{
		i := A_Index + 3
		GuiControlGet, button%i%
		If button%i%
		{
			typesCount++
			;Read Ini File
			ControlGetText, cbText, button%i%, ahk_id %mainGuiID%
			IniRead, FileTypeLine, Data\Settings.ini, FileTypes, %cbText%
			;Extensions & Types
			DelimPos				:= 	InStr(FileTypeLine, "#")
			FileType%typesCount%	:= 	SubStr(FileTypeLine, 1, DelimPos-1)
			FileExt%typesCount%		:= 	SubStr(FileTypeLine, DelimPos+1)
		}
	}
	
	;Advanced Filter's
	If AdvChecked
	{
		typesCount++
		FileType%typesCount%	:= 	"Advanced Filterate"
		FileExt%typesCount%		:= 	AdvancedFilter		
	}
	
	;If none of the checkboxes is selected
	If (typesCount = 0)	{
		SB_Message("Error","Please select atleast one filetype.")
		Return
	}
	
	;Destination
	If (DestinationType = "Same Folder")
		DestinationFolder := SourceFolder
	
	GoSub, BeginSort
Return

;Sort Folder
BeginSort:
	Loop, %typesCount%
	{
		i := A_Index
		Loop, Parse, FileExt%i%, `,	
			IfExist, % SourceFolder "\*." A_LoopField
			{
				If (SortType = "Delete")
					FileDelete, % SourceFolder "\*." A_LoopField
				Else
				{
					FileCreateDir, % DestinationFolder "\" FileType%i%
					
					If (SortType = "Move")
						FileMove, % SourceFolder "\*." A_LoopField , % DestinationFolder "\" FileType%i%
					Else If (SortType = "Copy")
						FileCopy, % SourceFolder "\*." A_LoopField, % DestinationFolder "\" FileType%i%
				}
				Sleep 250 ;Extra Care
				notCopied += Errorlevel
			}
	}
	
	SB_Message("OK", "Sorting process completed ( with " notCopied " errors )")

	;Open Destination Folder (if asked to)
	If OpenDest
		Run, % DestinationFolder
Return

;Browse for a folder
BrowseFolder:
	If A_GuiControl = BrowseSource
	{
		FileSelectFolder, target, , 3, Select the folder which would be sorted.
		If target =
			Return	
		GuiControl,, SourceFolder, %target%
	}	
	Else If A_GuiControl = BrowseDest
	{
		FileSelectFolder, target, , 3, Select the folder to which the sorted files would be copied.
		If target =
			Return	
		GuiControl,, DestinationFolder, %target%
	}
Return

;Special care for HTML files
HTMLCheckBox:
	; If isFileTypeShown
	; {
		Loop, 7
		{
			i := A_Index + 3
			GuiControl, Disable, button%i%
		}	
		; isFileTypeShown := False
	; }
	; Else
	; {
		; isAdvFilterShown := True
	; }
Return

;Advanced Filters
AdvancedCheckBox:
	GuiControlGet, AdvChecked
	If AdvChecked
		GuiControl, Enable, AdvancedFilter
	Else
		GuiControl, Disable, AdvancedFilter
Return

;The Sort Method DropDownList
SortDDL:
	Gui, Submit, NoHide	
	If (SortType = "Delete")
	{
		Control, Choose, 1, ComboBox3
		GuiControl, Disable, DestinationType
		GuiControl, Text, DestinationLabel, Processed files would be Deleted.
	}
	Else
	{
		GuiControl, Enable, DestinationType
		If (SortType = "Copy")
			GuiControl, Text, DestinationLabel, Sorted files would be copied to    -
		Else If (SortType = "Move")
			GuiControl, Text, DestinationLabel, Sorted files would be moved to    -	
	}
Return

;The Destination Type DropDownList
DestinationDDL:
	Gui, Submit, NoHide
	If (DestinationType = "Use Specified Folder")
	{
		GuiControl, Enable, DestinationFolder
		GuiControl, Enable, BrowseDest
		isDestShown := True
	}
	Else If isDestShown
	{
		GuiControl, Disable, DestinationFolder
		GuiControl, Disable, BrowseDest
		isDestShown := False
	}
Return

;The Drag 'n' Drop Handler
GuiDropFiles:
	Loop, Parse, A_GuiEvent, `n
	{
		; Msgbox, % A_GuiControl
		If (A_GuiControl = "SourceFolder")
		{
			If InStr(FileExist(A_LoopField), "D")
				GuiControl,, SourceFolder, %A_LoopField%
		}
		Else If (A_GuiControl = "DestinationFolder")
		{
			If InStr(FileExist(A_LoopField), "D")
				GuiControl,, DestinationFolder, %A_LoopField%
		}
	}
Return

GuiClose:
 ExitApp
	; Gui, Hide
; Return

;#########################################################
				 ;Tray Menu Events Labels
;#########################################################

;Menu Functions
CloseMe:
 ExitApp

;Show Settings Dialog
Settings:
	Gui, 1:Show
Return

;######################################################
				   ;Minimize To Tray
;######################################################

WM_SYSCOMMAND(wParam)
{
	If ( wParam = 61472 ) 
	{
		SetTimer, OnMinimizeButton, -1
		Return 0
	}
}

OnMinimizeButton:
	MinimizeGuiToTray( R, mainGuiID )
	Menu, Tray, Icon
Return

GuiShow:
  DllCall("DrawAnimatedRects", UInt,Gui1, Int,3, UInt,&R+16, UInt,&R )
  Menu, Tray, NoIcon
  Gui, 1:Show
Return

MinimizeGuiToTray( ByRef R, hGui ) {
  WinGetPos, X0,Y0,W0,H0, % "ahk_id " (Tray:=WinExist("ahk_class Shell_TrayWnd"))
  ControlGetPos, X1,Y1,W1,H1, TrayNotifyWnd1,ahk_id %Tray%
  SW:=A_ScreenWidth,SH:=A_ScreenHeight,X:=SW-W1,Y:=SH-H1,P:=((Y0>(SH/3))?("B"):(X0>(SW/3))
  ? ("R"):((X0<(SW/3))&&(H0<(SH/3)))?("T"):("L")),((P="L")?(X:=X1+W0):(P="T")?(Y:=Y1+H0):)
  VarSetCapacity(R,32,0), DllCall( "GetWindowRect",UInt,hGui,UInt,&R)
  NumPut(X,R,16), NumPut(Y,R,20), DllCall("RtlMoveMemory",UInt,&R+24,UInt,&R+16,UInt,8 )
  DllCall("DrawAnimatedRects", UInt,hGui, Int,3, UInt,&R, UInt,&R+16 )
  WinHide, ahk_id %hGui%
}


;#########################################################
				  ;Miscellaneous Labels
;#########################################################

;About Dialog Hyperlinks
ShadabZafar:
	Run,http://www.facebook.com/dufferzafar,,UseErrorLevel
Return

Unlicensed:
	Run,http://www.unlicense.org/,,UseErrorLevel
Return

Autohotkey:
	Run,http://www.autohotkey.com/,,UseErrorLevel
Return

GoogleCode:
	Run,http://code.google.com/p/the-sorting-hat/,,UseErrorLevel
Return

;#########################################################
				  ;Miscellaneous Functions
;#########################################################

SB_Message(Type,Msg)
{
	SB_SetText(Msg)
	
	If (Type = "Error")
		SB_SetIcon("Data\Error.ico")
	Else If (Type = "OK")
		SB_SetIcon("Data\OK.ico")

	SetTimer, SetReadyMessage, 5000
}

SetReadyMessage:
	SetTimer, SetReadyMessage, Off	
	SB_SetIcon("Data\OK.ico"), SB_SetText("Ready...")
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static16,Static17,Static18
    DllCall("SetCursor","UInt",hCurs)
  Return
}

NotReady()
{
	Msgbox, 48, Sorry!! This is a beta version, This feature is not yet implemented or it doesn't functions properly.
}