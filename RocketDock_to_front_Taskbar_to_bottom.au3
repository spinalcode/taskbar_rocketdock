#include <WinAPI.au3>

While 1

	Sleep(250)
	RocketDock()
	TaskBar()
 
WEnd
Exit

Func RocketDock()

	; If no app are full height and mouse is over the dock, then bring to front

    ; Get the mouse position
    Local $aPos = MouseGetPos()
	; List all running windows
	$list = WinList()
    ; Get the dimensions of the primary monitor
	$iFullDesktopWidth = _WinAPI_GetSystemMetrics(78)
	$iFullDesktopHeight = _WinAPI_GetSystemMetrics(79)
	
;	ConsoleWrite("Desktop " & $iFullDesktopWidth & "x" & $iFullDesktopHeight & @CRLF)

	$omethingIsFullscreen = False
    ; Loop through the windows
    For $i = 1 To $list[0][0]
        ; Get the position and size of the current window
        Local $aWinPos = WinGetPos($list[$i][1])

        ; Check if the window is fullscreen by comparing with the full desktop dimensions
        If $aWinPos[0] <= 0 And $aWinPos[1] <= 0 And _
           $aWinPos[1] + $aWinPos[3] >= $iFullDesktopHeight Then
            if $list[$i][0] <> "Program Manager" then
				;ConsoleWrite("Window " & $list[$i][0] & " is fullscreen." & @CRLF)
				$omethingIsFullscreen = True
			endif
        EndIf
    Next

	if $omethingIsFullscreen = False then
		; Loop through the windows
		For $i = 1 To $list[0][0]
			; Get the position of the current window
			Local $aWinPos = WinGetPos($list[$i][1])

			; Check if the mouse is over the current window
			If $aPos[0] >= $aWinPos[0] And $aPos[0] <= $aWinPos[0] + $aWinPos[2] And $aPos[1] >= $aWinPos[1] And $aPos[1] <= $aWinPos[1] + $aWinPos[3] Then
				if $list[$i][0] = "RocketDock" then
					WinActivate($list[$i][1])
				endif
			EndIf
		Next
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
