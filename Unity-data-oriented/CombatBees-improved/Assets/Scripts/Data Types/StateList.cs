using System.Collections.Generic;

public class StateList
{
    private List<int> ids;
    private Dictionary<int, int> idToIndex;

    public StateList(int initialCapacity)
    {
        ids = new List<int>(initialCapacity);
        idToIndex = new Dictionary<int, int>(initialCapacity);
    }

    public void Add(int value)
    {
        int index = ids.Count;
        ids.Add(value);
        idToIndex.Add(value, index);
    }

    public void Remove(int value)
    {
        bool found = idToIndex.TryGetValue(value, out int index);
        if (found)
        {
            int copiedId = ids[^1];
            ids[index] = copiedId;
            ids.RemoveAt(ids.Count - 1);
            idToIndex[copiedId] = index;
            idToIndex.Remove(value);
        }        
    }
    public bool Contains(int value)
    {
        return idToIndex.ContainsKey(value);
    }

    public void Clear()
    {
        ids.Clear();
        idToIndex.Clear();
    }

    public void Sort()
    {
        ids.Sort();

        //TODO need to update dictionary when we are sorting!!!!!
    }

    public int this[int i] => ids[i];

    public int Count => ids.Count;
}