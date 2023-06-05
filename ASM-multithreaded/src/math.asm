;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; DistanceBetweenPointAndLineSegment                                                                                                        -
;                                                                                                                      -
; Calculates the distance between a line segment and a point
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  xmm0: lineVector1, xmm1: lineVector2, xmm3: point                                                                                                         -
; Out: xmm0: the distance, xmm1: the projected point on the line                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

DistanceBetweenPointAndLineSegment				proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers  
												Save_SIMD_Registers                                                      ; Save incoming registers


;float minimum_distance(vec2 v, vec2 w, vec2 p) {
;  // Return minimum distance between line segment vw and point p
;  const float l2 = length_squared(v, w);  // i.e. |w-v|^2 -  avoid a sqrt
;  if (l2 == 0.0) return distance(p, v);   // v == w case
;  // Consider the line extending the segment, parameterized as v + t (w - v).
;  // We find projection of point p onto the line. 
;  // It falls where t = [(p-v) . (w-v)] / |w-v|^2
;  // We clamp t from [0,1] to handle points outside the segment vw.
;  const float t = max(0, min(1, dot(p - v, w - v) / l2));
;  const vec2 projection = v + t * (w - v);  // Projection falls on the segment
;  return distance(p, projection);
;}

												movaps xmm4, xmm0 ;v
												movaps xmm5, xmm1 ;w
												movaps xmm6, xmm2 ;p

												subps xmm1, xmm0
												movaps xmm7, xmm1		;keep w - v here
												movaps xmm0, xmm1
												LengthOfVectorFromRegisterSquared
												movaps xmm8, xmm1 ;l2
												;Calculate t
												;start with dot products
												;p-v
												subps xmm2, xmm4
												movaps xmm0, xmm2
												movaps xmm1, xmm5
												subps xmm1, xmm4
												DotProduct ;dot product now in xmm0
												divss xmm0, xmm8
												;clamp between 0 and 1
												movss xmm1, r1
												minss xmm0, xmm1
												xorps xmm1, xmm1
												maxss xmm0, xmm1
												shufps xmm0, xmm0, 00h ;t is now in all components

												;calculate projection
												mulps xmm0, xmm7 ;t * (w - v)
												andps xmm0, XMMask3 ;set w to 0
												addps xmm0, xmm4 ;v + t * (w - v)
												movaps xmm3, xmm0
												subps xmm0, xmm6
												LengthOfVectorFromRegister
												movaps xmm0, xmm1
												movaps xmm1, xmm3


;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_SIMD_Registers
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

DistanceBetweenPointAndLineSegment				endp                                                                  ; End function

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; LineSegmentsIntersects2D                                                                                                        -
;                                                                                                                      -
; Checks if two lines segments intersect in 2D
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  
;	   All points should be 2d in the lower half of the xmm registers
;	   xmm0: line 1 point 1.
;      xmm1: line 1 point 2                                                                                                         -
;      xmm2: line 2 point 1                                                                                                         -
;      xmm3: line 2 point 2                                                                                                         -
; Out: rax: 1 if linesegments intersects, 0 otherwise                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------



;
;float s1_x, s1_y, s2_x, s2_y;
;    s1_x = p1_x - p0_x;     s1_y = p1_y - p0_y;
;    s2_x = p3_x - p2_x;     s2_y = p3_y - p2_y;
;
;    float s, t;
;    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
;    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);
;
;    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
;    {
;        // Collision detected
;        if (i_x != NULL)
;            *i_x = p0_x + (t * s1_x);
;        if (i_y != NULL)
;            *i_y = p0_y + (t * s1_y);
;        return 1;
;    }
;
;    return 0; // No collision
;
;
LineSegmentsIntersects2D						proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers
												Save_SIMD_Registers

												;segment 1
												movaps xmm5, xmm1
												subps xmm5, xmm0
												;segment 2
												movaps xmm6, xmm3
												subps xmm6, xmm2

												;calc determinant (-s2_x * s1_y + s1_x * s2_y)
												movss xmm8, r1n
												movaps xmm7, xmm6
												mulss xmm7, xmm8 ;negate xvalue of segment 2 copy
												shufps xmm7, xmm7, 0c6h ;swap x and z, we are using x and z instead of x and y 
												mulps xmm7, xmm5 
												movss xmm8, xmm7 
												shufps xmm7, xmm7, 0c6h ;swap x and z
												;add x and y
												addss xmm7, xmm8 ;this now holds the determinant

												xor rax, rax
												movss xmm1, xmm7
												andps xmm1, xmmword ptr [XMMaskAbs]
												comiss xmm1, r0000001 ;if it's very close to zero thet do not intersect
												jb Return

												;calc s ((-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y))/determinant)
												;Start with p0 - p2
												movaps xmm8, xmm0
												subps xmm8, xmm2
												;negate s1_y and swap it with x
												movaps xmm9, xmm5
												shufps xmm9, xmm9, 0c6h ;swap x and z
												movss xmm10, r1n
												mulss xmm9, xmm10
												mulps xmm9, xmm8
												movss xmm10, xmm9
												shufps xmm9, xmm9, 0c6h ;swap x and z
												addss xmm9, xmm10 
												divss xmm9, xmm7 ;this is s
												xorps xmm10, xmm10
												comiss xmm9, xmm10
												jb Return
												comiss xmm9, r1
												ja Return

												;calc t (( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x))/determinant)												
												;swap x and y in s2
												movaps xmm9, xmm6
												shufps xmm9, xmm9, 0c6h ;swap x and z
												mulps xmm9, xmm8
												movss xmm10, xmm9
												shufps xmm9, xmm9, 0c6h ;swap x and z
												subss xmm9, xmm10 ;x - y
												divss xmm9, xmm7 ;this is t
												xorps xmm10, xmm10
												comiss xmm9, xmm10
												jb Return
												comiss xmm9, r1
												ja Return

												mov rax, 1


