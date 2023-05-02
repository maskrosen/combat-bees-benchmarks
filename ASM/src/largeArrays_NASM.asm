
section .bss 																; Declare bss segment

max_number_of_bees  							equ 				50000 ;Per team

												align   			16
global team1BeeMovementArray, team2BeeMovementArray, beeTransformDataArray, cbPerInst, team1BeeTargetsArray, team2BeeTargetsArray, team1BeeSizesArray, team2BeeSizesArray, team1BeeRotationArray, team2BeeRotationArray, team1DeadTimers, team2DeadTimers


align 32
beeTransformDataArray   						resb 		28 * max_number_of_bees 
team1BeeMovementArray   						resb 		24 * max_number_of_bees
team2BeeMovementArray   						resb 		24 * max_number_of_bees
team1BeeTargetsArray							resb		4 * max_number_of_bees
team2BeeTargetsArray							resb		4 * max_number_of_bees
team1BeeSizesArray								resb		4 * max_number_of_bees
team2BeeSizesArray								resb		4 * max_number_of_bees
team1BeeRotationArray							resb		12 * max_number_of_bees
team2BeeRotationArray							resb		12 * max_number_of_bees
team1DeadTimers									resb		4 * max_number_of_bees
team2DeadTimers									resb		4 * max_number_of_bees
cbPerInst   									resd 		3 * max_number_of_bees
