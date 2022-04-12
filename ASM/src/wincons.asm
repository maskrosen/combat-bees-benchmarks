
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Windows constants.                                                                                                   -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

;-----[A] --------------------------------------------------------------------------------------------------------------

;-----[B] --------------------------------------------------------------------------------------------------------------

;-----[C] --------------------------------------------------------------------------------------------------------------

cs_vredraw                                       equ                 00000001h
cs_hredraw                                       equ                 00000002h
cs_dblclks                                       equ                 00000008h
cs_owndc                                         equ                 00000020h
cs_classdc                                       equ                 00000040h
cs_parentdc                                      equ                 00000080h
cs_noclose                                       equ                 00000200h
cs_savebits                                      equ                 00000800h
cs_bytealignclient                               equ                 00001000h
cs_bytealignwindow                               equ                 00002000h
cs_globalclass                                   equ                 00004000h
cs_ime                                           equ                 00010000h
cs_dropshadow                                    equ                 00020000h

;-----[D]---------------------------------------------------------------------------------------------------------------

d3d_driver_type_unknown                          equ                 0                                                 ;
d3d_driver_type_hardware                         equ                 d3d_driver_type_unknown + 1                       ;
d3d_driver_type_reference                        equ                 d3d_driver_type_hardware + 1                      ;
d3d_driver_type_null                             equ                 d3d_driver_type_reference + 1                     ;
d3d_driver_type_software                         equ                 d3d_driver_type_null + 1                          ;
d3d_driver_type_warp                             equ                 d3d_driver_type_software + 1                      ;

d3d11_bind_constant_buffer                       equ                 00000004h                                         ;
d3d11_bind_decoder                               equ                 00000200h                                         ;
d3d11_bind_depth_stencil                         equ                 00000040h                                         ;
d3d11_bind_index_buffer                          equ                 00000002h                                         ;
d3d11_bind_render_target                         equ                 00000020h                                         ;
d3d11_bind_shader_resource                       equ                 00000008h                                         ;
d3d11_bind_stream_output                         equ                 00000010h                                         ;
d3d11_bind_unordered_access                      equ                 00000080h                                         ;
d3d11_bind_vertex_buffer                         equ                 00000001h                                         ;
d3d11_bind_video_encoder                         equ                 00000400h                                         ;

d3d11_blend_zero                                 equ                 1                                 
d3d11_blend_one                                  equ                 2  
d3d11_blend_src_color                            equ                 3    
d3d11_blend_inv_src_color                        equ                 4        
d3d11_blend_src_alpha                            equ                 5    
d3d11_blend_inv_src_alpha                        equ                 6       
d3d11_blend_dest_alpha                           equ                 7    
d3d11_blend_inv_dest_alpha                       equ                 8        
d3d11_blend_dest_color                           equ                 9    
d3d11_blend_inv_dest_color                       equ                 10        
d3d11_blend_src_alpha_sat                        equ                 11        
d3d11_blend_blend_factor                         equ                 14        
d3d11_blend_inv_blend_factor                     equ                 15            
d3d11_blend_src1_color                           equ                 16    
d3d11_blend_inv_src1_color                       equ                 17        
d3d11_blend_src1_alpha                           equ                 18    
d3d11_blend_inv_src1_alpha                       equ                 19        

d3d11_blend_op_add	                             equ                 1
d3d11_blend_op_subtract	                         equ                 2
d3d11_blend_op_rev_subtract	                     equ                 3
d3d11_blend_op_min	                             equ                 4
d3d11_blend_op_max	                             equ                 5

d3d11_clear_depth                                equ                 1                                                 ;
d3d11_clear_stencil                              equ                 2                                                 ;

d3d11_comparison_never							 equ 				 1
d3d11_comparison_less							 equ 				 2
d3d11_comparison_equal							 equ 				 3
d3d11_comparison_less_equal						 equ				 4
d3d11_comparison_greater						 equ				 5
d3d11_comparison_not_equal						 equ				 6
d3d11_comparison_greater_equal					 equ			 	 7
d3d11_comparison_always							 equ				 8

d3d11_color_write_enable_red	                 equ                 1
d3d11_color_write_enable_green	                 equ                 2
d3d11_color_write_enable_blue	                 equ                 4
d3d11_color_write_enable_alpha	                 equ                 8
d3d11_color_write_enable_all	                 equ                 15

d3d11_cpu_access_write                           equ                 00010000h
d3d11_cpu_access_read                            equ                 00020000h

d3d11_create_device_bgra_support                                     equ 0000020h                                      ;
d3d11_create_device_debug                                            equ 0000002h                                      ;
d3d11_create_device_debuggable                                       equ 0000040h                                      ;
d3d11_create_device_disable_gpu_timeout                              equ 0000100h                                      ;
d3d11_create_device_prevent_altering_layer_settings_from_registry    equ 0000080h                                      ;
d3d11_create_device_prevent_internal_threading_optimizations         equ 0000008h                                      ;
d3d11_create_device_singlethreaded                                   equ 0000001h                                      ;
d3d11_create_device_switch_to_ref                                    equ 0000004h                                      ;
d3d11_create_device_video_support                                    equ 0000800h                                      ;

d3d11_cull_back                                  equ                 3                                                 ;
d3d11_cull_front                                 equ                 2                                                 ;
d3d11_cull_none                                  equ                 1                                                 ;

d3d11_dsv_dimension_unknown                      equ                 0
d3d11_dsv_dimension_texture1d                    equ                 1
d3d11_dsv_dimension_texture1darray               equ                 2
d3d11_dsv_dimension_texture2d                    equ                 3
d3d11_dsv_dimension_texture2darray               equ                 4
d3d11_dsv_dimension_texture2dms                  equ                 5
d3d11_dsv_dimension_texture2dmsarray             equ                 6

d3d11_fill_wireframe                             equ                 2                                                 ;
d3d11_fill_solid                                 equ                 3                                                 ;

