;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; InitText                                                                                                        -
;                                                                                                                      -
; Inits buffers for text
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  nothing                                                                                                         -
; Out: nothing                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

InitText										proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers

												
												xor rdi, rdi


												movss xmm3, r1n
For_Loop:
												xor rdx, rdx
												lea rcx, test_string
												mov dl, byte ptr [rcx + rdi]
												cmp rdx, 0
												je For_Loop_End		
												

												lea rcx, textbufferVertices
												mov r8, rdi 
												movss xmm4, r08n

												LocalCall WriteCharacterInfoToBuffer
												movss xmm3, xmm0
												inc rdi
												jmp For_Loop
For_Loop_End:

												mov textLength, rdi
												movss textNextCharPosition, xmm3
												
;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

InitText										endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; AddReal4VariableToDebugText                                                                                                        -
;                                                                                                                      -
; Adds a variable value to a debug text
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  
;	xmm0, the value. 
;	xmm1, the xPos start
;	xmm2, the yPos 
;	rcx, the string to show before the value. 
;	rdx, the position in the textbuffer                                                                  -
; Out: nothing                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

AddReal4VariableToDebugText						proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers
												Save_SIMD_registers

												xor rdi, rdi
												mov r9, rdx

												mov rbx, rcx

												movss xmm7, xmm0
												movss xmm8, xmm2


												movss xmm3, xmm1
For_Loop:
												xor rdx, rdx
												mov dl, byte ptr [rbx + rdi]
												cmp rdx, 0
												je For_Loop_End		
												

												lea rcx, textbufferVertices
												mov r8, rdi 
												add r8, r9
												movss xmm4, xmm8

												LocalCall WriteCharacterInfoToBuffer
												movss xmm3, xmm0
												inc rdi
												jmp For_Loop
For_Loop_End:
												
												movss xmm6, xmm3

												mov r12, r9

												lea r8, tempTextBuffer
												mov rdx, 10
												;Value is in xmm0 already 
												cvtss2sd xmm0, xmm7 ;covert to double floating point
												WinCall gcvt, rcx, rdx, r8

												mov r9, r12
												add r9, rdi
												movss xmm3, xmm6

												xor rdi, rdi


For_Loop_Value:
												xor rdx, rdx
												lea rcx, tempTextBuffer
												mov dl, byte ptr [rcx + rdi]
												cmp rdx, 0
												je For_Loop_Value_End		
												

												lea rcx, textbufferVertices
												mov r8, rdi 
												add r8, r9
												movss xmm4, xmm8

												LocalCall WriteCharacterInfoToBuffer
												movss xmm3, xmm0
												inc rdi
												jmp For_Loop_Value
For_Loop_Value_End:
												add rdi, r9
												mov textLength, rdi



												
;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_SIMD_registers
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

AddReal4VariableToDebugText									endp                                                                  ; End function


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; WriteCharacterInfoToBuffer                                                                                                        -
;                                                                                                                      -
; Writes character info for a character to a textVertexbuffer at the specified index
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  rcx, textVertexbuffer. rdx, characterId. r8, index in buffer. xmm3, Screen x position. xmm4, screen y position                                                                                                         -
; Out: xmm0, next xPos                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

