Gui, Add, Radio, x38 y82 w423 h16 , &I'm not sure
Gui, Add, Radio, x38 y119 w423 h16 , On my &media card or iPod
Gui, Add, Radio, x38 y156 w423 h16 , In My &Documents
Gui, Add, Radio, x38 y193 w423 h16 , In the Recycle &Bin
Gui, Add, Radio, x38 y230 w423 h16 , In a &specific location
Gui, Add, Text, x54 y135 w407 h13 , Search any removable drives (except CDs and floppies) for deleted files.
Gui, Add, Text, x54 y172 w407 h13 , Search user documents folders.
Gui, Add, Text, x54 y209 w407 h13 , Search for files deleted from the Recycle Bin.
Gui, Add, Text, x54 y98 w407 h13 , Search everywhere on this computer.
Gui, Add, Edit, x53 y250 w324 h23 , C:\
Gui, Add, Button, x384 y250 w75 h23 , B&rowse...

Gui, Add, Button, x247 y384 w75 h23 , < &Back
Gui, Add, Button, x322 y384 w75 h23 , &Next >
Gui, Add, Button, x407 y384 w75 h23 gGuiClose, Cancel

Gui, 1:Color, FFFFFF
; Generated using SmartGUI Creator 4.0
Gui, Show, x432 y139 h416 w491, New GUI Window
Return

GuiClose:
ExitApp