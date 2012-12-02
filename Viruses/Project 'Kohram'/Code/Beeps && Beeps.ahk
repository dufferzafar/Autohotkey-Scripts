SetBatchLines, -1
Loop, 35
{
	DllCall( "Beep", UInt,650 + 7 * A_Index, UInt, 100 )
	Sleep, 100
}
