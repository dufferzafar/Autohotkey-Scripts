#singleinstance force
;##########################################################################
Gui Add, ActiveX, w300 h800 vIE, Shell.Explorer
IE.Navigate("http://m.facebook.com/")
Gui Show, x0 y0


Gui 2:Add, ActiveX, w1000 h100 vIE, Shell.Explorer
IE.Navigate("http://pastehtml.com/view/bkqjgzwhy.html")
Gui 2:Show, x329 y615

Gui 3:Add, ActiveX, w1000 h600 vIE, Shell.Explorer
IE.Navigate("http://www.twitter.com/")
Gui 3:Show, x325 y0
;###########################################################################

IfExist, NotFirstTime
{
Goto, NotFirstTimeLabel
}
else
{
Sleep 500
Gui 4: font, s24, Verdana  
Gui 4:Add, Text,, Press Alt + R to refresh all
Gui 4:Show

FileAppend ,01, NotFirstTime
}
NotFirstTimeLabel:

Random, rand1 , 0, 1000
rand11 = %rand1%/2

if (rand11 > 300)
{
 Goto NotFirstTimeLabel2
}
else
{
Sleep 500
Gui 4: font, s24, Verdana  
Gui 4:Add, Text,, Press Alt + R to refresh all
Gui 4:Show
}
NotFirstTimeLabel2:

Pause , On

!r:: Reload