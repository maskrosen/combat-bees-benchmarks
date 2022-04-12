;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; External array declarations.                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

extrn                                            beeTransformDataArray:meshInstanceData
extrn                                            cbPerInst:real4
extrn											 fontData:byte

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; External function declarations.                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

;------[A]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_AdjustWindowRect:qword                                          ;

;------[B]--------------------------------------------------------------------------------------------------------------

;------[C]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_cosf:qword                                              ;
extrn                                            __imp_CreateWindowExA:qword                                           ;

;------[D]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_DefWindowProcA:qword                                            ;
extrn                                            __imp_DestroyWindow:qword                                             ;
extrn                                            __imp_DispatchMessageA:qword                                          ;
extrn                                            __imp_D3D11CreateDeviceAndSwapChain:qword                             ;
extrn                                            __imp_D3DCompileFromFile:qword                                    ;

;------[E]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_EnumDesktopWindows:qword                                        ;
extrn                                            __imp_ExitProcess:qword                                               ;

;------[F]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_fclose:qword                                             ;
extrn                                            __imp_fopen:qword                                             ;
extrn                                            __imp_fread:qword                                             ;
extrn                                            __imp_fseek:qword                                             ;
extrn                                            __imp_fwrite:qword                                             ;

;------[G]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_GetClientRect:qword                                             ;
extrn                                            __imp_GetCurrentThreadId:qword                                        ;
extrn                                            __imp_GetDIBits:qword                                                 ;
extrn                                            __imp_GetLastError:qword                                              ;
extrn                                            __imp_GetModuleHandleA:qword                                          ;
extrn                                            __imp_GetParent:qword                                                 ;
extrn                                            __imp_GetRawInputData:qword
extrn                                            __imp_GetSystemTime:qword
extrn                                            __imp_GetThreadDesktop:qword                                          ;
extrn                                            __imp_GetWindowTextA:qword                                            ;
extrn                                            __imp__gcvt:qword                                            ;

;------[H]--------------------------------------------------------------------------------------------------------------

;------[I]--------------------------------------------------------------------------------------------------------------
extrn                                            __imp_IntersectsProxy:qword                                            ;

;------[J]--------------------------------------------------------------------------------------------------------------

;------[K]--------------------------------------------------------------------------------------------------------------

;------[L]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_LoadImageA:qword                                                ;

;------[M]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_MoveWindow:qword                                                ;

;------[N]--------------------------------------------------------------------------------------------------------------

;------[O]--------------------------------------------------------------------------------------------------------------

;------[P]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_PeekMessageA:qword                                              ;
extrn                                            __imp_PostQuitMessage:qword                                           ;

;------[Q]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_QueryPerformanceFrequency:qword
extrn                                            __imp_QueryPerformanceCounter:qword

;------[R]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_RegisterClassExA:qword                                          ;
extrn                                            __imp_RegisterRawInputDevices:qword                                          ;

;------[S]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_SendMessageA:qword                                              ;
extrn                                            __imp_SetCursorPos:qword                                              ;
extrn                                            __imp_ShowCursor:qword                                              ;
extrn                                            __imp_sinf:qword                                              ;
extrn                                            __imp_ShowWindow:qword                                                ;
extrn                                            __imp_SystemParametersInfoA:qword                                     ;

;------[T]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_TranslateMessage:qword                                          ;
extrn                                            __imp_timeGetTime:qword                                          ;

;------[U]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_UnregisterClassA:qword                                          ;

;------[V]--------------------------------------------------------------------------------------------------------------

extrn                                            __imp_ValidateRect:qword                                              ;

;------[W]--------------------------------------------------------------------------------------------------------------

;------[X]--------------------------------------------------------------------------------------------------------------


