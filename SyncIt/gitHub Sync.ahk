/*
		A nifty script that i use to sync my gitHub code
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

;########################################################## Global Variables

;Only files with these extensions will be copied
legalExtensions := "txt,ini,doc,docx" "ahk,lua,vbs,bat,reg" "png,bmp,jpg,ico"

;Change these values for source and destination directories.
; [absolute path]

destRoot = D:\Tosync\Dest
sources =
( LTrim Join|
D:\I, Coder\My Projects\Win Helper
D:\I, Coder\My Projects\# Dev Zone\The Sorting Hat
D:\I, Coder\My Projects\# Dev Zone\Magic Desk
)

; srcDir = D:\Tosync\Source

;###################################################################### Main

;Gui
Gui, Add, Text, vsyncStatus Left w200, Synchronizing...
Gui, Add, Button, gExit vsyncButton w50 h20 x+10, &Close
Gui, -Caption +Border
Gui, Show, Center Autosize, gitHub Code Synchronizer
GuiControl, +Default, syncButton

; Core logic

Loop, Parse, sources, |
{	
	SplitPath, A_LoopField, folderName
	destDir := destRoot "\" folderName
	
	SetWorkingDir, %A_LoopField%
	recursiveSync("*.*")
}

SetWorkingDir, %A_ScriptDir%

;Reflect Changes in GUI
GuiControl, , syncStatus, DONE!
GuiControl, , syncButton, &Ok

Return	 ;End of Auto Execute Section
;_____________________________________________

; This function implements the replication check, where the source items
; are replicated on destination side (the function is recursive)
recursiveSync(filePat)
{
   Global srcDir, destDir, legalExtensions

   Loop, %filePat%, 1
   {
		; It's a directory
		If InStr(FileExist(A_LoopFileFullPath), "D")
		{
			;Create destination directory if it doesn't exists
			IfNotExist, %destDir%\%A_LoopFileFullPath%
				FileCreateDir, %destDir%\%A_LoopFileFullPath%
				
			; Recursion into current directory
			recursiveSync(A_LoopFileFullPath . "\*.*")
		}
	  
		; It's a file
		Else
		{
			toCopyFlag := False
			
			;Inclusions based on Extensions
			SplitPath, A_LoopFileLongPath,,, thisFileExt
			
			If InStr(legalExtensions,thisFileExt)
			{
				; Checks if file exists in destination directory
				IfNotExist, %destDir%\%A_LoopFileFullPath%
					toCopyFlag := True
				Else
				{
					; Checks if source file is more recent than destination file
					FileGetTime, destTime, %destDir%\%A_LoopFileFullPath%
					EnvSub, destTime, %A_LoopFileTimeModified%, seconds
					If destTime < 0
						toCopyFlag := True
				}
			}
			
			; Copy file
			If toCopyFlag
				FileCopy, %A_LoopFileLongPath%, %destDir%\%A_LoopFileFullPath%, 1
		}
   }
   Return 0
}

; Exit label
Exit:
ExitApp
