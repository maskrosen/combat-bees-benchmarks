
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; ClipRayByBoundingBox                                                                                                          -
;                                                                                                                      -
; This function assumes second point defining the ray is outside the game bounding box
; This function will edit the point to the furthest away point on the ray that is inside the bounding box
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  rcx point0                                                                                                 -
;      rdx point1                                                                                                                -
;                                                                                                                      -
; Strores result in point1
;-----------------------------------------------------------------------------------------------------------------------

ClipRayByBoundingBox                            proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                Save_Registers                                                        ; Save incoming registers
                                                

                                                ;xmm10 length to x plane
                                                ;xmm11 length to y plane
                                                ;xmm12 length to z plane
                                                movss xmm10, r1000000
                                                movss xmm11, r1000000
                                                movss xmm12, r1000000

                                                movaps xmm4, xmmword ptr[rdx] ;xmm4 now hold the end point (P1)
                                                movaps xmm0, xmm4
                                                movaps xmm1, xmmword ptr[rcx]
                                                movaps xmm6, xmm1 ;xmm6 now holds start point (P0)
                                                ;Calc vector to represent ray
                                                subps xmm0, xmm1 
                                                NormalizeVectorFromRegister
                                                movaps xmm5, xmm0
                                                ;xmm5 now holds the direction vector of the ray
                                                
                                                ;Check if point is on right side of right x plane
                                                movss xmm2, worldBoundBoxXRight 
                                                comiss xmm4, xmm2
                                                jbe Skip_Right_X_Plane
                                                ;Point is on right side of right x plane
                                                ;Calculate the distance to the intersection point in the plane
                                                subss xmm2, xmm6 ;C - X0
                                                divss xmm2, xmm0 ;(C - X0)/Xd
                                                movss xmm10, xmm2
                                                jmp Skip_Left_X_Plane ;we can skip left here since we are outside right

Skip_Right_X_Plane:
                                                movss xmm2, worldBoundBoxXLeft
                                                comiss xmm4, xmm2 ;Check if point is on left side of left x plane
                                                jae Skip_Left_X_Plane
                                                ;Point is on left side of left x plane
                                                ;Calculate the distance to the intersection point in the plane
                                                subss xmm2, xmm6 ;C - X0
                                                divss xmm2, xmm5 ;(c - X0)/Xd
                                                movss xmm10, xmm2

Skip_Left_X_Plane:

                                                ;Check if point is on upper side of top y plane
                                                movss xmm2, worldBoundBoxYTop
                                                movaps xmm0, xmm4
                                                shufps xmm0, xmm0, 055h;set Y in all positions 
                                                comiss xmm0, xmm2
                                                jbe Skip_Top_Y_Plane
                                                ;Point is on upper side of top y plane
                                                ;Calculate the distance to the intersection point in the plane
                                                movaps xmm0, xmm6
                                                shufps xmm0, xmm0, 055h;set Y in all positions 
                                                subss xmm2, xmm0 ;C - Y0
                                                xorps xmm0, xmm0
                                                movaps xmm1, xmm5
                                                shufps xmm1, xmm1, 055h;set Y in all positions 
                                                divss xmm2, xmm1 ;(C - Y0)/Yd
                                                movss xmm11, xmm2
                                                jmp Skip_Bottom_Y_Plane ;we can skip bittom here since we are outside top

Skip_Top_Y_Plane:
                                                ;Check if point is on upper side of top y plane
                                                movss xmm2, worldBoundBoxYBottom
                                                movaps xmm0, xmm4
                                                shufps xmm0, xmm0, 055h;set Y in all positions 
                                                comiss xmm0, xmm2
                                                jae Skip_Bottom_Y_Plane
                                                ;Point is on upper side of top y plane
                                                ;Calculate the distance to the intersection point in the plane
                                                movaps xmm0, xmm6
                                                shufps xmm0, xmm0, 055h;set Y in all positions 
                                                subss xmm2, xmm0 ;-Y0
                                                xorps xmm0, xmm0
                                                movaps xmm1, xmm5
                                                shufps xmm1, xmm1, 055h;set Y in all positions Yd
                                                divss xmm2, xmm1 ;-Y0/Yd
                                                movss xmm11, xmm2

