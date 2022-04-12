
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; RenderScene                                                                                                          -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  <No Parameters>                                                                                                 -
;                                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

RenderScene                                      proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 

                                                

RenderScene_00001:                               

                                                 
                                                  
                                                 
                                                 
                                               
                                              
                                                ;-----[Map the vertex buffer]------------------------------------------
                                                 ;
                                                 ; 
                                                 ;d3d11DevCon->Map(triangleVertBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);

                                                 mov                 r9, D3D11_MAP_WRITE_DISCARD                       ; Set MapType
                                                 xor                 r8, r8                                            ; Set Subresource
                                                 mov                 rdx, pointVertexBuffer                   ; Set *pVertexBuffers
                                                 xor                 r12, r12                                          ; Set MapFlags
                                                 lea                 r13, vertexMappedResource                         ; Set *pMappedResource 
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Map, rcx, rdx, r8, r9, r12, r13          


                                                 ;Copy contents of v into vertexMappedResource.pData 16 bytes at a time using simd
                                                 mov r8, number_of_points
                                                 xor rdi, rdi ;Set rdi to 0

Copy_Vertex_Buffer_Points_For:                  cmp rdi, r8
                                                 jz Copy_Vertex_Buffer_Points_For_End

                                                 mov rax, sizeof(point_vertex)
                                                 mul rdi

                                                 lea rbx, vPoints
                                                 vmovdqa xmm0, xmmword ptr [rbx + rax] 
                                                 vmovdqa xmm1, xmmword ptr [rbx + rax + sizeof(xmmword)] 
                                                 add rax, vertexMappedResource.pData ; set rax to point to address of current index of vertexdata
                                                                                              
                                                 vmovdqa xmmword ptr [rax], xmm0
                                                 vmovdqa xmmword ptr [rax + sizeof(xmmword)], xmm1
                                                 inc rdi
                                                 jmp Copy_Vertex_Buffer_Points_For
                                                 
Copy_Vertex_Buffer_Points_For_End:

                                                  ;-----[Unmap the vertex buffer]------------------------------------------
                                                 ;
                                                 ; 
                                                 ;d3d11DevCon->Unmap(triangleVertBuffer, 0);

                                                 xor                 r8, r8                                            ; Set Subresource
                                                 mov                 rdx, pointVertexBuffer                  ; Set *pVertexBuffers
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Unmap, rcx, rdx, r8         
                                               
                                             

                                                 ;-----[Copy car position data to instance buffer]----------------------

                                                 ;-----[Map the vertex buffer]------------------------------------------
                                                 ;
                                                 ; 
                                                 ;d3d11DevCon->Map(triangleVertBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);

                                                 mov                 r9, D3D11_MAP_WRITE_DISCARD                       ; Set MapType
                                                 xor                 r8, r8                                            ; Set Subresource
                                                 mov                 rdx, beeInstanceBuffer                   ; Set *pVertexBuffers
                                                 xor                 r12, r12                                          ; Set MapFlags
                                                 lea                 r13, vertexMappedResource                         ; Set *pMappedResource 
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Map, rcx, rdx, r8, r9, r12, r13          


                                                ;Copy the data for only active cars into vertexMappedResource.pData 
                                                mov r8, max_number_of_bees
                                                xor rdi, rdi ;Set rdi to 0
                                                xor r12, r12 ;keep active car index here 

Copy_Index_Buffer_Bees_For:                     cmp rdi, r8
                                                jz Copy_Index_Buffer_Bees_For_End

                                                mov eax, sizeof(byte)
                                                mul edi

                                                mov rax, sizeof(meshInstanceData)
                                                mul rdi
                                                lea rbx, beeTransformDataArray
                                                add rbx, rax
                                                vmovdqa ymm0, ymmword ptr [rbx] 
                                                mov rax, sizeof(meshInstanceData)
                                                mul r12 ;active car index
                                                add rax, vertexMappedResource.pData ; set rax to point to address of current index of vertexdata
                                                                                              
                                                vmovdqa ymmword ptr [rax], ymm0
                                                inc r12
Copy_Index_Buffer_Bees_For_Continue:            inc rdi
                                                jmp Copy_Index_Buffer_Bees_For
                                                 
Copy_Index_Buffer_Bees_For_End:                 
                                                mov numberOfBees, r12d

                                                  ;-----[Unmap the vertex buffer]------------------------------------------
                                                 ;
                                                 ; 
                                                 ;d3d11DevCon->Unmap(triangleVertBuffer, 0);

                                                 xor                 r8, r8                                            ; Set Subresource
                                                 mov                 rdx, beeInstanceBuffer                  ; Set *pVertexBuffers
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Unmap, rcx, rdx, r8         

                                                
                                               
            
                                                 ;-----[Map the vertex buffer]------------------------------------------
                                                 ;
                                                 ; 
                                                 ;d3d11DevCon->Map(triangleVertBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);

                                                 mov                 r9, D3D11_MAP_WRITE_DISCARD                       ; Set MapType
                                                 xor                 r8, r8                                            ; Set Subresource
                                                 mov                 rdx, quadVertexBuffer                   ; Set *pVertexBuffers
                                                 xor                 r12, r12                                          ; Set MapFlags
                                                 lea                 r13, vertexMappedResource                         ; Set *pMappedResource 
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Map, rcx, rdx, r8, r9, r12, r13          


                                                 ;Copy contents of v into vertexMappedResource.pData 16 bytes at a time using simd
                                                 mov r8, sizeof(quad_vertex) * number_of_quad_vertices / 16
                                                 xor rdi, rdi ;Set rdi to 0

Copy_Vertex_Buffer_Quads_For:                    cmp rdi, r8
                                                 jz Copy_Vertex_Buffer_Quads_For_End

                                                 mov rax, 16
                                                 mul rdi
                                                 lea rbx, vQuads
                                                 add rbx, rax
                                                 vmovdqa xmm0, xmmword ptr [rbx] 
                                                 add rax, vertexMappedResource.pData ; set rax to point to address of current index of vertexdata
                                                                                              
                                                 vmovdqa xmmword ptr [rax], xmm0
                                                 inc rdi
                                                 jmp Copy_Vertex_Buffer_Quads_For
                                                 
