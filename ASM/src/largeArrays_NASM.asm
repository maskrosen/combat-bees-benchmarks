
section .bss                                                                 ; Declare bss segment

max_number_of_bees                              equ                 20000

                                                align               16
global beeTransformDataArray, cbPerInst


align 32
beeTransformDataArray                           resb         32 * max_number_of_bees 
cbPerInst                                       resd         3 * max_number_of_bees
