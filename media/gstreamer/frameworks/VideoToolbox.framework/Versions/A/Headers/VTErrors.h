/*
	File:  VTErrors.h
	
	Framework:  VideoToolbox
 
    Copyright 2006-2013 Apple Inc. All rights reserved.
  
*/

#ifndef VTERRORS_H
#define VTERRORS_H

#include <CoreMedia/CMBase.h>

#if defined(__cplusplus)
extern "C"
{
#endif
    
#pragma pack(push, 4)

// Error codes
enum {
	kVTPropertyNotSupportedErr				= -12900,
	kVTPropertyReadOnlyErr					= -12901,
	kVTParameterErr							= -12902,
	kVTInvalidSessionErr					= -12903,
	kVTAllocationFailedErr					= -12904,
	kVTPixelTransferNotSupportedErr			= -12905, // c.f. -8961
	kVTCouldNotFindVideoDecoderErr			= -12906,
	kVTCouldNotCreateInstanceErr			= -12907,
	kVTCouldNotFindVideoEncoderErr			= -12908,
	kVTVideoDecoderBadDataErr				= -12909, // c.f. -8969
	kVTVideoDecoderUnsupportedDataFormatErr	= -12910, // c.f. -8970
	kVTVideoDecoderMalfunctionErr			= -12911, // c.f. -8960
	kVTVideoEncoderMalfunctionErr			= -12912,
	kVTVideoDecoderNotAvailableNowErr		= -12913,
	kVTImageRotationNotSupportedErr			= -12914,
	kVTVideoEncoderNotAvailableNowErr		= -12915,
	kVTFormatDescriptionChangeNotSupportedErr	= -12916,
	kVTInsufficientSourceColorDataErr		= -12917,
	kVTCouldNotCreateColorCorrectionDataErr	= -12918,
	kVTColorSyncTransformConvertFailedErr	= -12919,
	kVTVideoDecoderAuthorizationErr			= -12210,
	kVTVideoEncoderAuthorizationErr			= -12211,
	kVTColorCorrectionPixelTransferFailedErr	= -12212,
};

/*!
	@enum		VTDecodeFrameFlags
	@abstract	Directives for the decompression session and the video decoder, passed into
				decodeFlags parameter of VTDecompressionSessionDecodeFrame.

	@constant	kVTDecodeFrame_EnableAsynchronousDecompression
		With the kVTDecodeFrame_EnableAsynchronousDecompression bit clear, the video decoder 
		is compelled to emit every frame before it returns.  With the bit set, the decoder may 
		process frames asynchronously, but it is not compelled to do so.  
	@constant	kVTDecodeFrame_DoNotOutputFrame
		A hint to the decompression session and video decoder that a CVImageBuffer should not
		be emitted for this frame.  NULL will be returned instead. 
	@constant	kVTDecodeFrame_1xRealTimePlayback
		A hint to the video decoder that it would be OK to use a low-power mode that can not decode faster than 1x realtime.
	@constant	kVTDecodeFrame_EnableTemporalProcessing
		With the kVTDecodeFrame_EnableTemporalProcessing bit clear, the video decoder should emit 
		every frame once that frame's decoding is done -- frames may not be delayed indefinitely.  With 
		the bit set, it is legal for the decoder to delay frames indefinitely -- at least 
		until VTDecompressionSessionFinishDelayedFrames or VTDecompressionSessionInvalidate is called.
*/
typedef uint32_t VTDecodeFrameFlags;
enum {
	kVTDecodeFrame_EnableAsynchronousDecompression = 1<<0,
	kVTDecodeFrame_DoNotOutputFrame = 1<<1,
	kVTDecodeFrame_1xRealTimePlayback = 1<<2, 
	kVTDecodeFrame_EnableTemporalProcessing = 1<<3,
};

// Informational status for decoding -- non-error flags 
typedef UInt32 VTDecodeInfoFlags;
enum {
	kVTDecodeInfo_Asynchronous = 1UL << 0,
	kVTDecodeInfo_FrameDropped = 1UL << 1,
};

// Informational status for encoding -- non-error flags 
typedef UInt32 VTEncodeInfoFlags;
enum {
	kVTEncodeInfo_Asynchronous = 1UL << 0,
	kVTEncodeInfo_FrameDropped = 1UL << 1,
};

#pragma pack(pop)

#if defined(__cplusplus)
}
#endif

#endif // VTERRORS_H
