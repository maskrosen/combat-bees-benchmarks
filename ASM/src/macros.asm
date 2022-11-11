
;***** AInclude ********************************************************************************************************

												;***** [Declare macro] ************************************************

AInclude 										macro   			filename  										; Declare macro

												;***** [Process] ******************************************************

												align   			qword 											; Set qword alignment
												include 			filename  										; Restore entry RBX

												;***** [End macro] ****************************************************

												endm  																; End macro declaration

;***** LocalCall *******************************************************************************************************
;
; This macro is not necessary; it's provided for clarity in distinguishing between a local call (calls to functions
; within this app) vs. calls to Windows functions.

												;***** [Declare macro] ************************************************

LocalCall										macro   			destination   									; Declare macro

												;***** [Process] ******************************************************

												call				destination   									; Restore entry RBX

												;***** [End macro] ****************************************************

												endm  																; End macro declaration

;***** LoopN ***********************************************************************************************************

												;***** [Declare macro] ************************************************

LoopN											macro   			destination   									; Declare macro

												;***** [Process] ******************************************************

												dec 				rcx   											; Decrement the loop counter
												jnz 				destination   									; Return to top of loop

												;***** [End macro] ****************************************************

												endm  																; End macro declaration


;***** BitwiseVectorNot *********************************************************************************************************
;
; Flips all bits in xmm0
; uses xmm1 for mask generation
; 

BitwiseVectorNot																				macro  
																								
												vpcmpeqd	xmm1, xmm1, xmm1
        										vpxor   	xmm0, xmm0, xmm1
																								endm

;***** AbsNoMemoryAccess *********************************************************************************************************
;
; Calcualtes the absolute calue of all the slots of xmm0
; Uses xmm1 to generate mask
; 

AbsNoMemoryAccess																				macro  

												;generate mask
												pcmpeqd xmm1, xmm1      
        										psrld 	xmm1, 1      
												andps 	xmm0, xmm1																							

																								endm

;***** Abs *********************************************************************************************************
;
; Calcualtes the absolute calue of all the slots of xmm0
;
; 

Abs																						macro  
												
												
												andps 	xmm0, xmmword ptr [XMMaskAbs]

												endm

;***** Calc2dTo1dArrayIndex *********************************************************************************************************
;
; Calculates the index in a 1d array representing a 2d array
; rbx, x index
; rcx, y index
; rdx, width of the 2d array
; puts the index in rax
; 

Calc2dTo1dArrayIndex														macro  
												
												;index = y * width + x
												mov rax, rcx
												mul rdx
												add rax, rbx

												endm
												
;***** CalcBrakeDistance *********************************************************************************************************
;
; Calculates the brake distance given a brakeforce in m/s2 and current speed in m/s
;-----------------------------------------------------------------------------------------------------------------------
;                                                      																-
; In:  xmm0, current speed. xmm1, brakeforce                                         																-
; Out: xmm0, the brake distance needed   

CalcBrakeDistance																macro  
												
												;d = (v/2) * (v/a) = v2/2a
												mulss xmm0, xmm0
												addss xmm1, xmm1
												divss xmm0, xmm1

												endm


;***** CrossProduct *********************************************************************************************************
;
; Returns the cross product of two vectors
; vector1 goes in xmm0
; vector2 goes in xmm1
; result in xmm0

CrossProduct									macro			
												
												;Code from compiled XMVector3Cross function in directxmath
												movaps  xmm3, xmm0
												movaps  xmm0, xmm1
												shufps  xmm0, xmm0, 0D2h
												movaps  xmm2, xmm0
												shufps  xmm3, xmm3, 0C9h
												shufps  xmm2, xmm0, 0D2h
												movaps  xmm1, xmm3
												mulps   xmm0, xmm3
												shufps  xmm1, xmm3, 0C9h
												mulps   xmm2, xmm1
												subps   xmm0, xmm2												
												andps   xmm0, xmmword ptr XMMask3
																					
																							
												endm



;***** DotProduct *********************************************************************************************************
;
; Returns the dot product of two vectors
; vector1 goes in xmm0
; vector2 goes in xmm1
; result in xmm0
; 

DotProduct																			macro  
												
												mulps xmm0, xmm1
												movaps xmm1, xmm0
												shufps xmm1, xmm1, 39h
												addss xmm0, xmm1 ;x + y
												shufps xmm1, xmm1, 39h
												addss xmm0, xmm1 ;x+y + z

												endm

;***** DivideVectorByW *********************************************************************************************************
;
; Divides a vector by its w value
; vector goes in xmm0
; 

DivideVectorByW 								macro			
												
												movaps xmm2, xmm0 ; store vector here for later
												shufps xmm2, xmm2, 0FFh ;put w in all spots  											
												divps xmm0, xmm2 ; divide by length  								
																							
												endm

