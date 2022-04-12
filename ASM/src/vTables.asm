
ID3D10Blob_QueryInterface                        textequ             <qword ptr [rbx]>                                 ;
ID3D10Blob_AddRef                                textequ             <qword ptr [rbx+8]>                               ;
ID3D10Blob_Release                               textequ             <qword ptr [rbx+16]>                              ;
ID3D10Blob_GetBufferPointer                      textequ             <qword ptr [rbx+24]>                              ;
ID3D10Blob_GetBufferSize                         textequ             <qword ptr [rbx+32]>                              ;

ID3D11Buffer_QueryInterface                      textequ             <qword ptr [rbx]>                                 ;
ID3D11Buffer_AddRef                              textequ             <qword ptr [rbx+8]>                               ;
ID3D11Buffer_Release                             textequ             <qword ptr [rbx+16]>                              ;
ID3D11Buffer_GetDevice                           textequ             <qword ptr [rbx+24]>                              ;
ID3D11Buffer_GetPrivateData                      textequ             <qword ptr [rbx+32]>                              ;
ID3D11Buffer_SetPrivateData                      textequ             <qword ptr [rbx+40]>                              ;
ID3D11Buffer_SetPrivateDataInterface             textequ             <qword ptr [rbx+48]>                              ;
ID3D11Buffer_GetType                             textequ             <qword ptr [rbx+56]>                              ;
ID3D11Buffer_SetEvictionPriority                 textequ             <qword ptr [rbx+64]>                              ;
ID3D11Buffer_GetEvictionPriority                 textequ             <qword ptr [rbx+72]>                              ;
ID3D11Buffer_GetDesc                             textequ             <qword ptr [rbx+80]>                              ;

ID3D11DepthStencilView_QueryInterface            textequ             <qword ptr [rbx]>                                 ;
ID3D11DepthStencilView_AddRef                    textequ             <qword ptr [rbx+8]>                               ;
ID3D11DepthStencilView_Release                   textequ             <qword ptr [rbx+16]>                              ;
ID3D11DepthStencilView_GetDevice                 textequ             <qword ptr [rbx+24]>                              ;
ID3D11DepthStencilView_GetPrivateData            textequ             <qword ptr [rbx+32]>                              ;
ID3D11DepthStencilView_SetPrivateData            textequ             <qword ptr [rbx+40]>                              ;
ID3D11DepthStencilView_SetPrivateDataInterface   textequ             <qword ptr [rbx+48]>                              ;
ID3D11DepthStencilView_GetResource               textequ             <qword ptr [rbx+56]>                              ;
ID3D11DepthStencilView_GetDesc                   textequ             <qword ptr [rbx+64]>                              ;

