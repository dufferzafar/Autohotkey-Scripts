#SingleInstance Force
#Persistent

; DllCall("WinLockDll\CtrlAltDel_Enable_Disable", Int, False)

DllCall("SystemParametersInfo", UInt, 0x24, UInt, 0, UIntP, OldState)
; DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, A_WinDir . "\winnt.bmp", UInt, 2)

Return
