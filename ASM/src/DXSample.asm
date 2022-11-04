
;-----------------------------------------------------------------------------------------------------------------------
;
; DXSample
;
; Traffic simulation game.

;----- [Declare data segment] ------------------------------------------------------------------------------------------

												.data 																	; Declare data segment

;----- [Data file includes] --------------------------------------------------------------------------------------------

												 include			macros.asm										; Macros first for subsequent ainclude defs

												;----- The ainclude macro is simply an 'align qword' statement
												;  	followed by 'include.'  It's a redundant precaution in most
												;  	cases, ensuring that qword alignment persists as much as
												;  	possible within static data.

												ainclude			wincons.asm   									; Windows constants
												ainclude			constants.asm 									; App-local constants
												ainclude			structuredefs.asm 								; Structure definitions

												ainclude			buffers.asm   									; String buffers
												ainclude			lookups.asm   									; Lookup lists
												ainclude			riid.asm  										; RIID values
												ainclude			routers.asm   									; Router lists
												ainclude			strings.asm   									; Constant strings
												ainclude			structures.asm									; Data structures
												ainclude			variables.asm 									; Data variables
												ainclude			vtables.asm   									; COM vTable declarations
												ainclude			blueBee.asm
												ainclude			yellowBee.asm
												ainclude			font_characters.asm
												ainclude			data.asm
											  
;----- [Declare block starting symbol segment] ------------------------------------------------------------------------------------------
												_data? segment align(64)
												include 			uninitializedData.asm 			

												_data? ends

;----- [Declare code segment] ------------------------------------------------------------------------------------------

												.code 																; Declare code segment

;----- [Code file includes] --------------------------------------------------------------------------------------------

												ainclude			externals.asm 									; External function declarations

												ainclude			callbacks.asm 									; Callback functions
												ainclude			common.asm										; Common functions
												ainclude			diagnostics.asm   								; Diagnostic functions
												ainclude			general.asm   									; General
												ainclude			renderer.asm
												ainclude			boundingBoxUtils.asm
												ainclude			debugUtils.asm
												ainclude			utils.asm
												ainclude			math.asm
												ainclude			textUtils.asm
												ainclude			beeLogic.asm

;-----------------------------------------------------------------------------------------------------------------------
;                                                  																	-
; Windows entry point                              																	-
;                                                  																	-
;-----------------------------------------------------------------------------------------------------------------------

Startup  										proc  																; Declare function

												local   			holder:qword  									;

