#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon

password = m
path = %A_AppData%\SCamera\
interval = 5000
shown = true
enabled = false

IfNotExist, %path%
	FileCreateDir %path%

^+E::
InputBox pass, Please enter the password, Password:, HIDE
	if(pass == password) 
	{
		if(enabled == "false") 
		{
			SetTimer snapshot, %interval%
			enabled = true
			SoundBeep, 750, 400
		} else 
		{
			SetTimer snapshot, off
			enabled = false
			SoundBeep, 500, 400
		}
	} 
	else 
	{
		msgbox Invalid password.
	}
return

snapshot:
	FormatTime, currentTime, ,h.mm.ss-tt yyyy-MM-dd
	pToken:=Gdip_Startup()
	pBitmap:=Gdip_BitmapFromScreen()
	file := path currentTime ".jpg"
	Gdip_SaveBitmapToFile(pBitmap, file, 60)
	Gdip_Shutdown(pToken)
return
