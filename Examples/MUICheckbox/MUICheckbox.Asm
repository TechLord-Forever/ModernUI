;.386
;.model flat,stdcall
;option casemap:none
.686
.MMX
.XMM
.model flat,stdcall
option casemap:none
include \masm32\macros\macros.asm

;DEBUG32 EQU 1

IFDEF DEBUG32
    PRESERVEXMMREGS equ 1
    includelib M:\Masm32\lib\Debug32.lib
    DBG32LIB equ 1
    DEBUGEXE textequ <'M:\Masm32\DbgWin.exe'>
    include M:\Masm32\include\debug32.inc
ENDIF

include MUICheckbox.inc

.code

start:

    Invoke GetModuleHandle,NULL
    mov hInstance, eax
    Invoke GetCommandLine
    mov CommandLine, eax
    Invoke InitCommonControls
    mov icc.dwSize, sizeof INITCOMMONCONTROLSEX
    mov icc.dwICC, ICC_COOL_CLASSES or ICC_STANDARD_CLASSES or ICC_WIN95_CLASSES
    Invoke InitCommonControlsEx, offset icc
    
    Invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    Invoke ExitProcess, eax

;-------------------------------------------------------------------------------------
; WinMain
;-------------------------------------------------------------------------------------
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
    LOCAL   wc:WNDCLASSEX
    LOCAL   msg:MSG

    mov     wc.cbSize, sizeof WNDCLASSEX
    mov     wc.style, CS_HREDRAW or CS_VREDRAW
    mov     wc.lpfnWndProc, offset WndProc
    mov     wc.cbClsExtra, NULL
    mov     wc.cbWndExtra, DLGWINDOWEXTRA
    push    hInst
    pop     wc.hInstance
    mov     wc.hbrBackground, COLOR_BTNFACE+1 ; COLOR_WINDOW+1
    mov     wc.lpszMenuName, IDM_MENU
    mov     wc.lpszClassName, offset ClassName
    Invoke LoadIcon, NULL, IDI_APPLICATION
    ;Invoke LoadIcon, hInstance, ICO_MAIN ; resource icon for main application icon
    ;mov hIcoMain, eax ; main application icon
    mov     wc.hIcon, eax
    mov     wc.hIconSm, eax
    Invoke LoadCursor, NULL, IDC_ARROW
    mov     wc.hCursor,eax
    Invoke RegisterClassEx, addr wc
    Invoke CreateDialogParam, hInstance, IDD_DIALOG, NULL, addr WndProc, NULL
    Invoke ShowWindow, hWnd, SW_SHOWNORMAL
    Invoke UpdateWindow, hWnd
    .WHILE TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
      .BREAK .if !eax
        Invoke TranslateMessage, addr msg
        Invoke DispatchMessage, addr msg
    .ENDW
    mov eax, msg.wParam
    ret
WinMain endp


;-------------------------------------------------------------------------------------
; WndProc - Main Window Message Loop
;-------------------------------------------------------------------------------------
WndProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
    
    mov eax, uMsg
    .IF eax == WM_INITDIALOG
        push hWin
        pop hWnd
        ; Init Stuff Here

        ;-----------------------------------------------------------------------------------------------------
        ; ModernUI_CaptionBar Example - similar to the other example projects based on this control
        ;-----------------------------------------------------------------------------------------------------
        ; Applies the ModernUI base style to the dialog, turning it into a borderless, caption less form
        ; we set our own caption and system buttons with the ModernUI_CaptionBar control
        Invoke MUIApplyToDialog, hWin, TRUE
        
        ; Create CaptionBar control and save handle
        Invoke MUICaptionBarCreate, hWin, Addr AppName, 32, IDC_CAPTIONBAR, MUICS_LEFT or MUICS_REDCLOSEBUTTON
        mov hCaptionBar, eax
        
        ; Set some properties for our CaptionBar control 
        Invoke MUICaptionBarSetProperty, hCaptionBar, @CaptionBarBackColor, MUI_RGBCOLOR(27,161,226)
        Invoke MUICaptionBarSetProperty, hCaptionBar, @CaptionBarBtnTxtRollColor, MUI_RGBCOLOR(61,61,61)
        Invoke MUICaptionBarSetProperty, hCaptionBar, @CaptionBarBtnBckRollColor, MUI_RGBCOLOR(87,193,244)      
        
        ;-----------------------------------------------------------------------------------------------------
        ; ModernUI_Checkbox Examples:
        ;-----------------------------------------------------------------------------------------------------
        ; Create our ModernUI_Button control and set to autostate
