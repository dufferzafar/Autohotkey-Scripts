:: Replacer 2.57 by Undefined
:: www3.telus.net/_/replacer/
:: Email: undefined@telus.net

@echo off
title Replacer
ver|find "NT">nul&&(
 echo/Windows NT not allowed.&pause>nul&goto:eof)
setlocal disabledelayedexpansion enableextensions

if exist "%~dp0Components\*.exe" (
 set "path=%~dp0Components;%path%"
 title Replacer *) else (
 set "path=%windir%\system32;%path%")
set "dir=%~dp0.ReplacerTemp"

set flg="%dir%\..\.Flag_SafeToDel"
set fl2="%dir%\.Flag2_SafeToDel"
set lst="%dir%\Special.cmd"
set zap="%dir%\Zap.exe"
set vbs="%dir%\Clear_WFP_Message.vbs"
set "scr=%dir%\.CurrentScript"
set dat="%~dp0data"
set und="%windir%\ReplacerUndo.txt"
call:brk Purge

if '%1'=='' (goto:sys) else (
 echo/"%*"|find "?">nul&&(
 goto:hlp)||(if not '%2'=='' goto:hlp))


:scr
 cls&title Replacer : %~n1
 call:say Message ChkScr
 echo/
 call:chk "%~f1"||call:brk
 pushd "%~dp1"
 find/i ";; ReplacerScript" "%~f1"%>nul 2>&1||(
  call:say Error InvScr
  call:brk)
 copy/v/y "%~f1" "%scr%">nul
 for /f "usebackq tokens=1,2,3,4 delims=, eol=;" %%a in (
  "%scr%") do (
  setlocal
  call:idt "%%~b" "%%~c" "%%~d" "%%~a"&&(
   call:exm "%%~a"&&call:opt "%%~a")
  endlocal)
 if not exist "%scr%-tmp%" (
  type nul>"%scr%-tmp")
 copy/v/y "%scr%-tmp" "%scr%">nul
 for /f "tokens=3 delims=:" %%* in (
  'find/c /v "" "%scr%"') do (
  if "%%*"==" 0" (
   call:say Error NonScr
   call:brk
  ) else (
   echo/
   call:say Message RepScr %%*))
 ::echo/
 ::call:say Message KeyScr
 ::pause>nul&cls
 echo/
 for /f "usebackq tokens=1,2,3,4 delims=, eol=;" %%a in (
  "%scr%") do (
  setlocal
  echo/ * %%~a:
  call:seq "%%~a" "%%~b" "%%~c" "%%~d"
  echo/
  endlocal)
 type nul>%flg%
 echo/
 ::call:say Message Finish
 ::call:say Message KeyExt
 ::pause>nul
 del "%scr%"
 del "%scr%-tmp"
 call:brk Now

:sys Get system file
 cls&set "sys="
 call:say Message GetSys
 call:say Message KeyEnt
 call:say Message OrQuit
 call:get sys||goto:sys
 call:quo sys
 if /i %sys%=="Q" call:brk Now
 if %sys:\=%==%sys% (
  if not %sys:.=%==%sys% (
   call:scn %sys%))
 if defined pth (
  for %%* in (%sys%) do (
   set sys="%pth%%%~nx*"))
 call:chk %sys%||(
  call:say Message KeyCon
  pause>nul
  goto:sys)
 for %%* in (%sys%) do (
  if /i "%%~x*"==".txt" (
   find/i ";; ReplacerScript" %%*>nul&&(
    call:scr %%* )))
 call:ver %sys%||goto:sys

:mod Get replacement file
 cls&set "mod="
 call:say Message GetMod
 if exist %bak% (
  call:say Message OrRest)
 call:say Message KeyEnt
 call:say Message OrQuit
 call:get mod||goto:mod
 call:quo mod
 if /i %mod%=="Q" call:brk Now
 if /i %mod%=="RESTORE" call:rst||goto:mod
 call:chk %mod%||(
  call:say Message KeyCon
  pause>nul
  goto:mod)
 if /i %mod%==%sys% (
  call:say Error SameFl
  call:say Message KeyCon
  pause>nul)&&goto:mod