d3d11_filter_min_mag_mip_point										equ 000000000h
d3d11_filter_min_mag_point_mip_linear								equ 000000001h
d3d11_filter_min_point_mag_linear_mip_point							equ 000000004h
d3d11_filter_min_point_mag_mip_linear								equ 000000005h
d3d11_filter_min_linear_mag_mip_point								equ 000000010h
d3d11_filter_min_linear_mag_point_mip_linear						equ 000000011h
d3d11_filter_min_mag_linear_mip_point								equ 000000014h
d3d11_filter_min_mag_mip_linear										equ 000000015h
d3d11_filter_anisotropic											equ 000000055h
d3d11_filter_comparison_min_mag_mip_point							equ 000000080h
d3d11_filter_comparison_min_mag_point_mip_linear					equ 000000081h
d3d11_filter_comparison_min_point_mag_linear_mip_point				equ 000000084h
d3d11_filter_comparison_min_point_mag_mip_linear					equ 000000085h
d3d11_filter_comparison_min_linear_mag_mip_point					equ 000000090h
d3d11_filter_comparison_min_linear_mag_point_mip_linear				equ 000000091h
d3d11_filter_comparison_min_mag_linear_mip_point					equ 000000094h
d3d11_filter_comparison_min_mag_mip_linear							equ 000000095h
d3d11_filter_comparison_anisotropic									equ 0000000d5h
d3d11_filter_minimum_min_mag_mip_point								equ 000000100h
d3d11_filter_minimum_min_mag_point_mip_linear						equ 000000101h
d3d11_filter_minimum_min_point_mag_linear_mip_point					equ 000000104h
d3d11_filter_minimum_min_point_mag_mip_linear						equ 000000105h
d3d11_filter_minimum_min_linear_mag_mip_point						equ 000000110h
d3d11_filter_minimum_min_linear_mag_point_mip_linear				equ 000000111h
d3d11_filter_minimum_min_mag_linear_mip_point						equ 000000114h
d3d11_filter_minimum_min_mag_mip_linear								equ 000000115h
d3d11_filter_minimum_anisotropic									equ 000000155h
d3d11_filter_maximum_min_mag_mip_point								equ 000000180h
d3d11_filter_maximum_min_mag_point_mip_linear						equ 000000181h
d3d11_filter_maximum_min_point_mag_linear_mip_point					equ 000000184h
d3d11_filter_maximum_min_point_mag_mip_linear						equ 000000185h
d3d11_filter_maximum_min_linear_mag_mip_point						equ 000000190h
d3d11_filter_maximum_min_linear_mag_point_mip_linear				equ 000000191h
d3d11_filter_maximum_min_mag_linear_mip_point						equ 000000194h
d3d11_filter_maximum_min_mag_mip_linear								equ 000000195h
d3d11_filter_maximum_anisotropic									equ 0000001d5h

d3d11_float32_max													equ 3.402823466e+38 

d3d11_input_per_instance_data                    equ                 1                                                 ;
d3d11_input_per_vertex_data                      equ                 0                                                 ;

d3d11_map_read	                                 equ                 1
d3d11_map_write	                                 equ                 2
d3d11_map_read_write	                         equ                 3
d3d11_map_write_discard	                         equ                 4
d3d11_map_write_no_overwrite	                 equ                 5

d3d11_primitive_topology_10_control_point_patchlist equ              42                                                ;
d3d11_primitive_topology_11_control_point_patchlist equ              43                                                ;
d3d11_primitive_topology_12_control_point_patchlist equ              44                                                ;
d3d11_primitive_topology_13_control_point_patchlist equ              45                                                ;
d3d11_primitive_topology_14_control_point_patchlist equ              46                                                ;
d3d11_primitive_topology_15_control_point_patchlist equ              47                                                ;
d3d11_primitive_topology_16_control_point_patchlist equ              48                                                ;
d3d11_primitive_topology_17_control_point_patchlist equ              49                                                ;
d3d11_primitive_topology_18_control_point_patchlist equ              50                                                ;
d3d11_primitive_topology_19_control_point_patchlist equ              51                                                ;
d3d11_primitive_topology_1_control_point_patchlist  equ              33                                                ;
d3d11_primitive_topology_20_control_point_patchlist equ              52                                                ;
d3d11_primitive_topology_21_control_point_patchlist equ              53                                                ;
d3d11_primitive_topology_22_control_point_patchlist equ              54                                                ;
d3d11_primitive_topology_23_control_point_patchlist equ              55                                                ;
d3d11_primitive_topology_24_control_point_patchlist equ              56                                                ;
d3d11_primitive_topology_25_control_point_patchlist equ              57                                                ;
d3d11_primitive_topology_26_control_point_patchlist equ              58                                                ;
d3d11_primitive_topology_27_control_point_patchlist equ              59                                                ;
d3d11_primitive_topology_28_control_point_patchlist equ              60                                                ;
d3d11_primitive_topology_29_control_point_patchlist equ              61                                                ;
d3d11_primitive_topology_2_control_point_patchlist  equ              34                                                ;
d3d11_primitive_topology_30_control_point_patchlist equ              62                                                ;
d3d11_primitive_topology_31_control_point_patchlist equ              63                                                ;
d3d11_primitive_topology_32_control_point_patchlist equ              64                                                ;
d3d11_primitive_topology_3_control_point_patchlist  equ              35                                                ;
d3d11_primitive_topology_4_control_point_patchlist  equ              36                                                ;
d3d11_primitive_topology_5_control_point_patchlist  equ              37                                                ;
d3d11_primitive_topology_6_control_point_patchlist  equ              38                                                ;
d3d11_primitive_topology_7_control_point_patchlist  equ              39                                                ;
d3d11_primitive_topology_8_control_point_patchlist  equ              40                                                ;
d3d11_primitive_topology_9_control_point_patchlist  equ              41                                                ;
d3d11_primitive_topology_linelist                   equ              02                                                ;
d3d11_primitive_topology_linelist_adj               equ              10                                                ;
d3d11_primitive_topology_linestrip                  equ              03                                                ;
d3d11_primitive_topology_linestrip_adj              equ              11                                                ;
d3d11_primitive_topology_pointlist                  equ              01                                                ;
d3d11_primitive_topology_trianglelist               equ              04                                                ;
d3d11_primitive_topology_trianglelist_adj           equ              12                                                ;
d3d11_primitive_topology_trianglestrip              equ              05                                                ;
d3d11_primitive_topology_trianglestrip_adj          equ              13                                                ;
d3d11_primitive_topology_undefined                  equ              00                                                ;

d3d11_sdk_version                                equ                 7                                                 ;

d3d11_srv_dimension_unknown							equ 			0
d3d11_srv_dimension_buffer							equ 			1
d3d11_srv_dimension_texture1d						equ				2
d3d11_srv_dimension_texture1darray					equ				3
d3d11_srv_dimension_texture2d						equ				4
d3d11_srv_dimension_texture2darray					equ				5
d3d11_srv_dimension_texture2dms						equ				6
d3d11_srv_dimension_texture2dmsarray				equ				7
d3d11_srv_dimension_texture3d						equ				8
d3d11_srv_dimension_texturecube						equ				9
d3d11_srv_dimension_texturecubearray				equ				10
d3d11_srv_dimension_bufferex						equ				11

d3d11_usage_default                              equ                 0                                                 ;
d3d11_usage_dynamic                              equ                 2                                                 ;
d3d11_usage_immutable                            equ                 1                                                 ;
d3d11_usage_staging                              equ                 3                                                 ;

