public static class SpawnBeesSystem
{
    public static void Run()
    {
        int team1BeeCount = Data.AliveCount[0] + Data.DeadCount[0];
        int beesToSpawnTeam1 = Data.beeStartCount/2 - team1BeeCount;
        if(beesToSpawnTeam1 > 0)
        {
            Utils.SpawnBees(beesToSpawnTeam1, 0);
        }

        int team2BeeCount = Data.AliveCount[1] + Data.DeadCount[1];
        int beesToSpawnTeam2 = Data.beeStartCount/2 - team2BeeCount;
        if(beesToSpawnTeam2 > 0)
        {
            Utils.SpawnBees(beesToSpawnTeam2, 1);
        }
    }


}