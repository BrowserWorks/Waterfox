/*
    File:  CMSampleBuffer.h
	
	Framework:  CoreMedia
 
    Copyright 2005-2013 Apple Inc. All rights reserved.
 
*/

#ifndef CMSAMPLEBUFFER_H
#define CMSAMPLEBUFFER_H

/*!
	@header
	@abstract	API for creating and manipulating CMSampleBuffers.
	@discussion	CMSampleBuffers are CF objects containing zero or more compressed (or uncompressed)
				samples of a particular media type (audio, video, muxed, etc), that are used to move
				media sample data through the media system.
				
				A CMSampleBuffer can contain a CMBlockBuffer of one or more media samples or a CVImageBuffer,
				a reference to the format description for the stream of CMSampleBuffers, size and timing
				information for each of the contained media samples, and both buffer-level and sample-level
				attachments.  The buffer-level attachments of a CMSampleBuffer are distinct from the attachments
				of its contained CMBlockBuffer. An example of a sample-level attachment is an annotation about
				video frame dependencies (eg. "droppable", "other frames depend on me", "I depend on other frames", etc).
				Each sample (video frame) in the CMSampleBuffer would need its own attachment in this case.
				Another sample-level attachment example is SMPTE timecode acquired during capture. To get and
				set a CMSampleBuffer's buffer-level attachments, use the APIs in in CMAttachmentBearer.h
				(CMGetAttachment et al).

				It is possible for a CMSampleBuffer to describe samples it does not yet contain. For example, 
				some media services may have access to sample size, timing and format information before the
				data is read. Such services may create CMSampleBuffers with that information and insert them
				into queues early, and attach (or fill) the CMBlockBuffers of media data later, when the
				data becomes ready.  To this end, CMSampleBuffers have the concept of data-readiness, which can
				be tested, set, forced to become ready "now", etc.
				
				It is also possible for a CMSampleBuffer to contain nothing but a special buffer-level
				attachment that describes a media stream event (eg. "discontinuity: drain and reset decoder
				before processing the next CMSampleBuffer").  Such a special attachment can also be attached
				to regular CMSampleBuffers (ie. that contain media sample data), and if so, the event it
				describes is defined to occur after the samples in that CMSampleBuffer.

				IMPORTANT: Clients of CMSampleBuffer must explicitly manage the retain count by 
				calling CFRetain and CFRelease, even in processes using garbage collection.  

				Objective-C code that may run under garbage collection should NOT use [sbuf retain],
				or [sbuf release]; these will not have the correct effect.
*/

#include <CoreMedia/CMBase.h>
#include <CoreFoundation/CoreFoundation.h>

#include <CoreMedia/CMTime.h>
#include <CoreMedia/CMBlockBuffer.h>
#include <CoreMedia/CMFormatDescription.h>

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma pack(push, 4)

/*!
	@enum CMSampleBuffer Errors
	@discussion The errors returned from the CMSampleBuffer APIs
	@constant	kCMSampleBufferError_AllocationFailed An allocation failed.
	@constant	kCMSampleBufferError_RequiredParameterMissing NULL or 0 was passed for a required parameter.
	@constant	kCMSampleBufferError_AlreadyHasDataBuffer Attempt was made to set a dataBuffer on a CMSampleBuffer that already has one.
	@constant   kCMSampleBufferError_BufferNotReady Buffer could not be made ready.
	@constant   kCMSampleBufferError_SampleIndexOutOfRange Sample index was not between 0 and numSamples-1, inclusive.
	@constant   kCMSampleBufferError_BufferHasNoSampleSizes Attempt to get sample size information when there was none.
	@constant   kCMSampleBufferError_BufferHasNoSampleTimingInfo Attempt to get sample timing information when there was none.
	@constant   kCMSampleBufferError_ArrayTooSmall Output array was not large enough for the array being requested.
	@constant   kCMSampleBufferError_InvalidEntryCount Timing info or size array entry count was not 0, 1, or numSamples.
	@constant	kCMSampleBufferError_CannotSubdivide Sample buffer does not contain sample sizes.  This can happen when the samples in the buffer are non-contiguous (eg. non-interleaved audio, where the channel values for a single sample are scattered through the buffer).
    @constant   kCMSampleBufferError_SampleTimingInfoInvalid buffer unexpectedly contains a non-numeric sample timing info
    @constant   kCMSampleBufferError_InvalidMediaTypeForOperation the media type specified by a format description is not valid for the given operation (eg. a CMSampleBuffer with a non-audio format description passed to CMSampleBufferGetAudioStreamPacketDescriptionsPtr).
	@constant	kCMSampleBufferError_InvalidSampleData Buffer contains bad data. Only returned by CMSampleBuffer functions that inspect its sample data.
    @constant   kCMSampleBufferError_InvalidMediaFormat the format of the given media does not match the given format description (eg. a format description paired with a CVImageBuffer that fails CMVideoFormatDescriptionMatchesImageBuffer).
	@constant	kCMSampleBufferError_Invalidated the sample buffer was invalidated.
*/
enum {
	kCMSampleBufferError_AllocationFailed				= -12730,
	kCMSampleBufferError_RequiredParameterMissing		= -12731,
	kCMSampleBufferError_AlreadyHasDataBuffer			= -12732,
	kCMSampleBufferError_BufferNotReady					= -12733,
	kCMSampleBufferError_SampleIndexOutOfRange			= -12734,
	kCMSampleBufferError_BufferHasNoSampleSizes			= -12735,
	kCMSampleBufferError_BufferHasNoSampleTimingInfo	= -12736,
	kCMSampleBufferError_ArrayTooSmall					= -12737,
	kCMSampleBufferError_InvalidEntryCount				= -12738,
	kCMSampleBufferError_CannotSubdivide				= -12739,
    kCMSampleBufferError_SampleTimingInfoInvalid      	= -12740,
    kCMSampleBufferError_InvalidMediaTypeForOperation	= -12741,
	kCMSampleBufferError_InvalidSampleData				= -12742,
    kCMSampleBufferError_InvalidMediaFormat				= -12743,
	kCMSampleBufferError_Invalidated					= -12744,
};

/*!
	@enum CMSampleBuffer Flags
	@discussion Flags passed to various CMSampleBuffer APIs
	@constant	kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment Make sure memory involved in audio buffer lists is 16-byte aligned
*/
enum {
	kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment		= (1L<<0)
};

/*!
	@typedef	CMSampleBufferRef
	@abstract	A reference to a CMSampleBuffer, a CF object containing zero or more compressed (or uncompressed)
				samples of a particular media type (audio, video, muxed, etc).
		
*/
typedef struct opaqueCMSampleBuffer *CMSampleBufferRef;

/*!
	@typedef	CMSampleTimingInfo
	@abstract	Collection of timing info for a sample in a CMSampleBuffer. A single CMSampleTimingInfo struct can
				describe every individual sample in a CMSampleBuffer, if the samples all have the same duration and
				are in presentation order with no gaps.
*/
typedef struct
{
	CMTime duration;				/*! @field duration
										The duration of the sample. If a single struct applies to
										each of the samples, they all will have this duration. */
	CMTime presentationTimeStamp;	/*! @field presentationTimeStamp
										The time at which the sample will be presented. If a single
										struct applies to each of the samples, this is the presentationTime of the
										first sample. The presentationTime of subsequent samples will be derived by
										repeatedly adding the sample duration. */
	CMTime decodeTimeStamp;			/*! @field decodeTimeStamp
										The time at which the sample will be decoded. If the samples
										are in presentation order, this must be set to kCMTimeInvalid. */
} CMSampleTimingInfo;

CM_EXPORT const CMSampleTimingInfo kCMTimingInfoInvalid		/*! @constant kCMTimingInfoInvalid
																Use this constant to initialize an invalid CMSampleTimingInfo struct.
																All fields are set to kCMTimeInvalid */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@typedef	CMSampleBufferMakeDataReadyCallback
	@abstract	Client callback called by CMSampleBufferMakeDataReady (client provides it when calling CMSampleBufferCreate).
	@discussion	This callback must make the data ready (e.g. force a scheduled read to finish). If this callback
				succeeds and returns 0, the CMSampleBuffer will then be marked as "data ready".
*/
typedef OSStatus (*CMSampleBufferMakeDataReadyCallback)
	(CMSampleBufferRef sbuf,	/*! @param sbuf
									The CMSampleBuffer to make ready. */
	void *makeDataReadyRefcon);	/*! @param makeDataReadyRefcon
									Client refcon provided to CMSampleBufferCreate.
									For example, it could point at info about the
									scheduled read that needs to be forced to finish. */

/*! 
	@functiongroup	Object management functions
*/