dxgi_format_unknown                              equ                 0                                                 ;
dxgi_format_r32g32b32a32_typeless                equ                 1                                                 ;
dxgi_format_r32g32b32a32_float                   equ                 2                                                 ;
dxgi_format_r32g32b32a32_uint                    equ                 3                                                 ;
dxgi_format_r32g32b32a32_sint                    equ                 4                                                 ;
dxgi_format_r32g32b32_typeless                   equ                 5                                                 ;
dxgi_format_r32g32b32_float                      equ                 6                                                 ;
dxgi_format_r32g32b32_uint                       equ                 7                                                 ;
dxgi_format_r32g32b32_sint                       equ                 8                                                 ;
dxgi_format_r16g16b16a16_typeless                equ                 9                                                 ;
dxgi_format_r16g16b16a16_float                   equ                 10                                                ;
dxgi_format_r16g16b16a16_unorm                   equ                 11                                                ;
dxgi_format_r16g16b16a16_uint                    equ                 12                                                ;
dxgi_format_r16g16b16a16_snorm                   equ                 13                                                ;
dxgi_format_r16g16b16a16_sint                    equ                 14                                                ;
dxgi_format_r32g32_typeless                      equ                 15                                                ;
dxgi_format_r32g32_float                         equ                 16                                                ;
dxgi_format_r32g32_uint                          equ                 17                                                ;
dxgi_format_r32g32_sint                          equ                 18                                                ;
dxgi_format_r32g8x24_typeless                    equ                 19                                                ;
dxgi_format_d32_float_s8x24_uint                 equ                 20                                                ;
dxgi_format_r32_float_x8x24_typeless             equ                 21                                                ;
dxgi_format_x32_typeless_g8x24_uint              equ                 22                                                ;
dxgi_format_r10g10b10a2_typeless                 equ                 23                                                ;
dxgi_format_r10g10b10a2_unorm                    equ                 24                                                ;
dxgi_format_r10g10b10a2_uint                     equ                 25                                                ;
dxgi_format_r11g11b10_float                      equ                 26                                                ;
dxgi_format_r8g8b8a8_typeless                    equ                 27                                                ;
dxgi_format_r8g8b8a8_unorm                       equ                 28                                                ;
dxgi_format_r8g8b8a8_unorm_srgb                  equ                 29                                                ;
dxgi_format_r8g8b8a8_uint                        equ                 30                                                ;
dxgi_format_r8g8b8a8_snorm                       equ                 31                                                ;
dxgi_format_r8g8b8a8_sint                        equ                 32                                                ;
dxgi_format_r16g16_typeless                      equ                 33                                                ;
dxgi_format_r16g16_float                         equ                 34                                                ;
dxgi_format_r16g16_unorm                         equ                 35                                                ;
dxgi_format_r16g16_uint                          equ                 36                                                ;
dxgi_format_r16g16_snorm                         equ                 37                                                ;
dxgi_format_r16g16_sint                          equ                 38                                                ;
dxgi_format_r32_typeless                         equ                 39                                                ;
dxgi_format_d32_float                            equ                 40                                                ;
dxgi_format_r32_float                            equ                 41                                                ;
dxgi_format_r32_uint                             equ                 42                                                ;
dxgi_format_r32_sint                             equ                 43                                                ;
dxgi_format_r24g8_typeless                       equ                 44                                                ;
dxgi_format_d24_unorm_s8_uint                    equ                 45                                                ;
dxgi_format_r24_unorm_x8_typeless                equ                 46                                                ;
dxgi_format_x24_typeless_g8_uint                 equ                 47                                                ;
dxgi_format_r8g8_typeless                        equ                 48                                                ;
dxgi_format_r8g8_unorm                           equ                 49                                                ;
dxgi_format_r8g8_uint                            equ                 50                                                ;
dxgi_format_r8g8_snorm                           equ                 51                                                ;
dxgi_format_r8g8_sint                            equ                 52                                                ;
dxgi_format_r16_typeless                         equ                 53                                                ;
dxgi_format_r16_float                            equ                 54                                                ;
dxgi_format_d16_unorm                            equ                 55                                                ;
dxgi_format_r16_unorm                            equ                 56                                                ;
dxgi_format_r16_uint                             equ                 57                                                ;
dxgi_format_r16_snorm                            equ                 58                                                ;
dxgi_format_r16_sint                             equ                 59                                                ;
dxgi_format_r8_typeless                          equ                 60                                                ;
dxgi_format_r8_unorm                             equ                 61                                                ;
dxgi_format_r8_uint                              equ                 62                                                ;
dxgi_format_r8_snorm                             equ                 63                                                ;
dxgi_format_r8_sint                              equ                 64                                                ;
dxgi_format_a8_unorm                             equ                 65                                                ;
dxgi_format_r1_unorm                             equ                 66                                                ;
dxgi_format_r9g9b9e5_sharedexp                   equ                 67                                                ;
dxgi_format_r8g8_b8g8_unorm                      equ                 68                                                ;
dxgi_format_g8r8_g8b8_unorm                      equ                 69                                                ;
dxgi_format_bc1_typeless                         equ                 70                                                ;
dxgi_format_bc1_unorm                            equ                 71                                                ;
dxgi_format_bc1_unorm_srgb                       equ                 72                                                ;
dxgi_format_bc2_typeless                         equ                 73                                                ;
dxgi_format_bc2_unorm                            equ                 74                                                ;
dxgi_format_bc2_unorm_srgb                       equ                 75                                                ;
dxgi_format_bc3_typeless                         equ                 76                                                ;
dxgi_format_bc3_unorm                            equ                 77                                                ;
dxgi_format_bc3_unorm_srgb                       equ                 78                                                ;
dxgi_format_bc4_typeless                         equ                 79                                                ;
dxgi_format_bc4_unorm                            equ                 80                                                ;
dxgi_format_bc4_snorm                            equ                 81                                                ;
dxgi_format_bc5_typeless                         equ                 82                                                ;
dxgi_format_bc5_unorm                            equ                 83                                                ;
dxgi_format_bc5_snorm                            equ                 84                                                ;
dxgi_format_b5g6r5_unorm                         equ                 85                                                ;
dxgi_format_b5g5r5a1_unorm                       equ                 86                                                ;
dxgi_format_b8g8r8a8_unorm                       equ                 87                                                ;
dxgi_format_b8g8r8x8_unorm                       equ                 88                                                ;
dxgi_format_r10g10b10_xr_bias_a2_unorm           equ                 89                                                ;
dxgi_format_b8g8r8a8_typeless                    equ                 90                                                ;
dxgi_format_b8g8r8a8_unorm_srgb                  equ                 91                                                ;
dxgi_format_b8g8r8x8_typeless                    equ                 92                                                ;
dxgi_format_b8g8r8x8_unorm_srgb                  equ                 93                                                ;
dxgi_format_bc6h_typeless                        equ                 94                                                ;
dxgi_format_bc6h_uf16                            equ                 95                                                ;
dxgi_format_bc6h_sf16                            equ                 96                                                ;
dxgi_format_bc7_typeless                         equ                 97                                                ;
dxgi_format_bc7_unorm                            equ                 98                                                ;
dxgi_format_bc7_unorm_srgb                       equ                 99                                                ;
dxgi_format_ayuv                                 equ                 100                                               ;
dxgi_format_y410                                 equ                 101                                               ;
dxgi_format_y416                                 equ                 102                                               ;
dxgi_format_nv12                                 equ                 103                                               ;
dxgi_format_p010                                 equ                 104                                               ;
dxgi_format_p016                                 equ                 105                                               ;
dxgi_format_420_opaque                           equ                 106                                               ;
dxgi_format_yuy2                                 equ                 107                                               ;
dxgi_format_y210                                 equ                 108                                               ;
dxgi_format_y216                                 equ                 109                                               ;
dxgi_format_nv11                                 equ                 110                                               ;
dxgi_format_ai44                                 equ                 111                                               ;
dxgi_format_ia44                                 equ                 112                                               ;
dxgi_format_p8                                   equ                 113                                               ;
dxgi_format_a8p8                                 equ                 114                                               ;
dxgi_format_b4g4r4a4_unorm                       equ                 115                                               ;
dxgi_format_p208                                 equ                 130                                               ;
dxgi_format_v208                                 equ                 131                                               ;
dxgi_format_v408                                 equ                 132                                               ;
dxgi_format_astc_4x4_unorm                       equ                 134                                               ;
dxgi_format_astc_4x4_unorm_srgb                  equ                 135                                               ;
dxgi_format_astc_5x4_typeless                    equ                 137                                               ;
dxgi_format_astc_5x4_unorm                       equ                 138                                               ;
dxgi_format_astc_5x4_unorm_srgb                  equ                 139                                               ;
dxgi_format_astc_5x5_typeless                    equ                 141                                               ;
dxgi_format_astc_5x5_unorm                       equ                 142                                               ;
dxgi_format_astc_5x5_unorm_srgb                  equ                 143                                               ;
dxgi_format_astc_6x5_typeless                    equ                 145                                               ;
dxgi_format_astc_6x5_unorm                       equ                 146                                               ;
dxgi_format_astc_6x5_unorm_srgb                  equ                 147                                               ;
dxgi_format_astc_6x6_typeless                    equ                 149                                               ;
dxgi_format_astc_6x6_unorm                       equ                 150                                               ;
dxgi_format_astc_6x6_unorm_srgb                  equ                 151                                               ;
dxgi_format_astc_8x5_typeless                    equ                 153                                               ;
dxgi_format_astc_8x5_unorm                       equ                 154                                               ;
dxgi_format_astc_8x5_unorm_srgb                  equ                 155                                               ;
dxgi_format_astc_8x6_typeless                    equ                 157                                               ;
dxgi_format_astc_8x6_unorm                       equ                 158                                               ;
dxgi_format_astc_8x6_unorm_srgb                  equ                 159                                               ;
dxgi_format_astc_8x8_typeless                    equ                 161                                               ;
dxgi_format_astc_8x8_unorm                       equ                 162                                               ;
dxgi_format_astc_8x8_unorm_srgb                  equ                 163                                               ;
dxgi_format_astc_10x5_typeless                   equ                 165                                               ;
dxgi_format_astc_10x5_unorm                      equ                 166                                               ;
dxgi_format_astc_10x5_unorm_srgb                 equ                 167                                               ;
dxgi_format_astc_10x6_typeless                   equ                 169                                               ;
dxgi_format_astc_10x6_unorm                      equ                 170                                               ;
dxgi_format_astc_10x6_unorm_srgb                 equ                 171                                               ;
dxgi_format_astc_10x8_typeless                   equ                 173                                               ;
dxgi_format_astc_10x8_unorm                      equ                 174                                               ;
dxgi_format_astc_10x8_unorm_srgb                 equ                 175                                               ;
dxgi_format_astc_10x10_typeless                  equ                 177                                               ;
dxgi_format_astc_10x10_unorm                     equ                 178                                               ;
dxgi_format_astc_10x10_unorm_srgb                equ                 179                                               ;
dxgi_format_astc_12x10_typeless                  equ                 181                                               ;
dxgi_format_astc_12x10_unorm                     equ                 182                                               ;
dxgi_format_astc_12x10_unorm_srgb                equ                 183                                               ;
dxgi_format_astc_12x12_typeless                  equ                 185                                               ;
dxgi_format_astc_12x12_unorm                     equ                 186                                               ;
dxgi_format_astc_12x12_unorm_srgb                equ                 187                                               ;
dxgi_format_force_uint                           equ                 0xffffffff                                        ;

