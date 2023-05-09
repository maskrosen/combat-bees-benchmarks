#ifndef BIT_MASK_UTILS_H
#define BIT_MASK_UTILS_H

inline bool IsBitSet32(__int32 mask, int i)
{
	return (mask & (1 << i)) != 0;
}

inline void SetBitTrue32(__int32* mask, int i)
{
	*mask |= (1 << i);
}

inline void SetBitFalse32(__int32* mask, int i)
{
	*mask &= ~(1U << i);
}

// Set a bit in a mask represented by an array of 64 bit ints to true
inline void SetBitTrue(__int64* mask, int i)
{
	int index = i / 64;
	__int64 bitIndex = i % 64;
	mask[index] |= (1ULL << bitIndex);
}

// Set a bit in a mask represented by an array of 64 bit ints to false
inline void SetBitFalse(__int64* mask, int i)
{
	int index = i / 64;
	__int64 bitIndex = i % 64;
	mask[index] &= ~(1ULL << bitIndex);
}

inline int GetBitValue(__int64* mask, int i)
{
	int index = i / 64;
	__int64 bitIndex = i % 64;
	return (mask[index] >> bitIndex) & 1LL;
}

inline void SetBitValue(__int64* mask, int i, int value)
{
	int index = i / 64;
	__int64 bitIndex = i % 64;
	mask[index] = (mask[index] & ~(1ULL << bitIndex)) | (value << bitIndex);
}

inline void CopyBitValue(__int64* mask, int sourceIndex, int destIndex)
{
	int sourceValue = GetBitValue(mask, sourceIndex);
	SetBitValue(mask, destIndex, sourceValue);
}

inline bool IsBitSet(__int64* mask, int i)
{
	int index = i / 64;
	__int64 bitIndex = i % 64;
	return (mask[index] & (1ULL << bitIndex)) != 0;
}

#endif