:cnf Confirm operation
 cls
 if %mod%==%bak% (
  call:say Message YesRst) else (
  if exist %bak% (
   call:say Message NotBak) else (
   for %%* in (%sys%) do (
    call:say Message YesBak "%%~dpn*.backup")))
 echo/
 call:say Message SysFil %sys%
 call:say Message ModFil %mod%
 echo/
 call:say Message Contin
 call:get cnf||goto:cnf
 call:quo cnf
 if /i not "%cnf:~1,1%"=="Y" call:brk Now
 cls

:vbs Start VBScript
 if exist %flg% del %flg%
 if not "%atr%"=="non" (
  start "" /abovenormal wscript //b %vbs% %flg%||(
   call:say Message VBSErr %vbs%))
 if exist "%scr%" exit/b

:rep Replace file
 if exist %und% del/f %und%
 if not exist "%scr%" (
  echo/ * %nam%:)
 if /i not %mod%==%bak% (
  if not exist %bak% (
   call:say Status CpyBak
   call:cpy %sys% %bak%))
 if not "%atr%"=="non" (
  if exist %dll% (
   call:say Status CpyDll
   call:cpy %mod% %dll%)
  if exist %spf% (
   call:say Status CpySpf
   call:cpy %mod% %spf%)
  if exist %c86% (
   call:say Status CpyC86
   call:cpy %mod% %fil%
   call:cab %fil% %c86%)
  if exist %w86% (
   call:say Status CpyW86
   call:cpy %mod% %fil%
   call:cab %fil% %w86%)
  if exist %d86% (
   call:say Status CpyD86
   call:cpy %mod% %d86%))
 call:say Status RepSys
 %zap% %sys%>nul 2>&1&&(
  call:say Error DelErr
  call:brk)
 call:cpy %mod% %sys%
 if exist "%scr%" (exit/b) else (type nul>%flg%)

:fin Finished
 echo/&echo/
 call:say Message Finish
 call:say Message KeyExt
 pause>nul&call:brk Now

goto:eof

 
:say Display message (type, 6-char ID)
 for /f "tokens=1,2 delims=#" %%a in (
  'call %lst% \%~2') do (
  if "%~1"=="Message" (
   call echo/%%a
   if not "%%~b"=="" (call echo/ %%b)
  ) else (
   if "%~1"=="Status" (
    echo/   - %%a...
   ) else (
    if "%~1"=="Error" (
     call echo/ ! %%a
     if not "%%~b"=="" call echo/    %%b
     echo/
    ) else (
     if "%~1"=="Indent" (
      call echo: ? %%a)))))
 exit/b

:get Get input (var)
 echo/
 set/p "%~1= > "
 if not defined %1 exit/b1
 echo/
 exit/b

:quo Quote variable (var)
 call set "quo=%%%1%%"
 set "quo=###%quo%###"
 set "quo=%quo:"###=%"
 set "quo=%quo:###"=%"
 set "quo=%quo:###=%"
 set %1="%quo%"
 set "quo="
 exit/b

:chk Check file (file)
 if not exist %1 (
  call:say Error NoFile %1
  exit/b1)
 if exist %1\ (
  call:say Error Folder %1
  exit/b1)
 echo/%1|find "*">nul&&(
  call:say Error Wildcd *
  exit/b1)
 echo/%1|find "?">nul&&(
  call:say Error Wildcd ?
  exit/b1)
 exit/b0

