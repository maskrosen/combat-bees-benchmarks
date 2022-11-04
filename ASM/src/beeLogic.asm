;-----------------------------------------------------------------------------------------------------------------------
;                                                      																-
; ClearBees                                        																-
;                                                      																-
; Initializes the positions of the bees
;-----------------------------------------------------------------------------------------------------------------------
;                                                      																-
; In:  nothing                                         																-
; Out: nothing                                                        																-
; 
;-----------------------------------------------------------------------------------------------------------------------

ClearBees										proc  																; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local   			holder:qword  									;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers														; Save incoming registers

												xor rdi, rdi ; set index to 0
												mov r8d, team1NumberOfBees ; load number of loops into rdx

SetupInstances_For: 							cmp edi, r8d ; Check if index is equal to number of loops
												je SetupInstances_End_For

												mov eax, 3
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

												mov eax, sizeof ( vector3 )
												mul edi
												lea rbx, team1BeeMovementArray
												;movss xmm1, r0
												movss real4 ptr [rbx+rax + vector3.x], xmm1
												movss xmm2, r24p5
												movss real4 ptr [rbx+rax + vector3.y], xmm2
												;movss xmm0, r0
												movss real4 ptr [rbx+rax + vector3.z], xmm0


												lea rbx, team2BeeMovementArray
												;movss xmm1, r0
												movss real4 ptr [rbx+rax + vector3.x], xmm1
												movss xmm2, r49
												movss real4 ptr [rbx+rax + vector3.y], xmm2
												;movss xmm0, r0
												movss real4 ptr [rbx+rax + vector3.z], xmm0

												inc edi
												jmp SetupInstances_For

SetupInstances_End_For:

												mov team1AliveBees, 0
												mov team2AliveBees, 0

												mov team1DeadBees, 0
												mov team2DeadBees, 0
;-----[Zero final return]----------------------------------------------

												xor 				rax, rax  										; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align   			qword 											; Set qword alignment
												Restore_Registers 													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret   																; Return to caller

ClearBees										endp  																; End function


;***** InitBee *********************************************************************************************************
;
; Does not restore registers!
;
; Initialises newly spawned bees
; rcx, index for first bee
; rdx, number of bees
; r8, teamIndex
; 

InitBees										macro

												mov r10, rcx
												mov r11, rdx
												mov rax, r8
												mov rbx, sizeof(dword)
												mul rbx
												
												lea r9, team1AliveBees
												add r9, rax

												mov rbx, sizeof(Vector4)
												mov rax, r8
												mul rbx

												lea rcx, team1SpawnPos
												movaps xmm0, xmmword ptr [rcx + rax] ;spawn pos as vector4
												movaps xmm1, xmm0
												shufps xmm1, xmm1, 39h
												shufps xmm1, xmm1, 39h
												xorps xmm2, xmm2
												;xmm1 now holds z in first positon
												

												lea rcx, beeMovements
												mov rax, r8
												mov rbx, sizeof(qword)
												mul rbx
												mov rcx, qword ptr [rcx + rax] ;now holds a pointer to the movement array for the current team

												
												
												;TODO add sizes, targets and noTargets here
												
												mov rdi, r10
												mov rsi, rdi
												add rsi, r11
												xor rax, rax
Init_Bees_Loop:

												
												cmp rdi, rsi
												jge Init_Bees_Loop_End

												movsd qword ptr [rcx + rax], xmm0 ;x, y
												movss real4 ptr [rcx + rax + 8], xmm1 ; z
												
												;set velocity to 0
												movsd qword ptr [rcx + rax + movement.velocity], xmm2 ;x, y
												movss real4 ptr [rcx + rax + movement.velocity + 8], xmm2 ; z

												inc dword ptr [r9] ;add 1 to alivebees of the current team

												inc rdi
												add rax, sizeof(movement)
												jmp Init_Bees_Loop
Init_Bees_Loop_End:
												endm



