/*

	Find Dupes v0.3 B

*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make Single instance application.

SetBatchLines -1

;######################################################
					;Settings
;######################################################

;DriveGet, Drives, List, FIXED
;Root = G

Gui +Resize
Gui, Font, S9, Arial
Gui, Add, ListView, x5 y6 w640 h480 +0x4 +LV0x1 +LV0x100 vMyListView, Filename|Path|Size|MD5
Gui, Add, StatusBar

;Index Files
	;Loop, PARSE, Drives
	Loop, G:\Songs\*.mp3 , 0 ,1
	{
		MD := MD5_File(A_LoopFileLongPath)
		LV_ADD( "", A_LoopFileName, A_LoopFileDir, A_LoopFileSize, MD)
	}
LV_ModifyCol(1)
LV_ModifyCol(2)
LV_ModifyCol(3,"50 Integer" )

Gui, Show,, % "MP3 Files  [ Total: " LV_GetCount() " ]"

Return	 ;End of Auto Execute Section
;_____________________________________________

;######################################################
					;Labels
;######################################################

GuiSize:
	if A_EventInfo = 1
		return
	GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 11) . " H" . (A_GuiHeight - 34)
return

GuiClose:
ExitApp

;######################################################
					;Functions
;######################################################

MD5_File( sFile="", cSz=4 ) {
 cSz  := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 )
 hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,1,Int,0,Int,3,Int,0,Int,0 )
 IfLess,hFil,1, Return,hFil
 DllCall( "GetFileSizeEx", UInt,hFil, Str,Buffer ),   fSz := NumGet( Buffer,0,"Int64" )
 VarSetCapacity( MD5_CTX,104,0 ),    DllCall( "advapi32\MD5Init", Str,MD5_CTX )
 Loop % ( fSz//cSz+!!Mod(fSz,cSz) )
   DllCall( "ReadFile", UInt,hFil, Str,Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
 , DllCall( "advapi32\MD5Update", Str,MD5_CTX, Str,Buffer, UInt,bytesRead )
 DllCall( "advapi32\MD5Final", Str,MD5_CTX ), DllCall( "CloseHandle", UInt,hFil )
 Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
Return MD5
}
