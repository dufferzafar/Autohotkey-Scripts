/*

								Run with Commands v0.6							
		Run executables with command-line arguments directly from explorer   	


Special Thanks To:- 

*/

#NoEnv  						;Recommended for performance.
#SingleInstance Ignore			;Make Single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

If 0 = 0		;If no arguments are passed
{
	FileCopy, %A_ScriptFullPath%, %A_WinDir%\System32\RwC.exe, true
		
	RegWrite, REG_SZ, HKCR, exefile\shell\RwC, , Run with Commands
	RegWrite, REG_SZ, HKCR, exefile\shell\RwC\command, , `"%A_WinDir%\System32\RwC.exe`" `"`%1`"
	
	If ErrorLevel
		MsgBox , 16,Error Occurred, An error occured while tryinmg to install RwC.
	Else
		MsgBox , 64,Install Complete, Run with Commands has installed successfully.
		
	ExitApp
}

Else If 0 > 1 	;If more than one arguments is passed
{
	MsgBox , 16,In-Correct Command-line, This Script requires only 1 arguments and you passed %0%.
	
	ExitApp
}

Else
{
	;Create a GUI
	Gui, -MaximizeBox -MinimizeBox +AlwaysOnTop
	Gui, Add, Text, xm y10 w350 h20 , Enter the command-line parameters you want to pass to this program.
	Gui, Add, Edit, xm y40 w324 h20 vCommands, 
	Gui, Add, Button, xm y70 w60 h30 Default gRunIt, Run
	Gui, Add, Button, x+196 y70 w70 h30 gRunItHidden, Run Hidden
	
	Gui, Show, h110 w345 Center, Run with Commands v0.7	
	
	Return
}

RunItHidden:
	fileToRun = %1%
	Gui, Submit, NoHide	;Save command-line params to var 'Commands'
	Run, %filetoRun% %Commands%, , Hide
ExitApp

RunIt:
	fileToRun = %1%
	Gui, Submit, NoHide	;Save command-line params to var 'Commands'
	Run, %filetoRun% %Commands%
ExitApp 

GuiClose:
ExitApp 