ID3D11Device_QueryInterface                      textequ             <qword ptr [rbx]>                                 ;
ID3D11Device_AddRef                              textequ             <qword ptr [rbx+8]>                               ;
ID3D11Device_Release                             textequ             <qword ptr [rbx+16]>                              ;
ID3D11Device_CreateBuffer                        textequ             <qword ptr [rbx+24]>                              ;
ID3D11Device_CreateTexture1D                     textequ             <qword ptr [rbx+32]>                              ;
ID3D11Device_CreateTexture2D                     textequ             <qword ptr [rbx+40]>                              ;
ID3D11Device_CreateTexture3D                     textequ             <qword ptr [rbx+48]>                              ;
ID3D11Device_CreateShaderResourceView            textequ             <qword ptr [rbx+56]>                              ;
ID3D11Device_CreateUnorderedAccessView           textequ             <qword ptr [rbx+64]>                              ;
ID3D11Device_CreateRenderTargetView              textequ             <qword ptr [rbx+72]>                              ;
ID3D11Device_CreateDepthStencilView              textequ             <qword ptr [rbx+80]>                              ;
ID3D11Device_CreateInputLayout                   textequ             <qword ptr [rbx+88]>                              ;
ID3D11Device_CreateVertexShader                  textequ             <qword ptr [rbx+96]>                              ;
ID3D11Device_CreateGeometryShader                textequ             <qword ptr [rbx+104]>                             ;
ID3D11Device_CreateGeometryShaderWithStreamOutput textequ            <qword ptr [rbx+112]>                             ;
ID3D11Device_CreatePixelShader                   textequ             <qword ptr [rbx+120]>                             ;
ID3D11Device_CreateHullShader                    textequ             <qword ptr [rbx+128]>                             ;
ID3D11Device_CreateDomainShader                  textequ             <qword ptr [rbx+136]>                             ;
ID3D11Device_CreateComputeShader                 textequ             <qword ptr [rbx+144]>                             ;
ID3D11Device_CreateClassLinkage                  textequ             <qword ptr [rbx+152]>                             ;
ID3D11Device_CreateBlendState                    textequ             <qword ptr [rbx+160]>                             ;
ID3D11Device_CreateDepthStencilState             textequ             <qword ptr [rbx+168]>                             ;
ID3D11Device_CreateRasterizerState               textequ             <qword ptr [rbx+176]>                             ;
ID3D11Device_CreateSamplerState                  textequ             <qword ptr [rbx+184]>                             ;
ID3D11Device_CreateQuery                         textequ             <qword ptr [rbx+192]>                             ;
ID3D11Device_CreatePredicate                     textequ             <qword ptr [rbx+200]>                             ;
ID3D11Device_CreateCounter                       textequ             <qword ptr [rbx+208]>                             ;
ID3D11Device_CreateDeferredContext               textequ             <qword ptr [rbx+216]>                             ;
ID3D11Device_OpenSharedResource                  textequ             <qword ptr [rbx+224]>                             ;
ID3D11Device_CheckFormatSupport                  textequ             <qword ptr [rbx+232]>                             ;
ID3D11Device_CheckMultisampleQualityLevels       textequ             <qword ptr [rbx+240]>                             ;
ID3D11Device_CheckCounterInfo                    textequ             <qword ptr [rbx+248]>                             ;
ID3D11Device_CheckCounter                        textequ             <qword ptr [rbx+256]>                             ;
ID3D11Device_CheckFeatureSupport                 textequ             <qword ptr [rbx+264]>                             ;
ID3D11Device_GetPrivateData                      textequ             <qword ptr [rbx+272]>                             ;
ID3D11Device_SetPrivateData                      textequ             <qword ptr [rbx+280]>                             ;
ID3D11Device_SetPrivateDataInterface             textequ             <qword ptr [rbx+288]>                             ;
ID3D11Device_GetFeatureLevel                     textequ             <qword ptr [rbx+296]>                             ;
ID3D11Device_GetCreationFlags                    textequ             <qword ptr [rbx+304]>                             ;
ID3D11Device_GetDeviceRemovedReason              textequ             <qword ptr [rbx+312]>                             ;
ID3D11Device_GetImmediateContext                 textequ             <qword ptr [rbx+320]>                             ;
ID3D11Device_SetExceptionMode                    textequ             <qword ptr [rbx+328]>                             ;
ID3D11Device_GetExceptionMode                    textequ             <qword ptr [rbx+336]>                             ;

