/*
	Numbers Base Converter
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
#Persistent						;Keep running until the user asks to exit.
#NoTrayIcon						;Ensures that no icon is visible at the start.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1
SendMode, Input

;########################################################## Create GUI
Gui, Font, s18, Verdana
Gui, Add, Text, x77 y10 w300 h30, Quick Convert
Gui, Font

Gui, Add, Text, x6 		y+22 	w70 	h20	Section, Binary
Gui, Add, Edit, x+15 	yp-3 	w220 	hp	vBinary gConvert, 
Gui, Add, Text, xs 		y+10 	w70 	hp, Decimal
Gui, Add, Edit, x+15 	yp-3 	w220 	hp	vDecimal gConvert, 
Gui, Add, Text, xs 		y+10 	w70 	hp, HexaDecimal
Gui, Add, Edit, x+15 	yp-3 	w220 	hp	vHexaDecimal gConvert, 

Gui, Show, Center h140 w317, Quick Convert

GuiControl, Focus, Decimal

Return	 ;End of Auto Execute Section
;############################################################## Labels

Convert:
	Gui, Submit, NoHide
	
	If (A_GuiControl = "Binary")
	{
		GuiControl, , Decimal, % toDec(Binary)
		GuiControl, , HexaDecimal, % toHex(toDec(Binary))	
		Send {end}
	}
	Else If (A_GuiControl = "Decimal")
	{
		GuiControl, , Binary, % toBin(Decimal)
		GuiControl, , HexaDecimal, % toHex(Decimal)
		Send {end}
	}
	Else If (A_GuiControl = "HexaDecimal")
	{
		GuiControl, , Binary, % toBin(HexaDecimal + 0)
		GuiControl, , Decimal, % HexaDecimal + 0
		Send {end}
	}
	; SetFormat, IntegerFast, d
Return

;########################################################### Functions

toBin(dec)
{
	While dec
	r:=1&dec r,dec>>=1
	Return r
}

toDec(bin)
{
	b:=StrLen(bin),r:=0
	Loop,Parse,bin
	r|=A_LoopField<<--b
	Return r
}

toHex(dec)
{
	SetFormat, IntegerFast, hex
	he := dec + 0,	he .= ""
	Return he
}

GuiClose:
ExitApp
