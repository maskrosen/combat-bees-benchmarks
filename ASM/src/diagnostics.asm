
;***********************************************************************************************************************
;
;

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Ŀ
;- FixWinDbg                                																																							-
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Ŀ
;- In:   										<Nothing>  																																			-
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Ĵ
;- Return:   									RAX = 00: no error 																																	-
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FixWinDbg										proc  																																				; Declare procedure

;----- Entry ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----[Save altered registers]--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																local   			holder:qword  																													;g
																local   			ParmCount:qword   																												;

;-----[Save altered registers]--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																Save_Registers																																		; Save altered registers

;----- Process ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

																;------------------------------------------------------------------------------------------------------------------------------------------------------
																;
																; Enumerate windows to size each.

																;-----[Get current desktop handle]---------------------------------------------------------------------------------------------------------------------

																mov 				fwpr_index,0  																													; Initialize item index
																WinCall 			GetCurrentThreadId																												; Execute call
																mov 				rcx,rax   																														; Set nIDThread
																WinCall 			GetThreadDesktop, rcx 																											; Execute call

																;-----[Get WinDbg main window handle]------------------------------------------------------------------------------------------------------------------

																xor 				rcx, rcx  																														; Set lParam
																lea 				rdx, FWDb_Proc																													; Set lpfn
																mov 				r8,rax																															; Set hDesktop
																WinCall 			EnumDesktopWindows, rcx, rdx, r8  																								; Execute call

																;-----[Zero final return]------------------------------------------------------------------------------------------------------------------------------

																xor 				rax,rax   																														; Zero final return

;----- Exit -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----[Restore altered registers]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

																Restore_Registers 																																	; Restore altered registers

;-----[Return to caller]--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																ret   																																				; Return to caller

FixWinDbg										endp

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Ŀ
;- FWDb_Proc                                																																							-
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
; EnumDesktopWindows callback
;
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Ŀ
;- In:   										rcx 		= hWnd 																																	-
;-   											rdx 		= lParam   																																-
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Ĵ
;-                                          																																							-
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FWDb_Proc										proc  																																				; Declare procedure

;----- Entry ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----[Local data]--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																local   			holder:qword  																													;
																local   			hwnd:qword																														;
																local   			lParam:qword  																													;

;-----[Save altered registers]--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																Save_Registers																																		; Save altered registers

;----- Process ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

																;------------------------------------------------------------------------------------------------------------------------------------------------------
																;
																;

																;-----[Save incoming values]---------------------------------------------------------------------------------------------------------------------------

																mov 				hWnd,rcx  																														;
																mov 				lParam,rdx																														;

																;-----[Get window parent (or window if no parent) title string]----------------------------------------------------------------------------------------

																WinCall 			GetParent, rcx																													; Get parent handle <--- RCX is already set to hWnd
																mov 				rcx,rax   																														; Set hWnd value for call
																test				rcx,rcx   																														; Null parent?
																jnz 				fwpr_00001																														; No -- use parent
																mov 				rcx,hwnd  																														; Yes -- use handle
