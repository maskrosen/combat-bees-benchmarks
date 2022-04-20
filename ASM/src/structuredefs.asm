
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Structure definitions.                                                                                               -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

point                                            struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
x                                                dword               ?                                                 ;
y                                                dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
point                                            ends                                                                  ; End structure declaration



XMMatrix                                         struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
                                                 real4               16 dup ( 0.0 )                                    ; XMMatrix
                                                ;-----------------------------------------------------------------------
XMMatrix                                         ends                                                                  ; End structure declaration

XMVector                                         struct
                                                 real4               4 dup (?)
XMVector                                         ends

;-----[A]---------------------------------------------------------------------------------------------------------------

;-----[B]---------------------------------------------------------------------------------------------------------------

bitmap_file_Header                                 struct
bfType                                           word                 ?                                                  ;
bfSize                                           dword                ?                                                  ;
bfReserved1                                      word                 ?                                                  ;
bfReserved2                                      word                 ?                                                  ;
bfOffBits                                        dword                ?                                                  ;
bitmap_file_Header                                 ends

bitmap_info_header                                 struct
biSize                                           dword                ?
biWidth                                          qword                ?   
biHeight                                         qword                ?   
biPlanes                                         word                 ?  
biBitCount                                       word                 ?  
biCompression                                    dword                ?       
biSizeImage                                      dword                ?       
biXPelsPerMeter                                  qword                ?           
biYPelsPerMeter                                  qword                ?           
biClrUsed                                        dword                ?   
biClrImportant                                   dword                ?
bitmap_info_header                                 ends       

;-----[C]---------------------------------------------------------------------------------------------------------------

;-----[D]---------------------------------------------------------------------------------------------------------------

dxgi_sample_desc                                 struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
count                                            dword               ?                                                 ;
quality                                          dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
dxgi_sample_desc                                 ends                                                                  ; End structure declaration

d3d11_buffer_desc                                struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
ByteWidth                                        dword               ?                                                 ;
Usage                                            dword               ?                                                 ;
BindFlags                                        dword               ?                                                 ;
CPUAccessFlags                                   dword               ?                                                 ;
MiscFlags                                        dword               ?                                                 ;
StructureByteStride                              dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_buffer_desc                                ends                                                                  ; End structure declaration

d3d11_depth_stencil_op_description               struct
StencilFailOp                                    dword               ?
StencilDepthFailOp                               dword               ?
StencilPassOp                                    dword               ?
StencilFunc                                      dword               ?
d3d11_depth_stencil_op_description               ends

d3d11_depth_stencil_desc                         struct
DepthClipEnable                                  dword               ?
DepthWriteMask                                   dword               ? 
DepthFunc                                        dword               ? 
StencilEnable                                    dword               ?
StencilReadMask                                  byte                ?
StencilWriteMask                                 byte                ?
FrontFace                                        d3d11_depth_stencil_op_description <>
BackFace                                         d3d11_depth_stencil_op_description <>
d3d11_depth_stencil_desc                         ends

d3d11_tex_dsv                                    struct
MipSlice                                         dword               ?
d3d11_tex_dsv                                    ends

d3d11_tex_array_dsv                              struct
MipSlice                                         dword               ?
FirstArraySlice                                  dword               ?
ArraySize                                        dword               ?
d3d11_tex_array_dsv                              ends

d3d11_buffer_srv								struct

FirstElement									dword				?
ElementOffset									dword				?
NumElements										dword				?
ElementWidth									dword				?

d3d11_buffer_srv								ends

d3d11_tex_srv									struct
MostDetailedMip									dword				?
MipLevels										dword				?
d3d11_tex_srv									ends

d3d11_tex_array_srv                             struct
MostDetailedMip                                 dword               ?
MipSlice                                        dword               ?
FirstArraySlice                                 dword               ?
ArraySize                                       dword               ?
d3d11_tex_array_srv                             ends

d3d11_bufferex_srv								struct				
FirstElement									dword				?				
NumElements										dword				?			
Flags											dword				?
d3d11_bufferex_srv								ends		

