#SingleInstance, Force
SetWorkingDir %A_ScriptDir%
SetFormat, Float, 6.2

DllCall( "LoadLibrary", Str,"mediainfo.Dll" )

totalDuration := 0

InputBox, fType, Enter FileType, Please enter the extension of the filetype that needs to be processed., ,279, 150

If !(fType)
	return

Loop, *.%fType%
{
	LoopFileDuration := Media_GetVideoDuration( A_LoopFileFullPath )

	totalDuration += Media_GetVideoDuration( A_LoopFileFullPath )
}

durationMins :=  totalDuration/(1000*60)
durationHours := durationMins//60

Msgbox, %  durationMins " `n " durationHours " hrs " (durationMins - 60*durationHours) " mins "

Media_GetVideoDuration( VidFil ) {
 hnd := MediaInfo_New()
 MediaInfo_Open( hnd, VidFil )
 If ( MediaInfo_Get( hnd, 1,0, "StreamKind", 1 ) <> "Video" )
  Return 0, MediaInfo_Close( hnd )
Return MediaInfo_Get( hnd, 1,0, "Duration", 1 ), MediaInfo_Close( hnd )
}

;  Video Properties - MediaInfo.Dll  www.autohotkey.com/forum/topic66500.html

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