dxgi_mode_scaling_centered                       equ                 1                                                 ;
dxgi_mode_scaling_stretched                      equ                 2                                                 ;
dxgi_mode_scaling_unspecified                    equ                 0                                                 ;

dxgi_mode_scanline_order_lower_field_first       equ                 3                                                 ;
dxgi_mode_scanline_order_progressive             equ                 1                                                 ;
dxgi_mode_scanline_order_unspecified             equ                 0                                                 ;
dxgi_mode_scanline_order_upper_field_first       equ                 2                                                 ;

dxgi_swap_effect_discard                         equ                 0                                                 ;
dxgi_swap_effect_sequential                      equ                 1                                                 ;
dxgi_swap_effect_flip_sequential                 equ                 3                                                 ;

dxgi_usage_back_buffer                           equ                 00000040h                                         ;
dxgi_usage_discard_on_present                    equ                 00000200h                                         ;
dxgi_usage_read_only                             equ                 00000100h                                         ;
dxgi_usage_render_target_output                  equ                 00000020h                                         ;
dxgi_usage_shader_input                          equ                 00000010h                                         ;
dxgi_usage_shared                                equ                 00000080h                                         ;
dxgi_usage_unordered_access                      equ                 00000400h                                         ;


d3d11_texture_address_wrap						 equ 				 1
d3d11_texture_address_mirror					 equ 				 2
d3d11_texture_address_clamp						 equ 				 3
d3d11_texture_address_border					 equ 				 4
d3d11_texture_address_mirror_once				 equ 				 5

;-----[E]---------------------------------------------------------------------------------------------------------------

;-----[F]---------------------------------------------------------------------------------------------------------------

;-----[G]---------------------------------------------------------------------------------------------------------------

;-----[H]---------------------------------------------------------------------------------------------------------------

;-----[I]---------------------------------------------------------------------------------------------------------------

;-----[J]---------------------------------------------------------------------------------------------------------------

;-----[K]---------------------------------------------------------------------------------------------------------------

;-----[L]---------------------------------------------------------------------------------------------------------------

;-----[M]---------------------------------------------------------------------------------------------------------------

;-----[N]---------------------------------------------------------------------------------------------------------------

;-----[O]---------------------------------------------------------------------------------------------------------------

;-----[P]---------------------------------------------------------------------------------------------------------------

pm_noremove                                      equ                 00000000h                                         ;
pm_noyield                                       equ                 00000002h                                         ;
pm_remove                                        equ                 00000001h                                         ;

;-----[Q]---------------------------------------------------------------------------------------------------------------

;-----[R]---------------------------------------------------------------------------------------------------------------

