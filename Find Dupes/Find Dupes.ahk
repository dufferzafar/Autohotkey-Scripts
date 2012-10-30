Gui, Add, GroupBox, x6 y10 w460 h100 , Directory
	Gui, Add, Text, x16 y30 w440 h20 , Select the location you would like to check for duplicate files
	Gui, Add, Edit, x16 y50 w360 h20 +ReadOnly,
	Gui, Add, Button, x386 y50 w70 h20 , Browse
	
Gui, Add, GroupBox, x6 y120 w460 h130 , File Types
	Gui, Add, CheckBox, x16 y80 w170 h20 , Scan All Subfolders (Recurse)
	Gui, Add, Radio, x16 y140 w90 h20 , Scan All Files
	Gui, Add, Radio, x16 y160 w140 h20 , Scan Specific File Types
	Gui, Add, CheckBox, x36 y180 w100 h20 , Audio
	Gui, Add, CheckBox, x36 y200 w100 h20 , Images
	Gui, Add, CheckBox, x136 y180 w100 h20 , Video
	Gui, Add, CheckBox, x136 y200 w100 h20 , Documents
	Gui, Add, CheckBox, x36 y220 w100 h20 , Advanced Filter
	Gui, Add, Edit, x136 y220 w100 h20 +Disabled, *.vbs`, *.lua
	
Gui, Add, Button, x386 y260 w80 h30 , Next

Gui, Show, x131 y91 h295 w475, Amit's DFF
Return

GuiClose:
ExitApp