;-----------------------------------------------------------------------------------------------------------------------
;                                                      																-
; SpawnBees                                        																-
;                                                      																-
; Spawns new bees until the total max is reached for the specified team
;-----------------------------------------------------------------------------------------------------------------------
;                                                      																-
; In:  rcx teamIndex                                         																-
; Out: nothing                                                        																-
; 
;-----------------------------------------------------------------------------------------------------------------------

SpawnBees										proc  																; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local   			holder:qword  									;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers														; Save incoming registers

												;keep teamIndex in r8
												mov r8, rcx
												lea rcx, team1AliveBees
												;calc pointer offset to team
												mov rax, r8
												mov rbx, sizeof(dword)
												mul rbx
												mov r9d, dword ptr [rcx + rax] ;alive bees for team
												lea rcx, team1DeadBees
												mov r10d, dword ptr [rcx + rax] ;dead bees for team
												add r10, r9
												;r10 now holds number of active bees
												mov rdi, starting_bees_per_team
												sub rdi, r10 ;number of bees to spawn

												mov rcx, r9 ;start index (alive count)
												mov rdx, rdi ;number of bees
												;r8 already holds team index

												InitBees



;-----[Zero final return]----------------------------------------------

												xor 				rax, rax  										; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align   			qword 											; Set qword alignment
												Restore_Registers 													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret   																; Return to caller

SpawnBees										endp  																; End function


;***** GetRandomNumberMacro *********************************************************************************************************
;
; Macro version of get random number for better speed
; in rax max range, rcx seed
; out rax random number, rcx new seed
;
; 

GetRandomNumberMacro								macro  

													imul  edx, ecx, 08088405H  	; EDX = RandSeed * 0x08088405 (decimal 134775813)
													inc   edx
													mov   ecx, edx 				; New RandSeed
													mul   edx   						; EDX:EAX = EAX * EDX
													mov   eax, edx  					; Return the EDX from the multiplication
													

													endm

;***** GetRandomInsideUnitSphere *********************************************************************************************************
;
; Returns a random vector inside a unit spehere
; Out: xmm0, the vector
; 

;We put the value here so it will probably always be in cache when we use it here
LR0p00001 											dword					03727C5ACh                      ;float 9.99999974E-6

GetRandomInsideUnitSphere							macro  
													
													xorps xmm0, xmm0
													mov rax, 200000
													GetRandomNumberMacro
													sub rax, 100000
													cvtsi2ss xmm1, rax
													mulss xmm1, LR0p00001
													movss xmm0, xmm1

													mov rax, 200000
													GetRandomNumberMacro
													sub rax, 100000
													cvtsi2ss xmm1, rax
													mulss xmm1, LR0p00001
													shufps xmm0, xmm0, 93h ; rotate one step so x becomes y
													movss xmm0, xmm1

													mov rax, 200000
													GetRandomNumberMacro
													sub rax, 100000
													cvtsi2ss xmm1, rax
													mulss xmm1, LR0p00001
													shufps xmm0, xmm0, 93h 
													movss xmm0, xmm1


													endm

;-----------------------------------------------------------------------------------------------------------------------
;																													-
; UpdateMovements																										-
;																													-
; Updates the movements of the bees of one team
;-----------------------------------------------------------------------------------------------------------------------
;																													-
; In:  rcx teamIndex																										-
; Out: nothing																														-
; 
;-----------------------------------------------------------------------------------------------------------------------


UpdateMovements									proc																 ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local				holder:qword									;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers														; Save incoming registers
												Save_SIMD_registers

												;keep teamIndex in r8
												mov r8, rcx
												lea rcx, team1AliveBees
												;calc pointer offset to team
												mov rax, r8
												mov rbx, sizeof(dword)
												mul rbx
												mov esi, dword ptr [rcx + rax] ;alive bees for team

												lea rcx, beeMovements
												mov rax, r8
												mov rbx, sizeof(qword)
												mul rbx
												mov rcx, qword ptr [rcx + rax] ;now holds a pointer to the movement array for the current team

												;TODO add directions

												;setup some local "variables" with registers 
												mov rax, deltaTimeMicros
												cvtsi2ss xmm10, rax
												movss xmm0, r0000001
												mulss xmm10, xmm0 ;delta time in seconds
												movss xmm11, r09
												movss xmm12, r1
												movaps xmm13, xmmword ptr XMMask3
												movss xmm14, r01 

												mov r11d, randSeed
												xor rdi, rdi ;bee index
												xor r10, r10 ;movement array offset

