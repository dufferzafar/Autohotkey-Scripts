Progress, m2 b fs13 zh0 WMn700, Slave script is running
Gui 99: show, hide, Slave script ; hidden "message receiver window"
OnMessage(0x1001,"ReceiveMessage")
return

ReceiveMessage(Message) {
   if Message = 8998
   ExitApp
}