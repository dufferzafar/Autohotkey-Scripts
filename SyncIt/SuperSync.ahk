; supersynchronizer
; :: SuperSynchronizer, a little script to backup a directory in incremental or mirror mode.
; :: Set the source and destination directory, set copy mode and let the script work.
; :: If you need to exclude files from the replication or reverse check, add them into exclusion lists.

#SingleInstance force

; Change these values for source and destination directories.
; [absolute path]
srcDir = D:\Tosync\Source
destDir = D:\Tosync\Dest

; Change this to "y" for directory mirroring or to "n" for incremental copy without mirroring.
toMirror = n


; REPLICATION CHECK GLOBAL EXCLUSIONS
; THESE ITEMS WILL NOT BE COPIED ON DESTINATION SIDE
; ***************************************************************
;
; Add source items (absolute path or relative name) to exclude them from the replication check.
; These items will not be created on destination side.
;
; Rules:
; ------
; [continuation section]
; [newline separated]
; [no quotes]
; [surrounded by <>]
;
; Examples:
; ---------
; SS_exReplicationXXX =
; ( LTrim
; <C:\example_source_dir\example_source_item>
; )
;
; SS_exReplicationXXXRel =
; ( LTrim
; <example_source_item>
; )
;
; ---------------------------------------------------------------

; Excluded directories (absolute path)
SS_exReplicationDirs =
( LTrim
)

; Excluded directories (relative name)
SS_exReplicationDirsRel =
( LTrim
)

; Excluded files (absolute path)
SS_exReplicationFiles =
( LTrim
)

; Excluded files (relative name)
SS_exReplicationFilesRel =
( LTrim
)


; REVERSE CHECK GLOBAL EXCLUSIONS
; THESE ITEMS WILL NOT BE DELETED ON DESTINATION SIDE
; ***************************************************************
;
; Add destination items (absolute path or relative name) to exclude them from the reverse check.
; These items will not be deleted on destination side.
;
; Rules:
; ------
; [continuation section]
; [newline separated]
; [no quotes]
; [surrounded by <>]
;
; Examples:
; ---------
; SS_exReverseXXX =
; ( LTrim
; <C:\example_destination_dir\example_destination_item>
; )
;
; SS_exReverseXXXRel =
; ( LTrim
; <example_destination_item>
; )
;
; ---------------------------------------------------------------

; Excluded directories (absolute path)
SS_exReverseDirs =
( LTrim
)

; Excluded directories (relative name)
SS_exReverseDirsRel =
( LTrim
)

; Excluded files (absolute path)
SS_exReverseFiles =
( LTrim
)

; Excluded files (relative name)
SS_exReverseFilesRel =
( LTrim
)


; PROGRAM LOGIC
; ***************************************************************

; Gui management
Gui, 11:Add, Text, vSS_syncText Left w200, Synchronizing...
Gui, 11:Add, Button, gSS_exitLabel vSS_syncButton w50 h20 x+10, &Close
Gui, 11:-Caption +Border
Gui, 11:Show, Center Autosize, SuperSynchronizer