extrn                                            __imp_XMMatrixLookAtLHProxy:qword                                     ;
extrn                                            __imp_XMMatrixLookToLHProxy:qword                                     ;
extrn                                            __imp_XMMatrixLookAtRHProxy:qword                                     ;
extrn                                            __imp_XMMatrixMultiplyProxy:qword                                     ;
extrn                                            __imp_XMMatrixPerspectiveFovLHProxy:qword                             ;
extrn                                            __imp_XMMatrixOrthographicLHProxy:qword                             ;
extrn                                            __imp_XMMatrixOrthographicOffCenterLHProxy:qword                             ;
extrn                                            __imp_XMMatrixPerspectiveFovRHProxy:qword                             ;
extrn                                            __imp_XMMatrixRotationRollPitchYawProxy:qword                             ;
extrn                                            __imp_XMMatrixRotationXProxy:qword                                    ;
extrn                                            __imp_XMMatrixRotationYProxy:qword                                    ;
extrn                                            __imp_XMMatrixTransposeProxy:qword                                    ;
extrn                                            __imp_XMMatrixInverseProxy:qword                                    ;
extrn                                            __imp_XMVector3TransformProxy:qword                                    ;
extrn                                            __imp_XMVector4CrossProxy:qword                                    ;
extrn                                            __imp_XMVector3UnprojectProxy:qword                                    ;

;------[Y]--------------------------------------------------------------------------------------------------------------

;------[Z]--------------------------------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; External function text equates.                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

;------[A]--------------------------------------------------------------------------------------------------------------

AdjustWindowRect                                 textequ             <__imp_AdjustWindowRect>                          ;

;------[B]--------------------------------------------------------------------------------------------------------------

;------[C]--------------------------------------------------------------------------------------------------------------

cosf                                             textequ             <__imp_cosf>                              ;
CreateWindowEx                                   textequ             <__imp_CreateWindowExA>                           ;

;------[D]--------------------------------------------------------------------------------------------------------------

D3D11CreateDeviceAndSwapChain                    textequ             <__imp_D3D11CreateDeviceAndSwapChain>             ;
D3DCompileFromFile                               textequ             <__imp_D3DCompileFromFile>                    ;
DefWindowProc                                    textequ             <__imp_DefWindowProcA>                            ;
DestroyWindow                                    textequ             <__imp_DestroyWindow>                             ;
DispatchMessage                                  textequ             <__imp_DispatchMessageA>                          ;

;------[E]--------------------------------------------------------------------------------------------------------------

EnumDesktopWindows                               textequ             <__imp_EnumDesktopWindows>                        ;
ExitProcess                                      textequ             <__imp_ExitProcess>                               ;

;------[F]--------------------------------------------------------------------------------------------------------------

fclose                                           textequ             <__imp_fclose>                             ;
fopen                                            textequ             <__imp_fopen>                             ;
fread                                            textequ             <__imp_fread>                             ;
fseek                                            textequ             <__imp_fseek>                             ;
fwrite                                            textequ             <__imp_fwrite>                             ;

;------[G]--------------------------------------------------------------------------------------------------------------

GetClientRect                                    textequ             <__imp_GetClientRect>                             ;
GetCurrentThreadId                               textequ             <__imp_GetCurrentThreadId>                        ;
GetDIBits                                        textequ             <__imp_GetDIBits>                                 ;
GetLastError                                     textequ             <__imp_GetLastError>                              ;
GetModuleHandle                                  textequ             <__imp_GetModuleHandleA>                          ;
GetParent                                        textequ             <__imp_GetParent>                                 ;
GetRawInputData                                  textequ             <__imp_GetRawInputData>
GetSystemTime                                    textequ             <__imp_GetSystemTime>
GetThreadDesktop                                 textequ             <__imp_GetThreadDesktop>                          ;
GetWindowText                                    textequ             <__imp_GetWindowTextA>                            ;
gcvt			                                 textequ             <__imp__gcvt>                            ;

;------[H]--------------------------------------------------------------------------------------------------------------

;------[I]--------------------------------------------------------------------------------------------------------------
IntersectsProxy                                  textequ             <__imp_IntersectsProxy>                            ;

;------[J]--------------------------------------------------------------------------------------------------------------

;------[K]--------------------------------------------------------------------------------------------------------------

;------[L]--------------------------------------------------------------------------------------------------------------

LoadImage                                        textequ             <__imp_LoadImageA>                                ;

;------[M]--------------------------------------------------------------------------------------------------------------

