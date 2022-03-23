public static class SpawnBeesSystem
{
    public static void Run()
    {
        int team1BeeCount = Data.Team1AliveBees.Count + Data.Team1DeadBees.Count;
        int beesToSpawnTeam1 = Data.beeStartCount/2 - team1BeeCount;
        if(beesToSpawnTeam1 > 0)
        {
            Utils.SpawnBees(beesToSpawnTeam1, 0);
        }

        int team2BeeCount = Data.Team2AliveBees.Count + Data.Team2DeadBees.Count;
        int beesToSpawnTeam2 = Data.beeStartCount/2 - team2BeeCount;
        if(beesToSpawnTeam2 > 0)
        {
            Utils.SpawnBees(beesToSpawnTeam2, 1);
        }
    }


}