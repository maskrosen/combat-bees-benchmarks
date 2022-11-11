
											align			qword
retVal										qword			?												;
RtlExitUserThread							qword			007F9298h										;

;-----------------------------------------------------------------------------------------------------------------------
;                                                              													-
; Static variable declarations.                                													-
;                                                              													-
;-----------------------------------------------------------------------------------------------------------------------

;-----[A]---------------------------------------------------------------------------------------------------------------

angleIncrement								real4			0.0005											; Per-render rotation angle increment
aspect_ratio								dword			?												; Width / height
angle										real4			0.0
activeNumberOfNodes							dword			0

;-----[B]---------------------------------------------------------------------------------------------------------------

BackBuffer									qword			?												; ID3D11Texture2D
blendState									qword			?
blendStateAdditive							qword			?
bitmapWidth									dword			?		
bitmapHeight								byte				?		

;-----[C]---------------------------------------------------------------------------------------------------------------

carsPaused									byte				0

cbPerObjectBuffer							qword			?												; ID3D11Buffer
cbCameraBuffer								qword			?												; ID3D11Buffer
cbMouseBuffer								qword			?												; ID3D11Buffer
cbSkyBoxBuffer								qword			?												; ID3D11Buffer
cbDirectionalLightBuffer					qword			?												; ID3D11Buffer
cbWaterBuffer								qword			?												; ID3D11Buffer
cbPerInstanceBuffer							qword			?												; ID3D11Buffer
cameraMovePerMicroSecond					real4			0.0000007
cameraZoomPerStep							real4			24.0
cosResult									real4			0.0
cameraMovedThisFrame						qword			0
cameraRotationPerScreenUnitHorizontal		real4			4.0
cameraRotationPerScreenUnitVertical			real4			2.0
cameraRotationPerMsHorizontal				real4			0.000003
cameraRotationPerMsVertical					real4			0.0000015
camPitch									real4			0.0
camYaw										real4			0.0

blueBeeVertexBuffer							qword			?
yellowBeeVertexBuffer						qword			?
carSpeed									real4			30.0											;m/s
carAcceleration								real4			8.0											;m/s2
carDeceleration								real4			42.5											;m/s2
carGridCheckDistance						real4			5.0
carWidthHalf								real4			0.8
carLengthToFrontPoint						real4			1.15
carLength									real4			4.5
carLengthHalf								real4			2.25
carLengthQuarter							real4			1.125

circleColorR								real4			0.0									
circleColorG								real4			0.0
circleColorB								real4			0.0
circleColorA								real4			0.0
circleMaterial								dword			0												; 0 default, 1 asphalt, 2 lane marker
circleNodeIndex								qword			0
circleRadius								real4			0.0
circleSides									qword			0

blueBeeIndexBuffer							qword			?
yellowBeeIndexBuffer						qword			?

currentPathDepthTemp						dword			0

;-----[D]---------------------------------------------------------------------------------------------------------------

d3d11DevCon									qword			?												; ID3D11DeviceContext
d3d11Device									qword			?												; ID3D11Device
depthStencilBuffer							qword			?												; ID3D11Texture2D
depthStencilState							qword			?
depthStencilOffState						qword			?
depthStencilView							qword			?												; ID3D11Buffer
debugMouseX									real4			940.0
debugMouseY									real4			95.0

debugPointInstanceBuffer					qword			?												; ID3D11Buffer

;-----[E]---------------------------------------------------------------------------------------------------------------

entryNodeCount								dword			0
erasingRoad									byte				0

;-----[F]---------------------------------------------------------------------------------------------------------------
filePtr										qword			?
findPathBackwards							byte				0
firstRoadPointX								real4			0.0
firstRoadPointY								real4			0.0
firstNodeIndex								qword			-1
firstNodeNew								byte				0

fontTexture									qword			?
fontTextureResouceView						qword				 ?
fontTextureVertexBuffer						qword			?

fwpr_index									qword			?												; FixWinDbg internal index

fpsMeasureTimePassed						qword			?
fpsMeasureFrameCount						dword			?

;-----[G]---------------------------------------------------------------------------------------------------------------

