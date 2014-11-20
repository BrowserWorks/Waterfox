/*
	File:  CMTime.h
	
	Framework:  CoreMedia
 
    Copyright 2005-2012 Apple Inc. All rights reserved.
 
*/

#ifndef CMTIME_H
#define CMTIME_H

/*!
	@header
	@abstract	API for creating and manipulating CMTime structs.
	@discussion	CMTime structs are non-opaque mutable structs representing times (either timestamps or durations).
	
				A CMTime is represented as a rational number, with a numerator (int64_t value), and a denominator (int32_t timescale).
				A flags field allows various non-numeric values to be stored (+infinity, -infinity, indefinite, invalid).  There is also
				a flag to mark whether or not the time is completely precise, or had to be rounded at some point in its past.
				
				CMTimes contain an epoch number, which is usually set to 0, but can be used to distinguish unrelated
				timelines: for example, it could be incremented each time through a presentation loop,
				to differentiate between time N in loop 0 from time N in loop 1.
				
				CMTimes can be converted to/from immutable CFDictionaries, via CMTimeCopyAsDictionary and
				CMTimeMakeFromDictionary, for use in annotations and various CF containers.
*/

#include <CoreMedia/CMBase.h>
#include <CoreFoundation/CoreFoundation.h>

#ifdef __cplusplus
extern "C" {
#endif

#pragma pack(push, 4)

/*!
	@typedef	CMTimeValue
	@abstract	Numerator of rational CMTime.
*/
typedef int64_t CMTimeValue;

/*!
	@typedef	CMTimeScale
	@abstract	Denominator of rational CMTime.
	@discussion	Timescales must be positive.
*/
typedef int32_t CMTimeScale;
#define kCMTimeMaxTimescale 0x7fffffffL

/*!
	@typedef	CMTimeEpoch
	@abstract	Epoch (eg, loop number) to which a CMTime refers.
*/
typedef int64_t CMTimeEpoch;

/*!
	@enum		CMTimeFlags
	@abstract	Flag bits for a CMTime.
	@constant	kCMTimeFlags_Valid Must be set, or the CMTime is considered invalid.
									Allows simple clearing (eg. with calloc or memset) for initialization
									of arrays of CMTime structs to "invalid". This flag must be set, even
									if other flags are set as well.
	@constant	kCMTimeFlags_HasBeenRounded Set whenever a CMTime value is rounded, or is derived from another rounded CMTime.													
	@constant	kCMTimeFlags_PositiveInfinity Set if the CMTime is +inf.	"Implied value" flag (other struct fields are ignored).													
	@constant	kCMTimeFlags_NegativeInfinity Set if the CMTime is -inf.	"Implied value" flag (other struct fields are ignored).														
	@constant	kCMTimeFlags_Indefinite Set if the CMTime is indefinite/unknown. Example of usage: duration of a live broadcast.
										 "Implied value" flag (other struct fields are ignored).
*/
enum {
	kCMTimeFlags_Valid = 1UL<<0,
	kCMTimeFlags_HasBeenRounded = 1UL<<1,
	kCMTimeFlags_PositiveInfinity = 1UL<<2,
	kCMTimeFlags_NegativeInfinity = 1UL<<3,
	kCMTimeFlags_Indefinite = 1UL<<4,
	kCMTimeFlags_ImpliedValueFlagsMask = kCMTimeFlags_PositiveInfinity | kCMTimeFlags_NegativeInfinity | kCMTimeFlags_Indefinite
};
typedef uint32_t CMTimeFlags;

/*!
	@typedef	CMTime
	@abstract	Rational time value represented as int64/int32.
*/
typedef struct
{
	CMTimeValue	value;		/*! @field value The value of the CMTime. value/timescale = seconds. */
	CMTimeScale	timescale;	/*! @field timescale The timescale of the CMTime. value/timescale = seconds.  */
	CMTimeFlags	flags;		/*! @field flags The flags, eg. kCMTimeFlags_Valid, kCMTimeFlags_PositiveInfinity, etc. */
	CMTimeEpoch	epoch;		/*! @field epoch Differentiates between equal timestamps that are actually different because
												 of looping, multi-item sequencing, etc.  
												 Will be used during comparison: greater epochs happen after lesser ones. 
												 Additions/subtraction is only possible within a single epoch,
												 however, since epoch length may be unknown/variable. */
} CMTime;

/*!
	@function	CMTIME_IS_VALID
    @abstract   Returns whether a CMTime is valid.
    @discussion This is a macro that evaluates to a Boolean result.
    @result     Returns true if the CMTime is valid, false if it is invalid.
*/
#define CMTIME_IS_VALID(time) ((Boolean)(((time).flags & kCMTimeFlags_Valid) != 0))

/*!
	@function	CMTIME_IS_INVALID
    @abstract   Returns whether a CMTime is invalid.
    @discussion This is a macro that evaluates to a Boolean result.
    @result     Returns true if the CMTime is invalid, false if it is valid.
*/
#define CMTIME_IS_INVALID(time) (! CMTIME_IS_VALID(time))

/*!
	@function	CMTIME_IS_POSITIVEINFINITY
    @abstract   Returns whether a CMTime is positive infinity.  Use this instead of (myTime == kCMTimePositiveInfinity),
				since there are many CMTime structs that represent positive infinity.  This is because the non-flags fields are ignored,
				so they can contain anything.
    @discussion This is a macro that evaluates to a Boolean result.
    @result     Returns true if the CMTime is positive infinity, false if it is not.
*/
#define CMTIME_IS_POSITIVE_INFINITY(time) ((Boolean)(CMTIME_IS_VALID(time) && (((time).flags & kCMTimeFlags_PositiveInfinity) != 0)))

/*!
	@function	CMTIME_IS_NEGATIVEINFINITY
    @abstract   Returns whether a CMTime is negative infinity.
    @discussion This is a macro that evaluates to a Boolean result.
    @result     Returns true if the CMTime is negative infinity, false if it is not.
*/
#define CMTIME_IS_NEGATIVE_INFINITY(time) ((Boolean)(CMTIME_IS_VALID(time) && (((time).flags & kCMTimeFlags_NegativeInfinity) != 0)))

/*!
	@function	CMTIME_IS_INDEFINITE
    @abstract   Returns whether a CMTime is indefinite.
    @discussion This is a macro that evaluates to a Boolean result.
    @result     Returns true if the CMTime is indefinite, false if it is not.
*/
#define CMTIME_IS_INDEFINITE(time) ((Boolean)(CMTIME_IS_VALID(time) && (((time).flags & kCMTimeFlags_Indefinite) != 0)))

/*!
	@function	CMTIME_IS_NUMERIC
    @abstract   Returns whether a CMTime is numeric (ie. contains a usable value/timescale/epoch).
    @discussion This is a macro that evaluates to a Boolean result.
    @result     Returns false if the CMTime is invalid, indefinite or +/- infinity.
				Returns true otherwise.
*/
#define CMTIME_IS_NUMERIC(time) ((Boolean)(((time).flags & (kCMTimeFlags_Valid | kCMTimeFlags_ImpliedValueFlagsMask)) == kCMTimeFlags_Valid))

/*!
	@function	CMTIME_HAS_BEEN_ROUNDED
    @abstract   Returns whether a CMTime has been rounded.
    @discussion This is a macro that evaluates to a Boolean result.
    @result     Returns true if the CMTime has been rounded, false if it is completely accurate.
*/
#define CMTIME_HAS_BEEN_ROUNDED(time) ((Boolean)(CMTIME_IS_NUMERIC(time) && (((time).flags & kCMTimeFlags_HasBeenRounded) != 0)))


CM_EXPORT const CMTime kCMTimeInvalid			/*! @constant kCMTimeInvalid
													Use this constant to initialize an invalid CMTime.
													All fields are 0, so you can calloc or fill with 0's to make lots of them.
													Do not test against this using (time == kCMTimeInvalid), there are many
													CMTimes other than this that are also invalid.
													Use !CMTIME_IS_VALID(time) instead. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CMTime kCMTimeIndefinite		/*! @constant kCMTimeIndefinite
													Use this constant to initialize an indefinite CMTime (eg. duration of a live
													broadcast).  Do not test against this using (time == kCMTimeIndefinite),
													there are many CMTimes other than this that are also indefinite.
													Use CMTIME_IS_INDEFINITE(time) instead. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CMTime kCMTimePositiveInfinity	/*! @constant kCMTimePositiveInfinity 
													Use this constant to initialize a CMTime to +infinity.
													Do not test against this using (time == kCMTimePositiveInfinity),
													there are many CMTimes other than this that are also +infinity.
													Use CMTIME_IS_POSITIVEINFINITY(time) instead. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CMTime kCMTimeNegativeInfinity	/*! @constant kCMTimeNegativeInfinity 
													Use this constant to initialize a CMTime to -infinity.
													Do not test against this using (time == kCMTimeNegativeInfinity),
													there are many CMTimes other than this that are also -infinity.
													Use CMTIME_IS_NEGATIVEINFINITY(time) instead. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CMTime kCMTimeZero				/*! @constant kCMTimeZero 
													Use this constant to initialize a CMTime to 0.
													Do not test against this using (time == kCMTimeZero),
													there are many CMTimes other than this that are also 0.
													Use CMTimeCompare(time, kCMTimeZero) instead. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeMake
	@abstract	Make a valid CMTime with value and timescale.  Epoch is implied to be 0.
	@result		The resulting CMTime.
*/
CM_EXPORT 
CMTime CMTimeMake(
				int64_t value,		/*! @param value		Initializes the value field of the resulting CMTime. */
				int32_t timescale)	/*! @param timescale	Initializes the timescale field of the resulting CMTime. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeMakeWithEpoch
	@abstract	Make a valid CMTime with value, scale and epoch.
	@result		The resulting CMTime.
*/
CM_EXPORT 
CMTime CMTimeMakeWithEpoch(
				int64_t value,		/*! @param value Initializes the value field of the resulting CMTime. */
				int32_t timescale,	/*! @param timescale Initializes the scale field of the resulting CMTime. */
				int64_t epoch)		/*! @param epoch Initializes the epoch field of the resulting CMTime. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
				

/*!
	@function	CMTimeMakeWithSeconds
	@abstract	Make a CMTime from a Float64 number of seconds, and a preferred timescale.
	@discussion	The epoch of the result will be zero.  If preferredTimeScale is <= 0, the result
				will be an invalid CMTime.  If the preferred timescale will cause an overflow, the
				timescale will be halved repeatedly until the overflow goes away, or the timescale
				is 1.  If it still overflows at that point, the result will be +/- infinity.  The
				kCMTimeFlags_HasBeenRounded flag will be set if the result, when converted back to
				seconds, is not exactly equal to the original seconds value.
	@result		The resulting CMTime.
*/
CM_EXPORT 
CMTime CMTimeMakeWithSeconds(
				Float64 seconds,
				int32_t preferredTimeScale)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeGetSeconds
	@abstract	Converts a CMTime to seconds.
	@discussion	If the CMTime is invalid or indefinite, NAN is returned.  If the CMTime is infinite, +/- __inf()
				is returned.  If the CMTime is numeric, epoch is ignored, and time.value / time.timescale is
				returned.  The division is done in Float64, so the fraction is not lost in the returned result.
	@result		The resulting Float64 number of seconds.
*/
CM_EXPORT 
Float64 CMTimeGetSeconds(
				CMTime time)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@enum CMTimeRoundingMethod
	@abstract Rounding method to use when computing time.value during timescale conversions.
	@constant	kCMTimeRoundingMethod_RoundHalfAwayFromZero	Round towards zero if abs(fraction) is < 0.5,
																away from 0 if abs(fraction) is >= 0.5.
	@constant	kCMTimeRoundingMethod_Default					Synonym for kCMTimeRoundingMethod_RoundHalfAwayFromZero.
	@constant	kCMTimeRoundingMethod_RoundTowardZero			Round towards zero if fraction is != 0.
	@constant	kCMTimeRoundingMethod_RoundAwayFromZero		Round away from zero if abs(fraction) is > 0.
	@constant	kCMTimeRoundingMethod_QuickTime				Use kCMTimeRoundingMethod_RoundTowardZero if converting
																from larger to smaller scale (ie. from more precision to
																less precision), but use
																kCMTimeRoundingMethod_RoundAwayFromZero if converting
																from smaller to larger scale (ie. from less precision to
																more precision). Also, never round a negative number down
																to 0; always return the smallest magnitude negative
																CMTime in this case (-1/newTimescale).
	@constant	kCMTimeRoundingMethod_RoundTowardPositiveInfinity	Round towards +inf if fraction is != 0.
	@constant	kCMTimeRoundingMethod_RoundTowardNegativeInfinity	Round towards -inf if fraction is != 0.
*/
enum {
	kCMTimeRoundingMethod_RoundHalfAwayFromZero = 1,
	kCMTimeRoundingMethod_RoundTowardZero = 2,
	kCMTimeRoundingMethod_RoundAwayFromZero = 3,
	kCMTimeRoundingMethod_QuickTime = 4,
	kCMTimeRoundingMethod_RoundTowardPositiveInfinity = 5,
	kCMTimeRoundingMethod_RoundTowardNegativeInfinity = 6,
	
	kCMTimeRoundingMethod_Default = kCMTimeRoundingMethod_RoundHalfAwayFromZero
};
typedef uint32_t CMTimeRoundingMethod;

/*!
	@function	CMTimeConvertScale
	@abstract	Returns a new CMTime containing the source CMTime converted to a new timescale (rounding as requested).
	@discussion If the value needs to be rounded, the kCMTimeFlags_HasBeenRounded flag will be set.
				See definition of CMTimeRoundingMethod for a discussion of the various rounding methods available. If
				the source time is non-numeric (ie. infinite, indefinite, invalid), the result will be similarly non-numeric.
	@result		The converted result CMTime.
*/
CM_EXPORT 
CMTime CMTimeConvertScale(
				CMTime time,					/*! @param time		Source CMTime. */
				int32_t newTimescale,			/*! @param newTimescale	The requested timescale for the converted result CMTime. */
				CMTimeRoundingMethod method)	/*! @param method	The requested rounding method. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeAdd
    @abstract   Returns the sum of two CMTimes.
    @discussion If the operands both have the same timescale, the timescale of the result will be the same as
				the operands' timescale.  If the operands have different timescales, the timescale of the result
				will be the least common multiple of the operands' timescales.  If that LCM timescale is 
				greater than kCMTimeMaxTimescale, the result timescale will be kCMTimeMaxTimescale,
				and default rounding will be applied when converting the result to this timescale.
				
				If the result value overflows, the result timescale will be repeatedly halved until the result
				value no longer overflows.  Again, default rounding will be applied when converting the
				result to this timescale.  If the result value still overflows when timescale == 1, then the
				result will be either positive or negative infinity, depending on the direction of the
				overflow.
				
				If any rounding occurs for any reason, the result's kCMTimeFlags_HasBeenRounded flag will be
				set.  This flag will also be set if either of the operands has kCMTimeFlags_HasBeenRounded set.
				
				If either of the operands is invalid, the result will be invalid.
				
				If the operands are valid, but just one operand is infinite, the result will be similarly
				infinite. If the operands are valid, and both are infinite, the results will be as follows:
<ul>			+infinity + +infinity == +infinity
<li>			-infinity + -infinity == -infinity
<li>			+infinity + -infinity == invalid
<li>			-infinity + +infinity == invalid
</ul>
				If the operands are valid, not infinite, and either or both is indefinite, the result
				will be indefinite. 								

				If the two operands are numeric (ie. valid, not infinite, not indefinite), but have
				different nonzero epochs, the result will be invalid.  If they have the same nonzero 
				epoch, the result will have epoch zero (a duration).  Times in different epochs 
				cannot be added or subtracted, because epoch length is unknown.  Times in epoch zero 
				are considered to be durations and can be added to times in other epochs.
				Times in different epochs can be compared, however, because numerically greater 
				epochs always occur after numerically lesser epochs. 
    @result     The sum of the two CMTimes (addend1 + addend2).
*/
CM_EXPORT 
CMTime CMTimeAdd(
				CMTime addend1,				/*! @param addend1			A CMTime to be added. */
				CMTime addend2)				/*! @param addend2			Another CMTime to be added. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMTimeSubtract
    @abstract   Returns the difference of two CMTimes.
    @discussion If the operands both have the same timescale, the timescale of the result will be the same as
				the operands' timescale.  If the operands have different timescales, the timescale of the result
				will be the least common multiple of the operands' timescales.  If that LCM timescale is 
				greater than kCMTimeMaxTimescale, the result timescale will be kCMTimeMaxTimescale,
				and default rounding will be applied when converting the result to this timescale.
				
				If the result value overflows, the result timescale will be repeatedly halved until the result
				value no longer overflows.  Again, default rounding will be applied when converting the
				result to this timescale.  If the result value still overflows when timescale == 1, then the
				result will be either positive or negative infinity, depending on the direction of the
				overflow.
				
				If any rounding occurs for any reason, the result's kCMTimeFlags_HasBeenRounded flag will be
				set.  This flag will also be set if either of the operands has kCMTimeFlags_HasBeenRounded set.

				If either of the operands is invalid, the result will be invalid.
				
				If the operands are valid, but just one operand is infinite, the result will be similarly
				infinite. If the operands are valid, and both are infinite, the results will be as follows:
<ul>			+infinity - +infinity == invalid
<li>			-infinity - -infinity == invalid
<li>			+infinity - -infinity == +infinity
<li>			-infinity - +infinity == -infinity
</ul>
				If the operands are valid, not infinite, and either or both is indefinite, the result
				will be indefinite. 								

				If the two operands are numeric (ie. valid, not infinite, not indefinite), but have
				different nonzero epochs, the result will be invalid.  If they have the same nonzero 
				epoch, the result will have epoch zero (a duration).  Times in different epochs 
				cannot be added or subtracted, because epoch length is unknown.  Times in epoch zero 
				are considered to be durations and can be subtracted from times in other epochs.
				Times in different epochs can be compared, however, because numerically greater 
				epochs always occur after numerically lesser epochs. 
    @result     The difference of the two CMTimes (minuend - subtrahend).
*/
CM_EXPORT 
CMTime CMTimeSubtract(
				CMTime minuend,		/*! @param minuend		The CMTime from which the subtrahend will be subtracted. */
				CMTime subtrahend)	/*! @param subtrahend	The CMTime that will be subtracted from the minuend. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMTimeMultiply
    @abstract   Returns the product of a CMTime and a 32-bit integer.
    @discussion The result will have the same timescale as the CMTime operand. If the result value overflows,
				the result timescale will be repeatedly halved until the result value no longer overflows.
				Again, default rounding will be applied when converting the result to this timescale.  If the
				result value still overflows when timescale == 1, then the result will be either positive or
				negative infinity, depending on the direction of the overflow.
				
				If any rounding occurs for any reason, the result's kCMTimeFlags_HasBeenRounded flag will be
				set.  This flag will also be set if the CMTime operand has kCMTimeFlags_HasBeenRounded set.

				If the CMTime operand is invalid, the result will be invalid.
				
				If the CMTime operand is valid, but infinite, the result will be infinite, and of an appropriate sign, given
				the signs of both operands.
				
				If the CMTime operand is valid, but indefinite, the result will be indefinite. 								

    @result     The product of the CMTime and the 32-bit integer.
*/
CM_EXPORT 
CMTime CMTimeMultiply(
				CMTime time,			/*! @param time			The CMTime that will be multiplied. */
				int32_t multiplier)		/*! @param multiplier	The integer it will be multiplied by. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeMultiplyByFloat64
	@abstract   Returns the product of a CMTime and a 64-bit float.
	@discussion The result will initially have the same timescale as the CMTime operand. 
				If the result timescale is less than 65536, it will be repeatedly doubled until it is at least 65536.
				If the result value overflows, the result timescale will be repeatedly halved until the 
				result value no longer overflows.
				Again, default rounding will be applied when converting the result to this timescale.  If the
				result value still overflows when timescale == 1, then the result will be either positive or
				negative infinity, depending on the direction of the overflow.
				
				If any rounding occurs for any reason, the result's kCMTimeFlags_HasBeenRounded flag will be
				set.  This flag will also be set if the CMTime operand has kCMTimeFlags_HasBeenRounded set.

				If the CMTime operand is invalid, the result will be invalid.
				
				If the CMTime operand is valid, but infinite, the result will be infinite, and of an appropriate sign, given
				the signs of both operands.
				
				If the CMTime operand is valid, but indefinite, the result will be indefinite.								

	@result     The product of the CMTime and the 64-bit float.
*/
CM_EXPORT 
CMTime CMTimeMultiplyByFloat64(
				CMTime time,			/*! @param time			The CMTime that will be multiplied. */
				Float64 multiplier)		/*! @param multiplier	The Float64 it will be multiplied by. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMTimeCompare
    @abstract   Returns the numerical relationship (-1 = less than, 1 = greater than, 0 = equal) of two CMTimes.
    @discussion If the two CMTimes are numeric (ie. not invalid, infinite, or indefinite), and have
				different epochs, it is considered that times in numerically larger epochs are always
				greater than times in numerically smaller epochs. 
				
				Since this routine will be used to sort lists by time, it needs to give all values 
				(even invalid and indefinite ones) a strict ordering to guarantee that sort algorithms
				terminate safely. The order chosen is somewhat arbitrary:
				
				-infinity < all finite values < indefinite < +infinity < invalid
				
				Invalid CMTimes are considered to be equal to other invalid CMTimes, and greater than
				any other CMTime. Positive infinity is considered to be less than any invalid CMTime,
				equal to itself, and greater than any other CMTime. An indefinite CMTime is considered
				to be less than any invalid CMTime, less than positive infinity, equal to itself,
				and greater than any other CMTime.  Negative infinity is considered to be equal to itself,
				and less than any other CMTime.
				
				-1 is returned if time1 is less than time2. 0 is returned if they
				are equal. 1 is returned if time1 is greater than time2.
    @result     The numerical relationship of the two CMTimes (-1 = less than, 1 = greater than, 0 = equal).
*/
CM_EXPORT 
int32_t CMTimeCompare(
				CMTime time1,		/*! @param time1 First CMTime in comparison. */
				CMTime time2)		/*! @param time2 Second CMTime in comparison. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTIME_COMPARE_INLINE
    @abstract   Returns whether the specified comparison of two CMTimes is true.
    @discussion This is a macro that evaluates to a Boolean result.
				Example of usage:
					CMTIME_COMPARE_INLINE(time1, <=, time2) will return true if time1 <= time2.
	@param		time1 First time to compare
	@param		comparator Comparison operation to perform (eg. <=).
	@param		time2 Second time to compare
    @result     Returns the result of the specified CMTime comparison.
*/
#define CMTIME_COMPARE_INLINE(time1, comparator, time2) ((Boolean)(CMTimeCompare(time1, time2) comparator 0))

/*!
	@function	CMTimeMinimum
    @abstract   Returns the lesser of two CMTimes (as defined by CMTimeCompare).
    @result     The lesser of the two CMTimes.
*/
CM_EXPORT 
CMTime CMTimeMinimum(
				CMTime time1,	/*! @param time1 A CMTime */
				CMTime time2)	/*! @param time2 Another CMTime */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeMaximum
    @abstract   Returns the greater of two CMTimes (as defined by CMTimeCompare).
    @result     The greater of the two CMTimes.
*/
CM_EXPORT 
CMTime CMTimeMaximum(
				CMTime time1,	/*! @param time1 A CMTime */
				CMTime time2)	/*! @param time2 Another CMTime */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeAbsoluteValue
    @abstract   Returns the absolute value of a CMTime.
    @result     Same as the argument time, with sign inverted if negative.
*/
CM_EXPORT 
CMTime CMTimeAbsoluteValue(
				CMTime time)	/*! @param time A CMTime */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeCopyAsDictionary
    @abstract   Returns a CFDictionary version of a CMTime.
    @discussion This is useful when putting CMTimes in CF container types.
    @result     A CFDictionary version of the CMTime.
*/
CM_EXPORT 
CFDictionaryRef CMTimeCopyAsDictionary(
					CMTime time,				/*! @param time			CMTime from which to create dictionary. */
					CFAllocatorRef allocator)	/*! @param allocator	CFAllocator with which to create dictionary.
																		Pass kCFAllocatorDefault to use the default
																		allocator. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
/*!
	@function	CMTimeMakeFromDictionary
    @abstract   Reconstitutes a CMTime struct from a CFDictionary previously created by CMTimeCopyAsDictionary.
    @discussion This is useful when getting CMTimes from CF container types.  If the CFDictionary does not
				have the requisite keyed values, an invalid time is returned.
	@result		The created CMTime.  
*/
CM_EXPORT 
CMTime CMTimeMakeFromDictionary(
				CFDictionaryRef dict)	/*! @param dict CFDictionary from which to create CMTime. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant kCMTimeValueKey
	@discussion CFDictionary key for value field of CMTime (CFNumber containing int64_t)
*/
CM_EXPORT const CFStringRef kCMTimeValueKey
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant kCMTimeScaleKey
	@discussion CFDictionary key for timescale field of CMTime (CFNumber containing int32_t)
*/
CM_EXPORT const CFStringRef kCMTimeScaleKey
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant kCMTimeEpochKey
	@discussion CFDictionary key for epoch field of CMTime (CFNumber containing int64_t)
*/
CM_EXPORT const CFStringRef kCMTimeEpochKey
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant kCMTimeFlagsKey
	@discussion CFDictionary key for flags field of CMTime (CFNumber containing uint32_t)
*/
CM_EXPORT const CFStringRef kCMTimeFlagsKey
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeCopyDescription
    @abstract   Creates a CFString with a description of a CMTime (just like CFCopyDescription).
    @discussion This is used from within CFShow on an object that contains CMTime fields. It is
				also useful from other client debugging code.  The caller owns the returned
				CFString, and is responsible for releasing it.
	@result		The created CFString description.  
*/
CM_EXPORT 
CFStringRef CMTimeCopyDescription(
	CFAllocatorRef allocator,		/*! @param allocator	CFAllocator with which to create description. Pass
															kCFAllocatorDefault to use the default allocator. */
	CMTime time)					/*! @param time			CMTime to describe. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeShow
    @abstract   Prints a description of the CMTime (just like CFShow).
    @discussion This is most useful from within gdb.
*/
CM_EXPORT 
void CMTimeShow(
	CMTime time)					/*! @param time			CMTime to show. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


#pragma pack(pop)

#ifdef __cplusplus
}
#endif
	
#endif // CMTIME_H