WriteCharacterInfoToBuffer						proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers
												Save_SIMD_registers                                                        ; Save incoming registers

												mov r10, rcx
												mov r11, rdx										
												xorps xmm7, xmm7 ;store current xPos here
												movss xmm7, xmm3
												xorps xmm9, xmm9 ;store yPos here
												movss xmm9, xmm4
												movss xmm8, r1
												divss xmm8, screenWidth
												movss xmm11, r512
												divss xmm11, screenWidth
												movss xmm0, screenWidth
												divss xmm0, screenHeight
												movss xmm14, xmm11
												mulss xmm14, xmm0
												movss xmm15, xmm8
												mulss xmm15, xmm0 ;yScale

												mov rbx, r11
												sub rbx, 30 ;TODO change this temp hack since id is not array index in font info

												mov rax, sizeof(font_char)
												mul rbx
												mov r12, rax
												
												lea rcx, fontCharacters
												movss xmm0, real4 ptr [rcx + r12 + font_char.u]
												movss xmm1, real4 ptr [rcx + r12 + font_char.v]
												movss xmm2, real4 ptr [rcx + r12 + font_char.xOffset]

												;add xPos
												mulss xmm2, xmm8 ;scale to -1.0 - 1.0
												addss xmm2, xmm7

												movss xmm4, real4 ptr [rcx + r12 + font_char.yOffset]
												mulss xmm4, xmm15 ;scale to -1.0 - 1.0
												movss xmm3, xmm9
												subss xmm3, xmm4

												movss xmm4, real4 ptr [rcx + r12 + font_char.tWidth]
												movss xmm5, real4 ptr [rcx + r12 + font_char.tHeight]
												movss xmm6, real4 ptr [rcx + r12 + font_char.xAdvance]
												mulss xmm6, xmm8
												
												;scale to screen units
												movss xmm12, xmm4
												mulss xmm12, xmm11
												movss xmm13, xmm5
												mulss xmm13, xmm14

												mov rax, sizeof(font_vertex) * 4
												mul r8
												movss real4 ptr[r10 + rax + font_vertex.u], xmm0
												movss real4 ptr[r10 + rax + font_vertex.v], xmm1
												movss real4 ptr[r10 + rax + font_vertex.x], xmm2
												movss real4 ptr[r10 + rax + font_vertex.y], xmm3
												movss real4 ptr[r10 + rax + font_vertex.z], xmm12
												movss real4 ptr[r10 + rax + font_vertex.w], xmm13
												movss real4 ptr[r10 + rax + font_vertex.uvWidth], xmm4
												movss real4 ptr[r10 + rax + font_vertex.uvHeight], xmm5
												movss xmm10, r1
												movss real4 ptr[r10 + rax + font_vertex.cr], xmm10
												movss real4 ptr[r10 + rax + font_vertex.cg], xmm10
												movss real4 ptr[r10 + rax + font_vertex.cb], xmm10
												movss real4 ptr[r10 + rax + font_vertex.ca], xmm10

												add rax, sizeof(font_vertex)

												movss real4 ptr[r10 + rax + font_vertex.u], xmm0
												movss real4 ptr[r10 + rax + font_vertex.v], xmm1
												movss real4 ptr[r10 + rax + font_vertex.x], xmm2
												movss real4 ptr[r10 + rax + font_vertex.y], xmm3
												movss real4 ptr[r10 + rax + font_vertex.z], xmm12
												movss real4 ptr[r10 + rax + font_vertex.w], xmm13
												movss real4 ptr[r10 + rax + font_vertex.uvWidth], xmm4
												movss real4 ptr[r10 + rax + font_vertex.uvHeight], xmm5
												movss xmm10, r1
												movss real4 ptr[r10 + rax + font_vertex.cr], xmm10
												movss real4 ptr[r10 + rax + font_vertex.cg], xmm10
												movss real4 ptr[r10 + rax + font_vertex.cb], xmm10
												movss real4 ptr[r10 + rax + font_vertex.ca], xmm10

												add rax, sizeof(font_vertex)
												
												movss real4 ptr[r10 + rax + font_vertex.u], xmm0
												movss real4 ptr[r10 + rax + font_vertex.v], xmm1
												movss real4 ptr[r10 + rax + font_vertex.x], xmm2
												movss real4 ptr[r10 + rax + font_vertex.y], xmm3
												movss real4 ptr[r10 + rax + font_vertex.z], xmm12
												movss real4 ptr[r10 + rax + font_vertex.w], xmm13
												movss real4 ptr[r10 + rax + font_vertex.uvWidth], xmm4
												movss real4 ptr[r10 + rax + font_vertex.uvHeight], xmm5
												movss xmm10, r1
												movss real4 ptr[r10 + rax + font_vertex.cr], xmm10
												movss real4 ptr[r10 + rax + font_vertex.cg], xmm10
												movss real4 ptr[r10 + rax + font_vertex.cb], xmm10
												movss real4 ptr[r10 + rax + font_vertex.ca], xmm10

												add rax, sizeof(font_vertex)
												
												movss real4 ptr[r10 + rax + font_vertex.u], xmm0
												movss real4 ptr[r10 + rax + font_vertex.v], xmm1
												movss real4 ptr[r10 + rax + font_vertex.x], xmm2
												movss real4 ptr[r10 + rax + font_vertex.y], xmm3
												movss real4 ptr[r10 + rax + font_vertex.z], xmm12
												movss real4 ptr[r10 + rax + font_vertex.w], xmm13
												movss real4 ptr[r10 + rax + font_vertex.uvWidth], xmm4
												movss real4 ptr[r10 + rax + font_vertex.uvHeight], xmm5
												movss xmm10, r1
												movss real4 ptr[r10 + rax + font_vertex.cr], xmm10
												movss real4 ptr[r10 + rax + font_vertex.cg], xmm10
												movss real4 ptr[r10 + rax + font_vertex.cb], xmm10
												movss real4 ptr[r10 + rax + font_vertex.ca], xmm10

												movss xmm0, xmm7
												addss xmm0, xmm6
 

												

;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_SIMD_registers
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

WriteCharacterInfoToBuffer						endp                                                                  ; End function