/*!
	@function	CMSampleBufferCreate
	@abstract	Creates a CMSampleBuffer.
	@discussion	Array parameters (sampleSizeArray, sampleTimingArray) should have only one element if that same
				element applies to all samples. All parameters are copied; on return, the caller can release them,
				free them, reuse them or whatever.  On return, the caller owns the returned CMSampleBuffer, and
				must release it when done with it.
				
				Example of usage for in-display-order video frames:
<ul>				dataBuffer: contains 7 Motion JPEG frames
<li>				dataFormatDescription: describes Motion JPEG video
<li>				numSamples: 7
<li>				numSampleTimingEntries: 1
<li>				sampleTimingArray: one entry = {duration = 1001/30000, presentationTimeStamp = 0/30000, decodeTimeStamp = invalid }
<li>				numSampleSizeEntries: 7
<li>				sampleSizeArray: {105840, 104456, 103464, 116460, 100412, 94808, 120400}
</ul>
				Example of usage for out-of-display-order video frames:
<ul>				dataBuffer: contains 6 H.264 frames in decode order (P2,B0,B1,I5,B3,B4)
<li>				dataFormatDescription: describes H.264 video
<li>				numSamples: 6
<li>				numSampleTimingEntries: 6
<li>				sampleTimingArray: 6 entries = {
<ul>					{duration = 1001/30000, presentationTimeStamp = 12012/30000, decodeTimeStamp = 10010/30000},
<li>					{duration = 1001/30000, presentationTimeStamp = 10010/30000, decodeTimeStamp = 11011/30000},
<li>					{duration = 1001/30000, presentationTimeStamp = 11011/30000, decodeTimeStamp = 12012/30000},
<li>					{duration = 1001/30000, presentationTimeStamp = 15015/30000, decodeTimeStamp = 13013/30000},
<li>					{duration = 1001/30000, presentationTimeStamp = 13013/30000, decodeTimeStamp = 14014/30000},
<li>					{duration = 1001/30000, presentationTimeStamp = 14014/30000, decodeTimeStamp = 15015/30000}}
</ul>
<li>				numSampleSizeEntries: 6
<li>				sampleSizeArray: {10580, 1234, 1364, 75660, 1012, 988}
</ul>
				Example of usage for compressed audio:
<ul>				dataBuffer: contains 24 compressed AAC packets
<li>				dataFormatDescription: describes 44.1kHz AAC audio
<li>				numSamples: 24
<li>				numSampleTimingEntries: 1
<li>				sampleTimingArray: one entry = {
<ul>					{duration = 1024/44100, presentationTimeStamp = 0/44100, decodeTimeStamp = invalid }}
</ul>
<li>				numSampleSizeEntries: 24
<li>				sampleSizeArray:
<ul>					{191, 183, 208, 213, 202, 206, 209, 206, 204, 192, 202, 277,
<li>					 282, 240, 209, 194, 193, 197, 196, 198, 168, 199, 171, 194}
</ul>
</ul>
				Example of usage for uncompressed interleaved audio:
<ul>				dataBuffer: contains 24000 uncompressed interleaved stereo frames, each containing 2 Float32s =
<ul>					{{L,R},
<li>					 {L,R},
<li>					 {L,R}, ...}
</ul>
<li>				dataFormatDescription: describes 48kHz Float32 interleaved audio
<li>				numSamples: 24000
<li>				numSampleTimingEntries: 1
<li>				sampleTimingArray: one entry = {
<ul>					{duration = 1/48000, presentationTimeStamp = 0/48000, decodeTimeStamp = invalid }}
</ul>
<li>				numSampleSizeEntries: 1
<li>				sampleSizeArray: {8}
</ul>
				Example of usage for uncompressed non-interleaved audio:
<ul>				dataBuffer: contains 24000 uncompressed non-interleaved stereo frames, each containing 2 (non-contiguous) Float32s =
<ul>					{{L,L,L,L,L,...},
<li>					 {R,R,R,R,R,...}}
</ul>
<li>				dataFormatDescription: describes 48kHz Float32 non-interleaved audio
<li>				numSamples: 24000
<li>				numSampleTimingEntries: 1
<li>				sampleTimingArray: one entry = {duration = 1/48000, presentationTimeStamp = 0/48000, decodeTimeStamp = invalid }
<li>				numSampleSizeEntries: 0
<li>				sampleSizeArray: NULL (because the samples are not contiguous)
</ul>
*/
CM_EXPORT
OSStatus CMSampleBufferCreate(
	CFAllocatorRef allocator,						/*! @param allocator
														The allocator to use for allocating the CMSampleBuffer object.
														Pass kCFAllocatorDefault to use the default allocator. */
	CMBlockBufferRef dataBuffer,					/*! @param dataBuffer
														CMBlockBuffer for the media data. This can be NULL, a CMBlockBuffer with
														no backing memory, a CMBlockBuffer with backing memory but no data yet,
														or a CMBlockBuffer that already contains the media data. Only in that
														last case (or if NULL and numSamples is 0) should dataReady be true. */
	Boolean dataReady,								/*! @param dataReady
														Indicates whether or not the BlockBuffer already contains the media data. */
	CMSampleBufferMakeDataReadyCallback makeDataReadyCallback,	
													/*! @param makeDataReadyCallback
														Callback that CMSampleBufferMakeDataReady should call to make the
														data ready. Can be NULL. */
	void *makeDataReadyRefcon,						/*! @param makeDataReadyRefcon
														Refcon CMSampleBufferMakeDataReady should pass to the callback. */
	CMFormatDescriptionRef formatDescription,		/*! @param formatDescription
														A description of the media data's format. Can be NULL. */
	CMItemCount numSamples,							/*! @param numSamples
														Number of samples in the CMSampleBuffer. Can be 0. */
	CMItemCount numSampleTimingEntries,				/*! @param numSampleTimingEntries
														Number of entries in sampleTimingArray. Must be 0, 1, or numSamples. */
	const CMSampleTimingInfo *sampleTimingArray,	/*! @param sampleTimingArray
														Array of CMSampleTimingInfo structs, one struct per sample.
														If all samples have the same duration and are in presentation order, you can pass a single
														CMSampleTimingInfo struct with duration set to the duration of one sample, presentationTimeStamp
														set to the presentation time of the numerically earliest sample, and decodeTimeStamp set to
														kCMTimeInvalid. Behaviour is undefined if samples in a CMSampleBuffer (or even in multiple
														buffers in the same stream) have the same presentationTimeStamp. Can be NULL. */
	CMItemCount numSampleSizeEntries,				/*! @param numSampleSizeEntries
														Number of entries in sampleSizeArray. Must be 0, 1, or numSamples. */
	const size_t *sampleSizeArray,					/*! @param sampleSizeArray
														Array of size entries, one entry per sample. If all samples have the
														same size, you can pass a single size entry containing the size of one sample. Can be NULL. Must be
														NULL if the samples are non-contiguous in the buffer (eg. non-interleaved audio, where the channel
														values for a single sample are scattered through the buffer). */
	CMSampleBufferRef *sBufOut)						/*! @param sBufOut
														Returned newly created CMSampleBuffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMAudioSampleBufferCreateWithPacketDescriptions
	@abstract	Creates an CMSampleBuffer containing audio given packetDescriptions instead of sizing and timing info
	@discussion	Provides an optimization over CMSampleBufferCreate() when the caller already has packetDescriptions for
				the audio data. This routine will use the packetDescriptions to create the sizing and timing arrays required
				to make the sample buffer if necessary.
*/				
CM_EXPORT
OSStatus CMAudioSampleBufferCreateWithPacketDescriptions(
	CFAllocatorRef allocator,						/*! @param allocator
														The allocator to use for allocating the CMSampleBuffer object.
														Pass kCFAllocatorDefault to use the default allocator. */
	CMBlockBufferRef dataBuffer,					/*! @param dataBuffer
														CMBlockBuffer for the media data. This can be NULL, a CMBlockBuffer with
														no backing memory, a CMBlockBuffer with backing memory but no data yet,
														or a CMBlockBuffer that already contains the media data. Only in that
														last case should dataReady be true. */
	Boolean dataReady,								/*! @param dataReady
														Indicates whether or not the BlockBuffer already contains the media data. */
	CMSampleBufferMakeDataReadyCallback makeDataReadyCallback,	
													/*! @param makeDataReadyCallback
														Callback that CMSampleBufferMakeDataReady should call to make the
														data ready. Can be NULL. */
	void *makeDataReadyRefcon,						/*! @param makeDataReadyRefcon
														Refcon CMSampleBufferMakeDataReady should pass to the callback. */
	CMFormatDescriptionRef formatDescription,		/*! @param formatDescription
														A description of the media data's format. Cannot be NULL. */
	CMItemCount numSamples,							/*! @param numSamples
														Number of samples in the CMSampleBuffer. Must not be 0. */
	CMTime	sbufPTS,								/*! @param sbufPTS
														Timestamp of the first sample in the buffer. Must be a numeric CMTime. */
	const AudioStreamPacketDescription *packetDescriptions,	/*! @param packetDescriptions
																Array of packetDescriptions, one for each of numSamples. May be NULL
																if the samples are known to have a constant number of frames per
																packet and a constant size. */
	CMSampleBufferRef *sBufOut)						/*! @param sBufOut
														Returned newly created CMSampleBuffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferCreateForImageBuffer
	@abstract	Creates a CMSampleBuffer that contains a CVImageBuffer instead of a CMBlockBuffer.
	@discussion	Unlike a CMBlockBuffer which can reference many samples, a CVImageBuffer is defined to
				reference only one sample;  therefore this routine has fewer parameters then
				CMSampleBufferCreate.
				
				Sample timing information, which is a vector for CMSampleBufferCreate,
				consists of only one value for this routine.
				
				The concept of sample size does not apply to CVImageBuffers.  As such, CMSampleBufferGetSampleSizeArray
				will return kCMSampleBufferError_BufferHasNoSampleSizes, and CMSampleBufferGetSampleSize
				will return 0.
				
				Because CVImageBuffers hold visual data, the format description provided is a
				CMVideoFormatDescription.  The format description must be consistent with the attributes
				and formatting information attached to the CVImageBuffer. The width, height, and codecType must
				match (for CVPixelBuffers the codec type is given by CVPixelBufferGetPixelFormatType(pixelBuffer);
				for other CVImageBuffers, the codecType must be 0). The format description extensions must
				match the image buffer attachments for all the keys in the list returned by
				CMVideoFormatDescriptionGetExtensionKeysCommonWithImageBuffers (if absent in either they
				must be absent in both).
*/
CM_EXPORT
OSStatus CMSampleBufferCreateForImageBuffer(
	CFAllocatorRef allocator,						/*! @param allocator
														The allocator to use for allocating the CMSampleBuffer object.
														Pass kCFAllocatorDefault to use the default allocator. */
	CVImageBufferRef imageBuffer,					/*! @param imageBuffer
														CVImageBuffer for the media data. This can be a CVImageBuffer whose content
														has not yet been rendered, or a CVImageBuffer that already contains the media data
														(in which case dataReady should be true).  May not be NULL. */
	Boolean dataReady,								/*! @param dataReady
														Indicates whether or not the CVImageBuffer already contains the media data. */
	CMSampleBufferMakeDataReadyCallback makeDataReadyCallback,	
													/*! @param makeDataReadyCallback
														Callback that CMSampleBufferMakeDataReady should call to make the
														data ready. Can be NULL. */
	void *makeDataReadyRefcon,						/*! @param makeDataReadyRefcon
														Refcon CMSampleBufferMakeDataReady should pass to the callback. */
	CMVideoFormatDescriptionRef formatDescription,	/*! @param formatDescription
														A description of the media data's format. See discussion above for constraints.
														May not be NULL. */
	const CMSampleTimingInfo *sampleTiming,			/*! @param sampleTiming
														A CMSampleTimingInfo struct that provides the timing information for the media
														represented by the CVImageBuffer. */
	CMSampleBufferRef *sBufOut)						/*! @param sBufOut
														Returned newly created CMSampleBuffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMSampleBufferCreateCopy
	@abstract	Creates a copy of a CMSampleBuffer.
	@discussion	The copy is shallow: scalar properties (sizes and timing) are copied directly,
				the data buffer and format description are retained, and
				the propogatable attachments are retained by the copy's dictionary.
				If sbuf's data is not ready, the copy will be set to track its readiness.
*/
CM_EXPORT
OSStatus CMSampleBufferCreateCopy(
	CFAllocatorRef allocator,						/*! @param allocator
														The allocator to use for allocating the CMSampleBuffer object.
														Pass kCFAllocatorDefault to use the default allocator. */
	CMSampleBufferRef sbuf,							/*! @param sbuf
														CMSampleBuffer being copied. */
	CMSampleBufferRef *sbufCopyOut)					/*! @param sbufCopyOut
														Returned newly created CMSampleBuffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferCreateCopyWithNewTiming
	@abstract	Creates a CMSampleBuffer with new timing information from another sample buffer.
	@discussion	This emulates CMSampleBufferCreateCopy, but changes the timing.
				Array parameters (sampleTimingArray) should have only one element if that same
				element applies to all samples. All parameters are copied; on return, the caller can release them,
				free them, reuse them or whatever.  Any outputPresentationTimestamp that has been set on the original Buffer
				will not be copied because it is no longer relevant.	On return, the caller owns the returned 
				CMSampleBuffer, and must release it when done with it.
 
 */				
