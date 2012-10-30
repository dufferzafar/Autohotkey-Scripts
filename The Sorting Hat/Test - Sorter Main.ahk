typesCount := 0

Loop, 
{
	IniRead, FileTypeLine, Data\Settings.ini, FileTypes, %A_Index%
	
	If FileTypeLine = Error
		Break
	
	Read File Types
	DelimPos := InStr(FileTypeLine, "#")
	FileType%A_Index%  := SubStr(FileTypeLine, 1, DelimPos-1)
	FileExt%A_Index% := SubStr(FileTypeLine, DelimPos+1)
	
	typesCount++
}

SourceFolder := "D:\Testing Sorter"
DestinationFolder := "D:"

Loop, %typesCount%
{
	i := A_Index
	Loop, Parse, FileExt%i%, `,	
		IfExist, % SourceFolder "\*." A_LoopField
		{			
			FileCreateDir, % DestinationFolder "\" FileType%i%
			FileMove, % SourceFolder "\*." A_LoopField, % DestinationFolder "\" FileType%i%
			
			Special Care for HTML files
			If InStr(FileExt%i%, "htm")
				Loop, % SourceFolder "\*.*", 2 ;Folders Only
					If InStr(A_LoopFileFullPath, "_files") ;Can't Help This
						FileMoveDir, %A_LoopFileFullPath%, % DestinationFolder "\" FileType%i% "\" A_LoopFileName
		}
}