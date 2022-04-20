
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Data structure declarations.                                                                                         -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                               align                16

;-----[A]---------------------------------------------------------------------------------------------------------------

;-----[B]---------------------------------------------------------------------------------------------------------------

bgColor                                          real4               0.8,0.2,0.8,1.0                                   ; Background clear color: black

blendDesc                                        label               dxgi_blend_desc
                                                 dword               0                                                 ;AlphaToCoverageEnable  
                                                 dword               0                                                 ;IndependentBlendEnable 
                                                 ;Render targets, should be 8 but let's try with 1 since we only gonna use 1
                                                 dword               1                                                 ;RenderTarget.BlendEnable
                                                 dword               d3d11_blend_src_alpha                             ;RenderTarget.SrcBlend
                                                 dword               d3d11_blend_inv_src_alpha                         ;RenderTarget.DestBlend
                                                 dword               d3d11_blend_op_add                                ;RenderTarget.BlendOp
                                                 dword               d3d11_blend_one                                   ;RenderTarget.SrcBlendAlpha
                                                 dword               d3d11_blend_zero                                  ;RenderTarget.DestBlendAlpha
                                                 dword               d3d11_blend_op_add                                ;RenderTarget.BlendOpAlpha
                                                 byte                d3d11_color_write_enable_all                      ;RenderTarget.RenderTargetWriteMask    

blendDescAdditive                                label               dxgi_blend_desc
                                                 dword               0                                                 ;AlphaToCoverageEnable  
                                                 dword               0                                                 ;IndependentBlendEnable 
                                                 ;Render targets, should be 8 but let's try with 1 since we only gonna use 1
                                                 dword               1                                                 ;RenderTarget.BlendEnable
                                                 dword               d3d11_blend_src_alpha                             ;RenderTarget.SrcBlend
                                                 dword               d3d11_blend_inv_src_alpha                         ;RenderTarget.DestBlend
                                                 dword               d3d11_blend_op_add                                ;RenderTarget.BlendOp
                                                 dword               d3d11_blend_one                                   ;RenderTarget.SrcBlendAlpha
                                                 dword               d3d11_blend_one                                   ;RenderTarget.DestBlendAlpha
                                                 dword               d3d11_blend_op_add                                ;RenderTarget.BlendOpAlpha
                                                 byte                d3d11_color_write_enable_all                      ;RenderTarget.RenderTargetWriteMask                                                  

bitmapFileHeaderHeightMap                        label               bitmap_file_Header
                                                 word                ?                                                  ;bfType
                                                 dword               ?                                                  ;bfSize
                                                 word                ?                                                  ;bfReserved1
                                                 word                ?                                                  ;bfReserved2
                                                 dword               ?                                                  ;bfOffBits

bitmapInfoHeaderHeightMap                        label               bitmap_info_header
                                                 dword               ?                                                  ;biSize
                                                 qword               ?                                                  ;biWidth
                                                 qword               ?                                                  ;biHeight
                                                 word                ?                                                  ;biPlanes
                                                 word                ?                                                  ;biBitCount
                                                 dword               ?                                                  ;biCompression
                                                 dword               ?                                                  ;biSizeImage
                                                 qword               ?                                                  ;biXPelsPerMeter
                                                 qword               ?                                                  ;biYPelsPerMeter
                                                 dword               ?                                                  ;biClrUsed
                                                 dword               ?                                                  ;biClrImportant

;-----[C]---------------------------------------------------------------------------------------------------------------

                                                align               16                                                ; Set xmm word alignment
camPosition                                     real4               0.0, 350.0, -10.0, 1.0                               ; Eye
camTarget                                       real4               0.0, 0.0,  0.0, 0.0                               ; LookAt
camLookTo                                       real4               0.0, 0.0, 1.0, 0.0                              ; Direction
camLookToSkyQuad                                real4               0.0, 0.0, 1.0, 0.0                              ; Direction
camUp                                           real4               0.0, 1.0,  0.0, 0.0                               ; Up
camForward                                      real4               0.0, 0.0, 1.0, 0.0

                                                align                16

cbPerInstBufferDescription                      label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                dword               sizeof ( XMMatrix )                               ; ByteWidth
                                                dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                dword               D3D11_BIND_CONSTANT_BUFFER                        ; BindFlags
                                                dword               0                                                 ; CPUAccessFlags
                                                dword               0                                                 ; MiscFlags
                                                dword               0                                                 ; StructureByteStride                   


                                                align                16

cameraBuffer                                    real4               4 dup (0.0)

cameraBufferDescription                         label               d3d11_buffer_desc
                                                ;-----------------------------------------------------------------------
                                                dword               sizeof ( XMVector )                               ; ByteWidth
                                                dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                dword               D3D11_BIND_CONSTANT_BUFFER                        ; BindFlags
                                                dword               0                                                 ; CPUAccessFlags
                                                dword               0                                                 ; MiscFlags
                                                dword               0                                                 ; StructureByteStride         
         

