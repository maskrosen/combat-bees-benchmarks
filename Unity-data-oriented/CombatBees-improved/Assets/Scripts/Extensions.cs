using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using Unity.Collections;
using Unity.Collections.LowLevel.Unsafe;

public static class Extensions
{

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public static void Clear<T>(this T[] array)
    {
        Array.Clear(array, 0, array.Length);
    }

    public static unsafe void* GetPtr<T>(this NativeArray<T> array) where T : struct
    {
        return NativeArrayUnsafeUtility.GetUnsafePtr(array);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public static void AddAndSort<T>(this List<T> list, T item)
    {
        list.Add(item);
        list.Sort();
    }

}
