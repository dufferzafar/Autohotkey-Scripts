;Create a GUI 		-we'll show it later
Gui, 2:Add, Text, x6 y10 w270 h30 , What would you like to do with the copied files?
Gui, 2:Add, Button, x6 y50 w60 h30 Default gCopy, Copy
Gui, 2:Add, Button, x76 y50 w60 h30 gCopyDir, CopyDir
Gui, 2:Add, Button, x146 y50 w60 h30 gMove, Move
Gui, 2:Add, Button, x216 y50 w60 h30 gMoveDir, MoveDir

Gui, 2:+AlwaysOnTop

;Help with copying files & folders				Ctrl + C
/*
^c::
	Clipboard = 		;Should be empty
	Send ^c				;Copy selected files to clip
	ClipWait 2
	if ErrorLevel
		Return			;Exit if can't copy

	FileList = %Clipboard%
	
	RegRead, LastFolder, HKCU, Software\WindowsHelper, LastFolder
	
	FileSelectFolder, TargetFolder, *%LastFolder%, 3, Select the folder to which the file(s) would be copied.
	If TargetFolder =
		Return
	
	RegWrite, REG_SZ, HKCU, Software\WindowsHelper, LastFolder, %TargetFolder%
	
	Gui, 2:Show, h89 w283 Center, Copy That! v1.0
Return
*/
;Help with copying files & folders				Ctrl + X
^x::
	Clipboard = 		;Should be empty
	Send ^c				;Copy selected files to clip
	ClipWait 2
	if ErrorLevel
		Return			;Exit if can't copy

	FileList = %Clipboard%
	
	RegRead, LastFolderM, HKCU, Software\WindowsHelper, LastFolderM
	
	FileSelectFolder, TargetFolder, *%LastFolderM%, 3, Select the folder to which the file(s) would be copied.
	If TargetFolder =
		Return	
		
	RegWrite, REG_SZ, HKCU, Software\WindowsHelper, LastFolderM, %TargetFolder%
		
	Loop, parse, FileList, `n, `r
	{
		SplitPath, A_LoopField, FileName
		FileMove, %A_LoopField%, %TargetFolder%\%FileName%, 0
	}
	Refresh()
Return


Copy:
	Task = 1
	Gosub, Core
Return

CopyDir:
	Task = 2
	Gosub, Core
Return

Move:
	Task = 3
	Gosub, Core
Return

MoveDir:
	Task = 4
	Gosub, Core
Return 

Core:
	Loop, parse, FileList, `n, `r
	{
		SplitPath, A_LoopField, FileName
		
		If Task = 1
			FileCopy, %A_LoopField%, %TargetFolder%\%FileName%, 0
		Else If Task = 2
			FileCopyDir, %A_LoopField%, %TargetFolder%\%FileName%, 1
		Else If Task = 3
			FileMove, %A_LoopField%, %TargetFolder%\%FileName%, 0
		Else If Task = 4
			FileMoveDir, %A_LoopField%, %TargetFolder%\%FileName%, 0
			
		Gui, Cancel
		Refresh()
	}
Return

Refresh()
{
    WinGetClass, eh_Class,A
    If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
        Send, {F5}
    Else PostMessage, 0x111, 28931,,, A
}