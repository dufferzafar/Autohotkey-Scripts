WM_KEYDOWN = 0x100
GoSub, GetHTML

OnMessage(WM_KEYDOWN, "WM_KeyDown")
Gui Add, ActiveX, w350 h300 x0 y0 vdoc, HTMLFile
doc.write(html)
Gui, Show, w310 h265 Center, HTML Based GUI
doc.all.type.focus
ComObjConnect(doc, "Doc_")
return

Doc_OnClick(doc) {
	id := doc.parentWindow.event.srcElement.id
	if (id = "myDocuments")
		Run %A_MyDocuments%
	else if (id = "AHKLogo") {
		doc.body.innerHTML := "<img src='http://www.autohotkey.com/docs/images/"
			.   "AutoHotkey_logo_no_text.gif' alt=""Don't worry - It'll change back!""/>"
		SetTimer, ResetHTML, -3000
	}
	else if (id = "bgcolor")
		doc.body.style.background := (doc.all.bgcolor.value)
	else if (id="show" || id="hide") {
		Gui % (id="show"? "+":"-") "Caption"
		Gui Show
	}
}
WM_KEYDOWN(wParam, lParam, nMsg, hWnd) {
	global doc
	static fields := "hWnd,nMsg,wParam,lParam,A_EventInfo,A_GuiX,A_GuiY"
	WinGetClass, ClassName, ahk_id %hWnd%
	if (ClassName = "Internet Explorer_Server") {	
		; http://www.autohotkey.com/community/viewtopic.php?p=562260#p562260
		pipa := ComObjQuery(doc, "{00000117-0000-0000-C000-000000000046}")
		VarSetCapacity(kMsg, 48)
		Loop Parse, fields, `,
			NumPut(%A_LoopField%, kMsg, (A_Index-1)*A_PtrSize)
		; Loop 2 ; only necessary for Shell.Explorer Object
			r := DllCall(NumGet(NumGet(1*pipa)+5*A_PtrSize), "ptr",pipa, "ptr",&kMsg)
		; until wParam != 9 || doc.activeElement != ""
		ObjRelease(pipa)
		SetTimer, KeyPress, -10
		if r = 0 ; S_OK: the message was translated to an accelerator.
			return 0
	}
}
GuiClose:
{
   doc := ""
   Gui, Destroy
   ObjRelease(pipa)
   ExitApp
}
KeyPress: ; allows keypress to update value first
{
   if (doc.ActiveElement.id ~= "type|mirror")
      doc.all.mirror.value := (doc.all.type.value "")
   return
}
ResetHTML:
{
   doc.body.innerHTML := html
   return
}
GetHTML:
{
   html =
   (
      <html>
         <body style='background-color:PowderBlue;overflow:auto'>
            <center><H3><b>HTML GUI Test</b></H3></center>
            <form>
               Type : <input type='text' name='type' id='type'/></br>
               Mirror : <input onclick="javascript:alert('This is a Mirror!');document.all.type.focus()" type='text' name='mirror' id='mirror'/>
            </form>
            <button type='button' id='myDocuments'>My Documents</button>
            <button type='button' id='AHKLogo'>Show AHK Logo</button>
            </br></br>
            Background Color: <select id='bgcolor'>
               <option value='PowderBlue'>PowderBlue</option>
               <option value='Red'>Red</option>
               <option value='White'>White</option>
               <option value='Yellow'>Yellow</option>
            </select>
            <form>
               <b>Border: </b>
               <input type='radio' name='show/hide' id='show' /><label>Show</label>
               <input type='radio' name='show/hide' id='hide' /><label>Hide</label>
            </form>
         </body>
      </html>
   )
   return
}