;***** ExtractXYZ *********************************************************************************************************
;
; Extracts x, y and z value from a packed vector
; vector goes in xmm0
; xmm1 will hold x
; xmm2 will hold y
; xmm3 will hold z

ExtractXYZ  									macro   	
												;Get x value
												movss xmm1, xmm0
												;Get y value
												shufps xmm0, xmm0, 39h
												movss xmm2, xmm0
												;Get z value
												shufps xmm0, xmm0, 39h
												movss xmm3, xmm0

												endm


;***** Calc2DArrayIndex *********************************************************************************************************
;
; Calculates the 1d index for a 2D array given 2 indices
; row index goes in rcx
; column index goes in rdx
; width of 2d array goes in r8
; rax will hold the 1d index

Calc2DArrayIndex																macro  
												mov rax, r8
												mov r8, rdx
												mul rcx ;row index * width
												add rax, r8


												endm

;***** LengthOfVectorFromRegister *********************************************************************************************************
;
; Returns the length of a vector
; vector goes in xmm0
; length is left in xmm1, in all slots

LengthOfVector3FromRegister 					macro			
												
												andps xmm0, xmmword ptr XMMask3 ;Zero w component   											
												mulps xmm0, xmm0 ;v.x*v.x, v.y*v.y, v.z*v.z
												movaps xmm1, xmm0 ; calc length in xmm1
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0 
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0
												shufps xmm0, xmm0, 39h ;move each element one final step
												addps xmm1, xmm0

												sqrtps xmm1, xmm1  								
																							
												endm


;***** LengthOfVectorFromRegister *********************************************************************************************************
;
; Returns the length of a vector
; vector goes in xmm0
; length is left in xmm1, in all slots

LengthOfVectorFromRegister  					macro			
												
												mulps xmm0, xmm0 ;v.x*v.x, v.y*v.y, v.z*v.z, v.w*v.w
												movaps xmm1, xmm0 ; calc length in xmm1
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0 
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0
												shufps xmm0, xmm0, 39h ;move each element one final step
												addps xmm1, xmm0

												sqrtps xmm1, xmm1  								
																							
												endm

;***** LengthOfVectorFromRegister *********************************************************************************************************
;
; Returns the length squared of a vector
; vector goes in xmm0
; length is left in xmm1, in all slots

LengthOfVectorFromRegisterSquared   			macro			
												
												mulps xmm0, xmm0 ;v.x*v.x, v.y*v.y, v.z*v.z, v.w*v.w
												movaps xmm1, xmm0 ; calc length in xmm1
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0 
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0
												shufps xmm0, xmm0, 39h ;move each element one final step
												addps xmm1, xmm0 							
																							
												endm

;***** NormalizeVectorFromRegister *********************************************************************************************************
;
; Normalizes a vector
; vector goes in xmm0
; also leaves length in xmm1

NormalizeVectorFromRegister 					macro			
												
												movaps xmm2, xmm0 ; store vector here for later
												mulps xmm0, xmm0 ;v.x*v.x, v.y*v.y, v.z*v.z, v.w*v.w
												movaps xmm1, xmm0 ; calc length in xmm1
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0 
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0
												shufps xmm0, xmm0, 39h ;move each element one final step
												addps xmm1, xmm0

												sqrtps xmm1, xmm1 

												divps xmm2, xmm1 ; divide by length 
												movaps xmm0, xmm2	
																
																							
												endm


;***** NormalizeVector *********************************************************************************************************
;
; Normalizes a vector
; vector goes in rcx and needs to be stored in 16 byte aligned memory

NormalizeVector 								macro			
												
												movaps xmm0, xmmword ptr [rcx]
												movaps xmm2, xmm0 ; store vector here for later
												mulps xmm0, xmm0 ;v.x*v.x, v.y*v.y, v.z*v.z, v.w*v.w
												movaps xmm1, xmm0 ; calc length in xmm1
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0 
												shufps xmm0, xmm0, 39h ;move each element one step
												addps xmm1, xmm0
												shufps xmm0, xmm0, 39h ;move each element one final step
												addps xmm1, xmm0

												sqrtps xmm1, xmm1 

												divps xmm2, xmm1 ; divide by length 	

												movaps xmmword ptr [rcx], xmm2									
																							
												endm

;***** CalcPerpendicularVector *********************************************************************************************************
;
; Calculates the perpendicular vector to the right for the vector in xmm0
; The new vector is in xmm0
; xmm1 is also used
; 

CalcPerpendicularVector													macro  
												xorps xmm1, xmm1
												subss xmm1, xmm0 ;-x
												movss xmm0, xmm1
												;now switch x and z
												shufps xmm0, xmm0, 0c6h

												endm


