/*
	File:  CMSimpleQueue.h
	
	Framework:  CoreMedia
 
    Copyright 2006-2012 Apple Inc. All rights reserved.
  
*/

#ifndef CMSIMPLEQUEUE_H
#define CMSIMPLEQUEUE_H

/*!
	@header
	@abstract	API for creating and using CMSimpleQueues.
	@discussion	CMSimpleQueues are CF-based objects that implement a simple lockless FIFO queue of (void *)
				elements. The elements are not assumed to be pointers; they could be simple pointer-sized
				numeric values (although NULL or 0-valued elements are not allowed). If the elements are
				in fact pointers to allocated memory buffers, buffer lifetime management must be handled
				externally.
				
				A CMSimpleQueue can safely handle one enqueueing thread and one dequeueing thread.
				
				CMSimpleQueues are lockless. As such, Enqueues and/or Dequeues can occur on the CoreAudio ioProc
				thread, where locking/blocking is forbidden.
				
				The current status of a CMSimpleQueue can be interrogated.  Clients can get the current number
				of elements in the queue (GetCount) as well as the maximum capacity of the queue (GetCapacity).
				There is also a convenience macro (GetFullness) that uses those two APIs to compute a Float32
				between 0.0 and 1.0, representing the fullness of the queue.  For example, 0.0 represents an
				empty queue, 0.5 represents a queue that is half-full, and 1.0 represents a full queue.
				
				CMSimpleQueues can be reset. This returns them to a newly created state, with no elements in the queue
				(but with the maximum capacity unchanged).
*/

#include <CoreMedia/CMBase.h>

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma pack(push, 4)

//=============================================================================
//	Errors
//=============================================================================

/*!
	@enum CMSimpleQueue Errors
	@discussion The OSStatus errors returned from the CMSimpleQueue APIs.
	@constant	kCMSimpleQueueError_AllocationFailed			An allocation failed.
	@constant	kCMSimpleQueueError_RequiredParameterMissing	NULL or 0 was passed for a required parameter.
	@constant	kCMSimpleQueueError_ParameterOutOfRange			An out-of-range value was passed for a parameter with a restricted valid range.
	@constant	kCMSimpleQueueError_QueueIsFull					Operation failed because queue was full.
*/
enum {
	kCMSimpleQueueError_AllocationFailed					= -12770,
	kCMSimpleQueueError_RequiredParameterMissing			= -12771,
	kCMSimpleQueueError_ParameterOutOfRange					= -12772,
	kCMSimpleQueueError_QueueIsFull							= -12773,
};

//=============================================================================
//	Types
//=============================================================================

/*!
	@typedef	CMSimpleQueueRef
	@abstract	A reference to a CMSimpleQueue, a CF object that implements a simple lockless queue of (void *) elements.
		
*/
typedef struct opaqueCMSimpleQueue *CMSimpleQueueRef;

//=============================================================================

/*!
	@function	CMSimpleQueueGetTypeID
	@abstract	Returns the CFTypeID of CMSimpleQueue objects.
	@discussion	You can check if a CFTypeRef object is actually a CMSimpleQueue by comparing CFGetTypeID(object)
				with CMSimpleQueueGetTypeID().
	@result		CFTypeID of CMSimpleQueue objects.
*/
CM_EXPORT
CFTypeID CMSimpleQueueGetTypeID(void)
			__OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

/*!
	@function	CMSimpleQueueCreate
    @abstract	Creates a CMSimpleQueue.
    @discussion On return, the caller owns the returned CMSimpleQueue, and must release it when done with it.
    @result		Returns noErr if the call succeeds.  Returns kCMSimpleQueueError_ParameterOutOfRange if
				capacity is negative.
*/
CM_EXPORT
OSStatus CMSimpleQueueCreate(
	CFAllocatorRef allocator,		/*! @param allocator
										Allocator used to allocate storage for the queue. */
	int32_t capacity,				/*! @param capacity
										Capacity of the queue (maximum number of elements holdable at any
										given time).  Required (must not be 0).  Must be a positive value. */
	CMSimpleQueueRef *queueOut) 	/*! @param queueOut Returned newly created queue is written to this address.
										Must not be NULL. */
		__OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

