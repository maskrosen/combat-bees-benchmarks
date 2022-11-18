
flight_jitter					equ 				200  	
team_attraction					equ					5
team_repulsion					equ					4
attackForce						equ					500
chaseForce						equ					50


align               qword

team1NumberOfBees				dword               0
team2NumberOfBees               dword               0

team1AliveBees					dword				0
team2AliveBees					dword				0

team1DeadBees					dword				0
team2DeadBees					dword				0

beeMovements					qword team1BeeMovementArray, team2BeeMovementArray
beeTargets						qword team1BeeTargetsArray, team2BeeTargetsArray
beeSizes						qword team1BeeSizesArray, team2BeeSizesArray

team1HasTargets					qword				max_number_of_bits dup (0)
team2HasTargets					qword				max_number_of_bits dup (0)

team1NoTargets					qword				max_number_of_bits dup (0FFFFFFFFFFFFFFFFh)
team2NoTargets					qword				max_number_of_bits dup (0FFFFFFFFFFFFFFFFh)

teamHasTargets					qword	team1HasTargets, team2HasTargets
teamNoTargets					qword	team1NoTargets, team2NoTargets

align 				16
team1SpawnPos					real4				-40.0, 0.0, 0.0, 0.0
team2SpawnPos					real4				40.0, 0.0, 0.0, 0.0
fieldSizeHalf					real4				100.0, 20.0, 30.0, 0.0

attackDistanceSqr				real4				16.0
hitDistanceSqr					real4				0.25

beeMinSize						real4				0.25
beeMaxSize						real4				0.5
