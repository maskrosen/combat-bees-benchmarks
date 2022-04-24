
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
								

align 				16
team1SpawnPos					real4				-40.0, 0.0, 0.0, 0.0
team2SpawnPos					real4				40.0, 0.0, 0.0, 0.0