d3d11_tex2dms_array_srv                         struct
FirstArraySlice                                 dword               ?
ArraySize                                       dword               ?
d3d11_tex2dms_array_srv                         ends


d3d11_depth_stencil_view_desc                   struct
Format                                          dword               ?
ViewDimension                                   dword               ?
Flags                                           dword               ?
Texture                                         d3d11_tex_dsv <>
TextureArray                                  	d3d11_tex_array_dsv <>
d3d11_depth_stencil_view_desc                   ends


d3d11_input_element_desc                         struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
SemanticName                                     qword               ?                                                 ;
SemanticIndex                                    dword               ?                                                 ;
Format                                           dword               ?                                                 ;
InputSlot                                        dword               ?                                                 ;
AlignedByteOffset                                dword               ?                                                 ;
InputSlotClass                                   dword               ?                                                 ;
InstanceDataStepRate                             dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_input_element_desc                         ends                                                                  ; End structure declaration

d3d11_mapped_subresource                         struct

pData                                            qword               ?
RowPitch                                         qword               ?
DepthPitch                                       qword               ?

d3d11_mapped_subresource                         ends


d3d11_sampler_desc								struct

Filter											dword				?					 
AddressU										dword				?
AddressV										dword				?
AddressW										dword				?
MipLODBias										real4				0.0
MaxAnisotropy									dword				?
ComparisonFunc									dword				?
BorderColor  									XMVector			<>
MinLOD											real4				0.0
MaxLOD											real4				0.0

d3d11_sampler_desc								ends

d3d11_shader_resource_view_desc_texture2d		struct

Format                                          dword               	?
ViewDimension                                   dword               	?
Texture2D                                       d3d11_tex_srv 			<>

d3d11_shader_resource_view_desc_texture2d		ends


d3d11_rasterizer_desc                            struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
FillMode                                         dword               ?                                                 ;
CullMode                                         dword               ?                                                 ;
FrontCounterClockwise                            dword               ?                                                 ;
DepthBias                                        dword               ?                                                 ;
DepthBiasClamp                                   real4               0.0                                               ;
SlopeScaledDepthBias                             real4               0.0                                               ;
DepthClipEnable                                  dword               ?                                                 ;
ScissorEnable                                    dword               ?                                                 ;
MultisampleEnable                                dword               ?                                                 ;
AntialiasedLineEnable                            dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_rasterizer_desc                            ends                                                                  ; End structure declaration

d3d11_render_target_blend_desc                   struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
BlendEnable                                      dword               ?                                                 ;
SrcBlend                                         dword               ?                                                 ;
DestBlend                                        dword               ?                                                 ;
BlendOp                                          dword               ?                                                 ;
SrcBlendAlpha                                    dword               ?                                                 ;
DestBlendAlpha                                   dword               ?                                                 ;
BlendOpAlpha                                     dword               ?                                                 ;
RenderTargetWriteMask                            byte                ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_render_target_blend_desc                   ends                                                                  ; End structure declaration

d3d11_subresource_data                           struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
pSysMem                                          qword               ?                                                 ;
SysMemPitch                                      dword               ?                                                 ;
SysMemSlicePitch                                 dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_subresource_data                           ends                                                                  ; End structure declaration

d3d11_texture2d_desc                             struct                                                                ;
                                                ;-----------------------------------------------------------------------
_Width                                           dword               ?                                                 ;
_Height                                          dword               ?                                                 ;
MipLevels                                        dword               ?                                                 ;
ArraySize                                        dword               ?                                                 ;
Format                                           dword               ?                                                 ;
SampleDesc                                       dxgi_sample_desc    <>                                                ;
Usage                                            dword               ?                                                 ;
BindFlags                                        dword               ?                                                 ;
CPUAccessFlags                                   dword               ?                                                 ;
MiscFlags                                        dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_texture2d_desc                             ends                                                                  ;


d3d11_viewport                                   struct                                                               ;
                                                ;-----------------------------------------------------------------------
