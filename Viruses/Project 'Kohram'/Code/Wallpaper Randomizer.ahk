;===============================================================================
;
;   Wallpaper Randomizer
;   System Tray Wallpaper Changer
;
;   Danny Ben Shitrit (Sector-Seven) 2011
;   Homepage: http://sector-seven.net
;   Email   : db@sector-seven.net
;
;   Contributors: 
;     Ashus - http://ashus.ashus.net/
; 
;===============================================================================
VersionString = 0.38
NameString    = Wallpaper Randomizer
AuthorString  = Danny Ben Shitrit (Sector-Seven)

#SingleInstance force
#Persistent

Gosub Init
Gosub Main

Return

;-------------------------------------------------------------------------------
; MAINS
;-------------------------------------------------------------------------------
Init:
  ; Some settings
  StringCaseSense Off
  SetWorkingDir %A_ScriptDir%

  If( !FileExist( "topng.exe" ) )
    Error( "Unable to find a required file: topng.exe`nAborting" )
  
  FirstRun := true
  MSEC_PER_MIN := 60000
  
  ShortcutFile := A_Startup . "\" . NameString . ".lnk"
  
  ; Read INI
  IniFile = %A_ScriptDir%\%NameString%.ini
  IniRead Interval,       %IniFile%, General, Interval, 10
  IniRead Suspended,      %IniFile%, General, Paused, 0
  IniRead ImageDir,       %IniFile%, General, ImageDir
  IniRead ShowTraytip,    %IniFile%, General, ShowTrayTip
  IniRead IntervalString, %IniFile%, General, Intervals, % "2,5,10,15,20,30,45,60,90,120,180,240"
  IniRead TempDir,        %IniFile%, General, TempDir, %A_ScriptDir%
  Transform TempDir, Deref, %TempDir%
  If( !IsDir( TempDir ) ) 
    TempDir := A_ScriptDir
    
  ; Menus
  Menu RefreshInterval, Add, Off, ChangeInterval
  Menu RefreshInterval, Add
  Loop Parse, IntervalString, `,
    Menu RefreshInterval, Add, %A_LoopField% Minutes  , ChangeInterval
    
  Menu CurrentImageMenu, Add, Open, OpenImage
  Menu CurrentImageMenu, Add, Edit, EditImage
  Menu CurrentImageMenu, Add, Properties, PropertiesImage

  Menu Tray, NoStandard
  Menu Tray, Add, Next Wallpaper`tWin+F5, ChangeNowForce
  Menu Tray, Add, Previous Wallpaper`tWin+Shift+F5, ChangeNowForce2
  Menu Tray, Add
  Menu Tray, Add, Current Image, :CurrentImageMenu
  Menu Tray, Add
  Menu Tray, Add, Refresh Interval, :RefreshInterval
  
  If( Interval > 0 ) {
    Menu RefreshInterval, Add, %Interval% Minutes, ChangeInterval
    Menu RefreshInterval, Check, %Interval% Minutes 
  }
  Else
    Menu RefreshInterval, Check, Off
  
  Menu Tray, Add, Pause, SuspendToggle
  If( Suspended )
    Menu Tray, Check, Pause
    
  Interval := Interval * MSEC_PER_MIN
  
  Menu Tray, Add
  Menu Tray, Add, Select Image Folder..., SelectFolder
  Menu Tray, Add
  Menu Tray, Add, Run %NameString% on Startup, ToggleStartup
  Menu Tray, Add
  Menu Tray, Add, Visit Sector-Seven, VisitHomepage
  Menu Tray, Add, About %NameString%..., About
  Menu Tray, Add, Exit %NameString%, Exit
  
  Menu Tray, Default, Next Wallpaper`tWin+F5
  
  IfExist W.ico
    Menu, Tray, Icon, W.ico
    
  Menu, Tray, Tip, %NameString% %VersionString% - Loading...
  
  Gosub CheckStartupState
Return


