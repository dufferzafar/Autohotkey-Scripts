#NoTrayIcon
;RegRead,tera_installation_location, HKEY_CURRENT_USER, Software\Code Sector\TeraCopy, InstallDir
Gui,Font, S9 CDefault, Verdana
Gui,Add, GroupBox, x6 y102 w510 h90, Output Folder Drag-n-Drop
Gui,Add, GroupBox, x6 y2 w510 h90, Input Folder Drag-n-Drop
Gui, Add, Button, x516 y22 w70 h60 , Browse Input
Gui, Font, S10 CRed Bold,
Gui, Add, Edit, x16 y22 w490 h60 vinput_folder +Center, Input Folder (Drag-n-Drop) or Browse
Gui, Font, S10 CGreen Bold,
Gui, Add, Edit, x16 y122 w490 h60 voutput_folder +Center, Output Folder (Drag-n-Drop) or Browse
Gui,Font, S9 CDefault Normal, Verdana
Gui, Add, Button, x516 y122 w70 h60 , Browse Output
Gui,Add, GroupBox, x6 y202 w150 h60 , Extention
Gui,Add, GroupBox, x166 y202 w180 h140 , Same Filenames
Gui, Add, ListBox, x176 y222 w160 h120 vmode, Renameall|Overwriteall||Skipall
Gui, Add, ListBox, x416 y212 w150 h70 vjob,Move|Copy||Delete
Gui,Add, ComboBox, x16 y222 w130 h20 vextention r5,Pdf|Movies||Photos|Zips_n_Rars|.nfo,.url,.txt|Disk_Images|
Gui, Add, Button, x396 y282 w190 h60 , Process
Gui, Show, x356 y186 h353 w598,Ekarth22's Bulk File mover Crap remover
Return
GuiClose:
ExitApp
GuiDropFiles:
Loop, parse, A_GuiEvent, `n
{
IfEqual,A_guicontrol,input_folder
{
   ControlSetText,edit1,%A_LoopField%
}
IfEqual,A_guicontrol,output_folder
   {
   ControlSetText,edit2,%A_LoopField%
   }
}
return
buttonbrowseinput:
FileSelectFolder,output1,::{20d04fe0-3aea-1069-a2d8-08002b30309d},3,Select the directory which contains your finished torrents
ControlSetText,edit1,%output1%
return
buttonbrowseoutput:
FileSelectFolder,output2,::{20d04fe0-3aea-1069-a2d8-08002b30309d},3,Select the folder where you want to Cut /Paste your files
ControlSetText,edit2,%output2%
return
Buttonprocess:
FileDelete,C:\filelist.cmd
gui,submit,nohide
if extention=Zips_n_Rars
   ext=.zip,.rar,.7zip
else if extention=Photos
   ext=.BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.TIFF,.GIF,.PNG
else if extention=Disk_Images
   ext=.ISO,.B5T,.B6T,.BWT,.CCD,.CDI,.CUE,.MDS,.MDF,.NRG,.ISZ
else if extention=Pdf
   ext=.pdf,.djvu
else if extention=Movies
   ext=.3gp,.3g2,.asf,.avi,.dat,.divx,.dsm,.evo,.flv,.m1v,.m2ts,.m2v,.m4a,.mj2,.mjpg,.mjpeg,.mkv,.mov,.moov,.mp4,.mpg,.mpeg,.mpv,.nut,.ogg,.ogm,.qt,.swf,.ts,.vob,.wmv,.xvid
else   ext=%extention%
Gosub,nextstep_readymade_list
return
nextstep_readymade_list:
Loop, Parse,ext,`,
{
   Loop,%input_folder%\*%A_LoopField%,1,1
   {
      FileAppend,%A_LoopFileFullPath%`n,C:\filelist.cmd
   }
}
Gosub final_step_tera
return
final_step_tera:
head=*C:\filelist.cmd "%output_folder%" /%mode%
tail=%A_Scriptdir%\Teracopy\TeraCopy.exe %job%
Run,%tail% %head%
return