ID3D11DeviceContext_QueryInterface               textequ             <qword ptr [rbx]>                                 ;
ID3D11DeviceContext_AddRef                       textequ             <qword ptr [rbx+8]>                               ;
ID3D11DeviceContext_Release                      textequ             <qword ptr [rbx+16]>                              ;
ID3D11DeviceContext_GetDevice                    textequ             <qword ptr [rbx+24]>                              ;
ID3D11DeviceContext_GetPrivateData               textequ             <qword ptr [rbx+32]>                              ;
ID3D11DeviceContext_SetPrivateData               textequ             <qword ptr [rbx+40]>                              ;
ID3D11DeviceContext_SetPrivateDataInterface      textequ             <qword ptr [rbx+48]>                              ;
ID3D11DeviceContext_VSSetConstantBuffers         textequ             <qword ptr [rbx+56]>                              ;
ID3D11DeviceContext_PSSetShaderResources         textequ             <qword ptr [rbx+64]>                              ;
ID3D11DeviceContext_PSSetShader                  textequ             <qword ptr [rbx+72]>                              ;
ID3D11DeviceContext_PSSetSamplers                textequ             <qword ptr [rbx+80]>                              ;
ID3D11DeviceContext_VSSetShader                  textequ             <qword ptr [rbx+88]>                              ;
ID3D11DeviceContext_DrawIndexed                  textequ             <qword ptr [rbx+96]>                              ;
ID3D11DeviceContext_Draw                         textequ             <qword ptr [rbx+104]>                             ;
ID3D11DeviceContext_Map                          textequ             <qword ptr [rbx+112]>                             ;
ID3D11DeviceContext_Unmap                        textequ             <qword ptr [rbx+120]>                             ;
ID3D11DeviceContext_PSSetConstantBuffers         textequ             <qword ptr [rbx+128]>                             ;
ID3D11DeviceContext_IASetInputLayout             textequ             <qword ptr [rbx+136]>                             ;
ID3D11DeviceContext_IASetVertexBuffers           textequ             <qword ptr [rbx+144]>                             ;
ID3D11DeviceContext_IASetIndexBuffer             textequ             <qword ptr [rbx+152]>                             ;
ID3D11DeviceContext_DrawIndexedInstanced         textequ             <qword ptr [rbx+160]>                             ;
ID3D11DeviceContext_DrawInstanced                textequ             <qword ptr [rbx+168]>                             ;
ID3D11DeviceContext_GSSetConstantBuffers         textequ             <qword ptr [rbx+176]>                             ;
ID3D11DeviceContext_GSSetShader                  textequ             <qword ptr [rbx+184]>                             ;
ID3D11DeviceContext_IASetPrimitiveTopology       textequ             <qword ptr [rbx+192]>                             ;
ID3D11DeviceContext_VSSetShaderResources         textequ             <qword ptr [rbx+200]>                             ;
ID3D11DeviceContext_VSSetSamplers                textequ             <qword ptr [rbx+208]>                             ;
ID3D11DeviceContext_Begin                        textequ             <qword ptr [rbx+216]>                             ;
ID3D11DeviceContext_End                          textequ             <qword ptr [rbx+224]>                             ;
ID3D11DeviceContext_GetData                      textequ             <qword ptr [rbx+232]>                             ;
ID3D11DeviceContext_SetPredication               textequ             <qword ptr [rbx+240]>                             ;
ID3D11DeviceContext_GSSetShaderResources         textequ             <qword ptr [rbx+248]>                             ;
ID3D11DeviceContext_GSSetSamplers                textequ             <qword ptr [rbx+256]>                             ;
ID3D11DeviceContext_OMSetRenderTargets           textequ             <qword ptr [rbx+264]>                             ;
ID3D11DeviceContext_OMSetRenderTargetsAndUnorderedAccessViews textequ <qword ptr [rbx+272]>                            ;
ID3D11DeviceContext_OMSetBlendState              textequ             <qword ptr [rbx+280]>                             ;
ID3D11DeviceContext_OMSetDepthStencilState       textequ             <qword ptr [rbx+288]>                             ;
ID3D11DeviceContext_SOSetTargets                 textequ             <qword ptr [rbx+296]>                             ;
ID3D11DeviceContext_DrawAuto                     textequ             <qword ptr [rbx+304]>                             ;
ID3D11DeviceContext_DrawIndexedInstancedIndirect textequ             <qword ptr [rbx+312]>                             ;
ID3D11DeviceContext_DrawInstancedIndirect        textequ             <qword ptr [rbx+320]>                             ;
ID3D11DeviceContext_Dispatch                     textequ             <qword ptr [rbx+328]>                             ;
ID3D11DeviceContext_DispatchIndirect             textequ             <qword ptr [rbx+336]>                             ;
ID3D11DeviceContext_RSSetState                   textequ             <qword ptr [rbx+344]>                             ;
ID3D11DeviceContext_RSSetViewports               textequ             <qword ptr [rbx+352]>                             ;
ID3D11DeviceContext_RSSetScissorRects            textequ             <qword ptr [rbx+360]>                             ;
ID3D11DeviceContext_CopySubresourceRegion        textequ             <qword ptr [rbx+368]>                             ;
ID3D11DeviceContext_CopyResource                 textequ             <qword ptr [rbx+376]>                             ;
ID3D11DeviceContext_UpdateSubresource            textequ             <qword ptr [rbx+384]>                             ;
ID3D11DeviceContext_CopyStructureCount           textequ             <qword ptr [rbx+392]>                             ;
ID3D11DeviceContext_ClearRenderTargetView        textequ             <qword ptr [rbx+400]>                             ;
ID3D11DeviceContext_ClearUnorderedAccessViewUint textequ             <qword ptr [rbx+408]>                             ;
ID3D11DeviceContext_ClearUnorderedAccessViewFloat textequ            <qword ptr [rbx+416]>                             ;
ID3D11DeviceContext_ClearDepthStencilView        textequ             <qword ptr [rbx+424]>                             ;
ID3D11DeviceContext_GenerateMips                 textequ             <qword ptr [rbx+432]>                             ;
ID3D11DeviceContext_SetResourceMinLOD            textequ             <qword ptr [rbx+440]>                             ;
ID3D11DeviceContext_GetResourceMinLOD            textequ             <qword ptr [rbx+448]>                             ;
ID3D11DeviceContext_ResolveSubresource           textequ             <qword ptr [rbx+456]>                             ;
ID3D11DeviceContext_ExecuteCommandList           textequ             <qword ptr [rbx+464]>                             ;
ID3D11DeviceContext_HSSetShaderResources         textequ             <qword ptr [rbx+472]>                             ;
ID3D11DeviceContext_HSSetShader                  textequ             <qword ptr [rbx+480]>                             ;
ID3D11DeviceContext_HSSetSamplers                textequ             <qword ptr [rbx+488]>                             ;
ID3D11DeviceContext_HSSetConstantBuffers         textequ             <qword ptr [rbx+496]>                             ;
ID3D11DeviceContext_DSSetShaderResources         textequ             <qword ptr [rbx+504]>                             ;
ID3D11DeviceContext_DSSetShader                  textequ             <qword ptr [rbx+512]>                             ;
ID3D11DeviceContext_DSSetSamplers                textequ             <qword ptr [rbx+520]>                             ;
ID3D11DeviceContext_DSSetConstantBuffers         textequ             <qword ptr [rbx+528]>                             ;
ID3D11DeviceContext_CSSetShaderResources         textequ             <qword ptr [rbx+536]>                             ;
ID3D11DeviceContext_CSSetUnorderedAccessViews    textequ             <qword ptr [rbx+544]>                             ;
ID3D11DeviceContext_CSSetShader                  textequ             <qword ptr [rbx+552]>                             ;
ID3D11DeviceContext_CSSetSamplers                textequ             <qword ptr [rbx+560]>                             ;
ID3D11DeviceContext_CSSetConstantBuffers         textequ             <qword ptr [rbx+568]>                             ;
ID3D11DeviceContext_VSGetConstantBuffers         textequ             <qword ptr [rbx+576]>                             ;
ID3D11DeviceContext_PSGetShaderResources         textequ             <qword ptr [rbx+584]>                             ;
ID3D11DeviceContext_PSGetShader                  textequ             <qword ptr [rbx+592]>                             ;
ID3D11DeviceContext_PSGetSamplers                textequ             <qword ptr [rbx+600]>                             ;
ID3D11DeviceContext_VSGetShader                  textequ             <qword ptr [rbx+608]>                             ;
ID3D11DeviceContext_PSGetConstantBuffers         textequ             <qword ptr [rbx+616]>                             ;
ID3D11DeviceContext_IAGetInputLayout             textequ             <qword ptr [rbx+624]>                             ;
ID3D11DeviceContext_IAGetVertexBuffers           textequ             <qword ptr [rbx+632]>                             ;
ID3D11DeviceContext_IAGetIndexBuffer             textequ             <qword ptr [rbx+640]>                             ;
ID3D11DeviceContext_GSGetConstantBuffers         textequ             <qword ptr [rbx+648]>                             ;
ID3D11DeviceContext_GSGetShader                  textequ             <qword ptr [rbx+656]>                             ;
ID3D11DeviceContext_IAGetPrimitiveTopology       textequ             <qword ptr [rbx+664]>                             ;
ID3D11DeviceContext_VSGetShaderResources         textequ             <qword ptr [rbx+672]>                             ;
ID3D11DeviceContext_VSGetSamplers                textequ             <qword ptr [rbx+680]>                             ;
ID3D11DeviceContext_GetPredication               textequ             <qword ptr [rbx+688]>                             ;
ID3D11DeviceContext_GSGetShaderResources         textequ             <qword ptr [rbx+696]>                             ;
ID3D11DeviceContext_GSGetSamplers                textequ             <qword ptr [rbx+704]>                             ;
ID3D11DeviceContext_OMGetRenderTargets           textequ             <qword ptr [rbx+712]>                             ;
ID3D11DeviceContext_OMGetRenderTargetsAndUnorderedAccessViews textequ <qword ptr [rbx+720]>                            ;
ID3D11DeviceContext_OMGetBlendState              textequ             <qword ptr [rbx+728]>                             ;
ID3D11DeviceContext_OMGetDepthStencilState       textequ             <qword ptr [rbx+736]>                             ;
ID3D11DeviceContext_SOGetTargets                 textequ             <qword ptr [rbx+744]>                             ;
ID3D11DeviceContext_RSGetState                   textequ             <qword ptr [rbx+752]>                             ;
ID3D11DeviceContext_RSGetViewports               textequ             <qword ptr [rbx+760]>                             ;
ID3D11DeviceContext_RSGetScissorRects            textequ             <qword ptr [rbx+768]>                             ;
ID3D11DeviceContext_HSGetShaderResources         textequ             <qword ptr [rbx+776]>                             ;
ID3D11DeviceContext_HSGetShader                  textequ             <qword ptr [rbx+784]>                             ;
ID3D11DeviceContext_HSGetSamplers                textequ             <qword ptr [rbx+792]>                             ;
ID3D11DeviceContext_HSGetConstantBuffers         textequ             <qword ptr [rbx+800]>                             ;
ID3D11DeviceContext_DSGetShaderResources         textequ             <qword ptr [rbx+808]>                             ;
ID3D11DeviceContext_DSGetShader                  textequ             <qword ptr [rbx+816]>                             ;
ID3D11DeviceContext_DSGetSamplers                textequ             <qword ptr [rbx+824]>                             ;
ID3D11DeviceContext_DSGetConstantBuffers         textequ             <qword ptr [rbx+832]>                             ;
ID3D11DeviceContext_CSGetShaderResources         textequ             <qword ptr [rbx+840]>                             ;
ID3D11DeviceContext_CSGetUnorderedAccessViews    textequ             <qword ptr [rbx+848]>                             ;
ID3D11DeviceContext_CSGetShader                  textequ             <qword ptr [rbx+856]>                             ;
ID3D11DeviceContext_CSGetSamplers                textequ             <qword ptr [rbx+864]>                             ;
ID3D11DeviceContext_CSGetConstantBuffers         textequ             <qword ptr [rbx+872]>                             ;
ID3D11DeviceContext_ClearState                   textequ             <qword ptr [rbx+880]>                             ;
ID3D11DeviceContext_Flush                        textequ             <qword ptr [rbx+988]>                             ;
ID3D11DeviceContext_GetType                      textequ             <qword ptr [rbx+996]>                             ;
ID3D11DeviceContext_GetContextFlags              textequ             <qword ptr [rbx+904]>                             ;
ID3D11DeviceContext_FinishCommandList            textequ             <qword ptr [rbx+912]>                             ;