g_XMIdentityR3								dword			3 dup ( 000000000h ), 03F800000h				; Floating point XMM vlaue 0:0:0:1
g_XMInfinity								dword			4 dup ( 07F800000h )							; Floating point XMM value infinity
g_XMMask3									dword			3 dup ( 0FFFFFFFFh ), 0						; Floating point XMM mask 3
g_XMMaskW									dword			3 dup ( 000000000h ), 0FFFFFFFFh				; Floating point XMM mask W
g_XMNegativeOne								dword			4 dup ( 0BF800000h )							; Floating point XMM value -1


gsTerrain									qword			?												; ID3D11VertexShader
gsBillboard									qword			?												; ID3D11VertexShader
GS_Buffer									qword			?												; ID3D10Blob: vertex shader

gridSize									real4			2.0
groundSizeHalf								real4			3.0
groundR1									real4			0.306
groundG1									real4			0.443
groundB1									real4			0.1
groundR2									real4			0.725
groundG2									real4			0.478
groundB2									real4			0.341
groundR3									real4			0.349
groundG3									real4			0.349
groundB3									real4			0.349
groundBrown									real4			120.0
groundGrey									real4			127.5
;-----[H]---------------------------------------------------------------------------------------------------------------

hInstance									qword			?												; This app hInstance
hoveredNode									qword			-1

;-----[I]---------------------------------------------------------------------------------------------------------------

inactiveCarsCount							qword			max_number_of_bees			

intersectionDistance						real4			0.0

in_shutdown									qword			0												; Flag: app shutdown in process

;-----[J]---------------------------------------------------------------------------------------------------------------

;-----[K]---------------------------------------------------------------------------------------------------------------

;-----[L]---------------------------------------------------------------------------------------------------------------

laneMarkerColorR							real4			0.0 ;0.471
laneMarkerColorG							real4			0.0 ;0.459
laneMarkerColorB							real4			0.0 ;0.557
laneMarkerDistance							real4			3.0
laneMarkerEndX								real4			0.0
laneMarkerEndY								real4			0.0
laneMarkerLength							real4			2.5
laneMarkerStartX							real4			0.0
laneMarkerStartY							real4			0.0
laneMarkerVX								real4			0.0
laneMarkerVY								real4			0.0
laneMarkerNextVX							real4			0.0
laneMarkerNextVY							real4			0.0
laneMarkerWidthHalf							real4			0.05

lightPitch									real4			0.0
lightRotationPerMsVertical					real4			0.00000005
lightRotationDirection						real4			1.0

lineVertexBuffer							qword			?
;-----[M]---------------------------------------------------------------------------------------------------------------

Main_Handle									qword			?												; Main window handle

mousePosX									real4			0.0
mousePosY									real4			0.0
mousePosXLastFrame							real4			0.0
mousePosYLastFrame							real4			0.0
mouseDiffXThisFrame							real4			0.0
mouseDiffYThisFrame							real4			0.0
mouseDiffXThisFrameRaw						real4			0.0
mouseDiffYThisFrameRaw						real4			0.0
mouseDownPosWorldX							real4			0.0
mouseDownPosWorldY							real4			0.0
mouseDownPosWorldZ							real4			0.0
mouseButtonsDown							qword			0	
mouseWheelDeltaConst						real4			120.0											
mouseWheelSteps								real4			0.0		
middleMousePressed							byte				0								

;-----[N]---------------------------------------------------------------------------------------------------------------

numElements									qword			( layout_E - layout ) / sizeof ( d3d11_input_element_desc ) ; Number of elements in layout array
numElementsCars								qword			( layout_cars_E - layout_cars ) / sizeof ( d3d11_input_element_desc ) ; Number of elements in layout array
numElementsFont								qword			( layout_font_E - layout_font ) / sizeof ( d3d11_input_element_desc ) ; Number of elements in layout array
numElementsPoints							qword			( layout_points_E - layout_points ) / sizeof ( d3d11_input_element_desc ) ; Number of elements in layout array
numElementsQuads							qword			( layout_quads_E - layout_quads ) / sizeof ( d3d11_input_element_desc ) ; Number of elements in layout array



;-----[O]---------------------------------------------------------------------------------------------------------------

offset_										qword			0												; Offset into vertex buffer
offset_1									qword			0												; Offset into vertex buffer

;-----[P]---------------------------------------------------------------------------------------------------------------

