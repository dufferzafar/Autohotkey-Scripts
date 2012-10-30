; Sort Any Folder v1.2 (May 3rd 2011, original script idea by x79animal)

; Creates subfolders in selected folder and sorts files into them.
; User is then given choices to move sorted documents and pictures into
; User's regular Documents, Pictures and Music folders
; (Uses My Documents, My Pictures and My Music folders in XP).

;Subfolders created in User-selected folder (if files exist):

;Unsorted AHK Scripts
;Unsorted Documents
;Unsorted EXE Files
;Unsorted Music
;Unsorted PDF Files
;Unsorted Pictures
;Unsorted Video
;Unsorted Zip Files

FileSelectFolder, ChosenFolder, *%UserProfile%, 0, Hello`, %A_UserName%`.`nPlease select folder you wish to organize`:
if ChosenFolder =
    GoSub, NoFolder

SetWorkingDir %ChosenFolder%
MsgBox, 4,,
    (
Are you sure you want to organize
the folder located at`:

%ChosenFolder%?

Files will be moved to subfolders
based on their extension names.
    )
IfMsgBox Yes
    GoSub, Organize
IfMsgBox No
{
    MsgBox, Operation aborted.`nProgram will now exit
    ExitApp
}
Return


Organize:

FileTypes := "ahk,ahk.bak,bak" ; AutoHotkey script files
Loop, Parse, FileTypes, `,
IfExist, *.%A_LoopField%
 FileCreateDir, Unsorted AHK scripts

FileTypes := "exe,msi" ; EXE files
Loop, Parse, FileTypes, `,
IfExist, *.%A_LoopField%
 FileCreateDir, Unsorted EXE Files

FileTypes := "aac,aif,iff,m3u,mid,mpa,ra,wav,mp3" ; Music files
Loop, Parse, FileTypes, `,
IfExist, *.%A_LoopField%
 FileCreateDir, Unsorted Music

FileTypes := "ini,wps,wpd,msg,rtf,doc,docx,log,wks,xls,xlsx,nfo,txt" ; Document files
Loop, Parse, FileTypes, `,
IfExist, *.%A_LoopField%
 FileCreateDir, Unsorted Documents

FileTypes := "bmp,jpg,jpeg,ico,png,psd,psp,pspimage,thm,raw,tif,gif" ; Picture files
Loop, Parse, FileTypes, `,
IfExist, *.%A_LoopField%
 FileCreateDir, Unsorted Pictures

FileTypes := "zip,rar,7z,gzip" ; Zip files
Loop, Parse, FileTypes, `,
IfExist, *.%A_LoopField%
 FileCreateDir, Unsorted Zip Files

FileTypes := "3g2,3gp,asf,asx,avi,mov,mp4,mkv,mpg,mpeg,wmv,flv,swf,vob,rm,ram" ; Video files
Loop, Parse, FileTypes, `,
IfExist, *.%A_LoopField%
 FileCreateDir, Unsorted Video

IfExist, *.pdf ; Looks for PDF files
 FileCreateDir, Unsorted PDF Files


; Sorts and moves files into created folders without overwriting identical file names

FileTypes := "ahk,ahk.bak,bak" ; AutoHotkey script files
Loop, Parse, FileTypes, `,
FileMove, *.%A_LoopField%, Unsorted AHK scripts, 0

FileTypes := "exe,msi" ; EXE files
Loop, Parse, FileTypes, `,
FileMove, *.%A_LoopField%, Unsorted EXE Files, 0

FileTypes := "aac,aif,iff,m3u,mid,mpa,ra,wav,mp3" ; Music files
Loop, Parse, FileTypes, `,
FileMove, *.%A_LoopField%, Unsorted Music, 0

FileTypes := "ini,wps,wpd,msg,rtf,doc,docx,log,wks,xls,xlsx,nfo,txt" ; Document files
Loop, Parse, FileTypes, `,
FileMove, *.%A_LoopField%, Unsorted Documents, 0

FileTypes := "bmp,jpg,jpeg,ico,png,psd,psp,pspimage,thm,raw,tif,gif" ; Picture files
Loop, Parse, FileTypes, `,
FileMove, *.%A_LoopField%, Unsorted Pictures, 0

FileTypes := "zip,rar,7z,gzip" ; Zip files
Loop, Parse, FileTypes, `,
FileMove, *.%A_LoopField%, Unsorted Zip files, 0

FileTypes := "3g2,3gp,asf,asx,avi,mov,mp4,mkv,mpg,mpeg,wmv,flv,swf,vob,rm,ram" ; Video files
Loop, Parse, FileTypes, `,
FileMove, *.%A_LoopField%, Unsorted Video, 0

FileMove, *.pdf, Unsorted PDF Files, 0

Sleep 1000 ; Waits a second for FileMove to be completed


; Confirms sorting is finished and asks if User wants to move contents of Unsorted Documents into User's Documents folder (My Documents in XP)
MsgBox, 4,,
    (
Sorting completed!
Do you want to move the documents inside`:

%ChosenFolder%\Unsorted Documents

...into your Documents folder?

(Files with the same names as in
 your Documents folder will not be moved)
    )
IfMsgBox Yes
    GoSub, MoveDocs ; Calls subroutine to move contents of Unsorted Documents

; Asks if User wants to move contents of Unsorted Pictures into User's Pictures folder (My Pictures in XP)
MsgBox, 4,,
    (
Do you want to move the pictures inside`:

%ChosenFolder%\Unsorted Pictures

...into your Pictures folder?

(Files with the same names as in
 your Pictures folder will not be moved)
    )
IfMsgBox Yes
    GoSub, MovePics ; Calls subroutine to move contents of Unsorted Pictures

; Asks if User wants to move contents of Unsorted Music into User's Music folder (My Music in XP)
MsgBox, 4,,
    (
Do you want to move the music inside`:

%ChosenFolder%\Unsorted Music

...into your Music folder?

(Files with the same names as in
 your Music folder will not be moved)
    )
IfMsgBox Yes
    GoSub, MoveMusic ; Calls subroutine to move contents of Unsorted Music
IfMsgBox No
    MsgBox, Operation finished.`nProgram will now exit.
    ExitApp
Return

; Subroutines

NoFolder:
MsgBox, You didn't select a folder.`nProgram will now exit.
ExitApp
Return

MoveDocs:
FileMove, %ChosenFolder%\Unsorted Documents\*.*, %A_MyDocuments%, 0 ; Moves contents of Unsorted Documents into User's Documents folder (My Documents in XP)
Sleep 500
Return

MovePics:
RegRead, MyPicturesVar, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, My Pictures ; looks for User's Pictures folder location
FileMove, %ChosenFolder%\Unsorted Pictures\*.*, %MyPicturesVar%, 0 ; Moves contents of Unsorted Pictures into User's Pictures folder (My Pictures in XP)
Sleep 500
Return

MoveMusic:
RegRead, MyMusicVar, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, My Music ; looks for User's Music folder location
FileMove, %ChosenFolder%\Unsorted Music\*.*, %MyMusicVar%, 0 ; Moves contents of Unsorted Music into User's Music folder (My Music in XP)
Sleep 500
MsgBox, Operation finished.`nProgram will now exit. ; Displays when FileMove is completed
ExitApp
Return 