/*!
	@function	CMSimpleQueueEnqueue
    @abstract	Enqueues an element on the queue.
    @discussion	If the queue is full, this operation will fail.
	@result		Returns noErr if the call succeeds, kCMSimpleQueueError_QueueIsFull if the queue is full.
*/
CM_EXPORT
OSStatus CMSimpleQueueEnqueue(
	CMSimpleQueueRef queue,		/*! @param queue
									The queue on which to enqueue the element. Must not be NULL. */
	const void *element)		/*! @param element
									Element to enqueue. Must not be NULL (NULL is returned from Dequeue
									to indicate an empty queue). */
		__OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

/*!
	@function	CMSimpleQueueDequeue
    @abstract	Dequeues an element from the queue.
    @discussion If the queue is empty, NULL will be returned.
	@result		The dequeued element.  NULL if the queue was empty, or if there was some other error.
*/
CM_EXPORT
const void *CMSimpleQueueDequeue(
	CMSimpleQueueRef queue) 	/*! @param queue
									The queue from which to dequeue an element. Must not be NULL. */
		__OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

/*!
	@function	CMSimpleQueueGetHead
    @abstract	Returns the element at the head of the queue.
    @discussion If the queue is empty, NULL will be returned.
	@result		The head element.  NULL if the queue was empty, or if there was some other error.
*/
CM_EXPORT
const void *CMSimpleQueueGetHead(
	CMSimpleQueueRef queue) 	/*! @param queue
									The queue from which to get the head element. Must not be NULL. */
		__OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

/*!
	@function	CMSimpleQueueReset
    @abstract	Resets the queue.
    @discussion	This function resets the queue to its empty state;  all values
				in the queue prior to reset are lost.   Note that CMSimpleQueueReset
				is not synchronized in any way, so the reader thread and writer thread
				must be held off by the client during this operation.
	@result		Returns noErr if the call succeeds.
*/
CM_EXPORT
OSStatus CMSimpleQueueReset(
	CMSimpleQueueRef queue) 	/*! @param queue
									The queue to reset. Must not be NULL. */
		__OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

/*!
	@function	CMSimpleQueueGetCapacity
    @abstract	Returns the number of elements that can be held in the queue.
	@result		The number of elements that can be held in the queue.  Returns
				0 if there is an error.
*/
CM_EXPORT
int32_t CMSimpleQueueGetCapacity(
	CMSimpleQueueRef queue) 	/*! @param queue
									The queue being interrogated. Must not be NULL. */
		__OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

/*!
	@function	CMSimpleQueueGetCount
    @abstract	Returns the number of elements currently on the queue.
	@result		The number of elements currently in the queue. Returns 0 if there is an error.
*/
CM_EXPORT
int32_t CMSimpleQueueGetCount(
	CMSimpleQueueRef queue) 	/*! @param queue
									The queue being interrogated. Must not be NULL. */
		__OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

/*!
	@define		CMSimpleQueueGetFullness
	A convenience macro that returns GetCount/GetCapacity, computed in floating point.  0.0 is empty, 0.5 is half full, 1.0 is full.
	Returns 0.0 if there is an error (eg. if queue is NULL).
*/
#define CMSimpleQueueGetFullness(queue) ( CMSimpleQueueGetCapacity(queue) ? \
											( ((Float32)CMSimpleQueueGetCount(queue)) / ((Float32)CMSimpleQueueGetCapacity(queue)) ) \
											: 0.0f )

#pragma pack(pop)
    
#if defined(__cplusplus)
}
#endif

#endif // ! CMSIMPLEQUEUE_H
