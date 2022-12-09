
;-----------------------------------------------------------------------------------------------------------------------
;																												-
; RunMessageLoop																								-
;																												-
;-----------------------------------------------------------------------------------------------------------------------
;																												-
; In:  <No Parameters>																							-
;																												-
; This function registers the window class MainWindowClass, creates the main window as a top level window of that  	-
; class, and returns the new window handle in RAX.  RAX is returned as -1 if the function fails.						-
;																												-
;-----------------------------------------------------------------------------------------------------------------------

RunMessageLoop								proc																; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

												local				holder:qword									;
												local				msg_data:msg									;

;------[Save incoming registers]----------------------------------------------------------------------------------------

												Save_Registers													; Save incoming registers

												;-----[Get the next message]-------------------------------------------

RunMessageLoop_00001:							xor					r9, r9											; Set wMsgFilterMax
												xor				r8, r8											; Set wMsgFilterMin
												xor				rdx, rdx										; Set hWnd
												lea				rcx, msg_data									; Set lpMsg
												WinCall			PeekMessage, rcx, rdx, r8, r9, pm_remove  		; Peek for next message

												;-----[Branch if no messages]------------------------------------------

												test				rax, rax										; Anything available?
												jz					RunMessageLoop_00003							; No - render scene

												;-----[Branch if not WM_Quit]------------------------------------------

												cmp				msg_data.message, wm_quit						; WM_Quit?
												jnz				RunMessageLoop_00002							; No - continue process

												;-----[Send the message manually]--------------------------------------

												xor				r9, r9											; Set lParam
												xor				r8, r8											; Set wParam
												mov				rdx, wm_quit									; Set uMsg
												mov				rcx, Main_Handle								; Set hWnd
												WinCall			SendMessage, rcx, rdx, r8, r9					; Execute call

												;-----[Exit the function]----------------------------------------------

												xor				rax, rax										; Zero final return
												jmp				RunMessageLoop_Exit								; Exit function

												;-----[Translate the message]------------------------------------------

RunMessageLoop_00002:							lea				rcx, msg_data									; Set lpMsg
												WinCall			TranslateMessage, rcx							; Execute call

												;-----[Dispatch the message]-------------------------------------------

												lea				rcx, msg_data									; Set lpMsg
												WinCall			DispatchMessage, rcx							; Execute call

												;-----[Check for next message]-----------------------------------------

												jmp				RunMessageLoop_00001							; Reloop for next check

												;-----[Update the scene]-----------------------------------------------

RunMessageLoop_00003:							LocalCall   		UpdateScene									; Execute call

												;-----[Render the scene]-----------------------------------------------

												LocalCall   		RenderScene									; Render the scene

												;-----[Check for next message]-----------------------------------------

												jmp				RunMessageLoop_00001							; Reloop for next check

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align				qword											; Set qword alignment
RunMessageLoop_Exit:							Restore_Registers													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

												ret																; Return to caller

RunMessageLoop									endp																; End function



;-----------------------------------------------------------------------------------------------------------------------
;																												-
; SetupDirectX																									-
;																												-
;-----------------------------------------------------------------------------------------------------------------------
;																												-
; In:  <No Parameters>																							-
;																												-
; This function registers the window class MainWindowClass, creates the main window as a top level window of that  	-
; class, and returns the new window handle in RAX.  RAX is returned as -1 if the function fails.						-
;																												-
;-----------------------------------------------------------------------------------------------------------------------

SetupDirectX									proc																; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

												local				holder:qword									;

;------[Save incoming registers]----------------------------------------------------------------------------------------

												Save_Registers													; Save incoming registers

												;-----[Get the client area]--------------------------------------------

												;int 3
												lea				rdx, client_rect								; Set lprc
												mov				rcx, Main_Handle								; Set hWnd
												WinCall			GetClientRect, rcx, rdx							; Get the client area
												
												cvtsi2ss xmm0, client_rect.right
												movss screenWidth, xmm0
												movss xmm1, r1
												divss xmm1, xmm0
												movss screenWidthInv, xmm1
												cvtsi2ss xmm0, client_rect.bottom
												movss screenHeight, xmm0
												movss xmm1, r1
												divss xmm1, xmm0
												movss screenHeightInv, xmm1

												;-----[Set values that are unknown before runtime]---------------------
												;
												; C++ code below - for reference only
												;
												; DXGI_MODE_DESC bufferDesc;
												;
												; ZeroMemory(&bufferDesc, sizeof(DXGI_MODE_DESC));
												;
												; bufferDesc.Width = Width;
												; bufferDesc.Height = Height;
												; bufferDesc.RefreshRate.Numerator = 60;
												; bufferDesc.RefreshRate.Denominator = 1;
												; bufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
												; bufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;
												; bufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;
												;
												; //Describe our SwapChain
												; DXGI_SWAP_CHAIN_DESC swapChainDesc;
												;
												; ZeroMemory(&swapChainDesc, sizeof(DXGI_SWAP_CHAIN_DESC));
												;
												; swapChainDesc.BufferDesc = bufferDesc;
												; swapChainDesc.SampleDesc.Count = 1;
												; swapChainDesc.SampleDesc.Quality = 0;
												; swapChainDesc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
												; swapChainDesc.BufferCount = 1;
												; swapChainDesc.OutputWindow = hwnd;
												; swapChainDesc.Windowed = TRUE;
												; swapChainDesc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;

												;----- Note that all the above is relatively standard for DirectX handling and is mostly a waste
												;  	of resources, both CPU and memory.  Our handling of the same structures holding the same
												;  	startup data only dynamically sets the data that is unknown until runtime.  The unnecessary
												;  	statements required to move data needlessly take up memory for the code and waste CPU time
												;  	executing.
												;
												;  	Even more ludicrous is wasting the memory for the bufferDesc structure, then using code
												;  	bytes to manually fill it with data that's all static except for the client width and heigth,
												;  	and the window handle, then moving it all into swapChainDesc.BufferDesc.  What a massive waste!

												xor				rax, rax										; Zero RAX
												mov				eax, client_rect.right							; Get the client area width
												mov				swapChainDesc.BufferDesc._Width, eax				; Store the buffer width

												mov				eax, client_rect.bottom							; Get the client area height
												mov				swapChainDesc.BufferDesc._Height, eax			; Store the buffer height

												mov				rax, Main_Handle								; Get the window handle
												mov				swapChainDesc.OutputWindow, rax					; Set the output window handle
												
												;----- That's it.  7 ASM instructions and the dxgi_swap_chain_desc structure is fully loaded and ready
												;  	to pass.

												;----- [Create the device and swap chain]------------------------------
												;
												; hr = D3D11CreateDeviceAndSwapChain(NULL, D3D_DRIVER_TYPE_HARDWARE,
												;									NULL, NULL, NULL, NULL,
												;									D3D11_SDK_VERSION, &swapChainDesc,
												;									&SwapChain, &d3d11Device, NULL, &
												;									d3d11DevCon);

												lea				r15, d3d11DevCon								; Set **ppImmediateContext
												lea				r14, d3d11Device								; Set **ppDevice
												lea				r13, swapChain									; Set **ppSwapChain
												lea				r12, swapChainDesc								; Set pSwapChainDesc
												mov				r9, 0;d3d11_create_device_debug				; Set flags : use debug flag for debug mode
												xor				r8, r8											; Set Software
												mov				rdx, D3D_DRIVER_TYPE_HARDWARE					; Set DriverType
												xor				rcx, rcx										; Set *pAdapter
												WinCall			D3D11CreateDeviceAndSwapChain, rcx, rdx, r8, r9, 0, 0, D3D11_SDK_VERSION, r12, r13, r14, 0, r15

												;----------------------------------------------------------------------

												;-----> Error if RAX != 0

												
												;-----[Create our back buffer]-----------------------------------------
												;
												; Note: ASM doesn't know or care about typecasting.  This is enormously
												;   	powerful as well as time saving.  Data is data; the only thing
												;   	the instructions care about is the size of each access in bytes.
												;   	Since all pointers are 64 bits, BackBuffer is simply a qword.
												;   	Don't use it where it shouldn't be used and you won't have any
												;   	problems.  The amount of coding that is saved becomes stag-
												;   	gering across an entire app from this aspect alone
												;
												; ID3D11Texture2D* BackBuffer;
												;
												; hr = SwapChain->GetBuffer( 0, __uuidof( ID3D11Texture2D ),
												;							(void--)&BackBuffer );