RIDEV_REMOVE									 equ				 00000001h
;If set, this removes the top level collection from the inclusion list. This tells the operating system to stop reading from a device which matches the top level collection.
RIDEV_EXCLUDE									 equ				 00000010h
;If set, this specifies the top level collections to exclude when reading a complete usage page. This flag only affects a TLC whose usage page is already specified with RIDEV_PAGEONLY.
RIDEV_PAGEONLY									 equ				 00000020h
;If set, this specifies all devices whose top level collection is from the specified usUsagePage. Note that usUsage must be zero. To exclude a particular top level collection, use RIDEV_EXCLUDE.
RIDEV_NOLEGACY									 equ				 00000030h
;If set, this prevents any devices specified by usUsagePage or usUsage from generating legacy messages. This is only for the mouse and keyboard. See Remarks.
RIDEV_INPUTSINK									 equ				 00000100h
;If set, this enables the caller to receive the input even when the caller is not in the foreground. Note that hwndTarget must be specified.
RIDEV_CAPTUREMOUSE								 equ				 00000200h
;If set, the mouse button click does not activate the other window. RIDEV_CAPTUREMOUSE can be specified only if RIDEV_NOLEGACY is specified for a mouse device.
RIDEV_NOHOTKEYS									 equ				 00000200h
;If set, the application-defined keyboard device hotkeys are not handled. However, the system hotkeys; for example, ALT+TAB and CTRL+ALT+DEL, are still handled. By default, all keyboard hotkeys are handled. RIDEV_NOHOTKEYS can be specified even if RIDEV_NOLEGACY is not specified and hwndTarget is NULL.
RIDEV_APPKEYS									 equ				 00000400h
;If set, the application command keys are handled. RIDEV_APPKEYS can be specified only if RIDEV_NOLEGACY is specified for a keyboard device.
RIDEV_EXINPUTSINK								 equ				 00001000h
;If set, this enables the caller to receive input in the background only if the foreground application does not process it. In other words, if the foreground application is not registered for raw input, then the background application that is registered will receive the input.
;Windows XP: This flag is not supported until Windows Vista
RIDEV_DEVNOTIFY									 equ 				 00002000h
;If set, this enables the caller to receive WM_INPUT_DEVICE_CHANGE notifications for device arrival and device removal.
;Windows XP: This flag is not supported until Windows Vista

RID_HEADER										 equ				 10000005h
;Get the header information from the RAWINPUT structure.
RID_INPUT										 equ				 10000003h
;Get the raw data from the RAWINPUT structure.

RIM_TYPEMOUSE 									 equ				 0	;Raw input comes from the mouse.
RIM_TYPEKEYBOARD 								 equ				 1	;Raw input comes from the keyboard.
RIM_TYPEHID 									 equ				 2	;Raw input comes from some device that is not a keyboard or a mouse.

;-----[S]---------------------------------------------------------------------------------------------------------------

spi_getbeep                                      equ                 00000001h                                         ;
spi_setbeep                                      equ                 00000002h                                         ;
spi_getmouse                                     equ                 00000003h                                         ;
spi_setmouse                                     equ                 00000004h                                         ;
spi_getborder                                    equ                 00000005h                                         ;
spi_setborder                                    equ                 00000006h                                         ;
spi_getkeyboardspeed                             equ                 0000000Ah                                         ;
spi_setkeyboardspeed                             equ                 0000000Bh                                         ;
spi_langdriver                                   equ                 0000000Ch                                         ;
spi_iconhorizontalspacing                        equ                 0000000Dh                                         ;
spi_getscreensavetimeout                         equ                 0000000Eh                                         ;
spi_setscreensavetimeout                         equ                 0000000Fh                                         ;
spi_getscreensaveactive                          equ                 00000010h                                         ;
spi_setscreensaveactive                          equ                 00000011h                                         ;
spi_getgridgranularity                           equ                 00000012h                                         ;
spi_setgridgranularity                           equ                 00000013h                                         ;
spi_setdeskwallpaper                             equ                 00000014h                                         ;
spi_setdeskpattern                               equ                 00000015h                                         ;
spi_getkeyboarddelay                             equ                 00000016h                                         ;
spi_setkeyboarddelay                             equ                 00000017h                                         ;
spi_iconverticalspacing                          equ                 00000018h                                         ;
spi_geticontitlewrap                             equ                 00000019h                                         ;
spi_seticontitlewrap                             equ                 0000001Ah                                         ;
spi_getmenudropalignment                         equ                 0000001Bh                                         ;
spi_setmenudropalignment                         equ                 0000001Ch                                         ;
spi_setdoubleclkwidth                            equ                 0000001Dh                                         ;
spi_setdoubleclkheight                           equ                 0000001Eh                                         ;
spi_geticontitlelogfont                          equ                 0000001Fh                                         ;
spi_setdoubleclicktime                           equ                 00000020h                                         ;
spi_setmousebuttonswap                           equ                 00000021h                                         ;
spi_seticontitlelogfont                          equ                 00000022h                                         ;
spi_getfasttaskswitch                            equ                 00000023h                                         ;
spi_setfasttaskswitch                            equ                 00000024h                                         ;
spi_setdragfullwindows                           equ                 00000025h                                         ;
spi_getdragfullwindows                           equ                 00000026h                                         ;
spi_getnonclientmetrics                          equ                 00000029h                                         ;
spi_setnonclientmetrics                          equ                 0000002Ah                                         ;
spi_getminimizedmetrics                          equ                 0000002Bh                                         ;
spi_setminimizedmetrics                          equ                 0000002Ch                                         ;
spi_geticonmetrics                               equ                 0000002Dh                                         ;
spi_seticonmetrics                               equ                 0000002Eh                                         ;
spi_setworkarea                                  equ                 0000002Fh                                         ;
spi_getworkarea                                  equ                 00000030h                                         ;
spi_setpenwindows                                equ                 00000031h                                         ;
spi_gethighcontrast                              equ                 00000042h                                         ;
spi_sethighcontrast                              equ                 00000043h                                         ;
spi_getkeyboardpref                              equ                 00000044h                                         ;
spi_setkeyboardpref                              equ                 00000045h                                         ;
spi_getscreenreader                              equ                 00000046h                                         ;
spi_setscreenreader                              equ                 00000047h                                         ;
spi_getanimation                                 equ                 00000048h                                         ;
spi_setanimation                                 equ                 00000049h                                         ;
spi_getfontsmoothing                             equ                 0000004Ah                                         ;
spi_setfontsmoothing                             equ                 0000004Bh                                         ;
spi_setdragwidth                                 equ                 0000004Ch                                         ;
spi_setdragheight                                equ                 0000004Dh                                         ;
spi_sethandheld                                  equ                 0000004Eh                                         ;
spi_getlowpowertimeout                           equ                 0000004Fh                                         ;
spi_getpowerofftimeout                           equ                 00000050h                                         ;
spi_setlowpowertimeout                           equ                 00000051h                                         ;
spi_setpowerofftimeout                           equ                 00000052h                                         ;
spi_getlowpoweractive                            equ                 00000053h                                         ;
spi_getpoweroffactive                            equ                 00000054h                                         ;
spi_setlowpoweractive                            equ                 00000055h                                         ;
spi_setpoweroffactive                            equ                 00000056h                                         ;
spi_setcursors                                   equ                 00000057h                                         ;
spi_seticons                                     equ                 00000058h                                         ;
spi_getdefaultinputlang                          equ                 00000059h                                         ;
spi_setdefaultinputlang                          equ                 0000005Ah                                         ;
spi_setlangtoggle                                equ                 0000005Bh                                         ;
spi_getwindowsextension                          equ                 0000005Ch                                         ;
spi_setmousetrails                               equ                 0000005Dh                                         ;
spi_getmousetrails                               equ                 0000005Eh                                         ;
spi_setscreensaverrunning                        equ                 00000061h                                         ;
spi_screensaverrunning                           equ                 00000061h                                         ;
spi_getfilterkeys                                equ                 00000032h                                         ;
spi_setfilterkeys                                equ                 00000033h                                         ;
spi_gettogglekeys                                equ                 00000034h                                         ;
spi_settogglekeys                                equ                 00000035h                                         ;
spi_getmousekeys                                 equ                 00000036h                                         ;
spi_setmousekeys                                 equ                 00000037h                                         ;
spi_getshowsounds                                equ                 00000038h                                         ;
spi_setshowsounds                                equ                 00000039h                                         ;
spi_getstickykeys                                equ                 0000003Ah                                         ;
spi_setstickykeys                                equ                 0000003Bh                                         ;
spi_getaccesstimeout                             equ                 0000003Ch                                         ;
spi_setaccesstimeout                             equ                 0000003Dh                                         ;
spi_getserialkeys                                equ                 0000003Eh                                         ;
spi_setserialkeys                                equ                 0000003Fh                                         ;
spi_getsoundsentry                               equ                 00000040h                                         ;
spi_setsoundsentry                               equ                 00000041h                                         ;
spi_getsnaptodefbutton                           equ                 00000060h                                         ;
spi_setsnaptodefbutton                           equ                 00000061h                                         ;
spi_getmousehoverwidth                           equ                 00000062h                                         ;
spi_setmousehoverwidth                           equ                 00000063h                                         ;
spi_getmousehoverheight                          equ                 00000064h                                         ;
spi_setmousehoverheight                          equ                 00000065h                                         ;
spi_getmousehovertime                            equ                 00000066h                                         ;
spi_setmousehovertime                            equ                 00000067h                                         ;
spi_getwheelscrolllines                          equ                 00000068h                                         ;
spi_setwheelscrolllines                          equ                 00000069h                                         ;
spi_getmenushowdelay                             equ                 0000006Ah                                         ;
spi_setmenushowdelay                             equ                 0000006Bh                                         ;
spi_getshowimeui                                 equ                 0000006Eh                                         ;
spi_setshowimeui                                 equ                 0000006Fh                                         ;
spi_getmousespeed                                equ                 00000070h                                         ;
spi_setmousespeed                                equ                 00000071h                                         ;
spi_getscreensaverrunning                        equ                 00000072h                                         ;
spi_getdeskwallpaper                             equ                 00000073h                                         ;
spi_getactivewindowtracking                      equ                 00001000h                                         ;
spi_setactivewindowtracking                      equ                 00001001h                                         ;
spi_getmenuanimation                             equ                 00001002h                                         ;
spi_setmenuanimation                             equ                 00001003h                                         ;
spi_getcomboboxanimation                         equ                 00001004h                                         ;
spi_setcomboboxanimation                         equ                 00001005h                                         ;
spi_getlistboxsmoothscrolling                    equ                 00001006h                                         ;
spi_setlistboxsmoothscrolling                    equ                 00001007h                                         ;
spi_getgradientcaptions                          equ                 00001008h                                         ;
spi_setgradientcaptions                          equ                 00001009h                                         ;
spi_getkeyboardcues                              equ                 0000100Ah                                         ;
spi_setkeyboardcues                              equ                 0000100Bh                                         ;
spi_getmenuunderlines                            equ                 0000100Ah                                         ;
spi_setmenuunderlines                            equ                 0000100Bh                                         ;
spi_getactivewndtrkzorder                        equ                 0000100Ch                                         ;
spi_setactivewndtrkzorder                        equ                 0000100Dh                                         ;
spi_gethottracking                               equ                 0000100Eh                                         ;
spi_sethottracking                               equ                 0000100Fh                                         ;
spi_getmenufade                                  equ                 00001012h                                         ;
spi_setmenufade                                  equ                 00001013h                                         ;
spi_getselectionfade                             equ                 00001014h                                         ;
spi_setselectionfade                             equ                 00001015h                                         ;
spi_gettooltipanimation                          equ                 00001016h                                         ;
spi_settooltipanimation                          equ                 00001017h                                         ;
spi_gettooltipfade                               equ                 00001018h                                         ;
spi_settooltipfade                               equ                 00001019h                                         ;
spi_getcursorshadow                              equ                 0000101Ah                                         ;
spi_setcursorshadow                              equ                 0000101Bh                                         ;
spi_getuieffects                                 equ                 0000103Eh                                         ;
spi_setuieffects                                 equ                 0000103Fh                                         ;
spi_getforegroundlocktimeout                     equ                 00002000h                                         ;
spi_setforegroundlocktimeout                     equ                 00002001h                                         ;
spi_getactivewndtrktimeout                       equ                 00002002h                                         ;
spi_setactivewndtrktimeout                       equ                 00002003h                                         ;
spi_getforegroundflashcount                      equ                 00002004h                                         ;
spi_setforegroundflashcount                      equ                 00002005h                                         ;
spi_getcaretwidth                                equ                 00002006h                                         ;
spi_setcaretwidth                                equ                 00002007h                                         ;

