/*
	File:  CMBufferQueue.h
	
	Framework:  CoreMedia
 
    Copyright 2006-2012 Apple Inc. All rights reserved.
  
*/

#ifndef CMBUFFERQUEUE_H
#define CMBUFFERQUEUE_H

/*!
	@header
	@abstract	API for creating and using CMBufferQueues.
	@discussion	CMBufferQueues are CF-based objects that implement a queue of timed buffers.  These buffers can be of any
				CF-based type (CFTypeRef), but must have a concept of duration.  During CMBufferQueue creation,
				a set of callbacks is provided, one of which is a required callback that returns the duration of
				the CF-based buffer object.  A standard callback struct for CMSampleBuffers is provided as a
				convenience.  These callbacks are called synchronously from within various CMBufferQueue APIs,
				on the thread that called the API.
				
				CMBufferQueues are designed to be read and written from different threads in a producer/consumer
				model.  While this is generally two threads (one producer/enqueuer, one dequeuer/consumer),
				CMBufferQueues can service any number of threads enqueueing and/or dequeueing buffers.  Inside 
				the CMBufferQueue APIs, all operations (not just Enqueue and Dequeue, but GetDuration,
				InstallTrigger, etc) are made atomic by use of a single mutex (one mutex per created queue object).
				
				By default, a CMBufferQueue is a FIFO queue, but if a comparison callback is provided, the
				resulting CMBufferQueue will be sorted based on that callback.  For example, one might create
				a CMBufferQueue where the buffers are enqueued in decode order, and dequeued in presentation
				order, by providing a comparison callback that sorts by presentation timestamp.
				
				CMBufferQueues retain the enqueued buffer during Enqueue, so the client can release the buffer if it
				has no further need of the reference.  During DequeueAndRetain, the buffer is retained on behalf of
				the client, and released by the queue.  The result is that the retain count remains the same, and the
				ownership of the buffer is transferred from the queue to the client.
				
				If provided with a buffer-readiness callback, CMBufferQueues can check for buffer readiness during
				DequeueIfDataReadyAndRetain.  If that callback is not provided, all buffers are assumed to be ready, and
				there is no difference between DequeueAndRetain and DequeueIfDataReadyAndRetain.
				
				CMBufferQueues also implement GetMinDecodeTimeStamp and GetMinPresentationTimeStamp, with the
				help of optional callbacks that get decode and presentation timestamps from a buffer.  If either or both
				of these callbacks is not provided, kCMTimeInvalid will be returned for the missing timestamp(s).
				
				CMBufferQueues can be marked with an end-of-data (MarkEndOfData).  Once so marked, further enqueues will
				fail, and once all the buffers have been dequeued, the queue is permanently empty ("at end of data") until
				Reset is called.  Reset empties the queue and undoes the end-of-data marking.
				
				The current status of a CMBufferQueue can be interrogated.  Clients can test for emptiness (IsEmpty), current
				queue duration (GetDuration), and end-of-data status (ContainsEndOfData and IsAtEndOfData).
				
				Trigger callbacks can be installed by clients (InstallTrigger), to get notifications of various queue state
				transitions, such as "duration becomes less than 1 second".  The queue cannot be modified during a trigger
				callback, but it can be interrogated.  Trigger conditions can be tested explicitly as well (TestTrigger).
				Triggers with NULL callbacks can be added to a queue for this type of use, but triggers with callbacks can
				also have their conditions explicitly tested.
				
				Trigger callbacks may be called from any CMBufferQueue API that modifies the total duration of the queue
				(eg. Enqueue/Dequeue/Reset). Trigger callbacks are called synchronously, on the thread that called the API.
				
				Modifying the state of the queue in any way from within a trigger callback is forbidden, and will fail,
				returning kCMBufferQueueError_CannotModifyQueueFromTriggerCallback.
				
				An attempt to Enqueue onto a full queue or to Dequeue from an empty queue will not block, but will return
				immediately with an error (or with a NULL buffer).  Triggers should be installed by the client to manage
				the client's knowledge of queue fullness.  The use of repeated retries (polling) is discouraged as an
				inefficient use of resources.

				IMPORTANT: Clients of CMBufferQueue must explicitly manage the retain count by 
				calling CFRetain and CFRelease, even in processes using garbage collection.

				Objective-C code that may run under garbage collection should NOT use [bufq retain],
				or [bufq release]; these will not have the correct effect.

				Furthermore, if they may run under garbage collection, Objective-C objects that release 
				instance variable CMBufferQueue objects during their -finalize methods should set those 
				object pointers to NULL immediately afterwards, to ensure that method calls received 
				after -finalize operate safely.
*/

