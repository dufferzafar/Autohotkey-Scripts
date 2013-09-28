;----------------------------------------------------------
;----------------------------------------------------------
; WinTraymin.ahk
; by Sean
;----------------------------------------------------------
;----------------------------------------------------------
; Adding a trayminned trayicon of hWnd:	WinTraymin(hWnd,0), where 0 can be omitted.
; Removing all trayminned trayicons:	WinTraymin(0,-1).
; Other values than 0 & -1 are reserved for internal use.
;----------------------------------------------------------

;#NoTrayIcon
TrayminOpen:
SetWinDelay, 0
SetFormat, Integer, D
CoordMode, Mouse, Screen
DetectHiddenWindows On
OnExit, TrayminClose
Return
TrayminClose:
WinTraymin(0,-1)
OnExit
ExitApp

RButton Up::
If	h:=WM_NCHITTEST()
	WinTraymin(h)
Else	Click, % SubStr(A_ThisHotkey,1,1)	; for hotkey: LButton/MButton/RButton
Return

WM_NCHITTEST()
{
	MouseGetPos, x, y, z
	SendMessage, 0x84, 0, (x&0xFFFF)|(y&0xFFFF)<<16,, ahk_id %z%
	Return	ErrorLevel=8 ? z : ""
}

WM_SHELLHOOKMESSAGE(wParam, lParam, nMsg)
{
	Critical
	If	nMsg=1028
	{
		If	wParam=1028
			Return
		Else If	(lParam=0x201||lParam=0x205||lParam=0x207)
			WinTraymin(wParam,3)
	}
	Else If	(wParam=1||wParam=2)
		WinTraymin(lParam,wParam)
	Return	0
}

WinTraymin(hWnd = "", nFlags = "")
{
	Static
	If Not	hAHK&&hAHK:=WinExist("ahk_class AutoHotkey ahk_pid " DllCall("GetCurrentProcessId"))
		ShellHook:=DllCall("RegisterWindowMessage","Str","SHELLHOOK"), nIcons:=0
	,	DllCall("RegisterShellHookWindow","Uint",hAHK)
	,	OnMessage(nMsg:=1028,"WM_SHELLHOOKMESSAGE")
	If Not	nFlags
	{
		If Not	((hWnd+=0)||hWnd:=DllCall("GetForegroundWindow"))||((h:=DllCall("GetWindow","Uint",hWnd,"Uint",4))&&DllCall("IsWindowVisible","Uint",h)&&!hWnd:=h)||!(VarSetCapacity(sClass,32),DllCall("GetClassName","Uint",hWnd,"Str",sClass,"Uint",VarSetCapacity(sClass)//2))||sClass=="Shell_TrayWnd"||sClass=="Progman"
		Return
		OnMessage(ShellHook,"")
		WinMinimize,	ahk_id %hWnd%
		WinHide,	ahk_id %hWnd%
		Sleep,	100
		OnMessage(ShellHook,"WM_SHELLHOOKMESSAGE")
		uID:=uID_%hWnd%, uID ? "" : (uID_%hWnd%:=uID:=++nIcons=nMsg ? ++nIcons : nIcons)
		SendMessage, 0x7F, 2, 0,, ahk_id %hWnd%
		If Not	hIcon:=ErrorLevel
			hIcon:=DllCall("GetClassLong","Uint",hWnd,"Int",-34)
		DllCall("GetWindowTextA","Uint",hWnd,"Uint",NumPut(hIcon,NumPut(nMsg,NumPut(1|2|4,NumPut(uID,NumPut(hAHK,NumPut(VarSetCapacity(ni,152),ni)))))),"int",128)
		Return	hWnd_%uID%:=DllCall("shell32\Shell_NotifyIcon","Uint",hWnd_%uID% ? 1 : 0,"Uint",&ni) ? hWnd : DllCall("ShowWindow","Uint",hWnd,"int",5)*0, DllCall("DestroyIcon","Uint",hIcon)
	}
	Else If	nFlags > 0
	{
		If	(nFlags=3&&uID:=hWnd)
			If	WinExist("ahk_id " . hWnd:=hWnd_%uID%)
			{
				WinShow,	ahk_id %hWnd%
				WinRestore,	ahk_id %hWnd%
			}
			Else	nFlags:=2
		Else	uID:=uID_%hWnd%
		Return	uID&&hWnd_%uID% ? (DllCall("shell32\Shell_NotifyIcon","Uint",2,"Uint",NumPut(uID,NumPut(hAHK,NumPut(VarSetCapacity(ni,152),ni)))-12),hWnd_%uID%:="") : ""
	}
	Else
		Loop, % nIcons+0*DllCall("DeregisterShellHookWindow","Uint",hAHK)
			hWnd_%A_Index% ? (DllCall("shell32\Shell_NotifyIcon","Uint",2,"Uint",NumPut(A_Index,NumPut(hAHK,NumPut(VarSetCapacity(ni,152),ni)))-12),DllCall("ShowWindow","Uint",hWnd_%A_Index%,"int",5),hWnd_%A_Index%:="") : ""
}
