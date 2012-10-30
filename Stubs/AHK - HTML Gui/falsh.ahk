#NoEnv
SendMode Input
SetWorkingDir, %A_ScriptDir%

Gui, +LastFound +Resize
guihWnd := WinExist()

; You can change this
width := 640, height := 390

hwndFlash := Atl_AxCreateContainer(guihWnd, 0, 0, width, height, "ShockwaveFlash.ShockwaveFlash")
oFlash := Atl_AxGetControl(hwndFlash)

params := { Movie: "insert here movie param"
, AllowFullScreen: "true"
, AllowScriptAccess: "always" }

if !COM_ExposeProps(oFlash, params)
{
   MsgBox, Error! %A_LastError% %ErrorLevel%
   ExitApp
}

Gui, Show, w%width% h%height%, Embedded flash!
return

GuiClose:
ExitApp

GuiSize:
WinMove, ahk_id %hwndFlash%,, 0, 0, %A_GuiWidth%, %A_GuiHeight%
return

COM_ExposeProps(obj, props)
{
   static _vt := __CEP_vt()
   rc := false, hr := 0, pPropBag := 0
   if pPPropBag := ComObjQuery(obj, "{37D84F60-42CB-11CE-8135-00AA004BB851}") ; IID_IPersistPropertyBag
   {
      rc := true
      
      if (hr := DllCall(_vtable(pPPropBag, 4), "ptr", pPPropBag)) < 0 ; pPPropBag->InitNew()
         goto __CEP_error
      
      pPropBag := _mem(2*A_PtrSize)
      if !pPropBag
         goto __CEP_error
      
      NumPut(_vt, pPropBag+0),NumPut(&props, pPropBag+A_PtrSize)
      
      if (hr := DllCall(_vtable(pPPropBag, 5), "ptr", pPPropBag, "ptr", pPropBag, "ptr", 0)) < 0 ; pPPropBag->Load(pPropBag, NULL)
         goto __CEP_error
      
      goto __CEP_cleanup
__CEP_error:
      `(pPropBag) ? _free(pPropBag) : ""
      DllCall("SetLastError", "uint", hr)
      rc := false
__CEP_cleanup:
      ObjRelease(pPPropBag)
   }
   return rc
}

__CEP_vt()
{
   vt := _mem(5*A_PtrSize)
   if !vt
   {
      MsgBox, 16,, Memory trouble!
      ExitApp
   }
   prm = 41143
   Loop, Parse, prm
      NumPut(RegisterCallback("__CEP_PropBag","F",A_LoopField,A_Index),vt+(A_Index-1)*A_PtrSize)
   return vt
}

__CEP_PropBag(pThis, a, b, c)
{
   this := Object(NumGet(pThis+A_PtrSize))
   if A_EventInfo between 2 and 3 ; AddRef() and Release()
      return 1
   else if (A_EventInfo = 1) || (A_EventInfo = 5) ; QueryInterface() and Write()
   {
      MsgBox, Trouble! %A_EventInfo%
      return -1
   }
   
   if !this._HasKey(key := StrGet(a, "UTF-16"))
      return 0x80070057 ; E_INVALIDARG
   else
   {
      btyp := NumGet(b+0, "UShort")
      var := ComVar(), var[] := this[key], pVar := ComObjValue(var.ref), vartyp := NumGet(pVar+0, "UShort")
      if btyp && (btyp != vartyp)
         if DllCall("oleaut32\VariantChangeType", "ptr", pVar, "ptr", pVar, "ushort", 0, "ushort", btyp) < 0
            return 0x80004005 ; E_FAIL
      DllCall("oleaut32\VariantCopy", "ptr", b, "ptr", pVar)
      return 0
   }
}

_mem(size)
{
   return DllCall("GlobalAlloc", "uint", 0, "ptr", size, "ptr")
}

_free(ptr)
{
   DllCall("GlobalFree", "ptr", ptr)
}

_vtable(ptr, n)
{
   ; NumGet(ptr+0) returns the address of the object's virtual function
   ; table (vtable for short). The remainder of the expression retrieves
   ; the address of the nth function's address from the vtable.
   return NumGet(NumGet(ptr+0), n*A_PtrSize)
}

; The following was copied from the AHK_L helpfile, all credit goes to Lexikos.

; ComVar: Creates an object which can be used to pass a value ByRef.
;   ComVar[] retrieves the value.
;   ComVar[] := Val sets the value.
;   ComVar.ref retrieves a ByRef object for passing to a COM function.
ComVar(Type=0xC)
{
    static base := { __Get: "ComVarGet", __Set: "ComVarSet", __Delete: "ComVarDel" }
    ; Create an array of 1 VARIANT.  This method allows built-in code to take
    ; care of all conversions between VARIANT and AutoHotkey internal types.
    arr := ComObjArray(Type, 1)
    ; Lock the array and retrieve a pointer to the VARIANT.
    DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue(arr), "ptr*", arr_data)
    ; Store the array and an object which can be used to pass the VARIANT ByRef.
    return { ref: ComObjParameter(0x4000|Type, arr_data), _: arr, base: base }
}
ComVarGet(cv, p*) { ; Called when script accesses an unknown field.
    if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]
        return cv._[0]
}
ComVarSet(cv, v, p*) { ; Called when script sets an unknown field.
    if p.MaxIndex() = "" ; No name/parameters, i.e. cv[]:=v
        return cv._[0] := v
}
ComVarDel(cv) { ; Called when the object is being freed.
    ; This must be done to allow the internal array to be freed.
    DllCall("oleaut32\SafeArrayUnaccessData", "ptr", ComObjValue(cv._))
}