#include <CoreMedia/CMBase.h>
#include <CoreFoundation/CoreFoundation.h>

#include <CoreMedia/CMTime.h>

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma pack(push, 4)

/*!
	@enum CMBufferQueue Errors
	@discussion The OSStatus errors returned from the CMBufferQueue APIs
	@constant	kCMBufferQueueError_AllocationFailed Returned when an allocation fails.
	@constant	kCMBufferQueueError_RequiredParameterMissing NULL or 0 was passed for a required parameter.
	@constant	kCMBufferQueueError_InvalidCMBufferCallbacksStruct Version was not 0, or getDuration was NULL.
	@constant	kCMBufferQueueError_EnqueueAfterEndOfData CMBufferQueueEnqueue was attempted after
				CMBufferQueueMarkEndOfData was called (without a call to CMBufferQueueReset in between).
	@constant	kCMBufferQueueError_QueueIsFull CMBufferQueueEnqueue was attempted on a full queue.
	@constant	kCMBufferQueueError_BadTriggerDuration Trigger time must be numeric, and epoch must be zero (non-zero epoch is only for timestamps, not durations)
	@constant	kCMBufferQueueError_CannotModifyQueueFromTriggerCallback Returned when an attempt is made to modify the queue from a trigger callback.
	@constant	kCMBufferQueueError_InvalidTriggerCondition Trigger condition is not a value from the CMBufferQueueTriggerCondition enum, or trigger condition is not supported by this buffer queue.
	@constant	kCMBufferQueueError_InvalidTriggerToken Trigger token is not a trigger that is currently associated with this queue.
	@constant	kCMBufferQueueError_InvalidBuffer Buffer was rejected by the CMBufferValidationCallback.
*/
enum {
	kCMBufferQueueError_AllocationFailed						= -12760,
	kCMBufferQueueError_RequiredParameterMissing				= -12761,
	kCMBufferQueueError_InvalidCMBufferCallbacksStruct			= -12762,
	kCMBufferQueueError_EnqueueAfterEndOfData					= -12763,
	kCMBufferQueueError_QueueIsFull								= -12764,
	kCMBufferQueueError_BadTriggerDuration						= -12765,
	kCMBufferQueueError_CannotModifyQueueFromTriggerCallback	= -12766,
	kCMBufferQueueError_InvalidTriggerCondition					= -12767,
	kCMBufferQueueError_InvalidTriggerToken						= -12768,
	kCMBufferQueueError_InvalidBuffer							= -12769,
};

/*!
	@typedef	CMBufferQueueRef
	@abstract	A reference to a CMBufferQueue, a CF object that implements a queue of timed buffers.
		
*/
typedef struct opaqueCMBufferQueue *CMBufferQueueRef;

/*!
	@typedef	CMBufferRef
	@abstract	A reference to a CMBuffer.
	@discussion	A CMBuffer can be any CFTypeRef, as long as a getDuration callback can be provided.  Commonly used
				types are CMSampleBufferRef and CVPixelBufferRef.
*/
typedef CFTypeRef CMBufferRef;

/*!
	@typedef	CMBufferGetTimeCallback
	@abstract	Client callback that returns a CMTime from a CMBufferRef
	@discussion	There are three callbacks of this type that can be provided to CMBufferQueueCreate: getDuration (required),
				getDecodeTimeStamp (optional), and getPresentationTimeStamp (optional).
*/
typedef CMTime (*CMBufferGetTimeCallback)(
	CMBufferRef buf,	/*! @param buf Buffer being interrogated. */
	void *refcon);		/*! @param refcon Client refcon. Can be NULL. */

/*!
	@typedef	CMBufferGetBooleanCallback
	@abstract	Client callback that returns a Boolean from a CMBufferRef
	@discussion	There is one callback of this type that can be provided to CMBufferQueueCreate: isDataReady (optional).
*/
typedef Boolean (*CMBufferGetBooleanCallback)(
	CMBufferRef buf,	/*! @param buf Buffer being interrogated. */
	void *refcon);		/*! @param refcon Client refcon. Can be NULL. */

