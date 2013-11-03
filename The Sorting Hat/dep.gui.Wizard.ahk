createWizard:
	;Basic Framework
	Gui, 1:Add, Tab, x-4 y-24 w-1 h-1 -Wrap vTabID, 1|2|3|4|5|6
	
	Gui, 1:Tab, 1		;##### Wizard Screen - 1	
	Gui, 1:Color, FFFFFF
	Gui, 1:Add, Picture, x12 y8, Data\Main.png
	Gui, 1:Font, W550 s16
	Gui, 1:Add, Text, x170 y8 w285 h50, Welcome to The Sorting Hat Wizard
	Gui, 1:Font
	Gui, 1:Font, s8, Verdana
	Gui, 1:Add, Text, x170 y87 w285 , This wizard will help you sort your files.  Just answer a few simple questions and the hat does the rest.
	Gui, 1:Add, Text, xp yp+60 wp , If you don't wat to use this wizard, simply press Cancel and you will have access to the advanced features of sorting hat.
	Gui, 1:Add, Checkbox, x12  y388, &Do not show this Wizard on startup.
	
	Gui, 1:Add, Button,   x245 yp-4 w75 Disabled, < &Back
	Gui, 1:Add, Button,   xp+75 yp wp gNext, &Next >
	Gui, 1:Add, Button,   xp+85 yp wp gGuiClose, Cancel

	Gui, 1:Tab, 2		;##### Wizard Screen - 2
	Gui, 1:Color, FFFFFF
	Gui, 1:Add, Radio, x38 y82 w423 h16 , &I'm not sure
	Gui, 1:Add, Radio, x38 y119 w423 h16 , On my &media card or iPod
	Gui, 1:Add, Radio, x38 y156 w423 h16 , In My &Documents
	Gui, 1:Add, Radio, x38 y193 w423 h16 , In the Recycle &Bin
	Gui, 1:Add, Radio, x38 y230 w423 h16 , In a &specific location
	Gui, 1:Add, Text, x54 y135 w407 h13 , Search any removable drives (except CDs and floppies) for deleted files.
	Gui, 1:Add, Text, x54 y172 w407 h13 , Search user documents folders.
	Gui, 1:Add, Text, x54 y209 w407 h13 , Search for files deleted from the Recycle Bin.
	Gui, 1:Add, Text, x54 y98 w407 h13 , Search everywhere on this computer.
	Gui, 1:Add, Edit, x53 y250 w324 h23 , C:\
	Gui, 1:Add, Button, x384 y250 w75 h23 , B&rowse...

	Gui, 1:Add, Button, x245 y384 w75 h23 gBack, < &Back
	Gui, 1:Add, Button, xp+75 yp wp hp gNext, &Next >
	Gui, 1:Add, Button, xp+85 yp wp hp gGuiClose, Cancel
	
	Gui, 1:Tab, 3		;##### Wizard Screen - 3
	Gui, 1:Add, Text, x22 y10 w100 h20 , File Location
	Gui, 1:Add, Text, x42 y30 , Where are the files?
	Gui, Add, Picture, x422 y10 w60 h60 , D:\I, Coder\My Projects\The Sorting Hat 2\Data\Main.png
	Gui, 1:Font, w700
	Gui, 1:Add, Radio, x40  y70, &Pictures
	Gui, 1:Add, Radio, xp yp+35, &Music
	Gui, 1:Add, Radio, xp yp+35, &Documents
	Gui, 1:Add, Radio, xp yp+35, &Video
	Gui, 1:Add, Radio, xp yp+35, &Compressed
	Gui, 1:Add, Radio, xp yp+35, &Emails
	Gui, 1:Add, Radio, xp yp+35, &Other
	Gui, 1:Font
	Gui, 1:Add, Text, x55  y85, Sort only files of common image formats`, such as digital camera photos.
	Gui, 1:Add, Text, xp yp+35, Sort only files of common audio formats`, like MP3 player files.
	Gui, 1:Add, Text, xp yp+35, Sort only files of common office document formats`, such as Word and Excel files.
	Gui, 1:Add, Text, xp yp+35, Sort only video files`, like digital camera recordings.
	Gui, 1:Add, Text, xp yp+35, Sort only compressed files.
	Gui, 1:Add, Text, xp yp+35, Sort only emails from Thunderbird`, Outlook Express and Windows Mail.
	Gui, 1:Add, Text, xp yp+35, Sort all files.
	
	Gui, 1:Add, Button, x245 y384 w75 h23 gBack, < &Back
	Gui, 1:Add, Button, xp+75 yp wp hp gNext, &Next >
	Gui, 1:Add, Button, xp+85 yp wp hp gGuiClose, Cancel
	
	ActiveTab := 1
	LastTab := 3
	
	Gui, Show, x432 y139 h416 w491, New GUI Window
Return 

Next:
  If( ActiveTab < LastTab ) {
    ActiveTab++
    GuiControl, Choose, TabID, %ActiveTab%
  }
Return

Back:
  If( ActiveTab > 1 ) {
    ActiveTab--
    GuiControl, Choose, TabID, %ActiveTab%
  }
Return