ID3D11InputLayout_QueryInterface                 textequ             <qword ptr [rbx]>                                 ;
ID3D11InputLayout_AddRef                         textequ             <qword ptr [rbx+8]>                               ;
ID3D11InputLayout_Release                        textequ             <qword ptr [rbx+16]>                              ;
ID3D11InputLayout_GetDevice                      textequ             <qword ptr [rbx+24]>                              ;
ID3D11InputLayout_GetPrivateData                 textequ             <qword ptr [rbx+32]>                              ;
ID3D11InputLayout_SetPrivateData                 textequ             <qword ptr [rbx+40]>                              ;
ID3D11InputLayout_SetPrivateDataInterface        textequ             <qword ptr [rbx+48]>                              ;

ID3D11PixelShader_QueryInterface                 textequ             <qword ptr [rbx]>                                 ;
ID3D11PixelShader_AddRef                         textequ             <qword ptr [rbx+8]>                               ;
ID3D11PixelShader_Release                        textequ             <qword ptr [rbx+16]>                              ;
ID3D11PixelShader_GetDevice                      textequ             <qword ptr [rbx+24]>                              ;
ID3D11PixelShader_GetPrivateData                 textequ             <qword ptr [rbx+32]>                              ;
ID3D11PixelShader_SetPrivateData                 textequ             <qword ptr [rbx+40]>                              ;
ID3D11PixelShader_SetPrivateDataInterface        textequ             <qword ptr [rbx+48]>                              ;

