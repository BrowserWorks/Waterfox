/*
    File:  CMBlockBuffer.h
 
	Framework:  CoreMedia

    Copyright 2005-2012 Apple Inc. All rights reserved.

*/

#ifndef CMBLOCKBUFFER_H
#define CMBLOCKBUFFER_H

/*!
	@header	CMBlockBuffer.h
	@abstract	API for creating and manipulating BlockBuffers
	@discussion	BlockBuffers are CF objects that are used to move blocks of memory through a processing system.
	A CMBlockBuffer represents a contiguous range of data offsets, from zero to CMBlockBufferGetDataLength(), across a
	possibly noncontiguous memory region composed of memoryBlocks and buffer references which in turn could
	refer to addtional regions.
	<BR>
	IMPORTANT: Clients of CMBlockBuffer must explicitly manage the retain count by 
	calling CFRetain and CFRelease even in processes using garbage collection.  
	<BR>
	Objective-C code that may run under garbage collection should NOT use [bbuf retain],
	or [bbuf release]; these will not have the correct effect.
	<BR>
	Furthermore, if they may run under garbage collection, Objective-C objects that release 
	instance variable CMBlockBuffer objects during their -finalize methods should set those 
	object pointers to NULL immediately afterwards, to ensure that method calls received 
	after -finalize operate safely.
*/

#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMAttachment.h>
#include <CoreFoundation/CoreFoundation.h>