p3pi										real4			0.9424777960769379715387930150					;
p4pi										real4			1.2566370614359172953850573533					;
p5pi										real4			1.5707963267948966192313216916					;
pi											real4			3.1415926535897932384626433833					;
pointVertexBuffer							qword			?
selectedVertexBuffer						qword			?
ps											qword			?												; ID3D11PixelShader
psLines										qword			?												; ID3D11PixelShader
psPoints									qword			?												; ID3D11PixelShader
psRoad										qword			?												; ID3D11PixelShader
psQuads										qword			?												; ID3D11PixelShader
psTexture2d									qword			?												; ID3D11PixelShader
psPreview									qword			?												; ID3D11PixelShader
PS_Buffer									qword			?												; ID3D10Blob: pixel shader


;-----[Q]---------------------------------------------------------------------------------------------------------------

quadVertexBuffer							qword			?
;-----[R]---------------------------------------------------------------------------------------------------------------

r0n											real4			-0.0											; Fixed float -0.0
r0											real4			0.0											; Fixed float 0.0
r0000001									real4			0.000001										; Fixed float 0.0000001
r1											real4			1.0											; Fixed float 1.0
r1n											real4			-1.0											; Fixed float 1.0
r1p1										real4			1.1											; Fixed float 1.1
r1p2										real4			1.2											; Fixed float 1.2
r1p5										real4			1.5											; Fixed float 1.5
r1p6										real4			1.6											; Fixed float 1.6
rn1											real4			-1.0											; Fixed float 1.0
r2											real4			2.0											; Fixed float 2.0
r2n											real4			-2.0											; Fixed float 2.0
r3											real4			3.0											; Fixed float 3.0
r4											real4			4.0											; Fixed float 4.0
r001										real4			0.01											; Fixed float 0.1
r0001										real4			0.001											; Fixed float 0.1
r01											real4			0.1											; Fixed float 0.1
r02											real4			0.2											; Fixed float 0.1
r02n										real4			-0.2											; Fixed float 0.1
r025										real4			0.25											; Fixed float 0.1
r03											real4			0.3											; Fixed float 0.3
r035										real4			0.35											; Fixed float 0.3
r05											real4			0.5											; Fixed float 0.5
r05n										real4			-0.5											; Fixed float 0.5
r0647										real4			0.647											; Fixed float 0.647
r0753										real4			0.753											; Fixed float 0.753
r06											real4			0.6											; Fixed float 0.6
r07											real4			0.7											; Fixed float 0.7
r08											real4			0.8											; Fixed float 0.8
r08n										real4			-0.8											; Fixed float 0.8
r09											real4			0.9											; Fixed float 0.9
r099										real4			0.99											; Fixed float 0.99
rTen										real4			10.0											; Fixed float 10.0
rFive										real4			5.0											; Fixed float 5.0
rSix										real4			6.0											; Fixed float 6.0
rSeven										real4			7.0											; Fixed float 7.0
r20											real4			20.0												; Fixed float 20.0
r20n										real4			-20.0												; Fixed float 20.0
r24p5										real4			24.5												; Fixed float 25.0
r25											real4			25.0												; Fixed float 25.0
r30											real4			30.0												; Fixed float 30.0
r35											real4			35.0												; Fixed float 30.0
r40											real4			40.0												; Fixed float 40.0
r45											real4			45.0												; Fixed float 45.0
r48											real4			48.0												; Fixed float 45.0
r49											real4			49.0												; Fixed float 45.0
r49p2										real4			49.2												; Fixed float 45.0
r49p3										real4			49.3												; Fixed float 45.0
r49p5										real4			49.5												; Fixed float 45.0
r51											real4			51.0												; Fixed float 51.0
r60											real4			60.0												; Fixed float 60.0
r70											real4			70.0												; Fixed float 70.0
r120										real4			120.0												; Fixed float 120.0
r500										real4			500.0											; Fixed float 500.0
r512										real4			512.0											; Fixed float 500.0
r500n										real4			-500.0											; Fixed float 500.0
r640										real4			640.0											; Fixed float 500.0
r640n										real4			-640.0											; Fixed float 500.0
r600										real4			600.0											; Fixed float 500.0
r600n										real4			-600.0											; Fixed float 500.0
r360										real4			360.0											; Fixed float 500.0
r1000										real4			1000.0											; Fixed float 1000.0
r1300										real4			1300.0											; Fixed float 1000.0
r1000n										real4			-1000.0											; Fixed float 1000.0
r2000										real4			2000.0											; Fixed float 1000.0
r2000n										real4			-2000.0											; Fixed float 1000.0
r3000										real4			3000.0											; Fixed float 1000.0
r100										real4			100.0											; Fixed float 100.0
r100n										real4			-100.0											; Fixed float 100.0
r150n										real4			-150.0											; Fixed float 100.0
r10000										real4			10000.0										; Fixed float 10000.0
r100000										real4			100000.0										; Fixed float 100000.0
r1000000									real4			1000000.0										; Fixed float 1000000.0
r200										real4			200.0											; Fixed float 255.0
r200n										real4			-200.0											; Fixed float 255.0
r400										real4			400.0											; Fixed float 255.0
r400n										real4			-400.0											; Fixed float 255.0
r255										real4			255.0											; Fixed float 255.0
r2550										real4			2550.0											; Fixed float 2550.0
r25500										real4			25500.0										; Fixed float 25500.0
rasterizerState								qword			?												; ID3D11RasterizerState
randSeed									dword			1234
renderTargetView							qword			?												; ID3D11RenderTargetView
rectangleWidthHalf							real4			0.0											; Used by create rectangle vertices function
rectangleColorR								real4			0.0											; Used by create rectangle vertices function
rectangleColorG								real4			0.0											; Used by create rectangle vertices function
rectangleColorB								real4			0.0											; Used by create rectangle vertices function
rectangleColorA								real4			0.0											; Used by create rectangle vertices function
rectangleMaterial							dword			0												; 0 default, 1 asphalt, 2 lane marker
rectanglePosOuter1Y							real4			0.0
rectanglePosOuter2Y							real4			0.0
rectanglePos1Y								real4			0.0
rectanglePos2Y								real4			0.0
rectangleProgress							real4			0.0
rectangleLength								real4			0.0
rotationAngle								real4			0.0											; Current rotation angle
rotationLimit								real4			6.26											; Limit of rotation in radians