Movement_Loop:

												cmp rdi, rsi
												jge Movement_Loop_End

												
												;Get position of 2 random ally bees
												mov rax, rsi ;number of alive bees in team
												push rcx
												mov rcx, r11
												GetRandomNumberMacro
												mov r11, rcx
												pop rcx
												;rax now holds our random bee index
												mov rbx, sizeof(movement)
												mul rbx
												movups xmm7, xmmword ptr [rcx + rax] ;position of ally bee

												mov rax, rsi ;number of alive bees in team
												push rcx
												mov rcx, r11
												GetRandomNumberMacro
												mov r11, rcx
												pop rcx
												;rax now holds our random bee index
												mov rbx, sizeof(movement)
												mul rbx
												movups xmm8, xmmword ptr [rcx + rax] ;position of ally bee

												push rcx
												mov rcx, r11
												GetRandomInsideUnitSphere
												mov r11, rcx 
												pop rcx
												;we now have a random point in a unit sphere in xmm0
												mov rax, flight_jitter 
												cvtsi2ss xmm6, rax
												
												mulss xmm6, xmm10 ;delta time
												shufps xmm6, xmm6, 00h
												mulps xmm6, xmm0 ;multiply with random unit sphere point
												movups xmm5, xmmword ptr [rcx + r10] ;position of current bee
												vaddps xmm6, xmm6, xmmword ptr [rcx + r10 + movement.velocity] ; add jitter to velocity
												;calc damping
												movss xmm0, xmm11 ;0.9f
												mulss xmm0, xmm10 ;delta time
												movss xmm3, xmm12 ;1.0f
												subss xmm3, xmm0
												shufps xmm3, xmm3, 00h
												mulps xmm6, xmm3 ;apply damping to velocity

												;Move towards the first random ally												
												;mov rax, rsi ;number of alive bees in team
												;push rcx
												;mov rcx, r11
												;GetRandomNumberMacro
												;mov r11, rcx
												;pop rcx
												;;rax now holds our random bee index
												;mov rbx, sizeof(movement)
												;mul rbx
												;movups xmm7, xmmword ptr [rcx + rax] ;position of ally bee
												
												movaps xmm0, xmm7
												subps xmm0, xmm5 ;diff between current bee and ally target bee
												andps xmm0, xmm13; zero w component
												movaps xmm2, xmm0
												LengthOfVectorFromRegister

												;length is in xmm1, 
												maxss xmm1, xmm14 ;0.1f
												mov rax, team_attraction
												cvtsi2ss xmm0, rax
												mulss xmm0, xmm10 ;delta time
												divss xmm0, xmm1 ;divide by distance
												shufps xmm0, xmm0, 00h
												mulps xmm2, xmm0 ;dist * attraction force
												addps xmm6, xmm2 ;add to velocity

												;Move away from the other random ally												
												;mov rax, rsi ;number of alive bees in team
												;push rcx
												;mov rcx, r11
												;GetRandomNumberMacro
												;mov r11, rcx
												;pop rcx
												;;rax now holds our random bee index
												;mov rbx, sizeof(movement)
												;mul rbx
												;movups xmm8, xmmword ptr [rcx + rax] ;position of ally bee
												
												movaps xmm0, xmm8
												subps xmm0, xmm5 ;diff between current bee and ally target bee
												andps xmm0, xmm13; zero w component
												movaps xmm2, xmm0
												LengthOfVectorFromRegister

												;length is in xmm1, 
												maxss xmm1, xmm14 ;0.1f
												mov rax, team_repulsion
												cvtsi2ss xmm0, rax
												mulss xmm0, xmm10 ;delta time
												divss xmm0, xmm1 ;divide by distance
												shufps xmm0, xmm0, 00h
												mulps xmm2, xmm0 ;dist * repulsion force
												subps xmm6, xmm2 ;sub from vel

												movsd qword ptr [rcx + r10 + movement.velocity], xmm6 ;write back vel to array x and y
												shufps xmm6, xmm6, 39h
												shufps xmm6, xmm6, 39h
												movss real4 ptr [rcx + r10 + movement.velocity + sizeof(qword)], xmm6 ;write back vel to array x and y

												;Todo calc direction												

												inc rdi
												add r10, sizeof(movement)
												jmp Movement_Loop

