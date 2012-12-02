F1::PostMessage("Slave script", 8998)   ; exits slave script

f2::
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where CommandLine like '%ahk%' ")
      MsgBox, % process.ProcessId
      ; process, close,  % process.ProcessId
Return

PostMessage(Receiver, Message) {
   oldTMM := A_TitleMatchMode, oldDHW := A_DetectHiddenWindows
   SetTitleMatchMode, 3
   DetectHiddenWindows, on
   PostMessage, 0x1001,%Message%,,, %Receiver% ahk_class AutoHotkeyGUI
   SetTitleMatchMode, %oldTMM%
   DetectHiddenWindows, %oldDHW%
}