carIndexBufferDesc                              label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( word ) * blueBeeIndexCount                 ; ByteWidth
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_INDEX_BUFFER                           ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0 ; sizeof ( vertex )                             ; StructureByteStride  

                                                align               16                                           

cbPerObj                                        real4               48 dup ( 0.0 )                                    ; Constant buffer

cbPerObjBufferDescription                       label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                dword               sizeof ( XMMatrix )  * 3                             ; ByteWidth
                                                dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                dword               D3D11_BIND_CONSTANT_BUFFER                        ; BindFlags
                                                dword               0                                                 ; CPUAccessFlags
                                                dword               0                                                 ; MiscFlags
                                                dword               0                                                 ; StructureByteStride         

client_rect                                      rect                <>                                                ; Main window client area

                                                align               16
colorGreen                                      real4               0.0, 1.0, 0.0, 1.0
colorRed                                        real4               1.0, 0.0, 0.0, 1.0
colorBlue                                       real4               0.0, 0.0, 1.0, 1.0
colorYellow                                     real4               1.0, 1.0, 0.0, 1.0


;-----[D]---------------------------------------------------------------------------------------------------------------


depthStencilViewDesc                             label               d3d11_texture2d_desc                              ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               ?                                                 ; _Width
                                                 dword               ?                                                 ; _Height
                                                 dword               1                                                 ; MipLevels
                                                 dword               1                                                 ; ArraySize
                                                 dword               DXGI_FORMAT_D24_UNORM_S8_UINT                     ; Format
                                                 dword               1                                                 ; SampleDesc.count
                                                 dword               0                                                 ; SampleDesc.quality
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_DEPTH_STENCIL                          ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags

depthStencilDesc                                 label               d3d11_depth_stencil_desc
                                                 dword               1                                                 ;DepthClipEnable                                  
                                                 dword               1 ;D3D11_DEPTH_WRITE_MASK_ALL                     ;DepthWriteMask                                    
                                                 dword               2 ;D3D11_COMPARISON_LESS                          ;DepthFunc                                         
                                                 dword               1                                                 ;StencilEnable                                    
                                                 byte                0ffh                                              ;StencilReadMask                                  
                                                 byte                0ffh                                              ;StencilWriteMask    
                                                 align               dword                             
                                                 dword               1;D3D11_STENCIL_OP_KEEP                           ;StencilFailOp       ;FrontFace                                                                                                            
                                                 dword               7;D3D11_STENCIL_OP_INCR                           ;StencilDepthFailOp
                                                 dword               1;D3D11_STENCIL_OP_KEEP                           ;StencilPassOp     
                                                 dword               8;D3D11_COMPARISON_ALWAYS                         ;StencilFunc
                                                 dword               1;D3D11_STENCIL_OP_KEEP                           ;StencilFailOp ;BackFace 
                                                 dword               8;D3D11_STENCIL_OP_DECR                           ;StencilDepthFailOp 
                                                 dword               1;D3D11_STENCIL_OP_KEEP                           ;StencilPassOp 
                                                 dword               8;D3D11_COMPARISON_ALWAYS                         ;StencilFunc 

depthStencilOffDesc                              label               d3d11_depth_stencil_desc
                                                 dword               0                                                 ;DepthClipEnable                                  
                                                 dword               1 ;D3D11_DEPTH_WRITE_MASK_ALL                     ;DepthWriteMask                                    
                                                 dword               8 ;D3D11_COMPARISON_ALWAYS                        ;DepthFunc                                         
                                                 dword               1                                                 ;StencilEnable                                    
                                                 byte                0ffh                                              ;StencilReadMask                                  
                                                 byte                0ffh                                              ;StencilWriteMask    
                                                 align               dword                             
                                                 dword               1;D3D11_STENCIL_OP_KEEP                           ;StencilFailOp       ;FrontFace                                                                                                            
                                                 dword               7;D3D11_STENCIL_OP_INCR                           ;StencilDepthFailOp
                                                 dword               1;D3D11_STENCIL_OP_KEEP                           ;StencilPassOp     
                                                 dword               8;D3D11_COMPARISON_ALWAYS                         ;StencilFunc
                                                 dword               1;D3D11_STENCIL_OP_KEEP                           ;StencilFailOp ;BackFace 
                                                 dword               8;D3D11_STENCIL_OP_DECR                           ;StencilDepthFailOp 
                                                 dword               1;D3D11_STENCIL_OP_KEEP                           ;StencilPassOp 
                                                 dword               8;D3D11_COMPARISON_ALWAYS                         ;StencilFunc 

                                                align                16

directionalLightBuffer                         	directionalLightBufferData	<>
												

directionalLightBufferDescription                label               d3d11_buffer_desc
                                                 ;-----------------------------------------------------------------------
                                                 dword               sizeof ( directionalLightBufferData )                 ; ByteWidth
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_CONSTANT_BUFFER                        ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0                                                 ; StructureByteStride  




                                                                                                                       

;-----[E]---------------------------------------------------------------------------------------------------------------



;-----[F]---------------------------------------------------------------------------------------------------------------