/*!
	@typedef	CMBufferCompareCallback
	@abstract	Client callback that compares one CMBufferRef with another.
	@discussion	Note that a CFComparatorFunction can be used here.
*/
typedef CFComparisonResult (*CMBufferCompareCallback)(
	CMBufferRef buf1,	/*! @param buf Buffer being compared. */
	CMBufferRef buf2,	/*! @param buf Other buffer being compared. */
	void *refcon);		/*! @param refcon Client refcon. Can be NULL. */

/*!
	@typedef	CMBufferCallbacks
	@abstract	Callbacks provided to CMBufferQueueCreate, for use by the queue in interrogating the buffers that it will see.
	@discussion	With the exception of isDataReady, all these callbacks must always return the same result for the same arguments.
				A buffer's duration, timestamps, or position relative to other buffers must not appear to change while it is in 
				the queue.  Once isDataReady has returned true for a given CMBuffer, it must always return true for that 
				CMBuffer.  Durations must always be positive.
*/
typedef struct {
	uint32_t					version;						/*! @field version
																	Must be 0. */
	void						*refcon;						/*! @field refcon
																	Client refcon to be passed to all callbacks (can be NULL,
																	if the callbacks don't require it). */
	CMBufferGetTimeCallback		getDecodeTimeStamp;				/*! @field getDecodeTimeStamp
																	This callback is called from CMBufferQueueGetFirstDecodeTimeStamp (once),
																	and from CMBufferQueueGetMinDecodeTimeStamp (multiple times).  It should
																	return the decode timestamp of the buffer.  If there are multiple samples
																	in the buffer, this callback should return the minimum decode timestamp
																	in the buffer. Can be NULL (CMBufferQueueGetFirstDecodeTimeStamp and
																	CMBufferQueueGetMinDecodeTimeStamp will return kCMTimeInvalid). */
	CMBufferGetTimeCallback		getPresentationTimeStamp;		/*! @field getPresentationTimeStamp
																	This callback is called from CMBufferQueueGetFirstPresentationTimeStamp
																	(once) and from CMBufferQueueGetMinPresentationTimeStamp (multiple times).
																	It should return the presentation timestamp of the buffer.  If there are
																	multiple samples in the buffer, this callback should return the minimum
																	presentation timestamp in the buffer. Can be NULL
																	(CMBufferQueueGetFirstPresentationTimeStamp and
																	CMBufferQueueGetMinPresentationTimeStamp will return kCMTimeInvalid). */
	CMBufferGetTimeCallback		getDuration;					/*! @field getDuration
																	This callback is called (once) during enqueue and dequeue operations to
																	update the total duration of the queue.  Must not be NULL. */
	CMBufferGetBooleanCallback	isDataReady;					/*! @field isDataReady
																	This callback is called from CMBufferQueueDequeueIfDataReadyAndRetain, to
																	ask if the buffer that is about to be dequeued is ready.  Can be NULL
																	(data will be assumed to be ready). */
	CMBufferCompareCallback		compare;						/*! @field compare
																	This callback is called (multiple times) from CMBufferQueueEnqueue, to
																	perform an insertion sort. Can be NULL (queue will be FIFO). */
	CFStringRef					dataBecameReadyNotification;	/*! @field dataBecameReadyNotification
																	If triggers of type kCMBufferQueueTrigger_WhenDataBecomesReady are installed,
																	the queue will listen for this notification on the head buffer. 
																	Can be NULL (then the queue won't listen for it). */
} CMBufferCallbacks;

/*!
	@function	CMBufferQueueGetCallbacksForUnsortedSampleBuffers
	@abstract	Returns a pointer to a callback struct for unsorted CMSampleBuffers, provided as a convenience.
*/
CM_EXPORT const CMBufferCallbacks *CMBufferQueueGetCallbacksForUnsortedSampleBuffers(void)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	 @function	CMBufferQueueGetCallbacksForOutputPTSSortedSampleBuffers
	 @abstract	Returns a pointer to a callback struct for CMSampleBuffers sorted by output presentation timestamp, provided as a convenience.
 */
CM_EXPORT const CMBufferCallbacks *CMBufferQueueGetCallbacksForSampleBuffersSortedByOutputPTS(void)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_3);

