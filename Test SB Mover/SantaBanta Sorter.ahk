Loop, *.jpg
{
	fName := A_LoopFileName
	
	If InStr(fName, "-") ; Type 1 = first-second-(num)(a/v)
	{
		pDash := InStr(fName, "-")
		pDash2 := InStr(fName, "-", false, pDash+1)
		
		firstName := ToUpper(SubStr(fName, 1, 1)) SubStr(fName, 2, pDash-2)
		secName := ToUpper(SubStr(fName, pDash+1, 1)) SubStr(fName, pDash+2, pDash2-(pDash+2))
		
		fName2 := RegExReplace(SubStr(fName, pDash2+1),"[av]","")
				
		If Not InStr(FileExist(firstName " " secName), "D")
			FileCreateDir,% A_ScriptDir "\" firstName " " secName "\"
			
		Sleep 100
		FileMove, %A_LoopFileFullPath%, % A_ScriptDir "\" firstName " " secName "\"	fName2
	}
	; Else ; Type 2 = \w\w\w(num)(a/v)
	; {
	
	; }
}

ToUpper(str)
{
	StringUpper, str, str
	Return str	
}
