/*
	File:  VTDecompressionSession.h
	
	Framework:  VideoToolbox
 
    Copyright 2006-2013 Apple Inc. All rights reserved.
  
	Video Toolbox client API for decompressing video frames.
	
	Decompression sessions convert compressed video frames in CMSampleBuffers 
	into uncompressed frames in CVImageBuffers.
*/

#ifndef VTDECOMPRESSIONSESSION_H
#define VTDECOMPRESSIONSESSION_H

#include <CoreMedia/CMBase.h>
#include <VideoToolbox/VTBase.h>

#include <CoreFoundation/CoreFoundation.h>
#include <CoreVideo/CoreVideo.h>
#include <CoreMedia/CMSampleBuffer.h>
#include <CoreMedia/CMFormatDescription.h>
#include <CoreMedia/CMTime.h>

#include <VideoToolbox/VTSession.h>
#include <VideoToolbox/VTDecompressionProperties.h>

#include <VideoToolbox/VTErrors.h>

#if defined(__cplusplus)
extern "C"
{
#endif
    
#pragma pack(push, 4)

/*!
	@typedef	VTDecompressionSessionRef
	@abstract	A reference to a Video Toolbox Decompression Session.
	@discussion
		A decompression session supports the decompression of a sequence of video frames.
		The session reference is a reference-counted CF object.
		To create a decompression session, call VTDecompressionSessionCreate; 
		then you can optionally configure the session using VTSessionSetProperty;
		then to decode frames, call VTDecompressionSessionDecodeFrame.
		When you are done with the session, you should call VTDecompressionSessionInvalidate
		to tear it down and CFRelease to release your object reference.
 */

typedef struct OpaqueVTDecompressionSession*  VTDecompressionSessionRef;

/*!
	@typedef	VTDecompressionOutputCallback
    @abstract   Prototype for callback invoked when frame decompression is complete.
    @discussion 
		When you create a decompression session, you pass in a callback function to be called 
		for decompressed frames.  This function will not necessarily be called in display order.
	@param	decompressionOutputRefCon
		The callback's reference value, copied from the decompressionOutputRefCon field of the
		VTDecompressionOutputCallbackRecord structure.
	@param	sourceFrameRefCon
		The frame's reference value, copied from the sourceFrameRefCon argument to 
		VTDecompressionSessionDecodeFrame.
	@param	status
		noErr if decompression was successful; an error code if decompression was not successful.
	@param	infoFlags
		Contains information about the decode operation.
		The kVTDecodeInfo_Asynchronous bit may be set if the decode ran asynchronously.
		The kVTDecodeInfo_FrameDropped bit may be set if the frame was dropped.
	@param	imageBuffer
		Contains the decompressed frame, if decompression was successful; otherwise, NULL.
		IMPORTANT: Do not modify the image in this buffer.  The video decoder may retain it
		and use it for generating subsequent frames.
	@param	presentationTimeStamp
		The frame's presentation timestamp; kCMTimeInvalid if not available.
	@param	presentationDuration
		The frame's presentation duration; kCMTimeInvalid if not available.
*/

typedef void (*VTDecompressionOutputCallback)(
		void *decompressionOutputRefCon, 
		void *sourceFrameRefCon, 
		OSStatus status, 
		VTDecodeInfoFlags infoFlags,
		CVImageBufferRef imageBuffer, 
		CMTime presentationTimeStamp, 
		CMTime presentationDuration );

struct VTDecompressionOutputCallbackRecord {
	VTDecompressionOutputCallback  decompressionOutputCallback;
	void *                         decompressionOutputRefCon;
};
typedef struct VTDecompressionOutputCallbackRecord VTDecompressionOutputCallbackRecord;

/*!
	@function	VTDecompressionSessionCreate
	@abstract	Creates a session for decompressing video frames.
    @discussion 
		Decompressed frames will be emitted through calls to outputCallback.
	@param	allocator
		An allocator for the session.  Pass NULL to use the default allocator.
	@param	videoFormatDescription
		Describes the source video frames.
	@param	videoDecoderSpecification
		Specifies a particular video decoder that must be used.  
		Pass NULL to let the video toolbox choose a decoder.
	@param	destinationImageBufferAttributes
		Describes requirements for emitted pixel buffers.
		Pass NULL to set no requirements.
	@param	outputCallback
		The callback to be called with decompressed frames.
	@param	decompressionSessionOut
		Points to a variable to receive the new decompression session.
	
*/
VT_EXPORT OSStatus 
VTDecompressionSessionCreate(
	CFAllocatorRef                              allocator,                                /* can be NULL */
	CMVideoFormatDescriptionRef                 videoFormatDescription,
	CFDictionaryRef								videoDecoderSpecification,                /* can be NULL */
	CFDictionaryRef                             destinationImageBufferAttributes,         /* can be NULL */
	const VTDecompressionOutputCallbackRecord * outputCallback,
	VTDecompressionSessionRef *                 decompressionSessionOut) VT_AVAILABLE_STARTING(10_8);

/*!
	@function	VTDecompressionSessionInvalidate
	@abstract	Tears down a decompression session.
    @discussion 
    	When you are done with a decompression session you created, call VTDecompressionSessionInvalidate 
    	to tear it down and then CFRelease to release your object reference.
    	When a decompression session's retain count reaches zero, it is automatically invalidated, but 
    	since sessions may be retained by multiple parties, it can be hard to predict when this will happen.
    	Calling VTDecompressionSessionInvalidate ensures a deterministic, orderly teardown.
*/
VT_EXPORT void 
VTDecompressionSessionInvalidate( VTDecompressionSessionRef session ) VT_AVAILABLE_STARTING(10_8);

/*!
	@function VTDecompressionSessionGetTypeID
	@abstract Returns the CFTypeID for decompression sessions.  
*/
VT_EXPORT CFTypeID 
VTDecompressionSessionGetTypeID(void) VT_AVAILABLE_STARTING(10_8);

/*!
	@function	VTDecompressionSessionDecodeFrame
	@abstract	Decompresses a video frame.
	@param	session
		The decompression session.
	@param	sampleBuffer
		A CMSampleBuffer containing one or more video frames.  
	@param	decodeFlags
		A bitfield of directives to the decompression session and decoder.
		The kVTDecodeFrame_EnableAsynchronousDecompression bit indicates whether the video decoder 
		may decompress the frame asynchronously.
		The kVTDecodeFrame_EnableTemporalProcessing bit indicates whether the decoder may delay calls to the output callback
		so as to enable processing in temporal (display) order.
		If both flags are clear, the decompression shall complete and your output callback function will be called 
		before VTDecompressionSessionDecodeFrame returns.
		If either flag is set, VTDecompressionSessionDecodeFrame may return before the output callback function is called.  
	@param	sourceFrameRefCon
		Your reference value for the frame.  
		Note that if sampleBuffer contains multiple frames, the output callback function will be called
		multiple times with this sourceFrameRefCon.
	@param	infoFlagsOut
		Points to a VTDecodeInfoFlags to receive information about the decode operation.
		The kVTDecodeInfo_Asynchronous bit may be set if the decode is (or was) running
		asynchronously.
		The kVTDecodeInfo_FrameDropped bit may be set if the frame was dropped (synchronously).
		Pass NULL if you do not want to receive this information.
*/
VT_EXPORT OSStatus
VTDecompressionSessionDecodeFrame(
	VTDecompressionSessionRef       session,
	CMSampleBufferRef               sampleBuffer,
	VTDecodeFrameFlags              decodeFlags, // bit 0 is enableAsynchronousDecompression
	void *                          sourceFrameRefCon,
	VTDecodeInfoFlags               *infoFlagsOut /* may be NULL */ ) VT_AVAILABLE_STARTING(10_8);

/*!
	@function VTDecompressionSessionFinishDelayedFrames
	@abstract Directs the decompression session to emit all delayed frames.
	@discussion
		By default, the decompression session may not delay frames indefinitely; 
		frames may only be indefinitely delayed if the client opts in via
		kVTDecodeFrame_EnableTemporalProcessing.
		IMPORTANT NOTE: This function may return before all delayed frames are emitted. 
		To wait for them, call VTDecompressionSessionWaitForAsynchronousFrames instead.
*/
VT_EXPORT OSStatus
VTDecompressionSessionFinishDelayedFrames(
	VTDecompressionSessionRef		session) VT_AVAILABLE_STARTING(10_8);

/*!
	@function VTDecompressionSessionCanAcceptFormatDescription
	@abstract Indicates whether the session can decode frames with the given format description.
	@discussion
		Some video decoders are able to accommodate minor changes in format without needing to be
		completely reset in a new session.  This function can be used to test whether a format change
		is sufficiently minor.
*/
VT_EXPORT Boolean 
VTDecompressionSessionCanAcceptFormatDescription( 
	VTDecompressionSessionRef		session, 
	CMFormatDescriptionRef			newFormatDesc ) VT_AVAILABLE_STARTING(10_8);

/*!
	@function VTDecompressionSessionWaitForAsynchronousFrames
	@abstract Waits for any and all outstanding asynchronous and delayed frames to complete, then returns.
	@discussion
		This function automatically calls VTDecompressionSessionFinishDelayedFrames, 
		so clients don't have to call both.  
*/
VT_EXPORT OSStatus
VTDecompressionSessionWaitForAsynchronousFrames(
	VTDecompressionSessionRef       session) VT_AVAILABLE_STARTING(10_8);

/*!
	@function	VTDecompressionSessionCopyBlackPixelBuffer
	@abstract	Copies a black pixel buffer from the decompression session.
    @discussion 
		The pixel buffer is in the same format that the session is decompressing to.
	@param	session
		The decompression session.
	@param	pixelBufferOut
		Points to a variable to receive the copied pixel buffer.
	
*/
VT_EXPORT OSStatus
VTDecompressionSessionCopyBlackPixelBuffer(
   VTDecompressionSessionRef		session,
   CVPixelBufferRef					*pixelBufferOut ) VT_AVAILABLE_STARTING(10_8);
	
// See VTSession.h for property access APIs on VTDecompressionSessions.
// See VTDecompressionProperties.h for standard property keys and values for decompression sessions.

    
#pragma pack(pop)
    
#if defined(__cplusplus)
}
#endif


#endif // VTDECOMPRESSIONSESSION_H
