DetectHiddenWindows, On

url:="http://www.pinellascounty.org/fbg/images/wildlife/Tree_Frog_lg.jpg"
splitpath,url,ofn
file := A_Temp "\" ofn
MsgBox, % file "`n" url
If Download( url, file ) 
 Runwait, Rundll32.exe %A_Windir%\system32\shimgvw.dll`,ImageView_Fullscreen %file%

Return


Download( url, file ) {
  static _init
  global _cu
  Splitpath,file, _dFile
  if ! init
{ RegRead,SysNot,HKCU,AppEvents\Schemes\Apps\.Default\SystemNotification\.Current 
  Transform, SysNot, deref, %sysnot% 
  SysGet, m, MonitorWorkArea, 1
  y:=(mBottom-52-2),x:=(mRight-330-2),init:=1,VarSetCapacity(vt,4*11),nPar:="31132253353"
  Loop, Parse, nPar
     NumPut(RegisterCallback("DL_Progress","Fast",A_LoopField,A_Index-1),vt,4*(A_Index-1))
} VarSetCapacity(_cu,255),DllCall("shlwapi\PathCompactPathExA",Str,_cu,Str,url,UInt,50) 
  Progress,Hide CWFAFAF7 CT000020 CB445566 x%x% y%y% w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11,,%_cu%,AutoHotkeyProgress,Tahoma
  WinSet,Transparent,180,AutoHotkeyProgress
  SoundPlay, %SysNot%
  re:=DllCall("urlmon\URLDownloadToFileA", Uint,0, Str,url,Str,file,Uint,0,UintP,&vt)
  SoundPlay, %SysNot%
  Progress, Off
Return re=0 ? 1 : 0
} 
DL_Progress( pthis, nP=0, nPMax=0, nSC=0, pST=0 ) {
  global _cu
  If (A_EventInfo=6) 
{ Progress, Show
  Progress, % (P:=100*nP//nPMax),% "Downloading:     " Round(np/1024,1) " Kb / " 
            .  Round(npmax/1024) " Kb    [ " p "`% ]",%_cu%
} Return 0
}