:ver Verify file (file)
 for %%* in (nam atr bak dll spf
  cab c86 w86 fln d86) do set "%%*="
 set "nam=%~nx1"
 set "pth=%~dp1"
 call %lst% %~n1 >nul 2>&1 || (
  set "atr=wfp")
 if not defined fln set "fln=%~nx1"
 set "pth=%pth%%nam%"
 set bak="%~dpn1.backup"
 set dll="%windir%\system32\dllcache\%fln%"
 set spf="%windir%\servicepackfiles\i386\%fln%"
 set "cab=%fln%"
 set "cab=%cab:~0,-1%_"
 set c86="%systemdrive%\i386\%cab%"
 set w86="%windir%\i386\%cab%"
 set d86="%windir%\Driver Cache\i386\%fln%"
 set fil="%dir%\%~nx1"
 exit/b0

:rst Restore backup
 if not exist %bak% (
  call:say Error NoBack %bak%
  call:say KeyCon
  pause>nul
  exit/b1) else (set "mod=%bak%")
 exit/b0

:cpy Copy file (source, target)
 if not %2==%sys% (
  attrib -h -r -s %1
  if exist %2 (
   attrib -h -r -s %2))
 copy/v/y %1 %2>nul 2>&1||(
  call:say Error CpyErr
  call:brk)
 if /i not %1==%bak% (
  if /i not %2==%bak% (
   >>%und% echo/del %2
   >>%und% echo/copy %bak% %2 ))
 exit/b

:cab Compress file (source, target)
 attrib -r -s -h %2
 makecab/v1 %1 %2>nul 2>&1||(
  call:say Error CmpErr
  call:brk)
 del %fil% 2>nul
 exit/b

