#include <WinAPI.au3>
#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPISysWin.au3>

$CurrentlyOver = "No"

While 1

	Sleep(250)
	RocketDock()
	TaskBar()
 
WEnd
Exit

Func RocketDock()
	Local $pos = _WinAPI_GetMousePos()
    Local $hwnd = _WinAPI_WindowFromPoint($pos)

	Local $RocketDock = "0x00010010"
	local $CurrentMouseOver = ""
	
    ; Retrieve the top-level window (remove any parent windows)
    While _WinAPI_GetParent($hwnd) <> 0
		$hwnd = _WinAPI_GetParent($hwnd)
		$CurrentMouseOver = GetClassName($hwnd)
    WEnd

	if $CurrentMouseOver = $RocketDock and $CurrentlyOver = "No" Then
		$CurentlyOver = "Yes"
		$list = WinList()
		If $list[0][0] = 0 Then Exit

		$i = 0

		Local $pos = _WinAPI_GetMousePos() ; Get current mouse position
		Local $hwnd = _WinAPI_WindowFromPoint($pos) ; Get handle of the window at mouse position

		For $n = 1 To $list[0][0]
			$i += 1
			If $list[$n][0] = "RocketDock" Then
                WinActivate($list[$n][1])
            EndIf
		Next

	else
		$CurrentlyOver = "No"
	endif

EndFunc

func TaskBar()
	; Get the handle for the taskbar using its class name
	Local $hTaskbar = WinGetHandle("[CLASS:Shell_TrayWnd]")
	; Check if the handle was found
	If $hTaskbar <> 0 Then
		; Get the current Z-order position of the taskbar
		Local $currentZOrder = _WinAPI_GetWindow($hTaskbar, $GW_HWNDPREV)
		; Check if the taskbar is not already at the bottom (HWND_BOTTOM = 1)
		If $currentZOrder <> $HWND_BOTTOM Then
			; Move the taskbar to the bottom of the Z-order
			Local $result = _WinAPI_SetWindowPos($hTaskbar, $HWND_BOTTOM, 0, 0, 0, 0, $SWP_FRAMECHANGED + $SWP_NOMOVE + $SWP_NOSIZE + $SWP_NOACTIVATE)
		EndIf
	EndIf
endfunc	

Func GetClassName(ByRef $hWnd)
    Local $ret = DLLCall("user32.dll","int","GetClassName","hwnd",$hWnd,"str","","int",5000)
    If IsArray($ret) Then
        Return $ret[1]
    Else
        Return ""
    EndIf
EndFunc

Func AboutScript()
    MsgBox($MB_SYSTEMMODAL, "RocketDock to front Taskbar to back", "All this app does, is set the windows taskbar to the back and when mouseover RocketDock, will move it to the front!")
EndFunc   ;==>AboutScript