sw_hide                                          equ                 00000000h                                         ;
sw_max                                           equ                 0000000Ah                                         ;
sw_maximize                                      equ                 00000003h                                         ;
sw_minimize                                      equ                 00000006h                                         ;
sw_normal                                        equ                 00000001h                                         ;
sw_restore                                       equ                 00000009h                                         ;
sw_show                                          equ                 00000005h                                         ;
sw_showdefault                                   equ                 0000000Ah                                         ;
sw_showmaximized                                 equ                 00000003h                                         ;
sw_showminimized                                 equ                 00000002h                                         ;
sw_showminnoactive                               equ                 00000007h                                         ;
sw_showna                                        equ                 00000008h                                         ;
sw_shownoactivate                                equ                 00000004h                                         ;
sw_shownormal                                    equ                 00000001h                                         ;

;-----[T]---------------------------------------------------------------------------------------------------------------

;-----[U]---------------------------------------------------------------------------------------------------------------

;-----[V]---------------------------------------------------------------------------------------------------------------


vk_delete										 equ	  			 0000002eh

vk_a                                             equ                 00000041h
vk_d                                             equ                 00000044h
vk_e                                             equ                 00000045h
vk_down                                          equ                 00000028h
vk_left                                          equ                 00000025h
vk_m                                             equ                 0000004Dh
vk_n                                             equ                 0000004Eh
vk_o                                             equ                 0000004Fh
vk_p                                             equ                 00000050h
vk_r                                             equ                 00000052h
vk_right                                         equ                 00000027h
vk_s                                             equ                 00000053h
vk_t                                             equ                 00000054h
vk_space                                         equ                 00000020h
vk_up                                            equ                 00000026h
vk_w                                             equ                 00000057h

vk_oem_comma									 equ				 000000bch
vk_oem_minus									 equ				 000000bdh
vk_oem_period									 equ				 000000beh



;-----[W]---------------------------------------------------------------------------------------------------------------