ID3D11RasterizerState_QueryInterface             textequ             <qword ptr [rbx]>                                 ;
ID3D11RasterizerState_AddRef                     textequ             <qword ptr [rbx+8]>                               ;
ID3D11RasterizerState_Release                    textequ             <qword ptr [rbx+16]>                              ;
ID3D11RasterizerState_GetDevice                  textequ             <qword ptr [rbx+24]>                              ;
ID3D11RasterizerState_GetPrivateData             textequ             <qword ptr [rbx+32]>                              ;
ID3D11RasterizerState_SetPrivateData             textequ             <qword ptr [rbx+40]>                              ;
ID3D11RasterizerState_SetPrivateDataInterface    textequ             <qword ptr [rbx+48]>                              ;
ID3D11RasterizerState_GetDesc                    textequ             <qword ptr [rbx+56]>                              ;

ID3D11RenderTargetView_QueryInterface            textequ             <qword ptr [rbx]>                                 ;
ID3D11RenderTargetView_AddRef                    textequ             <qword ptr [rbx+8]>                               ;
ID3D11RenderTargetView_Release                   textequ             <qword ptr [rbx+16]>                              ;
ID3D11RenderTargetView_GetDevice                 textequ             <qword ptr [rbx+24]>                              ;
ID3D11RenderTargetView_GetPrivateData            textequ             <qword ptr [rbx+32]>                              ;
ID3D11RenderTargetView_SetPrivateData            textequ             <qword ptr [rbx+40]>                              ;
ID3D11RenderTargetView_SetPrivateDataInterface   textequ             <qword ptr [rbx+48]>                              ;
ID3D11RenderTargetView_GetResource               textequ             <qword ptr [rbx+56]>                              ;
ID3D11RenderTargetView_GetDesc                   textequ             <qword ptr [rbx+64]>                              ;