Movement_Loop_End:

												mov randSeed, r11d 

;-----[Zero final return]----------------------------------------------

												xor					rax, rax										; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align				qword											; Set qword alignment
												Restore_SIMD_registers												; Restore incoming registers
												Restore_Registers													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret																	; Return to caller

UpdateMovements									endp																 ; End function


;-----------------------------------------------------------------------------------------------------------------------
;																													-
; UpdatePositions																										-
;																													-
; Updates the positions of all the active bees
;-----------------------------------------------------------------------------------------------------------------------
;																													-
; In:  rcx, teamIndex																										-
; Out: nothing																														-
; 
;-----------------------------------------------------------------------------------------------------------------------

UpdatePositions									proc																 ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local				holder:qword									;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers														; Save incoming registers
												Save_SIMD_registers

												
												;keep teamIndex in r8
												mov r8, rcx
												lea rcx, team1AliveBees
												;calc pointer offset to team
												mov rax, r8
												mov rbx, sizeof(dword)
												mul rbx
												mov esi, dword ptr [rcx + rax] ;alive bees for team
												lea rcx, team1DeadBees
												add esi, dword ptr [rcx + rax] ;dead bees for team

												lea rcx, beeMovements
												mov rax, r8
												mov rbx, sizeof(qword)
												mul rbx
												mov rcx, qword ptr [rcx + rax] ;now holds a pointer to the movement array for the current team

												mov rax, deltaTimeMicros
												cvtsi2ss xmm10, rax
												movss xmm0, r0000001
												mulss xmm10, xmm0 ;delta time in seconds
												shufps xmm10, xmm10, 00h
												movaps xmm13, xmmword ptr XMMask3

												xor rdi, rdi ;bee index
												xor r10, r10 ;movement array offset

Position_Loop:

												cmp rdi, rsi
												jge Position_Loop_End

												movups xmm5, xmmword ptr [rcx + r10] ;position of current bee
												movups xmm6, xmmword ptr [rcx + r10 + movement.velocity] ; velocity of current bee

												mulps xmm6, xmm10
												addps xmm6, xmm5
												movsd qword ptr [rcx + r10], xmm6 ;write back pos to array x and y
												shufps xmm6, xmm6, 39h
												shufps xmm6, xmm6, 39h
												movss real4 ptr [rcx + r10 + sizeof(qword)], xmm6 ;write back pos to array x and y


												inc rdi
												add r10, sizeof(movement)
												jmp Position_Loop

Position_Loop_End:

;-----[Zero final return]----------------------------------------------

												xor					rax, rax										; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align				qword											; Set qword alignment
												Restore_SIMD_registers													; Restore incoming registers
												Restore_Registers													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret																	; Return to caller

UpdatePositions									endp																 ; End function


;***** GetArrayOffset *********************************************************************************************************
;
; Return the offset to an array in rax
; 
; 

GetArrayOffset									macro index:req, entrySize:req  

												mov rax, index
												mov rbx, entrySize
												mul rbx												

												endm

;***** SetBit *********************************************************************************************************
;
; Sets bit in bit mask array
; cannot use rax or rbx or rdx as parameters
;
; 

SetBit 											macro dest:req, index:req 

												;calculate array index
												xor rdx, rdx
												mov rax, index
												mov rbx, 64
												div rbx
												;Quotient in rax
												;Remainder in rdx		
												push rdx							
												GetArrayOffset rax, sizeof(qword)
												pop rdx
												mov rbx, qword ptr [dest + rax]
												push rax
												mov rax, 1
												push rcx												
												mov cl, dl
												shl rax, cl ;we now have our bit to set 
												pop rcx
												or rbx, rax
												pop rax
												mov qword ptr[dest + rax], rbx

												endm

