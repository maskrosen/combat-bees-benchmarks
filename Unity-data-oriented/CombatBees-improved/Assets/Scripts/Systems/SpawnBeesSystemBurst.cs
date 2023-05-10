public static class SpawnBeesSystemBurst
{
    public static void Run()
    {
        int team1BeeCount = DataBurst.AliveCount[0] + DataBurst.DeadCount[0];
        int beesToSpawnTeam1 = DataBurst.beeStartCount/2 - team1BeeCount;
        if(beesToSpawnTeam1 > 0)
        {
            UtilsBurst.SpawnBees(beesToSpawnTeam1, 0); 
        }

        int team2BeeCount = DataBurst.AliveCount[1] + DataBurst.DeadCount[1];
        int beesToSpawnTeam2 = DataBurst.beeStartCount/2 - team2BeeCount;
        if(beesToSpawnTeam2 > 0)
        {
            UtilsBurst.SpawnBees(beesToSpawnTeam2, 1);
        }
    }


}