;***** Restore_SIMD_registers *********************************************************************************************************
;
; Restores simd registers that are considered non-volatile
;
; 

Restore_SIMD_registers													macro  
												
												;Pop xmm6
												movdqu  xmm15, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												movdqu  xmm14, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												movdqu  xmm13, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												movdqu  xmm12, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												movdqu  xmm11, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)
												
												movdqu  xmm10, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												movdqu  xmm9, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												movdqu  xmm8, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												movdqu  xmm7, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												movdqu  xmm6, xmmword ptr [rsp]
												add 	rsp, sizeof(xmmword)

												endm


;***** Restore_Registers ***********************************************************************************************

												;***** [Declare macro] ************************************************

Restore_Registers								macro 																; Declare macro

												;***** [Process] ******************************************************

												pop 				r15   											; Restore entry R15
												pop 				r14   											; Restore entry R14
												pop 				r13   											; Restore entry R13
												pop 				r12   											; Restore entry R12
												pop 				r11   											; Restore entry R11
												pop 				r10   											; Restore entry R10
												pop 				r9												; Restore entry R9
												pop 				r8												; Restore entry R8
												pop 				rdi   											; Restore entry RDI
												pop 				rsi   											; Restore entry RSI
												pop 				rdx   											; Restore entry RDX
												pop 				rcx   											; Restore entry RCX
												pop 				rbx   											; Restore entry RBX

												;***** [End macro] ****************************************************

												endm  																; End macro declaration


;***** Save_SIMD_registers *********************************************************************************************************
;
; Saves simd registers that are considered non-volatile
;
; 

Save_SIMD_registers															macro  
												
												;Push xmm6
												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm6

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm7

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm8

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm9

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm10

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm11

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm12

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm13

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm14

												sub 	rsp, sizeof(xmmword)
												movdqu  xmmword ptr [rsp], xmm15

												endm

;***** Save_Registers **************************************************************************************************

												;***** [Declare macro] ************************************************

Save_Registers   								macro 																; Declare macro

												;***** [Process] ******************************************************

												push				rbx   											; Save entry RBX
												push				rcx   											; Save entry RCX
												push				rdx   											; Save entry RDX
												push				rsi   											; Save entry RSI
												push				rdi   											; Save entry RDI
												push				r8												; Save entry r8
												push				r9												; Save entry r9
												push				r10   											; Save entry r10
												push				r11   											; Save entry r11
												push				r12   											; Save entry r12
												push				r13   											; Save entry r13
												push				r14   											; Save entry r14
												push				r15   											; Save entry r15

												;***** [End macro] ****************************************************

												endm  																; End macro declaration


;***** ScreenToClipSpaceX *********************************************************************************************************
;
; Converts the value in xmm0 from screen space to clip space
;
; 

ScreenToClipSpaceX															macro  
												mulss xmm0, screenWidthInv
												mulss xmm0, r2
												subss xmm0, r1
												endm

;***** ScreenToClipSpaceY *********************************************************************************************************
;
; Converts the value in xmm0 from screen space to clip space
;
; 

ScreenToClipSpaceY															macro  
												mulss xmm0, screenHeightInv
												mulss xmm0, r2n
												addss xmm0, r1
												endm


;***** TransformVector3FromRegister *********************************************************************************************************
;
; Multiplies a vector with a matrix
; vector goes in xmm2, and matrix goes in rcx
; resulting vector is in xmm2

TransformVector3FromRegister					macro

												;Code from compiled XMVector3Transform function in directxmath
												movaps  xmm0, xmm2
												movaps  xmm1, xmm2
												shufps  xmm0, xmm2, 55h
												mulps   xmm0, xmmword ptr [rcx+10h]
												shufps  xmm1, xmm2, 0
												mulps   xmm1, xmmword ptr [rcx]
												shufps  xmm2, xmm2, 0AAh
												mulps   xmm2, xmmword ptr [rcx+20h]
												addps   xmm0, xmm1
												addps   xmm0, xmm2
												addps   xmm0, xmmword ptr [rcx+30h]
												movaps  xmm2, xmm0
												endm

;***** TransformVectorFromRegister *********************************************************************************************************
;
; Multiplies a vector with a matrix
; vector goes in xmm2, and matrix goes in rcx
; resulting vector is in xmm2

