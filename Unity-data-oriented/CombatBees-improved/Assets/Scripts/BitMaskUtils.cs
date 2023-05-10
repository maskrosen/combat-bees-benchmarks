

public static unsafe class BitMaskUtils
{

	public static bool IsBitSet32(int mask, int i)
	{
		return (mask & (1 << i)) != 0;
	}

	public static void SetBitTrue32(int* mask, int i)
	{
		*mask |= (1 << i);
	}

	public static void SetBitFalse32(int* mask, int i)
	{
		*mask &= ~(1 << i);
	}

	// Set a bit in a mask represented by an array of 64 bit ints to true
	public static void SetBitTrue(ulong* mask, int i)
	{
		int index = i / 64;
		int bitIndex = i % 64;
		mask[index] |= ((ulong)1 << bitIndex);
	}

	// Set a bit in a mask represented by an array of 64 bit ints to false
	public static void SetBitFalse(ulong* mask, int i)
	{
		int index = i / 64;
		int bitIndex = i % 64;
		mask[index] &= ~((ulong)1 << bitIndex);
	}

	public static int GetBitValue(ulong* mask, int i)
	{
		int index = i / 64;
		int bitIndex = i % 64;
		return (int)(mask[index] >> bitIndex) & 1;
	}

	public static void SetBitValue(ulong* mask, int i, int value)
	{
		int index = i / 64;
		int bitIndex = i % 64;
		mask[index] = (mask[index] & ~((ulong)1 << bitIndex)) | ((ulong)value << bitIndex);
	}

	public static void CopyBitValue(ulong* mask, int sourceIndex, int destIndex)
	{
		int sourceValue = GetBitValue(mask, sourceIndex);
		SetBitValue(mask, destIndex, sourceValue);
	}

	public static bool IsBitSet(ulong* mask, int i)
	{
		int index = i / 64;
		int bitIndex = i % 64;
		return (mask[index] & ((ulong)1 << bitIndex)) != 0;
	}

}
