;[color=darkred]; Video Properties - MediaInfo.dll / 'StExBar Extension Script' - By SKAN, LM:25-Dec-2010[/color]
; Topic: www.autohotkey.com/forum/viewtopic.php?t=66500

#NoTrayIcon
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
DllCall( "LoadLibrary", Str,"MediaInfo.Dll" )
FileGetVersion, Ver, MediaInfo.Dll
Menu, Tray, Icon, User32.dll, 2

Gui +LastFound -Caption +Border
Gui1 := WinExist(), BGT := "BackgroundTrans"
Gui, Color, E2E2E2
Gui, Margin, 0, 10

Gui, Add, Text, x-1 y-1 w481 h61 0xE hwndGrad1 +Border gUIMove
ApplyGradient( Grad1, 0x6A6A6A, 0x000000, 1 )

Gui, Font, S10, Tahoma
Gui, Add,  Text, x15 y10 w55 h20 0x200 cCFCFCF %BGT%, Folder`t:
Gui, Add,  Text, x15 y+0 w55 h20 0x200 cCFCFCF %BGT%, Video`t:
Gui, Font, S9
Gui, Add,  Text, x80 y10 h20 w390 0x200 cEFEFEF vFolder %BGT%
Gui, Font, S11 Bold
Gui, Add,  Text, x80 y+0 h20 w390 0x200 cFFFFEF vVideo %BGT%
Gui, Font, s10 Normal


Gui, Add, Text, x30 y90 w430 h87 0xE hwndGrad2
ApplyGradient( Grad2, 0x666666, 0xCCCCCC, 0 )
Gui, Add, Text, x20 y80 w435 h20 0xE hwndGrad3
ApplyGradient( Grad3, 0x000000, 0x707070, 1 )

Gui, Add, Text, x25 y80 w90 h20 cCFCFCF 0x200 %BGT%, Video Format :
Gui, Add, Text, x+0 w340 hp 0x200 cFFFF80 %BGT% vVINF
Gui, Add, Text, x20 y+0 w145 h70 0x1000 Center, WxH / Aspect Ratio
Gui, Add, Text, x+0 wp hp 0x1000 Center, FrameRate / BitRate
Gui, Add, Text, x+0 wp hp 0x1000 Center, Duration / Size
Gui, Font, S11 Bold
Gui, Add, Text, x29 yp+20 w127 h25  0x201 vWxH          ; Width x Height
Gui, Add, Text, x+18 w127 hp 0x201 vFPS                 ; FPS
Gui, Add, Text, x+18 w127 hp 0x201 vDur                 ; Duration
Gui, Font, S10
Gui, Add, Text, x29 y+0 w127 h20 0x201 vDAR             ; Display Aspect Ratio
Gui, Add, Text, x+18 w127 hp 0x201 vVBit                ; Video BitRate
Gui, Add, Text, x+18 w127 hp 0x201 vVSSZ                ; Video Stream Size
Gui, Font, S10 Normal


Gui, Add, Text, x30 y207 w430 h87 0xE hwndGrad4
ApplyGradient( Grad4, 0x666666, 0xCCCCCC, 0 )
Gui, Add, Text, x20 y197 w435 h20 0xE hwndGrad5
ApplyGradient( Grad5, 0x000000, 0x707070, 1 )

Gui, Add, Text, x25 y197 w90 h20 cCFCFCF 0x200 %BGT%, Audio Format :
Gui, Add, Text, x+0 w340 hp 0x200 cFFFF80 %BGT% vAINF
Gui, Add, Text, x20 y+0 w145 h70 0x1000 Center, Sampling / Channels
Gui, Add, Text, x+0 wp hp 0x1000 Center, Bitrate Mode / Bitrate
Gui, Add, Text, x+0 wp hp 0x1000 Center, Duration / Size
Gui, Font, S11 Bold
Gui, Add, Text, x29 yp+20 w127 h25  0x201 vSRAT         ; Sampling Rate
Gui, Add, Text, x+18 w127 hp 0x201 vBRM                 ; BitRate Mode
Gui, Add, Text, x+18 w127 hp 0x201 vLen                 ; Duration
Gui, Font, S10
Gui, Add, Text, x29 y+0 w127 h20 0x201 vNCH             ; No of Channels
Gui, Add, Text, x+18 w127 hp 0x201 vABit                ; Audio BitRate
Gui, Add, Text, x+18 w127 hp 0x201 vASSZ                ; Audio Stream Size

Gui, Font
Gui, Add, Button, x375 w75 h25 y+23 Default gGuiEscape, &Close
Gui, Add, Button, xp-110 w100 hp gGSPOT, Open in &GSpot
Gui, Font, S11
Gui, Add, Text, x30 yp hp 0x200 c1B3A54 gSourceForge, http://mediainfo.sourceforge.net/en
Gui, Show, w475, Video Properties [ MediaInfo.Dll v%Ver% ]
WinWaitActive, ahk_id %Gui1%
File1=%1%