Create_Back_Buffer:								lea				r9, BackBuffer									; Set **ppSurface
												lea				r8, IID_ID3D11Texture2D							; Set riid
												xor				rdx, rdx										; Set Buffer
												mov				rcx, SwapChain									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			IDXGISwapChain_GetBuffer						; Get the buffer pointer

												;-----[----------------------------------------------------------------
												;-----> Error if RAX != 0

												;-----[Create our render target]---------------------------------------
												;
												; hr = d3d11Device->CreateRenderTargetView( BackBuffer, NULL, &renderTargetView );

												lea				r9, renderTargetView							; Set **ppRTView
												xor				r8, r8											; Set *pDesc
												mov				rdx, BackBuffer								; Set *pResource
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateRenderTargetView, rcx, rdx, r8, r9
												

											
												;-----[Release the back buffer]----------------------------------------
												;
												; BackBuffer->Release();

												mov				rcx, BackBuffer								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set vTable pointer
												WinCall			ID3D11Texture2D_Release, rcx					; Execute call

												;-----[Release the back buffer]----------------------------------------

												mov				eax, client_rect.right							; Get the client width
												mov				depthStencilViewDesc._Width, eax					; Set width
												mov				eax, client_rect.bottom							; Get the client height
												mov				depthStencilViewDesc._Height, eax					; Set height

												;-----[Create the depth stencil buffer]--------------------------------
												;
												; d3d11Device->CreateTexture2D(&depthStencilViewDesc, NULL, &depthStencilBuffer);

												lea				r9, depthStencilBuffer							; Set
												xor				r8, r8											; Set
												lea				rdx, depthStencilViewDesc						; Set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateTexture2D, rcx, rdx, r8, r9	; Create the depth stencil buffer
												
													;-----[Create the shadow map depth stencil buffer]--------------------------------
												;
												; d3d11Device->CreateTexture2D(&depthStencilViewDesc, NULL, &depthStencilBuffer);

												lea				r9, shadowMapRenderTexture							; Set
												xor				r8, r8											; Set
												lea				rdx, shadowMapDesc								; Set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateTexture2D, rcx, rdx, r8, r9	; Create the depth stencil buffer

												
												;-----[Create font texture]--------------------------------
												;
												; d3d11Device->CreateTexture2D(&depthStencilViewDesc, NULL, &testTexture);

												lea				r9, fontTexture								; Set 
												lea				r8, fontTextureSubResourceData								; Set
												lea				rdx, fontTextureDesc								; Set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateTexture2D, rcx, rdx, r8, r9	; Create the depth stencil buffer
												
												
												;-----[Create the shadow depth stencil view]----------------------------------
												;
												; d3d11Device->CreateDepthStencilView(depthStencilBuffer, NULL, &depthStencilView);

												lea				r9, shadowMapDepthView							; Set
												lea				r8, shadowMapDepthStencilViewDesc					; Set
												mov				rdx, shadowMapRenderTexture							; set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateDepthStencilView, rcx, rdx, r8, r9

													;-----[Create the shadowmap resource view]----------------------------------
												;

												lea				r9, shadowMapResouceView							; Set
												lea				r8, shadowmapResourceShaderViewDesc					; Set
												mov				rdx, shadowMapRenderTexture							; set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateShaderResourceView, rcx, rdx, r8, r9
												
												
													;-----[Create the font texture resource view]----------------------------------
												;

												lea				r9, fontTextureResouceView							; Set
												lea				r8, testTextureShaderViewDesc					; Set
												mov				rdx, fontTexture							; set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateShaderResourceView, rcx, rdx, r8, r9

												;int 3
												;-----[Create the depth stencil state]----------------------------------
												;
												; d3d11Device->CreateDepthStencilState(&depthStencilDesc, &depthStencilState);

												lea				r8, depthStencilState							; Set
												lea				rdx, depthStencilDesc							; set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateDepthStencilState, rcx, rdx, r8

													;-----[Create the depth stencil state]----------------------------------
												;
												; d3d11Device->CreateDepthStencilState(&depthStencilDesc, &depthStencilState);

												lea				r8, depthStencilOffState							; Set
												lea				rdx, depthStencilOffDesc							; set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateDepthStencilState, rcx, rdx, r8


												;-----[Set the depth stencil view]----------------------------------
												;
												; d3d11Device->OMSetDepthStencilState(depthStencilState, 1);

												mov				r8, 1											; Set
												mov				rdx, depthStencilState							; set
												mov				rcx, d3d11DevCon								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11DeviceContext_OMSetDepthStencilState, rcx, rdx, r8
												
												
												
												;-----[Create the depth stencil view]----------------------------------
												;
												; d3d11Device->CreateDepthStencilView(depthStencilBuffer, NULL, &depthStencilView);

												lea				r9, depthStencilView							; Set
												xor				r8, r8											; Set
												mov				rdx, depthStencilBuffer							; set
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateDepthStencilView, rcx, rdx, r8, r9

												;-----[Set the render target]------------------------------------------
												;
												; d3d11DevCon->OMSetRenderTargets( 1, &renderTargetView, NULL );

												mov				r9, depthStencilView								; Set *pDepthStencilView
												lea				r8, renderTargetView							; Set *ppRenderTargetViews
												mov				rdx, 1											; Set NumViews
												mov				rcx, d3d11DevCon								; Set interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11DeviceContext_OMSetRenderTargets			; Execute call
												
												;-----[Compile the vertex shader]--------------------------------------
												;
												; hr = D3DX11CompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							0, &VS_Buffer, 0   , 0);
												; hr = D3DCompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							&VS_Buffer, 0)

												lea				r13, VS_Buffer									; Set **ppShader
												lea				r12, vs_profile								; Set pProfile
												lea				r9, vs_Function								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0

												;-----[----------------------------------------------------------------

												;-----> Error if RAX != 0
												

												;-----[Compile the pixel shader]---------------------------------------

												lea				r13, PS_Buffer									; Set **ppShader
												lea				r12, ps_profile								; Set pProfile
												lea				r9, ps_Function								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0

													;-----[Compile the geometry shader]---------------------------------------

												lea				r13, GS_Buffer									; Set **ppShader
												lea				r12, gs_profile								; Set pProfile
												lea				r9, gsTerrain_function							; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0

												;-----[----------------------------------------------------------------

												;-----> Error if RAX != 0

												;-----[Create the vertex shader object]--------------------------------
												;
												; hr = d3d11Device->CreateVertexShader(VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										NULL, &VS);

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer
												mov				vBufferPtr, rax								; Save value for IASetInputLayout use

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size
												mov				vBufferSize, rax								; Save value for IASetInputLayout use

												lea				r12, vs										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateVertexShader, rcx, rdx, r8, r9, r12

													;-----> Error if RAX != 0

												


												
													;-----[Create the pixel shader object]---------------------------------
												;
												; hr = d3d11Device->CreatePixelShader(PS_Buffer->GetBufferPointer(), PS_Buffer->GetBufferSize(), NULL, &PS);

												mov				rcx, PS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer

												mov				rcx, PS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size

												lea				r12, ps										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreatePixelShader, rcx, rdx, r8, r9, r12
												;-----[Compile the vertex shader for cars]--------------------------------------
												;
												; hr = D3DX11CompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							0, &VS_Buffer, 0   , 0);
												; hr = D3DCompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							&VS_Buffer, 0)

												lea				r13, VS_Buffer									; Set **ppShader
												lea				r12, vs_profile								; Set pProfile
												lea				r9, vs_function_cars								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0

													;-----[Create the vertex shader object]--------------------------------
												;
												; hr = d3d11Device->CreateVertexShader(VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										NULL, &VS);

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer
												mov				vBufferPtr, rax								; Save value for IASetInputLayout use

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size
												mov				vBufferSize, rax								; Save value for IASetInputLayout use

												lea				r12, vsCars										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateVertexShader, rcx, rdx, r8, r9, r12
												
												
													;-----[Create the input layout]----------------------------------------
												;
												; hr = d3d11Device->CreateInputLayout( layout, numElements,
												;										VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										&vertLayout );

												lea				r13, vertLayoutCars								; Set **ppInputLayout
												mov				r12, vBufferSize								; set BytecodeLength
												mov				r9, vBufferPtr									; Set *pShaderBytecode
												mov				r8, numElementsCars								; Set Set numElements
												lea				rdx, layout_cars									; Set *pInputElementDescs
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateInputLayout, rcx, rdx, r8, r9, r12, r13

												
													;-----[Compile the vertex shader for points]--------------------------------------
												;
												; hr = D3DX11CompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							0, &VS_Buffer, 0   , 0);
												; hr = D3DCompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							&VS_Buffer, 0)

												lea				r13, VS_Buffer									; Set **ppShader
												lea				r12, vs_profile								; Set pProfile
												lea				r9, vs_function_points								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0


													;-----[Create the vertex shader object]--------------------------------
												;
												; hr = d3d11Device->CreateVertexShader(VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										NULL, &VS);

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer
												mov				vBufferPtr, rax								; Save value for IASetInputLayout use

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size
												mov				vBufferSize, rax								; Save value for IASetInputLayout use

												lea				r12, vsPoints										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateVertexShader, rcx, rdx, r8, r9, r12


													;-----[Create the input layout]----------------------------------------
												;
												; hr = d3d11Device->CreateInputLayout( layout, numElements,
												;										VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										&vertLayout );

												lea				r13, vertLayoutPoints								; Set **ppInputLayout
												mov				r12, vBufferSize								; set BytecodeLength
												mov				r9, vBufferPtr									; Set *pShaderBytecode
												mov				r8, numElementsPoints								; Set Set numElements
												lea				rdx, layout_points									; Set *pInputElementDescs
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateInputLayout, rcx, rdx, r8, r9, r12, r13

												
												;-----[Compile the pixel shader]---------------------------------------

												lea				r13, PS_Buffer									; Set **ppShader
												lea				r12, ps_profile								; Set pProfile
												lea				r9, ps_function_points								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0


													;-----[Create the pixel shader object]---------------------------------
												;
												; hr = d3d11Device->CreatePixelShader(PS_Buffer->GetBufferPointer(), PS_Buffer->GetBufferSize(), NULL, &PS);

												mov				rcx, PS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer

												mov				rcx, PS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size

												lea				r12, psPoints										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreatePixelShader, rcx, rdx, r8, r9, r12



												;-----> Error if RAX != 0

													;-----[Compile the vertex shader for quads]--------------------------------------
												;
												; hr = D3DX11CompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							0, &VS_Buffer, 0   , 0);
												; hr = D3DCompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							&VS_Buffer, 0)

												lea				r13, VS_Buffer									; Set **ppShader
												lea				r12, vs_profile								; Set pProfile
												lea				r9, vs_function_quads								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0


													;-----[Create the vertex shader object]--------------------------------
												;
												; hr = d3d11Device->CreateVertexShader(VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										NULL, &VS);

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer
												mov				vBufferPtr, rax								; Save value for IASetInputLayout use

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size
												mov				vBufferSize, rax								; Save value for IASetInputLayout use

												lea				r12, vsQuads										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateVertexShader, rcx, rdx, r8, r9, r12


												;-----[Compile the geometry shader]---------------------------------------

												lea				r13, GS_Buffer									; Set **ppShader
												lea				r12, gs_profile								; Set pProfile
												lea				r9, gsBillboard_function							; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0
												
												;-----[Create the geometry shader object]--------------------------------
												;
												; hr = d3d11Device->CreateGeometryShader(GS_Buffer->GetBufferPointer(),
												;										GS_Buffer->GetBufferSize(),
												;										NULL, &VS);

												mov				rcx, GS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer

												mov				rcx, GS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size

												lea				r12, gsBillboard									; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateGeometryShader, rcx, rdx, r8, r9, r12

													;-----[Create the input layout]----------------------------------------
												;
												; hr = d3d11Device->CreateInputLayout( layout, numElements,
												;										VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										&vertLayout );

												lea				r13, vertLayoutQuads								; Set **ppInputLayout
												mov				r12, vBufferSize								; set BytecodeLength
												mov				r9, vBufferPtr									; Set *pShaderBytecode
												mov				r8, numElementsQuads								; Set Set numElements
												lea				rdx, layout_quads									; Set *pInputElementDescs
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateInputLayout, rcx, rdx, r8, r9, r12, r13



												
												;-----[Compile the pixel shader]---------------------------------------

												lea				r13, PS_Buffer									; Set **ppShader
												lea				r12, ps_profile								; Set pProfile
												lea				r9, ps_function_quads								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0


													;-----[Create the pixel shader object]---------------------------------
												;
												; hr = d3d11Device->CreatePixelShader(PS_Buffer->GetBufferPointer(), PS_Buffer->GetBufferSize(), NULL, &PS);

												mov				rcx, PS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer

												mov				rcx, PS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size

												lea				r12, psQuads										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreatePixelShader, rcx, rdx, r8, r9, r12


												
														;-----[Compile the vertex shader for ui textures]--------------------------------------
												;
												; hr = D3DX11CompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							0, &VS_Buffer, 0   , 0);
												; hr = D3DCompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							&VS_Buffer, 0)

												lea				r13, VS_Buffer									; Set **ppShader
												lea				r12, vs_profile								; Set pProfile
												lea				r9, vs_function_texture2d								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0


													;-----[Create the vertex shader object]--------------------------------
												;
												; hr = d3d11Device->CreateVertexShader(VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										NULL, &VS);

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer
												mov				vBufferPtr, rax								; Save value for IASetInputLayout use

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size
												mov				vBufferSize, rax								; Save value for IASetInputLayout use

												lea				r12, vsTexture2d										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateVertexShader, rcx, rdx, r8, r9, r12

												
																								
												;-----[Compile the pixel shader]---------------------------------------

												lea				r13, PS_Buffer									; Set **ppShader
												lea				r12, ps_profile								; Set pProfile
												lea				r9, ps_function_texture2d								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0


													;-----[Create the pixel shader object]---------------------------------
												;
												; hr = d3d11Device->CreatePixelShader(PS_Buffer->GetBufferPointer(), PS_Buffer->GetBufferSize(), NULL, &PS);

												mov				rcx, PS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer

												mov				rcx, PS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size

												lea				r12, psTexture2d										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreatePixelShader, rcx, rdx, r8, r9, r12

												
												

												
														;-----[Compile the vertex shader for ui textures]--------------------------------------
												;
												; hr = D3DX11CompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							0, &VS_Buffer, 0   , 0);
												; hr = D3DCompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
												;							&VS_Buffer, 0)

												lea				r13, VS_Buffer									; Set **ppShader
												lea				r12, vs_profile								; Set pProfile
												lea				r9, vs_function_font								; Set pFunctionName
												mov				r8, 1											; Set pInclude
												xor				rdx, rdx										; Set *pDefines
												lea				rcx, effect_file								; Set pSrcFile
												WinCall			D3DCompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, r13, 0


													;-----[Create the vertex shader object]--------------------------------
												;
												; hr = d3d11Device->CreateVertexShader(VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										NULL, &VS);

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferPointer						; Get the buffer pointer
												push				rax											; Save the buffer pointer
												mov				vBufferPtr, rax								; Save value for IASetInputLayout use

												mov				rcx, VS_Buffer									; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D10Blob_GetBufferSize						; Get the buffer size
												mov				vBufferSize, rax								; Save value for IASetInputLayout use

												lea				r12, vsFont										; Set **ppVertexShader
												xor				r9, r9											; Set *pClassLinkage
												mov				r8, rax										; Set BytecodeLength
												pop				rdx											; Set *pShaderBytecode
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateVertexShader, rcx, rdx, r8, r9, r12

														;-----[Create the input layout]----------------------------------------
												;
												; hr = d3d11Device->CreateInputLayout( layout, numElements,
												;										VS_Buffer->GetBufferPointer(),
												;										VS_Buffer->GetBufferSize(),
												;										&vertLayout );

												lea				r13, vertLayoutFont								; Set **ppInputLayout
												mov				r12, vBufferSize								; set BytecodeLength
												mov				r9, vBufferPtr									; Set *pShaderBytecode
												mov				r8, numElementsFont								; Set Set numElements
												lea				rdx, layout_font									; Set *pInputElementDescs
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateInputLayout, rcx, rdx, r8, r9, r12, r13

												;-----[Create the vertex buffer object]--------------------------------
												;
												; D3D11_BUFFER_DESC vertexBufferDesc;
												; ZeroMemory( &vertexBufferDesc, sizeof(vertexBufferDesc) );
												;
												; vertexBufferDesc.Usage = D3D11_USAGE_DEFAULT;
												; vertexBufferDesc.ByteWidth = sizeof( Vertex ) * 3;
												; vertexBufferDesc.BindFlags = D3D11_BIND_VERTEX_BUFFER;
												; vertexBufferDesc.CPUAccessFlags = 0;
												; vertexBufferDesc.MiscFlags = 0;
												;
												; D3D11_SUBRESOURCE_DATA vertexBufferData;
												;
												; ZeroMemory( &vertexBufferData, sizeof(vertexBufferData) );
												; vertexBufferData.pSysMem = v;
												;
												; hr = d3d11Device->CreateBuffer( &vertexBufferDesc, &vertexBufferData,
												;								&triangleVertBuffer);

												
												lea				r9, pointVertexBuffer						; Set **ppBuffer
												lea				r8, vertexBufferDataPoints							; Set *pInitialData
												lea				rdx, vertexBufferDescPoints							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
												
											
												lea				r9, quadVertexBuffer						; Set **ppBuffer
												lea				r8, vertexBufferDataQuads							; Set *pInitialData
												lea				rdx, vertexBufferDescQuads							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
												
												lea				r9, fontTextureVertexBuffer						; Set **ppBuffer
												lea				r8, vertexBufferFontTexture2d							; Set *pInitialData
												lea				rdx, vertexBufferDescFontTexture2d							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
												
												lea				r9, blueBeeVertexBuffer						; Set **ppBuffer
												lea				r8, vertexBufferDataBlueBee							; Set *pInitialData
												lea				rdx, vertexBufferDescBlueBee							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
												
												lea				r9, yellowBeeVertexBuffer						; Set **ppBuffer
												lea				r8, vertexBufferDataYellowBee							; Set *pInitialData
												lea				rdx, vertexBufferDescYellowBee							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
												
												; lea				r9, triangleIndexBufferDebugGrid							; Set **ppBuffer
												; lea				r8, indexDebugGridBufferData								; Set *pInitialData
												; lea				rdx, indexDebugGridBufferDesc							; Set *pDesc
												; mov				rcx, d3d11Device								; Set the interface pointer
												; mov				rbx, [ rcx ]									; Set the vTable pointer
												; WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
 
												lea				r9, blueBeeIndexBuffer								; Set **ppBuffer
												lea				r8, blueBeeIndexBufferData								; Set *pInitialData
												lea				rdx, blueBeeIndexBufferDesc							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer

 

												lea				r9, yellowBeeIndexBuffer								; Set **ppBuffer
												lea				r8, yellowBeeIndexBufferData								; Set *pInitialData
												lea				rdx, yellowBeeIndexBufferDesc							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
 
												lea				r9, beeInstanceBuffer							; Set **ppBuffer
												lea				r8, instanceBufferData								; Set *pInitialData
												lea				rdx, instanceBufferDesc							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
												
												lea				r9, team2BeeInstanceBuffer							; Set **ppBuffer
												lea				r8, team2InstanceBufferData								; Set *pInitialData
												lea				rdx, instanceBufferDesc							; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer

												;-----[Set primitive topology]-----------------------------------------
												;
												; d3d11DevCon->IASetPrimitiveTopology( D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST );

												mov				rdx, D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST		; Set Topology
												mov				rcx, d3d11DevCon								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11DeviceContext_IASetPrimitiveTopology, rcx, rdx


													; int 3
												;-----[Create the blend state]------------------------------------------
												;
												; d3d11DevCon->CreateBlendState(&blendDesc, &blendState);

												lea				r8, blendState									;  **ppBlendState
												lea				rdx, blendDesc									; Set blendDesc
												mov				rcx, d3d11Device								; Set interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBlendState, rcx, rdx, r8   	; Execute call


												;-----[Create the blend state]------------------------------------------
												;
												; d3d11DevCon->CreateBlendState(&blendDesc, &blendState);

												lea				r8, blendStateAdditive									;  **ppBlendState
												lea				rdx, blendDescAdditive									; Set blendDesc
												mov				rcx, d3d11Device								; Set interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBlendState, rcx, rdx, r8   	; Execute call


												;-----[Create the sampler comparison state]------------------------------------------
												;

												lea				r8, shadowMapComparisonSampler									;  **ppBlendState
												lea				rdx, shadowMapComparisonSamplerDesc									; Set blendDesc
												mov				rcx, d3d11Device								; Set interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateSamplerState, rcx, rdx, r8   	; Execute call
												
												;-----[Create the sampler comparison state]------------------------------------------
												;

												lea				r8, textureSampler									;  **ppBlendState
												lea				rdx, samplerDesc									; Set blendDesc
												mov				rcx, d3d11Device								; Set interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateSamplerState, rcx, rdx, r8   	; Execute call
												

												;-----[Set the viewport structure]-------------------------------------
												;
												; XMM registers are used to convert integer values to floats.

												vmovd				xmm0, dword ptr client_rect.right				; Load the client width
												cvtdq2ps			xmm0, xmm0										; Convert to floating point
												movss				dword ptr viewport._Width, xmm0					; Store the viewport width

												vmovd				xmm0, dword ptr client_rect.bottom				; Load the client height
												cvtdq2ps			xmm0, xmm0										; Convert to floating point
												movss				dword ptr viewport._Height, xmm0				; Store the viewport height
												
												;-----[Set the shadow viewport structure]-------------------------------------
												;
												; XMM registers are used to convert integer values to floats.
												mov				rax, shadowMapWidth
												cvtsi2ss			xmm0, rax   ; Store the viewport width
												movss				shadowViewport._Height, xmm0   ; Store the viewport width
												movss				shadowViewport._Width,  xmm0   ; Store the viewport width

												;-----[Set the viewport]-----------------------------------------------
												;
												; d3d11DevCon->RSSetViewports(1, &viewport);

												lea				r8, viewport									; Set *pViewPorts
												mov				rdx, 1											; Set NumViewports
												mov				rcx, d3d11DevCon								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11DeviceContext_RSSetViewports, rcx, rdx, r8  ; Set the viewport

												;-----[Create the constant buffer]-------------------------------------
												;
												; hr = d3d11Device->CreateBuffer(&cbPerObjBufferDescription, NULL, &cbPerObjectBuffer);

												lea				r9, cbPerObjectBuffer							; Set **ppBuffer
												xor				r8, r8											; Set *pInitialData
												lea				rdx, cbPerObjBufferDescription					; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer

												;-----[Create the constant buffer]-------------------------------------
												;
												; hr = d3d11Device->CreateBuffer(&cbPerObjBufferDescription, NULL, &cbPerObjectBuffer);

												lea				r9, cbSkyBoxBuffer							; Set **ppBuffer
												xor				r8, r8											; Set *pInitialData
												lea				rdx, skyBoxBufferDescription					; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer

												;-----[Create the constant buffer]-------------------------------------
												;
												; hr = d3d11Device->CreateBuffer(&cbPerObjBufferDescription, NULL, &cbPerObjectBuffer);

												lea				r9, cbCameraBuffer								; Set **ppBuffer
												xor				r8, r8											; Set *pInitialData
												lea				rdx, cameraBufferDescription						; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer
												
												;-----[Create the constant buffer]-------------------------------------
												;
												; hr = d3d11Device->CreateBuffer(&cbPerObjBufferDescription, NULL, &cbPerObjectBuffer);

												lea				r9, cbMouseBuffer								; Set **ppBuffer
												xor				r8, r8											; Set *pInitialData
												lea				rdx, mouseBufferDescription						; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer

													;-----[Create the constant buffer]-------------------------------------
												;
												; hr = d3d11Device->CreateBuffer(&cbPerObjBufferDescription, NULL, &cbPerObjectBuffer);

												lea				r9, cbDirectionalLightBuffer					; Set **ppBuffer
												xor				r8, r8											; Set *pInitialData
												lea				rdx, directionalLightBufferDescription						; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer

												;-----[Create the constant buffer]-------------------------------------
												;
												; hr = d3d11Device->CreateBuffer(&cbPerObjBufferDescription, NULL, &cbPerObjectBuffer);

												lea				r9, cbWaterBuffer					; Set **ppBuffer
												xor				r8, r8											; Set *pInitialData
												lea				rdx, waterBufferDescription						; Set *pDesc
												mov				rcx, d3d11Device								; Set the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_CreateBuffer, rcx, rdx, r8, r9   	; Create the vertex buffer

												;-----[Set the view matrix]--------------------------------------------
												;
												; camView = XMMatrixLookAtLH( camPosition, camTarget, camUp );

												lea				r9, camUp										; Set vUp
												lea				r8, camTarget									; set vTarget
												lea				rdx, camPosition								; Set vPosition
												lea				rcx, mView										; Set undocumented mOut
												WinCall			XMMatrixLookToLHProxy, rcx, rdx, r8				; Set the view matrix
												
												;-----[Set the projection matrix]--------------------------------------
												;
												; mProj = XMMatrixPerspectiveFovLH( 0.4f*3.14f, Width/Height, 1.0f, 1000.0f);
													
												movss				xmm0, client_rect.right							; Get the client area width
												cvtdq2ps			xmm0, xmm0										; Convert value to float
												movss				xmm1, client_rect.bottom						; Get the client area height
												cvtdq2ps			xmm1, xmm1										; Convert value to float
												divps				xmm0, xmm1										; Set width / height
												movss				aspect_ratio, xmm0								; Store width / height

												xor				r12, r12										; Zero R12
												mov				r12d, r1300									; Set FarZ
												movss				xmm3, r1										; Set NearZ
												movss				xmm2, aspect_ratio								; Set AspectRatio
												movss				xmm1, p4pi										; Set FovAngleY
												lea				rcx, mProj										; Set undocumented mOut
												WinCall			XMMatrixPerspectiveFovLHProxy, rcx, rdx, r8, r9, r12


												;-----[Set the projection matrix]--------------------------------------
												mov				r14d, r640									; Set FarZ
												mov				r13d, r640n										; Set NearZ
												mov				r12d, r640									; Set ViewTop
												xorps				xmm3, xmm3
												subss				xmm3, r640									; Set ViewBottom
												movss				xmm2, r640									; Set ViewRight
												xorps				xmm1, xmm1
												subss				xmm1, r640									; Set ViewLeft
												lea				rcx, mProjOrtho								; Set undocumented mOut
												WinCall			XMMatrixOrthographicOffCenterLHProxy, rcx, rdx, r8, r9, r12, r13, r14

													;-----[Set the projection matrix]--------------------------------------
												mov				r14d, r10000									; Set FarZ
												mov				r13d, r1										; Set NearZ
												mov				r12d, r2000									; Set ViewTop
												xorps				xmm3, xmm3
												subss				xmm3, r2000									; Set ViewBottom
												movss				xmm2, r2000									; Set ViewRight
												xorps				xmm1, xmm1
												subss				xmm1, r2000									; Set ViewLeft
												lea				rcx, mProjSun								; Set undocumented mOut
												;WinCall			XMMatrixOrthographicOffCenterLHProxy, rcx, rdx, r8, r9, r12, r13, r14
												
												;-----[Set the projection matrix]--------------------------------------
												;
												; mProj = XMMatrixPerspectiveFovLH( 0.4f*3.14f, Width/Height, 1.0f, 1000.0f);
													
												movss				xmm0, client_rect.right							; Get the client area width
												cvtdq2ps			xmm0, xmm0										; Convert value to float
												movss				xmm1, client_rect.bottom						; Get the client area height
												cvtdq2ps			xmm1, xmm1										; Convert value to float
												divps				xmm0, xmm1										; Set width / height
												movss				aspect_ratio, xmm0								; Store width / height

												xor				r12, r12										; Zero R12
												mov				r12d, r100000									; Set FarZ
												movss				xmm3, r1										; Set NearZ
												movss				xmm2, aspect_ratio								; Set AspectRatio
												movss				xmm1, p4pi										; Set FovAngleY
												lea				rcx, mProjSun										; Set undocumented mOut
												WinCall			XMMatrixPerspectiveFovLHProxy, rcx, rdx, r8, r9, r12
												
												
												;-----[Calculate inverse of projection matrix]--------------------------
												;
												; cbPerObj.WVP = XMMatrixTranspose(WVP);

												lea				rdx, mProj										; Set M1
												lea				rcx, mProjInverse								; Set mOut
												WinCall			XMMatrixInverseProxy, rcx, rdx					; Transpose image to target

												;-----[Create the rasterizer state]------------------------------------
												;
												; d3d11Device->CreateRasterizerState(&rasterizerDesc, &rasterizerState);

												lea				r8, rasterizerState								; Set *pRasterizerState
												lea				rdx, rasterizerDesc								; Set *pRasterizerDesc
												mov				rcx, D3D11Device								; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D11Device_CreateRasterizerState, rcx, rdx, r8  ; Create the rasterizer state

												;-----[Create the rasterizer state]------------------------------------
												;
												; d3d11Device->CreateRasterizerState(&rasterizerDesc, &rasterizerState);

												lea				r8, shadowMapRasterizerState								; Set *pRasterizerState
												lea				rdx, shadowMapRasterizerDesc								; Set *pRasterizerDesc
												mov				rcx, D3D11Device								; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the interface pointer
												WinCall			ID3D11Device_CreateRasterizerState, rcx, rdx, r8  ; Create the rasterizer state

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align				qword											; Set qword alignment
SetupDirectX_Exit:								Restore_Registers													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

												ret																; Return to caller

