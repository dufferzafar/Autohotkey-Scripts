; sUrl := "http://media.santabanta.com/newsite/cinemascope/feed/poonam-pandey53.jpg"
; sFile := A_ScriptDir . "\poonam.jpg"

; sUrl := "http://www.autohotkey.com/docs/commands/UrlDownloadToFile.htm"

FileCreateDir, DownIms

; loop, 9
; {
; UrlDownloadToFile, % "http://pix.freeincestsites.net/fsl/020/00" . A_Index . ".jpg",% "DownIms\" . A_Index . ".jpg"
; }

Loop, 11
{
UrlDownloadToFile, % "http://pix.freeincestsites.net/fsl/020/0" . 9 + A_Index . ".jpg",% "DownIms\" . 9 + A_Index . ".jpg"

}

MsgBox, Downloaded