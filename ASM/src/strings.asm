
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; String constants.                                                                                                    -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

;-----[A]---------------------------------------------------------------------------------------------------------------

;-----[B]---------------------------------------------------------------------------------------------------------------

;-----[C]---------------------------------------------------------------------------------------------------------------
    

color_string                                     byte                'COLOR', 0                                        ;
command_str                                      byte                'COMMAND',0                                       ;
comma_str                                        byte                ' , ',0                                       ;

;-----[D]---------------------------------------------------------------------------------------------------------------

;-----[E]---------------------------------------------------------------------------------------------------------------

effect_file                                      word                'E','f','f','e','c','t','s','.','f','x',0                                   ;

;-----[F]---------------------------------------------------------------------------------------------------------------

fps_str                                    byte                'FPS: ',0                                        ;
;-----[G]---------------------------------------------------------------------------------------------------------------


gsTerrain_function                               byte                'GS_TerrainNormals', 0                                           ;
gsBillboard_function                             byte                'GS_Billboard', 0                                           ;
gs_profile                                       byte                'gs_4_0', 0                                       ;

;-----[H]---------------------------------------------------------------------------------------------------------------

heightmap_file                                   byte                'heightmap.bmp', 0   

;-----[I]---------------------------------------------------------------------------------------------------------------

i16_name                                         byte                'I16_RESOURCE', 0                                 ;
instance_position_string                         byte                'INSTANCEPOSITION', 0
instance_rotation_string                         byte                'INSTANCEROTATION', 0
instance_light_state_string                      byte                'INSTANCELIGHTSTATE', 0

;-----[J]---------------------------------------------------------------------------------------------------------------

;-----[K]---------------------------------------------------------------------------------------------------------------

;-----[L]---------------------------------------------------------------------------------------------------------------

length_string                                    byte                'LENGTH',0

;-----[M]---------------------------------------------------------------------------------------------------------------

main_classname                                   byte                'DXSampleClass', 0                                ;
main_winname                                     byte                'Bee combat asm', 0                  ;
memory_str                                       byte                'MEMORY',0                                        ;
money_str                                        byte                'Money: ',0                                        ;
mouse_pos_str                                    byte                'Mouse pos: ',0                                        ;

;-----[N]---------------------------------------------------------------------------------------------------------------
normal_string                                    byte                'NORMAL', 0

;-----[O]---------------------------------------------------------------------------------------------------------------

occupied_parking_str                             byte                'Occupied parking spots: ', 0


;-----[P]---------------------------------------------------------------------------------------------------------------

position_string                                  byte                'VERTEXPOSITION', 0                                     ;
ps_function                                      byte                'PS', 0                                           ;
ps_function_lines                                byte                'PSLines', 0                                           ;
ps_function_points                               byte                'PSPoints', 0                                           ;
ps_function_road                                 byte                'PSRoad', 0                                           ;
ps_function_quads                                byte                'PSQuads', 0                                           ;
ps_function_preview                              byte                'PSPreview', 0                                           ;
ps_function_texture2d                            byte                'PS2DTexture', 0                                           ;
ps_profile                                       byte                'ps_4_0', 0                                       ;

;-----[Q]---------------------------------------------------------------------------------------------------------------

;-----[R]---------------------------------------------------------------------------------------------------------------

read_binary                                      byte                'rb', 0   
reg_str                                          byte                'REGISTERS',0                                     ;

;-----[S]---------------------------------------------------------------------------------------------------------------

selected_string                                  byte                'selected ',0

;-----[T]---------------------------------------------------------------------------------------------------------------

test_string                                      byte                'C# is a script language ', 0

textcoord0_string                                byte                'TEXCOORD',0
time_string                                      byte                'time: ', 0
type_string                                      byte                'TYPE', 0                                     ;


;-----[U]---------------------------------------------------------------------------------------------------------------

;-----[V]---------------------------------------------------------------------------------------------------------------

vs_function                                      byte                'VS', 0                                           ;
vs_function_cars                                 byte                'VSCars', 0
vs_function_squares                              byte                'VSDebugSquares', 0
vs_function_lines                                byte                'VSLines', 0
vs_function_font                                 byte                'VSFont', 0
vs_function_malls                                byte                'VSMalls', 0
vs_function_mall_preview                         byte                'VSMallPreview', 0
vs_function_points                               byte                'VSPoints', 0
vs_function_quads                                byte                'VSQuads', 0
vs_function_preview                              byte                'VSPreview', 0                                           ;
vs_function_terrain                              byte                'VSTerrain', 0                                           ;
vs_function_texture2d                            byte                'VS2DTexture', 0                                           ;
vs_function_traffic_light                        byte                'VSTrafficLight', 0                                           ;
vs_function_water                                byte                'VSWater', 0                                           ;
vs_profile                                       byte                'vs_4_0', 0                                       ;

;-----[W]---------------------------------------------------------------------------------------------------------------

watch_str                                        byte                'WATCH',0                                         ;
write_binary                                     byte                'wb', 0   

;-----------------------------------------------------------------------------------------------------------------------
win_id                                           qword               ( win_ide - win_ids )                             ;
                                                ;-----------------------------------------------------------------------
win_ids                                          byte                'WinDbg 10.0.16299.15 AMD64',0                    ;
                                                ;-----------------------------------------------------------------------
win_ide                                          label               byte                                              ;
;-----------------------------------------------------------------------------------------------------------------------

;-----[X]---------------------------------------------------------------------------------------------------------------

;-----[Y]---------------------------------------------------------------------------------------------------------------

;-----[Z]---------------------------------------------------------------------------------------------------------------