wm_activate                                      equ                 00000006h                                         ;
wm_activateapp                                   equ                 0000001Ch                                         ;
wm_afxfirst                                      equ                 00000360h                                         ;
wm_afxlast                                       equ                 0000037Fh                                         ;
wm_app                                           equ                 00008000h                                         ;
wm_askcbformatname                               equ                 0000030Ch                                         ;
wm_canceljournal                                 equ                 0000004Bh                                         ;
wm_cancelmode                                    equ                 0000001Fh                                         ;
wm_capturechanged                                equ                 00000025h                                         ;
wm_changecbchain                                 equ                 0000030Dh                                         ;
wm_char                                          equ                 00000102h                                         ;
wm_chartoitem                                    equ                 0000002Fh                                         ;
wm_childactivate                                 equ                 00000022h                                         ;
wm_clear                                         equ                 00000303h                                         ;
wm_close                                         equ                 00000010h                                         ;
wm_command                                       equ                 00000111h                                         ;
wm_commnotify                                    equ                 00000044h                                         ;
wm_compacting                                    equ                 00000041h                                         ;
wm_compareitem                                   equ                 00000039h                                         ;
wm_contextmenu                                   equ                 0000007Bh                                         ;
wm_copy                                          equ                 00000301h                                         ;
wm_copydata                                      equ                 0000004Ah                                         ;
wm_create                                        equ                 00000001h                                         ;
wm_ctlcolorbtn                                   equ                 00000135h                                         ;
wm_ctlcolordlg                                   equ                 00000136h                                         ;
wm_ctlcoloredit                                  equ                 00000133h                                         ;
wm_ctlcolorlistbox                               equ                 00000134h                                         ;
wm_ctlcolormsgbox                                equ                 00000132h                                         ;
wm_ctlcolorscrollbar                             equ                 00000137h                                         ;
wm_ctlcolorstatic                                equ                 00000138h                                         ;
wm_cut                                           equ                 00000300h                                         ;
wm_deadchar                                      equ                 00000103h                                         ;
wm_deleteitem                                    equ                 0000002Dh                                         ;
wm_destroy                                       equ                 00000002h                                         ;
wm_destroyclipboard                              equ                 00000307h                                         ;
wm_devicechange                                  equ                 00000219h                                         ;
wm_devmodechange                                 equ                 0000001Bh                                         ;
wm_displaychange                                 equ                 0000007Eh                                         ;
wm_drawclipboard                                 equ                 00000308h                                         ;
wm_drawitem                                      equ                 0000002Bh                                         ;
wm_dropfiles                                     equ                 00000233h                                         ;
wm_enable                                        equ                 0000000Ah                                         ;
wm_endsession                                    equ                 00000016h                                         ;
wm_enteridle                                     equ                 00000121h                                         ;
wm_entermenuloop                                 equ                 00000211h                                         ;
wm_entersizemove                                 equ                 00000231h                                         ;
wm_erasebkgnd                                    equ                 00000014h                                         ;
wm_exitmenuloop                                  equ                 00000212h                                         ;
wm_exitsizemove                                  equ                 00000232h                                         ;
wm_fontchange                                    equ                 0000001Dh                                         ;
wm_getdlgcode                                    equ                 00000087h                                         ;
wm_getfont                                       equ                 00000031h                                         ;
wm_gethotkey                                     equ                 00000033h                                         ;
wm_geticon                                       equ                 0000007Fh                                         ;
wm_getminmaxinfo                                 equ                 00000024h                                         ;
wm_gettext                                       equ                 0000000Dh                                         ;
wm_gettextlength                                 equ                 0000000Eh                                         ;
wm_handheldfirst                                 equ                 00000358h                                         ;
wm_handheldlast                                  equ                 0000035Fh                                         ;
wm_help                                          equ                 00000053h                                         ;
wm_hotkey                                        equ                 00000312h                                         ;
wm_hscroll                                       equ                 00000114h                                         ;
wm_hscrollclipboard                              equ                 0000030Eh                                         ;
wm_iconerasebkgnd                                equ                 00000027h                                         ;
wm_ime_char                                      equ                 00000286h                                         ;
wm_ime_composition                               equ                 0000010Fh                                         ;
wm_ime_compositionfull                           equ                 00000284h                                         ;
wm_ime_control                                   equ                 00000283h                                         ;
wm_ime_endcomposition                            equ                 0000010Eh                                         ;
wm_ime_keydown                                   equ                 00000290h                                         ;
wm_ime_keylast                                   equ                 0000010Fh                                         ;
wm_ime_keyup                                     equ                 00000291h                                         ;
wm_ime_notify                                    equ                 00000282h                                         ;
wm_ime_select                                    equ                 00000285h                                         ;
wm_ime_setcontext                                equ                 00000281h                                         ;
wm_ime_startcomposition                          equ                 0000010Dh                                         ;
wm_initdialog                                    equ                 00000110h                                         ;
wm_initmenu                                      equ                 00000116h                                         ;
wm_initmenupopup                                 equ                 00000117h                                         ;
wm_input                                         equ                 000000FFh                                         ;
wm_inputlangchange                               equ                 00000051h                                         ;
wm_inputlangchanger                              equ                 00000050h                                         ;
wm_keydown                                       equ                 00000100h                                         ;
wm_keyfirst                                      equ                 00000100h                                         ;
wm_keylast                                       equ                 00000108h                                         ;
wm_keyup                                         equ                 00000101h                                         ;
wm_killfocus                                     equ                 00000008h                                         ;
wm_lbuttondblclk                                 equ                 00000203h                                         ;
wm_lbuttondown                                   equ                 00000201h                                         ;
wm_lbuttonup                                     equ                 00000202h                                         ;
wm_mbuttondblclk                                 equ                 00000209h                                         ;
wm_mbuttondown                                   equ                 00000207h                                         ;
wm_mbuttonup                                     equ                 00000208h                                         ;
wm_mdiactivate                                   equ                 00000222h                                         ;
wm_mdicascade                                    equ                 00000227h                                         ;
wm_mdicreate                                     equ                 00000220h                                         ;
wm_mdidestroy                                    equ                 00000221h                                         ;
wm_mdigetactive                                  equ                 00000229h                                         ;
wm_mdiiconarrange                                equ                 00000228h                                         ;
wm_mdimaximize                                   equ                 00000225h                                         ;
wm_mdinext                                       equ                 00000224h                                         ;
wm_mdirefreshmenu                                equ                 00000234h                                         ;
wm_mdirestore                                    equ                 00000223h                                         ;
wm_mdisetmenu                                    equ                 00000230h                                         ;
wm_mditile                                       equ                 00000226h                                         ;
wm_measureitem                                   equ                 0000002Ch                                         ;
wm_menuchar                                      equ                 00000120h                                         ;
wm_menucommand                                   equ                 00000126h                                         ;
wm_menuselect                                    equ                 0000011Fh                                         ;
wm_mouseactivate                                 equ                 00000021h                                         ;
wm_mouseenter                                    equ                 000002A2h                                         ;
wm_mousefirst                                    equ                 00000200h                                         ;
wm_mousehover                                    equ                 000002A1h                                         ;
wm_mouselast                                     equ                 00000209h                                         ;
wm_mousehwheel                                   equ                 0000020Eh                                         ;
wm_mousewheel                                    equ                 0000020Ah                                         ;
wm_mouseleave                                    equ                 000002A3h                                         ;
wm_mousemove                                     equ                 00000200h                                         ;
wm_move                                          equ                 00000003h                                         ;
wm_moving                                        equ                 00000216h                                         ;
wm_ncactivate                                    equ                 00000086h                                         ;
wm_nccalcsize                                    equ                 00000083h                                         ;
wm_nccreate                                      equ                 00000081h                                         ;
wm_ncdestroy                                     equ                 00000082h                                         ;
wm_nchittest                                     equ                 00000084h                                         ;
wm_nclbuttondblclk                               equ                 000000A3h                                         ;
wm_nclbuttondown                                 equ                 000000A1h                                         ;
wm_nclbuttonup                                   equ                 000000A2h                                         ;
wm_ncmbuttondblclk                               equ                 000000A9h                                         ;
wm_ncmbuttondown                                 equ                 000000A7h                                         ;
wm_ncmbuttonup                                   equ                 000000A8h                                         ;
wm_ncmousehover                                  equ                 000002A0h                                         ;
wm_ncmouseleave                                  equ                 000002A2h                                         ;
wm_ncmousemove                                   equ                 000000A0h                                         ;
wm_ncpaint                                       equ                 00000085h                                         ;
wm_ncrbuttondblclk                               equ                 000000A6h                                         ;
wm_ncrbuttondown                                 equ                 000000A4h                                         ;
wm_ncrbuttonup                                   equ                 000000A5h                                         ;
wm_ncxbuttondblclk                               equ                 000000ADh                                         ;
wm_ncxbuttondown                                 equ                 000000ABh                                         ;
wm_ncxbuttonup                                   equ                 000000ACh                                         ;
wm_nextdlgctl                                    equ                 00000028h                                         ;
wm_nextmenu                                      equ                 00000213h                                         ;
wm_notify                                        equ                 0000004Eh                                         ;
wm_notifyformat                                  equ                 00000055h                                         ;
wm_null                                          equ                 00000000h                                         ;
wm_paint                                         equ                 0000000Fh                                         ;
wm_paintclipboard                                equ                 00000309h                                         ;
wm_painticon                                     equ                 00000026h                                         ;
wm_palettechanged                                equ                 00000311h                                         ;
wm_paletteischanging                             equ                 00000310h                                         ;
wm_parentnotify                                  equ                 00000210h                                         ;
wm_paste                                         equ                 00000302h                                         ;
wm_penwinfirst                                   equ                 00000380h                                         ;
wm_penwinlast                                    equ                 0000038Fh                                         ;
wm_power                                         equ                 00000048h                                         ;
wm_powerbroadcast                                equ                 00000218h                                         ;
wm_print                                         equ                 00000317h                                         ;
wm_printclient                                   equ                 00000318h                                         ;
wm_querydragicon                                 equ                 00000037h                                         ;
wm_queryendsession                               equ                 00000011h                                         ;
wm_querynewpalette                               equ                 0000030Fh                                         ;
wm_queryopen                                     equ                 00000013h                                         ;
wm_queuesync                                     equ                 00000023h                                         ;
wm_quit                                          equ                 00000012h                                         ;
wm_rbuttondblclk                                 equ                 00000206h                                         ;
wm_rbuttondown                                   equ                 00000204h                                         ;
wm_rbuttonup                                     equ                 00000205h                                         ;
wm_renderallformats                              equ                 00000306h                                         ;
wm_renderformat                                  equ                 00000305h                                         ;
wm_setcursor                                     equ                 00000020h                                         ;
wm_setfocus                                      equ                 00000007h                                         ;
wm_setfont                                       equ                 00000030h                                         ;
wm_sethotkey                                     equ                 00000032h                                         ;
wm_seticon                                       equ                 00000080h                                         ;
wm_setredraw                                     equ                 0000000Bh                                         ;
wm_settext                                       equ                 0000000Ch                                         ;
wm_settingchange                                 equ                 0000001Ah                                         ;
wm_showwindow                                    equ                 00000018h                                         ;
wm_size                                          equ                 00000005h                                         ;
wm_sizeclipboard                                 equ                 0000030Bh                                         ;
wm_sizing                                        equ                 00000214h                                         ;
wm_spoolerstatus                                 equ                 0000002Ah                                         ;
wm_stylechanged                                  equ                 0000007Dh                                         ;
wm_stylechanging                                 equ                 0000007Ch                                         ;
wm_syncpaint                                     equ                 00000088h                                         ;
wm_syschar                                       equ                 00000106h                                         ;
wm_syscolorchange                                equ                 00000015h                                         ;
wm_syscommand                                    equ                 00000112h                                         ;
wm_sysdeadchar                                   equ                 00000107h                                         ;
wm_syskeydown                                    equ                 00000104h                                         ;
wm_syskeyup                                      equ                 00000105h                                         ;
wm_tcard                                         equ                 00000052h                                         ;
wm_themechanged                                  equ                 0000031Ah                                         ;
wm_timechange                                    equ                 0000001Eh                                         ;
wm_timer                                         equ                 00000113h                                         ;
wm_undo                                          equ                 00000304h                                         ;
wm_userchanged                                   equ                 00000054h                                         ;
wm_vkeytoitem                                    equ                 0000002Eh                                         ;
wm_vscroll                                       equ                 00000115h                                         ;
wm_vscrollclipboard                              equ                 0000030Ah                                         ;
wm_windowposchanged                              equ                 00000047h                                         ;
wm_windowposchanging                             equ                 00000046h                                         ;
wm_wininichange                                  equ                 0000001Ah                                         ;
wm_xbuttondblclk                                 equ                 0000020Dh                                         ;
wm_xbuttondown                                   equ                 0000020Bh                                         ;
wm_xbuttonup                                     equ                 0000020Ch                                         ;

