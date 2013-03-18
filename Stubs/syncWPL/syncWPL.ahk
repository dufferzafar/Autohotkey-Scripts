/*
			syncWPL				
	Copy 

4:51 PM Monday, March 18, 2013  
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
#Persistent						;Keep running until the user asks to exit.
; #NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines -1

;############################################################# Dependencies

;The xpath function by Titan
#Include xpath.ahk

;############################################################# Variables

;The Destination Directory
destRoot := "K:\Songs"

;Variables
musicDir := "C:\Users\dufferzafar\Downloads\Music"

;Read path of songs from the XML
FileRead, xml, Best.wpl
xpath_load(xml), filePaths := xpath(xml, "body/seq/media/@src/text()")

;Number of files
fileCount :=  ( count, regexReplace(filePaths, "(`,)", "`,",count))

x := Floor(A_ScreenWidth * 0.8)

;Create a basic progress window
Progress, R0-%fileCount% M, Starting....., Your playlist is being synced, WPL Sync

;Makes sure that the progress window is created
Sleep, 500

;Copy Files
Loop, parse, filePaths, `,
{
	If FileExist(A_LoopField)
	{
		SplitPath, A_LoopField, name
		
		;Show Progress
		Progress, % A_Index, %name%
		
		FileCopy, %A_LoopField%, % destRoot "\" name, 0		
	}
	Else ;Handles files with src like "..\raabta (night in motel).mp3"
	{
		newSrc := musicDir . SubStr(A_LoopField, 3)
		SplitPath, newSrc, name
		
		If FileExist(newSrc)
		{
			;Show Progress
			Progress, % A_Index, %name%
			
			FileCopy, %newSrc%, % destRoot "\" name, 0	
		}
	}
	; Sleep 1000 ;For Debugging
}

;Bye!!
Exitapp