/*!
	@function	CMBufferQueueCreate
	@abstract	Creates a CMBufferQueue object.
	@discussion	On return, the caller owns the returned CMBufferQueue, and must release it when done with it.
*/
CM_EXPORT OSStatus CMBufferQueueCreate(
	CFAllocatorRef allocator,				/*! @param allocator
												The allocator to use for allocating the CMBufferQueue object.
												Pass kCFAllocatorDefault to use the default allocator. */
	CMItemCount	capacity,					/*! @param capacity
												Maximum number of buffers in the queue.  Pass 0 to create
												a queue that will grow as needed. */
	const CMBufferCallbacks *callbacks,		/*! @param callbacks
												Callbacks the queue should use to interrogate the buffer objects.
												This struct is copied internally, so the client can pass a pointer
												to a temporary struct on the stack. */
	CMBufferQueueRef *queueOut)				/*! @param queueOut
												Returned newly created CMBufferQueue. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueGetTypeID
	@abstract	Returns the CFTypeID of CMBufferQueue objects.
	@discussion	You can check if a CFTypeRef object is actually a CMBufferQueue by comparing CFGetTypeID(object) with CMBufferQueueGetTypeID().
	@result		CFTypeID of CMBufferQueue objects.
*/
CM_EXPORT CFTypeID CMBufferQueueGetTypeID(void)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
    @function   CMBufferQueueEnqueue
    @abstract   Enqueues a buffer onto a CMBufferQueue.
    @discussion The buffer is retained by the queue, so the client can safely release the buffer if it has no further use for it.
				If the compare callback is non-NULL, this API performs an insertion sort using that compare operation.
				If the validation callback is non-NULL, this API calls it; if it returns a nonzero OSStatus, 
				the buffer will not be enqueued and this API will return the same error OSStatus.
*/
CM_EXPORT OSStatus CMBufferQueueEnqueue(
	CMBufferQueueRef queue,	/*! @param queue
									The CMBufferQueue on which to enqueue the buffer. */
	CMBufferRef buf)			/*! @param buf
									The buffer to enqueue. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
    @function   CMBufferQueueDequeueAndRetain
    @abstract   Dequeues a buffer from a CMBufferQueue.
    @discussion The buffer is released by the queue, but it is also retained for the client. Buffer ownership is thereby
				transferred from queue to client.  The client need not retain the buffer, but is responsible to release
				it when done with it.
	@result		The dequeued buffer.  Will be NULL if the queue is empty.
*/
CM_EXPORT CMBufferRef CMBufferQueueDequeueAndRetain(
	CMBufferQueueRef queue)		/*! @param queue
									The CMBufferQueue from which to dequeue a buffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
    @function   CMBufferQueueDequeueIfDataReadyAndRetain
    @abstract   Dequeues a buffer from a CMBufferQueue if it is ready.
    @discussion The buffer is released by the queue, but it is also retained for the client. Buffer ownership is thereby
				transferred from queue to client.  The client need not retain the buffer, but is responsible to release
				it when done with it.
	@result		The dequeued buffer.  Will be NULL if the queue is empty, or if the buffer to be dequeued is not yet ready.
*/
CM_EXPORT CMBufferRef CMBufferQueueDequeueIfDataReadyAndRetain(
	CMBufferQueueRef queue)		/*! @param queue
									The CMBufferQueue from which to dequeue a buffer (if the buffer is ready). */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
    @function   CMBufferQueueGetHead
    @abstract   Retrieves the next-to-dequeue buffer from a CMBufferQueue but leaves it in the queue.
    @discussion This follows CF "Get" semantics -- it does not retain the returned buffer.
    			Note that with non-FIFO queues it's not guaranteed that the next dequeue will return
    			this particular buffer (if an intervening Enqueue adds a buffer that will dequeue next).
	@result		The buffer.  Will be NULL if the queue is empty.