ws_border                                        equ                 00800000h                                         ;
ws_caption                                       equ                 00C00000h                                         ;
ws_child                                         equ                 40000000h                                         ;
ws_clipchildren                                  equ                 02000000h                                         ;
ws_clipsiblings                                  equ                 04000000h                                         ;
ws_disabled                                      equ                 08000000h                                         ;
ws_dlgframe                                      equ                 00400000h                                         ;
ws_group                                         equ                 00020000h                                         ;
ws_hscroll                                       equ                 00100000h                                         ;
ws_iconic                                        equ                 20000000h                                         ;
ws_maximize                                      equ                 01000000h                                         ;
ws_maximizebox                                   equ                 00010000h                                         ;
ws_minimize                                      equ                 20000000h                                         ;
ws_minimizebox                                   equ                 00020000h                                         ;
ws_overlapped                                    equ                 00000000h                                         ;
ws_popup                                         equ                 80000000h                                         ;
ws_sizebox                                       equ                 00040000h                                         ;
ws_sysmenu                                       equ                 00080000h                                         ;
ws_tabstop                                       equ                 00010000h                                         ;
ws_thickframe                                    equ                 00040000h                                         ;
ws_tiled                                         equ                 00000000h                                         ;
ws_tiledwindow                                   equ                 00CF0000h                                         ;
ws_visible                                       equ                 10000000h                                         ;
ws_vscroll                                       equ                 00200000h                                         ;

;-----[X]---------------------------------------------------------------------------------------------------------------

;-----[Y]---------------------------------------------------------------------------------------------------------------

;-----[Z]---------------------------------------------------------------------------------------------------------------