Main:
  If( ImageDir = "" or Not FileExist( ImageDir ) ) {
    Gosub SelectFolder  
    IniRead ImageDir, %IniFile%, General, ImageDir
    If( ImageDir = "" or Not FileExist( ImageDir ) )
      ExitApp
  }
  Else {
    If( ShowTraytip ) {
      IniWrite 0, %IniFile%, General, ShowTraytip
      Traytip %NameString% %VersionString%, Right click here for help and options, 20, 1      
    }
    Gosub ChangeNowForce
  }
Return

;-------------------------------------------------------------------------------
; PRIMARY EVENTS
;-------------------------------------------------------------------------------
SuspendToggle:
  If( Suspended ) {
    Gosub ChangeNowForce
    Menu, Tray, Uncheck, Pause
    Suspended := false
  }
  Else {
    SetTimer ChangeNow, Off
    Menu, Tray, Check, Pause
    Suspended := true
  }
  IniWrite %Suspended%, %IniFile%, General, Paused
Return


SetNewInterval:
  If( Not InTheMiddle ) {
    SetTimer SetNewInterval, Off
    If( Interval > 0 ) {
      If ( Not Suspended )
        SetTimer ChangeNow, %Interval%
    }
    Else
      SetTimer ChangeNow, Off     
    
  }
  Else
    SetTimer SetNewInterval, -1000
Return

ChangeNowForce:
  If( Not InTheMiddle ) {
    ChangeNow( 1 )
    If( Interval > 0 ) and ( Not Suspended )
      SetTimer ChangeNow, %Interval%
  }
Return

ChangeNowForce2:
  If( Not InTheMiddle ) {
    ChangeNow( -1 )
    If( Interval > 0 ) and ( Not Suspended )
      SetTimer ChangeNow, %Interval%
  }
Return

ChangeNow:
  ChangeNow( 1 )
Return


ChangeNow( direction ) {
  Global
  InTheMiddle := true
  MenuItems := "Next Wallpaper`tWin+F5,Previous Wallpaper`tWin+Shift+F5,Refresh Interval,Pause,About " . NameString . "...,Select Image Folder...,Run " . NameString . " on Startup"
  If( FirstRun ) {
    Menu Tray, Disable, Current Image
    Loop Parse, MenuItems, `,
      Menu Tray, Disable, %A_LoopField%

    Gosub ScanFiles

    Loop Parse, MenuItems, `,
      Menu Tray, Enable, %A_LoopField%

    Random SelectedImageIndex , 1, %Counter%
  }
  Else {
    SelectedImageIndex += direction
    If( SelectedImageIndex > Counter )
      SelectedImageIndex := 1
    
    If( SelectedImageIndex < 1 )
      SelectedImageIndex := Counter
  }
  
  SelectedImage := ImageDir . "\" . Image%SelectedImageIndex%  
  
  StringRight Extension, SelectedImage, 3
  NewImage = %TempDir%\Wallpaper.%Extension%
  FileCopy %SelectedImage%, %NewImage%, 1
  
  If( Extension <> "bmp" ) {
    If( !FileExist( "topng.exe" ) )
      Error( "Unable to find a required file: topng.exe`nAborting" )
    RunWait topng.exe "%NewImage%" BMP,%TempDir%,Hide 
    FileDelete %NewImage%
    StringReplace NewImage, NewImage, .jpg, .bmp
    StringReplace NewImage, NewImage, .png, .bmp
    StringReplace NewImage, NewImage, .gif, .bmp
  }
  
  FileMove %NewImage%, %TempDir%\Wallpaper.bmp, 1
  Sleep 100
  
  FinalPaper := TempDir . "\Wallpaper.BMP"
  DllCall( "SystemParametersInfo", UInt, 0x14, UInt, 0, Str, FinalPaper, UInt, 1 )
  Menu Tray, Enable, Current Image
  
  SplitPath, SelectedImage, SelFn, SelDir
  SplitPath, SelDir, SelDir
  Menu, Tray, Tip, %NameString% %VersionString% - %Counter% Wallpapers Loaded`nCurrently showing:`n%SelDir% -> %SelFn%
  
  InTheMiddle := false
}