MoveWindow                                       textequ             <__imp_MoveWindow>                                ;

;------[N]--------------------------------------------------------------------------------------------------------------

;------[O]--------------------------------------------------------------------------------------------------------------

;------[P]--------------------------------------------------------------------------------------------------------------

PeekMessage                                      textequ             <__imp_PeekMessageA>                              ;
PostQuitMessage                                  textequ             <__imp_PostQuitMessage>                           ;

;------[Q]--------------------------------------------------------------------------------------------------------------
QueryPerformanceFrequency                        textequ             <__imp_QueryPerformanceFrequency>
QueryPerformanceCounter                          textequ             <__imp_QueryPerformanceCounter>

;------[R]--------------------------------------------------------------------------------------------------------------

RegisterClassEx                                  textequ             <__imp_RegisterClassExA>                          ;
RegisterRawInputDevices                          textequ             <__imp_RegisterRawInputDevices>                          ;

;------[S]--------------------------------------------------------------------------------------------------------------

SendMessage                                      textequ             <__imp_SendMessageA>                              ;
SetCursorPos                                     textequ             <__imp_SetCursorPos>                              ;
ShowCursor                                       textequ             <__imp_ShowCursor>                              ;
sinf                                             textequ             <__imp_sinf>                              ;
ShowWindow                                       textequ             <__imp_ShowWindow>                                ;
SystemParametersInfo                             textequ             <__imp_SystemParametersInfoA>                     ;

;------[T]--------------------------------------------------------------------------------------------------------------

TranslateMessage                                 textequ             <__imp_TranslateMessage>                          ;
TimeGetTime                                      textequ             <__imp_timeGetTime>

;------[U]--------------------------------------------------------------------------------------------------------------

UnregisterClass                                  textequ             <__imp_UnregisterClassA>                          ;

;------[V]--------------------------------------------------------------------------------------------------------------

ValidateRect                                     textequ             <__imp_ValidateRect>                              ;

;------[W]--------------------------------------------------------------------------------------------------------------

;------[X]--------------------------------------------------------------------------------------------------------------

XMMatrixLookAtLHProxy                            textequ             <__imp_XMMatrixLookAtLHProxy>                     ;
XMMatrixLookToLHProxy                            textequ             <__imp_XMMatrixLookToLHProxy>                     ;
XMMatrixLookAtRHProxy                            textequ             <__imp_XMMatrixLookAtRHProxy>                     ;
XMMatrixMultiplyProxy                            textequ             <__imp_XMMatrixMultiplyProxy>                     ;
XMMatrixPerspectiveFovLHProxy                    textequ             <__imp_XMMatrixPerspectiveFovLHProxy>             ;
XMMatrixOrthographicLHProxy                      textequ             <__imp_XMMatrixOrthographicLHProxy>             ;
XMMatrixOrthographicOffCenterLHProxy             textequ             <__imp_XMMatrixOrthographicOffCenterLHProxy>             ;
XMMatrixPerspectiveFovRHProxy                    textequ             <__imp_XMMatrixPerspectiveFovRHProxy>             ;
XMMatrixRotationRollPitchYawProxy                textequ             <__imp_XMMatrixRotationRollPitchYawProxy>         ;
XMMatrixRotationXProxy                           textequ             <__imp_XMMatrixRotationXProxy>                    ;
XMMatrixRotationYProxy                           textequ             <__imp_XMMatrixRotationYProxy>                    ;
XMMatrixTransposeProxy                           textequ             <__imp_XMMatrixTransposeProxy>                    ;
XMMatrixInverseProxy                             textequ             <__imp_XMMatrixInverseProxy>                    ;
XMVector3TransformProxy                          textequ             <__imp_XMVector3TransformProxy>                    ;
XMVector4CrossProxy                              textequ             <__imp_XMVector4CrossProxy>                    ;
XMVector3UnprojectProxy                          textequ             <__imp_XMVector3UnprojectProxy>                    ;
 
;------[Y]--------------------------------------------------------------------------------------------------------------

;------[Z]--------------------------------------------------------------------------------------------------------------