;----- [Fix the WinDbg bug] --------------------------------------------------------------------------------------------

												LocalCall   		FixWinDbg 										; Execute call

												;-----[Setup the main window]------------------------------------------

												LocalCall   		SetupMainWindow   								; Setup the main window
												mov 				Main_Handle, rax  								; Save the main window handle

												
												lea 				rcx, rawInputMouse
												mov 				rdx, 1
												mov 				r8, sizeof(RawInputDevice)
												WinCall 			RegisterRawInputDevices, rcx, rdx, r8
												

												;-----[Setup DirectX]--------------------------------------------------

												LocalCall   		SetupDirectX  									; Setup DirectX
												LocalCall   		InitText
												

												mov team1NumberOfBees, 0
												mov team2NumberOfBees, 0
												LocalCall   		ClearBees

												;Back quad
												xorps xmm0, xmm0
												movss xmm9, r1000
												subss xmm0, xmm9
												xorps xmm1, xmm1
												movss xmm9, r500
												subss xmm1, xmm9

												movss xmm2, r500
												movss xmm3, r1

												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB
												movss xmm7, r1

												movss xmm10, r0
												movss xmm11, r0

												movss real4 ptr [vQuads+0 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+0 + quad_vertex.y], xmm1
												movss real4 ptr [vQuads+0 + quad_vertex.z], xmm2
												movss real4 ptr [vQuads+0 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+0 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+0 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+0 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+0 + quad_vertex.ca], xmm7
												movss real4 ptr [vQuads+0 + quad_vertex.u], xmm10
												movss real4 ptr [vQuads+0 + quad_vertex.v], xmm11


												

												movss xmm0, r1000
												xorps xmm1, xmm1
												movss xmm9, r500
												subss xmm1, xmm9

												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB

												movss xmm10, r1
												movss xmm11, r0

												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.y], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.z], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.ca], xmm7
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.u], xmm10
												movss real4 ptr [vQuads+sizeof(quad_vertex) + quad_vertex.v], xmm11

												movss xmm0, r1000
												movss xmm1, r500

												movss xmm4, skyQuadHighR
												movss xmm5, skyQuadHighG
												movss xmm6, skyQuadHighB
																							  
												movss xmm10, r1
												movss xmm11, r1

												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.y], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.z], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.ca], xmm7
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.u], xmm10
												movss real4 ptr [vQuads+sizeof(quad_vertex)*2 + quad_vertex.v], xmm11

												
												xorps xmm0, xmm0
												movss xmm9, r1000
												subss xmm0, xmm9
												xorps xmm1, xmm1
												movss xmm9, r500
												subss xmm1, xmm9

												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB
												
												movss xmm10, r0
												movss xmm11, r0

												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.y], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.z], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.ca], xmm7
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.u], xmm10
												movss real4 ptr [vQuads+sizeof(quad_vertex)*3 + quad_vertex.v], xmm11


												
												movss xmm0, r1000
												movss xmm1, r500

												movss xmm4, skyQuadHighR
												movss xmm5, skyQuadHighG
												movss xmm6, skyQuadHighB
												
												movss xmm10, r1
												movss xmm11, r1

												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.y], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.z], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.ca], xmm7
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.u], xmm10
												movss real4 ptr [vQuads+sizeof(quad_vertex)*4 + quad_vertex.v], xmm11

												
												xorps xmm0, xmm0
												movss xmm9, r1000
												subss xmm0, xmm9
												movss xmm1, r500


												movss xmm4, skyQuadHighR
												movss xmm5, skyQuadHighG
												movss xmm6, skyQuadHighB

												movss xmm10, r0
												movss xmm11, r1

												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.y], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.z], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.ca], xmm7
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.u], xmm10
												movss real4 ptr [vQuads+sizeof(quad_vertex)*5 + quad_vertex.v], xmm11

												
												;Bottom quad
												xorps xmm0, xmm0
												movss xmm9, r2000
												subss xmm0, xmm9
												xorps xmm1, xmm1
												movss xmm9, r500
												subss xmm1, xmm9

												movss xmm2, r500n
												movss xmm3, r1

												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB
												movss xmm7, r1

												movss real4 ptr [vQuads+sizeof(quad_vertex)*6 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*6 + quad_vertex.y], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*6 + quad_vertex.z], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*6 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*6 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*6 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*6 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*6 + quad_vertex.ca], xmm7

												movss xmm0, r2000
												xorps xmm1, xmm1
												movss xmm9, r500
												subss xmm1, xmm9

												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB

												movss real4 ptr [vQuads+sizeof(quad_vertex)*7 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*7 + quad_vertex.y], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*7 + quad_vertex.z], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*7 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*7 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*7 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*7 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*7 + quad_vertex.ca], xmm7

												movss xmm0, r2000
												movss xmm1, r500

												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB											


												movss real4 ptr [vQuads+sizeof(quad_vertex)*8 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*8 + quad_vertex.y], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*8 + quad_vertex.z], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*8 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*8 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*8 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*8 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*8 + quad_vertex.ca], xmm7

												
												xorps xmm0, xmm0
												movss xmm9, r2000
												subss xmm0, xmm9
												xorps xmm1, xmm1
												movss xmm9, r500
												subss xmm1, xmm9

												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB

												movss real4 ptr [vQuads+sizeof(quad_vertex)*9 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*9 + quad_vertex.y], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*9 + quad_vertex.z], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*9 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*9 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*9 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*9 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*9 + quad_vertex.ca], xmm7


												
												movss xmm0, r2000
												movss xmm1, r500

												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB

												movss real4 ptr [vQuads+sizeof(quad_vertex)*10 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*10 + quad_vertex.y], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*10 + quad_vertex.z], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*10 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*10 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*10 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*10 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*10 + quad_vertex.ca], xmm7

												
												xorps xmm0, xmm0
												movss xmm9, r2000
												subss xmm0, xmm9
												movss xmm1, r500


												movss xmm4, skyQuadLowR
												movss xmm5, skyQuadLowG
												movss xmm6, skyQuadLowB

												movss real4 ptr [vQuads+sizeof(quad_vertex)*11 + quad_vertex.x], xmm0
												movss real4 ptr [vQuads+sizeof(quad_vertex)*11 + quad_vertex.y], xmm2
												movss real4 ptr [vQuads+sizeof(quad_vertex)*11 + quad_vertex.z], xmm1
												movss real4 ptr [vQuads+sizeof(quad_vertex)*11 + quad_vertex.w], xmm3
												movss real4 ptr [vQuads+sizeof(quad_vertex)*11 + quad_vertex.cr], xmm4
												movss real4 ptr [vQuads+sizeof(quad_vertex)*11 + quad_vertex.cg], xmm5
												movss real4 ptr [vQuads+sizeof(quad_vertex)*11 + quad_vertex.cb], xmm6
												movss real4 ptr [vQuads+sizeof(quad_vertex)*11 + quad_vertex.ca], xmm7


											
												;-----[Setup Instances]------------------------------------------------
												; LocalCall   		SetupInstances


												; xorps xmm0, xmm0
												; subss xmm0, rFive
												; movss xmm1, rTen
;
												; movss real4 ptr [nodeXPos + 4* sizeof(real4)], xmm0
												; movss real4 ptr [nodeZPos + 4*sizeof(real4)], xmm1
												;
												;mov nextNodeIndex, 5
												; 
												; mov rcx, 3
												; mov rdx, 4
												; mov r8, nextRoadVertexIndex
												; LocalCall   		SetupStraightRoad2Nodes
;
												; mov nextRoadVertexIndex, rax

											  
												;-----[Run the message loopo]------------------------------------------

												LocalCall   		RunMessageLoop									; Run the message loop

												;-----[Terminate the application]--------------------------------------

												; xor 				rcx, rcx  										; Set final return code
												; call				ExitProcess   									; Exit this process
												xor					rax, rax
												ret
Startup  										endp  																; End startup function

												end   																; End module