fontTextureDesc                                  label               d3d11_texture2d_desc                              ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               512                                                 ; _Width
                                                 dword               512                                                 ; _Height
                                                 dword               1                                                 ; MipLevels
                                                 dword               1                                                 ; ArraySize
                                                 dword               dxgi_format_r8g8b8a8_unorm                     ; Format
                                                 dword               1                                                 ; SampleDesc.count
                                                 dword               0                                                 ; SampleDesc.quality
                                                 dword               D3D11_USAGE_IMMUTABLE                               ; Usage
                                                 dword               D3D11_BIND_SHADER_RESOURCE                          ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags

fontTextureSubResourceData                       label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               fontData                                 ; pSysMem
                                                 dword               512 * sizeof(dword)                                                 ; SysMemPitch
                                                 dword               0                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
fontTextureSubResourceDataE                      label               byte                                              ; End marker

;-----[G]---------------------------------------------------------------------------------------------------------------

;-----[H]---------------------------------------------------------------------------------------------------------------



;-----[I]---------------------------------------------------------------------------------------------------------------

                                                 align                16

instanceBufferDesc                               label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( meshInstanceData ) * max_number_of_bees       ; ByteWidth
                                                 dword               D3D11_USAGE_DYNAMIC                               ; Usage
                                                 dword               D3D11_BIND_VERTEX_BUFFER                          ; BindFlags
                                                 dword               D3D11_CPU_ACCESS_WRITE                            ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0                                                 ; StructureByteStride      

                                    
instanceBufferData                               label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               beeTransformDataArray                                 ; pSysMem
                                                 dword               ?                                                 ; SysMemPitch
                                                 dword               ?                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
instanceBufferDataE                              label               byte                                              ; End marker
                                                 align                16



;-----[J]---------------------------------------------------------------------------------------------------------------

;-----[K]---------------------------------------------------------------------------------------------------------------

;-----[L]---------------------------------------------------------------------------------------------------------------


layout                                           label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                              
                                                ;-----------------------------------------------------------------------
                                                 qword               normal_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                       ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               32                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               48                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                 ;-----------------------------------------------------------------------
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               1                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               56                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                 ;-----------------------------------------------------------------------
                                                 qword               length_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32_float                             ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               64                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
layout_E                                         label               byte                                              ; End of array marker
                                                 
                                                 align               16
                                                 
layout_Road                                      label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                              
                                                ;-----------------------------------------------------------------------
                                                 qword               normal_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                       ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               32                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               48                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                 ;-----------------------------------------------------------------------
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               1                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               56                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                 ;-----------------------------------------------------------------------
                                                 qword               length_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32_float                             ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               64                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 ;-----------------------------------------------------------------------
                                                 qword               type_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32_uint                             ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               68                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
layout_Road_E                                    label               byte                                              ; End of array marker
                                                 
                                                 align               16

layout_cars                                      label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                              
                                                ;-----------------------------------------------------------------------
                                                 qword               normal_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                       ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               32                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               48                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                                
                                                 ;-----------------------------------------------------------------------
                                                 qword               instance_position_string                          ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               1                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_INSTANCE_DATA                     ; InputSlotClass
                                                 dword               1                                                 ; InstanceDataStepRate
                                                  ;-----------------------------------------------------------------------
                                                 qword               instance_rotation_string                          ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               1                                                 ; InputSlot
                                                 dword               16                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_INSTANCE_DATA                     ; InputSlotClass
                                                 dword               1                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
layout_cars_E                                    label               byte                                              ; End of array marker
                                                 align               16
layout_traffic_lights                            label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                              
                                                ;-----------------------------------------------------------------------
                                                 qword               normal_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                       ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               32                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               48                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                                
                                                 ;-----------------------------------------------------------------------
                                                 qword               instance_position_string                          ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               1                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_INSTANCE_DATA                     ; InputSlotClass
                                                 dword               1                                                 ; InstanceDataStepRate
                                                  ;-----------------------------------------------------------------------
                                                 qword               instance_rotation_string                          ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               1                                                 ; InputSlot
                                                 dword               16                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_INSTANCE_DATA                     ; InputSlotClass
                                                 dword               1                                                 ; InstanceDataStepRate
                                                  ;-----------------------------------------------------------------------
                                                 qword               instance_light_state_string                          ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32_uint                    ; Format
                                                 dword               1                                                 ; InputSlot
                                                 dword               32                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_INSTANCE_DATA                     ; InputSlotClass
                                                 dword               1                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
layout_traffic_lights_E                          label               byte                                              ; End of array marker
                                                 align               16


layout_malls                                     label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                              
                                                ;-----------------------------------------------------------------------
                                                 qword               normal_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                       ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               32                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               48                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                                
                                                 ;-----------------------------------------------------------------------
                                                 qword               instance_position_string                          ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               1                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_INSTANCE_DATA                     ; InputSlotClass
                                                 dword               1                                                 ; InstanceDataStepRate
                                                 ;-----------------------------------------------------------------------
                                                 qword               instance_rotation_string                          ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               1                                                 ; InputSlot
                                                 dword               16                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_INSTANCE_DATA                     ; InputSlotClass
                                                 dword               1                                                 ; InstanceDataStepRate
                                                  ;-----------------------------------------------------------------------
                                             
                                                ;-----------------------------------------------------------------------