Skip_Bottom_Y_Plane:


                                                ;Check if point is behind the back z plane
                                                movss xmm2, worldBoundBoxZBack
                                                movaps xmm0, xmm4
                                                shufps xmm0, xmm0, 0AAh;set Z in all positions 
                                                comiss xmm0, xmm2
                                                jbe Skip_Back_Z_Plane
                                                ;Point is behind back z plane
                                                ;Calculate the distance to the intersection point in the plane
                                                movaps xmm0, xmm6
                                                shufps xmm0, xmm0, 0AAh;set Z in all positions 
                                                subss xmm2, xmm0 ;C - Z0
                                                xorps xmm0, xmm0
                                                movaps xmm1, xmm5
                                                shufps xmm1, xmm1, 0AAh;set Z in all positions 
                                                divss xmm2, xmm1 ; (C - Z0)/Zd
                                                movss xmm12, xmm2
                                                jmp Skip_Front_Z_Plane ;we can skip bittom here since we are outside top

Skip_Back_Z_Plane:
                                                ;Check if point is behind the back z plane
                                                movss xmm2, worldBoundBoxZFront
                                                movaps xmm0, xmm4
                                                shufps xmm0, xmm0, 0AAh;set Z in all positions 
                                                comiss xmm0, xmm2
                                                jae Skip_Front_Z_Plane
                                                ;Point is behind back z plane
                                                ;Calculate the distance to the intersection point in the plane
                                                movaps xmm0, xmm6
                                                shufps xmm0, xmm0, 0AAh;set Z in all positions 
                                                subss xmm2, xmm0 ;C - Z0
                                                xorps xmm0, xmm0
                                                movaps xmm1, xmm5
                                                shufps xmm1, xmm1, 0AAh;set Z in all positions 
                                                divss xmm2, xmm1 ;(C-Z0)/Zd
                                                movss xmm12, xmm2

Skip_Front_Z_Plane:


                                                ;Now check which length is shortest (in xmm10, xmm11, xmm12) and use that to calculate new point
                                                ;Use the absolute value of the lengths when comparing
                                                xorps xmm13, xmm13
                                                subss xmm13, xmm10
                                                maxss xmm13, xmm10

                                                xorps xmm14, xmm14
                                                subss xmm14, xmm11
                                                maxss xmm14, xmm11

                                                xorps xmm15, xmm15
                                                subss xmm15, xmm12
                                                maxss xmm15, xmm12

                                                comiss xmm13, xmm14
                                                jae Bounding_Box_Test_Y; x is larger than y
                                                comiss xmm13, xmm15
                                                jae Bounding_Box_Test_Y; x is larger than z
                                                ;x is smallest
                                                movss xmm0, xmm10
                                                jmp Bounding_Box_Calc_New_Point
Bounding_Box_Test_Y:
                                                ;x is larger than y or z, the smallest one of these is the smallest
                                                comiss xmm14, xmm15
                                                ja Bounding_Box_Y_Larger
                                                ;y is smallest
                                                movss xmm0, xmm11
                                                jmp Bounding_Box_Calc_New_Point

Bounding_Box_Y_Larger:
                                                ;z is smallest
                                                movss xmm0, xmm12
Bounding_Box_Calc_New_Point:                    
                                                ;Calc new point
                                                shufps xmm0, xmm0, 0h
                                                mulps xmm5, xmm0
                                                addps xmm5, xmm6;final point
                                                ;Store in p1 pointer
                                                movaps xmmword ptr[rdx], xmm5

                                                ;-----[Zero final return]----------------------------------------------

                                                xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                align               qword                                             ; Set qword alignment
                                                Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                ret                                                                   ; Return to caller

ClipRayByBoundingBox                            endp                                                                  ; End function
