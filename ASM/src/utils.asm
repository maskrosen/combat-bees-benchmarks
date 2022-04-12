;------------------------------------------------------------------
; Get Random Number
;------------------------------------------------------------------
;
; In: rax: max range of number (exlusive)
;
; Out: rax: a psuedo random number
;

GetRandomNumber                                proc

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                Save_Registers                                                        ; Save incoming registers

                                                imul  edx, randSeed, 08088405H      ; EDX = RandSeed * 0x08088405 (decimal 134775813)
                                                inc   edx
                                                mov   randSeed, edx                 ; New RandSeed
                                                mul   edx                           ; EDX:EAX = EAX * EDX
                                                mov   eax, edx                      ; Return the EDX from the multiplication

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                align               qword                                             ; Set qword alignment
                                                Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                ret                                                                   ; Return to caller

GetRandomNumber                                endp                                                                  ; End function


                                              