;-----[S]---------------------------------------------------------------------------------------------------------------

saveBufferQword								qword			0
saveVersion									qword			0


screenHeight								real4			1080.0
screenWidth									real4			1920.0
screenHeightInv								real4			?
screenWidthInv								real4			?
shadowMapRasterizerState					qword			?												; ID3D11RasterizerState
shadowMapDepthView							qword			?
shadowMapRenderTexture						qword			?
shadowMapComparisonSampler					qword			?
shadowMapResouceView						qword			?
shaderResourceViewNullPtr					qword			0
skyQuadLowR									real4			0.569
skyQuadLowG									real4			0.843
skyQuadLowB									real4			0.949
skyQuadHighR								real4			0.016
skyQuadHighG								real4			0.616
skyQuadHighB								real4			0.851
sinResult									real4			0.0

squareIndexBuffer							qword			?
squareVertexBuffer							qword			?

stride										qword			sizeof ( vertex )								; Vertex buffer stride
strideFont									qword			sizeof ( font_vertex )								; Vertex buffer stride
stridePoints								qword			sizeof ( point_vertex )								; Vertex buffer stride
strideQuads									qword			sizeof ( quad_vertex )								; Vertex buffer stride
stride1										qword			sizeof ( meshInstanceData )						; Vertex buffer stride
sunAngle									real4			0.6
sunAnglePerS								real4			0.000
sunOrbitRadius								real4			200000.0
sunWidth									real4			100.0
swapChain									qword			?												; IDXGISwapChain


;-----[T]---------------------------------------------------------------------------------------------------------------

tau											real4			6.2831853071795864769252867666
testTexture									qword			?
testTextureResouceView						qword				 ?
testTextureVertexBuffer						qword			?
textureSampler								qword			?
textLength									qword			0
textNextCharPosition						real4			0.0												;Xpos of the next character


timeToNextCarSpawn							real4			3.0

beeInstanceBuffer							qword			?												; ID3D11Buffer
team2BeeInstanceBuffer						qword			?												; ID3D11Buffer

;-----[U]---------------------------------------------------------------------------------------------------------------

;-----[V]---------------------------------------------------------------------------------------------------------------