layout_malls_E                                   label               byte                                              ; End of array marker


layout_mall_preview                              label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                              
                                                ;-----------------------------------------------------------------------
                                                 qword               normal_string                                     ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                       ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               32                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               48                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate                                                
                                               
                                             
                                                ;-----------------------------------------------------------------------
layout_mall_preview_E                            label               byte                                              ; End of array marker
                                                 align               16


layout_lines                                     label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate 
                                                ;-----------------------------------------------------------------------  
layout_lines_E                                   label               byte                                              ; End of array marker

layout_squares                                   label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate 
                                                  ;-----------------------------------------------------------------------
                                                 qword               instance_position_string                          ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               1                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_INSTANCE_DATA                     ; InputSlotClass
                                                 dword               1                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------  
                                                
layout_squares_E                                   label               byte                                              ; End of array marker

layout_font                                     label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate  
                                                ;-----------------------------------------------------------------------                                                  
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               2                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               32                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate     
layout_font_E                                   label               byte     
layout_points                                    label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate 
                                                ;-----------------------------------------------------------------------  
layout_points_E                                  label               byte                                              ; End of array marker

layout_quads                                     label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               16                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate  
                                                ;-----------------------------------------------------------------------                                                  
                                                 qword               textcoord0_string                                 ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               dxgi_format_r32g32_float                          ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               32                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate     
layout_quads_E                                   label               byte                                              ; End of array marker
                                                 align               16

lightDirection                                   real4               0.0, 0.0, 0.0, 0.0    
lightDirectionInv                                real4               0.0, 0.0, 0.0, 0.0    
lightForward                                     real4               9.0, 0.0, -1.0, 0.0
lightPosition                                    real4               3000.0, 0.0, -150000.0, 1.0                              ;This is made up for the shadowmap rendering
lightLookTo                                      real4               0.0, -1.0, 0.1, 0.0                              ; Direction
 

;-----[M]---------------------------------------------------------------------------------------------------------------
                                                
                                                 align                16


materials                                        real4               0.0;specular power ;Default, no specular
                                                 real4               0.0;specular intensity
                                                 ;Asphalt road
                                                 real4               8.0
                                                 real4               0.15
                                                 ;lane marker 
                                                 real4               12.0
                                                 real4               0.4  
                                                 ;Grass plain
                                                 real4               6.0
                                                 real4               0.01
                                                 ;Water
                                                 real4               32.0
                                                 real4               0.3



mouseBufferDescription                          label               d3d11_buffer_desc
                                                ;-----------------------------------------------------------------------
                                                dword               sizeof ( XMVector ) * 3                              ; ByteWidth
                                                dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                dword               D3D11_BIND_CONSTANT_BUFFER                        ; BindFlags
                                                dword               0                                                 ; CPUAccessFlags
                                                dword               0                                                 ; MiscFlags
                                                dword               0                                                 ; StructureByteStride         

                                                 align               16     
mouseMoveWorldPos                                XMVector            <>                                           ; Set xmm word alignment
mouseRay                                         real4               4  dup ( 0.0 )
mouseFar                                         real4               4  dup ( 0.0 )
mouseNear                                        real4               4  dup ( 0.0 )
                                                 align               16                                                ; Set xmm word alignment
mProj                                            real4               16 dup ( 0.0 )                                    ; Projection matrix
mProjSkyBox                                      real4               1.0, 0.0, 0.0, 0.0                                ; World matrix row 1
                                                 real4               0.0, 1.0, 0.0, 0.0                                ; World matrix row 2
                                                 real4               0.0, 0.0, 1.0, 0.0                                ; World matrix row 3
                                                 real4               0.0, 0.0, 0.0, 1.0                                ; World matrix row 4

mProjOrtho                                       real4               16 dup ( 0.0 )                                    ; Projection matrix
mProjSun                                         real4               16 dup ( 0.0 )                                    ; Projection matrix
mProjInverse                                     real4               16 dup ( 0.0 )                                    ; Projection matrix
mShadowFrustum                                   real4               16 dup ( 0.0 )
mView                                            real4               16 dup ( 0.0 )                                    ; View matrix
mViewInverse                                     real4               16 dup ( 0.0 )                                    ; View matrix
mViewLight                                       real4               16 dup ( 0.0 )                                    ; View matrix
mViewLightInverse                                real4               16 dup ( 0.0 )                                    ; View matrix


mWorld                                           real4               1.0, 0.0, 0.0, 0.0                                ; World matrix row 1
                                                 real4               0.0, 1.0, 0.0, 0.0                                ; World matrix row 2
                                                 real4               0.0, 0.0, 1.0, 0.0                                ; World matrix row 3
                                                 real4               0.0, 0.0, 0.0, 1.0                                ; World matrix row 4






mScale                                           real4               1.0, 0.0, 0.0, 0.0                                ; scale matrix row 1
                                                 real4               0.0, 1.0, 0.0, 0.0                                ; scale matrix row 2
                                                 real4               0.0, 0.0, 1.0, 0.0                                ; scale matrix row 3
                                                 real4               0.0, 0.0, 0.0, 1.0                                ; scale matrix row 4


