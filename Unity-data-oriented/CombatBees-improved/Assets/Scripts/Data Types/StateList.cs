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
        return;
        InsertionSort(ids);
        for (int i = 0; i < ids.Count; i++)
        {
            int id = ids[i];
            idToIndex[id] = i;
        }
    }

    static int InsertionSort(List<int> A)
    {
        int result = 0;
        for (int i = 1; i < A.Count; i++)
        {
            int key = A[i];
            int j = i - 1;

            /* Move elements of A[0..i-1], that are
            greater than key, to one position ahead
            of their current position */
            while (j >= 0 && A[j] > key)
            {
                A[j + 1] = A[j];
                j = j - 1;
            }
            A[j + 1] = key;
        }

        for (int i = 0; i < A.Count; i++)
        {
            result += A[i];
        }
        return result;
    }

    public int this[int i] => ids[i];

    public int Count => ids.Count;
}