TopLeftX                                         real4               0.0                                               ;
TopLeftY                                         real4               0.0                                               ;
_Width                                           real4               0.0                                               ;
_Height                                          real4               0.0                                               ;
MinDepth                                         real4               0.0                                               ;
MaxDepth                                         real4               0.0                                               ;
                                                ;-----------------------------------------------------------------------
d3d11_viewport                                   ends                                                                  ;

dxgi_rational                                    struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
numerator                                        dword               ?                                                 ;
denominator                                      dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
dxgi_rational                                    ends                                                                  ; End structure declaration

dxgi_mode_desc                                   struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
_Width                                           dword               ?                                                 ;
_Height                                          dword               ?                                                 ;
RefreshRate                                      dxgi_rational       <>                                                ;
Format                                           dword               ?                                                 ;
ScanlineOrdering                                 dword               ?                                                 ;
Scaling                                          dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
dxgi_mode_desc                                   ends                                                                  ; End structure declaration

dxgi_swap_chain_desc                             struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
BufferDesc                                       dxgi_mode_desc      <>                                                ;
SampleDesc                                       dxgi_sample_desc    <>                                                ;
BufferUsage                                      dword               ?                                                 ;
BufferCount                                      qword               ?                                                 ;
OutputWindow                                     qword               ?                                                 ;
Windowed                                         dword               ?                                                 ;
SwapEffect                                       dword               ?                                                 ;
Flags                                            qword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
dxgi_swap_chain_desc                             ends                                                                  ; End structure declaration

dxgi_blend_desc                                 struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
AlphaToCoverageEnable                            dword               ?                                                 ;
IndependentBlendEnable                           dword               ?                                                 ;
RenderTarget                                     d3d11_render_target_blend_desc <>
                                                ;-----------------------------------------------------------------------
dxgi_blend_desc                                 ends                                                                  ; End structure declaration


;-----[E]---------------------------------------------------------------------------------------------------------------


;-----[F]---------------------------------------------------------------------------------------------------------------

font_char                                       struct
id                                              word                ?
u                                               real4               ?                               
v                                               real4               ?                               
tWidth                                          real4               ? ;width on texture in uv space                              
tHeight                                         real4               ? ;height on texture in uv space   
xOffset                                         real4               ? ;offset from current cursor pos to left side of character              
yOffset                                         real4               ? ;offset from top of line to top of character              
xAdvance                                        real4               ? ;how far to move to right for next character    
font_char                                       ends          


font_vertex                                     struct
                                               ;-----------------------------------------------------------------------
x                                                real4               ?                                               ;
y                                                real4               ?                                               ;
z                                                real4               ?                                               ;
w                                                real4               ?                                               ;
cr                                               real4               ?                                               ;
cg                                               real4               ?                                               ;
cb                                               real4               ?                                               ;
ca                                               real4               ?                                               ;
u                                                real4               ?                                               ;
v                                                real4               ?                                               ;
uvWidth                                          real4               ?
uvHeight                                         real4               ?
font_vertex                                      ends


;-----[G]---------------------------------------------------------------------------------------------------------------

;-----[H]---------------------------------------------------------------------------------------------------------------

;-----[I]---------------------------------------------------------------------------------------------------------------

index                                            struct
v1                                               word                0
v2                                               word                0
v3                                               word                0
index                                            ends

index_dword                                      struct
v1                                               dword                0
v2                                               dword                0
v3                                               dword                0
index_dword                                      ends

intersection_line                               struct
active                                          byte                0
carIndex                                        dword               0
startPos                                        XMVector            <>
middlePos                                       XMVector            <>
endPos                                          XMVector            <>
intersection_line                               ends


;-----[J]---------------------------------------------------------------------------------------------------------------

;-----[K]---------------------------------------------------------------------------------------------------------------

;-----[L]---------------------------------------------------------------------------------------------------------------

large_integer                                    struct
QuadPart                                         qword               ?
large_integer                                    ends

