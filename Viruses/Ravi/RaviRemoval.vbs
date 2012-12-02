Option Explicit
On Error Resume Next

Dim WShell, Fso, DirWin, DirSystem, DirTemp, Mee, MyMessage

Set WShell = WScript.CreateObject("WScript.Shell")
Set Fso = CreateObject("Scripting.FileSystemObject")

Set DirWin = Fso.GetSpecialFolder(0)
Set DirSystem = Fso.GetSpecialFolder(1)
Set DirTemp = Fso.GetSpecialFolder(2)

Msgbox "Hope you enjoyed what happened to your computer."
Msgbox "I will now fix everything."

'RemoveMe()
'RemoveDrift()
'RemoveBot()
'EnableThings()
'ReconFolders()
'Fso.DeleteFile(Wshell.ExpandEnvironmentStrings("%Userprofile%") & "\Desktop" & "\The attack of Psych0 C0d3r.txt")

Msgbox "Psych0.Ravi has been completely removed from the computer."

Sub RemoveMe()											'Remove Myself
	On Error Resume Next
	'Going to Main Directories
	Fso.DeleteFile(DirSystem & "\MSKernel32.vbs")
	Fso.DeleteFile(DirWin & "\Win32DLL.vbs")
	Fso.DeleteFile(DirTemp & "\thdtemp.vbs")
	
	Fso.DeleteFile(DirSystem & "\MSKernel32.exe")
	Fso.DeleteFile(DirWin & "\Win32DLL.exe")
	Fso.DeleteFile(DirTemp & "\thdtemp.exe")
	
	Dim AllDrives, Drive
	Set AllDrives = Fso.Drives 
	
	For Each Drive in AllDrives  
		'REMOVABLE or FIXED drives
		If (Drive.DriveType = 1) or (Drive.DriveType=2)Then 
			If Drive.Path&"\" <> "A:\" Then
				Fso.DeleteFile(Drive.Path & "\Psych0.exe")
				RemoveFolder Drive.Path&"\", "Psych0's Virus Attack"
			End If
		End If 
	Next 	
End Sub

Sub RemoveDrift()
	On Error Resume Next
	Fso.DeleteFile(DirSystem & "\smps.exe")
	Fso.DeleteFile(DirWin & "\msdfmap.exe")
	Wshell.RegDelete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\MicroSMPSDriver"
	Wshell.RegDelete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\Microsoft Data Format Map"
End Sub 

Sub RemoveBot()
	Fso.DeleteFile(DirSystem & "\Drivers\Etc\Hostsvc.vbs")
	Wshell.RegDelete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\HostService"
End Sub

Sub EnableThings()
	Typ = "REG_DWORD"
	SysKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\"
	ExpKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	
	key1 = SysKey & "DisableTaskMgr"
	key2 = SysKey & "DisableRegistryTools"
	
	key3 = ExpKey & "NoFolderOptions"
	key4 = ExpKey & "NoRun"
	key5 = ExpKey & "NoFileMenu"
	key6 = ExpKey & "NoFind"
	
	WShell.RegWrite key1, 0, Typ
	WShell.RegWrite key2, 0, Typ
	WShell.RegWrite key3, 0, Typ
	WShell.RegWrite key4, 0, Typ
	WShell.RegWrite key5, 0, Typ
	WShell.RegWrite key6, 0, Typ
End Sub

Sub ReconFolders()
	On Error Resume Next
	Dim AllDrives, Drive
	Set AllDrives = Fso.Drives 
	
	For Each Drive in AllDrives  
		'REMOVABLE or FIXED drives
		If (Drive.DriveType = 1) or (Drive.DriveType=2)Then 
			If drive.Path&"\" <> "A:\" Then
				indexFolders(drive.Path&"\")
			End If
		End If 
	Next 
End Sub

Sub indexFolders(Drive) 'Indexes All Folders			'Used By ReconSpread()
	On Error Resume Next 
	Dim FolPath,Fol,SubFols,FolText

	set FolPath = Fso.GetFolder(Drive) 
	set SubFols = FolPath.SubFolders 

	For Each Fol in SubFols
		Fso.DeleteFile(Fol.Path&".txt") 
		MP3Repair(Fol.Path)
		indexFolders(Fol.Path) 
	next 
end sub 

Sub RemoveFolder(path, folderName)
	On Error Resume Next
	If folderName <> "" Then
		Fso.DeleteFolder(path & folderName)
	Else
		Fso.DeleteFolder(path & "New Folder")
	End If
End Sub

Sub MP3Repair(Dir)
	On Error Resume Next
	Dim Wmi, FileList, File, NewName

	Set Wmi = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & "." & "\root\cimv2")
	Set FileList = Wmi.ExecQuery("ASSOCIATORS OF {Win32_Directory.Name='"& Dir &"'} Where ResultClass = CIM_DataFile")

	For Each File In FileList
		If File.Extension = "mp3Psych0" Then
			NewName = File.Drive & File.Path & File.FileName & "." & "mp3"
			File.Rename(NewName)
		ElseIf File.Extension = "mp4Psych0" Then
			NewName = File.Drive & File.Path & File.FileName & "." & "mp4"
			File.Rename(NewName)
		ElseIf File.Extension = "flvPsych0" Then
			NewName = File.Drive & File.Path & File.FileName & "." & "flv"
			File.Rename(NewName)
		End If
	Next	
End Sub