ID3D11Texture2D_QueryInterface                   textequ             <qword ptr [rbx]>                                 ;
ID3D11Texture2D_AddRef                           textequ             <qword ptr [rbx+8]>                               ;
ID3D11Texture2D_Release                          textequ             <qword ptr [rbx+16]>                              ;
ID3D11Texture2D_GetDevice                        textequ             <qword ptr [rbx+24]>                              ;
ID3D11Texture2D_GetPrivateData                   textequ             <qword ptr [rbx+32]>                              ;
ID3D11Texture2D_SetPrivateData                   textequ             <qword ptr [rbx+40]>                              ;
ID3D11Texture2D_SetPrivateDataInterface          textequ             <qword ptr [rbx+48]>                              ;
ID3D11Texture2D_GetType                          textequ             <qword ptr [rbx+56]>                              ;
ID3D11Texture2D_SetEvictionPriority              textequ             <qword ptr [rbx+64]>                              ;
ID3D11Texture2D_GetEvictionPriority              textequ             <qword ptr [rbx+72]>                              ;
ID3D11Texture2D_GetDesc                          textequ             <qword ptr [rbx+80]>                              ;

ID3D11VertexShader_QueryInterface                textequ             <qword ptr [rbx]>                                 ;
ID3D11VertexShader_AddRef                        textequ             <qword ptr [rbx+8]>                               ;
ID3D11VertexShader_Release                       textequ             <qword ptr [rbx+16]>                              ;
ID3D11VertexShader_GetDevice                     textequ             <qword ptr [rbx+24]>                              ;
ID3D11VertexShader_GetPrivateData                textequ             <qword ptr [rbx+32]>                              ;
ID3D11VertexShader_SetPrivateData                textequ             <qword ptr [rbx+40]>                              ;
ID3D11VertexShader_SetPrivateDataInterface       textequ             <qword ptr [rbx+48]>                              ;