vBufferPtr									qword			?												; VS blob code buffer pointer
vBufferSize									qword			?												; VS blob code buffer size
vertLayout									qword			?												; ID3D11InputLayout
vertLayoutCars								qword			?												; ID3D11InputLayout
vertLayoutFont								qword			?												; ID3D11InputLayout
vertLayoutLines								qword			?												; ID3D11InputLayout
vertLayoutPoints							qword			?												; ID3D11InputLayout
vertLayoutQuads								qword			?												; ID3D11InputLayout
vs											qword			?												; ID3D11VertexShader
vsCars										qword			?												; ID3D11VertexShader
vsMalls										qword			?												; ID3D11VertexShader
vsMallPreview								qword			?												; ID3D11VertexShader
vsLines										qword			?												; ID3D11VertexShader
vsDebugSquares								qword			?												; ID3D11VertexShader
vsFont										qword			?												; ID3D11VertexShader
vsPoints									qword			?												; ID3D11VertexShader
vsQuads										qword			?												; ID3D11VertexShader
vsPreview									qword			?												; ID3D11VertexShader
vsTerrain									qword			?												; ID3D11VertexShader
vsTexture2d									qword			?												; ID3D11VertexShader
vsTrafficLight								qword			?												; ID3D11VertexShader
vsWater										qword			?												; ID3D11VertexShader
VS_Buffer									qword			?												; ID3D10Blob: vertex shader

;-----[W]---------------------------------------------------------------------------------------------------------------

worldSideHalf								real4			600.0

worldBoundBoxXRight							real4			700.0
worldBoundBoxXLeft							real4			-700.0
worldBoundBoxYBottom						real4			0.0
worldBoundBoxYTop							real4			700.0
worldBoundBoxZBack							real4			700.0
worldBoundBoxZFront							real4			-700.0

;-----[X]---------------------------------------------------------------------------------------------------------------

;-----[Y]---------------------------------------------------------------------------------------------------------------

;-----[Z]---------------------------------------------------------------------------------------------------------------
zoomToApply									real4				0.0
zoomPerSecond								real4				40.0


;------My Stuff---------------------------------------------------------------------------------------------------------


rightButtonPressed							byte				0
leftButtonPressed							byte				0
upButtonPressed								byte				0
downButtonPressed							byte				0
eButtonPressed								byte				0
spaceButtonPressedLastFrame					byte				0
mButtonPressed								byte				0
nButtonPressed								byte				0
nButtonPressedLastFrame						byte				0
wButtonPressed								byte				0
aButtonPressed								byte				0
sButtonPressed								byte				0
dButtonPressed								byte				0
pButtonPressed								byte				0
rButtonDown									byte				0
rButtonDownThisFrame						byte				0 ;if the r button down event came this frame 
pButtonPressedLastFrame						byte				0
rButtonPressedLastFrame						byte				0
eButtonPressedLastFrame						byte				0
tButtonPressedLastFrame						byte				0
mButtonPressedLastFrame						byte				0
deleteButtonPressedLastFrame				byte				0

peroidPressedLastFrame						byte				0
minusPressedLastFrame						byte				0
commaPressedLastFrame						byte				0

nodeCounter									dword			    0


squarePositionX								real4		    	-0.5		
squarePositionY								real4		    	-1.0	
squareSize									real4		    	0.09	

translationX								dword				48	; 12 * 4
translationY								dword				52	; 13 * 4

scaleX										dword				0	; 0 * 4
scaleY										dword				20	; 5 * 4

lastX1										real4				-0.5
lastY1										real4				-0.5

lastX2										real4				0.5
lastY2										real4				-0.5

squareVertexSize							real4				0.5

v1X											real4				-0.5				
v1Y											real4				-0.5	

v2X											real4				0.5				
v2Y											real4				-0.5	

v3X											real4				0.5				
v3Y											real4				0.5	

v4X											real4				-0.5				
v4Y											real4				-0.5	

v5X											real4				0.5				
v5Y											real4				0.5	

v6X											real4				-0.5				
v6Y											real4				0.5		
integerVariable								dword				0		
currentSquareIndex							dword				0
deltaTimeMicros								qword				0
lastFrameTimeTicks							qword				0
dropIntervalTime							dword				800
timeToDrop									dword				800

lockTime									dword				500
timeToLock									dword				500

debugFrameTime								dword				1000
debugTimeToRecordFrames						dword				1000


;Debug stuff
framesSinceLastSecond						dword			0
fpsLastSecond								dword			0