:hlp Display help
 echo/Replaces protected system files.
 echo/
 echo/ Usage:
 echo/  %~n0 "ScriptFile"
 echo/
 echo/ Example:
 echo/  %~n0 "C:\Replacer\Script.txt"
 echo/
 echo/ Script syntax:
 echo/  ;; ReplacerScript
 echo/  ; Comment
 echo/  SystemFileName [,ReplacementFile] [,Reference#] [,Optional]
 echo/
 echo/ Script example:
 echo/  ;; ReplacerScript
 echo/  ; Replace Notepad, Calc, Paint
 echo/  notepad.exe,notepad.new
 echo/  calc.exe,files\calc.new
 echo/  mspaint.exe,"C:\Files\paint.new"
 echo/  ; Prompt to optionally restore Notepad from backup
 echo/  notepad.exe,RESTORE,Optional
 echo/
 echo/ See readme.txt for ReferenceNumber details.
 exit/b

:idt Identify script format (last 3 tokens, sys)
 set "sys=%~4"
 if /i "%~1"=="Restore" (
  if "%~2" LSS "9" (
   if "%~2"=="" (
    set "typ=R--"
   ) else (
    if "%~2" GEQ "0" (
     if /i "%~3"=="Optional" (
      set "typ=RNO"
     ) else (
      if /i "%~3"=="" (
       set "typ=RN-"))))
  ) else (
   if /i "%~2"=="Optional" (
    set "typ=R-O"))
 ) else (
  if "%~1" LSS "9" (
   if "%~1"=="" (
    set "typ=---"
   ) else (
    if "%~1" GEQ "0" (
     if /i "%~2"=="Optional" (
      set "typ=-NO"
     ) else (
      if /i "%~2"=="" (
       set "typ=-N-"))))
  ) else (
   if /i "%~1"=="Optional" (
    set "typ=--O"
   ) else (
    if "%~2" LSS "9" (
     if "%~2"=="" (
      set "typ=M--"
     ) else (
      if "%~2" GEQ "0" (
       if "%~3"=="" (
        set "typ=MN-"
       ) else (
        if /i "%~3"=="Optional" (
         set "typ=MNO"))))
    ) else (
     if /i "%~2"=="Optional" (
      set "typ=M-O")))))
 if not defined typ (
  call:say Error Unknwn
  exit/b1) else (
  call %lst% \%typ% "%~1" "%~2" "%~3")
 exit/b0

:exm Examine script (sys)
 call:scn "%~1"
 if not exist "%pth%\%~nx1" (
  call:say Error System "%~1"
  exit/b1)
 if /i not "%mod%"=="Restore" (
  if not exist "%mod%" (
   call:say Error Replac "%mod%"
   exit/b1))
 if not "%num%"=="" (
  find/i ":%~n1%num%" %lst%>nul 2>&1||(
   call:say Error RefNum "%~nx1,%num%"
   exit/b1))
 exit/b0

:opt Handles optional lines (sys)
 if /i "%opt%"=="Optional" (
  call:say Indent Option "%~1"
  setlocal enabledelayedexpansion
  call:get var
  if /i "!var!"=="Y" (
   endlocal
   call:fmt "%sys%,%mod%,%num%,%opt%"
   exit/b
  ) else (endlocal)
 ) else (
  call:fmt "%sys%,%mod%,%num%,%opt%"
  exit/b1)
 exit/b0

:fmt Format script
 set "var=%~1"
 set "var=%var:,,=, ,%"
 set "var=%var:,,=, ,%"
 >>"%scr%-tmp" echo/%var%
 exit/b0

:seq Run sequence (4 ordered tokens)
 set "pth="
 if not "%~3"==" " (call %lst% %~n1%~3) else (
  call:scn %1)
 set "sys=%pth%%~nx1"
 if /i "%~2"=="Restore" (
  set "mod=%pth%%~n1.backup") else (
   set "mod=%~f2")
 call:quo sys
 call:quo mod
 call:chk %sys%||exit/b
 call:chk %mod%||exit/b
 call:ver %sys%||exit/b
 call:rep
 exit/b0

:scn Scan Folders
 set "pth="
 call %lst% %~n10&&exit/b0
 for %%* in (
  "%windir%"
  "%windir%\system32"
  "%windir%\system32\drivers"
  "%windir%\system"
  "%programfiles%\Outlook Express"
  "%programfiles%\Windows Media Player"
  "%windir%\Resources\Themes\Luna"
  "%programfiles%\Movie Maker"
  "%programfiles%\Windows NT"
  "%windir%\PCHEALTH\HELPCTR\Binaries"
  "%windir%\Fonts"
  "%programfiles%\Internet Explorer"
  "%programfiles%\Internet Explorer\Connection Wizard"
  "%commonprogramfiles%\Microsoft Shared\MSInfo"
  "%programfiles%\Windows NT\Accessories"
  "%programfiles%\Windows NT\Pinball"
  "%commonprogramfiles%\System"
  "%windir%\system32\Restore"
  "%windir%\system32\srchasst"
  "%windir%\system32\usmt"
  "%commonprogramfiles%\Microsoft Shared\Speech"
  "%programfiles%\NetMeeting"
  "%commonprogramfiles%\System\Mapi\1033"
  "%commonprogramfiles%\Adobe\Calibration"
  "%programfiles%\Symantec\LiveUpdate"
  "%programfiles%\WildTangent\Apps\CDA"
  "%programfiles%\Stardock\Object Desktop\IconPackager"
 ) do (
  if not exist %fl2% (
   if exist "%%~*\%~nx1" (
    set "pth=%%~*\"
    type nul>%fl2%)))
 if exist %fl2% del %fl2%
 exit/b0

:brk Exit Replacer ([Purge] [Now])
 if not "%~1"=="Purge" (
  if not "%~1"=="Now" (
    echo/
    call:say Message KeyExt
    pause>nul))
 if /i not "%~1"=="Purge" if exist "%scr%" popd
 for %%* in (%fil% %flg%
  %fl2% "%scr%" "%scr%-tmp" 
  "%systemdrive%\_@??.tmp"
 ) do if exist %%* del/f %%* >nul 2>&1
 if /i not "%~1"=="Purge" (
  endlocal&exit)