#NoEnv
#Persistent

;Reverses the ClipBoard 
reversePercent = 100
OnClipboardChange: 
{ 
   IfEqual, A_EventInfo, 1 ;Checks to see if there is text on the Clipboard 
   { 
 ;     random, test, 1, 100 
 ;     IfLessOrEqual, test, reversePercent 
 ;     { 
         tempClipboard = 
         i := StrLen(Clipboard) 
         loop %i% 
         { 
            tempClipboard := tempClipboard SubStr(Clipboard, i - a_index + 1, 1) 
         } 
         Clipboard := tempClipboard 
         tempClipboard = 
 ;     } 
   } 
   return 
} 