ScanFiles:
	Loading := true
  ImageDirLn := StrLen(ImageDir)+2
  Random Seed, 0, 10000000
  Random ,,%Seed%
  
  Loop %ImageDir%\*.*,0,1
  {
    SplitPath A_LoopFileLongPath,,, OutExtension
    If( OutExtension <> "bmp" and OutExtension <> "png" and OutExtension <> "jpg" and OutExtension <> "gif" )
      Continue
    Counter++

    If( Mod(Counter,100) = 0 ) 
      Menu, Tray, Tip, %NameString% %VersionString% - Loading (%Counter%)...

    Random Rnd , 1, %Counter%
    Image%Counter% := Image%Rnd%
    Image%Rnd% := SubStr(A_LoopFileLongPath, ImageDirLn)
  }
  
  Menu, Tray, Tip, %NameString% %VersionString% - %Counter% Wallpapers Loaded
  Loading := false
  FirstRun := false
Return

ChangeInterval:
  If( Interval > 0 ) {
    Interval := Interval / MSEC_PER_MIN
    Interval := RegexReplace( Interval, "0+$", "" )
    Interval := RegexReplace( Interval, "\.$", "" )
    Menu RefreshInterval, Uncheck, %Interval% Minutes
  }
  Else
    Menu RefreshInterval, Uncheck, Off
    
  If( A_ThisMenuItem <> "Off" ) {
    StringSplit WorkArray, A_ThisMenuItem, %A_Space%
    Interval := WorkArray1  
    Menu RefreshInterval, Check, %Interval% Minutes
    IniWrite %Interval%, %IniFile%, General, Interval
    Interval := Interval * MSEC_PER_MIN
  }
  Else {
    Interval := 0
    Menu RefreshInterval, Check, Off
    IniWrite %Interval%, %IniFile%, General, Interval
  }
  
  Gosub SetNewInterval
Return


;-------------------------------------------------------------------------------
; SERVICES AND SECONDARY EVENTS
;-------------------------------------------------------------------------------
Error( ErrCode ) {
  MsgBox 16,Error,An error has occured.`n%ErrCode%
  ExitApp
}

IsDir( pathstring ) {
  If( pathstring == "" )
    Return false
    
  FileGetAttrib, Attributes, %pathstring%
  Return InStr( Attributes, "D" )
}

RemoveToolTip:
  SetTimer RemoveToolTip, Off
  ToolTip
Return

RemoveTrayTip:
  SetTimer RemoveTrayTip, Off
  TrayTip
Return

About:
  If( InTheMiddle ) 
    SetTimer About, 1000
  Else {
    SetTimer About, Off
    Msgbox 64, %NameString%, %NameString% %VersionString%`t`t`n%AuthorString%`n`n%Counter% wallpapers loaded`n`nNow Showing:`n%SelectedImage%
  }
Return

OpenImage:
  Run %SelectedImage%
Return

EditImage:
  Run Edit %SelectedImage%
Return

PropertiesImage:
  Run Properties %SelectedImage%
Return

VisitHomepage:
  Run http://sector-seven.net
Return

SelectFolder:
  FileSelectFolder NewFolder,*%ImageDir%,, Select the folder containing your wallpapers.`nWallpapers can be in BMP, JPG, GIF or PNG format.`n(You can always change this later).
  If( Not ErrorLevel and NewFolder <> "" ) {
    IniWrite %NewFolder%, %IniFile%, General, ImageDir
    IniWrite 1, %IniFile%, General, ShowTraytip
    
    Reload
    Sleep 1000
  }
Return

CheckStartupState:
  If( FileExist( ShortcutFile ) )
    Menu Tray, Check, Run %Namestring% on Startup
  Else
    Menu Tray, Uncheck, Run %Namestring% on Startup
Return

ToggleStartup:
  If( FileExist( ShortcutFile ) )
    FileDelete %ShortcutFile%
  Else
    FileCreateShortcut %A_ScriptFullPath%, %ShortcutFile%
    
  Gosub CheckStartupState
Return

Exit:
  If( InTheMiddle and !Loading ) 
    SetTimer Exit, -1000
  Else
    ExitApp
Return

;-------------------------------------------------------------------------------
; Hotkeys
;-------------------------------------------------------------------------------
#F5::
  Gosub ChangeNowForce
Return

+#F5::
  Gosub ChangeNowForce2
Return