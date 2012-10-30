;DownloadAndRun.ahk
; Download a file from the internet, and run it or open it in a program.
;Skrommel @ 2006

#SingleInstance,Off
#NoEnv

applicationname=DownloadAndRun

Gosub,INIREAD

IfNotExist,%downloadpath%
  FileCreateDir,%downloadpath%
Stringsplit,part_,filename,*

URLDownloadToFile,%url%,url.txt
FileRead,file,url.txt
FileDelete,url.txt
start=1
Loop
{
  start:=InStr(file,"<a href=",0,start)+8
  If start=8
    Break
  end:=InStr(file,">",0,start)
  If end=0
    Break
  StringMid,href,file,% start,% end-start
  StringReplace,href,href,",,All

  match=0
  mid=1
  Loop,% part_0
  {
    part:=part_%A_Index%
    mid:=InStr(href,part,0,mid)
    If mid=0
      Break
    match+=1
  }
  If (match=part_0)
  {
    StringSplit,name_,href,/
    name:=name_%name_0%
    If traytip=1
      TrayTip,%applicationname%,Downloading`n%href%,3
    SetTimer,STATUS,1000
    URLDownloadToFile,%href%,%downloadpath%\%name%
    SetTimer,STATUS,Off
    If traytip=1
    {
      FileGetSize,size,%downloadpath%\%name%,K
      TrayTip,%applicationname%,Downloaded %size% KB`n%href%,3
    }
    If (InStr(action,"Run")=1)
    {    
      Menu,Tray,Tip,%applicationname%`nRunning %execute% %downloadpath%\%name%
      StringTrimLeft,execute,action,4
      execute=%execute%
      If execute=
        Run,%downloadpath%\%name%
      Else
        Run,%execute% %downloadpath%\%name%
    }
  }
}
Sleep,3000
Return


STATUS:
FileGetSize,size,%downloadpath%\%name%,K
If traytip=1
  TrayTip,%applicationname%,Downloading %size% KB`n%href%,3
Menu,Tray,Tip,%applicationname%`nDownloading %size% KB`n%href%
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  traytip=1
  url=http://www.symantec.com/avcenter/download/pages/US-SAVCE.html
  filename=http*x86.exe
  downloadpath=Download
  action=Run
  Gosub,INIWRITE
}

IniRead,traytip,%applicationname%.ini,Settings,traytip
IniRead,url,%applicationname%.ini,Settings,url
IniRead,filename,%applicationname%.ini,Settings,filename
IniRead,downloadpath,%applicationname%.ini,Settings,downloadpath
IniRead,action,%applicationname%.ini,Settings,action
Return


INIWRITE:
IniWrite,%traytip%,%applicationname%.ini,Settings,traytip
IniWrite,%url%,%applicationname%.ini,Settings,url
IniWrite,%filename%,%applicationname%.ini,Settings,filename
IniWrite,%downloadpath%,%applicationname%.ini,Settings,downloadpath
IniWrite,%action%,%applicationname%.ini,Settings,action
Return
