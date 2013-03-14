
Gui, Font, w700
Gui, Add, Radio, x40  y70, &Pictures
Gui, Add, Radio, xp yp+35, &Music
Gui, Add, Radio, xp yp+35, &Documents
Gui, Add, Radio, xp yp+35, &Video
Gui, Add, Radio, xp yp+35, &Compressed
Gui, Add, Radio, xp yp+35, &Emails
Gui, Add, Radio, xp yp+35, &Other
Gui, Font
Gui, Add, Text, x55  y85, Sort only files of common image formats`, such as digital camera photos.
Gui, Add, Text, xp yp+35, Sort only files of common audio formats`, like MP3 player files.
Gui, Add, Text, xp yp+35, Sort only files of common office document formats`, such as Word and Excel files.
Gui, Add, Text, xp yp+35, Sort only video files`, like digital camera recordings.
Gui, Add, Text, xp yp+35, Sort only compressed files.
Gui, Add, Text, xp yp+35, Sort only emails from Thunderbird`, Outlook Express and Windows Mail.
Gui, Add, Text, xp yp+35, Sort all files.

Gui, Add, Button, x247 y384 w75 h23 , < &Back
Gui, Add, Button, x322 y384 w75 h23 , &Next >
Gui, Add, Button, x407 y384 w75 h23 , Cancel

Gui, Show, x159 y103 h416 w491, Sorting Hat Wizard
Return

GuiClose:
ExitApp