IDXGISwapChain_QueryInterface                    textequ             <qword ptr [rbx]>                                 ;
IDXGISwapChain_AddRef                            textequ             <qword ptr [rbx+8]>                               ;
IDXGISwapChain_Release                           textequ             <qword ptr [rbx+16]>                              ;
IDXGISwapChain_SetPrivateData                    textequ             <qword ptr [rbx+24]>                              ;
IDXGISwapChain_SetPrivateDataInterface           textequ             <qword ptr [rbx+32]>                              ;
IDXGISwapChain_GetPrivateData                    textequ             <qword ptr [rbx+40]>                              ;
IDXGISwapChain_GetParent                         textequ             <qword ptr [rbx+48]>                              ;
IDXGISwapChain_GetDevice                         textequ             <qword ptr [rbx+56]>                              ;
IDXGISwapChain_Present                           textequ             <qword ptr [rbx+64]>                              ;
IDXGISwapChain_GetBuffer                         textequ             <qword ptr [rbx+72]>                              ;
IDXGISwapChain_SetFullscreenState                textequ             <qword ptr [rbx+80]>                              ;
IDXGISwapChain_GetFullscreenState                textequ             <qword ptr [rbx+88]>                              ;
IDXGISwapChain_GetDesc                           textequ             <qword ptr [rbx+96]>                              ;
IDXGISwapChain_ResizeBuffers                     textequ             <qword ptr [rbx+104]>                             ;
IDXGISwapChain_ResizeTarget                      textequ             <qword ptr [rbx+112]>                             ;
IDXGISwapChain_GetContainingOutput               textequ             <qword ptr [rbx+120]>                             ;
IDXGISwapChain_GetFrameStatistics                textequ             <qword ptr [rbx+128]>                             ;
IDXGISwapChain_GetLastPresentCount               textequ             <qword ptr [rbx+136]>                             ;