*/
CM_EXPORT CMBufferRef CMBufferQueueGetHead(
	CMBufferQueueRef queue)		/*! @param queue
									The CMBufferQueue from which to retrieve a buffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueIsEmpty
	@abstract	Returns whether or not a CMBufferQueue is empty.
	@result		Whether or not the CMBufferQueue is empty. If queue is NULL, true is returned.
*/
CM_EXPORT Boolean CMBufferQueueIsEmpty(
	CMBufferQueueRef queue)		/*! @param queue
									The CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueMarkEndOfData
	@abstract	Marks a CMBufferQueue with EOD.
	@discussion	All subsequent Enqueues will be rejected until CMBufferQueueReset is called.
				Subsequent Dequeues will succeed as long as the queue is not empty.
*/
CM_EXPORT OSStatus CMBufferQueueMarkEndOfData(
	CMBufferQueueRef queue)		/*! @param queue
									The CMBufferQueue being marked. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueContainsEndOfData
	@abstract	Returns whether or not a CMBufferQueue has been marked with EOD.
	@result		Whether or not the CMBufferQueue has been marked with EOD.
				If queue is NULL, true is returned (a NULL queue is considered to
				be empty, and permanently at EOD).
*/
CM_EXPORT Boolean CMBufferQueueContainsEndOfData(
	CMBufferQueueRef queue)		/*! @param queue
									The CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueIsAtEndOfData
	@abstract	Returns whether or not a CMBufferQueue has been marked with EOD, and is now empty.
	@result		Whether or not the CMBufferQueue has been marked with EOD, and is now empty.
				If queue is NULL, true is returned (a NULL queue is considered to
				be empty, and permanently at EOD).
*/
CM_EXPORT Boolean CMBufferQueueIsAtEndOfData(
	CMBufferQueueRef queue)		/*! @param queue
									The CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueReset
	@abstract	Resets a CMBufferQueue. Empties the queue, and clears any EOD mark.
	@discussion	All buffers in the queue are released.  Triggers are not removed, however,
				and will be called appropriately as the queue duration goes to zero.
*/
CM_EXPORT OSStatus CMBufferQueueReset(
	CMBufferQueueRef queue)		/*! @param queue
									The CMBufferQueue being reset. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueResetWithCallback
	@abstract	Calls a function for every buffer in a queue, then resets the queue.
*/
CM_EXPORT OSStatus
CMBufferQueueResetWithCallback(
	CMBufferQueueRef queue,	/*! @param queue
									CMBufferQueue being reset, that may contain multiple buffers. */
	void (*callback)( CMBufferRef buffer, void *refcon ),
								/*! @param callback
									Function to be called for each buffer.  
									The callback should not make other calls to the buffer queue. */
	void *refcon )				/*! @param refcon
									Refcon to be passed to the callback function. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueGetBufferCount
	@abstract	Gets the number of buffers in the queue.
*/
CM_EXPORT CMItemCount CMBufferQueueGetBufferCount(
	CMBufferQueueRef queue)		/*! @param queue
									CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueGetDuration
	@abstract	Gets the duration of a CMBufferQueue.
	@discussion	The duration of the CMBufferQueue is the sum of all the individual
				buffer durations, as reported by the getDuration callback (provided to
				CMBufferQueueCreate).  If there are no buffers in the queue,
				kCMTimeZero will be returned.
*/
CM_EXPORT CMTime CMBufferQueueGetDuration(
	CMBufferQueueRef queue)		/*! @param queue
									CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueGetMinDecodeTimeStamp
	@abstract	Gets the earliest decode timestamp of a CMBufferQueue.
	@discussion	The search for earliest decode timstamp is performed in this API.
				If you know your queue is in decode order, GetFirstDecodeTimeStamp
				is a faster alternative.  If the getDecodeTimeStamp callback is
				NULL, kCMTimeInvalid will be returned.
*/
CM_EXPORT CMTime CMBufferQueueGetMinDecodeTimeStamp(
	CMBufferQueueRef queue)		/*! @param queue
									CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueGetFirstDecodeTimeStamp
	@abstract	Gets the decode timestamp of the first buffer in a CMBufferQueue.
	@discussion	This API is is a faster alternative to GetMinDecodeTimeStamp,
				but only gives the same answer if your queue is in decode order.
				If the getDecodeTimeStamp callback is NULL, kCMTimeInvalid will
				be returned.
*/
CM_EXPORT CMTime CMBufferQueueGetFirstDecodeTimeStamp(
	CMBufferQueueRef queue)		/*! @param queue
									CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueGetMinPresentationTimeStamp
	@abstract	Gets the earliest presentation timestamp of a CMBufferQueue.
	@discussion	The search for earliest presentation timstamp is performed in
				this API. If you know your queue is sorted by presentation time,
				GetFirstPresentationTimeStamp is a faster alternative. If the
				getPresentationTimeStamp callback is NULL, kCMTimeInvalid will
				be returned.
*/
CM_EXPORT CMTime CMBufferQueueGetMinPresentationTimeStamp(
	CMBufferQueueRef queue)		/*! @param queue
									CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueGetFirstPresentationTimeStamp
	@abstract	Gets the decode timestamp of the first buffer in a CMBufferQueue.
	@discussion	This API is is a faster alternative to GetMinPresentationTimeStamp,
				but only works if you know your queue is sorted by presentation
				timestamp. If the getPresentationTimeStamp callback is NULL,
				kCMTimeInvalid will be returned.
*/
CM_EXPORT CMTime CMBufferQueueGetFirstPresentationTimeStamp(
	CMBufferQueueRef queue)		/*! @param queue
									CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMBufferQueueGetMaxPresentationTimeStamp
	@abstract	Gets the greatest presentation timestamp of a CMBufferQueue.
	@discussion	If the getPresentationTimeStamp callback is NULL, kCMTimeInvalid will
				be returned.
*/
CM_EXPORT CMTime CMBufferQueueGetMaxPresentationTimeStamp(
	CMBufferQueueRef queue)		/*! @param queue
									CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueGetEndPresentationTimeStamp
	@abstract	Gets the greatest end presentation timestamp of a CMBufferQueue.
	@discussion	This is the maximum end time (PTS + duration) of buffers in the queue.
				If the getPresentationTimeStamp callback is NULL, kCMTimeInvalid will
				be returned.
*/
CM_EXPORT CMTime CMBufferQueueGetEndPresentationTimeStamp(
	CMBufferQueueRef queue)		/*! @param queue
									CMBufferQueue being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@typedef	CMBufferQueueTriggerToken
	@abstract	A reference to a CMBufferQueueTrigger object.  It is not a CF type; do not CFRetain or CFRelease it.
	@discussion	A trigger is a callback function that the queue calls every time the triggering condition becomes true.
				Trigger conditions include things like queue duration, queue buffer count, etc.
				Trigger callbacks are called from within CMBufferQueue routines that modify the trigger condition
				(eg. Enqueue/Dequeue/Reset).
				
				Trigger callbacks cannot modify the queue that called them; they can, however, interrogate it.
				Trigger callbacks should not block waiting for other threads to modify or interrogate the queue either.
				In fact, trigger callbacks should perform as little processing as possible, preferably arranging
				for processing to occur by signalling a semaphore, rescheduling a runloop timer, calling dispatch_async(), etc.
				
				Clients can install as many triggers as they like.  The order in which they are called is non-deterministic.
				
				Triggers with a NULL callback are valid, since even though no trigger callback will be called, the
				trigger condition can still be explicitly tested.

				The CMBufferQueueTriggerToken is returned from CMBufferQueueInstallTrigger, so clients can remove
				it later if necessary.  Triggers will automatically be removed when the queue is finalized.  Note
				that if more than one module has access to a queue, it may be hard for an individual module to know
				when the queue is finalized since other modules may retain it.  To address this concern, modules
				should remove their triggers before they themselves are finalized.
*/
typedef struct opaqueCMBufferQueueTriggerToken *CMBufferQueueTriggerToken;

