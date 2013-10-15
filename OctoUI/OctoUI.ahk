/**
 * OctoUI
 *
 * A Simplistic UI Panel for Octopress.
 *
 * @dufferzafar
 */

/**
 * Script Settings
 *
 * Do not touch if you are unsure of anything.
 */
#NoEnv
#SingleInstance Force
#Persistent
#NoTrayIcon
#KeyHistory 0

; Your Octopress directory
OctoDir := "D:\I, Coder\@ GitHub\dufferzafar.github.com"

If !FileExist(OctoDir)
{
	Msgbox, Octopress not found.
	ExitApp
}

SetWorkingDir, %OctoDir%

Gui, Add, Button, x10 y10 w120 h40 gPreview, Rake Preview
Gui, Add, Button, xp+130 yp wp hp gGenerate, Rake Generate
Gui, Add, Button, xp+130 yp wp hp gDeploy, Rake Deploy

Gui, Show, Center, OctoUI

Return

Preview:
	Run, cmd /c "rake preview", %OctoDir%, Hide, PreviewProcess
Return

Generate:
	Run, cmd /c "rake generate", %OctoDir%, Hide, GenerateProcess
Return

Deploy:
	Run, cmd /c "rake deploy", %OctoDir%, Hide, DeployProcess
Return

GuiClose:
	WinKill, ahk_pid %PreviewProcess%
	WinKill, ahk_pid %GenerateProcess%
	WinKill, ahk_pid %DeployProcess%
ExitApp