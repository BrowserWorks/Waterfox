/*
	File:  CMMemoryPool.h
 
	Framework:  CoreMedia
 
	Copyright 2006-2012 Apple Inc. All rights reserved.
 
*/

#ifndef CMMEMORYPOOL_H
#define CMMEMORYPOOL_H

#include <CoreFoundation/CoreFoundation.h>
#include <CoreMedia/CMBase.h>

#ifdef __cplusplus
extern "C" {
#endif

/*!
	@header		CMMemoryPool.h
	@abstract	Memory pool for optimizing repeated large block allocation.
	@discussion
		CMMemoryPool is a memory allocation service that holds onto a pool of
		recently deallocated memory so as to speed up subsequent allocations of the same size.  
		It's intended for cases where large memory blocks need to be repeatedly allocated --
		for example, the compressed data output by a video encoder.
		
		All of its allocations are on the granularity of page sizes; it does not suballocate
		memory within pages, so it is a poor choice for allocating tiny blocks.
		For example, it's appropriate to use as the blockAllocator argument to
		CMBlockBufferCreateWithMemoryBlock, but not the structureAllocator argument --
		use kCFAllocatorDefault instead.

		When you no longer need to allocate memory from the pool, call CMMemoryPoolInvalidate
		and CFRelease.  Calling CMMemoryPoolInvalidate tells the pool to stop holding onto
		memory for reuse.  Note that the pool's CFAllocator can outlive the pool, owing
		to the way that CoreFoundation is designed: CFAllocators are themselves CF objects,
		and every object allocated with a CFAllocator implicitly retains the CFAllocator 
		until it is finalized.  After the CMMemoryPool is invalidated or finalized,
		its CFAllocator allocates and deallocates with no pooling behavior.
		
		CMMemoryPool deallocates memory if it has not been recycled in 0.5 second,
		so that short-term peak usage does not cause persistent bloat.
		(This period may be overridden by specifying kCMMemoryPoolOption_AgeOutPeriod.)
		Such "aging out" is done during the pool's CFAllocatorAllocate and
		CFAllocatorDeallocate methods.
*/

typedef struct OpaqueCMMemoryPool *CMMemoryPoolRef; // a CF type; use CFRetain and CFRelease.

CM_EXPORT CFTypeID CMMemoryPoolGetTypeID(void)
						__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@const		kCMMemoryPoolOption_AgeOutPeriod
	@abstract	Specifies how long memory should be allowed to hang out in the pool before being deallocated.
	@discussion	Pass this in the options dictionary to CMMemoryPoolCreate.
*/
CM_EXPORT const CFStringRef kCMMemoryPoolOption_AgeOutPeriod // CFNumber (seconds)
								__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMMemoryPoolCreate
	@abstract	Creates a new CMMemoryPool.
*/
CM_EXPORT CMMemoryPoolRef CMMemoryPoolCreate( CFDictionaryRef options ) // pass NULL for defaults
								__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMMemoryPoolGetAllocator
	@abstract	Returns the pool's CFAllocator.
*/
CM_EXPORT CFAllocatorRef CMMemoryPoolGetAllocator( CMMemoryPoolRef pool )
								__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMMemoryPoolFlush
	@abstract	Deallocates all memory the pool was holding for recycling.
*/
CM_EXPORT void CMMemoryPoolFlush( CMMemoryPoolRef pool )
					__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

/*!
	@function	CMMemoryPoolInvalidate
	@abstract	Stops the pool from recycling.
	@discussion
		When CMMemoryPoolInvalidate is called the pool's allocator stops recycling memory.
		The pool deallocates any memory it was holding for recycling.
		This also happens when the retain count of the CMMemoryPool drops to zero, 
		except that under GC it may be delayed.
*/
CM_EXPORT void CMMemoryPoolInvalidate( CMMemoryPoolRef pool )
					__OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_6_0);

#ifdef __cplusplus
}
#endif

#endif // CMMEMORYPOOL_H