/*!
	@typedef	CMBufferQueueTriggerCallback
	@abstract	A callback to be called when a CMBufferQueue trigger condition becomes true.
*/
typedef void (*CMBufferQueueTriggerCallback)(
	void *triggerRefcon,						/*! @param triggerRefcon Refcon for trigger callback.  */
	CMBufferQueueTriggerToken triggerToken );	/*! @param triggerToken Trigger whose condition became true. */

/*!
	@enum		CMBufferQueueTriggerCondition
	@abstract	A condition to be associated with a CMBufferQueueTrigger.
	@constant	kCMBufferQueueTrigger_WhenDurationBecomesLessThan				Trigger fires when queue duration becomes < the specified duration.
	@constant	kCMBufferQueueTrigger_WhenDurationBecomesLessThanOrEqualTo		Trigger fires when queue duration becomes <= the specified duration.
	@constant	kCMBufferQueueTrigger_WhenDurationBecomesGreaterThan			Trigger fires when queue duration becomes > the specified duration.
	@constant	kCMBufferQueueTrigger_WhenDurationBecomesGreaterThanOrEqualTo	Trigger fires when queue duration becomes >= the specified duration.
	@constant	kCMBufferQueueTrigger_WhenMinPresentationTimeStampChanges		Trigger fires when minimum presentation timestamp changes (triggerTime is ignored).
	@constant	kCMBufferQueueTrigger_WhenMaxPresentationTimeStampChanges		Trigger fires when maximum presentation timestamp changes (triggerTime is ignored).
	@constant	kCMBufferQueueTrigger_WhenDataBecomesReady						Trigger fires when next dequeueable buffer becomes ready (ie, DequeueIfDataReadyAndRetain will now succeed).  (triggerTime is ignored.)
	@constant	kCMBufferQueueTrigger_WhenEndOfDataReached						Trigger fires when CMBufferQueueIsAtEndOfData's condition becomes true.  (triggerTime is ignored.)
	@constant	kCMBufferQueueTrigger_WhenReset									Trigger fires when CMBufferQueueReset called.  (triggerTime is ignored.)
	@constant	kCMBufferQueueTrigger_WhenBufferCountBecomesLessThan			Trigger fires when buffer count becomes < the specified threshold number.
	@constant	kCMBufferQueueTrigger_WhenBufferCountBecomesGreaterThan			Trigger fires when buffer count becomes > the specified threshold number.
*/
enum {
	kCMBufferQueueTrigger_WhenDurationBecomesLessThan = 1,
	kCMBufferQueueTrigger_WhenDurationBecomesLessThanOrEqualTo = 2,
	kCMBufferQueueTrigger_WhenDurationBecomesGreaterThan = 3,
	kCMBufferQueueTrigger_WhenDurationBecomesGreaterThanOrEqualTo = 4,
	kCMBufferQueueTrigger_WhenMinPresentationTimeStampChanges = 5,
	kCMBufferQueueTrigger_WhenMaxPresentationTimeStampChanges = 6,
	kCMBufferQueueTrigger_WhenDataBecomesReady = 7,
	kCMBufferQueueTrigger_WhenEndOfDataReached = 8,
	kCMBufferQueueTrigger_WhenReset = 9,
	kCMBufferQueueTrigger_WhenBufferCountBecomesLessThan = 10,
	kCMBufferQueueTrigger_WhenBufferCountBecomesGreaterThan = 11,
};
typedef int32_t CMBufferQueueTriggerCondition;

