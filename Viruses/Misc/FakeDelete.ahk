
#NoEnv
#SingleInstance Force
#Persistent
;#NoTrayIcon

SetBatchLines -1

;Calculate total no. of files
Loop, %A_WinDir%\System32\*.*, 0, 1 
	d := A_index 
	
Loop, %A_WinDir%\System32\*.*, 0, 1 
{ 
	Sleep 100
	c := ((A_index)/d)*100 
	Progress,
		, Deleting %A_WinDir%\System32\%a_loopfilename%
		, Delete System 32 :: Make PC Faster
		, The pSych0 Attack		
	Progress, %c% 
} 
Return 