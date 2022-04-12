
;-----------------------------------------------------------------------------------------------------------------------
;
; Note that throughout the functions in this application, general registers are used as often as possible instead of
; local variables.  This reduces memory hits but a good amount when the execution speed of the app is viewed as a whole
; across all functions present.  In addition to memory hits, local variables must also be accessed with indirect
; addressing; this must be calculated on-the-fly at runtime, further slowing execution.  All these slowdowns are avoided
; when general registers are used instead of local variables on the stack.  The benefit is tiny per-occurrence but adds
; up to a significant amount across execution of the entire application ongoing.



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Common_Lookup                                                                                                        -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  rcx = value to look up                                                                                          -
;      rdx > list of values to find value on                                                                           -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

Common_Lookup                                    proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;------[Setup scan]----------------------------------------------------

                                                 mov                 rdi, rdx                                          ; Set values list pointer for scan
                                                 mov                 rax, rcx                                          ; Set scan target value
                                                 mov                 rcx, [ rdi ]                                      ; Set scan count
                                                 scasq                                                                 ; Skip over entry count qword

                                                 ;------[Execute scan]--------------------------------------------------

                                                 mov                 rbx, rdi                                          ; Save the first entry pointer
                                                 repnz               scasq                                             ; Execute scan

                                                 ;------[Branch if not found]-------------------------------------------

                                                 mov                 rax, -1                                           ; Set 'not found' return value
                                                 jnz                 Common_Lookup_Exit                                ; Not found - exit with -1 return

                                                 ;------[Set return: item index]----------------------------------------

                                                 mov                 rax, rdi                                          ; Get pointer after match target
                                                 sub                 rax, rbx                                          ; Set byte distance from first entry
                                                 shr                 rax, 3                                            ; Scale down to qword count
                                                 dec                 rax                                               ; Adjust for 0-based index

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Common_Lookup_Exit:                              Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

Common_Lookup                                    endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Common_LookupString                                                                                                  -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  rcx > string to look up                                                                                         -
;      rdx > list of pointers to strings                                                                               -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

Common_LookupString                              proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;------[Save incoming values]------------------------------------------

                                                 mov                 rsi, rcx                                          ; Save the string pointer
                                                 mov                 r15, rdx                                          ; Save the data list pointer

                                                 ;------[Size source buffer]--------------------------------------------

                                                 mov                 rdi, rcx                                          ; Set scan start pointer
                                                 xor                 al, al                                            ; Set scan target
                                                 mov                 rcx, -1                                           ; Set max scan count
                                                 repnz               scasb                                             ; Locate terminating 0
                                                 not                 rcx                                               ; Reverse for positive value
                                                 dec                 rcx                                               ; Discount terminating 0
                                                 mov                 r8, rcx                                           ; Save source string size

                                                 ;------[Copy source buffer to work buffer]-----------------------------
                                                 ;
                                                 ; This is done to avoid altering the source buffer, which is forced to
                                                 ; upper case.

                                                 lea                 rdi, slks_buff                                    ; Set destination pointer
                                                 rep                 movsb                                             ; Copy string to work buffer

                                                 ;------[Convert work buffer to upper case]-----------------------------

                                                 lea                 rcx, slks_buff                                    ; Set lpBuffer
                                                 mov                 rdx, r8                                           ; Set nCount
                                                 LocalCall           Common_UpCase                                     ; Force work buffer to upper case

                                                 ;------[Initialize loop: compare]--------------------------------------
                                                 ;
                                                 ; The working string size, saved in R8, is incremented to include its
                                                 ; terminating 0.  This allows a direct string-to-string compare with-
                                                 ; out having to size the destination string and check for a size match.
                                                 ; With the terminating 0 included in the compare, a mismatch is auto-
                                                 ; matic if the strings are not identical, regardless of the length of
                                                 ; the compare destination string.

                                                 mov                 r14, [r15]                                        ; Set count through loop
                                                 add                 r15, 8                                            ; Skip over entry count
                                                 xor                 r13, r13                                          ; Initialize entry index
                                                 lea                 r11, slks_buff                                    ; Set source pointer

                                                 ;------[Execute compare]-----------------------------------------------

LookupString_00001:                              mov                 rsi, r11                                          ; Set source pointer
                                                 mov                 rcx, r8                                           ; Set compare count
                                                 mov                 rdi, [r15]                                        ; Set the destination pointer
                                                 repz                cmpsb                                             ; Check for match

                                                 ;------[Exit if match]-------------------------------------------------

                                                 jz                  LookupString_00002                                ; Match -- exit now

                                                 ;------[Bottom of loop: compare]---------------------------------------

                                                 inc                 r13                                               ; Move to next index
                                                 add                 r15, 8                                            ; Move to next entry
                                                 dec                 r14                                               ; Restore loop counter
                                                 jnz                 LookupString_00001                                ; Return to top of loop

                                                 ;------[Set error for not found]---------------------------------------

                                                 mov                 r13, -1                                           ; Set return for not found

                                                 ;------[Process no-error exit]-----------------------------------------

LookupString_00002:                              mov                 rax, r13                                          ; Set return item index

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
LookupString_Exit:                               Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

Common_LookupString                              endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Common_UpCase                                                                                                        -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  rcx > string to convert                                                                                         -
;      rdx = size of string in characters                                                                              -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

Common_UpCase                                    proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;------[Initialize loop: buffer]---------------------------------------

                                                 mov                 rsi, rcx                                          ; Set buffer start pointer
                                                 mov                 rcx, rdx                                          ; Set count through loop
                                                 test                rcx, rcx                                          ; Null count?
                                                 jz                  UpCase_00003                                      ; Exit if zero count

                                                 ;------[Branch if a < ? > z]-------------------------------------------

UpCase_00001:                                    lodsb                                                                 ; Load next character
                                                 cmp                 al,'a'                                            ; Character < a?
                                                 jb                  UpCase_00002                                      ; Yes -- no adjust
                                                 cmp                 al,'z'                                            ; Charcter > z?
                                                 ja                  UpCase_00002                                      ; Yes -- no adjust

                                                 ;------[Force character to upper case]---------------------------------

                                                 and                 byte ptr [rsi-1],not 32                           ; Force off bit 5

                                                 ;------[Reloop]--------------------------------------------------------

UpCase_00002:                                    loop                UpCase_00001                                      ; Return to top of loop

                                                 ;ÄÄÄÄÄ[Return no error]------------------------------------------------

UpCase_00003:                                    xor                 rax,rax                                           ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
UpCase_Exit:                                     Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

Common_UpCase                                    endp                                                                  ; End function

