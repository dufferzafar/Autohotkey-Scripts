:: Special files and strings
@echo off
call:%~1 "%~2" "%~3" "%~4" 2>nul||exit/b1
exit/b0

:Luna
 set "fln=luna.mst"
 set "atr=wfp"
 exit/b0

:Shellstyle
 if /i not "%pth:Homestead=%"=="%pth%" (
  set "fln=home_ss.dll")
 if /i not "%pth:Metallic=%"=="%pth%" (
  set "fln=metal_ss.dll")
 if /i not "%pth:NormalColor=%"=="%pth%" (
  set "fln=blue_ss.dll")
 if /i not "%pth:\system32\=%"=="%pth%" (
  set "fln=class_ss.dll")
 set "atr=wfp"
 exit/b0

:Marlett
 set "atr=non"
 exit/b0

:Comctl32
 if /i not "%pth%"=="%windir%\system32\" (
  set "atr=non")
 exit/b0

:Commdlg
 if /i not "%pth%"=="%windir%\system\" (
  set "atr=non")
 exit/b0

:Notepad
 if /i not "%pth%"=="%windir%\" (
  set "atr=non")
 exit/b0

:Uxtheme.dll
 set "atr=


:: Reference numbers

:Comctl320
 set "pth=%windir%\system32\"
 exit/b0

:Comctl321
 set "pth=%windir%\WinSxS\x86_Microsoft.Windows.Common-Controls_6595b64144ccf1df_6.0.0.0_x-ww_1382d70a\"
 exit/b0

:Comctl322
 set "pth=%windir%\WinSxS\x86_Microsoft.Windows.Common-Controls_6595b64144ccf1df_6.0.10.0_x-ww_f7fb5805\"
 exit/b0

:Comctl323
 set "pth=%windir%\WinSxS\x86_Microsoft.Windows.Common-Controls_6595b64144ccf1df_6.0.2600.1331_x-ww_7abf6d02\"
 exit/b0

:Comctl324
 set "pth=%windir%\WinSxS\x86_Microsoft.Windows.Common-Controls_6595b64144ccf1df_6.0.2600.1515_x-ww_7bb98b8a\"
 exit/b0

:Comctl325
 set "pth=%windir%\WinSxS\x86_Microsoft.Windows.Common-Controls_6595b64144ccf1df_6.0.2600.2180_x-ww_a84f1ff9\"
 exit/b0

:Commdlg0
 set "pth=%windir%\system\"
 exit/b0

:Commdlg1
 set "pth=%windir%\system32\"
 exit/b0

:Notepad0
 set "pth=%windir%\"
 exit/b0

:Notepad1
 set "pth=%windir%\system32\"
 exit/b0

:Shellstyle0
 set "pth=%windir%\system32\"
 exit/b0

:Shellstyle1
 set "pth=%windir%\Resources\Themes\Luna\Shell\NormalColor\"
 exit/b0

:Shellstyle2
 set "pth="%windir%\Resources\Themes\Luna\Shell\Metallic\"
 exit/b0

:Shellstyle3
 set "pth=%windir%\Resources\Themes\Luna\Shell\Homestead\"
 exit/b0

:: Formats

:\RNO
 set "mod=Restore"
 set "num=%~2"
 set "opt=%~3"
 exit/b
:\R-O
 set "mod=Restore"
 set "num="
 set "opt=%~2"
 exit/b
:\RN-
 set "mod=Restore"
 set "num=%~2"
 set "opt="
 exit/b
:\R--
 set "mod=Restore"
 set "num="
 set "opt="
 exit/b

:\-N-
 set "mod=%sys%"
 set "num=%~1"
 set "opt="
 exit/b
:\-NO
 set "mod=%sys%"
 set "num=%~1"
 set "opt=%~2"
 exit/b

:\--O
 set "mod=%sys%"
 set "num="
 set "opt=%~1"
 exit/b

:\M--
 set "mod=%~1"
 set "num="
 set "opt="
 exit/b
:\MN-
 set "mod=%~1"
 set "num=%~2"
 set "opt="
 exit/b
:\M-O
 set "mod=%~1"
 set "num="
 set "opt=%~2"
 exit/b
:\MNO
 set "mod=%~1"
 set "num=%~2"
 set "opt=%~3"
 exit/b

:\---
 set "mod=%sys%"
 set "num="
 set "opt="
 exit/b


:: Strings

:\GetSys
 echo/Drag the ORIGINAL system file to replace into this window.
 exit/b

:\OrQuit
 echo/Or, type Q to quit.
 exit/b

:\KeyEnt
 echo/Then, press enter to continue.
 exit/b

:\GetMod
 echo/Drag the REPLACEMENT %%nam%% into this window.
 exit/b

:\OrRest
 echo/Or, type RESTORE to restore the backup of %nam%.
 exit/b

:\YesRst
 echo/File will be restored.
 exit/b

:\NotBak
 echo/File will not be backed up, backup already exists.
 exit/b

:\YesBak
 echo/File will be backed up to:#%%3
 exit/b

:\SysFil
 echo/The system file:#%%3
 exit/b

:\ModFil
 echo/will be replaced with:#%%3
 exit/b

:\Contin
 echo/Continue? (Y/N)
 exit/b

:\Finish
 echo/Complete. Reboot to see changes.
 exit/b

:\KeyExt
 echo/Press any key to quit.
 exit/b

:\KeyCon
 echo/Press any key to continue.
 exit/b

:\ChkScr
 echo/Checking script...
 exit/b

:\RepScr
 echo/%%3 file(s) will be replaced.
 exit/b

:\KeyScr
 echo/Press any key to start the script.
 exit/b

:\CpyBak
 echo/Backing up
 exit/b

:\CpyDll
 echo/Copying to DllCache
 exit/b

:\CpySpf
 echo/Copying to ServicePackFiles
 exit/b

:\CpyC86
 echo/Compressing to i386 folder
 exit/b

:\CpyW86
 echo/Compressing to Windows i386 folder
 exit/b

:\CpyD86
 echo/Copying to Driver Cache
 exit/b

:\RepSys
 echo/Replacing system file
 exit/b

:\NoFile
 echo/File does not exist:#%%3
 exit/b

:\Folder
 echo/Folders not allowed:#%%3
 exit/b

:\Wildcd
 echo/Wildcards (%%3) not allowed.
 exit/b

:\SameFl
 echo/A file cannot replace itself.
 exit/b

:\VBSErr
 echo/VBScript failed:#%%3
 exit/b

:\DelErr
 echo/Delete failed.
 exit/b

:\NoBack
 echo/Backup does not exist:#%%3
 exit/b

:\CpyErr
 echo/Copy failed.
 exit/b

:\CmpErr
 echo/Compress failed.
 exit/b

:\InvScr
 echo/Invalid Replacer script, doesn't contain ";; ReplacerScript".
 exit/b

:\FtrScr
 echo/Filtering of script failed.
 exit/b

:\NonScr
 echo/No files to be replaced.
 exit/b

:\System
 echo/System file not found: %%3
 exit/b

:\Replac
 echo/Replacement file not found: %%3
 exit/b

:\RefNum
 echo/Invalid reference number: %%3
 exit/b

:\Unknwn
 echo/Format of line unknown.
 exit/b

:\Option
 echo/Replace optional file %%3? (Y/N)
 exit/b