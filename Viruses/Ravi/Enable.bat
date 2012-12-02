reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Userinit /f /d "%windir%\system32\userinit.exe",
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /f /d "explorer.exe"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t Reg_dword /v Hidden /f /d 00000002
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t Reg_dword /v ShowSuperHidden /f /d 00000001
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t Reg_dword /v SuperHidden /f /d 00000000
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\NOHIDDEN" /t Reg_dword /v CheckedValue /f /d 00000002
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\NOHIDDEN" /t Reg_dword /v DefaultValue /f /d 00000002
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL" /t Reg_dword /v CheckedValue /f /d 00000001
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL" /t Reg_dword /v DefaultValue /f /d 00000002
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\SuperHidden" /t Reg_dword /v CheckedValue /f /d 00000000
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\SuperHidden" /t Reg_dword /v DefaultValue /f /d 00000000
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\SuperHidden" /t Reg_dword /v UncheckedValue /f /d 00000001
reg add "HKLM\Software\Policies\Microsoft\Windows\Installer" /t Reg_dword /v DisableMSI /f /d 0
reg add "HKCU\Software\Policies\Microsoft\Windows\System" /t Reg_dword /v DisableCMD /f /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /t Reg_dword /v DisableCMD /f /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /t Reg_dword /v DisableConfig /f /d 0
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /t Reg_dword /v DisableSR /f /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /t Reg_Binary /v NoDriveAutoRun /f /d ffffff03
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /t Reg_dword /v NoDriveTypeAutoRun /f /d 36
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /t Reg_dword /v NoFolderOptions /f /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /t Reg_dword /v NoFolderOptions /f /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /t Reg_dword /v NoRun /f /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /t Reg_dword /v NoFind /f /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /t Reg_dword /v NoFind /f /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UnreadMail" /t Reg_dword /v MessageExpiryDays /f /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /t Reg_dword /v DisableRegistryTools /f /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /t Reg_dword /v DisableRegistryTools /f /d 0
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /t Reg_dword /v DisableTaskMgr /f /d 0
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /t Reg_dword /v DisableTaskMgr /f /d 0
Msg * /TIME 5 All Restrictions have been Removed!!