line_section                                    struct
x1                                              real4                ?
y1                                              real4                ?
z1                                              real4                ?
x2                                              real4                ?
y2                                              real4                ?
z2                                              real4                ?
line_section                                    ends


line_vertex                                      struct
x                                                real4               ?
y                                                real4               ?
Z                                                real4               ?
w                                                real4               ?
r                                                real4               ?
g                                                real4               ?
b                                                real4               ?
a                                                real4               ?
line_vertex                                      ends

;-----[M]---------------------------------------------------------------------------------------------------------------


material                                         struct
specularPower                                    real4               0.0
specularIntensity                                real4               0.0
material                                         ends


;!-----Important----! if data is changed here the copy to the instance buffer needs to be updated as well since it assumes meshInstanceData is 32 bytes
meshInstanceData								struct
position                                        XMVector			<>
rotation                                        XMVector			<>
meshInstanceData								ends

meshTrafficLightInstanceData								struct
position                                        XMVector			<>
rotation                                        XMVector			<>
lightState                                      dword               0 ;0 red, 1 yellow to green, 2 green, 3 yellow to red
meshTrafficLightInstanceData								ends

msg                                              struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
hwnd                                             qword               ?                                                 ;
message                                          dword               ?                                                 ;
wparamx                                          qword               ?                                                 ;
lparam                                           qword               ?                                                 ;
time                                             qword               ?                                                 ;
pt                                               point               <>                                                ;
extra                                            qword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
msg                                              ends                                                                  ; End structure declaration

;-----[N]---------------------------------------------------------------------------------------------------------------

;-----[O]---------------------------------------------------------------------------------------------------------------

;-----[P]---------------------------------------------------------------------------------------------------------------
piece                                           struct
x1                                              dword                0
y1                                              dword                0
x2                                              dword                0
y2                                              dword                0    
x3                                              dword                0    
y3                                              dword                0    
x4                                              dword                0    
y4                                              dword                0   
highestY                                        dword                0 
piece                                           ends

point_vertex                                      struct
x                                                real4               ?
y                                                real4               ?
Z                                                real4               ?
w                                                real4               ?
r                                                real4               ?
g                                                real4               ?
b                                                real4               ?
a                                                real4               ?
point_vertex                                      ends

;-----[Q]---------------------------------------------------------------------------------------------------------------

quad_vertex                                     struct
                                               ;-----------------------------------------------------------------------
x                                                real4               ?                                               ;
y                                                real4               ?                                               ;
z                                                real4               ?                                               ;
w                                                real4               ?                                               ;
cr                                               real4               ?                                               ;
cg                                               real4               ?                                               ;
cb                                               real4               ?                                               ;
ca                                               real4               ?                                               ;
u                                                real4               ?                                               ;
v                                                real4               ?                                               ;
quad_vertex                                      ends

;-----[R]---------------------------------------------------------------------------------------------------------------

RawInputDevice                                   struct
usUsagePage                                      word                 ?
usUsage                                          word                 ?
dwFlags                                          dword                ?
hwndTarget                                       qword                ?
RawInputDevice                                   ends

RawInputHeader                                   struct
dwType                                           dword                ?
dwSize                                           dword                ?
hDevice                                          qword                ?
WParam                                           qword                ?
RawInputHeader                                   ends

RawHID                                           struct
dwSizeHid                                        dword                ?
dwCount                                          dword                ?
bRawData                                         byte                 ?
RawHID                                           ends

RawKeyboard                                      struct
MakeCode                                         word                 ?
Flags                                            word                 ?
Reserved                                         word                 ?
VKey                                             word                 ?
Message                                          dword                ?
ExtraInformation                                 qword                ?
RawKeyboard                                      ends

RawMouse                                         struct
usFlags                                          word                 ?
padding                                          word                 ? ;needed since the union is aligned at 4 bytes
ulButtons                                        dword                ? ;this is really a union and could also contain the two words, USHORT usButtonFlags, USHORT usButtonData
ulRawButtons                                     dword                ?
lLastX                                           dword                ?
lLastY                                           dword                ?
ulExtraInformation                               dword                ?
RawMouse                                         ends


