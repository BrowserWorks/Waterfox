/*
	File:  CMSync.h
 
	Framework:  CoreMedia
 
	Copyright 2006-2013 Apple Inc. All rights reserved.
 
*/

#ifndef __CMSYNC__
#define __CMSYNC__

#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMTime.h>
#include <dispatch/dispatch.h>

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma pack(push, 4)

/*!
	@typedef	CMClock
	@abstract	A timing source object.
	@discussion
		A clock represents a source of time information: generally, a piece of hardware that measures the passage of time.  
		One example of a clock is the host time clock, accessible via CMClockGetHostTimeClock().  
		It measures time using the CPU system clock, which on Mac OS X is mach_absolute_time().
		Every audio device can also be considered a clock since the audio samples that it outputs or inputs each have a 
		defined duration (eg, 1/48000 of a second for 48 kHz audio).
		
		CMClocks are read-only: they cannot be stopped or started, and the current time cannot be set.
		A CMClock has one primary function, CMClockGetTime, which tells what time it is now.  
		Additionally, the CMSync infrastructure monitors relative drift between CMClocks.
*/

typedef struct OpaqueCMClock* CMClockRef; // a CF type; use CFRetain and CFRelease

/*!
	@typedef	CMTimebase
	@abstract	Models a timeline under application control.
	@discussion
		A timebase represents a timeline that clients can control by setting the rate and time.
		Each timebase has either a master clock or a master timebase.  
		The rate of the timebase is expressed relative to its master. 
		When a timebase has rate 0.0, its time is fixed and does not change as its master's time changes.
		When a timebase has rate 1.0, its time increases one second as its master's time increases by one second.
		When a timebase has rate 2.0, its time increases two seconds as its master's time increases by one second.
		When a timebase has rate -1.0, its time decreases one second as its master's time increases by one second.
		
		If a timebase has a master timebase, the master timebase's rate is a factor in determining the timebase's effective rate.
		In fact, a timebase's effective rate is defined as the product of its rate, its master timebase's rate, 
		its master timebase's master timebase's rate, and so on up to the ultimate master clock.  This is the rate at which
		the timebase's time changes relative to the ultimate master clock.
*/

typedef struct OpaqueCMTimebase* CMTimebaseRef; // a CF type; use CFRetain and CFRelease

typedef CFTypeRef CMClockOrTimebaseRef; // used in argument lists and function results to indicate that either may be passed


// CMClock error codes
enum {
	kCMClockError_MissingRequiredParameter	= -12745,
	kCMClockError_InvalidParameter			= -12746,
	kCMClockError_AllocationFailed			= -12747,
	kCMClockError_UnsupportedOperation		= -12756,
};

// CMTimebase error codes
enum {
	kCMTimebaseError_MissingRequiredParameter	= -12748,
	kCMTimebaseError_InvalidParameter			= -12749,
	kCMTimebaseError_AllocationFailed			= -12750,
	kCMTimebaseError_TimerIntervalTooShort		= -12751,
	kCMTimebaseError_ReadOnly					= -12757,
};

// CMSync error codes
enum {
	kCMSyncError_MissingRequiredParameter	= -12752,
	kCMSyncError_InvalidParameter			= -12753,
	kCMSyncError_AllocationFailed			= -12754,
	kCMSyncError_RateMustBeNonZero			= -12755,
};

/*!
	@function	CMClockGetTypeID
	@abstract	Returns the CFTypeID for CMClock.
*/
CM_EXPORT CFTypeID
CMClockGetTypeID( void )
	__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMClockGetHostTimeClock
	@abstract	Returns a reference to the singleton clock logically identified with host time.
	@discussion
		On Mac OS X, the host time clock uses mach_absolute_time but returns a value 
		with a large integer timescale (eg, nanoseconds).
*/
CM_EXPORT CMClockRef
CMClockGetHostTimeClock( void )
	__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMClockConvertHostTimeToSystemUnits
	@abstract	Converts a host time from CMTime to the host time's native units.
	@discussion
		This function performs a scale conversion, not a clock conversion.
		It can be more accurate than CMTimeConvertScale because the system units may 
		have a non-integer timescale.
		On Mac OS X, this function converts to the units of mach_absolute_time.
*/
CM_EXPORT uint64_t
CMClockConvertHostTimeToSystemUnits( CMTime hostTime )
	__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMClockMakeHostTimeFromSystemUnits
	@abstract	Converts a host time from native units to CMTime.
	@discussion
		The returned value will have a large integer timescale (eg, nanoseconds).
		This function handles situations where host time's native units use a 
		non-integer timescale.
		On Mac OS X, this function converts from the units of mach_absolute_time.
