;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; InitBees                                                                                                        -
;                                                                                                                      -
; Initializes the positions of the bees
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  nothing                                                                                                         -
; Out: nothing                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

InitBees									proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers

												xor rdi, rdi ; set index to 0
                                                mov r8d, numberOfBees ; load number of loops into rdx

SetupInstances_For:                             cmp edi, r8d ; Check if index is equal to number of loops
                                                je SetupInstances_End_For

												mov eax, 2
                                                mul edi
												mov ebx, eax
												mov ecx, 200
												div ecx
												mov r11d, edx; load the remainder to r11d, this is our i value
                                                mov r12d, eax; load the quotent to r12d, this is out j value
												cvtsi2ss xmm1, r11d
												cvtsi2ss xmm0, r12d
												subss xmm1, r255
												subss xmm0, r255

												mov eax, sizeof ( vector4 )
                                                mul edi
                                                lea rbx, beeTransformDataArray
												;movss xmm1, r0
												movss real4 ptr [rbx+rax + vector4.x], xmm1
                                                movss xmm2, r24p5
                                                movss real4 ptr [rbx+rax + vector4.y], xmm2
                                                ;movss xmm0, r0
                                                movss real4 ptr [rbx+rax + vector4.z], xmm0
                                                movss xmm0, r0
                                                movss real4 ptr [rbx+rax + vector4.w], xmm0
												inc edi
                                                jmp SetupInstances_For

SetupInstances_End_For:
;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

InitBees									endp                                                                  ; End function