Copy_Vertex_Buffer_Quads_For_End:



                                                 ;-----[Unmap the vertex buffer]------------------------------------------
                                                 ;
                                                 ; 
                                                 ;d3d11DevCon->Unmap(triangleVertBuffer, 0);

                                                 xor                 r8, r8                                            ; Set Subresource
                                                 mov                 rdx, quadVertexBuffer                  ; Set *pVertexBuffers
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Unmap, rcx, rdx, r8         
Skip_Quad_Vertex_Update:                         



                                                
                                                
                                                 ;-----[Map the vertex buffer]------------------------------------------
                                                 ;
                                                 ; 
                                                 ;d3d11DevCon->Map(triangleVertBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &mappedResource);

                                                 mov                 r9, D3D11_MAP_WRITE_DISCARD                       ; Set MapType
                                                 xor                 r8, r8                                            ; Set Subresource
                                                 mov                 rdx, fontTextureVertexBuffer                   ; Set *pVertexBuffers
                                                 xor                 r12, r12                                          ; Set MapFlags
                                                 lea                 r13, vertexMappedResource                         ; Set *pMappedResource 
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Map, rcx, rdx, r8, r9, r12, r13          
                                                
                                                ;Copy textBuffer stuff
                                                 mov r8, sizeof(font_vertex) * text_buffer_length * 4 / 16
                                                 xor rdi, rdi ;Set rdi to 0

Copy_Vertex_Buffer_Font_For:                     cmp rdi, r8
                                                 jz Copy_Vertex_Buffer_Font_For_End

                                                 mov rax, 16
                                                 mul rdi
                                                 lea rbx, textbufferVertices
                                                 add rbx, rax
                                                 vmovdqa xmm0, xmmword ptr [rbx] 
                                                 add rax, vertexMappedResource.pData ; set rax to point to address of current index of vertexdata
                                                                                              
                                                 vmovdqa xmmword ptr [rax], xmm0
                                                 inc rdi
                                                 jmp Copy_Vertex_Buffer_Font_For
                                                 
