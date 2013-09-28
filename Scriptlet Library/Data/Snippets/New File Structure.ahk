#NoEnv
SetWorkingDir %A_ScriptDir%

ScriptletStartString = #Begin-
ScriptletEndString = #End-

ID = 987766

Return

FileScriptletsIntoGui:
	Loop, Snippets\*.snips
	{	
		Loop, Read, %A_LoopFileFullPath%
		{
			If (InStr(A_LoopReadLine,ScriptletStartString)=1) 
			{
				;Get scriptlet name
				StringTrimLeft, ScriptletName, A_LoopReadLine, % StrLen(ScriptletStartString)
				
				;ID := TV_Add(ScriptletName,Group_ID,"Sort")
				ID++
				ScriptletInProcess := True
				Scriptlet =
			}
			Else If (InStr(A_LoopReadLine,ScriptletEndString)=1)
			{
				ScriptletInProcess := False
				StringTrimRight, Scriptlet, Scriptlet, 1
				%ID%Scriptlet = %Scriptlet%
				; Msgbox, GroupName - %A_LoopFileName%
				; Msgbox, % %ID%Scriptlet
			} 
			Else If ScriptletInProcess 
				Scriptlet = %Scriptlet%%A_LoopReadLine%`n
		}	
	}
Return

ScriptletsToFile:

Return