mWVP                                             real4               16 dup ( 0.0 )                                    ; World * view * projection
mWVPInverse                                      real4               16 dup ( 0.0 )                                    ; World * view * projection


mRotation                                        real4               1.0, 0.0, 0.0, 0.0                                ; translation matrix row 1
                                                 real4               0.0, 1.0, 0.0, 0.0                                ; translation matrix row 2
                                                 real4               0.0, 0.0, 1.0, 0.0                                ; translation matrix row 3
                                                 real4               0.0, 0.0, 0.0, 1.0                                ; translation matrix row 4


mTranslation                                     real4               1.0, 0.0, 0.0, 0.0                                ; translation matrix row 1
                                                 real4               0.0, 1.0, 0.0, 0.0                                ; translation matrix row 2
                                                 real4               0.0, 0.0, 1.0, 0.0                                ; translation matrix row 3
                                                 real4               0.0, 0.0, 0.0, 1.0                                ; translation matrix row 4



;-----[N]---------------------------------------------------------------------------------------------------------------

ndc1                                             real4               -1.0, 1.0, 0.0, 1.0
ndc2                                             real4               1.0, 1.0, 0.0, 1.0
ndc3                                             real4               1.0, -1.0, 0.0, 1.0
ndc4                                             real4               -1.0, -1.0, 0.0, 1.0
ndc5                                             real4               -1.0, 1.0, 1.0, 1.0
ndc6                                             real4               1.0, 1.0, 1.0, 1.0
ndc7                                             real4               1.0, -1.0, 1.0, 1.0
ndc8                                             real4               -1.0, -1.0, 1.0, 1.0

ndcTransformed1                                  real4              -1.0, 1.0, 0.0, 0.0
ndcTransformed2                                  real4               1.0, 1.0, 0.0, 0.0
ndcTransformed3                                  real4              -1.0, 1.0, 1.0, 0.0
ndcTransformed4                                  real4               1.0, 1.0, 1.0, 0.0
ndcTransformed5                                  real4              -1.0, -1.0, 0.0, 0.0
ndcTransformed6                                  real4               1.0, -1.0, 0.0, 0.0
ndcTransformed7                                  real4              -1.0, -1.0, 1.0, 0.0
ndcTransformed8                                  real4               1.0, -1.0, 1.0, 0.0

ndcTransformedLight1                             real4              -1.0, 1.0, 0.0, 0.0
ndcTransformedLight2                             real4               1.0, 1.0, 0.0, 0.0
ndcTransformedLight3                             real4              -1.0, 1.0, 1.0, 0.0
ndcTransformedLight4                             real4               1.0, 1.0, 1.0, 0.0
ndcTransformedLight5                             real4              -1.0, -1.0, 0.0, 0.0
ndcTransformedLight6                             real4               1.0, -1.0, 0.0, 0.0
ndcTransformedLight7                             real4              -1.0, -1.0, 1.0, 0.0
ndcTransformedLight8                             real4               1.0, -1.0, 1.0, 0.0

ndcTransformedMax                                real4               0.0, 0.0, 0.0, 0.0
ndcTransformedMin                                real4               0.0, 0.0, 0.0, 0.0

ndcTransformedMaxClamp                           real4               640.0, 640.0, 640.0, 1.0
ndcTransformedMinClamp                           real4               -640.0, -640.0, -640.0, 1.0

;-----[O]---------------------------------------------------------------------------------------------------------------

                                                align 16

origin                                           real4               0.0, 0.0, 0.0, 1.0

;-----[P]---------------------------------------------------------------------------------------------------------------

previewBuffer                                   XMVector            2 dup (<>)

;-----[Q]---------------------------------------------------------------------------------------------------------------

;-----[R]---------------------------------------------------------------------------------------------------------------

rasterizerDesc                                   label               D3D11_RASTERIZER_DESC                             ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               D3D11_FILL_SOLID                                  ; FillMode
                                                 dword               D3D11_CULL_BACK                                   ; CullMode
                                                 dword               0                                                 ; FrontCounterClockwise
                                                 dword               0                                                 ; DepthBias
                                                 real4               0.0                                               ; DepthBiasClamp
                                                 real4               0.0                                               ; SlopeScaledDepthBias
                                                 dword               1                                                 ; DepthClipEnable
                                                 dword               0                                                 ; ScissorEnable
                                                 dword               0                                                 ; MultisampleEnable
                                                 dword               0                                                 ; AntialiasedLineEnable

rawInputMouse                                    label               RawInputDevice
                                                 word                01h  ;HID_USAGE_PAGE_GENERIC
                                                 word                02h  ;HID_USAGE_GENERIC_MOUSE
                                                 dword               0
                                                 qword               ?


rawInputData                                    RawInput              <>
rawInputDataSize                                dword                sizeof(RawInput)



;-----[S]---------------------------------------------------------------------------------------------------------------
                                                 align               16

