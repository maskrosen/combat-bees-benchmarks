square										 label 					 line_vertex
;v1
real4 				0.5
real4 				0.0
real4 				0.5
real4 				1.0
;v1 color
real4 				1.0
real4 				0.0
real4 				0.0
real4 				1.0
;v2
real4 				0.5
real4 				0.0
real4 				-0.5
real4 				1.0
;v2 color
real4 				1.0
real4 				0.0
real4 				0.0
real4 				1.0
;v3
real4 				-0.5
real4 				0.0
real4 				-0.5
real4 				1.0
;v3 color
real4 				1.0
real4 				0.0
real4 				0.0
real4 				1.0
;v4
real4 				-0.5
real4 				0.0
real4 				0.5
real4 				1.0
;v3 color
real4 				1.0
real4 				0.0
real4 				0.0
real4 				1.0

squareIndices								 word 0
											 word 1
											 word 2
											 word 0
											 word 2
											 word 3
										
squareIndexBufferData 						 label 				 d3d11_subresource_data
											 qword 				 squareIndices
											 qword 				 ?
											 qword 				 ?
squareIndexBufferDataE 						 label 				 byte
squareIndexCount 				 equ 					 6
squareVertexCount 				 equ 					 4

squareIndexBufferDesc 					 label 					 d3d11_buffer_desc
 				 dword 					 sizeof(word) * squareIndexCount
 				 dword 					 D3D11_USAGE_DEFAULT
 				 dword 					 D3D11_BIND_INDEX_BUFFER
 				 dword 					 0
 				 dword 					 0
 				 dword 					 0


vertexBufferDataSquare                           label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               square                                                 ; pSysMem
                                                 dword               ?                                                 ; SysMemPitch
                                                 dword               ?                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
vertexBufferDataSquareE                           label               byte                                              ; End marker

vertexBufferDescSquare                            label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( line_vertex ) * squareVertexCount  ; ByteWidth
                                                 dword               D3D11_USAGE_DYNAMIC                               ; Usage
                                                 dword               D3D11_BIND_VERTEX_BUFFER                          ; BindFlags
                                                 dword               D3D11_CPU_ACCESS_WRITE                            ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0 ; sizeof ( vertex )                             ; StructureByteStride 
