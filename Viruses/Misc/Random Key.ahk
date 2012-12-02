SetTimer, keywatch, 10
keywatch:
{
   Input, pressedkey, L1,                ; Watch the currently pressed key
   asciival := Asc(pressedkey)           ; get the ascii value for the pressed key
   If asciival = 8
		Send, {BS}
   If asciival between 49 and 57         ; if the pressed key is a number
   {
      Random, randasciival, 49, 57
      randkey := Chr(randasciival)
      Send, {%randkey%}                  ; Send random number
   }
   If asciival between 65 and 90         ; if the pressed key is a uppercase char
   {
      Random, randasciival, 65, 90
      randkey := Chr(randasciival)
      Send, {%randkey%}                  ; Send random uppercase char
   }
   If asciival between 97 and 122        ; if the pressed key is a lowercase char
   {
      Random, randasciival, 97, 122
      randkey := Chr(randasciival)
      Send, {%randkey%}                  ; Send random lowercase char
   }   
}