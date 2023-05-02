yellowBee										 label 					 vertex
real4 				0.0
real4 				-1.0
real4 				2.0
real4 				1.0
real4 				0.9098039
real4 				1.0
real4 				0.1803922
real4 				1.0
real4 				1.0
real4 				0.0
real4 				0.0
real4 				0.0

real4 				0.0
real4 				-1.0
real4 				-2.0
real4 				1.0
real4 				0.9098039
real4 				1.0
real4 				0.1803922
real4 				1.0
real4 				1.0
real4 				0.0
real4 				0.0
real4 				0.0

real4 				0.0
real4 				1.0
real4 				-2.0
real4 				1.0
real4 				0.9098039
real4 				1.0
real4 				0.1803922
real4 				1.0
real4 				1.0
real4 				0.0
real4 				0.0
real4 				0.0

real4 				0.0
real4 				1.0
real4 				2.0
real4 				1.0
real4 				0.9098039
real4 				1.0
real4 				0.1803922
real4 				1.0
real4 				1.0
real4 				0.0
real4 				0.0
real4 				0.0

yellowBeeIndices									 word 0
											 word 1
											 word 2
											 word 1
											 word 3
											 word 0
											 word 1
											 word 2
											 word 3
yellowBeeIndexBufferData 						 label 				 d3d11_subresource_data
											 qword 				 yellowBeeIndices
											 qword 				 ?
											 qword 				 ?
yellowBeeIndexBufferDataE 						 label 				 byte
yellowBeeIndexCount 				 equ 					 9
yellowBeeVertexCount 				 equ 					 4
yellowBeeIndexBufferDesc 				 label 					 d3d11_buffer_desc
 				 dword 					 sizeof(word) * yellowBeeIndexCount
 				 dword 					 D3D11_USAGE_DEFAULT
 				 dword 					 D3D11_BIND_INDEX_BUFFER
 				 dword 					 0
 				 dword 					 0
 				 dword 					 0