*/
CM_EXPORT CMTime
CMClockMakeHostTimeFromSystemUnits( uint64_t hostTime )
	__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);
		
/*!
	@function	CMClockGetTime
	@abstract	Retrieves the current time from a clock.
*/
CM_EXPORT CMTime
CMClockGetTime( 
		CMClockRef clock )
	__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMClockGetAnchorTime
	@abstract	Retrieves the current time from a clock and also the matching time from the clock's reference clock.
	@discussion	To make practical use of this, you may need to know what the clock's reference clock is.
*/
CM_EXPORT OSStatus
CMClockGetAnchorTime( 
		CMClockRef clock,
		CMTime *outClockTime,
		CMTime *outReferenceClockTime )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMClockMightDrift
	@abstract	Indicates whether it is possible for two clocks to drift relative to each other.
*/
CM_EXPORT Boolean
CMClockMightDrift(
		CMClockRef clock,
		CMClockRef otherClock )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMClockInvalidate
	@abstract	Makes the clock stop functioning.
	@discussion
		After invalidation, the clock will return errors from all APIs.
		This should only be called by the "owner" of the clock, who knows (for example) that some piece of hardware
		has gone away, and the clock will no longer work (and might even crash).
*/
CM_EXPORT void
CMClockInvalidate(
		CMClockRef clock )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);
		

/*!
	@function	CMTimebaseGetTypeID
	@abstract	Returns the CFTypeID for CMTimebase.
*/
CM_EXPORT CFTypeID
CMTimebaseGetTypeID( void )
	__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseCreateWithMasterClock
	@abstract	Creates a timebase driven by the given clock.  
	@discussion
		The timebase will initially have rate zero and time zero.
		Pass CMClockGetHostTimeClock() for masterClock to have the host time clock drive this timebase.
*/
CM_EXPORT OSStatus
CMTimebaseCreateWithMasterClock( 
		CFAllocatorRef allocator,
		CMClockRef masterClock,
		CMTimebaseRef *timebaseOut )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseCreateWithMasterTimebase
	@abstract	Creates a timebase driven by the given master timebase.  
	@discussion
		The timebase will initially have rate zero and time zero.
*/
CM_EXPORT OSStatus
CMTimebaseCreateWithMasterTimebase( 
		CFAllocatorRef allocator,
		CMTimebaseRef masterTimebase,
		CMTimebaseRef *timebaseOut )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseGetMasterTimebase
	@abstract	Returns the immediate master timebase of a timebase.
	@discussion
		Returns NULL if the timebase actually has a master clock instead of a master timebase.