fwpr_00001:  									lea 				rdx,gen_buff  																													; Set lpString
																mov 				r8,buffer_size																													; Set nMaxCount
																WinCall 			GetWindowText, rcx, rdx, r8   																									; Execute call
																mov 				rcx,rax   																														; Set scan count

																;-----[Exit if no name for this window]----------------------------------------------------------------------------------------------------------------

																test				rax, rax  																														; Null string?
																jz  				fwpr_last 																														; Yes -- do net window

																;-----[Locate - in title string]-----------------------------------------------------------------------------------------------------------------------

																mov 				rcx, rax  																														; Set the scan count
																lea 				rdi,gen_buff 
																add 				rdi, rax  																											; Set scan start pointer
																mov 				al,'-'																															; Set scan target
																std   																																				; Reverse scan direction
																repnz   			scasb 																															; Execute scan
																cld   																																				; Clear direction flag
																jnz 				fwpr_last 																														; Not found -- do next window
																scasw 																																				; Adjust for overshot

																;-----[Check for # after -]----------------------------------------------------------------------------------------------------------------------------

																cmp 				byte ptr [rdi],' '																												; # separator?
																jnz 				fwpr_last 																														; No -- no process
																scasb 																																				; Skip over # separator

																;-----[Size the ID string after -]---------------------------------------------------------------------------------------------------------------------

																mov 				rsi,rdi   																														; Save the compare source pointer
																xor 				al,al 																															; Set the scan target
																mov 				rcx,-1																															; Set max scan count
																repnz   			scasb 																															; Execute scan
																not 				rcx   																															; Reverse sign
																dec 				rcx   																															; Discount terminating 0

																;-----[Branch if no string size match]-----------------------------------------------------------------------------------------------------------------

																cmp 				rcx,qword ptr win_id  																											; Size match?
																jnz 				fwpr_last 																														; No -- no process

																;-----[Get this window title string]-------------------------------------------------------------------------------------------------------------------

																mov 				rcx,hWnd  																														; Reset this handle
																lea 				rdx,gen_buff  																													; Set the buffer pointer
																mov 				r8,buffer_size																													; Set nMaxCount
																WinCall 			GetWindowText, rcx, rdx, r8   																									; Execute call

																;-----[Validate non-zero buffer]-----------------------------------------------------------------------------------------------------------------------
																;
																; Some shithole amateur created a window whose text is 84h or 132 bytes of 0.  This has to be accounted for here.

																lea 				rdi, gen_buff 																													;
																mov 				rcx, buffer_size  																												;
																xor 				al,al 																															;
																repz				scasb 																															;
																jz  				fwpr_last 																														;

																;-----[Size the first word of the string]--------------------------------------------------------------------------------------------------------------
																;
																; This is a WinDbg window.  The first word, followed by #-#, will either be Memory, Registers,
																; Command, or Watch.  If none of these match, check the parent handle.  If it's zero, this is the
																; main window and we don't change it.  Otherwise it's a source window.

																lea 				rdi,gen_buff
																add 				rdi, rax																											; Set the scan start pointer
																mov 				rsi,rdi   																														; Save the source pointer
																mov 				rcx,-1																															; Set max scan count
																mov 				al,' '																															; Set scan target
																repnz   			scasb 																															; Execute scan
																not 				rcx   																															; Reverse sign
																dec 				rcx   																															; Discount terminating 0
																mov 				byte ptr [rdi-1],0																												; Change first # to terminator

																;-----[Index the string]-------------------------------------------------------------------------------------------------------------------------------

																lea 				rcx, gen_buff 																													; Set the buffer pointer
																lea 				rdx, win_list 																													; Set the data list pointer
																LocalCall   		Common_LookupString   																											; Execute call

																;-----[Use index 4 for source windows]-----------------------------------------------------------------------------------------------------------------

																cmp 				rax,-1																															; Source window?
																jnz 				fwpr_00002																														; No -- leave current index

																;-----[------------------------------------------------------------------------------------------------------------------------------------------------

																mov 				rcx,hwnd  																														;
																WinCall 			GetParent, rcx																													;
																test				rax,rax   																														;
																jz  				fwpr_last 																														;

																mov 				rax,4 																															; Yes -- use index 4

																;-----[Callout for window type]------------------------------------------------------------------------------------------------------------------------

fwpr_00002:  									shl 				rax,3 																															; Scale to * 8 for qword size
																lea 				rbx,fwpr_rte  																													;
																add 				rax,rbx   																														;
																jmp 				qword ptr [rax]   																												;

;----- 0: command -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

																;-----[Set new window position]------------------------------------------------------------------------------------------------------------------------

																align   			dword 																															; Set dword alignment
fwpr_00100   												label   			near  																															; Declare near label
															;  mov 				qword ptr [rsp+28h],1 																											; Set bRedraw
															;  mov 				rax,cmnd_h																														; Get the window height
															;  mov 				qword ptr [rsp+20h],rax   																										; Set nHeight
																mov 				r9,cmnd_w 																														; Set nWidth
																mov 				r8,cmnd_y 																														; Set y
																mov 				rdx,cmnd_x																														; Set x
																mov 				rcx,hwnd  																														; Set hWnd
																WinCall 			MoveWindow, rcx, rdx, r8, r9, cmnd_h, 1   																						; Execute call

																;-----[Skip remainder of processes]--------------------------------------------------------------------------------------------------------------------

																jmp 				fwpr_last 																														; Skip remainder of processes

;----- 1: memory --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

																;-----[Branch if not first hit]-------------------------------------------------------------------------------------------------------------------------------------------------------

																align   			dword 																															; Set dword alignment
fwpr_00200   									label   			near  																															; Declare near label
																cmp 				fwpr_index,0  																													; First hit?
																jnz 				fwpr_00201																														; No -- process second memory window

																;-----[Set new window position: window 1]---------------------------------------------------------------------------------------------------------------------------------------------

															;  mov 				qword ptr [rsp+28h],1 																											; Set bRedraw
															;  mov 				rax,mem1_h																														; Get the window height
															;  mov 				qword ptr [rsp+20h],rax   																										; Set nHeight
																mov 				r9,mem1_w 																														; Set nWidth
																mov 				r8,mem1_y 																														; Set y
																mov 				rdx,mem1_x																														; Set x
																mov 				rcx,hwnd  																														; Set hWnd
																WinCall 			MoveWindow, rcx, rdx, r8, r9, mem1_h, 1   																						; Execute call

																;-----[Skip remainder of processes]---------------------------------------------------------------------------------------------------------------------------------------------------

																inc 				fwpr_index																														; Increment hit index
																jmp 				fwpr_last 																														; Skip remainder of processes

																;-----[Branch if not second hit]------------------------------------------------------------------------------------------------------------------------------------------------------

fwpr_00201:  									cmp 				fwpr_index,1  																													; First hit?
																jnz 				fwpr_00202																														; No -- process second memory window

																;-----[Set new window position: window 1]---------------------------------------------------------------------------------------------------------------------------------------------

															;  mov 				qword ptr [rsp+28h],1 																											; Set bRedraw
															;  mov 				rax,mem2_h																														; Get the window height
															;  mov 				qword ptr [rsp+20h],rax   																										; Set nHeight
																mov 				r9,mem2_w 																														; Set nWidth
																mov 				r8,mem2_y 																														; Set y
																mov 				rdx,mem2_x																														; Set x
																mov 				rcx,hwnd  																														; Set hWnd
																WinCall 			MoveWindow, rcx, rdx, r8, r9, mem2_h, 1   																						; Execute call

																;-----[Skip remainder of processes]---------------------------------------------------------------------------------------------------------------------------------------------------

																inc 				fwpr_index																														; Increment hit index
																jmp 				fwpr_last 																														; Skip remainder of processes

																;-----[Set new window position]-------------------------------------------------------------------------------------------------------------------------------------------------------

fwpr_00202:   								;  mov 				qword ptr [rsp+28h],1 																											; Set bRedraw
															;  mov 				rax,mem3_h																														; Get the window height
															;  mov 				qword ptr [rsp+20h],rax   																										; Set nHeight
																mov 				r9,mem3_w 																														; Set nWidth
																mov 				r8,mem3_y 																														; Set y
																mov 				rdx,mem3_x																														; Set x
																mov 				rcx,hwnd  																														; Set hWnd
																WinCall 			MoveWindow, rcx, rdx, r8, r9, mem3_h, 1   																						; Execute call

																;-----[Skip remainder of processes]---------------------------------------------------------------------------------------------------------------------------------------------------

																inc 				fwpr_index																														; Increment hit index
																jmp 				fwpr_last 																														; Skip remainder of processes

;----- 2: registers -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

						;-----[Set new window position]-------------------------------------------------------------------------------------------------------------------------------------------------------

																align   			dword 																															; Set dword alignment
fwpr_00300   									label   			near  																															; Declare near label
															;  mov 				qword ptr [rsp+28h],1 																											; Set bRedraw
															;  mov 				rax,regs_h																														; Get the window height
															;  mov 				qword ptr [rsp+20h],rax   																										; Set nHeight
																mov 				r9,regs_w 																														; Set nWidth
																mov 				r8,regs_y 																														; Set y
																mov 				rdx,regs_x																														; Set x
																mov 				rcx,hwnd  																														; Set hWnd
																WinCall 			MoveWindow, rcx, rdx, r8, r9, regs_h, 1  																							; Execute call

																;-----[Skip remainder of processes]---------------------------------------------------------------------------------------------------------------------------------------------------

																jmp 				fwpr_last 																														; Skip remainder of processes

;----- 3: watch ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

																;-----[Set new window position]-------------------------------------------------------------------------------------------------------------------------------------------------------

																align   			dword 																															; Set dword alignment
fwpr_00400   									label   			near  																															; Declare near label
															;  mov 				qword ptr [rsp+28h],1 																											; Set bRedraw
															;  mov 				rax,watch_h   																													; Get the window height
															;  mov 				qword ptr [rsp+20h],rax   																										; Set nHeight
																mov 				r9,watch_w																														; Set nWidth
																mov 				r8,watch_y																														; Set y
																mov 				rdx,watch_x   																													; Set x
																mov 				rcx,hwnd  																														; Set hWnd
																WinCall 			MoveWindow, rcx, rdx, r8, r9, watch_h, 1  																						; Execute call

																;-----[Skip remainder of processes]---------------------------------------------------------------------------------------------------------------------------------------------------

																jmp 				fwpr_last 																														; Skip remainder of processes

;----- 4: source --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

																;-----[Set new window position]-------------------------------------------------------------------------------------------------------------------------------------------------------

																align   			dword 																															; Set dword alignment
fwpr_00500   									label   			near  																															; Declare near labe
															;  mov 				qword ptr [rsp+28h],1 																											; Set bRedraw
															;  mov 				rax,source_h  																													; Get the window height
															;  mov 				qword ptr [rsp+20h],rax   																										; Set nHeight
																mov 				r9,source_w   																													; Set nWidth
																mov 				r8,source_y   																													; Set y
																mov 				rdx,source_x  																													; Set x
																mov 				rcx,hwnd  																														; Set hWnd
																WinCall 			MoveWindow, rcx, rdx, r8, r9, source_h, 1 																						; Execute call

																;-----[Process no-error exit]---------------------------------------------------------------------------------------------------------------------------------------------------------

fwpr_last:   									mov 				rax,1 																															; Set TRUE return to continue enumerations

;----- Exit -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------͸
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----[Restore altered registers]------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																Restore_Registers 																																	; Restore altered registers

;-----[Return to caller]---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																ret   																																				; Return to caller

FWDb_Proc										endp