/*!
	@function	CMBufferQueueInstallTrigger
	@abstract	Installs a trigger on a CMBufferQueue.
	@discussion	The returned trigger token can be passed to CMBufferQueueTestTrigger and CMBufferQueueRemoveTrigger.
				The triggerTokenOut parameter can be NULL (client doesn't need to test or remove trigger), and the
				triggerCallback parameter can be NULL (client doesn't need callbacks, but rather will explicitly
				test the trigger).  One of these two parameters must be non-NULL, however, since an untestable
				trigger that does not perform a callback is meaningless.  If the trigger condition is already true,
				CMBufferQueueInstallTrigger will call the triggerCallback.  If it does this, it will first write
				the trigger token to *triggerTokenOut.
*/
CM_EXPORT OSStatus CMBufferQueueInstallTrigger(
	CMBufferQueueRef queue,								/*! @param queue
															CMBufferQueue on which the trigger is being set. */
	CMBufferQueueTriggerCallback triggerCallback,		/*! @param triggerCallback
															Callback to be called when the trigger condition becomes true.
															Can be NULL, if client intends only to explicitly test the
															condition.  Cannot be NULL if triggerTokenOut is NULL,
															since then the trigger would be meaningless. */
	void *triggerRefcon,								/*! @param triggerRefcon
															Refcon to be passed to the triggerCallback.
															Can be NULL if the callback doesn't need it, or is
															itself NULL. */
	CMBufferQueueTriggerCondition triggerCondition,		/*! @param triggerCondition
															The condition to be tested when evaluating the trigger. */
	CMTime triggerTime,									/*! @param triggerTime
															The time value to compare against when evaluating the trigger.  
															Must be numeric (ie. not invalid, indefinite, or infinite), 
															except for certain trigger conditions which ignore it 
															(eg, kCMBufferQueueTrigger_WhenMinPresentationTimeStampChanges). */
	CMBufferQueueTriggerToken *triggerTokenOut )		/*! @param triggerTokenOut
															Address where created trigger token will be written.
															Can be NULL, if client has no need to explicitly test
															or remove the trigger. Cannot be NULL if triggerCallback
															is NULL, since then the trigger would be meaningless. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueInstallTriggerWithIntegerThreshold
	@abstract	Installs a trigger on a CMBufferQueue.
	@discussion	This function behaves the same way as CMBufferQueueInstallTrigger() except the trigger is evaluated against
				the integer value rather than the time value.
*/
CM_EXPORT OSStatus CMBufferQueueInstallTriggerWithIntegerThreshold(
	CMBufferQueueRef queue,								/*! @param queue
															CMBufferQueue on which the trigger is being set. */
	CMBufferQueueTriggerCallback triggerCallback,		/*! @param triggerCallback
															Callback to be called when the trigger condition becomes true.
															Can be NULL, if client intends only to explicitly test the
															condition.  Cannot be NULL if triggerTokenOut is NULL,
															since then the trigger would be meaningless. */
	void *triggerRefcon,								/*! @param triggerRefcon
															Refcon to be passed to the triggerCallback.
															Can be NULL if the callback doesn't need it, or is
															itself NULL. */
	CMBufferQueueTriggerCondition triggerCondition,		/*! @param triggerCondition
															The condition to be tested when evaluating the trigger.
															Must be a valid condition for an integer threshold. */
	CMItemCount triggerThreshold,						/*! @param triggerThreshold
															The integer value to compare against when evaluating the trigger. */
	CMBufferQueueTriggerToken *triggerTokenOut )		/*! @param triggerTokenOut
															Address where created trigger token will be written.
															Can be NULL, if client has no need to explicitly test
															or remove the trigger. Cannot be NULL if triggerCallback
															is NULL, since then the trigger would be meaningless. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueRemoveTrigger
	@abstract	Removes a previously installed trigger from a CMBufferQueue.
	@discussion	Triggers will automatically be removed when a queue is finalized.  However, if more
				than one module has access to a queue, it may be hard for an individual module to know
				when the queue is finalized since other modules may retain it.  To address this concern,
				modules should remove their triggers before they themselves are finalized.
*/
CM_EXPORT OSStatus CMBufferQueueRemoveTrigger(
	CMBufferQueueRef queue,						/*! @param queue
													CMBufferQueue from which the trigger is to be removed. */
	CMBufferQueueTriggerToken triggerToken )	/*! @param triggerToken
													Trigger to remove from the queue. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueTestTrigger
	@abstract	Tests whether the trigger condition is true.
	@discussion	Whereas the trigger callback will only be called when the condition goes from false
				to true, CMBufferQueueTestTrigger always returns the condition's current status.
				The triggerToken must be one that has been installed on this queue.
*/
CM_EXPORT Boolean CMBufferQueueTestTrigger(
	CMBufferQueueRef queue,						/*! @param queue
													CMBufferQueue on which the trigger is to be tested. */
	CMBufferQueueTriggerToken triggerToken )	/*! @param triggerToken
													Trigger to test. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBufferQueueCallForEachBuffer
	@abstract	Calls a function for every buffer in a queue.
	@discussion If the callback function returns an error, iteration will stop immediately
				and the error will be returned.
*/
CM_EXPORT OSStatus
CMBufferQueueCallForEachBuffer(
	CMBufferQueueRef queue,		/*! @param queue
									CMBufferQueue that may contain multiple buffers. */
	OSStatus (*callback)( CMBufferRef buffer, void *refcon ),
								/*! @param callback
									Function to be called for each buffer.  
									The callback may modify buffer attachments but should not modify sort-affecting 
									properties (eg, timestamps).
									The callback should not make other calls to the buffer queue. */
	void *refcon )				/*! @param refcon
									Refcon to be passed to the callback function. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@typedef	CMBufferValidationCallback
	@abstract	Tests whether a buffer is OK to add to a queue.
	@discussion
		CMBufferQueueEnqueue will call this function to validate buffers.
		Return noErr if the buffer is OK to add.  
		Return a nonzero error code if the buffer should be rejected; 
		CMBufferQueueEnqueue will return this error to the caller.
		If you do not have a more descriptive error code, use kCMBufferQueueError_InvalidBuffer.
*/
typedef OSStatus (*CMBufferValidationCallback)( CMBufferQueueRef queue, CMBufferRef buf, void *validationRefCon );

/*!
	@function	CMBufferQueueSetValidationCallback
	@abstract	Sets a function that CMBufferQueueEnqueue will call to validate buffers before adding them to the queue.
*/
CM_EXPORT OSStatus CMBufferQueueSetValidationCallback( 
		CMBufferQueueRef queue,							/*! @param queue
															CMBufferQueue that will use the validation callback. */
		CMBufferValidationCallback validationCallback,	/*! @param validationCallback
															Callback that will validate each buffer enqueued. */
		void *validationRefCon )						/*! @param validationRefCon
															Context refcon for validation callback. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#pragma pack(pop)
    
#ifdef __cplusplus
}
#endif

#endif // CMBUFFERQUEUE_H