#ifdef __cplusplus
extern "C" {
#endif

#pragma pack(push, 4)

/*!
	@enum CMBlockBuffer Errors
	@discussion The errors returned from the CMBlockBuffer APIs
	@constant	kCMBlockBufferNoErr Success
	@constant	kCMBlockBufferStructureAllocationFailedErr Returned when a CMBlockBuffer-creating API gets a failure
				from the CFAllocator provided for CMBlockBuffer construction.
	@constant	kCMBlockBufferBlockAllocationFailedErr Returned when the allocator provided to allocate a memory block
				(as distinct from CMBlockBuffer structures) fails.
	@constant	kCMBlockBufferBadCustomBlockSourceErr The custom block source’s Allocate() routine was NULL when an allocation was attempted.
	@constant	kCMBlockBufferBadOffsetParameterErr The offset provided to an API is out of the range of the relevent CMBlockBuffer.
	@constant	kCMBlockBufferBadLengthParameterErr The length provided to an API is out of the range of the relevent CMBlockBuffer,
				or is not allowed to be zero.
	@constant	kCMBlockBufferBadPointerParameterErr	A pointer parameter (e.g. CMBlockBuffer reference, destination memory) is NULL
				or otherwise invalid.
	@constant	kCMBlockBufferEmptyBBufErr	Expected a non-empty CMBlockBuffer.
	@constant	kCMBlockBufferUnallocatedBlockErr	An unallocated memory block was encountered.
*/
enum {
	kCMBlockBufferNoErr							= 0,
	kCMBlockBufferStructureAllocationFailedErr	= -12700,
	kCMBlockBufferBlockAllocationFailedErr		= -12701,
	kCMBlockBufferBadCustomBlockSourceErr		= -12702,
	kCMBlockBufferBadOffsetParameterErr			= -12703,
	kCMBlockBufferBadLengthParameterErr			= -12704,
	kCMBlockBufferBadPointerParameterErr		= -12705,
	kCMBlockBufferEmptyBBufErr					= -12706,
	kCMBlockBufferUnallocatedBlockErr			= -12707,
};

/*!
	@enum CMBlockBuffer Flags
	@discussion Flags controlling behaviors and features of CMBlockBuffer APIs
	@constant kCMBlockBufferAssureMemoryNowFlag When passed to routines that accept block allocators, causes the memory block
				to be allocated immediately.
	@constant kCMBlockBufferAlwaysCopyDataFlag Used with CMBlockBufferCreateContiguous() to cause it to always produce an allocated
				copy of the desired data.
	@constant kCMBlockBufferDontOptimizeDepthFlag Passed to CMBlockBufferAppendBufferReference() and CMBlockBufferCreateWithBufferReference()
				to suppress reference depth optimization
	@constant kCMBlockBufferPermitEmptyReferenceFlag Passed to CMBlockBufferAppendBufferReference() and CMBlockBufferCreateWithBufferReference()
				to allow references into a CMBlockBuffer that may not yet be populated.
*/
enum {
	kCMBlockBufferAssureMemoryNowFlag		= (1L<<0),
	kCMBlockBufferAlwaysCopyDataFlag		= (1L<<1),
	kCMBlockBufferDontOptimizeDepthFlag		= (1L<<2),
	kCMBlockBufferPermitEmptyReferenceFlag	= (1L<<3)
};

/*!
	@typedef CMBlockBufferFlags
	Type used for parameters containing CMBlockBuffer feature and control flags
*/
typedef uint32_t CMBlockBufferFlags;

/*!
	@typedef CMBlockBufferRef
	A reference to a CMBlockBuffer, a CF object that adheres to retain/release semantics. When CFRelease() is performed
	on the last reference to the CMBlockBuffer, any referenced BlockBuffers are released and eligible memory blocks are
	deallocated. These operations are recursive, so one release could result in many follow on releses.
*/
typedef struct OpaqueCMBlockBuffer *CMBlockBufferRef;

/*!
	@typedef CMBlockBufferCustomBlockSource
	Used with functions that accept a memory block allocator, this structure allows a client to provide a custom facility for
	obtaining the memory block to be used in a CMBlockBuffer. The Allocate function must be non-zero if the CMBlockBuffer code will
	need to call for allocation (not required if a previously-obtained memory block is provided to the CMBlockBuffer API). The
	Free() routine, if non-NULL, will be called once when the CMBlockBuffer is disposed. It will not be called if no memory block
	is ever allocated or supplied. The refCon will be passed to both the Allocate and Free() calls. The client is responsible for
	its disposal (if any) during the Free() callback.
*/
typedef  struct {
	uint32_t	version;
	void		*(*AllocateBlock)(void *refCon, size_t sizeInBytes);
	void		(*FreeBlock)(void *refCon, void *doomedMemoryBlock, size_t sizeInBytes);
	void		*refCon;
} CMBlockBufferCustomBlockSource;

enum {
	kCMBlockBufferCustomBlockSourceVersion = 0
};

/*! 
 @functiongroup CMBlockBuffer creation and assembly functions
*/

/*!
	@function	CMBlockBufferCreateEmpty
	
	@abstract	Creates an empty CMBlockBuffer
	@discussion	Creates an empty CMBlockBuffer, i.e. one which has no memory block nor reference to a CMBlockBuffer
				supplying bytes to it. It is ready to be populated using CMBlockBufferAppendMemoryBlock()
				and/or CMBlockBufferAppendBufferReference(). CMBlockBufferGetDataLength() will return zero for
				an empty CMBlockBuffer and CMBlockBufferGetDataPointer() and CMBlockBufferAssureBufferMemory() will fail.
				The memory for the CMBlockBuffer object will be allocated using the given allocator.
				If NULL is passed for the allocator, the default allocator is used.

	@param	structureAllocator	Allocator to use for allocating the CMBlockBuffer object. NULL will cause the
								default allocator to be used.
	@param	subBlockCapacity	Number of subBlocks the newBlockBuffer shall accommodate before expansion occurs.
								A value of zero means "do the reasonable default"
	@param	flags				Feature and control flags
	@param	newBBufOut			Receives newly-created empty CMBlockBuffer object with retain count of 1. Must not be  NULL.
	
	@result	Returns kCMBlockBufferNoErr if successful.
*/
CM_EXPORT OSStatus	CMBlockBufferCreateEmpty(
		CFAllocatorRef structureAllocator, 
		uint32_t subBlockCapacity, 
		CMBlockBufferFlags flags, 
		CMBlockBufferRef *newBBufOut)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferCreateWithMemoryBlock
	
	@abstract	Creates a new CMBlockBuffer backed by a memory block (or promise thereof). 
	@discussion Creates a new CMBlockBuffer backed by a memory block. The memory block may be statically allocated, dynamically allocated
	using the given allocator (or customBlockSource) or not yet allocated. The returned CMBlockBuffer may be further expanded using
	CMBlockBufferAppendMemoryBlock() and/or CMBlockBufferAppendBufferReference(). 

	If the kCMBlockBufferAssureMemoryNowFlag is set in the flags parameter, the memory block is allocated immediately using the blockAllocator or
	customBlockSource. 
				
	@param	structureAllocator	Allocator to use for allocating the CMBlockBuffer object. NULL will cause the
								default allocator to be used.
	@param	memoryBlock			Block of memory to hold buffered data. If NULL, a memory block will be allocated when needed (via a call
								to CMBlockBufferAssureBlockMemory()) using the provided blockAllocator or customBlockSource. If non-NULL,
								the block will be used and will be deallocated when the new CMBlockBuffer is finalized (i.e. released for
								the last time).
	@param	blockLength			Overall length of the memory block in bytes. Must not be zero. This is the size of the
								supplied memory block or the size to allocate if memoryBlock is NULL.
	@param	blockAllocator		Allocator to be used for allocating the memoryBlock, if memoryBlock is NULL. If memoryBlock is non-NULL,
								this allocator will be used to deallocate it if provided. Passing NULL will cause the default allocator
								(as set at the time of the call) to be used. Pass kCFAllocatorNull if no deallocation is desired.
	@param	customBlockSource	If non-NULL, it will be used for the allocation and freeing of the memory block (the blockAllocator
								parameter is ignored). If provided, and the memoryBlock parameter is NULL, its Allocate() routine must
								be non-NULL. Allocate will be called once, if successful, when the memoryBlock is allocated. Free() will
								be called once when the CMBlockBuffer is disposed.
	@param	offsetToData		Offset within the memoryBlock at which the CMBlockBuffer should refer to data.
	@param	dataLength			Number of relevant data bytes, starting at offsetToData, within the memory block.
	@param	flags				Feature and control flags
	@param	newBBufOut			Receives newly-created CMBlockBuffer object with a retain count of 1. Must not be  NULL.

	@result	Returns kCMBlockBufferNoErr if successful.
*/
CM_EXPORT OSStatus	CMBlockBufferCreateWithMemoryBlock(
		CFAllocatorRef structureAllocator, 
		void *memoryBlock, 
		size_t blockLength,
		CFAllocatorRef blockAllocator, 
		const CMBlockBufferCustomBlockSource *customBlockSource,
		size_t offsetToData, 
		size_t dataLength,
		CMBlockBufferFlags flags, 
		CMBlockBufferRef *newBBufOut)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferCreateWithBufferReference
	
	@abstract	Creates a new CMBlockBuffer that refers to another CMBlockBuffer.
	@discussion Creates a new CMBlockBuffer that refers to (a possibly subset portion of) another CMBlockBuffer.
				The returned CMBlockBuffer may be further expanded using CMBlockBufferAppendMemoryBlock() and/or CMBlockBufferAppendBufferReference(). 

	@param	structureAllocator	Allocator to use for allocating the CMBlockBuffer object. NULL will cause the
								default allocator to be used.
	@param	targetBuffer		CMBlockBuffer to refer to. This parameter must not be NULL. Unless the kCMBlockBufferPermitEmptyReferenceFlag
								is passed, it must not be empty and it must have a data length at least large enough to supply the data subset
								specified (i.e. offsetToData+dataLength bytes).
	@param	offsetToData		Offset within the target CMBlockBuffer at which the new CMBlockBuffer should refer to data.
	@param	dataLength			Number of relevant data bytes, starting at offsetToData, within the target CMBlockBuffer.
	@param	flags				Feature and control flags
	@param	newBBufOut			Receives newly-created CMBlockBuffer object with a retain count of 1. Must not be  NULL.

	@result	Returns kCMBlockBufferNoErr if successful.
*/
CM_EXPORT OSStatus	CMBlockBufferCreateWithBufferReference(
		CFAllocatorRef structureAllocator, 
		CMBlockBufferRef targetBuffer, 
		size_t offsetToData,
		size_t dataLength, 
		CMBlockBufferFlags flags, 
		CMBlockBufferRef *newBBufOut)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferCreateContiguous
	
	@abstract	Produces a CMBlockBuffer containing a contiguous copy of or reference to the data specified by the parameters.
	@discussion	Produces a CMBlockBuffer containing a contiguous copy of or reference to the data specified by the parameters.
				The resulting new CMBlockBuffer may contain an allocated copy of the data, or may contain a contiguous CMBlockBuffer reference. 

				If the kCMBlockBufferAlwaysCopyDataFlag is set in the flags parameter, the resulting CMBlockBuffer will contain an allocated
				copy of the data rather than a reference to theSourceBuffer. 

	@param	structureAllocator	Allocator to use for allocating the CMBlockBuffer object. NULL will cause the
								default allocator to be used.
	@param	theSourceBuffer		CMBlockBuffer from which data will be copied or referenced. Must not be NULL nor empty,
	@param	blockAllocator		Allocator to be used for allocating the memoryBlock if a contiguous copy of the data is to be made. Passing NULL will cause the default
								allocator (as set at the time of the call) to be used.
	@param	customBlockSource	If non-NULL, it will be used for the allocation and freeing of the memory block (the blockAllocator
								parameter is ignored). If provided, and the memoryBlock parameter is NULL, its Allocate() routine must
								be non-NULL. Allocate will be called once, if successful, when the memoryBlock is allocated. Free() will
								be called once when the CMBlockBuffer is disposed.
	@param	offsetToData		Offset within the source CMBlockBuffer at which the new CMBlockBuffer should obtain data.
	@param	dataLength			Number of relevant data bytes, starting at offsetToData, within the source CMBlockBuffer. If zero, the
								target buffer's total available dataLength (starting at offsetToData) will be referenced.
	@param	flags				Feature and control flags
	@param	newBBufOut			Receives newly-created CMBlockBuffer object with a retain count of 1. Must not be  NULL.
	
	@result	Returns kCMBlockBufferNoErr if successful
*/
CM_EXPORT OSStatus	CMBlockBufferCreateContiguous(
		CFAllocatorRef structureAllocator, 
		CMBlockBufferRef sourceBuffer, 
		CFAllocatorRef blockAllocator,
		const CMBlockBufferCustomBlockSource *customBlockSource,
		size_t offsetToData, 
		size_t dataLength, 
		CMBlockBufferFlags flags, 
		CMBlockBufferRef *newBBufOut)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMBlockBufferGetTypeID
	
	@abstract	Obtains the CoreFoundation type ID for the CMBlockBuffer type.
	@discussion	Obtains the CoreFoundation type ID for the CMBlockBuffer type.
	
	@result	Returns the CFTypeID corresponding to CMBlockBuffer.
*/
CM_EXPORT CFTypeID CMBlockBufferGetTypeID(void) __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferAppendMemoryBlock
	
	@abstract	Adds a memoryBlock to an existing CMBlockBuffer.
	@discussion	Adds a memoryBlock to an existing CMBlockBuffer. The memory block may be statically allocated,
				dynamically allocated using the given allocator or not yet allocated. The CMBlockBuffer's total
				data length will be increased by the specified dataLength. 

				If the kCMBlockBufferAssureMemoryNowFlag is set in the flags parameter, the memory block is
				allocated immediately using the blockAllocator or customBlockSource. Note that append operations
				are not thread safe, so care must be taken when appending to BlockBuffers that are used by multiple threads.

	@param	theBuffer		CMBlockBuffer to which the new memoryBlock will be added. Must not be NULL
	@param	memoryBlock		Block of memory to hold buffered data. If NULL, a memory block will be allocated when needed
							(via a call to CMBlockBufferAssureBlockMemory()) using the provided blockAllocator or customBlockSource.
							If non-NULL, the block will be used and will be deallocated when the CMBlockBuffer is finalized (i.e. released
							for the last time).
	@param	blockLength		Overall length of the memory block in bytes. Must not be zero. This is the size of the supplied
							memory block or the size to allocate if memoryBlock is NULL.
	@param	blockAllocator	Allocator to be used for allocating the memoryBlock, if memoryBlock is NULL. If memoryBlock is
							non-NULL, this allocator will be used to deallocate it if provided. Passing NULL will cause
							the default allocator (as set at the time of the call) to be used. Pass kCFAllocatorNull if no
							deallocation is desired.
	@param	customBlockSource	If non-NULL, it will be used for the allocation and freeing of the memory block (the blockAllocator
								parameter is ignored). If provided, and the memoryBlock parameter is NULL, its Allocate() routine must
								be non-NULL. Allocate will be called once, if successful, when the memoryBlock is allocated. Free() will
								be called once when the CMBlockBuffer is disposed.
	@param	offsetToData	Offset within the memoryBlock at which the CMBlockBuffer should refer to data.
	@param	dataLength		Number of relevant data bytes, starting at offsetToData, within the memory block.
	@param	flags			Feature and control flags

	@result	Returns kCMBlockBufferNoErr if successful.
*/
CM_EXPORT OSStatus	CMBlockBufferAppendMemoryBlock(
		CMBlockBufferRef theBuffer, 
		void *memoryBlock, 
		size_t blockLength, 
		CFAllocatorRef blockAllocator,
		const CMBlockBufferCustomBlockSource *customBlockSource,
		size_t offsetToData, 
		size_t dataLength, 
		CMBlockBufferFlags flags)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferAppendBufferReference
	
	@abstract	Adds a CMBlockBuffer reference to an existing CMBlockBuffer.
	@discussion	Adds a buffer reference to (a possibly subset portion of) another CMBlockBuffer to an existing CMBlockBuffer.
				The CMBlockBuffer's total data length will be increased by the specified dataLength. Note that append operations
				are not thread safe, so care must be taken when appending to BlockBuffers that are used by multiple threads.

	@param	theBuffer		CMBlockBuffer to which the new CMBlockBuffer reference will be added. Must not be NULL
	@param	targetBuffer	CMBlockBuffer to refer to. This parameter must not be NULL. Unless the kCMBlockBufferPermitEmptyReferenceFlag
							is passed, it must not be empty and it must have a data length at least large enough to supply the data subset
							specified (i.e. offsetToData+dataLength bytes).
	@param	offsetToData	Offset within the target CMBlockBuffer at which the CMBlockBuffer should refer to data.
	@param	dataLength		Number of relevant data bytes, starting at offsetToData, within the target CMBlockBuffer. If zero, the target
							buffer's total available dataLength (starting at offsetToData) will be referenced.
	@param	flags			Feature and control flags

	@result	Returns kCMBlockBufferNoErr if successful.
*/
CM_EXPORT OSStatus	CMBlockBufferAppendBufferReference(
		CMBlockBufferRef theBuffer, 
		CMBlockBufferRef targetBBuf, 
		size_t offsetToData, 
		size_t dataLength, 
		CMBlockBufferFlags flags)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferAssureBlockMemory
	
	@abstract	Assures all memory blocks in a CMBlockBuffer are allocated.
	@discussion	Traverses the possibly complex CMBlockBuffer, allocating the memory for any constituent
				memory blocks that are not yet allocated.

	@param	theBuffer		CMBlockBuffer to operate on. Must not be NULL

	@result	Returns kCMBlockBufferNoErr if successful.
*/
CM_EXPORT OSStatus	CMBlockBufferAssureBlockMemory(CMBlockBufferRef theBuffer) 
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*! 
 @functiongroup CMBlockBuffer access and query functions
*/

/*!
	@function	CMBlockBufferAccessDataBytes
	
	@abstract	Accesses potentially noncontiguous data in a CMBlockBuffer.
	@discussion	Used for accessing potentially noncontiguous data, this routine will return a pointer directly
				into the given CMBlockBuffer if possible, otherwise the data will be assembled and copied into the
				given temporary block and its pointer will be returned. 


	@param	theBuffer		CMBlockBuffer to operate on. Must not be NULL
	@param	offset			Offset within the CMBlockBuffer's offset range.
	@param	length			Desired number of bytes to access at offset
	@param	temporaryBlock	A piece of memory, assumed to be at least length bytes in size. Must not be NULL
	@param	returnedPointer	Receives NULL if the desired amount of data could not be accessed at the given offset.
							Receives non-NULL if it could. The value returned will either be a direct pointer into
							the CMBlockBuffer or temporaryBlock Must not be NULL.
							
	@result	Returns kCMBlockBufferNoErr if the desired amount of data could be accessed at the given offset.
*/
CM_EXPORT OSStatus CMBlockBufferAccessDataBytes(
		CMBlockBufferRef theBuffer, 
		size_t offset, 
		size_t length, 
		void *temporaryBlock, 
		char **returnedPointer)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferCopyDataBytes
	
	@abstract	Copies bytes from a CMBlockBuffer into a provided memory area.
	@discussion	This function is used to copy bytes out of a CMBlockBuffer into a provided piece of memory.
				It deals with the possibility of the desired range of data being noncontiguous. The function
				assumes that the memory at the destination is sufficient to hold the data. If length bytes
				of data are not available in the CMBlockBuffer, an error is returned and the contents of the
				destination are undefined. 
				
	@param	theSourceBuffer	The buffer from which data will be  copied into the destination
	@param	offsetToData	Offset within the source CMBlockBuffer at which the copy should begin.
	@param	dataLength		Number of bytes to copy, starting at offsetToData, within the source CMBlockBuffer. Must not be zero.
	@param	destination		Memory into which the data should be copied.
	
	@result	Returns kCMBlockBufferNoErr if the copy succeeded, returns an error otherwise.
*/
CM_EXPORT OSStatus	CMBlockBufferCopyDataBytes(
		CMBlockBufferRef theSourceBuffer, 
		size_t offsetToData, 
		size_t dataLength, 
		void* destination)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferReplaceDataBytes
	
	@abstract	Copies bytes from a given memory block into a CMBlockBuffer, replacing bytes in the underlying data blocks
	@discussion	This function is used to replace bytes in a CMBlockBuffer's memory blocks with those from a provided piece of memory.
				It deals with the possibility of the destination range of data being noncontiguous. CMBlockBufferAssureBlockMemory() is
				called on the given CMBlockBuffer. If desired range is subsequently not accessible in the CMBlockBuffer, an error is returned
				and the contents of the CMBlockBuffer are untouched. 
				
	@param	sourceBytes				Memory block from which bytes are copied into the CMBlockBuffer
	@param	destinationBuffer		CMBlockBuffer whose range of bytes will be replaced by the sourceBytes.
	@param	offsetIntoDestination	Offset within the destination CMBlockBuffer at which replacement should begin.
	@param	dataLength				Number of bytes to be replaced, starting at offsetIntoDestination, in the destinationBuffer.
	
	@result	Returns kCMBlockBufferNoErr if the replacement succeeded, returns an error otherwise.
*/
CM_EXPORT OSStatus	CMBlockBufferReplaceDataBytes(
		const void* sourceBytes, 
		CMBlockBufferRef destinationBuffer, 
		size_t offsetIntoDestination, 
		size_t dataLength)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferFillDataBytes
	
	@abstract	Fills a CMBlockBuffer with a given byte value, replacing bytes in the underlying data blocks
	@discussion	This function is used to fill bytes in a CMBlockBuffer's memory blocks with a given byte value.
				It deals with the possibility of the destination range of data being noncontiguous. CMBlockBufferAssureBlockMemory() is
				called on the given CMBlockBuffer. If desired range is subsequently not accessible in the CMBlockBuffer, an error is returned
				and the contents of the CMBlockBuffer are untouched. 
				
	@param	fillByte				The value with which to fill the specified data range
	@param	destinationBuffer		CMBlockBuffer whose range of bytes will be filled.
	@param	offsetIntoDestination	Offset within the destination CMBlockBuffer at which filling should begin.
	@param	dataLength				Number of bytes to be filled, starting at offsetIntoDestination, in the destinationBuffer. If zero, the
									destinationBuffer's total available dataLength (starting at offsetToData) will be filled.
	
	@result	Returns kCMBlockBufferNoErr if the fill succeeded, returns an error otherwise.
*/
CM_EXPORT OSStatus	CMBlockBufferFillDataBytes(
		char fillByte, 
		CMBlockBufferRef destinationBuffer, 
		size_t offsetIntoDestination, 
		size_t dataLength)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferGetDataPointer
	
	@abstract	Gains access to the data represented by a CMBlockBuffer.
	@discussion	Gains access to the data represented by a CMBlockBuffer. A pointer into a memory block is returned
				which corresponds to the offset within the CMBlockBuffer. The number of bytes addressable at the
				pointer can also be returned. This length-at-offset may be smaller than the number of bytes actually
				available starting at the offset if the dataLength of the CMBlockBuffer is covered by multiple memory
				blocks (a noncontiguous CMBlockBuffer). The data pointer returned will remain valid as long as the
				original CMBlockBuffer is referenced - once the CMBlockBuffer is released for the last time, any pointers
				into it will be invalid. 

	@param	theBuffer		CMBlockBuffer to operate on. Must not be NULL
	@param	offset			Offset within the buffer's offset range.
	@param	lengthAtOffset	On return, contains the amount of data available at the specified offset. May be NULL.
	@param	totalLength		On return, contains the block buffer's total data length (from offset 0). May be NULL.
							The caller can compare (offset+lengthAtOffset) with totalLength to determine whether
							the entire CMBlockBuffer has been referenced and whether it is possible to access the CMBlockBuffer's
							data with a contiguous reference.
	@param	dataPointer		On return, contains a pointer to the data byte at the specified offset; lengthAtOffset bytes are
							available at this address. May be NULL.

	@result	Returns kCMBlockBufferNoErr if data was accessible at the specified offset within the given CMBlockBuffer, false otherwise.
*/
CM_EXPORT OSStatus	CMBlockBufferGetDataPointer(
		CMBlockBufferRef theBuffer, 
		size_t offset, 
		size_t *lengthAtOffset, 
		size_t *totalLength, 
		char **dataPointer)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferGetDataLength
	
	@abstract	Obtains the total data length reachable via a CMBlockBuffer.
	@discussion	Obtains the total data length reachable via a CMBlockBuffer. This total is the sum of the dataLengths
				of the CMBlockBuffer's memoryBlocks and buffer references. Note that the dataLengths are
				the _portions_ of those constituents that this CMBlockBuffer subscribes to. This CMBlockBuffer presents a
				contiguous range of offsets from zero to its totalDataLength as returned by this routine.

	@param	theBuffer		CMBlockBuffer to examine.
	
	@result	Returns the total data length available via this CMBlockBuffer, or zero if it is empty, NULL, or somehow invalid.
*/
CM_EXPORT size_t	CMBlockBufferGetDataLength(CMBlockBufferRef theBuffer)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMBlockBufferIsRangeContiguous
	
	@abstract	Determines whether the specified range within the given CMBlockBuffer is contiguous.
	@discussion	Determines whether the specified range within the given CMBlockBuffer is contiguous. if CMBlockBufferGetDataPointer()
				were to be called with the same parameters, the returned pointer would address the desired number of bytes.
	
	@param	theBuffer		CMBlockBuffer to examine. Must not be NULL
	@param	offset			Offset within the buffer's offset range.
	@param	length			Desired number of bytes to access at offset. If zero, the number of bytes available at offset
							(dataLength – offset), contiguous or not, is used.
							
	@result	Returns true if the specified range is contiguous within the CMBlockBuffer, false otherwise. Also returns false if the
			CMBlockBuffer is NULL or empty.
*/
CM_EXPORT Boolean	CMBlockBufferIsRangeContiguous(
		CMBlockBufferRef theBuffer, 
		size_t offset, 
		size_t length)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMBlockBufferIsEmpty
	
	@abstract	Indicates whether the given CMBlockBuffer is empty.
	@discussion	Indicates whether the given CMBlockBuffer is empty, i.e., devoid of any memoryBlocks or CMBlockBuffer references.
				Note that a CMBlockBuffer containing a not-yet allocated memoryBlock is not considered empty.

	@param	theBuffer		CMBlockBuffer to examine. Must not be NULL
	
	@result	Returns the result of the emptiness test. Will return false if the CMBlockBuffer is NULL.
*/
CM_EXPORT Boolean	CMBlockBufferIsEmpty(CMBlockBufferRef theBuffer)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#pragma pack(pop)
    
#ifdef __cplusplus
}
#endif

#endif // CMBLOCKBUFFER_H
