; MAIN EXAMPLE
; The following is a working script that is more elaborate than the one near the top of this page.
; It displays the files in a folder chosen by the user, with each file assigned the icon associated with
; its type. The user can double-click a file, or right-click one or more files to display a context menu.

; Allow the user to maximize or drag-resize the window:
Gui +Resize

; Create some buttons:
Gui, Add, Button, Default gButtonLoadFolder, Load a folder
Gui, Add, Button, x+20 gButtonClear, Clear List
Gui, Add, Button, x+20, Switch View

; Create the ListView and its columns:
Gui, Add, ListView, xm r20 w700 vMyListView gMyListView, Name|In Folder|Size (KB)|Type
LV_ModifyCol(3, "Integer")  ; For sorting, indicate that the Size column is an integer.

; Create an ImageList so that the ListView can display some icons:
ImageListID1 := IL_Create(10)
ImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.

; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)

; Create a popup menu to be used as the context menu:
Menu, MyContextMenu, Add, Open, ContextOpenFile
Menu, MyContextMenu, Add, Properties, ContextProperties
Menu, MyContextMenu, Add, Clear from ListView, ContextClearRows
Menu, MyContextMenu, Default, Open  ; Make "Open" a bold font to indicate that double-click does the same thing.

; Display the window and return. The OS will notify the script whenever the user
; performs an eligible action:
Gui, Show
return


ButtonLoadFolder:
Gui +OwnDialogs  ; Forces user to dismiss the following dialog before using main window.
FileSelectFolder, Folder,, 3, Select a folder to read:
if not Folder  ; The user canceled the dialog.
    return

; Check if the last character of the folder name is a backslash, which happens for root
; directories such as C:\. If it is, remove it to prevent a double-backslash later on.
StringRight, LastChar, Folder, 1
if LastChar = \
    StringTrimRight, Folder, Folder, 1  ; Remove the trailing backslash.

; Calculate buffer size required for SHFILEINFO structure.
sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
VarSetCapacity(sfi, sfi_size)

; Gather a list of file names from the selected folder and append them to the ListView:
GuiControl, -Redraw, MyListView  ; Improve performance by disabling redrawing during load.
Loop %Folder%\*.*
{
    FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.

    ; Build a unique extension ID to avoid characters that are illegal in variable names,
    ; such as dashes.  This unique ID method also performs better because finding an item
    ; in the array does not require search-loop.
    SplitPath, FileName,,, FileExt  ; Get the file's extension.
    if FileExt in EXE,ICO,ANI,CUR
    {
        ExtID := FileExt  ; Special ID as a placeholder.
        IconNumber = 0  ; Flag it as not found so that these types can each have a unique icon.
    }
    else  ; Some other extension/file-type, so calculate its unique ID.
    {
        ExtID = 0  ; Initialize to handle extensions that are shorter than others.
        Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
        {
            StringMid, ExtChar, FileExt, A_Index, 1
            if not ExtChar  ; No more characters.
                break
            ; Derive a Unique ID by assigning a different bit position to each character:
            ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
        }
        ; Check if this file extension already has an icon in the ImageLists. If it does,
        ; several calls can be avoided and loading performance is greatly improved,
        ; especially for a folder containing hundreds of files:
        IconNumber := IconArray%ExtID%
    }
    if not IconNumber  ; There is not yet any icon for this extension, so load it.
    {
        ; Get the high-quality small-icon associated with this file extension:
        if not DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "str", FileName
            , "uint", 0, "ptr", &sfi, "uint", sfi_size, "uint", 0x101)  ; 0x101 is SHGFI_ICON+SHGFI_SMALLICON
            IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
        else ; Icon successfully loaded.
        {
            ; Extract the hIcon member from the structure:
            hIcon := NumGet(sfi, 0)
            ; Add the HICON directly to the small-icon and large-icon lists.
            ; Below uses +1 to convert the returned index from zero-based to one-based:
            IconNumber := DllCall("ImageList_ReplaceIcon", "ptr", ImageListID1, "int", -1, "ptr", hIcon) + 1
            DllCall("ImageList_ReplaceIcon", "ptr", ImageListID2, "int", -1, "ptr", hIcon)
            ; Now that it's been copied into the ImageLists, the original should be destroyed:
            DllCall("DestroyIcon", "ptr", hIcon)
            ; Cache the icon to save memory and improve loading performance:
            IconArray%ExtID% := IconNumber
        }
    }

    ; Create the new row in the ListView and assign it the icon number determined above:
    LV_Add("Icon" . IconNumber, A_LoopFileName, A_LoopFileDir, A_LoopFileSizeKB, FileExt)
}
GuiControl, +Redraw, MyListView  ; Re-enable redrawing (it was disabled above).
LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(3, 60) ; Make the Size column at little wider to reveal its header.
return


ButtonClear:
LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.
return

ButtonSwitchView:
if not IconView
    GuiControl, +Icon, MyListView    ; Switch to icon view.
else
    GuiControl, +Report, MyListView  ; Switch back to details view.
IconView := not IconView             ; Invert in preparation for next time.
return

MyListView:
if A_GuiEvent = DoubleClick  ; There are many other possible values the script can check.
{
    LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
    LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
    Run %FileDir%\%FileName%,, UseErrorLevel
    if ErrorLevel
        MsgBox Could not open "%FileDir%\%FileName%".
}
return

GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
if A_GuiControl <> MyListView  ; Display the menu only for clicks inside the ListView.
    return
; Show the menu at the provided coordinates, A_GuiX and A_GuiY.  These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

ContextOpenFile:  ; The user selected "Open" in the context menu.
ContextProperties:  ; The user selected "Properties" in the context menu.
; For simplicitly, operate upon only the focused row rather than all selected rows:
FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
if not FocusedRowNumber  ; No row is focused.
    return
LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
LV_GetText(FileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
IfInString A_ThisMenuItem, Open  ; User selected "Open" from the context menu.
    Run %FileDir%\%FileName%,, UseErrorLevel
else  ; User selected "Properties" from the context menu.
    Run Properties "%FileDir%\%FileName%",, UseErrorLevel
if ErrorLevel
    MsgBox Could not perform requested action on "%FileDir%\%FileName%".
return

ContextClearRows:  ; The user selected "Clear" in the context menu.
RowNumber = 0  ; This causes the first iteration to start the search at the top.
Loop
{
    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
    ; subtract 1 so that the search includes the same row number that was previously
    ; found (in case adjacent rows are selected):
    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_Delete(RowNumber)  ; Clear the row from the ListView.
}
return

GuiSize:  ; Expand or shrink the ListView in response to the user's resizing of the window.
if A_EventInfo = 1  ; The window has been minimized.  No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the ListView to match.
GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 40)
return

GuiClose:  ; When the window is closed, exit the script automatically:
ExitApp