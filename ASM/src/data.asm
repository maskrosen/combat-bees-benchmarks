
flight_jitter					equ 				200  	
team_attraction					equ					5
team_repulsion					equ					4



align               qword

team1NumberOfBees				dword               0
team2NumberOfBees               dword               0

team1AliveBees					dword				0
team2AliveBees					dword				0

team1DeadBees					dword				0
team2DeadBees					dword				0

beeMovements					qword team1BeeMovementArray, team2BeeMovementArray
beeTargets						qword team1BeeTargetsArray, team2BeeTargetsArray

team1HasTargets					qword				max_number_of_bits dup (0)
team2HasTargets					qword				max_number_of_bits dup (0)

team1NoTargets					qword				max_number_of_bits dup (0FFFFFFFFFFFFFFFFh)
team2NoTargets					qword				max_number_of_bits dup (0FFFFFFFFFFFFFFFFh)

teamHasTargets					qword	team1HasTargets, team2HasTargets
teamNoTargets					qword	team1NoTargets, team2NoTargets

align 				16
team1SpawnPos					real4				-40.0, 0.0, 0.0, 0.0
team2SpawnPos					real4				40.0, 0.0, 0.0, 0.0