EvalProperties:
 If ! FileExist( File1 ) || InStr( FileExist( File1 ), "D" )
   Return
 Loop, %File1%
   File1 := A_LoopFileLongPath
 SplitPath, File1, Video, OutDir
 SplitPath, OutDir, Folder
 GuiControl,, Folder, %OutDir%
 GuiControl,, Video, %Video%
 hnd := MediaInfo_New()
 MediaInfo_Open( hnd, File1 )
 
 If ( MediaInfo_Get( hnd, 1,0, "StreamKind", 1 ) <> "Video" )
    GoTo, EndEvalProperties

 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - Video Information
 GuiControl,, VINF,% MediaInfo_Get( hnd, 1,0, "Codec/String",  1 ) " "
 GuiControl,, WxH, % MediaInfo_Get( hnd, 1,0, "Width", 1  ) " x "
                   . MediaInfo_Get( hnd, 1,0, "Height", 1 )
 GuiControl,, FPS, % MediaInfo_Get( hnd, 1,0, "FrameRate/String", 1 )
 GuiControl,, Dur, % MediaInfo_Get( hnd, 1,0, "Duration/String3", 1 )
 GuiControl,, DAR, % MediaInfo_Get( hnd, 1,0, "DisplayAspectRatio/String", 1 )
 GuiControl,, VBIT,% MediaInfo_Get( hnd, 1,0, "BitRate/String", 1 )
 GuiControl,, VSSZ,% MediaInfo_Get( hnd, 1,0, "StreamSize/String", 1 )

 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - Audio Information
 GuiControl,, AINF,% MediaInfo_Get( hnd, 2,0, "Codec/String", 1 )
 GuiControl,, SRAT,% MediaInfo_Get( hnd, 2,0, "SamplingRate/String", 1 )
 GuiControl,, BRM, % MediaInfo_Get( hnd, 2,0, "BitRate_Mode", 1 )
 GuiControl,, LEN, % MediaInfo_Get( hnd, 2,0, "Duration/String3", 1 )
 GuiControl,, NCH, % MediaInfo_Get( hnd, 2,0, "Channel(s)/String", 1 )
 GuiControl,, ABIT,% MediaInfo_Get( hnd, 2,0, "BitRate/String", 1 )
 GuiControl,, ASSZ,% MediaInfo_Get( hnd, 2,0, "StreamSize/String", 1 )

EndEvalProperties:
 MediaInfo_Close( hnd )
Return                                                 ; // end of auto-execute section //


SourceForge:
 Run,http://mediainfo.sourceforge.net/en
Return

UIMove:
 SendMessage, 0xA1, 2,,, A
Return

GuiDropFiles:
 StringSplit, File, A_GuiEvent, `n
 ConVars := "VINF|WxH|FPS|DUR|DAR|VBIT|VSSZ|AINF|SRAT|BRM|LEN|NCH|ABIT|ASSZ"
 Loop, Parse, ConVars, |
   GuiControl,, %A_LoopField%
 GoTo, EvalProperties
Return

GSPOT:
 IfExist,gspot.exe, Run,GSpot.exe "%File1%"
Return

GuiEscape:
GuiClose:
 ExitApp

MediaInfo_New() {
 Return DllCall( "mediainfo\MediaInfo" ( A_IsUnicode ? "" : "A" ) "_New" )
}

MediaInfo_Open( hnd, MediaFile ) {
 Return DllCall( "mediainfo.dll\MediaInfo" ( A_IsUnicode ? "" : "A" ) "_Open", UInt,hnd
               , Str,MediaFile, UInt )
}

MediaInfo_Get( hnd, StrK=0, StrN=0, Comm="", InfK=0, Srch=0 ) {
 Return DllCall( "mediainfo.dll\MediaInfo" ( A_IsUnicode ? "" : "A" ) "_Get", UInt,hnd
               , Int,StrK, Int,StrN, Str,Comm, Int,InfK, Int,Sech, Str )
}

MediaInfo_Close( hnd ) {
 Return DllCall( "mediainfo\MediaInfo" ( A_IsUnicode ? "" : "A" ) "_Close", UInt,hnd )
}

ApplyGradient( cHwnd=0, RB=0x0, LT=0x0, Vertical=1 ) { ; LT = Left/Top,  RB = Right/Bottom
 ; By SKAN / 27-Jul-2010            www.autohotkey.com/forum/viewtopic.php?p=372006#372006
 HotkeyIt := 6                    ; Credit:   Undocumented constant discovered by HotkeyIt
                                  ; www.autohotkey.com/forum/viewtopic.php?p=229361#229361
 VarSetCapacity( BMP,70,0 ),  NumPut( 0x10, NumPut( 0x180001, NumPut( 0x0200000002
 , NumPut( 0x2800000036, NumPut( 0x464D42, BMP ) + 6, 0, "Int64" ), 0, "Int64" ) ) + 4 )
 P := ( Vertical<>0 ) ?  NumPut( 0x14, NumPut( LT, NumPut( LT, NumPut( 0x14, NumPut( RB
 , NumPut( RB,BMP,54 )-1 )-1, 0, "UShort" ) )-1)-1, 0, "UShort" ) : NumPut( RB, NumPut( LT
 , NumPut( RB, NumPut( LT, BMP, 54 )-1 ) +1 ) -1 )
 TBM := DllCall( "CreateDIBitmap", UInt,hDC := DllCall("GetDC", UInt,cHwnd ), UInt,&BMP+14
                , UInt,HotkeyIt, UInt, &BMP+NumGet(BMP,10), UInt,&BMP+14, UInt,1 )
 ControlGetPos,,,W, H,, ahk_id %cHwnd%
 hBitmap := DllCall( "CopyImage", UInt,TBM, UInt,0, Int,W, Int,H, UInt,0 )
 DllCall( "SendMessage", UInt,cHwnd, UInt,0x172, UInt,0, UInt,hBitmap )
 DllCall( "DeleteObject", UInt,TBM ),  DllCall( "ReleaseDC", UInt,hDC )
Return hBitmap
}