;-----[Zero final return]----------------------------------------------


;------[Restore incoming registers]-------------------------------------------------------------------------------------
Return:
												align               qword                                             ; Set qword alignment
												Restore_SIMD_Registers
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

LineSegmentsIntersects2D						endp                                                                  ; End function


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; RotateRotationVectorWithAngle                                                                                                        -
;                                                                                                                      -
; Rotates a rotation vector by a given angle in radians
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  xmm0, rotation vector. xmm1, angle in radians                                                                                                         -
; Out: xmm0, new vector value                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

RotateRotationVectorWithAngle					proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers
												Save_SIMD_Registers

												
												mulss xmm1, r1n ;algorithm is for rotating anti clock-wise and we want clock-wise. And I am too tired to any other change to achieve this

												movaps xmm6, xmm0
												movss xmm7, xmm1
												;calc sin and cos of the angle
												movss xmm0, xmm7
												WinCall sinf
												movss xmm8, xmm0
												movss xmm0, xmm7
												WinCall cosf
												movss xmm9, xmm0

												movss xmm2, xmm6 ;get x value
												shufps xmm6, xmm6, 0c6h ;swap x and z
												movss xmm3, xmm6 ;get z value
												;calc new y value
												movss xmm0, xmm2
												mulss xmm0, xmm8 ; x1 * sin
												movss xmm1, xmm3
												mulss xmm1, xmm9 ; z1 * cos
												addss xmm0, xmm1 
												movss xmm6, xmm0 
												shufps xmm6, xmm6, 0c6h ;swap x and z
												;calc new x value
												movss xmm0, xmm2
												mulss xmm0, xmm9 ; x1 * cos
												movss xmm1, xmm3
												mulss xmm1, xmm8 ; z1 * sin
												subss xmm0, xmm1 
												movss xmm6, xmm0 

												movaps xmm0, xmm6

												
;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_SIMD_Registers
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

RotateRotationVectorWithAngle					endp                                                                  ; End function


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; PointInRectangle2D                                                                                                        -
;                                                                                                                      -
; Checks if point lies inside a rectangle in 2 dimensions
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  xmm0, point. xmm1 v1. xmm2 v2. xmm3 v3 xmm4 v4                                                                                                         -
; Out: rax 1 if point is inside rectangle, 0 otherwise                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

PointInRectangle2D								proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers
												Save_SIMD_Registers
												
												movaps xmm6, xmm0
												movaps xmm7, xmm1
												movaps xmm8, xmm2
												movaps xmm9, xmm3
												movaps xmm10, xmm4

												xorps xmm11, xmm11 ;keep area of triangles here

												;calc area of rectangle
												movaps xmm0, xmm7
												movaps xmm1, xmm8
												movaps xmm2, xmm9
												movaps xmm3, xmm10

												LocalCall AreaOf4SidedPolygon
												movss xmm12, xmm0
												
												;calc area of the triangles of the point and the edges of the rectangle
												;P v1 v2
												movaps xmm0, xmm6 
												movaps xmm1, xmm7 
												movaps xmm2, xmm8
												LocalCall AreaOf3SidedPolygon
												addss xmm11, xmm0
												
												;P v2 v3
												movaps xmm0, xmm6 
												movaps xmm1, xmm8 
												movaps xmm2, xmm9
												LocalCall AreaOf3SidedPolygon
												addss xmm11, xmm0
												
												;P v3 v4
												movaps xmm0, xmm6 
												movaps xmm1, xmm9 
												movaps xmm2, xmm10
												LocalCall AreaOf3SidedPolygon
												addss xmm11, xmm0
												
												;P v4 v1
												movaps xmm0, xmm6 
												movaps xmm1, xmm10 
												movaps xmm2, xmm7
												LocalCall AreaOf3SidedPolygon
												addss xmm11, xmm0

												
												mov rax, 1

												subss xmm11, xmm12
												movss xmm0, r01
												comiss xmm11, xmm0
												jb Return

;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------
Return:
												align               qword                                             ; Set qword alignment
												Restore_SIMD_Registers
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