TransformVectorFromRegister 					macro

												;Code from compiled XMVector4Transform function in directxmath
												movaps  xmm3,xmm2
												movaps  xmm0,xmm2
												shufps  xmm0,xmm2,0AAh
												movaps  xmm1,xmm2
												mulps   xmm0,xmmword ptr [rcx+20h]
												shufps  xmm1,xmm2,55h
												mulps   xmm1,xmmword ptr [rcx+10h]
												shufps  xmm3,xmm2,0FFh
												mulps   xmm3,xmmword ptr [rcx+30h]
												shufps  xmm2,xmm2,0
												mulps   xmm2,xmmword ptr [rcx]
												addps   xmm0,xmm3
												addps   xmm1,xmm2
												addps   xmm0,xmm1

												movaps xmm2, xmm0

												endm



;***** TransformVector *********************************************************************************************************
;
; Multiplies a vector with a matrix
; vector goes in rcx, and matrix goes in rdx

TransformVector 								macro

												;Code from compiled XMVector4Transform function in directxmath
												movups  xmm2,xmmword ptr [rcx] 
												movaps  xmm3,xmm2
												movaps  xmm0,xmm2
												shufps  xmm0,xmm2,0AAh
												movaps  xmm1,xmm2
												mulps   xmm0,xmmword ptr [rdx+20h]
												shufps  xmm1,xmm2,55h
												mulps   xmm1,xmmword ptr [rdx+10h]
												shufps  xmm3,xmm2,0FFh
												mulps   xmm3,xmmword ptr [rdx+30h]
												shufps  xmm2,xmm2,0
												mulps   xmm2,xmmword ptr [rdx]
												addps   xmm0,xmm3
												addps   xmm1,xmm2
												addps   xmm0,xmm1

												movups xmmword ptr [rcx], xmm0

												endm


;***** UpdateCurrentPieceMatrix *********************************************************************************************************
;
; Updates the current pice matrix from the currently selected piece type and rotation id 

UpdateCurrentPieceMatrix						macro 		

												;Copies the matrix of the current piece and rotation into the currentPieceMatrix using simd
												;Since the pieces are stored direclty after each other in ememory we can just start from the first one (iMatrix) and 
												; add the piece index multiplied by the length of a piece matrix to get the correct piece 
												
												mov ebx, currentRotationIndex
												mov eax, 16
												mul ebx
												mov ebx, eax
												mov ecx, currentPieceIndex
												mov eax, 64 															;length of a piece matrix with roations
												mul ecx 																;multiply with pieceindex to get the address of the current piece
												add ebx, eax															;add roation index to get rotation of the piece
												lea eax, [iMatrix + ebx]
												vmovdqa xmm0, xmmword ptr [eax]
												lea rax, [currentPieceMatrix]
												vmovdqa xmmword ptr [rax], xmm0

												endm

;***** WinCall *********************************************************************************************************
;
; Every function invoking this macro MUST have a local "holder" variable declared.

												;***** [Declare macro] ************************************************

WinCall  										macro   			call_dest:req, argnames:vararg					; Declare macro

												local   			jump_1, lpointer, numArgs 						; Declare local labels

												;***** [Process] ******************************************************

												numArgs 			= 0   											; Initialize # arguments passed

												for 				argname, <argnames>   							; Loop through each argument passed
													numArgs   		= numArgs + 1 									; Increment local # arguments count
												endm  																; End of FOR looop

												if numArgs lt 4   													; If # arguments passed < 4
													numArgs = 4 														; Set count to 4
												endif 																; End IF

												mov 				holder, rsp   									; Save the entry RSP value

												sub 				rsp, numArgs * 8  								; Back up RSP 1 qword for each parameter passed

												test				rsp, 0Fh  										;
												jz  				jump_1											;
												and 				rsp, 0FFFFFFFFFFFFFFF0h   						; Clear low 4 bits for para alignment
jump_1:
												lPointer			= 0   											; Initialize shadow area @ RSP + 0

												for 				argname, <argnames>   							; Loop through arguments
													if				lPointer gt 24									; If not on argument 0, 1, 2, 3
														mov 			rax, argname  									; Move argument into RAX
														mov 			[ rsp + lPointer ], rax   						; Shadow the next parameter on the stack
													elseif			lPointer eq 0 									; If on argument 0
														mov 			rcx, argname  									; Argument 0 -> RCX
													elseif			lPointer eq 8 									; If on argument 1
														mov 			rdx, argname  									; Argument 1 -> RDX
													elseif			lPointer eq 16									; If on argument 2
														mov 			r8, argname   									; Argument 2 -> R8
													elseif			lPointer eq 24									; If on argument 3
														mov 			r9, argname   									; Argument 3 -> R9
													endif   															; End IF
													lPointer  		= lPointer + 8									; Advance the local pointer by 1 qword
												endm  																; End FOR looop

												call				call_dest 										; Execute call to destination function

												mov 				rsp, holder   									; Reset the entry RSP value

												;***** [End macro] ****************************************************

												endm  																; End macro declaration
