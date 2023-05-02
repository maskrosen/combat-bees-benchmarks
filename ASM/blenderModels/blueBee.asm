blueBee										 label 					 vertex
real4 				0.0
real4 				-1.0
real4 				-2.0
real4 				1.0
real4 				0.2156863
real4 				0.1647059
real4 				1.0
real4 				1.0
real4 				1.0
real4 				0.0
real4 				0.0
real4 				0.0

real4 				0.0
real4 				1.0
real4 				2.0
real4 				1.0
real4 				0.2156863
real4 				0.1647059
real4 				1.0
real4 				1.0
real4 				1.0
real4 				0.0
real4 				0.0
real4 				0.0

real4 				0.0
real4 				-1.0
real4 				2.0
real4 				1.0
real4 				0.2156863
real4 				0.1647059
real4 				1.0
real4 				1.0
real4 				1.0
real4 				0.0
real4 				0.0
real4 				0.0

real4 				0.0
real4 				1.0
real4 				-2.0
real4 				1.0
real4 				0.2156863
real4 				0.1647059
real4 				1.0
real4 				1.0
real4 				1.0
real4 				0.0
real4 				0.0
real4 				0.0

blueBeeIndices									 word 0
											 word 1
											 word 2
											 word 0
											 word 1
											 word 2
											 word 0
											 word 3
											 word 1
											 word 0
											 word 3
											 word 1
blueBeeIndexBufferData 						 label 				 d3d11_subresource_data
											 qword 				 blueBeeIndices
											 qword 				 ?
											 qword 				 ?
blueBeeIndexBufferDataE 						 label 				 byte
blueBeeIndexCount 				 equ 					 12
blueBeeVertexCount 				 equ 					 4
blueBeeIndexBufferDesc 				 label 					 d3d11_buffer_desc
 				 dword 					 sizeof(word) * blueBeeIndexCount
 				 dword 					 D3D11_USAGE_DEFAULT
 				 dword 					 D3D11_BIND_INDEX_BUFFER
 				 dword 					 0
 				 dword 					 0
 				 dword 					 0
