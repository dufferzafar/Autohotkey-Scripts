#NoEnv
#SingleInstance Force

SetWorkingDir %A_ScriptDir%
SendMode Input

SetBatchLines, -1

InputBox, AddWhat, Enter Text to Add, Please enter the text that you want to be added to all files.

If AddWhat <>
{
	Loop, %A_ScriptDir%\*.png
	{
		StringTrimRight, FileName, A_LoopFileName, StrLen(A_LoopFileExt) + 1
		LoopFileName = %FileName%-%AddWhat%
		FileMove, %A_LoopFileFullPath%, %A_ScriptDir%\%LoopFileName%.%A_LoopFileExt%
	}
}