Copy_Vertex_Buffer_Font_For_End:




                                                 ;-----[Unmap the vertex buffer]------------------------------------------
                                                 ;
                                                 ; 
                                                 ;d3d11DevCon->Unmap(triangleVertBuffer, 0);

                                                 xor                 r8, r8                                            ; Set Subresource
                                                 mov                 rdx, fontTextureVertexBuffer                  ; Set *pVertexBuffers
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Unmap, rcx, rdx, r8         

                                                  ;-----[set the blend state]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->CreateBlendState(&blendDesc, &blendState);

                                                 mov                 rdx, blendState                                    ; Set blendDesc
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetBlendState, rcx, rdx, 0, 0FFFFFFFFh       ; Execute call
                                                 
                                                ; LocalCall         RenderShadowMap 
                                                 ;-----[Set primitive topology]-----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetPrimitiveTopology( D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST );

                                                 mov                 rdx, D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST        ; Set Topology
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetPrimitiveTopology, rcx, rdx

                                                 ;-----[Set the viewport]-----------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->RSSetViewports(1, &viewport);

                                                 lea                 r8, viewport                                      ; Set *pViewPorts
                                                 mov                 rdx, 1                                            ; Set NumViewports
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_RSSetViewports, rcx, rdx, r8  ; Set the viewport

                                                
                                                 ;-----[Set the render target]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->OMSetRenderTargets( 1, &renderTargetView, NULL );

                                                 mov                 r9, depthStencilView                               ; Set *pDepthStencilView
                                                 lea                 r8, renderTargetView                              ; Set *ppRenderTargetViews
                                                 mov                 rdx, 1                                            ; Set NumViews
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetRenderTargets            ; Execute call
                                                
                                                 
                                                 ;-----[Clear the background]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->ClearRenderTargetView(renderTargetView, bgColor);

                                                 lea                 r8, bgColor                                       ; Set ColorRGBA
                                                 mov                 rdx, renderTargetView                             ; Set *pRenderTargetView
                                                 mov                 rcx, d3d11DevCon                                  ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_ClearRenderTargetView, rcx, rdx, r8

                                                 ;-----[Clear the depth stencil view]-----------------------------------
                                                 ;
                                                 ; d3d11DevCon->ClearDepthStencilView(depthStencilView,
                                                 ;                                      D3D11_CLEAR_DEPTH | D3D11_CLEAR_STENCIL,
                                                 ;                                      1.0f, 0);

                                                 xorps               xmm3, xmm3                                        ; Depth goes in xmm3
                                                 movss               xmm3, r1                                           ; Set Depth
                                                 mov                 r8, D3D11_CLEAR_DEPTH or D3D11_CLEAR_STENCIL      ; Set ClearFlags
                                                 mov                 rdx, depthStencilView                             ; Set *pDepthStencilView
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_ClearDepthStencilView, rcx, rdx, r8, r9, 0

                                                
                                                ;-----[Render sky quad]------------------------------------------------

                                                 ;-----[Disable depth testing]----------------------------------
                                                 ;
                                                 ; d3d11Device->OMSetDepthStencilState(depthStencilState, 1);

                                                 mov                 r8, 1                                              ; Set
                                                 mov                 rdx, depthStencilOffState                             ; set
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetDepthStencilState, rcx, rdx, r8

                                                 
                                                   ;-----[Set the vertex shader]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetShader(VS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, vsQuads                                           ; Set *pVertexShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetShader                   ; Execute call

                                                 ;-----[Set the pixel shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetShader(PS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, psQuads                                           ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShader                   ; Execute call

                                                 

                                                  ;-----[Set the vertex buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );
                                                 lea                 r13, offset_                                      ; Set *pOffsets
                                                 lea                 r12, strideQuads                                  ; Set *pStrides
                                                 lea                 r9, quadVertexBuffer                    ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13

                                                ;-----[Set the view matrix]--------------------------------------------
                                                 ;
                                                 ; camView = XMMatrixLookAtLH( camPosition, camLookTo, camUp );

                                                 lea                 r9, camUp                                         ; Set vUp
                                                 lea                 r8, camLookToSkyQuad                                     ; set vDirection
                                                 lea                 rdx, camPosition                                  ; Set vPosition
                                                 lea                 rcx, mView                                        ; Set undocumented mOut
                                                 WinCall             XMMatrixLookToLHProxy, rcx, rdx, r8, r9           ; Set the view matrix

                                                 ;-----[Transpose result into constant buffer]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);

                                                 lea                 rdx, mView                                         ; Set M1
                                                 lea                 rcx, mView                                     ; Set mOut
                                                 WinCall             XMMatrixTransposeProxy, rcx, rdx                  ; Transpose image to target
                                                  ;-----[Set matrix mWVP = mWVP * mProj]---------------------------------

                                                 
                                                  ;-----[Transpose result into constant buffer]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);

                                                 lea                 rdx, mProj                                         ; Set M1
                                                 lea                 rcx, mProjSkyBox                                     ; Set mOut
                                                 WinCall             XMMatrixTransposeProxy, rcx, rdx                  ; Transpose image to target
                                                
                                                movaps xmm0, xmmword ptr[mView]
                                                movaps xmmword ptr [skyBoxBuffer], xmm0

                                                movaps xmm0, xmmword ptr[mView + sizeof(xmmword)]
                                                movaps xmmword ptr [skyBoxBuffer + sizeof(xmmword)], xmm0

                                                movaps xmm0, xmmword ptr[mView + sizeof(xmmword)*2]
                                                movaps xmmword ptr [skyBoxBuffer + sizeof(xmmword)*2], xmm0

                                                movaps xmm0, xmmword ptr[mView + sizeof(xmmword)*3]
                                                movaps xmmword ptr [skyBoxBuffer + sizeof(xmmword)*3], xmm0

                                                movaps xmm0, xmmword ptr[mProjSkyBox]
                                                movaps xmmword ptr [skyBoxBuffer +sizeof(xmmword) *4], xmm0

                                                movaps xmm0, xmmword ptr[mProjSkyBox + sizeof(xmmword)]
                                                movaps xmmword ptr [skyBoxBuffer + sizeof(xmmword) * 5], xmm0

                                                movaps xmm0, xmmword ptr[mProjSkyBox + sizeof(xmmword)*2]
                                                movaps xmmword ptr [skyBoxBuffer + sizeof(xmmword)*6], xmm0

                                                movaps xmm0, xmmword ptr[mProjSkyBox + sizeof(xmmword)*3]
                                                movaps xmmword ptr [skyBoxBuffer + sizeof(xmmword)*7], xmm0

                                                 ;-----[Update the sub resource]----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->UpdateSubresource( cbPerObjectBuffer, 0, NULL, &cbPerObj, 0, 0 );

                                                 lea                 r12, skyBoxBuffer                                     ; Set *pSrcData
                                                 xor                 r9, r9                                            ; Set *pDstBox
                                                 xor                 r8, r8                                            ; Set DstSubresource
                                                 mov                 rdx, cbSkyBoxBuffer                            ; Set *pDstResource
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_UpdateSubresource, rcx, rdx, r8, r9, r12, 0, 0

                                                  ;-----[Set the VS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbPerObjectBuffer );
                                                 lea                 r9, cbSkyBoxBuffer                             ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 4                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetConstantBuffers, rcx, rdx, r8, r9

                                                ;-----[Set the PS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbPerObjectBuffer );
                                                 lea                 r9, cbSkyBoxBuffer                             ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 4                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetConstantBuffers, rcx, rdx, r8, r9
                                                   ;-----[Set the view matrix]--------------------------------------------
                                                 ;
                                                 ; camView = XMMatrixLookAtLH( camPosition, camLookTo, camUp );

                                                 lea                 r9, camUp                                         ; Set vUp
                                                 lea                 r8, camLookTo                                     ; set vDirection
                                                 lea                 rdx, camPosition                                  ; Set vPosition
                                                 lea                 rcx, mView                                        ; Set undocumented mOut
                                                 WinCall             XMMatrixLookToLHProxy, rcx, rdx, r8, r9           ; Set the view matrix

                                                 ;-----[Calculate inverse of view matrix]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);
                                                
                                                 lea                 rdx, mView                                        ; Set M1
                                                 lea                 rcx, mViewInverse                                 ; Set mOut
                                                 WinCall             XMMatrixInverseProxy, rcx, rdx                    ; Transpose image to target

                                                 ;-----[Set matrix mWVP = mWorld * mView]-------------------------------
                                                 ;
                                                 ; mWVP = mWorld * mView * mProj;

                                                 lea                 r8, mView                                         ; Set M2
                                                 lea                 rdx, mWorld                                       ; Set M1
                                                 lea                 rcx, mWVP                                         ; Set m
                                                 WinCall             XMMatrixMultiplyProxy, rcx, rdx, r8               ; Set mWVP = mWorld * mView

                                                 ;-----[Set matrix mWVP = mWVP * mProj]---------------------------------

                                                 lea                 r8, mProj                                         ; Set M2
                                                 lea                 rdx, mWVP                                         ; Set M1
                                                 lea                 rcx, mWVP                                         ; Set m
                                                 WinCall             XMMatrixMultiplyProxy, rcx, rdx, r8               ; Set mWVP = mWorld * mView

                                                 ;-----[Calculate inverse of WVP matrix]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);
                                                
                                                 lea                 rdx, mWVP                                        ; Set M1
                                                 lea                 rcx, mWVPInverse                                 ; Set mOut
                                                 WinCall             XMMatrixInverseProxy, rcx, rdx                    ; Transpose image to target
                                                
                                                lea                 r9, camUp                                         ; Set vUp
                                                lea                 r8, origin                                 ; set FocusPosition
                                                lea                 rdx, lightDirection                               		   ; Set cameraPosition
                                                lea                 rcx, mViewLight                                        ; Set undocumented mOut
                                                WinCall             XMMatrixLookAtLHProxy, rcx, rdx, r8, r9           ; Set the view matrix

                                                lea                 rdx, mViewLight                                        ; Set M1
                                                lea                 rcx, mViewLightInverse                                 ; Set mOut
                                                WinCall             XMMatrixInverseProxy, rcx, rdx                    ; Transpose image to target

                                                ;lea                 r8, mViewLightInverse                                         ; Set M2
                                                ;lea                 rdx, mWVPInverse                                         ; Set M1
                                                ;lea                 rcx, mShadowFrustum                                         ; Set m
                                                ;WinCall             XMMatrixMultiplyProxy, rcx, rdx, r8               ; Set mWVP = mWorld * mView

                                                lea                   rcx, mWVPInverse
                                                movaps                xmm2, ndc1
                                                TransformVectorFromRegister
                                                movaps                xmm0, xmm2
                                                DivideVectorByW
                                                movaps                ndcTransformed1, xmm0

                                                lea                   rcx, mWVPInverse
                                                movaps                xmm2, ndc2
                                                TransformVectorFromRegister
                                                movaps                xmm0, xmm2
                                                DivideVectorByW
                                                movaps                ndcTransformed2, xmm0

                                                lea                   rcx, mWVPInverse
                                                movaps                xmm2, ndc3
                                                TransformVectorFromRegister
                                                movaps                xmm0, xmm2
                                                DivideVectorByW
                                                movaps                ndcTransformed3, xmm0

                                                lea                   rcx, mWVPInverse
                                                movaps                xmm2, ndc4
                                                TransformVectorFromRegister
                                                movaps                xmm0, xmm2
                                                DivideVectorByW
                                                movaps                ndcTransformed4, xmm0

                                                lea                   rcx, mWVPInverse
                                                movaps                xmm2, ndc5
                                                TransformVectorFromRegister
                                                movaps                xmm0, xmm2
                                                DivideVectorByW
                                                movaps                ndcTransformed5, xmm0

                                                lea                   rcx, mWVPInverse
                                                movaps                xmm2, ndc6
                                                TransformVectorFromRegister
                                                movaps                xmm0, xmm2
                                                DivideVectorByW
                                                movaps                ndcTransformed6, xmm0

                                                lea                   rcx, mWVPInverse
                                                movaps                xmm2, ndc7
                                                TransformVectorFromRegister
                                                movaps                xmm0, xmm2
                                                DivideVectorByW
                                                movaps                ndcTransformed7, xmm0

                                                lea                   rcx, mWVPInverse
                                                movaps                xmm2, ndc8
                                                TransformVectorFromRegister
                                                movaps                xmm0, xmm2
                                                DivideVectorByW
                                                movaps                ndcTransformed8, xmm0


                                                
                                                ;Clamp everything so its inside the terrain bounding box
                                                lea rcx, ndcTransformed1
                                                lea rdx, ndcTransformed5
                                                LocalCall ClipRayByBoundingBox

                                                lea rcx, ndcTransformed2
                                                lea rdx, ndcTransformed6
                                                LocalCall ClipRayByBoundingBox

                                                lea rcx, ndcTransformed3
                                                lea rdx, ndcTransformed7
                                                LocalCall ClipRayByBoundingBox

                                                lea rcx, ndcTransformed4
                                                lea rdx, ndcTransformed8
                                                LocalCall ClipRayByBoundingBox

                                                movaps xmm0, ndcTransformed1
                                                movaps xmm1, ndcTransformed2
                                                movaps xmm2, ndcTransformed3
                                                movaps xmm3, ndcTransformed4
                                                movaps xmm4, ndcTransformed5
                                                movaps xmm5, ndcTransformed6
                                                movaps xmm6, ndcTransformed7
                                                movaps xmm7, ndcTransformed8


                                                lea                   rcx, mViewLight
                                                movaps                xmm2, xmmword ptr [ndcTransformed1]
                                                TransformVectorFromRegister
                                                movaps xmmword ptr [ndcTransformedLight1], xmm2

                                                lea                   rcx, mViewLight
                                                movaps                xmm2, xmmword ptr [ndcTransformed2]
                                                TransformVectorFromRegister
                                                movaps xmmword ptr [ndcTransformedLight2], xmm2

                                                lea                   rcx, mViewLight
                                                movaps                xmm2, xmmword ptr [ndcTransformed3]
                                                TransformVectorFromRegister
                                                movaps xmmword ptr [ndcTransformedLight3], xmm2

                                                lea                   rcx, mViewLight
                                                movaps                xmm2, xmmword ptr [ndcTransformed4]
                                                TransformVectorFromRegister
                                                movaps xmmword ptr [ndcTransformedLight4], xmm2

                                                lea                   rcx, mViewLight
                                                movaps                xmm2, xmmword ptr [ndcTransformed5]
                                                TransformVectorFromRegister
                                                movaps xmmword ptr [ndcTransformedLight5], xmm2

                                                lea                   rcx, mViewLight
                                                movaps                xmm2, xmmword ptr [ndcTransformed6]
                                                TransformVectorFromRegister
                                                movaps xmmword ptr [ndcTransformedLight6], xmm2

                                                lea                   rcx, mViewLight
                                                movaps                xmm2, xmmword ptr [ndcTransformed7]
                                                TransformVectorFromRegister
                                                movaps xmmword ptr [ndcTransformedLight7], xmm2

                                                lea                   rcx, mViewLight
                                                movaps                xmm2, xmmword ptr [ndcTransformed8]
                                                TransformVectorFromRegister
                                                movaps xmmword ptr [ndcTransformedLight8], xmm2

                                                
                                                ;cmpps
                                                ;0 = 
                                                ;1 <
                                                ;2 <=
                                                ;3 Nan
                                                ;4 !=
                                                ;5 >=
                                                ;6 >
                                                ;7 !Nan

                                                movaps xmm0, xmmword ptr [ndcTransformedLight1]
                                                movaps xmmword ptr [ndcTransformedMax], xmm0
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight2], 2 ;if ndcTransformed2 is greater or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight2]
                                                vmaskmovps xmmword ptr [ndcTransformedMax], xmm0, xmm1 ; move greater values to ndcTransformedMax
                                                movaps xmm0, xmmword ptr [ndcTransformedMax]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight3], 2 ;if ndcTransformed3 is greater or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight3]
                                                vmaskmovps xmmword ptr [ndcTransformedMax], xmm0, xmm1 ; move greater values to ndcTransformedMax
                                                movaps xmm0, xmmword ptr [ndcTransformedMax]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight4], 2 ;if ndcTransformed4 is greater or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight4]
                                                vmaskmovps xmmword ptr [ndcTransformedMax], xmm0, xmm1 ; move greater values to ndcTransformedMax
                                                movaps xmm0, xmmword ptr [ndcTransformedMax]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight5], 2 ;if ndcTransformed4 is greater or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight5]
                                                vmaskmovps xmmword ptr [ndcTransformedMax], xmm0, xmm1 ; move greater values to ndcTransformedMax
                                                movaps xmm0, xmmword ptr [ndcTransformedMax]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight6], 2 ;if ndcTransformed4 is greater or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight6]
                                                vmaskmovps xmmword ptr [ndcTransformedMax], xmm0, xmm1 ; move greater values to ndcTransformedMax
                                                movaps xmm0, xmmword ptr [ndcTransformedMax]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight7], 2 ;if ndcTransformed4 is greater or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight7]
                                                vmaskmovps xmmword ptr [ndcTransformedMax], xmm0, xmm1 ; move greater values to ndcTransformedMax
                                                movaps xmm0, xmmword ptr [ndcTransformedMax]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight8], 2 ;if ndcTransformed4 is greater or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight8]
                                                vmaskmovps xmmword ptr [ndcTransformedMax], xmm0, xmm1 ; move greater values to ndcTransformedMax

                                                movaps xmm0, xmmword ptr [ndcTransformedLight1]
                                                movaps xmmword ptr [ndcTransformedMin], xmm0
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight2], 5 ;if ndcTransformed2 is less or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight2]
                                                vmaskmovps xmmword ptr [ndcTransformedMin], xmm0, xmm1 ; move smaller values to ndcTransformedMin
                                                movaps xmm0, xmmword ptr [ndcTransformedMin]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight3], 5 ;if ndcTransformed3 is less or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight3]
                                                vmaskmovps xmmword ptr [ndcTransformedMin], xmm0, xmm1 ; move smaller values to ndcTransformedMin
                                                movaps xmm0, xmmword ptr [ndcTransformedMin]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight4], 5 ;if ndcTransformed4 is less or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight4]
                                                vmaskmovps xmmword ptr [ndcTransformedMin], xmm0, xmm1 ; move smaller values to ndcTransformedMin
                                                movaps xmm0, xmmword ptr [ndcTransformedMin]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight5], 5 ;if ndcTransformed4 is less or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight5]
                                                vmaskmovps xmmword ptr [ndcTransformedMin], xmm0, xmm1 ; move smaller values to ndcTransformedMin
                                                movaps xmm0, xmmword ptr [ndcTransformedMin]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight6], 5 ;if ndcTransformed4 is less or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight6]
                                                vmaskmovps xmmword ptr [ndcTransformedMin], xmm0, xmm1 ; move smaller values to ndcTransformedMin
                                                movaps xmm0, xmmword ptr [ndcTransformedMin]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight7], 5 ;if ndcTransformed4 is less or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight7]
                                                vmaskmovps xmmword ptr [ndcTransformedMin], xmm0, xmm1 ; move smaller values to ndcTransformedMin
                                                movaps xmm0, xmmword ptr [ndcTransformedMin]
                                                cmpps xmm0, xmmword ptr [ndcTransformedLight8], 5 ;if ndcTransformed4 is less or equal
                                                movaps xmm1, xmmword ptr [ndcTransformedLight8]
                                                vmaskmovps xmmword ptr [ndcTransformedMin], xmm0, xmm1 ; move smaller values to ndcTransformedMin

                                                movaps xmm0, xmmword ptr [ndcTransformedMax]
                                                movaps xmm1, xmmword ptr [ndcTransformedMin]


                                                  ;-----[Set the projection matrix]--------------------------------------
                                                 mov                 r14d, real4 ptr [ndcTransformedMax + sizeof(real4) * 2]         ; Set FarZ
                                                 mov                 r13d, real4 ptr [ndcTransformedMin + sizeof(real4) * 2]         ; Set NearZ
                                                 mov                 r12d, real4 ptr [ndcTransformedMax + sizeof(real4) * 1]         ; Set ViewTop
                                                 movss               xmm3, real4 ptr [ndcTransformedMin + sizeof(real4) * 1]         ; Set ViewBottom
                                                 movss               xmm2, real4 ptr [ndcTransformedMax]                             ; Set ViewRight
                                                 movss               xmm1, real4 ptr [ndcTransformedMin]                             ; Set ViewLeft
                                                 lea                 rcx, mProjOrtho                                   ; Set undocumented mOut
                                                 WinCall             XMMatrixOrthographicOffCenterLHProxy, rcx, rdx, r8, r9, r12, r13, r14
                                                 

                                                 ;-----[Transpose result into constant buffer]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);

                                                 lea                 rdx, mWVP                                         ; Set M1
                                                 lea                 rcx, cbPerObj                                     ; Set mOut
                                                 WinCall             XMMatrixTransposeProxy, rcx, rdx                  ; Transpose image to target

                                                    ;-----[Transpose result into constant buffer]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);

                                                 lea rcx, cbPerObj
                                                 add rcx, sizeof(real4) * 16

                                                 lea                 rdx, mView                                         ; Set M1
                                                 WinCall             XMMatrixTransposeProxy, rcx, rdx                  ; Transpose image to target	

                                                  ;-----[Transpose result into constant buffer]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);

                                                 lea rcx, cbPerObj
                                                 add rcx, sizeof(real4) * 32

                                                 lea                 rdx, mProjSun                                         ; Set M1
                                                 WinCall             XMMatrixTransposeProxy, rcx, rdx                  ; Transpose image to target	

                                                 ;Set camera position in constant buffer cameraBuffer
                                                  ;int 3
                                                 movaps xmm1, xmmword ptr [camPosition]                                                
                                                 movaps xmmword ptr [cameraBuffer], xmm1
                                                ;int 3


                                                   ;-----[Update the sub resource]----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->UpdateSubresource( cbPerObjectBuffer, 0, NULL, &cbPerObj, 0, 0 );

                                                 lea                 r12, cbPerObj                                     ; Set *pSrcData
                                                 xor                 r9, r9                                            ; Set *pDstBox
                                                 xor                 r8, r8                                            ; Set DstSubresource
                                                 mov                 rdx, cbPerObjectBuffer                            ; Set *pDstResource
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_UpdateSubresource, rcx, rdx, r8, r9, r12, 0, 0

                                                  ;-----[Set the PS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetConstantBuffers( 0, 1, &cbPerObjectBuffer );
                                                 lea                 r9, cbPerObjectBuffer                             ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetConstantBuffers, rcx, rdx, r8, r9

                                                   ;-----[Update the sub resource]----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->UpdateSubresource( directionalLightBuffer, 0, NULL, &cbPerObj, 0, 0 );

                                                 lea                 r12, directionalLightBuffer                                 ; Set *pSrcData
                                                 xor                 r9, r9                                            ; Set *pDstBox
                                                 xor                 r8, r8                                            ; Set DstSubresource
                                                 mov                 rdx, cbDirectionalLightBuffer                     ; Set *pDstResource
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_UpdateSubresource, rcx, rdx, r8, r9, r12, 0, 0

                                                  ;-----[Set the PS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetConstantBuffers( 0, 1, &cbDirectionalLightBuffer );
                                                 lea                 r9, cbDirectionalLightBuffer                      ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 3                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetConstantBuffers, rcx, rdx, r8, r9

                                                 ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayoutQuads                            ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout


                                                   
                                                 xor                 r8, r8                                            ; Set StartVertexLocation
                                                 mov                 rdx, number_of_quad_vertices                      ; Set VertexCount
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Draw, rcx, rdx, r8            ; Draw the scene


                                                ;-----[enable depth testing]----------------------------------
                                                 ;
                                                 ; d3d11Device->OMSetDepthStencilState(depthStencilState, 1);

                                                 mov                 r8, 1                                              ; Set
                                                 mov                 rdx, depthStencilState                             ; set
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetDepthStencilState, rcx, rdx, r8


                                               
                                                 ;-----[Set rasterizer state]---------------------------------------
                                                 ;
                                                 ; d3d11DevCon->RSSetState(rasterizerState);

                                                 mov                 rdx, rasterizerState                              ; Set *pRasterizerState
                                                 mov                 rcx, D3D11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_RSSetState, rcx, rdx          ; Set the rasterizer state

                                                 ;-----[Set the vertex shader]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetShader(VS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, vsTerrain                                           ; Set *pVertexShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetShader                   ; Execute call

                                                 ;-----[Set the pixel shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetShader(PS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, PS                                           ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShader                   ; Execute call

                                                 ;-----[Set the geometry shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->GSSetShader(PS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, gsTerrain                                    ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_GSSetShader                   ; Execute call

                                                
                                                  ;-----[Update the sub resource]----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->UpdateSubresource( cameraBuffer, 0, NULL, &cbPerObj, 0, 0 );

                                                 lea                 r12, cameraBuffer                                 ; Set *pSrcData
                                                 xor                 r9, r9                                            ; Set *pDstBox
                                                 xor                 r8, r8                                            ; Set DstSubresource
                                                 mov                 rdx, cbCameraBuffer                               ; Set *pDstResource
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_UpdateSubresource, rcx, rdx, r8, r9, r12, 0, 0
                                                 
                                                 
                                                  ;-----[Update the sub resource]----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->UpdateSubresource( cameraBuffer, 0, NULL, &cbPerObj, 0, 0 );

                                                 lea                 r12, previewBuffer                                 ; Set *pSrcData
                                                 xor                 r9, r9                                            ; Set *pDstBox
                                                 xor                 r8, r8                                            ; Set DstSubresource
                                                 mov                 rdx, cbMouseBuffer                               ; Set *pDstResource
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_UpdateSubresource, rcx, rdx, r8, r9, r12, 0, 0
                                                 

                                                  ;-----[Update the sub resource]----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->UpdateSubresource( directionalLightBuffer, 0, NULL, &cbPerObj, 0, 0 );

                                                 lea                 r12, waterBuffer                                 ; Set *pSrcData
                                                 xor                 r9, r9                                            ; Set *pDstBox
                                                 xor                 r8, r8                                            ; Set DstSubresource
                                                 mov                 rdx, cbWaterBuffer                     ; Set *pDstResource
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_UpdateSubresource, rcx, rdx, r8, r9, r12, 0, 0

                                                    ;int 3
                                                 ;-----[Set the VS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbPerObjectBuffer );
                                                 lea                 r9, cbPerObjectBuffer                             ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetConstantBuffers, rcx, rdx, r8, r9

                                                 ;-----[Set the VS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbCameraBuffer );
                                                 lea                 r9, cbCameraBuffer                                ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetConstantBuffers, rcx, rdx, r8, r9

                                                  ;-----[Set the VS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbCameraBuffer );
                                                 lea                 r9, cbWaterBuffer                                ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 2                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetConstantBuffers, rcx, rdx, r8, r9

												                        ;-----[Set the PS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetConstantBuffers( 0, 1, &cbDirectionalLightBuffer );
                                                 lea                 r9, cbDirectionalLightBuffer                      ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 3                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetConstantBuffers, rcx, rdx, r8, r9
                                                 
                                                   ;-----[Set the VS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbCameraBuffer );
                                                 lea                 r9, cbCameraBuffer                                ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetConstantBuffers, rcx, rdx, r8, r9
                                                 
                                                  
                                                 ;-----[Set the VS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbCameraBuffer );
                                                 lea                 r9, cbMouseBuffer                                ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 5                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetConstantBuffers, rcx, rdx, r8, r9

                                                  ;-----[Set the PS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbCameraBuffer );
                                                 lea                 r9, cbMouseBuffer                                ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 5                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetConstantBuffers, rcx, rdx, r8, r9


                                                  ;-----[Set the PS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbCameraBuffer );
                                                 lea                 r9, cbCameraBuffer                                ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetConstantBuffers, rcx, rdx, r8, r9

                                                  ;-----[Set the PS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetConstantBuffers( 0, 1, &cbDirectionalLightBuffer );
                                                 lea                 r9, cbDirectionalLightBuffer                    ; Set *ppSamplers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 3                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetConstantBuffers, rcx, rdx, r8, r9


												                        ;-----[Set the PS shadowmap texture]-------------------------------------
                                                 ;
                                                 ; 
                                                 lea                 r9, shadowMapResouceView                        ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 0                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShaderResources, rcx, rdx, r8, r9


												                         ;-----[Set the PS sampler]-------------------------------------
                                                 ;
                                                 ; 
                                                 lea                 r9, shadowMapComparisonSampler                      ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumSamplers
                                                 mov                 rdx, 0                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetSamplers, rcx, rdx, r8, r9
                                                 
                                               
                                               
                                                 ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayout                                   ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout


                                                  ;-----[Set the vertex shader]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetShader(VS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, vsCars                                           ; Set *pVertexShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetShader                   ; Execute call

                                                 ;-----[Set the pixel shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetShader(PS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, PS                                           ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShader                   ; Execute call

                                                  ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayoutCars                                   ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout


                                                  ;-----[Set the vertex buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );
                                                 lea                 r13, offset_                                      ; Set *pOffsets
                                                 lea                 r12, stride                                  ; Set *pStrides
                                                 lea                 r9, carsVertexBuffer                    ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13

                                                   ;-----[Set the instance buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );
                                                 lea                 r13, offset_1                                      ; Set *pOffsets
                                                 lea                 r12, stride1                                       ; Set *pStrides
                                                 lea                 r9, beeInstanceBuffer                         ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13
                                                
                                                 ;-----[Set the index buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetIndexBuffer( triangleIndexBuffer, DXGI_FORMAT_R16_UINT, 0 );
                                                 xor                 r9, r9                                            ; Set Offset
                                                 mov                 r8, dxgi_format_r16_uint                          ; Set Format
                                                 mov                 rdx, basicCarIndexBuffer                              ; Set *pIndexBuffer
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetIndexBuffer, rcx, rdx, r8, r9


                                                 ;-----[Draw the scene]-------------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->DrawInstanced( 6, 10, 0, 0 );
                                                
                                                 xor                 r13, r13                                          ; set StartInstanceLocation
                                                 xor                 r12, r12                                          ; Set StartInstanceLocation
                                                 xor                 r9, r9                                            ; Set StartIndexLocation
                                                 mov                 r8d, numberOfBees                                ; Set InstanceCount
                                                 mov                 rdx, basicCarIndexCount                               ; Set IndexCountPerInstance
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_DrawIndexedInstanced, rcx, rdx, r8, r9, r12, r13         ; Draw the scene


                                                ;Draw traffic lights
                                                 
                                                

                                                ;LocalCall           RenderDebugGrid             


                                               
                                                 ;-----[Set primitive topology for points to draw sun]-----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetPrimitiveTopology( D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST );

                                                 mov                 rdx, D3D11_PRIMITIVE_TOPOLOGY_POINTLIST            ; Set Topology
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetPrimitiveTopology, rcx, rdx
                                                 
                                                 ;-----[set the blend state]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->CreateBlendState(&blendDesc, &blendState);

                                                 mov                 rdx, blendStateAdditive                                    ; Set blendDesc
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetBlendState, rcx, rdx, 0, 0FFFFFFFFh       ; Execute call

                                                   ;-----[Set the vertex shader]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetShader(VS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, vsPoints                                           ; Set *pVertexShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetShader                   ; Execute call

                                                 ;-----[Set the pixel shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetShader(PS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, psPoints                                           ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShader                   ; Execute call

                                                  ;-----[Set the geometry shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->GSSetShader(GS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, gsBillBoard                                    ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_GSSetShader                   ; Execute call

                                                 ;-----[Set the GS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->GSSetConstantBuffers( 0, 1, &cbCameraBuffer );
                                                 lea                 r9, cbCameraBuffer                                ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_GSSetConstantBuffers, rcx, rdx, r8, r9


                                                  ;-----[Set the GS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->GSSetConstantBuffers( 0, 1, &cbCameraBuffer );
                                                 lea                 r9, cbPerObjectBuffer                                ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 0                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_GSSetConstantBuffers, rcx, rdx, r8, r9


                                                  ;-----[Set the vertex buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );
                                                 lea                 r13, offset_                                      ; Set *pOffsets
                                                 lea                 r12, stridePoints                                  ; Set *pStrides
                                                 lea                 r9, pointVertexBuffer                    ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13


                                                 
                                                 ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayoutPoints                            ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout


                                                   
                                                 xor                 r8, r8                                            ; Set StartVertexLocation
                                                 mov                 rdx, number_of_points                                            ; Set VertexCount
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Draw, rcx, rdx, r8            ; Draw the scene



                                                 ;-----[Set the geometry shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->GSSetShader(GS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 xor                 rdx, rdx                                    ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_GSSetShader                   ; Execute call

                                                  ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayoutQuads                            ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout

                                                ;-----[Set primitive topology]-----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetPrimitiveTopology( D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST );

                                                 mov                 rdx, d3d11_primitive_topology_trianglestrip        ; Set Topology
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetPrimitiveTopology, rcx, rdx

                                                   ;-----[Disable depth testing]----------------------------------
                                                 ;
                                                 ; d3d11Device->OMSetDepthStencilState(depthStencilState, 1);

                                                 mov                 r8, 1                                              ; Set
                                                 mov                 rdx, depthStencilOffState                             ; set
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetDepthStencilState, rcx, rdx, r8

                                                 
                                                   ;-----[Set the vertex shader]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetShader(VS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, vsTexture2d                                           ; Set *pVertexShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetShader                   ; Execute call

                                                 ;-----[Set the pixel shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetShader(PS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, psTexture2d                                           ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShader                   ; Execute call

                                                 
                                                  ;-----[Set the test texture]-------------------------------------
                                                 ;
                                                 ; 
                                                 lea                 r9, testTextureResouceView                        ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShaderResources, rcx, rdx, r8, r9


												                         ;-----[Set the PS sampler]-------------------------------------
                                                 ;
                                                 ; 
                                                 lea                 r9, textureSampler                      ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumSamplers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetSamplers, rcx, rdx, r8, r9
                                                 


                                                  ;-----[Set the vertex buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );
                                                 lea                 r13, offset_                                      ; Set *pOffsets
                                                 lea                 r12, strideQuads                                  ; Set *pStrides
                                                 lea                 r9, testTextureVertexBuffer                    ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13

                                                      
                                                 xor                 r8, r8                                            ; Set StartVertexLocation
                                                 mov                 rdx, 4                      ; Set VertexCount
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                ; WinCall             ID3D11DeviceContext_Draw, rcx, rdx, r8            ; Draw the scene

                                                

                                                  ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayoutFont                            ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout

                                                    ;-----[Set the vertex shader]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetShader(VS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, vsFont                                          ; Set *pVertexShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetShader                   ; Execute call


                                                  ;-----[Set the test texture]-------------------------------------
                                                 ;
                                                 ; 
                                                 lea                 r9, fontTextureResouceView                        ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShaderResources, rcx, rdx, r8, r9


                                                 
                                                  ;-----[Set the vertex buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );
                                                 lea                 r13, offset_                                      ; Set *pOffsets
                                                 lea                 r12, strideFont                                  ; Set *pStrides
                                                 lea                 r9, fontTextureVertexBuffer                    ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13

                                                      
                                                 xor                 r8, r8                                            ; Set StartVertexLocation
                                                 mov                 rax, 4
                                                 mul                 textLength
                                                 mov                 rdx, rax                     ; Set VertexCount
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Draw, rcx, rdx, r8            ; Draw the scene



                                                 ;-----[Present the scene]----------------------------------------------
                                                 ;
                                                 ; SwapChain->Present(0, 0);

                                                 xor                 r8, r8                                            ; Set Flags
                                                 xor                 rdx, rdx                                          ; Set SyncInterval
                                                 mov                 rcx, SwapChain                                    ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             IDXGISwapChain_Present, rcx, rdx, r8              ; Present the scene



                                                 ;-----[Zero final return]----------------------------------------------

                                                 xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
RenderScene_Exit:                                Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

RenderScene                                      endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; RenderShadowMap                                                                                                          -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  <No Parameters>                                                                                                 -
;                                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

RenderShadowMap                                  proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers


;------[Render scene to shadow map]-------------------------------------------------------------------------------------
                                                

												                        ;-----[unmap shadowmap texture]-------------------------------------
                                                 ;
                                                 ; 
                                                 lea                 r9, shaderResourceViewNullPtr    					; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 0                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShaderResources, rcx, rdx, r8, r9


                                                 ;-----[Set the viewport]-----------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->RSSetViewports(1, &viewport);

                                                 lea                 r8, shadowViewport                                      ; Set *pViewPorts
                                                 mov                 rdx, 1                                            ; Set NumViewports
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_RSSetViewports, rcx, rdx, r8  ; Set the viewport


												
                                                 ;-----[Set rasterizer state]---------------------------------------
                                                 ;
                                                 ; d3d11DevCon->RSSetState(rasterizerState);

                                                 mov                 rdx, shadowMapRasterizerState                              ; Set *pRasterizerState
                                                 mov                 rcx, D3D11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_RSSetState, rcx, rdx          ; Set the rasterizer state

                                                 ;-----[Set primitive topology]-----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetPrimitiveTopology( D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST );

                                                 mov                 rdx, D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST        ; Set Topology
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetPrimitiveTopology, rcx, rdx

                                                  ;-----[Set the render target]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->OMSetRenderTargets( 0, NULL,  shadowMapDepthView);

                                                 mov                 r9, shadowMapDepthView                            ; Set *pDepthStencilView
                                                 xor                 r8, r8                                            ; Set *ppRenderTargetViews
                                                 mov                 rdx, 0                                            ; Set NumViews
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetRenderTargets            ; Execute call
                                                
                                                 
  												 ;-----[enable depth testing]----------------------------------
                                                 ;
                                                 ; d3d11Device->OMSetDepthStencilState(depthStencilState, 1);

                                                 mov                 r8, 1                                              ; Set
                                                 mov                 rdx, depthStencilState                             ; set
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetDepthStencilState, rcx, rdx, r8

												 
                                                 ;-----[Clear the background]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->ClearRenderTargetView(renderTargetView, bgColor);

                                                 lea                 r8, bgColor                                       ; Set ColorRGBA
                                                 mov                 rdx, renderTargetView                             ; Set *pRenderTargetView
                                                 mov                 rcx, d3d11DevCon                                  ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_ClearRenderTargetView, rcx, rdx, r8

                                                 ;-----[Clear the depth stencil view]-----------------------------------
                                                 ;
                                                 ; d3d11DevCon->ClearDepthStencilView(depthStencilView,
                                                 ;                                      D3D11_CLEAR_DEPTH | D3D11_CLEAR_STENCIL,
                                                 ;                                      1.0f, 0);

                                                 xorps               xmm3, xmm3                                        ; Depth goes in xmm3
                                                 movss               xmm3, r1                                           ; Set Depth
                                                 mov                 r8, D3D11_CLEAR_DEPTH or D3D11_CLEAR_STENCIL      ; Set ClearFlags
                                                 mov                 rdx, shadowMapDepthView                             ; Set *pDepthStencilView
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_ClearDepthStencilView, rcx, rdx, r8, r9, 0


                                                   ;-----[Set the view matrix]--------------------------------------------
                                                 ;
                                                 ; camView = XMMatrixLookAtLH( camPosition, camLookTo, camUp );

                                                 movaps xmm0, lightDirection
                                                 xorps xmm1, xmm1
                                                 subps xmm1, xmm0
                                                 movaps lightDirectionInv, xmm1

                                                 lea                 r9, camUp                                         ; Set vUp
                                                 lea                 r8, origin                                 ; set FocusPosition
                                                 lea                 rdx, lightDirection                               		   ; Set cameraPosition
                                                 lea                 rcx, mView                                        ; Set undocumented mOut
                                                 WinCall             XMMatrixLookAtLHProxy, rcx, rdx, r8, r9           ; Set the view matrix

                                                 ;-----[Set matrix mWVP = mWorld * mView]-------------------------------
                                                 ;
                                                 ; mWVP = mWorld * mView * mProj;

                                                 lea                 r8, mView                                         ; Set M2
                                                 lea                 rdx, mWorld                                       ; Set M1
                                                 lea                 rcx, mWVP                                         ; Set m
                                                 WinCall             XMMatrixMultiplyProxy, rcx, rdx, r8               ; Set mWVP = mWorld * mView

                                                 ;-----[Set matrix mWVP = mWVP * mProj]---------------------------------

                                                 lea                 r8, mProjOrtho                                      ; Set M2
                                                 lea                 rdx, mWVP                                         ; Set M1
                                                 lea                 rcx, mWVP                                         ; Set m
                                                 WinCall             XMMatrixMultiplyProxy, rcx, rdx, r8               ; Set mWVP = mWorld * mView

                                                 ;-----[Transpose result into constant buffer]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);

                                                 lea                 rdx, mWVP                                         ; Set M1
                                                 lea                 rcx, cbPerObj                                     ; Set mOut
                                                 WinCall             XMMatrixTransposeProxy, rcx, rdx                  ; Transpose image to target			

                                                								 
												 
                                                 movaps xmm1, xmmword ptr [lightDirection]
                                                 movaps xmmword ptr [directionalLightBuffer.lightDirection], xmm1

												 
                                                 ;-----[Transpose result into constant buffer]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);

                                                 lea                 rdx, mWVP                                         ; Set M1
                                                 lea                 rcx, directionalLightBuffer.mMVP                  ; Set mOut
                                                 WinCall             XMMatrixTransposeProxy, rcx, rdx                  ; Transpose image to target
                                                
                                                movaps xmm1, xmmword ptr [lightPosition]
                                                movaps xmmword ptr [directionalLightBuffer.sunPosition], xmm1

                                                 ;-----[Update the sub resource]----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->UpdateSubresource( cbPerObjectBuffer, 0, NULL, &cbPerObj, 0, 0 );

                                                 lea                 r12, cbPerObj                                     ; Set *pSrcData
                                                 xor                 r9, r9                                            ; Set *pDstBox
                                                 xor                 r8, r8                                            ; Set DstSubresource
                                                 mov                 rdx, cbPerObjectBuffer                            ; Set *pDstResource
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_UpdateSubresource, rcx, rdx, r8, r9, r12, 0, 0

												                         ;-----[Set the pixel shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetShader(PS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 xor                 rdx, rdx                                           ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShader                   ; Execute call


                                                 

                                                 ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayout                                   ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout
                                                 
                                                
												                        ;-----[Set the vertex shader]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetShader(VS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, vsCars                                           ; Set *pVertexShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetShader                   ; Execute call

                                                

                                                ;-------[Render cars]

                                                  ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayoutCars                                   ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout


                                                  ;-----[Set the vertex buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );
                                                 lea                 r13, offset_                                      ; Set *pOffsets
                                                 lea                 r12, stride                                  ; Set *pStrides
                                                 lea                 r9, carsVertexBuffer                    ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13

                                                   ;-----[Set the instance buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );
                                                 lea                 r13, offset_1                                      ; Set *pOffsets
                                                 lea                 r12, stride1                                       ; Set *pStrides
                                                 lea                 r9, beeInstanceBuffer                         ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 mov                 rdx, 1                                            ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13
                                                
                                                 ;-----[Set the index buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetIndexBuffer( triangleIndexBuffer, DXGI_FORMAT_R16_UINT, 0 );
                                                 xor                 r9, r9                                            ; Set Offset
                                                 mov                 r8, dxgi_format_r16_uint                          ; Set Format
                                                 mov                 rdx, basicCarIndexBuffer                              ; Set *pIndexBuffer
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetIndexBuffer, rcx, rdx, r8, r9


                                                 ;-----[Draw the scene]-------------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->DrawInstanced( 6, 10, 0, 0 );
                                                
                                                 xor                 r13, r13                                          ; set StartInstanceLocation
                                                 xor                 r12, r12                                          ; Set StartInstanceLocation
                                                 xor                 r9, r9                                            ; Set StartIndexLocation
                                                 mov                 r8d, numberOfBees                                 ; Set InstanceCount
                                                 mov                 rdx, basicCarIndexCount                               ; Set IndexCountPerInstance
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_DrawIndexedInstanced, rcx, rdx, r8, r9, r12, r13         ; Draw the scene
                                                
                                                 

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
RenderShadowMap_Exit:                            Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

RenderShadowMap                                  endp                                                                  ; End function