PointInRectangle2D								endp                                                                  ; End function


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; AreaOf4SidedPolygon                                                                                                        -
;                                                                                                                      -
; Calculates the area of a polygon with 4 sides in 2 Dimensions
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  xmm0 p1, xmm1 p2, xmm2 p3, xmm3 p4. will use x and z                                                                                                        -
; Out: xmm0 area in x spot                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

AreaOf4SidedPolygon								proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers
												Save_SIMD_Registers
												
												movaps xmm5, xmm0
												movaps xmm6, xmm1
												movaps xmm7, xmm2
												movaps xmm8, xmm3

												;y is z
												;x1y2-y1x2
												movaps xmm1, xmm5 ;p1
												movaps xmm2, xmm6 ;p2
												shufps xmm2, xmm2, 0c6h ; swap x and z
												mulps xmm1, xmm2 ;x1y2 in x spot and y1x2 in z spot
												movss xmm0, xmm1 ;x1y2
												shufps xmm1, xmm1, 0c6h
												subss xmm0, xmm1 ;x1y2-y1x2

												;x2y3-y2x3
												movaps xmm1, xmm6 ;p2
												movaps xmm2, xmm7 ;p3
												shufps xmm2, xmm2, 0c6h ; swap x and z
												mulps xmm1, xmm2 ;x2y3 in x spot and y2x3 in z spot
												movss xmm3, xmm1 ;x2y3
												shufps xmm1, xmm1, 0c6h
												subss xmm3, xmm1 ;x2y3-y2x3
												addss xmm0, xmm3

												;x3y4-y3x4
												movaps xmm1, xmm7 ;p3
												movaps xmm2, xmm8 ;p4
												shufps xmm2, xmm2, 0c6h ; swap x and z
												mulps xmm1, xmm2 ;x3y4 in x spot and y3x4 in z spot
												movss xmm3, xmm1 ;x3y4
												shufps xmm1, xmm1, 0c6h
												subss xmm3, xmm1 ;x3y4-y3x4
												addss xmm0, xmm3
												
												;x4y1-y4x1
												movaps xmm1, xmm8 ;p4
												movaps xmm2, xmm5 ;p1
												shufps xmm2, xmm2, 0c6h ; swap x and z
												mulps xmm1, xmm2 ;x4y1 in x spot and y4x1 in z spot
												movss xmm3, xmm1 ;x4y1
												shufps xmm1, xmm1, 0c6h
												subss xmm3, xmm1 ;x4y1-y4x1
												addss xmm0, xmm3

												movss xmm1, r05
												mulss xmm0, xmm1
												Abs

;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_SIMD_Registers
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

AreaOf4SidedPolygon								endp                                                                  ; End function


;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; AreaOf3SidedPolygon                                                                                                        -
;                                                                                                                      -
; Calculates the area of a polygon with 3 sides in 2 Dimensions
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  xmm0 p1, xmm1 p2, xmm2 p3. will use x and z                                                                                                        -
; Out: xmm0 area in x spot                                                                                                                        -
; 
;-----------------------------------------------------------------------------------------------------------------------

AreaOf3SidedPolygon								proc                                                                  ; Declare function
;------[Local Data]-----------------------------------------------------------------------------------------------------
												local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------
												Save_Registers                                                        ; Save incoming registers
												Save_SIMD_Registers
												
												movaps xmm5, xmm0
												movaps xmm6, xmm1
												movaps xmm7, xmm2

												;y is z
												;x1y2-y1x2
												movaps xmm1, xmm5 ;p1
												movaps xmm2, xmm6 ;p2
												shufps xmm2, xmm2, 0c6h ; swap x and z
												mulps xmm1, xmm2 ;x1y2 in x spot and y1x2 in z spot
												movss xmm0, xmm1 ;x1y2
												shufps xmm1, xmm1, 0c6h
												subss xmm0, xmm1 ;x1y2-y1x2

												;x2y3-y2x3
												movaps xmm1, xmm6 ;p2
												movaps xmm2, xmm7 ;p3
												shufps xmm2, xmm2, 0c6h ; swap x and z
												mulps xmm1, xmm2 ;x2y3 in x spot and y2x3 in z spot
												movss xmm3, xmm1 ;x2y3
												shufps xmm1, xmm1, 0c6h
												subss xmm3, xmm1 ;x2y3-y2x3
												addss xmm0, xmm3												
												
												;x3y1-y3x1
												movaps xmm1, xmm7 ;p3
												movaps xmm2, xmm5 ;p1
												shufps xmm2, xmm2, 0c6h ; swap x and z
												mulps xmm1, xmm2 ;x3y1 in x spot and y3x1 in z spot
												movss xmm3, xmm1 ;x3y1
												shufps xmm1, xmm1, 0c6h
												subss xmm3, xmm1 ;x3y1-y3x1
												addss xmm0, xmm3

												movss xmm1, r05
												mulss xmm0, xmm1
												Abs

;-----[Zero final return]----------------------------------------------

												xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align               qword                                             ; Set qword alignment
												Restore_SIMD_Registers
												Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

ret                                                                   ; Return to caller

AreaOf3SidedPolygon								endp                                                                  ; End function
