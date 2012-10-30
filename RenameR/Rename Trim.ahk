/*
	Remove part of Text Form Files
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1

;##########################################################

InputBox, fType, Enter FileType, Please enter the extension of the filetype that needs to be processed., ,279, 150

If (fType)
	InputBox, RemoveWhat, Enter Text to remove, Please enter the text that you want to be removed from all files., ,305, 150

If (RemoveWhat)
	Loop, %A_ScriptDir%\*.%fType%
	{
		StringReplace, LoopFileName, A_LoopFileName, %RemoveWhat%, 
		FileMove, %A_LoopFileFullPath%, %A_ScriptDir%\%LoopFileName%
	}