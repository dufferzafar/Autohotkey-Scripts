html = 
(
<html>
<style>
span.FakeLink{color:blue; text-decoration:underline; cursor:pointer;}
span.Red{color:red; font-weight:bold;}
span.Green{color:green; font-weight:bold;}
body{margin:4px; font-family:Arial, Helvetica, sans-serif; font-size:12; overflow:visible; background-color:#ffffcc; text-align:justify}
</style>

<body>
<p>By using <i>Html</i> and <i>ActiveX</i>, you can easily mimic <i>SysLink</i> controls. Use <i>fake links</i> to execute AHK code; <span id="FakeLink1" class="FakeLink">fake link 1</span> or <span id="FakeLink2" class="FakeLink">fake link 2</span>. Launch <i>URLs</i>; visit <a href="http://www.autohotkey.com/forum/">AutoHotkey forum</a> and <a href="http://www.autohotkey.com/docs/Tutorial.htm">quick-start tutorial</a>.  And of course, format your text; <b>bold</b>, <i>italic</i>, <span class="Red"> red</span>, <span class="Green"> green</span>, etc.</p>
</body>
</html>
)

Gui, Add, ActiveX,  x2 y2 w400 h80 voHtml, HtmlFile
oHtml.write(html)
ComObjConnect(oHtml, "oHtml_")
Gui, Show, w404 h84, [idea] SysLink via Html 
Return

GuiClose:
ExitApp

oHtml_OnClick(oHtml) {
   id := oHtml.parentWindow.event.srcElement.id
   if id contains FakeLink
      MsgBox,,, You clicked on: %id%, 1   ; put your action here
}