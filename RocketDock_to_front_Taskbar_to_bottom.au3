
#pragma compile(Icon, dock_icon.ico)
;#AutoIt3Wrapper_Run_Au3Stripper=y
;#Au3Stripper_Parameters=/mo
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Local $aScreenResolution = _DesktopDimensions()
; Get the dimensions of the primary monitor
$iFullDesktopWidth = $aScreenResolution[1]
$iFullDesktopHeight = $aScreenResolution[2]

While 1

	Sleep(250)
	;TaskBar()
	RocketDock()

WEnd
Exit

Func RocketDock()

	$TaskbarPosition = -1
	$RocketDockPosition = -1

	; If no app are full height and mouse is over the dock, then bring to front

    ; Get the mouse position
    Local $aPos = MouseGetPos()
	; List all running windows
	$list = WinList()
    ; Check if $list is a valid array
    If Not IsArray($list) Then
        ConsoleWrite("Error: Unable to get window list. Exiting function." & @CRLF)
        Return
    EndIf

	;ConsoleWrite("Desktop " & $iFullDesktopWidth & "x" & $iFullDesktopHeight & @CRLF)

	$omethingIsFullscreen = False
	$RocketMoved = false
    ; Loop through the windows
    For $i = 1 To $list[0][0]

		if GetClassName($list[$i][1]) = "Shell_TrayWnd" then
			;ConsoleWrite("Taskbar" & @CRLF)
			$TaskbarPosition = $i
		endif

		if $list[$i][0] = "RocketDock" then
			$RocketDockPosition = $i
		endif

		; Get the position and size of the current window
        Local $aWinPos = WinGetPos($list[$i][1])
		; Once in a while, it will not work, so check and exit function if it failed.
		If Not IsArray($aWinPos) Then
			ConsoleWrite("Error: Unable to get window position list. Exiting function." & @CRLF)
			Return
		EndIf

        ; Check if the window is fullscreen by comparing with the full desktop dimensions
        If $aWinPos[0] <= 0 And $aWinPos[1] <= 0 And _
           $aWinPos[0] + $aWinPos[2] >= $iFullDesktopWidth And _
           $aWinPos[1] + $aWinPos[3] >= $iFullDesktopHeight Then

			if $list[$i][0] <> "Program Manager" then
				$omethingIsFullscreen = True
			endif

        EndIf
    Next

	if $omethingIsFullscreen = False then
		; Loop through the windows
		For $i = 1 To $list[0][0]
			; Get the position of the current window
			Local $aWinPos = WinGetPos($list[$i][1])
			If Not IsArray($aWinPos) Then
				ConsoleWrite("Error: Unable to get window position list. Exiting function." & @CRLF)
				Return
			EndIf

			; Check if the mouse is over the current window
			If $aPos[0] >= $aWinPos[0] then
				if $aPos[0] <= $aWinPos[0] + $aWinPos[2] Then
					if $aPos[1] >= $aWinPos[1] then
						if $aPos[1] <= $aWinPos[1] + $aWinPos[3] Then
							if $list[$i][0] = "RocketDock" then
								WinActivate($list[$i][1])
								$RocketMoved = true
							endif
						endif
					endif
				endif
			EndIf
		Next
	endif

	if $RocketMoved = false then
		if $TaskbarPosition < $RocketDockPosition then
			TaskBar()
		endif
	EndIf
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

; From https://www.autoitscript.com/forum/topic/134534-_desktopdimensions-details-about-the-primary-and-secondary-monitors/
Func _DesktopDimensions()
    Local $aReturn = [_WinAPI_GetSystemMetrics($SM_CMONITORS), _ ; Number of monitors.
            _WinAPI_GetSystemMetrics($SM_CXSCREEN), _ ; Width or Primary monitor.
            _WinAPI_GetSystemMetrics($SM_CYSCREEN), _ ; Height or Primary monitor.
            _WinAPI_GetSystemMetrics($SM_CXVIRTUALSCREEN)-_WinAPI_GetSystemMetrics($SM_CXSCREEN), _ ; Width of the Virtual screen.
            _WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN)] ; Height of the Virtual screen.
    Return $aReturn
EndFunc   ;==>_DesktopDimensions

Func GetClassName(ByRef $hWnd)
    Local $ret = DLLCall("user32.dll", "int", "GetClassName", "hwnd", $hWnd, "str", "", "int", 5000)
    If IsArray($ret) Then
        Return $ret[2]
    Else
        Return ""
    EndIf
EndFunc