samplerDesc                           					  label				 d3d11_sampler_desc

												                          dword				d3d11_filter_min_mag_mip_linear				;Filter
												                          dword				d3d11_texture_address_border							;AddressU
												                          dword				d3d11_texture_address_border							;AddressV
												                          dword				d3d11_texture_address_border							;AddressW
												                          real4				0.0														;MipLODBias
												                          dword				0														;MaxAnisotropy
												                          dword				d3d11_comparison_never								;ComparisonFunc
												                          real4 				0.0, 0.0, 0.0, 0.0										;BorderColor
												                          real4				0.0														;MinLOD																													
												                          real4				d3d11_float32_max 										;MaxLOD

shadowMapDesc                                    label               d3d11_texture2d_desc                              ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               shadowMapWidth                                                 ; _Width
                                                 dword               shadowMapWidth                                                 ; _Height
                                                 dword               1                                                 ; MipLevels
                                                 dword               1                                                 ; ArraySize
                                                 dword               DXGI_FORMAT_R24G8_TYPELESS                        ; Format
                                                 dword               1                                                 ; SampleDesc.count
                                                 dword               0                                                 ; SampleDesc.quality
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_DEPTH_STENCIL or D3D11_BIND_SHADER_RESOURCE                          ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags

shadowMapRasterizerDesc                          label               D3D11_RASTERIZER_DESC                             ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               D3D11_FILL_SOLID                                  ; FillMode
                                                 dword               D3D11_CULL_FRONT                                   ; CullMode
                                                 dword               0                                                 ; FrontCounterClockwise
                                                 dword               0                                                 ; DepthBias
                                                 real4               0.0                                               ; DepthBiasClamp
                                                 real4               0.0                                               ; SlopeScaledDepthBias
                                                 dword               1                                                 ; DepthClipEnable
                                                 dword               0                                                 ; ScissorEnable
                                                 dword               0                                                 ; MultisampleEnable
                                                 dword               0                                                 ; AntialiasedLineEnable

shadowMapDepthStencilViewDesc                    label                d3d11_depth_stencil_view_desc
                                                 dword                DXGI_FORMAT_D24_UNORM_S8_UINT
                                                 dword                D3D11_DSV_DIMENSION_TEXTURE2D
                                                 dword                0
                                                 ;d3d11_tex2d_dsv
                                                 dword                0
                                                 ;d3d11_tex2d_array_dsv
                                                 dword                ?
                                                 dword                ?
                                                 dword                ?
												 
												align               dword

shadowmapResourceShaderViewDesc					label				d3d11_shader_resource_view_desc_texture2d

												dword               	dxgi_format_r24_unorm_x8_typeless				;Format
												dword               	d3d11_srv_dimension_texture2d					;ViewDimension
												d3d11_tex_srv			<0,1>												;Texture2D



shadowViewport                                   label               d3d11_viewport                                    ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 real4               0.0                                               ; TopLeftX
                                                 real4               0.0                                               ; TopLeftY
                                                 real4               0.0                                               ; _Width
                                                 real4               0.0                                               ; _Height
                                                 real4               0.0                                               ; MinDepth
                                                 real4               1.0                                               ; MaxDepth

shadowMapComparisonSamplerDesc					 label				 d3d11_sampler_desc

												 dword				d3d11_filter_comparison_min_mag_mip_linear				;Filter
												 dword				d3d11_texture_address_border							;AddressU
												 dword				d3d11_texture_address_border							;AddressV
												 dword				d3d11_texture_address_border							;AddressW
												 real4				0.0														;MipLODBias
												 dword				0														;MaxAnisotropy
												 dword				d3d11_comparison_less_equal								;ComparisonFunc
												 real4 				1.0, 1.0, 1.0, 1.0										;BorderColor
												 real4				0.0														;MinLOD																													
												 real4				d3d11_float32_max 										;MaxLOD
																														
																														
                                                 align               16

skyBoxV1                                         real4               -1.0, -1.0, 0.0, 1.0
skyBoxV2                                         real4                1.0,  1.0, 0.0, 1.0
skyBoxV3                                         real4                1.0,  1.0, 0.0, 1.0
skyBoxV4                                         real4               -1.0, -1.0, 0.0, 1.0
skyBoxV5                                         real4               -1.0,  1.0, 0.0, 1.0
skyBoxV6                                         real4                1.0,  1.0, 0.0, 1.0

skyBoxPosition                                   real4                0.0, 0.0, 0.0, 1.0

skyBoxBuffer                                     real4               32 dup ( 0.0 )                                    ; Constant buffer

skyBoxBufferDescription                          label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( XMMatrix ) * 2                               ; ByteWidth
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_CONSTANT_BUFFER                        ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0                                                 ; StructureByteStride         