;       Invoke MUIButtonCreate, hWin, Addr szCheckbox1Text, 20, 50, 200, 24, IDC_CHECKBOX1, MUIBS_LEFT + MUIBS_AUTOSTATE + MUIBS_HAND
;       mov hChk1, eax
;       ; Set all properties for checkbox style
;       Invoke MUIButtonSetAllProperties, hChk1, Addr MUI_CHECKBOX_LIGHT_THEME, SIZEOF MUI_BUTTON_PROPERTIES
;       ; load checkbox icons
;       Invoke MUIButtonLoadImages, hChk1, MUIBIT_ICO, ICO_NOCHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK, ICO_CHECKMARK, ICO_NOCHECKMARK
;
;       Invoke MUIButtonCreate, hWin, Addr szCheckbox2Text, 20, 75, 200, 24, IDC_CHECKBOX2, MUIBS_LEFT + MUIBS_AUTOSTATE + MUIBS_HAND
;       mov hChk2, eax
;       ; Set all properties for checkbox style
;       Invoke MUIButtonSetAllProperties, hChk2, Addr MUI_CHECKBOX_LIGHT_THEME, SIZEOF MUI_BUTTON_PROPERTIES
;       ; load checkbox icons
;       Invoke MUIButtonLoadImages, hChk2, MUIBIT_ICO, ICO_NOCHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK, ICO_CHECKMARK, ICO_NOCHECKMARK
;
;       Invoke MUIButtonCreate, hWin, Addr szCheckbox3Text, 20, 100, 200, 24, IDC_CHECKBOX3, MUIBS_LEFT + MUIBS_AUTOSTATE + MUIBS_HAND
;       mov hChk3, eax
;       ; Set all properties for checkbox style
;       Invoke MUIButtonSetAllProperties, hChk3, Addr MUI_CHECKBOX_LIGHT_THEME, SIZEOF MUI_BUTTON_PROPERTIES
;       ; load checkbox icons
;       Invoke MUIButtonLoadImages, hChk3, MUIBIT_ICO, ICO_NOCHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK, ICO_CHECKMARK, ICO_NOCHECKMARK
        

        Invoke MUICheckboxCreate, hWin, Addr szCheckbox1Text, 20, 50, 200, 24, IDC_CHECKBOX1, MUICS_HAND or WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN
        mov hChk1, eax
        ;Invoke MUICheckboxSetProperty, hChk1, @CheckboxDllInstance, hInstance
        ;Invoke MUICheckboxLoadImages, hChk1, MUICIT_ICO, ICO_NOCHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK, ICO_CHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK

        Invoke MUICheckboxCreate, hWin, Addr szCheckbox2Text, 20, 75, 200, 24, IDC_CHECKBOX2, MUICS_HAND or WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN
        mov hChk2, eax
        Invoke MUICheckboxSetProperty, hChk2, @CheckboxDllInstance, hInstance
        Invoke MUICheckboxLoadImages, hChk2, MUICIT_ICO, ICO_NOCHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK, ICO_CHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK
        
        Invoke MUICheckboxCreate, hWin, Addr szCheckbox3Text, 20, 100, 200, 24, IDC_CHECKBOX3, MUICS_HAND or WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN
        mov hChk3, eax
        Invoke MUICheckboxSetProperty, hChk3, @CheckboxDllInstance, hInstance
        Invoke MUICheckboxLoadImages, hChk3, MUICIT_ICO, ICO_NOCHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK, ICO_CHECKMARK, ICO_NOCHECKMARK, ICO_CHECKMARK
        

        

    ;---------------------------------------------------------------------------------------------------------------
    ; Handle painting of our dialog with our specified background and border color to mimic new Modern style UI feel
    ;---------------------------------------------------------------------------------------------------------------
    .ELSEIF eax == WM_ERASEBKGND
        mov eax, 1
        ret

    .ELSEIF eax == WM_PAINT
        invoke MUIPaintBackground, hWin, MUI_RGBCOLOR(240,240,240), MUI_RGBCOLOR(27,161,226)
        mov eax, 0
        ret
    ;---------------------------------------------------------------------------------------------------------------
        
        
    .ELSEIF eax == WM_COMMAND
        mov eax, wParam
        and eax, 0FFFFh
        .IF eax == IDM_FILE_EXIT
            Invoke SendMessage,hWin,WM_CLOSE,0,0
            
        .ELSEIF eax == IDM_HELP_ABOUT
            Invoke ShellAbout,hWin,addr AppName,addr AboutMsg,NULL
            
        .ENDIF

    .ELSEIF eax == WM_CLOSE
        Invoke DestroyWindow,hWin
        
    .ELSEIF eax == WM_DESTROY
        Invoke PostQuitMessage,NULL
        
    .ELSE
        Invoke DefWindowProc,hWin,uMsg,wParam,lParam
        ret
    .ENDIF
    xor    eax,eax
    ret
WndProc endp

end start
