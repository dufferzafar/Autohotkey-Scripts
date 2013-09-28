/*
	Scriptlet Library v4.5
		by Rajat
		edited by Toralf
		edited again by ShadabSofts

Added:-

Removed:-
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

;Global Variables
ScriptName = My Scriptlet Library

GroupStartString = <---Group_
ScriptletStartString = <---Start_
ScriptletEndString = <---End_
DefaultGroupName = Misc
DefaultNewGroupName = New Group
DefaultNewScriptletName = Scriptlet
ScriptletNameIndex = 0

;Add a Group Name Here To Exclude it in QuickSnips Menu
QSExceptions = Notes,Dev,Temp

;Read INI File
SplitPath, A_ScriptName, , , , OutNameNoExt
IniFile = Data\%OutNameNoExt%.ini
IniRead, BolRollUpDown,  %IniFile%, Settings, BolRollUpDown,  1
IniRead, BolAlwaysOnTop, %IniFile%, Settings, BolAlwaysOnTop, 0
IniRead, StrFontName,    %IniFile%, Settings, StrFontName,    Courier
IniRead, IntFontSize,    %IniFile%, Settings, IntFontSize,    %A_Space%
If IntFontSize
    FontSize = S%IntFontSize%

;Tray menu
Menu, Tray, NoStandard
Menu, Tray, Icon, Data\Scripts.ico
Menu, Tray, Tip, %ScriptName%

Menu, Tray, Add, Restore, GuiShow
Menu, Tray, Add
Menu, Tray, Add, &Exit, GuiClose

Menu, Tray, Click, 1
Menu, Tray, Default, Restore

;Build Interface
GoSub, BuildGui
GoSub, BuildContextMenu
GoSub, BuildQuickSnipsMenu

;Now Show GUI
Gui, 1: +LastFound
Gui1UniqueID := WinExist()
; OnMessage(0x112, "WM_SYSCOMMAND")

Gui, 1:Show, Center, %ScriptName%

;Maximize it now so that it can resize itself
PostMessage, 0x112, 0xF030,,, ahk_id %Gui1UniqueID%

Return	 ;End of Auto Execute Section
;_____________________________________________

;######################################################
				;Main GUI Related Threads
;######################################################

BuildGui:
	Gui, 1:+Resize
	Gui, 1:Add, Button, Section vBtnAddGroup gBtnAddGroup, +
	Gui, 1:Add, Edit,  x+1 ys+1 w125 vEdtGroupName gEdtGroupName Disabled,
	Gui, 1:Add, Button,  x+1 ys vBtnRemoveGroup gBtnRemoveGroup Disabled, -

	Gui, 1:Add, Button, x+22 ys vBtnAddScriptlet gBtnAddScriptlet Disabled, +
	Gui, 1:Add, Edit,  x+1 ys+1 w125 vEdtScriptletName gEdtScriptletName Disabled,
	Gui, 1:Add, Button,  x+1 ys vBtnRemoveScriptlet gBtnRemoveScriptlet Disabled, -

	Gui, 1:Add, DropDownList, x+22 ys w150 vDdbScriptletInGroup gDdbScriptletInGroup Sort Disabled,

	Gui, 1:Add, Button, x+15 ys vSaveAs gSaveAs Disabled, &Save As
	Gui, 1:Add, Button, x+15 ys vLaunchScript gLaunchScript Disabled, &Launch Script
	Gui, 1:Add, Button, x+15 ys vBtnCopyToClipboard gBtnCopyToClipboard Disabled, To &Clipboard
	

	Gui, 1:Add, TreeView, xs Section w220 h500 vTrvScriptlets gTrvScriptlets
	
	GoSub, FileScriptletsIntoGui
	
	Gui, 1:Font, %FontSize%, %StrFontName%
	Gui, 1:Add, Edit, ys w530 h500 Multi T8 vEdtScriptletData gEdtScriptletData,
	
	TV_Modify(TV_GetChild(TV_GetNext(TV_GetNext(TV_GetNext()))), "Select") ;Select Lua
Return

;Called When user Right-Clicks
GuiContextMenu:
   Menu, ContextMenu, Show
Return

BtnCopyToClipboard:
  GuiControlGet, EdtScriptletData
  Clipboard = %EdtScriptletData%
  If BolRollUpDown
      RollGuiUp(ScriptName)
Return

LaunchScript:
	Gui, Submit , NoHide	
	If DdbScriptletInGroup in Lua,Autohotkey
	{	
		GuiControlGet, EdtScriptletData ;Get Scriplet Data
		Random, RandomName, 1, 99999 ;Generate a Random Number		
		If DdbScriptletInGroup = Lua
			Ext = lua
		Else If DdbScriptletInGroup = Autohotkey
		{
			Ext = ahk
			FileAppend, SetWorkingDir `%A_Temp`%`n`n, %A_Temp%\Executed-Scriptlet-%RandomName%.%Ext%
		}
		FileAppend, %EdtScriptletData%, %A_Temp%\Executed-Scriptlet-%RandomName%.%Ext%
		Run, %A_Temp%\Executed-Scriptlet-%RandomName%.%Ext%	;Execute it
	}
	
	WasLaunched := True
Return

SaveAs:
	Gui, 1:+OwnDialogs
	Gui, Submit , NoHide	
	GuiControlGet, EdtScriptletData ;Get Scriplet Data	
	
	If DdbScriptletInGroup = Lua
		Ext = lua
	Else If DdbScriptletInGroup = Autohotkey
		Ext = ahk
	Else
		Ext = txt
		
	FileSelectFile, SelectedFile, S, %A_MyDocuments%\%EdtScriptletName%.%Ext%, Save Scriptlet As
	
	If (SelectedFile != "")
	{
		If FileExist(SelectedFile)
			FileDelete, %SelectedFile%
		FileAppend, %EdtScriptletData%, %SelectedFile%		
	}
Return

GuiEscape:
GuiClose:
	GoSub, WriteINIFile
	If WasLaunched
		Loop, %A_Temp%\*.*
			If A_LoopFileExt in lua,ahk
				FileDelete, %A_LoopFileFullPath%
	ExitApp
Return

;######################################################
				;Right Click Context Menu
;######################################################

BuildContextMenu:
	Menu, ContextMenu, Add, BackUp Scriptlets, BackUpScriptlets
	Menu, ContextMenu, Add, ;Separator

	;Editor Sub-Menu
	Menu, Editor, Add, Font, ChangeFont
	Menu, Editor, Add, Font Size, ChangeFontSize
	Menu, ContextMenu, Add, Editor, :Editor

	Menu, ContextMenu, Add, ;Separator

	Menu, ContextMenu, Add, Auto-Roll-Up when not active, ToggleRollUpDown
	If BolRollUpDown
	  GoSub, SetRollUpDown
	Menu, ContextMenu, Add, Always On Top, ToggleAlwaysOnTop
	If BolAlwaysOnTop
	  Gosub, SetAlwaysOnTop
Return

BackUpScriptlets:
  Gui, 1:+OwnDialogs
  FileSelectFile, SelectedFile, S18, %A_ScriptDir%, Select file to backup scriptlets, Ini file (*.ini)
  If SelectedFile {
      NormalINI = %IniFile%
      IniFile = %SelectedFile%
      GoSub, WriteINIFile
      IniFile = %NormalINI%
    }
Return

ChangeFont:
  Gui, 1:+OwnDialogs
  InputBox, OutVar, Choose Font, Specify an existing font name for the scriptlet editor window (Default: Lucida Console) ,,310,140,,,,, %StrFontName%
  If ErrorLevel
      Return
  StrFontName = %OutVar%
  GoSub, ReRunOrReload
Return

ChangeFontSize:
  Gui, 1:+OwnDialogs
  InputBox, OutVar, Choose Font Size, Specify a font size for the scriptlet editor window.,,260,140,,,,, %IntFontSize%
  If ErrorLevel
      Return
  IntFontSize = %OutVar%
  GoSub, ReRunOrReload
Return

ReRunOrReload:
	GoSub, WriteINIFile
	Reload
Return

;######################################################
				   ;Quick Snips Menu
;######################################################

BuildQuickSnipsMenu:
	ID = 0
	Loop
	{	
		ID := TV_GetNext(ID, "Full")
		ParentID := TV_GetParent(ID), TV_GetText(Name, ID)		
		
		If Not ID 
		{	
			Menu, QuickSnips, Add, %Language%, :%Language%
			Break
		}
		If Name in %QSExceptions% 
		{	
			Menu, QuickSnips, Add, %Language%, :%Language%
			Break
		}
		
		If ParentID
			Menu, %Language%, Add, %Name%, QSHotkey
		Else
		{	
			If (Language <> "")
				Menu, QuickSnips, Add, %Language%, :%Language%		
			Language = %Name%
		}
	}
	Gui, 1:Default
Return

QSHotkey:
	ID = 0
	Loop
	{
		ID := TV_GetNext(ID, "Full")
		
		If Not ID
			Break
		ParentID := TV_GetParent(ID), TV_GetText(Name, ID)
		
		If ParentID ;If the object has a parent i.e - It is a Scriptlet
		{
			If (Language = A_ThisMenu) and (Name = A_ThisMenuItem)		
			SendInput, % %ID%Scriptlet
		}
		Else
		{
			Language = %Name%
		}
	}
Return

;######################################################
				;Read File Scriptlets To Gui
;######################################################

FileScriptletsIntoGui:	
  ;create default group
  Gui, 1: Default
  Group_ID := TV_Add(DefaultGroupName, "", "Sort")
  ListOfGroupNames = `n%DefaultGroupName%`n
  Default_Group_ID := Group_ID

  ;read data
  Loop, Read, %IniFile%
    {
      If (InStr(A_LoopReadLine,GroupStartString)=1) {
          ;get group name
          StringTrimLeft, GroupName, A_LoopReadLine, % StrLen(GroupStartString)
          Group_ID := TV_Add(GroupName, "", "Sort")
          ListOfGroupNames = %ListOfGroupNames%%GroupName%`n
      } Else If (InStr(A_LoopReadLine,ScriptletStartString)=1) {
          ;get scriptlet name
          StringTrimLeft, ScriptletName, A_LoopReadLine, % StrLen(ScriptletStartString)

          ;add scriptlet
          ID := TV_Add(ScriptletName,Group_ID,"Sort")
          ScriptletInProcess := True
          Scriptlet =
      } Else If (InStr(A_LoopReadLine,ScriptletEndString)=1) {
          ScriptletInProcess := False
          StringTrimRight, Scriptlet, Scriptlet, 1
          %ID%Scriptlet = %Scriptlet%
      } Else If ScriptletInProcess {
          Scriptlet = %Scriptlet%%A_LoopReadLine%`n
        }
    }
  ;check if default group is used
  If !TV_GetChild(Default_Group_ID){
      TV_Delete(Default_Group_ID)
      StringReplace, ListOfGroupNames, ListOfGroupNames, `n%DefaultGroupName%`n, `n
    }

  StringReplace, DdbScriptletInGroup, ListOfGroupNames, `n, |, All
  GuiControl, 1:, DdbScriptletInGroup, %DdbScriptletInGroup%
Return

;######################################################
			  ;TreeView Related Threads
;######################################################

;Called When TreeView is Selected/Clicked
TrvScriptlets:
	If TreeSelectionInProcess
		Return
	TreeSelectionInProcess := True
	ID := TV_GetSelection()
	ParentID := TV_GetParent(ID)
	If ParentID	;its a scriptlet
	{
		TV_GetText(GroupName, ParentID)
		TV_GetText(ScriptletName, ID)
		GuiControl,1:ChooseString, DdbScriptletInGroup, %GroupName%
		GuiControl,1:, EdtScriptletName, %ScriptletName%
		GuiControl,1:, EdtScriptletData, % %ID%Scriptlet
		GuiControl,1: Enable, EdtScriptletData
		GuiControl,1: Enable, EdtScriptletName
		GuiControl,1: Enable, BtnRemoveScriptlet
		GuiControl,1: Enable, DdbScriptletInGroup
		GuiControl,1: Enable, BtnCopyToClipboard
		GuiControl,1: Enable, LaunchScript
		GuiControl,1: Enable, SaveAs
	}
	Else
	{
		TV_GetText(GroupName, ID)
		GuiControl,1:, EdtScriptletName,
		GuiControl,1:, EdtScriptletData,
		GuiControl,1: Disable, EdtScriptletData
		GuiControl,1: Disable, EdtScriptletName
		GuiControl,1: Disable, BtnRemoveScriptlet
		GuiControl,1: Disable, DdbScriptletInGroup
		GuiControl,1: Disable, BtnCopyToClipboard
		GuiControl,1: Disable, LaunchScript
		GuiControl,1: Disable, SaveAs
	}
	GuiControl,1:, EdtGroupName, %GroupName%

	GuiControl,1: Enable, BtnAddScriptlet
	GuiControl,1: Enable, BtnRemoveGroup
	GuiControl,1: Enable, EdtGroupName
	GuiControl,1: Enable, BtnSave
	TreeSelectionInProcess := False
Return

;######################################################
			  ;Add, Edit & Remove Group
;######################################################

BtnAddGroup:
	Gui, 1: Default
	;find group name that doesn't exist yet
	Loop
	  If !InStr(ListOfGroupNames, "`n" . DefaultNewGroupName . " " . A_Index . "`n"){
		  NewGroupNumber := A_Index
		  Break
		}
	;add new group
	GroupName := DefaultNewGroupName " " NewGroupNumber
	ID := TV_Add(GroupName,"","Select Vis")
	ListOfGroupNames = %ListOfGroupNames%%GroupName%`n
	StringReplace, DdbScriptletInGroup, ListOfGroupNames, `n, |, All
	GuiControl, 1:, DdbScriptletInGroup, %DdbScriptletInGroup%
	GuiControl, 1:Focus, EdtGroupName
	sleep,20
	Send, +{End}
Return

EdtGroupName:
	;check if new group name already exists
	GuiControlGet, EdtGroupName
	If InStr(ListOfGroupNames, "`n" EdtGroupName "`n")
	  Return

	;get group id
	Gui, 1: Default
	ID := TV_GetSelection()
	ParentID := TV_GetParent(ID)
	If ParentID      ;its a scriptlet
	  ID = %ParentID%

	;replace old name with new one in list
	TV_GetText(GroupName, ID)
	StringReplace, ListOfGroupNames, ListOfGroupNames, `n%GroupName%`n, `n%EdtGroupName%`n
	StringReplace, DdbScriptletInGroup, ListOfGroupNames, `n, |, All
	GuiControl, 1:, DdbScriptletInGroup, %DdbScriptletInGroup%

	;change name in tree
	TV_Modify(ID, "", EdtGroupName)
	TV_Modify(0, "Sort")
Return

BtnRemoveGroup:
	Gui, 1: Default
	;get group id
	ID := TV_GetSelection()
	ParentID := TV_GetParent(ID)
	If ParentID      ;its a scriptlet
	  ID = %ParentID%

	;get group name
	TV_GetText(GroupName, ID)

	MsgBox, 4, Delete Scriptlet Group?,
	(LTrim
	  Please confirm deletion of current scriptlet group:
	  %GroupName%
	
	  This will also remove all scriptlets in that group !!!
	)
	IfMsgBox, Yes
	{
	  ;get first scriptlet in that group and loop over all its siblings
	  ScriptletID := TV_GetChild(ID)
	  Loop {
		  If !ScriptletID
			  break
		  ;remove scriptlet from memory
		  %ScriptletID%Scriptlet =
		  ;get next sibling in that group
		  ScriptletID := TV_GetNext(ScriptletID)
		}
	  ;remove group
	  TV_Delete(ID)
	  ;remove group name from list
	  StringReplace, ListOfGroupNames, ListOfGroupNames, `n%GroupName%`n, `n
	  StringReplace, DdbScriptletInGroup, ListOfGroupNames, `n, |, All
	  GuiControl, 1:, DdbScriptletInGroup, %DdbScriptletInGroup%
	}
Return

;######################################################
			  ;Add, Edit & Remove Scriptlet
;######################################################

BtnAddScriptlet:
  Gui, 1: Default
  ;get group id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If ParentID      ;its a scriptlet
      ID = %ParentID%

  ;add new scriptlet
  ScriptletNameIndex++
  ScriptletName = %DefaultNewScriptletName% %ScriptletNameIndex%
  ID := TV_Add(ScriptletName,ID,"Sort Select Vis")
  %ID%Scriptlet =
  GuiControl, 1:Focus, EdtScriptletName
  sleep,20
  Send, +{End}
Return

EdtScriptletName:
  Gui, 1: Default
  ;get scriptlet id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If !ParentID      ;its a group
      Return

  GuiControlGet, EdtScriptletName
  ;change name in tree
  TV_Modify(ID, "", EdtScriptletName)
  TV_Modify(ID, "Sort")
Return

BtnRemoveScriptlet:
  Gui, 1: Default
  ;get scriptlet id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If !ParentID      ;its a group
      Return

  ;get scriptlet name
  TV_GetText(ScriptletName, ID)

  MsgBox, 4, Delete Scriptlet?,
    (LTrim
      Please confirm deletion of current scriptlet:
      %ScriptletName%
    )
  IfMsgBox, Yes
    {
      ;remove scriptlet from memory
      %ID%Scriptlet =
      ;remove group
      TV_Delete(ID)
    }
Return

;######################################################
			  ;Scriptlets Related Threads
;######################################################

EdtScriptletData:
  If TreeSelectionInProcess
      Return
  Gui, 1: Default
  ;get scriptlet id
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If !ParentID      ;its a group
      Return

  GuiControlGet, EdtScriptletData
  %ID%Scriptlet = %EdtScriptletData%
Return

DdbScriptletInGroup:
  If TreeSelectionInProcess
      Return
  TreeSelectionInProcess := True
  Gui, 1: Default
  ;get scriptlet id and name
  ID := TV_GetSelection()
  ParentID := TV_GetParent(ID)
  If !ParentID      ;its a group
      Return
  TV_GetText(ScriptletName, ID)

  ;get new group ID
  GuiControlGet, DdbScriptletInGroup
  GroupID := TV_GetNext()
  Loop {
      If !GroupID
          Return
      TV_GetText(GrouptName, GroupID)
      If (GrouptName = DdbScriptletInGroup)
          Break
      GroupID := TV_GetNext(GroupID)
    }
  ;create new key and delete old one
  NewID := TV_Add(ScriptletName,GroupID, "Sort Select Vis")
  %NewID%Scriptlet := %ID%Scriptlet
  TV_Delete(ID)
  %ID%Scriptlet =
  TreeSelectionInProcess := False
Return

;######################################################
					;Update INI File
;######################################################

WriteINIFile:
  If GuiRolledUp
      DllCall("AnimateWindow","UInt",Gui1UniqueID,"Int",0,"UInt","0x20005")
;      RollGuiDown(1, 1, 1, 1)
  FileDelete, %IniFile%
  WinGetPos, PosX, PosY, SizeW, SizeH, ahk_id %Gui1UniqueID%
  IniWrite, %BolRollUpDown%,  %IniFile%, Settings, BolRollUpDown
  IniWrite, %BolAlwaysOnTop%, %IniFile%, Settings, BolAlwaysOnTop
  IniWrite, %StrFontName%,    %IniFile%, Settings, StrFontName
  IniWrite, %IntFontSize%,    %IniFile%, Settings, IntFontSize
  FileAppend, `n`n, %IniFile%

  ID = 0
  Gui, 1: Default
  ScriptletString =
  Loop {
      ID := TV_GetNext(ID, "Full")
      If not ID
        break
      TV_GetText(Name, ID)
      ParentID := TV_GetParent(ID)
      If ParentID { ;it's a scriptlet
          Scriptlet := %ID%Scriptlet
          ScriptletString = %ScriptletString%%ScriptletStartString%%Name%`n%Scriptlet%`n%ScriptletEndString%%Name%`n`n`n
      } Else
          ScriptletString = %ScriptletString%%GroupStartString%%Name%`n

      ;remove the `n if no extra line break should be in the INI file
      ; If (Mod(A_index, 100)=0) {
          ; FileAppend, %ScriptletString%`n, %IniFile%
          ; ScriptletString =
        ; }
    }
  If ScriptletString
      FileAppend, %ScriptletString%`n, %IniFile%
Return

;######################################################
				;AlwaysOnTop & RollGui
;######################################################

ToggleAlwaysOnTop:
  BolAlwaysOnTop := not BolAlwaysOnTop
SetAlwaysOnTop:
  Menu, ContextMenu, ToggleCheck, Always On Top
  WinGetTitle, CurrentTitle , ahk_id %Gui1UniqueID%
  If BolAlwaysOnTop {
        Gui, 1: +AlwaysOnTop
        WinSetTitle, ahk_id %Gui1UniqueID%, , %CurrentTitle% - *AOT*
  }Else{
        Gui, 1: -AlwaysOnTop
        StringTrimRight, CurrentTitle, CurrentTitle, 8
        WinSetTitle, ahk_id %Gui1UniqueID%, , %CurrentTitle%
    }
Return

CheckIfActive:
  IfWinNotActive, ahk_id %Gui1UniqueID%
      RollGuiUp(ScriptName)
Return

ToggleRollUpDown:
  BolRollUpDown := Not BolRollUpDown
SetRollUpDown:
  Menu, ContextMenu, ToggleCheck, Auto-Roll-Up when not active
  If BolRollUpDown {
      SetTimer, CheckIfActive, On
  }Else{
      SetTimer, CheckIfActive, Off
    }
Return

RollGuiUp(BarName, vertical = "") {
    global Gui1UniqueID, GuiRolledUp
    SetTimer, CheckIfActive, Off
    WM_NCMouseMove = 0xA0
    OnMessage(WM_NCMouseMove , "RollGuiDown")
    WinGetPos, Gui1X, Gui1Y, , , ahk_id %Gui1UniqueID%
    Gui, 2: +ToolWindow -SysMenu +AlwaysOnTop
    If vertical
        Gui, 2:Show, w0 h100 x%Gui1X% y%Gui1Y% NoActivate, %BarName%  ;vertical bar
    Else
        Gui, 2:Show, w150 h0 x%Gui1X% y%Gui1Y% NoActivate, %BarName%  ;horizontal bar
    DllCall("AnimateWindow","UInt",Gui1UniqueID,"Int",200,"UInt","0x3000a")
    GuiRolledUp := True
 }

RollGuiDown(wParam, lParam, msg, hwnd) {
    global Gui1UniqueID, GuiRolledUp
    WM_NCMouseMove = 0xA0
    OnMessage(WM_NCMouseMove , "")
    DllCall("AnimateWindow","UInt",Gui1UniqueID,"Int",200,"UInt","0x20005")
    WinActivate, ahk_id %Gui1UniqueID%
    SetTimer, CheckIfActive, On
    Gui, 2:Destroy
    GuiRolledUp := False
  }

;######################################################
				;Anchorize GUI Window
;######################################################

;#Include Anchor.ahk

;Called When GUI is Resized
GuiSize:
	;       ControlName         , xwyh with factors [, True for MoveDraw]
	;Anchor("DdbScriptletInGroup", "x0.75 w0.25  ")
	;Anchor("BtnCopyToClipboard" , "x            ")
	Anchor("TrvScriptlets"      , "h")
	Anchor("EdtScriptletData"   , "wh")
Return

;######################################################
			  ;Context Sensitive Hotkeys
;######################################################
#IfWinActive My Scriptlet Library
	; ^c::
		; Gosub, BtnCopyToClipboard
	; Return
	
	^s::
		Gosub, SaveAs
	Return
	
	^e::
		Gosub, LaunchScript
	Return
#If

#If ActiveControlIsOfClass("Scintilla")
	RButton & LButton::
		Menu, QuickSnips, Show
	Return
#If

;######################################################
				   ;Minimize To Tray
;######################################################

WM_SYSCOMMAND(wParam)
{
	If ( wParam = 0xF020 ) ;SC_MINIMIZE
	{
		SetTimer, OnMinimizeButton, -1
		Return 0
	}
}

OnMinimizeButton:
	MinimizeGuiToTray( R, Gui1UniqueID )
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

;######################################################
			  ;Miscellaneous Functions
;######################################################

ActiveControlIsOfClass(Class)
{
	ControlGetFocus, FocusedControl, A
	ControlGet, FocusedControlHwnd, Hwnd,, %FocusedControl%, A
	WinGetClass, FocusedControlClass, ahk_id %FocusedControlHwnd%
	return (FocusedControlClass=Class)
}