swapChainDesc                                    label               dxgi_swap_chain_desc                              ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               ?                                                 ; dxgi_swap_chain_desc.BufferDesc._Width
                                                 dword               ?                                                 ; dxgi_swap_chain_desc.BufferDesc._Height
                                                 dword               0                                                ; dxgi_swap_chain_desc.BufferDesc.RefreshRate.numerator
                                                 dword               0                                                 ; dxgi_swap_chain_desc.BufferDesc.RefreshRate.denominator
                                                 dword               DXGI_FORMAT_R8G8B8A8_UNORM                        ; dxgi_swap_chain_desc.BufferDesc.Format
                                                 dword               DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED              ; dxgi_swap_chain_desc.BufferDesc.ScanlineOrdering
                                                 dword               DXGI_MODE_SCALING_UNSPECIFIED                     ; dxgi_swap_chain_desc.BufferDesc.Scaling
                                                 dword               1                                                 ; dxgi_swap_chain_desc.SampleDesc.Count
                                                 dword               0                                                 ; dxgi_swap_chain_desc.SampleDesc.Quality
                                                 dword               DXGI_USAGE_RENDER_TARGET_OUTPUT                   ; dxgi_swap_chain_desc.BufferUsage
                                                 qword               1                                                 ; dxgi_swap_chain_desc.BufferCount
                                                 qword               ?                                                 ; dxgi_swap_chain_desc.OutputWindow
                                                 dword               1                                                 ; dxgi_swap_chain_desc.Windowed
                                                 dword               DXGI_SWAP_EFFECT_DISCARD                          ; dxgi_swap_chain_desc.SwapEffect
                                                 qword               0                                                 ; dxgi_swap_chain_desc.Flags

;-----[T]---------------------------------------------------------------------------------------------------------------

tempTextBuffer                                    byte              100


testTextureDesc                                  label               d3d11_texture2d_desc                              ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               200                                                 ; _Width
                                                 dword               200                                                 ; _Height
                                                 dword               1                                                 ; MipLevels
                                                 dword               1                                                 ; ArraySize
                                                 dword               dxgi_format_r8g8b8a8_unorm                     ; Format
                                                 dword               1                                                 ; SampleDesc.count
                                                 dword               0                                                 ; SampleDesc.quality
                                                 dword               D3D11_USAGE_IMMUTABLE                               ; Usage
                                                 dword               D3D11_BIND_SHADER_RESOURCE                          ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags


testTextureShaderViewDesc     					        label				d3d11_shader_resource_view_desc_texture2d

												                        dword               	dxgi_format_r8g8b8a8_unorm				;Format
												                        dword               	d3d11_srv_dimension_texture2d					;ViewDimension
												                        d3d11_tex_srv			<0,1>												;Texture2D



timeFrequency                                    large_integer       <>
timeStamp                                        large_integer       <>    


;-----[U]---------------------------------------------------------------------------------------------------------------

;-----[V]---------------------------------------------------------------------------------------------------------------                                               
                                              

                                                align              16
                                           
;vLines                                           line_vertex         number_of_lines dup (<>)

                                                align              16
vPoints                                          point_vertex         number_of_points dup (<>)

                                                align              16
vQuads                                           quad_vertex         number_of_quad_vertices dup (<>)

vTexture2d                                       quad_vertex         4 dup (<0.5, 0.5, 0.5, 0.5, 1.0, 1.0, 1.0,1.0, 0.5, 0.5>)


vertexBufferDataCars                             label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               blueBee                                                 ; pSysMem
                                                 dword               ?                                                 ; SysMemPitch
                                                 dword               ?                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
vertexBufferDataCarsE                           label               byte                                              ; End marker

vertexBufferDescCars                            label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( vertex ) * blueBeeVertexCount  ; ByteWidth
                                                 dword               D3D11_USAGE_DYNAMIC                               ; Usage
                                                 dword               D3D11_BIND_VERTEX_BUFFER                          ; BindFlags
                                                 dword               D3D11_CPU_ACCESS_WRITE                            ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0 ; sizeof ( vertex )                             ; StructureByteStride 

                                                align                16
                                               ;-----------------------------------------------------------------------
vertexBufferDataLinesE                           label               byte                                              ; End marker

vertexBufferDataPoints                            label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               vPoints                                                 ; pSysMem
                                                 dword               ?                                                 ; SysMemPitch
                                                 dword               ?                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
vertexBufferDataPointsE                           label               byte                                              ; End marker


vertexBufferDescPoints                            label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( point_vertex ) * number_of_points                             ; ByteWidth
                                                 dword               D3D11_USAGE_DYNAMIC                               ; Usage
                                                 dword               D3D11_BIND_VERTEX_BUFFER                          ; BindFlags
                                                 dword               D3D11_CPU_ACCESS_WRITE                            ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0 ; sizeof ( vertex )                             ; StructureByteStride 
vertexBufferDescPointsE                          label               d3d11_subresource_data                            ; Declare structure label


vertexBufferDataQuads                            label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               vQuads                                                 ; pSysMem
                                                 dword               ?                                                 ; SysMemPitch
                                                 dword               ?                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
vertexBufferDataQuadsE                           label               byte                                              ; End marker

