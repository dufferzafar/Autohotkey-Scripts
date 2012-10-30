#IfWinActive ahk_class ExploreW Class ahk_class CabinetWClass   ; if explorer is active
^#r::                     ; Ctrl+Win+r
SetWorkingDir, % ControlGetText("edit1",ahk_class CabinetWClass)
Clipboard := ""           ; Start off empty to allow ClipWait to detect when the text has arrived
SendInput, ^c                  ; Simulate the Copy hotkey (Ctrl+C)
ClipWait, 2, 1                 ; Wait 2 seconds for the clipboard to contain text
Selection := Clipboard         ; Put the clipboard in the variable Selection
if selection =
   return   ; exit if nothing selected
loop, parse, selection,`n,`r
{
   index := a_index
}
if (index > 1)
   gosub multyrename
else
   gosub singlerename
#IfWinActive
return

singlerename:
newname := InputBox("File/folder renamer","Type the new name `nif you enter a different path or drive `nit will be moved" ,selection,,330,170)

if ErrorLevel
   return  ; exit if cancel was pressed

FileGetAttrib, Attributes, %selection%
IfInString, Attributes, D  ; it it is  a folder
  FileMovedir, %selection%, %newname%
else
  FileMove, %selection%, %newname%
if errorlevel = 1 ; if error
   msgbox Error in renaming/moving
; Clipboard := LastClipboard   ; Restore the previous clipboard
;clipboard := selection   

return

multyrename:
prefix := InputBox("File renaming","Type the new name `n(Adding a # before the name will create a counter)`nOtherwise it will prefix it" ,"#Newname",,330,170)
if errorlevel
   return
loop, parse, selection,`n,`r
{
;index++
FileGetAttrib, Attributes, %A_LoopField%
IfInString, Attributes, D  ; it it is  a folder Skips the rest of the current loop iteration and begins a new one
  continue 
index := a_index
   ifinstring,prefix,#
   {
     StringReplace, prefix2, prefix,#
     index := SubStr("000" . index, -2)   
     newname := prefix2 . "-" . index
     FileMove, %A_LoopField% , % newname . "." . getfilepart(A_LoopField,"ext")
   }
   else 
   { 
     newname := prefix . getfilepart(A_LoopField,"name")
     FileMove, %A_LoopField% , %newname%
     if errorlevel = 1 ; if error
        msgbox Error in renaming/moving
   }
}
return

;   ************* some  functions   **************

ControlGetText(Control="", WinTitle="", WinText="", ExcludeTitle="", ExcludeText="")
{
   ControlGetText, OutputVar, % Control, % WinTitle, % WinText, % ExcludeTitle, % ExcludeText
   Return OutputVar
}

InputBox(Title="",Prompt="",Default="",HIDE="",Width=330,Height=170,X="",Y="",Font="",Timeout= "")
{
  InputBox, v, %Title%, %Prompt%, %HIDE%, %Width%,%Height%, %X%,%Y%,,%Timeout%,%Default%
   Return, v
}
return

;funtion to get part of a file created by me sal
;  for what_part argument is the literal strings "name", "dir", "ext", "name_no_ext", or "drive"
getfilepart(fullfilename,what_part)
{
  SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
  return (%what_part%)
}