RawInput                                         struct
header                                           RawInputHeader       <>
data                                             RawMouse             <> ;this is really a union of RawMouse, RawKeyboard and RawHID but mouse is largest so we use that one here
RawInput                                         ends

rect                                             struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
left                                             dword               ?                                                 ; Left edge
top                                              dword               ?                                                 ; Top edge
right                                            dword               ?                                                 ; Right edge
bottom                                           dword               ?                                                 ; Bottom edge
                                                ;-----------------------------------------------------------------------
rect                                             ends                                                                  ; End structure declaration



roadVertex                                       struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
x                                               real4               ?                                               ;
y                                               real4               ?                                               ;
z                                               real4               ?                                               ;
w                                               real4               ?                                               ;
cr                                              real4               ?                                               ;
cg                                              real4               ?                                               ;
cb                                              real4               ?                                               ;
ca                                              real4               ?                                               ;
nx                                              real4               ?                                               ;
ny                                              real4               ?                                               ;
nz                                              real4               ?                                               ;
nw                                              real4               ?                                               ;
specularPower                                   real4               ?
specularIntensity                               real4               ?
u                                               real4               ?                                           
v                                               real4               ? 
vertexLength                                    real4               ?         
roadType                                        dword               ?                                                              
                                                ;-----------------------------------------------------------------------
roadVertex                                       ends                                                                  ; End structure declaration


;-----[S]---------------------------------------------------------------------------------------------------------------


;-----[T]---------------------------------------------------------------------------------------------------------------


;-----[U]---------------------------------------------------------------------------------------------------------------

;-----[V]---------------------------------------------------------------------------------------------------------------


vector4                                          struct

x                                                real4               ?                                               ;
y                                                real4               ?                                               ;
z                                                real4               ?                                               ;
w                                                real4               ?                                               ;

vector4                                          ends

vector3                                          struct

x                                                real4               ?                                               ;
y                                                real4               ?                                               ;
z                                                real4               ?                                               ;

vector3                                          ends


vertex                                           struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
x                                                real4               ?                                               ;
y                                                real4               ?                                               ;
z                                                real4               ?                                               ;
w                                                real4               ?                                               ;
cr                                               real4               ?                                               ;
cg                                               real4               ?                                               ;
cb                                               real4               ?                                               ;
ca                                               real4               ?                                               ;
nx                                               real4               ?                                               ;
ny                                               real4               ?                                               ;
nz                                               real4               ?                                               ;
nw                                               real4               ?                                               ;                                      
                                                ;-----------------------------------------------------------------------
vertex                                           ends                                                                  ; End structure declaration



;-----[W]---------------------------------------------------------------------------------------------------------------

WndClassEx                                       struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
cbSize                                           dword               sizeof ( wndclassex )                             ; Size of this structure
dwStyle                                          dword               ?                                                 ; Style dword
lpfnCallback                                     qword               ?                                                 ; Window procedure pointer
cbClsExtra                                       dword               ?                                                 ; Extra class bytes
cbWndExtra                                       dword               ?                                                 ; Extra window bytes
hInst                                            qword               ?                                                 ; Instance handle
hIconx                                           qword               ?                                                 ; Icon handle
hCursorx                                         qword               ?                                                 ; Cursor handle
hbrBackground                                    qword               ?                                                 ; Background brush handle
lpszMenuName                                     qword               ?                                                 ; Menu name pointer
lpszClassName                                    qword               ?                                                 ; Class name pointer
hIconSm                                          qword               ?                                                 ; Small icon handle
                                                ;-----------------------------------------------------------------------
WndClassEx                                       ends                                                                  ; End structure declaration

;-----[X]---------------------------------------------------------------------------------------------------------------

;-----[Y]---------------------------------------------------------------------------------------------------------------

;-----[Z]---------------------------------------------------------------------------------------------------------------





directionalLightBufferData 						struct

lightDirection									XMVector			<>
mMVP											XMMatrix			<>
sunPosition                                     XMVector            <>

directionalLightBufferData						 	ends