vertexBufferDescQuads                            label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( quad_vertex ) * number_of_quad_vertices  ; ByteWidth
                                                 dword               D3D11_USAGE_DYNAMIC                               ; Usage
                                                 dword               D3D11_BIND_VERTEX_BUFFER                          ; BindFlags
                                                 dword               D3D11_CPU_ACCESS_WRITE                            ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0 ; sizeof ( vertex )                             ; StructureByteStride 
                                                
vertexBufferDataTexture2d                            label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               vTexture2d                                                 ; pSysMem
                                                 dword               ?                                                 ; SysMemPitch
                                                 dword               ?                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
vertexBufferDataTexture2dE                           label               byte                                              ; End marker

vertexBufferDescTexture2d                            label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( quad_vertex ) * 4  ; ByteWidth
                                                 dword               D3D11_USAGE_DYNAMIC                               ; Usage
                                                 dword               D3D11_BIND_VERTEX_BUFFER                          ; BindFlags
                                                 dword               D3D11_CPU_ACCESS_WRITE                            ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0 ; sizeof ( vertex )                             ; StructureByteStride 
                                                
                                                
vertexBufferFontTexture2d                            label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               textbufferVertices                                                 ; pSysMem
                                                 dword               ?                                                 ; SysMemPitch
                                                 dword               ?                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
vertexBufferFontTexture2dE                           label               byte                                              ; End marker

vertexBufferDescFontTexture2d                    label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( font_vertex ) * 4 * text_buffer_length  ; ByteWidth
                                                 dword               D3D11_USAGE_DYNAMIC                               ; Usage
                                                 dword               D3D11_BIND_VERTEX_BUFFER                          ; BindFlags
                                                 dword               D3D11_CPU_ACCESS_WRITE                            ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0 ; sizeof ( vertex )                             ; StructureByteStride 
                                                
                                                
                                                align                16

vertexMappedResource                             label               d3d11_mapped_subresource
                                                 qword               ?                                                 ;pData
                                                 qword               ?                                                 ;RowPitch
                                                 qword               ?                                                 ;DepthPitch

viewport                                         label               d3d11_viewport                                    ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 real4               0.0                                               ; TopLeftX
                                                 real4               0.0                                               ; TopLeftY
                                                 real4               0.0                                               ; _Width
                                                 real4               0.0                                               ; _Height
                                                 real4               0.0                                               ; MinDepth
                                                 real4               1.0                                               ; MaxDepth

                                                 align               16

viewRightVector                                  real4               4 dup (0.0)
viewUpVector                                     real4               4 dup (0.0)



;-----[W]---------------------------------------------------------------------------------------------------------------

waterBuffer                                      real4               4 dup (0.0)

waterBufferDescription                           label               d3d11_buffer_desc
                                                 ;-----------------------------------------------------------------------
                                                 dword               sizeof ( XMVector )                               ; ByteWidth
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_CONSTANT_BUFFER                        ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0                                                 ; StructureByteStride  



window_rect                                      rect                <>                                                ;

wnd                                              label               wndclassex                                        ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( wndclassex )                             ; cbSize
                                                 dword               classStyle                                        ; dwStyle
                                                 qword               Main_CB                                           ; lpfnCallback
                                                 dword               0                                                 ; cbClsExtra
                                                 dword               0                                                 ; cbWndExtra
wnd_hinst                                        qword               ?                                                 ; hInst
                                                 qword               0                                                 ; hIcon
wnd_hCursor                                      qword               ?                                                 ; hCursor
                                                 qword               0                                                 ; hbrBackground
                                                 qword               0                                                 ; lpszMenuName
                                                 qword               main_classname                                    ; lpszClassName
wnd_hIconSmall                                   qword               ?                                                 ; hIconSm

work_rect                                        rect                <>                                                ; General work rectangle
                                                
                                                align               16

worldBoundingBoxMax                              real4               600.0, 200.0, 600.0, 1.0
worldBoundingBoxMin                              real4               -600.0, 0.0, -600.0, 1.0;TODO: calculate these at start of the program

;-----[X]---------------------------------------------------------------------------------------------------------------

                                                 align              16
XMMask3                                          dword              0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 00000000h
XMMaskY                                          dword              00000000h, 0FFFFFFFFh, 00000000h, 00000000h
XMMaskNotY                                       dword              0FFFFFFFFh, 00000000h, 0FFFFFFFFh, 0FFFFFFFFh
XMMaskAbs                                        dword              7fffffffh, 7fffffffh, 7fffffffh, 7fffffffh

XMRed                                            real4              1.0, 0.0, 0.0, 1.0
XMRedPreview                                     real4              1.0, 0.3, 0.3, 0.6
XMBluePreview                                    real4              0.3, 0.3, 1.0, 0.6
XMX0Y0Z0W1                                       real4              0.0, 0.0, 0.0, 1.0
XMX0Y10Z0W1                                      real4              0.0, 50.0, 0.0, 1.0

XMM16Bytes3                                      byte               16 dup (3)
;-----[Y]---------------------------------------------------------------------------------------------------------------

ymmMinus1Dwords                                  dword              8 dup (-1)                                        
ymmMinus1Qwords                                  qword              4 dup (-1)                                        

;-----[Z]---------------------------------------------------------------------------------------------------------------


