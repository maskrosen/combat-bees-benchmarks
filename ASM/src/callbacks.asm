
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Main_CB                                                                                                              -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  rcx = hWnd                                                                                                      -
;      rdx = uMsg                                                                                                      -
;      r8  = wParam                                                                                                    -
;      r9  = lParam                                                                                                    -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

Main_CB                                          proc                                                                  ; Declare function

;-----[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;
                                                 local               hWnd:qword                                        ;
                                                 local               lParam:qword                                      ;
                                                 local               message:qword                                     ;
                                                 local               wParam:qword                                      ;

;-----[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;-----[Set incoming values]-------------------------------------------

                                                 mov                 hWnd, rcx                                         ; Set the incoming handle
                                                 mov                 message, rdx                                      ; Set the incoming message
                                                 mov                 wParam, r8                                        ; Set the incoming wParam value
                                                 mov                 lParam, r9                                        ; Set the incoming lParam value

                                                 ;-----[Branch if overriding local callouts]---------------------------

                                                 cmp                 in_shutdown, 0                                    ; In shutdown process?
                                                 jnz                 Main_CB_00001                                     ; Yes -- default handling only

                                                 ;-----[Lookup incoming message]---------------------------------------

                                                 mov                 rcx, rdx                                          ; Set message
                                                 lea                 rdx, Main_CB_Lookup                               ; Set lpLookupList
                                                 LocalCall           Common_Lookup                                     ; Route for incoming message

                                                 ;-----[Branch if message lookup hit]-----------------------------------
                                                 ;
                                                 ; If the incoming uMsg value is present in the Main_CB_Lookup list, the
                                                 ; return value for RAX will contain the 0-based qword index of the list
                                                 ; item matched.  If no match, -1 is returned.

                                                 cmp                 rax, -1                                           ; Message lookup hit?
                                                 jnz                 Main_CB_00002                                     ; Yes -- route for message

                                                 ;-----[Execute default handler]---------------------------------------

Main_CB_00001:                                   mov                 rcx, hwnd                                         ; Reset RCX
                                                 mov                 rdx, message                                      ; Reset RDX
                                                 mov                 r8, wParam                                        ; Reset R8
                                                 mov                 r9, lParam                                        ; Reset R9
                                                 WinCall             DefWindowProc, rcx, rdx, r8, r9                   ; Execute call
                                                 jmp                 Main_CB_Exit                                      ; Exit procedure

                                                 ;-----[Route for target message]--------------------------------------

Main_CB_00002:                                   shl                 rax, 3                                            ; Scale to * 8 for byte offset
                                                 lea                 rbx,  Main_CB_Rte                  
                                                 add                 rbx,  rax    
                                                 mov                 rax, [rbx]              
                                                 call                rax                                ; Execute target callout

;-----[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Exit:                                    Restore_Registers                                                     ; Restore incoming registers

;-----[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_EraseBkgnd message.                                                                                      -
;                                                                                                                      -
;          Since DirectX handles drawing, this handler does nothing but return TRUE to say "processed."                -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_EraseBkgnd                               label               qword                                             ; Declare label

                                                 ;-----[Set TRUE return]-----------------------------------------------

                                                 mov                 rax, 1                                            ; Set TRUE return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_Paint message.                                                                                           -
;                                                                                                                      -
;          Since DirectX handles drawing, this handler only validates the invalid client area to prevent WM_Paint      -
;          from being sent over and over.                                                                              -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Paint                                    label               qword                                             ; Declare label

                                                 ;-----[Validate the invalid rectangle]--------------------------------

                                                 mov                 rcx, hwnd                                         ; Set hWnd
                                                 xor                 rdx, rdx                                          ; Set lprc
                                                 WinCall             ValidateRect, rcx, rdx                            ; Execute call

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_Close message.                                                                                           -
;                                                                                                                      -
;          Execute DirectX shutdowns and destroy main window.                                                          -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Close                                    label               qword                                             ; Declare label

                                                 ;-----[Do DirectX cleanups]--------------------------------------------

                                                 LocalCall           Shutdown                                          ; Shut down DirectX

                                                 ;-----[Destroy the main window]----------------------------------------

                                                 mov                 rcx, Main_Handle                                  ; Set hWnd
                                                 WinCall             DestroyWindow, rcx                                ; Execute call

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_Destroy message.                                                                                         -
;                                                                                                                      -
;          Post WM_Quit.                                                                                               -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Destroy                                  label               qword                                             ; Declare label

                                                 ;-----[Post the quit message]------------------------------------------

                                                 xor                 rax, rax                                          ; Set nExitCode
                                                 WinCall             PostQuitMessage, rcx                              ; Post the quit message

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_KeyDown message.                                                                                         -
;                                                                                                                      -
;          Post Controls game                                                                                               -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_KeyDown                                  label               qword                                             ; Declare label

                                                                                                 
                                                cmp r8, vk_up ; test if up key is pressed
                                                jne KeyDown_Test_Left ; if not up test left
                                                mov upButtonPressed, 1
KeyDwon_Up_End:                                 jmp KeyDown_Return


KeyDown_Test_Left:                              cmp r8, vk_left ; test if left key is pressed
                                                jne KeyDown_Test_Right ; if not, test right
                                                mov leftButtonPressed, 1
KeyDown_Left_End:                               jmp KeyDown_Return

KeyDown_Test_Right:                             cmp r8, vk_right ; test if right is pressed
                                                jne KeyDown_Test_Down ; if not, test down
                                                mov rightButtonPressed, 1
KeyDown_Right_End:                              jmp KeyDown_Return

KeyDown_Test_Down:                              cmp r8, vk_down ; test if down is pressed
                                                jne KeyDown_Test_M ; if not, test M
                                                mov downButtonPressed, 1
                                                jmp KeyDown_Return

KeyDown_Test_M:                                 cmp r8, vk_m ; test if m is pressed
                                                jne KeyDown_Test_N ; if not, test N
                                                mov mButtonPressed, 1
                                                jmp KeyDown_Return

KeyDown_Test_N:                                 cmp r8, vk_n ; test if m is pressed
                                                jne KeyDown_Test_W ; if not, return
                                                mov nButtonPressed, 1
                                                jmp KeyDown_Return   

KeyDown_Test_W:                                 cmp r8, vk_w ; test if m is pressed
                                                jne KeyDown_Test_A ; if not, return
                                                mov wButtonPressed, 1
                                                jmp KeyDown_Return        

KeyDown_Test_A:                                 cmp r8, vk_a ; test if m is pressed
                                                jne KeyDown_Test_S ; if not, return
                                                mov aButtonPressed, 1
                                                jmp KeyDown_Return   

KeyDown_Test_S:                                 cmp r8, vk_s ; test if m is pressed
                                                jne KeyDown_Test_D ; if not, return
                                                mov sButtonPressed, 1
                                                jmp KeyDown_Return   
                                            
KeyDown_Test_D:                                 cmp r8, vk_d ; test if m is pressed
                                                jne KeyDown_Test_P ; if not, return
                                                mov dButtonPressed, 1
                                                jmp KeyDown_Return   

KeyDown_Test_P:                                 cmp r8, vk_p ; test if m is pressed
                                                jne KeyDown_Test_R ; if not, return
                                                mov pButtonPressed, 1
                                                jmp KeyDown_Return   

KeyDown_Test_R:                                 cmp r8, vk_r ; test if m is pressed
                                                jne KeyDown_Return ; if not, return
                                                cmp rButtonDown, 1
												je Not_First_R_Down_Frame
												mov rButtonDownThisFrame, 1
Not_First_R_Down_Frame:
                                                mov rButtonDown, 1
                                                jmp KeyDown_Return   

                                                 ;-----[Set ZERO return]------------------------------------------------

KeyDown_Return:                                  xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_KeyUp message.                                                                                         -
;                                                                                                                      -
;          Post Controls game                                                                                               -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_KeyUp                                    label               qword                                             ; Declare label

                                                                                                 
                                                ;int 3
                                                cmp r8, vk_up ; test if up key is released
                                                jne KeyUp_Test_Left ; if not up test left
                                                mov upButtonPressed, 0
KeyUp_Up_End:                                   jmp KeyUp_Return


KeyUp_Test_Left:                                cmp r8, vk_left ; test if left key is released
                                                jne KeyUp_Test_Right ; if not, test right
                                                mov leftButtonPressed, 0
KeyUp_Left_End:                                 jmp KeyUp_Return

KeyUp_Test_Right:                               cmp r8, vk_right ; test if right is released
                                                jne KeyUp_Test_Down ; if not, test down
                                                mov rightButtonPressed, 0
KeyUp_Right_End:                                jmp KeyUp_Return

KeyUp_Test_Down:                                cmp r8, vk_down ; test if down is released
                                                jne KeyUp_Test_Space ; if not, test M
                                                mov downButtonPressed, 0
                                                jmp KeyUp_Return

KeyUp_Test_Space:                               cmp r8, vk_space ; test if m is released
                                                jne KeyUp_Test_E ; if not, test N
                                                ;mov eButtonPressed, 0
                                                mov spaceButtonPressedLastFrame, 1
                                                jmp KeyUp_Return

KeyUp_Test_E:                                   cmp r8, vk_e ; test if m is released
                                                jne KeyUp_Test_M ; if not, test N
                                                mov eButtonPressed, 0
                                                mov eButtonPressedLastFrame, 1
                                                jmp KeyUp_Return

KeyUp_Test_M:                                   cmp r8, vk_m ; test if m is released
                                                jne KeyUp_Test_N ; if not, test N
                                                mov mButtonPressed, 0
                                                mov mButtonPressedLastFrame, 1
                                                jmp KeyUp_Return

KeyUp_Test_N:                                   cmp r8, vk_n ; test if m is released
                                                jne KeyUp_Test_W ; if not, return
                                                mov nButtonPressed, 0
                                                mov nButtonPressedLastFrame, 1
                                                jmp KeyUp_Return   

KeyUp_Test_W:                                   cmp r8, vk_w ; test if m is released
                                                jne KeyUp_Test_A ; if not, return
                                                mov wButtonPressed, 0                                                
                                                jmp KeyUp_Return        

KeyUp_Test_A:                                   cmp r8, vk_a ; test if m is released
                                                jne KeyUp_Test_S ; if not, return
                                                mov aButtonPressed, 0
                                                jmp KeyUp_Return   

KeyUp_Test_S:                                   cmp r8, vk_s ; test if m is released
                                                jne KeyUp_Test_D ; if not, return
                                                mov sButtonPressed, 0
                                                jmp KeyUp_Return   
                                            
KeyUp_Test_D:                                   cmp r8, vk_d ; test if m is released
                                                jne KeyUp_Test_P ; if not, return
                                                mov dButtonPressed, 0
                                                jmp KeyUp_Return   

KeyUp_Test_P:                                   cmp r8, vk_p ; test if p is released
                                                jne KeyUp_Test_R ; if not, return
                                                mov pButtonPressed, 0
                                                mov pButtonPressedLastFrame, 1
                                                jmp KeyUp_Return   

KeyUp_Test_R:                                   cmp r8, vk_r ; test if p is released
                                                jne KeyUp_Test_T ; if not, return
                                                mov rButtonPressedLastFrame, 1
												mov rButtonDown, 0
                                                jmp KeyUp_Return   

KeyUp_Test_T:                                   cmp r8, vk_t ; test if t is released
                                                jne KeyUp_Test_Comma ; if not, return
                                                mov tButtonPressedLastFrame, 1
                                                jmp KeyUp_Return   

KeyUp_Test_Comma:                               cmp r8, vk_oem_comma ; test if t is released
                                                jne KeyUp_Test_Minus ; if not, return
                                                mov commaPressedLastFrame, 1
                                                jmp KeyUp_Return   

KeyUp_Test_Minus:                               cmp r8, vk_oem_minus ; test if t is released
                                                jne KeyUp_Test_Period ; if not, return
                                                mov minusPressedLastFrame, 1
                                                jmp KeyUp_Return   

KeyUp_Test_Period:                              cmp r8, vk_oem_period ; test if t is released
                                                jne KeyUp_Return ; if not, return
                                                mov peroidPressedLastFrame, 1
                                                jmp KeyUp_Return   

KeyUp_Test_Delete:                              cmp r8, vk_delete ; test if t is released
                                                jne KeyUp_Return ; if not, return
                                                mov deleteButtonPressedLastFrame, 1
                                                jmp KeyUp_Return   

                                                 ;-----[Set ZERO return]------------------------------------------------

KeyUp_Return:                                  xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_MouseMove message.                                                                                         -
;                                                                                                                      -
;                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_MouseMove                                label               qword                                             ; Declare label

                                                mov rax, r9
                                                mov rbx, 000000000000FFFFh
                                                and rax, rbx
                                                cvtsi2ss xmm0, rax 
                                                ;movss xmm0, debugMouseX
                                                movss mousePosX, xmm0
                                                

                                                mov rax, r9
                                                shr rax, 16
                                                mov rbx, 000000000000FFFFh
                                                and rax, rbx
                                                cvtsi2ss xmm0, rax 
                                                ;movss xmm0, debugMouseY
                                                movss mousePosY, xmm0

                                                
                                                ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_MouseWheel message.                                                                                         -
;                                                                                                                      -
;                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_MouseWheel                               label               qword                                             ; Declare label


                                                mov eax, r8d
                                                shr eax, 16
                                                and eax, 000000000000FFFFh
                                                movsx ecx, ax
                                                cvtsi2ss xmm0, ecx 
                                                divss xmm0, mouseWheelDeltaConst
                                                movss mouseWheelSteps, xmm0
                                                ;int 3
                                             

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_LButtonDown message.                                                                                         -
;                                                                                                                      -
;                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_LButtonDown                              label               qword                                             ; Declare label

                                                
                                                
                                                
                                                movss mouseDownPosWorldX, xmm10
                                                movss mouseDownPosWorldY, xmm11
                                                movss mouseDownPosWorldZ, xmm12

                                                mov rax, input_mouse_left_button
                                                or mouseButtonsDown, rax


                                                 ;-----[Set ZERO return]------------------------------------------------
Mouse_Down_Return:
                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_MButtonDown message.                                                                                         -
;                                                                                                                      -
;                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_RButtonDown                              label               qword                                             ; Declare label


                                                 
                                             

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_MButtonUp message.                    

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_MButtonDown message.                                                                                         -
;                                                                                                                      -
;                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_MButtonDown                              label               qword                                             ; Declare label


                                                 mov middleMousePressed, 1
                                             

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_MButtonUp message.                                                                                         -
;                                                                                                                      -
;                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_MButtonUp                                label               qword                                             ; Declare label


                                                 mov middleMousePressed, 0
                                             

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_Input message.                                                                                         -
;                                                                                                                      -
;                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Input                                    label               qword                                             ; Declare label


                                                 mov eax, rawInputDataSize
                                                 mov rbx, sizeof(RawMouse)
                                                 
                                                 mov rcx, r9 ;lparam
                                                 mov rdx, RID_INPUT
                                                 lea r8, rawInputData ; data pointer
                                                 lea r9, rawInputDataSize ;size
                                                 mov r12, sizeof(RawInputHeader)

                                                 WinCall GetRawInputData, rcx, rdx, r8, r9, r12

                                                mov eax, dword ptr [rawInputData + RawInputHeader.dwType]

                                                cmp eax, RIM_TYPEMOUSE
                                                jne Not_Mouse

                                                 mov ecx, dword ptr [rawInputData + RawInput.data + RawMouse.lLastX] 
                                                 mov edx, dword ptr [rawInputData + RawInput.data + RawMouse.lLastY] 

                                                 cvtsi2ss xmm0, ecx
                                                 movss mouseDiffXThisFrameRaw, xmm0

                                                 cvtsi2ss xmm0, edx
                                                 movss mouseDiffYThisFrameRaw, xmm0
Not_Mouse:                                             

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement


Main_CB                                          endp                                                                  ; End function