CM_EXPORT
OSStatus CMSampleBufferCreateCopyWithNewTiming(
  CFAllocatorRef allocator,						/*! @param allocator
														   The allocator to use for allocating the CMSampleBuffer object.
														   Pass kCFAllocatorDefault to use the default allocator. */
  CMSampleBufferRef originalSBuf,            	/*!  @param originalSBuf
															CMSampleBuffer containing the original samples */
											  
  CMItemCount numSampleTimingEntries,			/*! @param numSampleTimingEntries
														   Number of entries in sampleTimingArray. Must be 0, 1, or numSamples 
														   in original sampleBuffer. */
  const CMSampleTimingInfo *sampleTimingArray,	/*! @param sampleTimingArray
														   Array of CMSampleTimingInfo structs, one struct per sample.
														   If all samples have the same duration and are in presentation order, you can pass a single
														   CMSampleTimingInfo struct with duration set to the duration of one sample, presentationTimeStamp
														   set to the presentation time of the numerically earliest sample, and decodeTimeStamp set to
														   kCMTimeInvalid. Behaviour is undefined if samples in a CMSampleBuffer (or even in multiple
														   buffers in the same stream) have the same presentationTimeStamp. Can be NULL. */
  CMSampleBufferRef *sBufCopyOut)				/*! @param sBufCopyOut
														   Returned newly created CMSampleBuffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
	
/*!
	@function	CMSampleBufferCopySampleBufferForRange
	@abstract	Creates a CMSampleBuffer containing a range of samples from an existing CMSampleBuffer.
	@discussion	Samples containing non-interleaved audio are currently not supported.
 */				
CM_EXPORT
OSStatus CMSampleBufferCopySampleBufferForRange(
  CFAllocatorRef allocator,			/*! @param allocator
											   The allocator to use for allocating the CMSampleBuffer object.
											   Pass kCFAllocatorDefault to use the default allocator. */
  CMSampleBufferRef sbuf,    	   	/*! @param sbuf
												CMSampleBuffer containing the original samples */
											  
  CFRange sampleRange,				/*! @param sampleRange
											   The range of samples to copy from sbuf, where sample 0 is the first sample in the sbuf */
  CMSampleBufferRef *sBufOut)		/*! @param sBufOut
											   Returned newly created CMSampleBuffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMSampleBufferGetTypeID
	@abstract	Returns the CFTypeID of CMSampleBuffer objects.
	@discussion	You can check if a CFTypeRef object is actually a CMSampleBuffer by comparing CFGetTypeID(object) with CMSampleBufferGetTypeID().
	@result		CFTypeID of CMSampleBuffer objects.
*/
CM_EXPORT
CFTypeID	CMSampleBufferGetTypeID(void)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*! 
	@functiongroup Data management functions
*/