*/
CM_EXPORT CMTimebaseRef
CMTimebaseGetMasterTimebase(
		CMTimebaseRef timebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseGetMasterClock
	@abstract	Returns the immediate master clock of a timebase.  
	@discussion
		Returns NULL if the timebase actually has a master timebase instead of a master clock.
*/
CM_EXPORT CMClockRef
CMTimebaseGetMasterClock(
		CMTimebaseRef timebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseGetMaster
	@abstract	Returns the immediate master (either timebase or clock) of a timebase.  
	@discussion
		Only returns NULL if there was an error (such as timebase == NULL).
		Example of use: time = CMSyncGetTime(CMTimebaseGetMaster(timebase));
*/
CM_EXPORT CMClockOrTimebaseRef
CMTimebaseGetMaster(
		CMTimebaseRef timebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseGetUltimateMasterClock
	@abstract	Returns the master clock that is the master of all of a timebase's master timebases.
*/
CM_EXPORT CMClockRef
CMTimebaseGetUltimateMasterClock(
		CMTimebaseRef timebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);
		
/*!
	@function	CMTimebaseGetTime
	@abstract	Retrieves the current time from a timebase.
*/
CM_EXPORT CMTime
CMTimebaseGetTime( 
		CMTimebaseRef timebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseGetTimeWithTimeScale
	@abstract	Retrieves the current time from a timebase in the specified timescale.
*/
CM_EXPORT CMTime
CMTimebaseGetTimeWithTimeScale( 
		CMTimebaseRef timebase,
		CMTimeScale timescale,
		CMTimeRoundingMethod method)
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseSetTime
	@abstract	Sets the current time of a timebase.  
*/
CM_EXPORT OSStatus 
CMTimebaseSetTime( 
		CMTimebaseRef timebase, 
		CMTime time )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseSetAnchorTime
	@abstract	Sets the time of a timebase at a particular master time.
	@discussion
		CMTimebaseGetTime's results will be interpolated from that anchor time.
		CMTimebaseSetTime(timebase, time) is equivalent to calling
		CMTimebaseSetAnchorTime(timebase, time, CMSyncGetTime(CMTimebaseGetMaster(timebase))).
*/
CM_EXPORT OSStatus
CMTimebaseSetAnchorTime(
		CMTimebaseRef timebase,
		CMTime timebaseTime,
		CMTime immediateMasterTime)
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseGetRate
	@abstract	Retrieves the current rate of a timebase.  
	@discussion
		This is the rate relative to its immediate master clock or timebase.  
		For example, if a timebase is running at twice the rate of its master, its rate is 2.0.
*/
CM_EXPORT Float64 
CMTimebaseGetRate( 
		CMTimebaseRef timebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseGetTimeAndRate
	@abstract	Retrieves the current time and rate of a timebase.
	@discussion
		You can use this function to take a consistent snapshot of the two values,
		avoiding possible inconsistencies due to external changes between retrieval of time and rate.
*/
CM_EXPORT OSStatus 
CMTimebaseGetTimeAndRate( 
		CMTimebaseRef timebase,
		CMTime *outTime,
		Float64 *outRate )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseSetRate
	@abstract	Sets the rate of a timebase.
*/
CM_EXPORT OSStatus 
CMTimebaseSetRate( 
		CMTimebaseRef timebase, 
		Float64 rate )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);
		
/*!
	@function	CMTimebaseSetRateAndAnchorTime
	@abstract	Sets the time of a timebase at a particular master time, and changes the rate at exactly that time.
	@discussion
		CMTimebaseGetTime's results will be interpolated from that anchor time as though the timebase 
		has been running at the requested rate since that time.
		CMTimebaseSetRate(timebase, rate) is approximately equivalent to calling
		CMTimebaseSetRateAndAnchorTime(timebase, rate, CMTimebaseGetTime(timebase),
		                               CMSyncGetTime(CMTimebaseGetMaster(timebase))),
		except that CMTimebaseSetRate will not generate a TimeJumped notification, and
		CMTimebaseSetRateAndAnchorTime will.
*/
CM_EXPORT OSStatus
CMTimebaseSetRateAndAnchorTime(
		CMTimebaseRef timebase,
		Float64 rate,
		CMTime timebaseTime,
		CMTime immediateMasterTime)
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseGetEffectiveRate
	@abstract	Gets the effective rate of a timebase (which combines its rate with the rates of all its master timebases).
	@discussion
		Calling CMTimebaseGetEffectiveRate(timebase) is equivalent to calling
		CMSyncGetRelativeRate(timebase, CMTimebaseGetUltimateMasterClock(timebase)).
*/
CM_EXPORT Float64
CMTimebaseGetEffectiveRate(
		CMTimebaseRef timebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseAddTimer
	@abstract
		Adds the timer to the list of timers managed by the timebase. 
	@discussion
		The timer must be a repeating run loop timer (with a very long interval at
		least as long as kCMTimebaseVeryLongCFTimeInterval), attached to a runloop.  
		The timebase will retain the timer, and will maintain its "NextFireDate" 
		according to the CMTime set using CMTimebaseSetTimerNextFireTime.
		Until the first call to CMTimebaseSetTimerNextFireTime, the "NextFireDate" 
		will be set far, far in the future. The runloop that timer is attached to must be
		passed in and the timebase will retain that runloop. The retained runloop will be
		used to call CFRunLoopWakeUp() any time the timebase modifies the timer's fire date.
*/
CM_EXPORT OSStatus
CMTimebaseAddTimer( 
		CMTimebaseRef timebase,
		CFRunLoopTimerRef timer,
		CFRunLoopRef runloop )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

#define kCMTimebaseVeryLongCFTimeInterval	(CFTimeInterval)(256.0 * 365.0 * 24.0 * 60.0 * 60.0)	// quite a while
#define kCMTimebaseFarFutureCFAbsoluteTime	((CFAbsoluteTime)kCMTimebaseVeryLongCFTimeInterval)		// quite a while from 2001

/*!
	@function	CMTimebaseRemoveTimer
	@abstract
		Removes the timer from the list of timers managed by the timebase. 
	@discussion
		The timebase will no longer maintain the timer's "NextFireDate".
		If the timer is invalidated, the timebase will eventually remove it 
		from its list and release it even if this function is not called.
*/
CM_EXPORT OSStatus
CMTimebaseRemoveTimer( 
		CMTimebaseRef timebase,
		CFRunLoopTimerRef timer )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseSetTimerNextFireTime
	@abstract
		Sets the CMTime on the timebase's timeline at which the timer should next be fired.
	@discussion
		The timer must be on the list of timers managed by the timebase.
		The timebase will continue to update the timer's "NextFireDate" according to time jumps 
		and effective rate changes.
		If fireTime is not numeric, or if the timebase is not moving, the "NextFireDate"
		will be set to a date far, far in the future.
		<BR>
		IMPORTANT NOTE: Due to the way that CFRunLoopTimers are implemented, if a timer passes 
		through a state in which it is due to fire, it may fire even if its rescheduled before 
		the runloop runs again.  Clients should take care to avoid temporarily scheduling timers 
		in the past.  For example, set the timebase's rate or time before you set the timer's 
		next fire time, if you are doing both at once.  (If setting the timebase's rate or time
		might put the timer's fire time in the past, you may need to set the fire time to 
		kCMTimeInvalid across the timebase change.)
*/
CM_EXPORT OSStatus
CMTimebaseSetTimerNextFireTime( 
		CMTimebaseRef timebase,
		CFRunLoopTimerRef timer,
		CMTime fireTime,
		uint32_t flags ) // reserved, pass zero
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseSetTimerToFireImmediately
	@abstract
		Sets the timer to fire immediately once, overriding any previous CMTimebaseSetTimerNextFireTime call.
	@discussion
		The timer must be on the list of timers managed by the timebase.
		This is equivalent to calling 
			CFRunLoopTimerSetNextFireDate( timer, CFAbsoluteTimeGetCurrent() );
		except that the timebase gets to know that it shouldn't interfere.
*/
CM_EXPORT OSStatus
CMTimebaseSetTimerToFireImmediately( 
		CMTimebaseRef timebase,
		CFRunLoopTimerRef timer )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);


/*!
	@function	CMTimebaseAddTimerDispatchSource
	@abstract
		Adds the timer dispatch source to the list of timers managed by the timebase. 
	@discussion
		The timer source must have been created by calling
		dispatch_source_create( DISPATCH_SOURCE_TYPE_TIMER, 0, 0, some_dispatch_queue )
		and should have had an event handler associated with it via
		dispatch_source_set_event_handler( timerSource, some_handler_block )
		or dispatch_source_set_event_handler_f( timerSource, some_handler_function ).
		Don't forget to call dispatch_resume( timerSource ) as dispatch sources are 
		created suspended.
		
		The timebase will retain the timer source, and will maintain its start time
		according to the CMTime set using CMTimebaseSetTimerDispatchSourceNextFireTime.
		Until the first call to CMTimebaseSetTimerDispatchSourceNextFireTime, the start time 
		will be set to DISPATCH_TIME_FOREVER.
*/
CM_EXPORT OSStatus
CMTimebaseAddTimerDispatchSource( 
		CMTimebaseRef timebase,
		dispatch_source_t timerSource )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);


/*!
	@function	CMTimebaseRemoveTimerDispatchSource
	@abstract
		Removes the timer dispatch source from the list of timers managed by the timebase. 
	@discussion
		The timebase will no longer maintain the timer source's start time.
		If the timer source is cancelled, the timebase will eventually remove it 
		from its list and release it even if this function is not called.
*/
CM_EXPORT OSStatus
CMTimebaseRemoveTimerDispatchSource( 
		CMTimebaseRef timebase,
		dispatch_source_t timerSource )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseSetTimerDispatchSourceNextFireTime
	@abstract
		Sets the CMTime on the timebase's timeline at which the timer dispatch source should next be fired.
	@discussion
		The timer source must be on the list of timers managed by the timebase.
		The timebase will continue to update the timer dispatch source's start time 
		according to time jumps and effective rate changes.
		If fireTime is not numeric, or if the timebase is not moving, the start time
		will be set to DISPATCH_TIME_FOREVER.
		<BR>
		IMPORTANT NOTE: Due to the way that timer dispatch sources are implemented, if a timer passes 
		through a state in which it is due to fire, it may fire even if its rescheduled before 
		the event handler is run.  Clients should take care to avoid temporarily scheduling timers 
		in the past.  For example, set the timebase's rate or time before you set the timer's 
		next fire time, if you are doing both at once.  (If setting the timebase's rate or time
		might put the timer's fire time in the past, you may need to set the fire time to 
		kCMTimeInvalid across the timebase change.)
*/
CM_EXPORT OSStatus
CMTimebaseSetTimerDispatchSourceNextFireTime( 
		CMTimebaseRef timebase,
		dispatch_source_t timerSource,
		CMTime fireTime,
		uint32_t flags ) // reserved, pass zero
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseSetTimerDispatchSourceToFireImmediately
	@abstract
		Sets the timer dispatch source to fire immediately once, overriding any previous
		CMTimebaseSetTimerDispatchSourceNextFireTime call.
	@discussion
		The timer source must be on the list of timers managed by the timebase.
		This is equivalent to calling 
			dispatch_source_set_timer( timerSource, DISPATCH_TIME_NOW, 0, 0 );
		except that the timebase gets to know that it shouldn't interfere.
*/
CM_EXPORT OSStatus
CMTimebaseSetTimerDispatchSourceToFireImmediately( 
		CMTimebaseRef timebase,
		dispatch_source_t timerSource )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);



/*!
	@function	CMSyncGetRelativeRate
	@abstract	Queries the relative rate of one timebase or clock relative to another timebase or clock.
	@discussion
		If both have a common master, this calculation is performed purely based on the rates in the common tree 
		rooted in that master.  
		If they have different master clocks (or are both clocks), this calculation takes into account the measured
		drift between the two clocks, using host time as a pivot.
		The rate of a moving timebase relative to a stopped timebase is a NaN.
		Calling CMTimebaseGetEffectiveRate(timebase) is equivalent to calling
		CMSyncGetRelativeRate(timebase, CMTimebaseGetUltimateMasterClock(timebase)).
*/
CM_EXPORT Float64 
CMSyncGetRelativeRate( 
		CMClockOrTimebaseRef ofClockOrTimebase, 
		CMClockOrTimebaseRef relativeToClockOrTimebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);
		
/*!
	@function	CMSyncGetRelativeRateAndAnchorTime
	@abstract	Queries the relative rate of one timebase or clock relative to another timebase or clock and the times of each timebase or clock at which the relative rate went into effect.
	@discussion
		If both have a common master, this calculation is performed purely based on the rates in the common tree
		rooted in that master.  
		If they have different master clocks (or are both clocks), this calculation takes into account the measured
		drift between the two clocks, using host time as a pivot.
		The rate of a moving timebase relative to a stopped timebase is a NaN.
*/
CM_EXPORT OSStatus
CMSyncGetRelativeRateAndAnchorTime( 
		CMClockOrTimebaseRef ofClockOrTimebase, 
		CMClockOrTimebaseRef relativeToClockOrTimebase,
		Float64* outRelativeRate,
		CMTime* outOfClockOrTimebaseAnchorTime,
		CMTime* outRelativeToClockOrTimebaseAnchorTime)
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMSyncConvertTime
	@abstract	Converts a time from one timebase or clock to another timebase or clock.
	@discussion
		If both have a common master, this calculation is performed purely based on the mathematical rates and offsets 
		in the common tree rooted in that master.  
		If they have different master clocks (or are both clocks), this calculation also compensates
		for measured drift between the clocks.
		To convert to or from host time, pass CMClockGetHostTimeClock() as the appropriate argument.
*/
CM_EXPORT CMTime
CMSyncConvertTime(
		CMTime time, 
		CMClockOrTimebaseRef fromClockOrTimebase,
		CMClockOrTimebaseRef toClockOrTimebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMSyncMightDrift
	@abstract	Reports whether it is possible for one timebase/clock to drift relative to the other.
	@discussion
		A timebase can drift relative to another if they are ultimately mastered by clocks that can drift relative
		to each other.
*/
CM_EXPORT Boolean
CMSyncMightDrift(
		CMClockOrTimebaseRef clockOrTimebase1,
		CMClockOrTimebaseRef clockOrTimebase2 )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);
		
/*!
	@function	CMSyncGetTime
	@abstract	A helper function to get time from a clock or timebase.
	@discussion
		CMSyncGetTime simply calls either CMClockGetTime or CMTimebaseGetTime, as appropriate.
		It comes in handy for things like: CMSyncGetTime(CMTimebaseGetMaster(timebase)).
*/
CM_EXPORT CMTime
CMSyncGetTime(
		CMClockOrTimebaseRef clockOrTimebase )
			__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMTimebaseNotificationBarrier
	@abstract	Requests that the timebase wait until it is not posting any notifications.
*/
CM_EXPORT OSStatus	CMTimebaseNotificationBarrier(CMTimebaseRef timebase )
						__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

// Posted by a timebase after a change in effective rate.  
CM_EXPORT const CFStringRef kCMTimebaseNotification_EffectiveRateChanged
								__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

// Posted by a timebase after a discontinuous time jump.
CM_EXPORT const CFStringRef kCMTimebaseNotification_TimeJumped
								__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

// Payload key for the time at which a change in effective rate or a discontinuous time jump occurred.
CM_EXPORT const CFStringRef kCMTimebaseNotificationKey_EventTime
								__OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

#pragma pack(pop)
    
#ifdef __cplusplus
}
#endif

#endif // __CMSYNC__
