/*
	Delete Files Smaller than a Paritcular Dimension
*/

#NoEnv  						;Recommended for performance.
#SingleInstance Force			;Make single instance application.
SetWorkingDir %A_ScriptDir%		;Ensures a consistent starting directory.

SetBatchLines, -1

;##########################################################

pToken := Gdip_Startup()

InputBox, fType, Enter Image FileType, Please enter the extension of the filetype that needs to be processed (jpg`, png`, bmp), , 280, 150

If fType in jpg,png,bmp
{
	InputBox, Width, Enter Width, , ,225, 100
	If (Width)
		InputBox, Height, Enter Height, , ,225, 100
}

If (Width) And (Height)
	Loop, %A_ScriptDir%\*.%fType%
	{
		Dimensions(A_LoopFileName, FileWidth, FileHeight)
		If (FileWidth < 1000) OR (FileHeight < 760)
			FileDelete, %A_LoopFileName%
			; FileMove, %A_LoopFileName%, E:\Wallpapers\Short\
	}

Gdip_Shutdown(pToken)

;##############################################

Dimensions(File, ByRef W, ByRef H)
{
	Bmp := Gdip_CreateBitmapFromFile(File), W := Gdip_GetImageWidth(Bmp)
	H := Gdip_GetImageHeight(Bmp), Gdip_DisposeImage(Bmp)
}