/*!
	@function	CMSampleBufferSetDataBuffer
	@abstract	Associates a CMSampleBuffer with its CMBlockBuffer of media data.
	@discussion	If successful, this operation retains the dataBuffer thereafter, so the caller can release the dataBuffer
				after calling this API, if it has no further need to reference it. This is a write-once operation; it will fail if
				the CMSampleBuffer already has a dataBuffer. This API allows a CMSampleBuffer to exist, with timing and format
				information, before the associated data shows up. Example of usage: Some media services may have access to sample
				size, timing, and format information before the data is read.  Such services may create CMSampleBuffers with that
				information and insert them into queues early, and use this API to attach the CMBlockBuffers later, when the data
				becomes ready.
*/
CM_EXPORT
OSStatus CMSampleBufferSetDataBuffer(
	CMSampleBufferRef sbuf,			/*! @param sbuf
										CMSampleBuffer being modified. */
	CMBlockBufferRef dataBuffer)	/*! @param dataBuffer
										CMBlockBuffer of data being associated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetDataBuffer
	@abstract	Returns a CMSampleBuffer's CMBlockBuffer of media data.
	@discussion The caller does not own the returned dataBuffer, and must retain it explicitly if the caller needs to maintain a reference to it.
	@result		CMBlockBuffer of media data. The result will be NULL if the CMSampleBuffer does not contain a CMBlockBuffer, if the
				CMSampleBuffer contains a CVImageBuffer, or if there is some other error.
*/
CM_EXPORT
CMBlockBufferRef CMSampleBufferGetDataBuffer(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetImageBuffer
	@abstract	Returns a CMSampleBuffer's CVImageBuffer of media data.
	@discussion The caller does not own the returned dataBuffer, and must retain it explicitly if the caller needs to maintain a reference to it.
	@result		CVImageBuffer of media data. The result will be NULL if the CMSampleBuffer does not contain a CVImageBuffer, if the
				CMSampleBuffer contains a CMBlockBuffer, or if there is some other error.
*/
CM_EXPORT
CVImageBufferRef CMSampleBufferGetImageBuffer(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
									
/*!
	@function	CMSampleBufferSetDataBufferFromAudioBufferList
	@abstract	Creates a CMBlockBuffer containing a copy of the data from the AudioBufferList,
				and sets that as the CMSampleBuffer's data buffer. The resulting buffer(s) in the
				sample buffer will be 16-byte-aligned if  
				kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment is passed in.
*/
CM_EXPORT
OSStatus CMSampleBufferSetDataBufferFromAudioBufferList(
	CMSampleBufferRef sbuf,				/*! @param sbuf
										CMSampleBuffer being modified. */
	CFAllocatorRef bbufStructAllocator,	/*! @param bbufStructAllocator
										Allocator to use when creating the CMBlockBuffer structure. */
	CFAllocatorRef bbufMemoryAllocator,	/*! @param bbufMemoryAllocator
										Allocator to use for memory block held by the CMBlockBuffer. */
	uint32_t flags,						/*! @param flags
										Flags controlling operation. */
	const AudioBufferList *bufferList)	/*! @param bufferList
										Buffer list whose data will be copied into the new CMBlockBuffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer
	@abstract	Creates an AudioBufferList containing the data from the CMSampleBuffer,
				and a CMBlockBuffer which references (and manages the lifetime of) the
				data in that AudioBufferList.  The data may or may not be copied,
				depending on the contiguity and 16-byte alignment of the CMSampleBuffer's
				data. The buffers placed in the AudioBufferList are guaranteed to be contiguous.
				The buffers in the AudioBufferList will be 16-byte-aligned if
				kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment is passed in.
*/
CM_EXPORT
OSStatus CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
	CMSampleBufferRef sbuf,				/*! @param sbuf
										CMSampleBuffer being accessed. */
	size_t *bufferListSizeNeededOut,	/*! @param bufferListSizeNeededOut
										Receives the size of the AudioBufferList required to
										accommodate the data. May be NULL. */
	AudioBufferList *bufferListOut,		/*! @param bufferListOut
										Allocated by the caller, sized as specified by bufferListSizeNeededOut.
										It is filled in with pointers into the retained blockBufferOut.
										May be NULL. */
	size_t bufferListSize,				/*! @param bufferListSize
										Size of the bufferListOut allocated by the client. If bufferListOut
										is not NULL and bufferListSize is insufficient, kFigSampleBufferError_ArrayTooSmall
										is returned. */ 
	CFAllocatorRef bbufStructAllocator,	/*! @param bbufStructAllocator
										Allocator to use when creating the CMBlockBuffer structure. */
	CFAllocatorRef bbufMemoryAllocator,	/*! @param bbufMemoryAllocator
										Allocator to use for memory block held by the CMBlockBuffer. */
	uint32_t flags,						/*! @param flags
										Flags controlling operation. */
	CMBlockBufferRef *blockBufferOut)	/*! @param blockBufferOut
										The retained CMBlockBuffer. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMSampleBufferGetAudioStreamPacketDescriptions
	@abstract	Creates an array of AudioStreamPacketDescriptions for the 
                variable bytes per packet or variable frames per packet
                audio data in the provided CMSampleBuffer.  Constant bitrate,
                constant frames-per-packet audio yields a return value of noErr 
                and no packet descriptions.  This API is specific to audio format
				sample buffers, and will return kCMSampleBufferError_InvalidMediaTypeForOperation
				if called with a non-audio sample buffer.
*/
CM_EXPORT
OSStatus CMSampleBufferGetAudioStreamPacketDescriptions(
    CMSampleBufferRef sbuf,							/*! @param sbuf
													CMSampleBuffer being accessed. */
    size_t packetDescriptionsSize,					/*! @param packetDescriptionsSize
    												Size of packetDescriptionsOut as allocated by the caller. */
    AudioStreamPacketDescription *packetDescriptionsOut,	/*! @param packetDescriptionsOut
    														Allocated by the caller, receives the packet descriptions
    														for the samples in the CMSampleBuffer. If non-NULL and
    														packetDescriptionsSize is too small, kFigSampleBufferError_ArrayTooSmall
    														is returned. */
    size_t *packetDescriptionsSizeNeededOut )		/*! @param packetDescriptionsSizeNeededOut
    												Used to query for the correct size required for packetDescriptionsOut. May be NULL. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMSampleBufferGetAudioStreamPacketDescriptionsPtr
	@abstract	Returns a pointer to (and size of) a constant array of
				AudioStreamPacketDescriptions for the variable bytes per
				packet or variable frames per packet audio data in the
				provided CMSampleBuffer.  The pointer will remain valid
				as long as the sbuf continues to be retained.
				Constant bitrate, constant frames-per-packet audio yields a
				return value of noErr and no packet descriptions.  This API is
				specific to audio format sample buffers, and will return
				kCMSampleBufferError_InvalidMediaTypeForOperation if called
				with a non-audio sample buffer.
*/
CM_EXPORT
OSStatus CMSampleBufferGetAudioStreamPacketDescriptionsPtr(
    CMSampleBufferRef						sbuf,							/*! @param sbuf CMSampleBuffer being modified. */
    const AudioStreamPacketDescription   ** packetDescriptionsPtrOut,		/*! @param packetDescriptionsPtrOut returned pointer to constant array of AudioStreamPacketDescriptions. May be NULL. */
    size_t								  * packetDescriptionsSizeOut )		/*! @param packetDescriptionsSizeOut size in bytes of constant array of AudioStreamPacketDescriptions. May be NULL. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferCopyPCMDataIntoAudioBufferList
	@abstract	Copies PCM audio data from the given CMSampleBuffer into
				a pre-populated AudioBufferList. The AudioBufferList must
				contain the same number of channels and its data buffers
				must be sized to hold the specified number of frames.
				This API is	specific to audio format sample buffers, and
				will return kCMSampleBufferError_InvalidMediaTypeForOperation
				if called with a non-audio sample buffer. It will return an
				error if the CMSampleBuffer does not contain PCM audio data
				or if its dataBuffer is not ready.
*/

CM_EXPORT
OSStatus CMSampleBufferCopyPCMDataIntoAudioBufferList(
	CMSampleBufferRef	sbuf,							/*! @param sbuf Contains PCM audio data to be copied. */
	int32_t				frameOffset,					/*! @param frameOffset (zero-based) starting frame number to copy from. */
	int32_t				numFrames,						/*! @param numFrames number of frames to copy */
	AudioBufferList		*bufferList)					/*! @param  Pre-populated bufferlist */
							__OSX_AVAILABLE_STARTING(__MAC_10_9,__IPHONE_7_0);

/*!
	@function	CMSampleBufferSetDataReady
	@abstract	Marks a CMSampleBuffer's data as "ready".
	@discussion	There is no way to undo this operation.  The only way to get an "unready"
				CMSampleBuffer is to call CMSampleBufferCreate with the dataReady parameter
				set to false. Example of usage: in a read completion routine.
*/
CM_EXPORT
OSStatus CMSampleBufferSetDataReady(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being modified. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferDataIsReady
	@abstract	Returns whether or not a CMSampleBuffer's data is ready.
	@result		Whether or not the CMSampleBuffer's data is ready.  True is returned for special marker buffers, even
				though they have no data. False is returned if there is an error.
*/
CM_EXPORT
Boolean CMSampleBufferDataIsReady(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferMakeDataReady
	@abstract	Makes a CMSampleBuffer's data ready, by calling the client's CMSampleBufferMakeDataReadyCallback.
	@discussion	The CMSampleBufferMakeDataReadyCallback is passed in by the client during creation. It must return
				0 if successful, and in that case, CMSampleBufferMakeDataReady will set the data readiness of
				the CMSampleBuffer to true. Example of usage: when it is time to actually use the data. Example of
				callback routine: a routine to force a scheduled read to complete.  If the CMSampleBuffer is not
				ready, and there is no CMSampleBufferMakeDataReadyCallback to call, kCMSampleBufferError_BufferNotReady
				will be returned. Similarly, if the CMSampleBuffer is not ready, and the CMSampleBufferMakeDataReadyCallback
				fails and returns an error, kCMSampleBufferError_BufferNotReady will be returned.
*/
CM_EXPORT
OSStatus CMSampleBufferMakeDataReady(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being modified. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferTrackDataReadiness
	@abstract	Associates a CMSampleBuffer's data readiness with another CMSampleBuffer's data readiness.
	@discussion	After calling this API, if CMSampleBufferDataIsReady(sbuf) is called, it will return sbufToTrack's data
				readiness. If CMSampleBufferMakeDataReady(sbuf) is called, it will do it by making sbufToTrack ready.
				Example of use: This allows bursting a multi-sample CMSampleBuffer into single-sample CMSampleBuffers
				before the data is ready. The single-sample CMSampleBuffers will all track the multi-sample
				CMSampleBuffer's data readiness.
*/
CM_EXPORT
OSStatus CMSampleBufferTrackDataReadiness(
	CMSampleBufferRef sbuf,				/*! @param sbuf
										CMSampleBuffer being modified. */
	CMSampleBufferRef sbufToTrack)		/*! @param sbufToTrack
										CMSampleBuffer being tracked. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferInvalidate
	@abstract	Makes the sample buffer invalid, calling any installed invalidation callback.
	@discussion	An invalid sample buffer cannot be used -- all accessors will return kCMSampleBufferError_Invalidated.
				It is not a good idea to do this to a sample buffer that another module may be accessing concurrently.
				Example of use: the invalidation callback could cancel pending I/O.
*/
CM_EXPORT 
OSStatus CMSampleBufferInvalidate( 
	CMSampleBufferRef sbuf )	/*! @param sbuf
								CMSampleBuffer being modified. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@typedef	CMSampleBufferInvalidateCallback
	@abstract	Client callback called by CMSampleBufferInvalidate.
*/
typedef void (*CMSampleBufferInvalidateCallback)
	(CMSampleBufferRef sbuf,	/*! @param sbuf
									The CMSampleBuffer being invalidated. */
	uint64_t invalidateRefCon);	/*! @param invalidateRefCon
									Reference constant provided when the callback was set up. */

/*!
	@function	CMSampleBufferSetInvalidateCallback
	@abstract	Sets the sample buffer's invalidation callback, which is called during CMSampleBufferInvalidate.
	@discussion	A sample buffer can only have one invalidation callback.  
				The invalidation callback is NOT called during ordinary sample buffer finalization.
*/
CM_EXPORT OSStatus 
CMSampleBufferSetInvalidateCallback( 
	CMSampleBufferRef sbuf,									/*! @param sbuf
															The CMSampleBuffer being modified. */
	CMSampleBufferInvalidateCallback invalidateCallback,	/*! @param invalidateCallback
															Pointer to function to be called during CMSampleBufferInvalidate. */
	uint64_t invalidateRefCon )								/*! invalidateRefCon
															Reference constant to be passed to invalidateCallback. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferIsValid
	@abstract	Queries whether a sample buffer is still valid.
	@discussion	Returns false if sbuf is NULL or CMSampleBufferInvalidate(sbuf) was called, true otherwise.
				Does not perform any kind of exhaustive validation of the sample buffer.
*/
CM_EXPORT 
Boolean CMSampleBufferIsValid( 
	CMSampleBufferRef sbuf )	/*! @param sbuf
								The CMSampleBuffer being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@constant	kCMSampleBufferNotification_DataBecameReady
	@abstract	Posted on a CMSampleBuffer by CMSampleBufferSetDataReady when the buffer becomes ready.
*/
CM_EXPORT const CFStringRef kCMSampleBufferNotification_DataBecameReady
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferConduitNotification_InhibitOutputUntil
	@abstract	Posted on a conduit of CMSampleBuffers (eg, a CMBufferQueue) to announce a coming discontinuity and specify a tag value that will be attached to the first CMSampleBuffer following the discontinuity.  
	@discussion
		The first CMSampleBuffer following the discontinuity should have 
		a kCMSampleBufferAttachmentKey_ResumeOutput attachment with value containing 
		the same CFNumber as this notification's payload's
		kCMSampleBufferConduitNotificationParameter_ResumeTag.  
		The consumer should discard output data until it receives this CMSampleBuffer.
		If multiple kCMSampleBufferConduitNotification_InhibitOutputUntil notifications are
		received, the last one indicates the tag to trigger resuming.
*/
CM_EXPORT const CFStringRef kCMSampleBufferConduitNotification_InhibitOutputUntil  // payload: CFDictionary containing:
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleBufferConduitNotificationParameter_ResumeTag  // payload: CFNumber
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferConduitNotification_ResetOutput
	@abstract	Posted on a conduit of CMSampleBuffers (eg, a CMBufferQueue) to request invalidation of pending output data.
*/
CM_EXPORT const CFStringRef kCMSampleBufferConduitNotification_ResetOutput
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferConduitNotification_UpcomingOutputPTSRangeChanged
	@abstract	Posted on a conduit of video CMSampleBuffers (eg, a CMBufferQueue) to report information about the range of upcoming CMSampleBuffer output presentation timestamps.
*/
CM_EXPORT const CFStringRef kCMSampleBufferConduitNotification_UpcomingOutputPTSRangeChanged  // payload: CFDictionary containing:
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_3);
CM_EXPORT const CFStringRef kCMSampleBufferConduitNotificationParameter_UpcomingOutputPTSRangeMayOverlapQueuedOutputPTSRange  // payload: CFBoolean
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_3);
CM_EXPORT const CFStringRef kCMSampleBufferConduitNotificationParameter_MinUpcomingOutputPTS  // payload: CFDictionary(CMTime)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_3);
CM_EXPORT const CFStringRef kCMSampleBufferConduitNotificationParameter_MaxUpcomingOutputPTS  // payload: CFDictionary(CMTime)
							__OSX_AVAILABLE_STARTING(__MAC_10_8,__IPHONE_5_0);

/*!
	@constant	kCMSampleBufferConsumerNotification_BufferConsumed
	@abstract	Posted when a CMSampleBuffer that has kCMSampleBufferAttachmentKey_PostNotificationWhenConsumed is consumed.
	@discussion
		After an object consumes a CMSampleBuffer that has a kCMSampleBufferAttachmentKey_PostNotificationWhenConsumed
		attachment, it should post kCMSampleBufferConsumerNotification_BufferConsumed 
		with itself as the notifyingObject and the attachment value as the payload.
		Such an attachment value must be a CFDictionary but the contents are client-defined.
		
		Note that a NULL refcon cannot be attached to a CMSampleBuffer.
*/
CM_EXPORT const CFStringRef kCMSampleBufferConsumerNotification_BufferConsumed  // payload: CFDictionary
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*! 
	@functiongroup Buffer attribute functions
*/

/*!
	@function	CMSampleBufferGetNumSamples
	@abstract	Returns the number of media samples in a CMSampleBuffer.
	@result		The number of media samples in the CMSampleBuffer. 0 is returned if there is an error.
*/
CM_EXPORT
CMItemCount CMSampleBufferGetNumSamples(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetDuration
	@abstract	Returns the total duration of a CMSampleBuffer.
	@discussion	If the buffer contains out-of-presentation-order samples, any gaps in the presentation timeline are not represented in the returned duration.
				The returned duration is simply the sum of all the individual sample durations.
	@result		The duration of the CMSampleBuffer. kCMTimeInvalid is returned if there is an error.
*/
CM_EXPORT
CMTime CMSampleBufferGetDuration(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetPresentationTimeStamp
	@abstract	Returns the numerically earliest presentation timestamp of all the samples in a CMSampleBuffer.
	@discussion	For in-presentation-order samples, this is the presentation timestamp of the first sample.
				For out-of-presentation-order samples, this is the presentation timestamp of the sample that
				will be presented first, which is not necessarily the first sample in the buffer.
	@result		Numerically earliest sample presentation timestamp in the CMSampleBuffer.  kCMTimeInvalid is returned if there is an error.
*/
CM_EXPORT
CMTime CMSampleBufferGetPresentationTimeStamp(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetDecodeTimeStamp
	@abstract	Returns the numerically earliest decode timestamp of all the samples in a CMSampleBuffer.
	@discussion	The returned decode timestamp is always the decode timestamp of the first sample in the buffer,
				since even out-of-presentation-order samples are expected to be in decode order in the buffer.
	@result		Numerically earliest sample decode timestamp in the CMSampleBuffer.  kCMTimeInvalid is returned if there is an error.
*/
CM_EXPORT
CMTime CMSampleBufferGetDecodeTimeStamp(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetOutputDuration
	@abstract	Returns the output duration of a CMSampleBuffer.
	@discussion	The OutputDuration is the duration minus any trimmed duration, all divided by the SpeedMultiplier:
				(Duration - TrimDurationAtStart - TrimDurationAtEnd) / SpeedMultiplier
	@result		The output duration of the CMSampleBuffer. kCMTimeInvalid is returned if there is an error.
*/
CM_EXPORT
CMTime CMSampleBufferGetOutputDuration(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetOutputPresentationTimeStamp
	@abstract	Returns the output presentation timestamp of the CMSampleBuffer.
	@discussion	The output presentation timestamp is the time at which the decoded, trimmed, stretched 
				and possibly reversed samples should commence being presented.
				If CMSampleBufferSetOutputPresentationTimeStamp has been called to explicitly set the output PTS, 
				CMSampleBufferGetOutputPresentationTimeStamp returns it.  
				If not, CMSampleBufferGetOutputPresentationTimeStamp calculates its result as
				(PresentationTimeStamp + TrimDurationAtStart) 
				unless kCMSampleBufferAttachmentKey_Reverse is kCFBooleanTrue, in which case it calculates the result as
				(PresentationTimeStamp + Duration - TrimDurationAtEnd).
				These are generally correct for un-stretched, un-shifted playback.
				For general forward playback in a scaled edit, the OutputPresentationTimeStamp should be set to:
				((PresentationTimeStamp + TrimDurationAtStart - EditStartMediaTime) / EditSpeedMultiplier) + EditStartTrackTime.
				For general reversed playback:
				((PresentationTimeStamp + Duration - TrimDurationAtEnd - EditStartMediaTime) / EditSpeedMultiplier) + EditStartTrackTime.
	@result		kCMTimeInvalid is returned if there is an error.
*/
CM_EXPORT
CMTime CMSampleBufferGetOutputPresentationTimeStamp(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferSetOutputPresentationTimeStamp
	@abstract	Sets an output presentation timestamp to be used in place of a calculated value.
	@discussion	The output presentation timestamp is the time at which the decoded, trimmed, stretched 
				and possibly reversed samples should commence being presented.
				By default, this is calculated by CMSampleBufferGetOutputPresentationTimeStamp.
				Call CMSampleBufferSetOutputPresentationTimeStamp to explicitly set the value for
				CMSampleBufferGetOutputPresentationTimeStamp to return.
				For general forward playback in a scaled edit, the OutputPresentationTimeStamp should be set to:
				((PresentationTimeStamp + TrimDurationAtStart - EditStartMediaTime) / EditSpeedMultiplier) + EditStartTrackTime.
				For general reversed playback:
				((PresentationTimeStamp + Duration - TrimDurationAtEnd - EditStartMediaTime) / EditSpeedMultiplier) + EditStartTrackTime.
*/
CM_EXPORT
OSStatus CMSampleBufferSetOutputPresentationTimeStamp(
	CMSampleBufferRef sbuf,	/*! @param sbuf
									CMSampleBuffer being interrogated */
	CMTime outputPresentationTimeStamp)	 /*! @param outputPresentationTimeStamp
									New value for OutputPresentationTimeStamp.  
									Pass kCMTimeInvalid to go back to the default calculation. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetOutputDecodeTimeStamp
	@abstract	Returns the output decode timestamp of the CMSampleBuffer.
	@discussion	For consistency with CMSampleBufferGetOutputPresentationTimeStamp, this is calculated as:
				OutputPresentationTimeStamp + ((DecodeTimeStamp - PresentationTimeStamp) / SpeedMultiplier).
	@result		CMInvalidTime is returned if there is an error.
*/
CM_EXPORT
CMTime CMSampleBufferGetOutputDecodeTimeStamp(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetSampleTimingInfoArray
	@abstract	Returns an array of CMSampleTimingInfo structs, one for each sample in a CMSampleBuffer.
	@discussion	If only one CMSampleTimingInfo struct is returned, it applies to all samples in the buffer.
				See documentation of CMSampleTimingInfo for details of how a single CMSampleTimingInfo struct can apply to multiple samples.
				The timingArrayOut must be allocated by the caller, and the number of entries allocated must be passed in timingArrayEntries.
				If timingArrayOut is NULL, timingArrayEntriesNeededOut will return the required number of entries.  Similarly, 
				if *timingArrayEntriesNeededOut is too small, kCMSampleBufferError_ArrayTooSmall will be returned, and timingArrayEntriesNeededOut
				will return the required number of entries. In either case, the caller can then make an appropriately-sized timingArrayOut and call again.
				For example, the caller might pass the address of a CMSampleTimingInfo struct on the stack (as timingArrayOut), and 1 (as
				timingArrayEntries). If all samples are describable with a single CMSampleTimingInfo struct (or there is only one sample
				in the CMSampleBuffer), this call will succeed. If not, it will fail, and will return the number of entries required in
				timingArrayEntriesNeededOut. Only in this case will the caller actually need to allocate an array.
				
				If there is no timingInfo in this CMSampleBuffer, kCMSampleBufferError_BufferHasNoSampleTimingInfo will be returned, and
				timingArrayEntriesNeededOut will be set to 0.
*/
CM_EXPORT
OSStatus CMSampleBufferGetSampleTimingInfoArray(
	CMSampleBufferRef sbuf,						/*! @param sbuf
													CMSampleBuffer being interrogated */
	CMItemCount timingArrayEntries,				/*! @param timingArrayEntries
													Number of entries in timingArray */
	CMSampleTimingInfo *timingArrayOut,			/*! @param timingArrayOut
													Points to an array of CMSampleTimingInfo structs
													to receive the timing info. */
	CMItemCount *timingArrayEntriesNeededOut)	/*! @param timingArrayEntriesNeededOut
													Number of entries needed for the result. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetOutputSampleTimingInfoArray
	@abstract	Returns an array of output CMSampleTimingInfo structs, one for each sample in a CMSampleBuffer.
	@discussion	If only one CMSampleTimingInfo struct is returned, it applies to all samples in the buffer.
				See documentation of CMSampleTimingInfo for details of how a single CMSampleTimingInfo struct can apply to multiple samples.
				The timingArrayOut must be allocated by the caller, and the number of entries allocated must be passed in timingArrayEntries.
				If timingArrayOut is NULL, timingArrayEntriesNeededOut will return the required number of entries.  Similarly,
				if *timingArrayEntriesNeededOut is too small, kCMSampleBufferError_ArrayTooSmall will be returned, and timingArrayEntriesNeededOut
				will return the required number of entries. In either case, the caller can then make an appropriately-sized timingArrayOut and call again.
				For example, the caller might pass the address of a CMSampleTimingInfo struct on the stack (as timingArrayOut), and 1 (as
				timingArrayEntries). If all samples are describable with a single CMSampleTimingInfo struct (or there is only one sample
				in the CMSampleBuffer), this call will succeed. If not, it will fail, and will return the number of entries required in
				timingArrayEntriesNeededOut. Only in this case will the caller actually need to allocate an array.
				
				If there is no timingInfo in this CMSampleBuffer, kCMSampleBufferError_BufferHasNoSampleTimingInfo will be returned,
				and *timingArrayEntriesNeededOut will be set to 0.
*/
CM_EXPORT
OSStatus CMSampleBufferGetOutputSampleTimingInfoArray(
	CMSampleBufferRef sbuf,						/*! @param sbuf
													CMSampleBuffer being interrogated */
	CMItemCount timingArrayEntries,				/*! @param timingArrayEntries
													Number of entries in timingArray */
	CMSampleTimingInfo *timingArrayOut,			/*! @param timingArrayOut
													Points to an array of CMSampleTimingInfo structs
													to receive the timing info. */
	CMItemCount *timingArrayEntriesNeededOut)	/*! @param timingArrayEntriesNeededOut
													Number of entries needed for the result. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetSampleTimingInfo
	@abstract	Returns a CMSampleTimingInfo struct describing a specified sample in a CMSampleBuffer.
	@discussion	A sample-specific CMSampleTimingInfo struct will be returned (ie. with a sample-specific
				presentationTimeStamp and decodeTimeStamp), even if a single CMSampleTimingInfo struct was used
				during creation to describe all the samples in the buffer. The timingInfo struct must be
				allocated by the caller.  If the sample index is not in the range 0 .. numSamples-1,
				kCMSampleBufferError_SampleIndexOutOfRange will be returned.  If there is no timingInfo
				in this CMSampleBuffer, kCMSampleBufferError_BufferHasNoSampleTimingInfo will be returned.
*/
CM_EXPORT
OSStatus CMSampleBufferGetSampleTimingInfo(
	CMSampleBufferRef sbuf,					/*! @param sbuf
												CMSampleBuffer being interrogated */
	CMItemIndex sampleIndex,				/*! @param sampleIndex
												Sample index (0 is first sample in sbuf) */
	CMSampleTimingInfo *timingInfoOut)		/*! @param timingInfoOut
												Points to a single CMSampleTimingInfo
												struct to receive the timing info. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetSampleSizeArray
	@abstract	Returns an array of sample sizes, one for each sample in a CMSampleBuffer.
	@discussion	If only one size entry is returned, all samples in the buffer are of this size.
				The sizeArrayOut must be allocated by the caller, and the number of entries allocated must be passed in sizeArrayEntries.
				If sizeArrayOut is NULL, sizeArrayEntriesNeededOut will return the required number of entries.  Similarly, if sizeArrayEntries
				is too small, kCMSampleBufferError_ArrayTooSmall will be returned, and sizeArrayEntriesNeededOut will return the required number of entries.
				The caller can then make an appropriately-sized sizeArrayOut and call again. For example, the caller might pass the address
				of a size_t variable on the stack (as sizeArrayOut), and 1 (as sizeArrayEntries). If all samples are the same size (or there
				is only one sample in the CMSampleBuffer), this call would succeed. If not, it will fail, and will return the number of
				entries required in sizeArrayEntriesNeededOut. Only in this case (multiple samples of different sizes) will the caller
				need to allocate an array.  0 entries will be returned if the samples in the buffer are non-contiguous (eg. non-interleaved
				audio, where the channel values for a single sample are scattered through the buffer).
				
				If there are no sample sizes in this CMSampleBuffer, kCMSampleBufferError_BufferHasNoSampleSizes will be returned,
				and *sizeArrayEntriesNeededOut will be set to 0.  This will be true, for example,
				if the samples in the buffer are non-contiguous (eg. non-interleaved audio, where
				the channel values for a single sample are scattered through the buffer), or if
				this CMSampleBuffer contains a CVImageBuffer.
*/
CM_EXPORT
OSStatus CMSampleBufferGetSampleSizeArray(
	CMSampleBufferRef sbuf,						/*! @param sbuf
													CMSampleBuffer being interrogated */
	CMItemCount sizeArrayEntries,				/*! @param sizeArrayEntries
													Number of entries in sizeArray. */
	size_t *sizeArrayOut,						/*! @param sizeArrayOut
													Points to an array of size_t values
													to receive the sample sizes. */
	CMItemCount *sizeArrayEntriesNeededOut)		/*! @param sizeArrayEntriesNeededOut
													Number of entries needed for the result. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
									   
/*!
	@function	CMSampleBufferGetSampleSize
	@abstract	Returns the size in bytes of a specified sample in a CMSampleBuffer.
	@result		Size in bytes of the specified sample in the CMSampleBuffer.
				If the sample index is not in the range 0 .. numSamples-1,
				a size of 0 will be returned.  If there are no sample sizes
				in this CMSampleBuffer, a size of 0 will be returned.  This will be true, for example,
				if the samples in the buffer are non-contiguous (eg. non-interleaved audio, where
				the channel values for a single sample are scattered through the buffer),
				or if this CMSampleBuffer contains a CVImageBuffer.
				
*/
CM_EXPORT
size_t CMSampleBufferGetSampleSize(
	CMSampleBufferRef sbuf,		/*! @param sbuf
									CMSampleBuffer being interrogated */
	CMItemIndex sampleIndex)	/*! @param sampleIndex
									Sample index (0 is first sample in sbuf) */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetTotalSampleSize
	@abstract	Returns the total size in bytes of sample data in a CMSampleBuffer.
	@result		Total size in bytes of sample data in the CMSampleBuffer.
				If there are no sample sizes in this CMSampleBuffer, a size of 0 will be returned.  
*/
CM_EXPORT
size_t CMSampleBufferGetTotalSampleSize(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetFormatDescription
	@abstract	Returns the format description of the samples in a CMSampleBuffer.
	@discussion On return, the caller does not own the returned formatDesc, and must retain it explicitly if the caller needs to maintain a reference to it.
	@result		The format description of the samples in the CMSampleBuffer.  NULL is returned if there is an error.
*/
CM_EXPORT
CMFormatDescriptionRef CMSampleBufferGetFormatDescription(
	CMSampleBufferRef sbuf)		/*! @param sbuf
									CMSampleBuffer being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMSampleBufferGetSampleAttachmentsArray
	@abstract	Returns a reference to a CMSampleBuffer's immutable array of mutable sample attachments dictionaries (one dictionary
				per sample in the CMSampleBuffer).
	@discussion Attachments can then be added/removed directly by the caller, using CF APIs. On return, the caller does not
				own the returned array of attachments dictionaries, and must retain it if the caller needs to maintain a
				reference to it. If there are no sample attachments yet, and createIfNecessary is true, a new CFArray containing N empty
				CFMutableDictionaries is returned (where N is the number of samples in the CMSampleBuffer), so that
				attachments can be added directly by the caller. If there are no sample attachments yet, and createIfNecessary is
				false, NULL is returned.  Once the CFArray has been created, subsequent calls will return it, even if there are still
				no sample attachments in the array.
	@result		A reference to the CMSampleBuffer's immutable array of mutable sample attachments dictionaries (one dictionary per sample
				in the CMSampleBuffer). NULL is returned if there is an error.
*/
CM_EXPORT
CFArrayRef CMSampleBufferGetSampleAttachmentsArray(
	CMSampleBufferRef sbuf,		/*! @param sbuf
									CMSampleBuffer being interrogated */
	Boolean createIfNecessary)	/*! @param createIfNecessary
									Specifies whether an empty array should be
									created (if there are no sample attachments yet). */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

// The following keys may be attached to individual samples via the CMSampleBufferGetSampleAttachmentsArray() interface:
CM_EXPORT const CFStringRef kCMSampleAttachmentKey_NotSync  // CFBoolean (absence of this key implies Sync)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleAttachmentKey_PartialSync  // CFBoolean (absence of this key implies not Partial Sync. If NotSync is false, PartialSync should be ignored.)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleAttachmentKey_HasRedundantCoding  // kCFBooleanTrue, kCFBooleanFalse, or absent if unknown
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleAttachmentKey_IsDependedOnByOthers  // kCFBooleanTrue, kCFBooleanFalse, or absent if unknown
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleAttachmentKey_DependsOnOthers  // kCFBooleanTrue, kCFBooleanFalse, or absent if unknown
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleAttachmentKey_EarlierDisplayTimesAllowed  // CFBoolean
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
// A frame is considered droppable if and only if kCMSampleAttachmentKey_IsDependedOnByOthers is present and set to kCFBooleanFalse.

CM_EXPORT const CFStringRef kCMSampleAttachmentKey_DisplayImmediately  // CFBoolean
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleAttachmentKey_DoNotDisplay  // CFBoolean
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

// The following keys may be attached to sample buffers using CMSetAttachment():
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_ResetDecoderBeforeDecoding  // CFBoolean
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_DrainAfterDecoding  // CFBoolean
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_PostNotificationWhenConsumed  // CFDictionary (client-defined)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_ResumeOutput  // CFNumber (ResumeTag)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_TransitionID
	@abstract	Marks a transition from one source of buffers (eg. song) to another
	@discussion
		For example, during gapless playback of a list of songs, this attachment marks the first buffer from the next song.
		If this attachment is on a buffer containing no samples, the first following buffer that contains samples is the
		buffer that contains the first samples from the next song.  The value of this attachment is a CFTypeRef.  This
		transition identifier should be unique within a playlist, so each transition in a playlist is uniquely
		identifiable.  A CFNumberRef counter that increments with each transition is a simple example.
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_TransitionID
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_TrimDurationAtStart
	@abstract	The duration that should be removed at the beginning of the sample buffer, after decoding.
	@discussion
		If this attachment is not present, the trim duration is zero (nothing removed).
		This is a CMTime in CFDictionary format as made by CMTimeCopyAsDictionary; 
		use CMTimeMakeFromDictionary to convert to CMTime.
		In cases where all the output after decoding the sample buffer is to be discarded 
		(eg, the samples are only being decoded to prime the decoder) the usual convention
		is to set kCMSampleBufferAttachmentKey_TrimDurationAtStart to the whole duration 
		and not to set a kCMSampleBufferAttachmentKey_TrimDurationAtEnd attachment.
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_TrimDurationAtStart  // CFDictionary/CMTime, default 0
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_TrimDurationAtEnd
	@abstract	The duration that should be removed at the end of the sample buffer, after decoding.
	@discussion
		If this attachment is not present, the trim duration is zero (nothing removed).
		This is a CMTime in CFDictionary format as made by CMTimeCopyAsDictionary; 
		use CMTimeMakeFromDictionary to convert to CMTime.
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_TrimDurationAtEnd  // CFDictionary/CMTime, default 0
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_SpeedMultiplier
	@abstract	The factor by which the sample buffer's presentation should be accelerated (eg, in a scaled edit).
	@discussion
		For normal playback the speed multiplier would be 1.0 (which is used if this attachment is not present); 
		for double-speed playback the speed multiplier would be 2.0, which would halve the output duration.
		Speed-multiplication factors take effect after trimming; see CMSampleBufferGetOutputDuration.
		Note that this attachment principally provides information about the duration-stretching effect:
		by default, it should be implemented by rate conversion, but other attachments may specify richer 
		stretching operations -- for example, scaling without pitch shift, or pitch shift without changing duration.
		Sequences of speed-multiplied sample buffers should have explicit OutputPresentationTimeStamp attachments 
		to clarify when each should be output.
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_SpeedMultiplier  // CFNumber, positive, default 1
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_Reverse
	@abstract	Indicates that the decoded contents of the sample buffer should be reversed.
		If this attachment is not present, the sample buffer should be played forwards as usual.
		Reversal occurs after trimming and speed multipliers.

*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_Reverse  // CFBoolean, default false
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_FillDiscontinuitiesWithSilence
	@abstract	Fill the difference between discontiguous sample buffers with silence.
	@discussion
		If a sample buffer enters a buffer queue and the presentation time stamp between the
		previous buffer and the buffer with this attachment are discontiguous, handle the
		discontinuity by generating silence for the time difference.
 */
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_FillDiscontinuitiesWithSilence  // CFBoolean, default false
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_EmptyMedia
	@abstract	Marks an intentionally empty interval in the sequence of samples.
	@discussion
		The sample buffer's output presentation timestamp indicates when the empty interval begins.
		Marker sample buffers with this attachment are used to announce the arrival of empty edits.
 */
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_EmptyMedia  // CFBoolean, default false
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_PermanentEmptyMedia
	@abstract	Marks the end of the sequence of samples.
	@discussion
		Marker sample buffers with this attachment in addition to kCMSampleBufferAttachmentKey_EmptyMedia
		are used to indicate that no further samples are expected.
 */
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_PermanentEmptyMedia  // CFBoolean, default false
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_DisplayEmptyMediaImmediately
	@abstract	Tells that the empty marker should be dequeued immediately regardless of its timestamp.
	@discussion
		Marker sample buffers with this attachment in addition to kCMSampleBufferAttachmentKey_EmptyMedia
		are used to tell that the empty sample buffer should be dequeued immediately regardless of its timestamp.
		This attachment should only be used with sample buffers with the kCMSampleBufferAttachmentKey_EmptyMedia
		attachment.
 */
CM_EXPORT const CFStringRef	kCMSampleBufferAttachmentKey_DisplayEmptyMediaImmediately
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_EndsPreviousSampleDuration
	@abstract	Indicates that sample buffer's decode timestamp may be used to define the previous sample buffer's duration.
	@discussion
		Marker sample buffers with this attachment may be used in situations where sample buffers are transmitted
		before their duration is known. In such situations, normally the recipient may use each sample buffer's timestamp
		to calculate the duration of the previous sample buffer. The marker sample buffer with this attachment is sent
		to provide the timestamp for calculating the final sample buffer's duration.
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_EndsPreviousSampleDuration  // CFBoolean, default false
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_SampleReferenceURL
	@abstract	Indicates the URL where the sample data is.
	@discussion
		This key is only used for CMSampleBuffers representing sample references.  
		Such CMSampleBuffers:
		 - have dataBuffer == NULL and imageBuffer == NULL
		 - have dataReady == true and no makeDataReadyCallback
		 - have a non-NULL formatDescription
		 - have numSamples > 0
		 - have numSampleTimingEntries > 0 and numSampleSizeEntries > 0
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_SampleReferenceURL  // CFURL
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_SampleReferenceByteOffset
	@abstract	Indicates the byte offset at which the sample data begins.
	@discussion
		This key is only used for CMSampleBuffers representing sample references.  
		Such CMSampleBuffers:
		 - have dataBuffer == NULL and imageBuffer == NULL
		 - have dataReady == true and no makeDataReadyCallback
		 - have a non-NULL formatDescription
		 - have numSamples > 0
		 - have numSampleTimingEntries > 0 and numSampleSizeEntries > 0
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_SampleReferenceByteOffset  // CFNumber, byte offset from beginning of URL to contiguous data
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@constant	kCMSampleBufferAttachmentKey_GradualDecoderRefresh
	@abstract	Indicates the decoder refresh count.
	@discussion
		Sample buffers with this attachment may be used to identify the audio decoder refresh count.
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_GradualDecoderRefresh  // CFNumber, audio decoder refresh count
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_3);
	
/*!
	@constant	kCMSampleBufferAttachmentKey_DroppedFrameReason
	@abstract	Indicates the reason the current video frame was dropped.
	@discussion
		Sample buffers with this attachment contain no image or data buffer.  They mark a dropped video
		frame.  This attachment identifies the reason for the droppage.
*/
CM_EXPORT const CFStringRef kCMSampleBufferAttachmentKey_DroppedFrameReason  // CFString, frame drop reason
							__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);

/*!
	@constant	kCMSampleBufferDroppedFrameReason_FrameWasLate
	@abstract	The frame was dropped because it was late
	@discussion
		The value of kCMSampleBufferAttachmentKey_DroppedFrameReason if a video capture client has indicated 
		that late video frames should be dropped and the current frame is late.  This condition is typically
		caused by the client's processing taking too long.
*/
CM_EXPORT const CFStringRef kCMSampleBufferDroppedFrameReason_FrameWasLate
							__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	
/*!
	@constant	kCMSampleBufferDroppedFrameReason_OutOfBuffers
	@abstract	The frame was dropped because the module providing frames is out of buffers
	@discussion
		The value of kCMSampleBufferAttachmentKey_DroppedFrameReason if the module providing sample buffers
		has run out of source buffers.  This condition is typically caused by the client holding onto
		buffers for too long and can be alleviated by returning buffers to the provider.
 */
CM_EXPORT const CFStringRef kCMSampleBufferDroppedFrameReason_OutOfBuffers
							__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	
/*!
	@constant	kCMSampleBufferDroppedFrameReason_Discontinuity
	@abstract	An unknown number of frames were dropped
	@discussion
		The value of kCMSampleBufferAttachmentKey_DroppedFrameReason if the module providing sample buffers
		has experienced a discontinuity, and an unknown number of frames have been lost.  This condition is 
		typically caused by the system being too busy.
 */
CM_EXPORT const CFStringRef kCMSampleBufferDroppedFrameReason_Discontinuity
							__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);

// Use CMAttachmentBearer APIs to set, get, and remove buffer-level attachments on the CMSampleBuffer itself

/*!
	@function	CMSampleBufferCallForEachSample
	@abstract	Calls a function for every individual sample in a sample buffer.
	@discussion Temporary sample buffers will be created for individual samples,
				referring to the sample data and containing its timing, size and attachments.
				The callback function may retain these sample buffers if desired.
				If the callback function returns an error, iteration will stop immediately
				and the error will be returned.
				If there are no sample sizes in the provided sample buffer, kCMSampleBufferError_CannotSubdivide will be returned.
				This will happen, for example, if the samples in the buffer are non-contiguous (eg. non-interleaved audio, where
				the channel values for a single sample are scattered through the buffer).
*/
CM_EXPORT OSStatus
CMSampleBufferCallForEachSample(
	CMSampleBufferRef sbuf,		/*! @param sbuf
									CMSampleBuffer that may contain multiple samples. */
	OSStatus (*callback)( CMSampleBufferRef sampleBuffer, CMItemCount index, void *refcon ),
								/*! @param callback
									Function to be called for each individual sample. */
	void *refcon )				/*! @param refcon
									Refcon to be passed to the callback function. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#pragma pack(pop)
    
#ifdef __cplusplus
}
#endif
	
#endif // CMSAMPLEBUFFER_H