; Log management
; VarSetCapacity(SS_logData, 10240000) ; 10MB
; SS_logData = [%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - REPLICATION CHECK STARTED`n******************************************************************************`n

; Core logic
SetWorkingDir, %srcDir%
SS_ReplicationCheckRecursive("*.*")
If toMirror = y
{
   ; Log management
   ; SS_logData = %SS_logData%`n[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - REVERSE CHECK STARTED`n******************************************************************************`n

   SetWorkingDir, %destDir%
   SS_ReverseCheckRecursive("*.*")
}
SetWorkingDir, %A_ScriptDir%

; Log management
; SS_logData = %SS_logData%`n------------------------------------------------------------------------------`n`n
; FileAppend, %SS_logData%, %A_ScriptDir%\SS_log.txt

; Gui management
Gui, 11:Cancel
GuiControl, 11:, SS_syncText, DONE!
GuiControl, 11:, SS_syncButton, &Ok
GuiControl, 11:+Default, SS_syncButton
Gui, 11:Show, Center Autosize, SuperSynchronizer

Return


; Exit label
SS_exitLabel:
Gui, 11:Destroy
ExitApp


; This function implements the replication check, where the source items
; are replicated on destination side (the function is recursive)
SS_ReplicationCheckRecursive(SS_aPattern)
{
   Global srcDir, destDir, SS_exReplicationDirs, SS_exReplicationDirsRel, SS_exReplicationFiles, SS_exReplicationFilesRel, SS_logData

   Loop, %SS_aPattern%, 1
   {
      FileGetAttrib, SS_checkPattern, %A_LoopFileFullPath%
      ; It's a directory
      IfInString, SS_checkPattern, D
      {
         ; If directory isn't in exlusion lists
         If (NOT InStr(SS_exReplicationDirs, "<" . A_LoopFileLongPath . ">")) AND (NOT InStr(SS_exReplicationDirsRel, "<" . A_LoopFileName . ">"))
         {
            ; Checks if source directory exists as destination directory, if not it creates it
            IfNotExist, %destDir%\%A_LoopFileFullPath%
            {
               FileCreateDir, %destDir%\%A_LoopFileFullPath%
               ; Log management
               If ErrorLevel
               {
                  ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - ERROR >> Could not create directory: "%destDir%\%A_LoopFileFullPath%" #`n
               }
               Else
               {
                  ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SUCCESS >> Directory created: "%destDir%\%A_LoopFileFullPath%" #`n
               }
            }
            ; Recursion into current directory
            SS_ReplicationCheckRecursive(A_LoopFileFullPath . "\*.*")
         }
         ; Directory skipped
         Else
         {
            ; Log management
            ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SKIPPED >> Directory excluded: "%A_LoopFileLongPath%" #`n
         }

      }
      ; It's a file
      Else
      {
         SS_copyItFlag = n
         ; If file isn't in exlusion lists
         If (NOT InStr(SS_exReplicationFiles, "<" . A_LoopFileLongPath . ">")) AND (NOT InStr(SS_exReplicationFilesRel, "<" . A_LoopFileName . ">"))
         {
            ; Checks if file exists in destination directory, if not sets copy flag
            IfNotExist, %destDir%\%A_LoopFileFullPath%
            {
               SS_copyItFlag = y
            }
            Else
            {
               ; Checks if source file is more recent than destination file, if yes sets copy flag
               FileGetTime, SS_time, %destDir%\%A_LoopFileFullPath%
               EnvSub, SS_time, %A_LoopFileTimeModified%, seconds
               If SS_time < 0
               {
                  SS_copyItFlag = y
               }
            }
         }
         ; File skipped
         Else
         {
            ; Log management
            ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SKIPPED >> File excluded: "%A_LoopFileLongPath%" #`n
         }
         ; Copy file
         If SS_copyItFlag = y
         {
            SS_destFileLongPath = %destDir%\%A_LoopFileFullPath%
            FileCopy, %A_LoopFileLongPath%, %SS_destFileLongPath%, 1
            ; Log management
            If ErrorLevel
            {
               ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - ERROR >> Error copying "%A_LoopFileLongPath%" to "%SS_destFileLongPath%" #`n
            }
            Else
            {
               ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SUCCESS >> Copied "%A_LoopFileLongPath%" to "%SS_destFileLongPath%" #`n
            }
         }
      }
   }
   Return 0
}


; This function implements the reverse check, where the destination side is analyzed and
; eventually modified to create a mirror copy of the source (the function is recursive)
SS_ReverseCheckRecursive(SS_aPattern)
{
   Global srcDir, destDir, SS_exReverseDirs, SS_exReverseDirsRel, SS_exReverseFiles, SS_exReverseFilesRel, SS_logData

   Loop, %SS_aPattern%, 1
   {
      FileGetAttrib, SS_checkPattern, %A_LoopFileFullPath%
      ; It's a directory
      IfInString, SS_checkPattern, D
      {
         ; If directory doesn't exist on source side
         IfNotExist, %srcDir%\%A_LoopFileFullPath%
         {
            ; If directory isn't in exlusion lists
            If (NOT InStr(SS_exReverseDirs, "<" . A_LoopFileLongPath . ">")) AND (NOT InStr(SS_exReverseDirsRel, "<" . A_LoopFileName . ">"))
            {
               ; Backup flag (to restore the dontDeleteDirFlag if next recursion sets the flag to 0 and it was 1)
               ; Eg: the item is a directory that can be deleted
               SS_oldFlag = SS_dontDeleteDirFlag
               ; Recurses and obtains a new flag
               SS_dontDeleteDirFlag := SS_ReverseCheckRecursive(A_LoopFileFullPath . "\*.*")
               If SS_dontDeleteDirFlag != 1
               {
                  FileRemoveDir, %A_LoopFileFullPath%, 1
                  ; Log management
                  If ErrorLevel
                  {
                     ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - ERROR >> Could not delete directory: "%A_LoopFileLongPath%" #`n
                  }
                  Else
                  {
                     ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SUCCESS >> Directory removed: "%A_LoopFileLongPath%" #`n
                  }
                  ; Restores flag
                  If SS_oldFlag = 1
                  {
                     SS_dontDeleteDirFlag = 1
                  }
               }
               ; Directory skipped
               Else
               {
                  ; Log management
                  ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SKIPPED >> Directory excluded because of file dependancy: "%A_LoopFileLongPath%" #`n
               }
            }
            ; Directory skipped
            Else
            {
               SS_dontDeleteDirFlag = 1
               ; Log management
               ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SKIPPED >> Directory excluded: "%A_LoopFileLongPath%" #`n
            }
         }
         ; If directory exists in source side
         Else
         {
            SS_ReverseCheckRecursive(A_LoopFileFullPath . "\*.*")
         }
      }
      ; It's a file
      Else
      {
         ; If file doesn't exist on source side
         IfNotExist, %srcDir%\%A_LoopFileFullPath%
         {
            ; If file isn't in exclusion lists
            If (NOT InStr(SS_exReverseFiles, "<" . A_LoopFileLongPath . ">")) AND (NOT InStr(SS_exReverseFilesRel, "<" . A_LoopFileName . ">"))
            {
               FileDelete, %A_LoopFileFullPath%
               ; Log management
               If ErrorLevel
               {
                  ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - ERROR >> Could not delete "%A_LoopFileLongPath%" #`n
               }
               Else
               {
                  ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SUCCESS >> File deleted: "%A_LoopFileLongPath%" #`n
               }
            }
            ; The file is skipped for exclusion, to keep it on destination side, sets the SS_dontDeleteDirFlag
            Else
            {
               SS_dontDeleteDirFlag = 1
               ; Log management
               ; SS_logData = %SS_logData%[%A_YYYY%/%A_MM%/%A_DD%]%A_Hour%:%A_Min%:%A_Sec% - SKIPPED >> File excluded: "%A_LoopFileLongPath%" #`n
            }
         }
      }
   }
   Return SS_dontDeleteDirFlag
}