;***** ClearBit *********************************************************************************************************
;
; Clears bit in bit mask array
; cannot use rax or rbx or rdx as parameters
;
; 

ClearBit 										macro dest:req, index:req 

												;calculate array index
												xor rdx, rdx
												mov rax, index
												mov rbx, 64
												div rbx
												;Quotient in rax
												;Remainder in rdx				
												push rdx								
												GetArrayOffset rax, sizeof(qword)
												pop rdx
												mov rbx, qword ptr [dest + rax]
												push rax
												mov rax, 1
												push rcx
												mov cl, dl
												shl rax, cl ;we now have our bit to set 
												pop rcx
												not rax ; now all bits are set to 1 exept the one that should be cleared
												and rbx, rax
												pop rax
												mov qword ptr[dest + rax], rbx

												endm


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; GetNewEnemyTargets                                                                                                        -
;                                                                                                                      -
; Gets new enemy targets for any bee that needs it
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  rcx, teamIndex    rdx, enemy teamIndex                                                                                                     -
; Out: nothing                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

GetNewEnemyTargets								proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers

												
												mov r8, rcx ;team index
												mov r12, rdx ;enemy team index
												mov r15d, randSeed
												;calc pointer offset to team
												mov rax, r8
												mov rbx, sizeof(dword)
												mul rbx
												lea rcx, team1AliveBees
												mov esi, dword ptr [rcx + rax] ;alive bees for team
												sar esi, 6 ;divide by 64
												inc esi ;we add by one to catch the rest part when not evenly divisible by 64	

												mov rax, r8
												mov rbx, sizeof(qword)
												mul rbx
												lea rcx, teamNoTargets
												mov r9, qword ptr [rcx + rax] ;no target array for team index
												lea rcx, beeTargets
												mov r10, qword ptr [rcx + rax] ;targets array for team index
												lea rcx, teamHasTargets
												mov r8, qword ptr [rcx + rax] ;has target array for team index
												
												;calc pointer offset to enemy team
												mov rax, r12
												mov rbx, sizeof(dword)
												mul rbx
												lea rcx, team1AliveBees
												mov r12d, dword ptr [rcx + rax] ;alive bees for enemy team														
												
												;rcx reserved for mask
												;r8 hasTarget
												;r9 noTarget
												;r10 targets
												;r12 enemyAliveCount
												;r14 bitmask array offset
												;r15 randSeed
									

												xor r14, r14
												xor rdi, rdi
GetTarget_Mask_Loop:												
												cmp rdi, rsi
												jge GetTarget_Loop_Mask_End

												mov rcx, qword ptr[r9 + r14]
												
												test rcx, rcx
												jz GetTarget_Continue ;no bits are set in this qword
GetTarget_Bit_Loop:												
												tzcnt rbx, rcx
												mov r11, rbx ;hold our bit index

												;get random enemy target index 
												push rcx
												mov rcx, r15 ;random seed
												mov rax, r12 ;alive enemy bees
												GetRandomNumberMacro
												mov r15, rcx ;keep random seed here
												pop rcx

												;write target to target array
												mov r13, rax ;save target index
												mov rax, rdi
												mov rbx, 64 ;bits per qword
												mul rbx
												add rax, r11 ;bee index
												mov r11, rax
												mov rbx, sizeof(dword)
												mul rbx 
												mov dword ptr [r10 + rax], r13d
												;update bit masks
												SetBit r8, r11
												ClearBit r9, r11
												blsi rax, rcx ;leaves only the least significant bit turned on
												xor rcx, rax ;flip the bit we just handled

												jnz GetTarget_Bit_Loop


GetTarget_Continue:									
												inc rdi
												add r14, sizeof(qword)
												jmp GetTarget_Mask_Loop
GetTarget_Loop_Mask_End:

												mov randSeed, r15d ;store random seed that was kept in r15

;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

GetNewEnemyTargets								endp                                                                  ; End function