/*
		  Batch RenameR Script v0.8 	
		Batch Rename Files With Ease	
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1

;Create The Main GUI
	Gui, 2: Add, Text, x6 y12 w50, FileType
		Gui, 2: Add, ComboBox, x56 y10 w110 vExtension, PNG||BMP|JPG|FLV
	Gui, 2: Add, Text, x6 y42 w50, Replace
		Gui, 2: Add, Edit, x56 y40 w110 vReplace,
	Gui, 2: Add, Text, x200 y42 w50, With
		Gui, 2: Add, Edit, x236 y40 w110 vWith,
	Gui, 2: Add, Button, x150 y70 w50 h24 gPerformTask, OK
	Gui, 2: Add, Button, x210 y70 w60 h24 g2GuiClose, Cancel
	
	Gui, 2: Show, Center, Batch RenameR


Return	 ;End of Auto Execute Section
;_____________________________________________

Esc::
2GuiClose:
ExitApp

PerformTask:
	Gui,2: Submit, NoHide

	;Check Extension
	If Extension = 
	{
		Msgbox, 16, Invalid Extension, Please Select a valid Extension
		Return
	}
	
	;Add/Trim
	If (Replace = "") and (With = "")
	{
		Msgbox, 16, Nothing to Do, What should i do....?
		Return
	}
	Else If (Replace = "")	;Add Something to the filenames
	{
		msgbox, add
		Loop, %A_ScriptDir%\*.%Extension%
		{
			StringTrimRight, FileName, A_LoopFileName, StrLen(A_LoopFileExt) + 1
			LoopFileName = %FileName%-%With%
			FileMove, %A_LoopFileFullPath%, %A_ScriptDir%\%LoopFileName%.%A_LoopFileExt%
		}
	}
	Else ;If (Replace <> "") and (With <> "") ;Replace 'Something' With 'Something'
	{
		Loop, %A_ScriptDir%\*.%Extension%
		{
			LoopFileName := RegExReplace(A_LoopFileName, Replace, With)
			FileMove, %A_LoopFileFullPath%, %A_ScriptDir%\%LoopFileName%.%A_LoopFileExt%
		}
	}	
Return

TESTING:

	var := "Shadab12Harry"
	
	Msgbox, % RegExReplace("abc123abc478==78---56", "\d+", "")

Return