SetupDirectX									endp																; End function



;-----------------------------------------------------------------------------------------------------------------------
;																												-
; SetupMainWindow																								-
;																												-
;-----------------------------------------------------------------------------------------------------------------------
;																												-
; In:  <No Parameters>																							-
;																												-
; This function registers the window class MainWindowClass, creates the main window as a top level window of that  	-
; class, and returns the new window handle in RAX.  RAX is returned as -1 if the function fails.						-
;																												-
;-----------------------------------------------------------------------------------------------------------------------

SetupMainWindow								proc																; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

												local				holder:qword									;

;------[Save incoming registers]----------------------------------------------------------------------------------------

												Save_Registers													; Save incoming registers

												;-----[Register the window class]--------------------------------------
												;
												; The industry has fallen into a pattern of assigning values to the
												; WndClassEx structure dynamically through code.  This is a complete
												; waste when it comes to any value that is known at runtime.  In this
												; app that amounts to all values except 3.  Only those are assigned
												; here; the rest are hard-coded in the structures.asm file.

												;-----[Get the hInstance value for this app

												xor				rcx, rcx										; Set lpModuleName
												WinCall			GetModuleHandle, rcx							; Get this module handle in RAX
												mov				wnd_hInst, rax									; Set the hInstance value

												;-----[Get the standard cursor handle]---------------------------------

												xor				r9, r9											; Zero cxDesired
												mov				r8, image_cursor								; Set uType
												mov				rdx, ocr_normal								; Set lpszName
												xor				rcx, rcx										; Zero hInstance
												WinCall			LoadImage, rcx, rdx, r8, r9, 0, fu_load   		; Load the standard cursor handle
												mov				wnd_hCursor, rax								; Set the cursor handle

												;-----[Get the small icon handle for this app]-------------------------

												mov				r9, 16											; Set cxDesired
												mov				r8, image_icon									; Set uType
												lea				rdx, i16_name									; Set lpszName
												mov				rcx, wnd_hInst									; Set hInstance

												WinCall			LoadImage, rcx, rdx, r8, r9, 16, 0				; Load the small icon handle
												mov				wnd_hIconSmall, rax								; Save the small icon handle

												;-----[Register the window class]--------------------------------------

												lea				rcx, wnd										; Set lpwcx
												WinCall			RegisterClassEx, rcx							; Register the window class

												;-----[Setup initial adjust rectangle]---------------------------------
												;
												; A 300 x 300 client area is going to be created.  The window has to be
												; properly sized such that a 300 x 300 client area is created with the
												; passed window size.  window_rect is initialized to 0, 0, 300, 300 and
												; passed to AdjustWindowRect, which adjusts the RECT structure to the
												; overall window size.  Since they both start at 0, .left and .top will
												; be negative after this call.  Subtracting .left from .right and set-
												; ting .left to 0 maintains the proper width but sets .left to 0.  Do
												; the same for height and window_rect is at 0, 0 for the proper width
												; and height, allowing the .right and .bottom fields to be used
												; directly as the final window width and height.

												mov				window_rect.right, client_width					; Set the initial right edge
												mov				window_rect.bottom, client_height				; Set the initial bottom edge

												;-----[Get window rect for 300 x 300 client]---------------------------

												xor				r8, r8											; Set bMenu
												mov				rdx, main_style								; Set dwStyle
												lea				rcx, window_rect								; Set lprc
												WinCall			AdjustWindowRect, rcx, rdx, r8					; Execute call

												;-----[Zero base the window rectangle]---------------------------------
												;
												; This allows .right and .bottom to be used directly as width and
												; height.

												mov				eax, window_rect.left							; Get the left edge
												sub				window_rect.right, eax							; Adjust the right edge
												mov				window_rect.left, 0								; Zero the left edge
												mov				eax, window_rect.top							; Get the top edge
												sub				window_rect.bottom, eax							; Adjust the bottom edge
												mov				window_rect.top, 0								; Zero the top edge

												;-----[Create the main window]-----------------------------------------

												mov				r14, wnd_hInst									; Set hInstance

												xor				r9, r9											; Set fWinIni
												lea				r8, work_rect									; Set pvParam
												xor				rdx, rdx										; Set uiParam
												mov				rcx, spi_getworkarea							; Set uiAction
												WinCall			SystemParametersInfo, rcx, rdx, r8, r9			; Get the monitor work area

												xor				r13, r13										; Zero R13
												mov				r13d, window_rect.bottom						; Get the window height

												xor				r12, r12										; Zero R12
												mov				r12d, window_rect.right							; Get the window width

												xor				rbx, rbx										; Zero RBX
												mov				ebx, work_rect.right							; Get the work area width
												sub				ebx, window_rect.right							; Subtract the window width
												shr				rbx, 1											; Cut in half for x = center

												xor				r15, r15										; Zero R15
												mov				r15d, work_rect.bottom							; Get the work area height
												sub				r15d, window_rect.bottom						; Subtract the window height
												shr				r15, 1											; Cut in half for y = center

												mov				r9, main_style
												lea				r8, main_winname								; Set lpWindowName
												lea				rdx, main_classname								; Set lpClassName
												xor				rcx, rcx										; Set dwExStyle
												WinCall			CreateWindowEx, rcx, rdx, r8, r9, rbx, r15, r12, r13, 0, 0, r14, 0

												;-----[Display the window]---------------------------------------------

												mov				r15, rax										; Sae the return value
												mov				rdx, sw_show									; Set nCmdShow
												mov				rcx, rax										; Set hWnd
												WinCall			ShowWindow, rcx, rdx							; Display the window
												mov				rax, r15										; Reset the return value

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align				qword											; Set qword alignment
SetupMainWindow_Exit:							Restore_Registers													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

												ret																; Return to caller

SetupMainWindow								endp																; End function



;-----------------------------------------------------------------------------------------------------------------------
;																												-
; Shutdown																										-
;																												-
;-----------------------------------------------------------------------------------------------------------------------
;																												-
; In:  <No Parameters>																							-
;																												-
; This function closes out everything that was opened including DirectX, Windows stuff, all of it.					-
;																												-
;-----------------------------------------------------------------------------------------------------------------------

Shutdown										proc																; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

												local				holder:qword									;

;------[Save incoming registers]----------------------------------------------------------------------------------------

												Save_Registers													; Save incoming registers

												;------[Release the swap chain]----------------------------------------
												;
												; SwapChain->Release();

												mov				rcx, swapChain									; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			IDXGISwapChain_Release							; Execute call

												;------[Release the device]--------------------------------------------
												;
												; d3d11Device->Release();

												mov				rcx, d3d11Device								; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Device_Release							; Execute call

												;------[Release the device context]------------------------------------
												;
												; d3d11DevCon->Release();

												mov				rcx, d3d11DevCon								; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11DeviceContext_Release						; Execute call

												;------[Release the render target view]--------------------------------
												;
												; renderTargetView->Release();

												mov				rcx, renderTargetView							; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11RenderTargetView_Release					; Execute call

												
												;------[Release the instance buffer]-------------------------------------
												;
												; TriangleInstanceBuffer->Release();

												mov				rcx, beeInstanceBuffer					; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call
												
												mov				rcx, team2BeeInstanceBuffer					; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call

												;------[Release the vertex shader]-------------------------------------
												;
												; VS->Release();

												mov				rcx, VS										; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11VertexShader_Release						; Execute call

												;------[Release the pixel shader]--------------------------------------
												;
												; PS->Release();

												mov				rcx, PS										; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11PixelShader_Release						; Execute call

												;------[Release the vertex shader buffer]------------------------------
												;
												; VS_Buffer->Release();

												mov				rcx, VS_Buffer									; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call

												;------[Release the pixel shader buffer]-------------------------------
												;
												; PS_Buffer->Release();

												mov				rcx, PS_Buffer									; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call

												;------[Release the layout]--------------------------------------------
												;
												; vertLayout->Release();

												mov				rcx, vertLayoutCars								; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11InputLayout_Release						; Execute call
												
												;------[Release the layout]--------------------------------------------
												;
												; vertLayout->Release();

												mov				rcx, vertLayoutPoints								; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11InputLayout_Release						; Execute call
												
												;------[Release the layout]--------------------------------------------
												;
												; vertLayout->Release();

												mov				rcx, vertLayoutQuads								; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11InputLayout_Release						; Execute call
												
												;------[Release the layout]--------------------------------------------
												;
												; vertLayout->Release();

												mov				rcx, vertLayoutFont								; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11InputLayout_Release						; Execute call
												
												
												;------[Release the depth stencil view]--------------------------------
												;
												; depthStencilView->Release();

												mov				rcx, depthStencilView							; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11DepthStencilView_Release					; Execute call

												;------[Release the depth stencil buffer]------------------------------
												;
												; depthStencilBuffer->Release();

												mov				rcx, depthStencilBuffer							; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call

												;------[Release the constant buffer]-----------------------------------
												;
												; cbPerObjectBuffer->Release();

												mov				rcx, cbPerObjectBuffer							; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call

												;------[Release the constant buffer]-----------------------------------
												;
												; cbPerObjectBuffer->Release();

												mov				rcx, cbCameraBuffer							; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call
												
												;------[Release the constant buffer]-----------------------------------
												;
												; cbPerObjectBuffer->Release();

												mov				rcx, cbMouseBuffer							; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call

												;------[Release the constant buffer]-----------------------------------
												;
												; cbPerObjectBuffer->Release();

												mov				rcx, cbDirectionalLightBuffer					; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11Buffer_Release							; Execute call

																								
												;------[Release the rasterizer state]----------------------------------
												;
												; rasterizerState->Release();

												mov				rcx, rasterizerState							; Get the interface pointer
												mov				rbx, [ rcx ]									; Set the vTable pointer
												WinCall			ID3D11RasterizerState_Release					; Execute call

												;------[Unregister the main window class]------------------------------

												mov				rdx, wnd_hInst									; Set hInstance
												lea				rcx, main_classname								; Set lpClassName
												WinCall			UnregisterClass, rcx, rdx						; Execute call

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align				qword											; Set qword alignment
Shutdown_Exit:								Restore_Registers													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

												ret																; Return to caller

Shutdown										endp																; End function



;-----------------------------------------------------------------------------------------------------------------------
;																												-
; UpdateScene																									-
;																												-
;-----------------------------------------------------------------------------------------------------------------------
;																												-
; In:  <No Parameters>																							-
;																												-
; This function updates the scene geometry and performes any other per-render updates required.						-
;																												-
;-----------------------------------------------------------------------------------------------------------------------

UpdateScene									proc																; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

												local				holder:qword									;

;------[Save incoming registers]----------------------------------------------------------------------------------------

												Save_Registers													; Save incoming registers



												;------[Update delta time---------------------------------------------------------------
												lea			rcx, timeStamp
												WinCall 		QueryPerformanceCounter, rcx ;

												lea			rcx, timeFrequency
												WinCall 		QueryPerformanceFrequency, rcx

												mov rax, timeStamp.QuadPart
												
												sub rax, lastFrameTimeTicks
												mov rbx, 1000000
												mul rbx; convert to microseconds *before* dividing by ticks per second to avoid precision errors
												div timeFrequency.QuadPart
												mov rbx, timeStamp.QuadPart
												mov lastFrameTimeTicks, rbx; save current time as last time for next frame

												mov deltaTimeMicros, rax  

												; int 3
												cmp rax, 50000 ;Hack to avoid overflowing the time variable due to very large delta time first frame
												jl Delta_In_Range
												;set delta to 16 milliseconds
												mov rax, 16000
												mov deltaTimeMicros, rax 

Delta_In_Range:								
												cvtsi2ss xmm3, rax
												
												xorps xmm4, xmm4
												movss xmm2, lightPitch
												movss xmm5, pi
												movss xmm6, lightRotationDirection
												comiss xmm2, xmm5
												jbe light_check_below_zero
												;int 3
												movss xmm2, xmm5
												movss xmm7, rn1
												mulss xmm6, xmm7
												jmp light_in_range
light_check_below_zero:							xorps xmm5, xmm5
												comiss xmm2, xmm5
												jae light_in_range
												movss xmm2, xmm5
												movss xmm7, rn1
												mulss xmm6, xmm7
light_in_range:									addss xmm4, xmm3
												movss xmm1, lightRotationPerMsVertical
												mulss xmm1, xmm4
												mulss xmm1, xmm6
												movss lightRotationDirection, xmm6
												addss xmm1, xmm2
												movss lightPitch, xmm1  
												xorps xmm2, xmm2 	

												movss xmm1, sunAngle
												movss xmm2, sunAnglePerS
												
												movss xmm5, xmm3
												movss xmm6, r0000001
												mulss xmm5, xmm6 ;delta time in seconds

												mulss xmm2, xmm5
												addss xmm1, xmm2 

												movss xmm4, tau
												comiss xmm1, xmm4

												jb sun_angle_below_tau

												xorps xmm1, xmm1

sun_angle_below_tau:							movss sunAngle, xmm1

												movss xmm6, xmm1

												movss xmm0, xmm1				;set y
												WinCall sinf, rcx					;result is returned in xmm0
												movss xmm8, sunOrbitRadius
												movss xmm9, xmm8
												mulss xmm9, xmm0

												movss xmm0, xmm6				;set x
												WinCall cosf, rcx					;result is returned in xmm0
												movss xmm5, xmm8
												mulss xmm5, xmm0

												movss real4 ptr [lightPosition], xmm5								;set x position
												movss real4 ptr [lightPosition + sizeof(real4)], xmm9				;set y position

												movaps xmm3, xmmword ptr [lightPosition]
												movaps xmmword ptr [vPoints], xmm3



												;update light direction
Calc_Light_Rotation:							;-----[Get the rotation matrix for the light rotation]--------------------------------------
												;
												; mRotation = XMMatrixRotationRollPitchYawProxy(pitch, yaw, roll);   	
												;int 3
												xorps xmm3, xmm3 ; set roll to 0										
												;xmm2 holds yaw
												;xmm1 holds pitch
												lea				rcx, mRotation									; Set undocumented mOut
												WinCall			XMMatrixRotationRollPitchYawProxy, rcx, rdx, r8, r9

												lea rcx, mRotation
												movaps xmm2, xmmword ptr [lightForward]

												TransformVectorFromRegister
												
												;skip this and just use static position now
												movaps xmm2, xmmword ptr [lightPosition]
												;xorps xmm0, xmm0
												movaps xmm0, xmm2
												
												NormalizeVectorFromRegister

												movaps xmmword ptr [lightDirection], xmm0 	

												xor rcx, rcx ;this will be set to 1 if camera has moved
												xor rax, rax
												mov al, wButtonPressed
												cmp al, 0
												je Up_Button_Check_End
												;int 3
												movaps xmm4, xmmword ptr [camPosition]
												mov rbx, deltaTimeMicros
												cvtsi2ss xmm1, rbx
												shufps xmm1, xmm1, 0h
												movss xmm2, cameraMovePerMicroSecond
												movss xmm0, real4 ptr [camPosition + sizeof(real4)] ;camera y position
												mulss xmm2, xmm0
												mulss xmm2, r1p5
												shufps xmm2, xmm2, 0h
												mulps xmm1, xmm2 ; length to move
												movaps xmm5, xmm1
												movaps xmm0, xmmword ptr [camLookTo]
												shufps xmm0, xmm0, 0ech
												NormalizeVectorFromRegister
												mulps xmm0, xmm5
												addps xmm4, xmm0
												movaps xmmword ptr [camPosition], xmm4
												mov rcx, 1
												

Up_Button_Check_End:
												xor rax, rax
												mov al, sButtonPressed
												cmp al, 0
												je Down_Button_Check_End
												movaps xmm4, xmmword ptr [camPosition]
												mov rbx, deltaTimeMicros
												cvtsi2ss xmm1, rbx
												shufps xmm1, xmm1, 0h
												movss xmm2, cameraMovePerMicroSecond
												movss xmm0, real4 ptr [camPosition + sizeof(real4)] ;camera y position
												mulss xmm2, xmm0
												mulss xmm2, r1p5
												shufps xmm2, xmm2, 0h
												mulps xmm1, xmm2 ; length to move
												movaps xmm5, xmm1
												movaps xmm0, xmmword ptr [camLookTo]
												shufps xmm0, xmm0, 0ech
												NormalizeVectorFromRegister
												mulps xmm0, xmm5
												subps xmm4, xmm0
												movaps xmmword ptr [camPosition], xmm4
												mov rcx, 1

Down_Button_Check_End:

												xor rax, rax
												mov al, aButtonPressed
												cmp al, 0
												je Left_Button_Check_End
												movaps xmm4, xmmword ptr [camPosition]
												mov rbx, deltaTimeMicros
												cvtsi2ss xmm1, rbx
												shufps xmm1, xmm1, 0h
												movss xmm2, cameraMovePerMicroSecond
												movss xmm0, real4 ptr [camPosition + sizeof(real4)] ;camera y position
												mulss xmm2, xmm0
												mulss xmm2, r1p5
												shufps xmm2, xmm2, 0h
												mulps xmm1, xmm2 ; length to move
												movaps xmm5, xmm1
												movaps xmm0, xmmword ptr [camLookTo]
												shufps xmm0, xmm0, 0ech
												NormalizeVectorFromRegister
												;int 3
												xorps xmm1, xmm1
												subps xmm1, xmm0
												shufps xmm0, xmm1, 0c6h

												mulps xmm0, xmm5
												subps xmm4, xmm0
												movaps xmmword ptr [camPosition], xmm4
												mov rcx, 1

Left_Button_Check_End:
												xor rax, rax
												mov al, dButtonPressed
												cmp al, 0
												je Right_Button_Check_End
												movaps xmm4, xmmword ptr [camPosition]
												mov rbx, deltaTimeMicros
												cvtsi2ss xmm1, rbx
												shufps xmm1, xmm1, 0h
												movss xmm2, cameraMovePerMicroSecond
												movss xmm0, real4 ptr [camPosition + sizeof(real4)] ;camera y position
												mulss xmm2, xmm0
												mulss xmm2, r1p5
												shufps xmm2, xmm2, 0h
												mulps xmm1, xmm2 ; length to move
												movaps xmm5, xmm1
												movaps xmm0, xmmword ptr [camLookTo]
												shufps xmm0, xmm0, 0ech
												NormalizeVectorFromRegister
												;int 3
												xorps xmm1, xmm1
												subps xmm1, xmm0
												shufps xmm0, xmm1, 0c6h

												mulps xmm0, xmm5
												addps xmm4, xmm0
												movaps xmmword ptr [camPosition], xmm4
												mov rcx, 1

Right_Button_Check_End:												
												xor rax, rax
												movss xmm1, mouseWheelSteps
												xorps xmm0, xmm0
												movss mouseWheelSteps, xmm0
												movss xmm2, cameraZoomPerStep
												mulss xmm2, xmm1
												movss xmm0, zoomToApply
												addss xmm0, xmm2
												movss zoomToApply, xmm0


												movss xmm1, xmm0
												Abs

												mov rbx, deltaTimeMicros
												cvtsi2ss xmm2, rbx
												mulss xmm2, r0000001 ;time in seconds

												movss xmm4, zoomPerSecond
												mulss xmm4, xmm2
												comiss xmm0, xmm4 ;if the value is smaller than what we move per frame skip the update
												jb Skip_Zoom_Update

												mulss xmm0, r4 ;this will be our zoom per second so it will always take 1/4 = 0.25 seconds to complete the zoom

												maxss xmm0, xmm4
												mulss xmm2, xmm0 ;zoomchange this frame

												movss xmm0, real4 ptr [camPosition + 4 * 1]
												movss xmm3, real4 ptr [camTarget + 4 * 1]
												mov rcx, 1
												
												comiss xmm1, r0
												ja Zoom_Positive
												mulss xmm2, rn1
Zoom_Positive:									subss xmm1, xmm2
												movss zoomToApply, xmm1
												subss xmm0, xmm2
												subss xmm3, xmm2
												movss real4 ptr [camPosition + 4*1], xmm0
												movss real4 ptr [camTarget + 4*1], xmm3
Skip_Zoom_Update:												
												
												
												mov cameraMovedThisFrame, rcx												
												

												;------[Calc mouse move diff this frame]----------------------------------------

												
												movss xmm2, mousePosX  
												movss xmm0, mousePosXLastFrame
												subss xmm2, xmm0
												movss xmm4, screenWidth
												divss xmm2, xmm4
												movss mouseDiffXThisFrame, xmm2

												movss xmm1, mousePosY
												movss xmm0, mousePosYLastFrame
												subss xmm1, xmm0
												movss xmm4, screenHeight
												divss xmm1, xmm4
												movss mouseDiffYThisFrame, xmm1


												;------[Mouse input handling]----------------------------------------

												xor rcx, rcx
												cmp middleMousePressed, 1
												jne Check_Yaw_Keys

												;Calculate the rotation factor for this frame
												movss xmm3, cameraRotationPerScreenUnitHorizontal
											
												movss xmm2, mouseDiffXThisFrame
												mulss xmm2, xmm3 ;mouseXDiff * rotation factor  	
												jmp Set_Cam_Yaw

Check_Yaw_Keys:									cmp rightButtonPressed, 1
												je Cam_Yaw_Right_Key
												cmp leftButtonPressed, 1
												je Cam_Yaw_Left_Key
												movss xmm2, camYaw
												jmp Check_Pitch_Keys


Cam_Yaw_Left_Key:								
												;int 3
												mov rbx, deltaTimeMicros
												cvtsi2ss xmm2, rbx
												xorps xmm1, xmm1
												subss xmm1, xmm2
												jmp Cam_Yaw_Calc

Cam_Yaw_Right_Key:								mov rbx, deltaTimeMicros
												cvtsi2ss xmm1, rbx
Cam_Yaw_Calc:									movss xmm2, cameraRotationPerMsHorizontal
												mulss xmm2, xmm1
												xorps xmm1, xmm1


Set_Cam_Yaw:									movss xmm0, camYaw
												addss xmm2, xmm0
												;int 3
												movss camYaw, xmm2
												or cameraMovedThisFrame, 1 ;camera has been rotated if we end up here
											


Check_Cam_Pitch_Mouse:							cmp middleMousePressed, 1
												jne Check_Pitch_Keys												

												movss xmm3, cameraRotationPerScreenUnitVertical
												movss xmm1, mouseDiffYThisFrame
												mulss xmm1, xmm3 ;mouseYDiff * rotation factor
												mov rcx, 1												
												jmp Cam_Check_Pitch 

Check_Pitch_Keys:								cmp upButtonPressed, 1
												je Cam_Pitch_Up_Key
												cmp downButtonPressed, 1
												je Cam_Pitch_Down_Key
												movss xmm1, camPitch
												jmp Calc_Rotation   

												
Cam_Pitch_Down_Key:								mov rbx, deltaTimeMicros
												cvtsi2ss xmm4, rbx
												jmp Cam_Pitch_Calc

Cam_Pitch_Up_Key:								mov rbx, deltaTimeMicros
												cvtsi2ss xmm3, rbx
												xorps xmm4, xmm4
												subss xmm4, xmm3
Cam_Pitch_Calc:									movss xmm1, cameraRotationPerMsVertical
												mulss xmm1, xmm4  	
												mov rcx, 1											

						
												;int 3
Cam_Check_Pitch:								movss xmm0, camPitch
												addss xmm0, xmm1
												movss xmm4, p5pi
												movss xmm1, xmm0
												comiss xmm0, xmm4
												ja Revert_Pitch
												xorps xmm4, xmm4
												comiss xmm0, xmm4
												ja Write_Camera_Pitch

Revert_Pitch:									movss xmm1, camPitch
												jmp Calc_Rotation
Write_Camera_Pitch:																		
												;int 3
												movss camPitch, xmm1

												or cameraMovedThisFrame, rcx ;camera has been rotated if we end up here
												


Calc_Rotation:								;-----[Get the rotation matrix for the camera x rotation]--------------------------------------
												;
												; mRotation = XMMatrixRotationRollPitchYawProxy(pitch, yaw, roll);   	
												;int 3
												xorps xmm3, xmm3 ; set roll to 0										
												;xmm2 holds yaw
												;xmm1 holds pitch
												lea				rcx, mRotation									; Set undocumented mOut
												WinCall			XMMatrixRotationRollPitchYawProxy, rcx, rdx, r8, r9

												lea rcx, mRotation
												movaps xmm2, xmmword ptr [camForward]

												TransformVectorFromRegister

												movaps xmmword ptr [camLookTo], xmm2  

												;-----[Get the rotation matrix for the camera x rotation]--------------------------------------
												;
												; mRotation = XMMatrixRotationRollPitchYawProxy(pitch, yaw, roll);   	
												;int 3
												xorps xmm3, xmm3 ; set roll to 0										
												xorps xmm2, xmm2
												movss xmm1, camPitch  
												lea				rcx, mRotation									; Set undocumented mOut
												WinCall			XMMatrixRotationRollPitchYawProxy, rcx, rdx, r8, r9

												lea rcx, mRotation
												movaps xmm2, xmmword ptr [camForward]

												TransformVectorFromRegister

												movaps xmmword ptr [camLookToSkyQuad], xmm2	

Mouse_Middle_End:
												
												cmp cameraMovedThisFrame, 1
												jne Camera_Not_Moved

												;LocalCall FindMouseTerrainIntersection

Camera_Not_Moved:								
												

												
												cmp rButtonDownThisFrame, 1
												jne R_Not_Pressed
												LocalCall ClearBees

R_Not_Pressed:
												
												;Update bee stuff
												mov rcx, 0
												LocalCall SpawnBees
												;Update bee stuff
												mov rcx, 1
												LocalCall SpawnBees

												mov rcx, 0
												LocalCall UpdateMovements
												mov rcx, 1
												LocalCall UpdateMovements

												mov rcx, 0
												LocalCall UpdatePositions
												mov rcx, 1
												LocalCall UpdatePositions		

												mov rcx, 0
												mov rdx, 1
												LocalCall GetNewEnemyTargets
												mov rcx, 1
												mov rdx, 0
												LocalCall GetNewEnemyTargets													

												mov rcx, 0
												mov rdx, 1
												LocalCall Attack
												mov rcx, 1
												mov rdx, 0
												LocalCall Attack	
													
												mov rcx, 0								
												LocalCall CheckCollisionsWall
												mov rcx, 1
												LocalCall CheckCollisionsWall		

												mov rcx, 0
												LocalCall UpdateDead
												mov rcx, 1
												LocalCall UpdateDead						

												mov eax, team1AliveBees
												add eax, team1DeadBees
												mov team1NumberOfBees, eax

												mov eax, team2AliveBees
												add eax, team2DeadBees
												mov team2NumberOfBees, eax
												
												;Measure fps
												inc fpsMeasureFrameCount
												mov rax, fpsMeasureTimePassed
												add rax, deltaTimeMicros
												mov fpsMeasureTimePassed, rax
												cmp rax, 1000000 ;1 second in microseconds
												jl Skip_FPS_Update

												mov fpsMeasureTimePassed, 0 ;reset time passed
												cvtsi2ss xmm0, rax ;time passed
												mov ebx, fpsMeasureFrameCount
												cvtsi2ss xmm1, ebx ;frame count
												divss xmm1, xmm0 ;frames per microsecond
												movss xmm0, xmm1
												mulss xmm0, r1000000
												mov fpsMeasureFrameCount, 0 ;reset frame count

												movss xmm1, textNextCharPosition   	
												movss xmm2, r08n
												lea rcx, fps_str
												mov rdx, 24
												LocalCall AddReal4VariableToDebugText

												mov eax, team1NumberOfBees
												add eax, team2NumberOfBees

												cvtsi2ss xmm0, eax

												movss xmm1, textNextCharPosition   	
												movss xmm2, r05n
												lea rcx, number_of_bees_string
												mov rdx, textLength
												LocalCall AddReal4VariableToDebugText


Skip_FPS_Update:
												;------[Update mousePosLastFrame]----------------------------------------------------
												movss xmm0, mousePosX
												movss mousePosXLastFrame, xmm0
												movss xmm1, mousePosY
												movss mousePosYLastFrame, xmm1

												;------[Clear last frame pressed buttons]--------------------------------------------
												mov rButtonPressedLastFrame, 0
												mov rButtonDownThisFrame, 0

												xorps xmm0, xmm0
												movss mouseDiffXThisFrameRaw, xmm0
												movss mouseDiffYThisFrameRaw, xmm0


UpdateScene_End:

;------[Restore incoming registers]-------------------------------------------------------------------------------------

												align				qword											; Set qword alignment
												Restore_Registers													; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

												ret																; Return to caller

UpdateScene									endp																; End function

