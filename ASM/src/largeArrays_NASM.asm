
section .bss 																; Declare bss segment

max_number_of_bees  							equ 				15000 ;Per team

												align   			16
global team1BeeMovementArray, team2BeeMovementArray, beeTransformDataArray, cbPerInst


align 32
beeTransformDataArray   						resb 		24 * max_number_of_bees 
team1BeeMovementArray   						resb 		24 * max_number_of_bees
team2BeeMovementArray   						resb 		24 * max_number_of_bees
cbPerInst   									resd 		3 * max_number_of_bees
