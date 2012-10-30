#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1

InputBox, fType, Enter FileType, Please enter the extension of the filetype that needs to be processed., ,300, 170

If fType <>
{
	InputBox, RemoveWhat, Enter Text to remove, Please enter the text that you want to be removed from all files., ,300, 170
}

If RemoveWhat <>
{
	Loop, %A_ScriptDir%\*.%fType%
	{
		FileMove, %A_LoopFileFullPath%,% A_ScriptDir "\" RegExReplace(A_LoopFileName, RemoveWhat, "") 
	}
}
