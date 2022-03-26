public static class SortListsSystem
{
    public static void Run()
    {
        Data.Team1AliveBees.Sort();
        Data.Team1DeadBees.Sort();
        Data.Team1InactiveBees.Sort();
        Data.Team1HasEnemyTarget.Sort();
        Data.Team2AliveBees.Sort();
        Data.Team2DeadBees.Sort();
        Data.Team2InactiveBees.Sort();
        Data.Team2HasEnemyTarget.Sort();
    }
}