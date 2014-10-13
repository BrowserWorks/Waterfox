/*
	File:  VTDecompressionProperties.h
	
	Framework:  VideoToolbox
 
    Copyright 2007-2013 Apple Inc. All rights reserved.
  
	Standard Video Toolbox decompression properties.
*/

#ifndef VTDECOMPRESSIONPROPERTIES_H
#define VTDECOMPRESSIONPROPERTIES_H

#include <CoreMedia/CMBase.h>
#include <VideoToolbox/VTBase.h>

#include <CoreFoundation/CoreFoundation.h>

#if defined(__cplusplus)
extern "C"
{
#endif
    
#pragma pack(push, 4)

/*!
	@header
	@abstract
		Standard Video Toolbox decompression properties
		
	@discussion
		This file defines standard properties used to describe and configure decompression 
		operations managed by the video toolbox.  
		
		The video toolbox will provide direct support for some of these properties.
		Some properties are supported by individual decoders.
		
		Clients can query supported properties by calling VTSessionCopySupportedPropertyDictionary.
*/

#pragma mark Pixel buffer pools

// Standard properties regarding buffer recycling.  
// These are implemented by the video toolbox.

/*!
	@constant	kVTDecompressionPropertyKey_PixelBufferPool
	@abstract
		A pixel buffer pool for pixel buffers being output by the decompression session.
	@discussion
		This pixel buffer pool is always compatible with the client's pixel buffer attributes
		as specified when calling VTDecompressionSessionCreate.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_PixelBufferPool VT_AVAILABLE_STARTING(10_8); // Read-only, CVPixelBufferPool

/*!
	@constant	kVTDecompressionPropertyKey_PixelBufferPoolIsShared
	@abstract
		Indicates whether a common pixel buffer pool is shared between
		the video decoder and the session client. 
	@discussion
		This is false if separate pools are used because the pixel buffer attributes specified 
		by the video decoder and the client were incompatible.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_PixelBufferPoolIsShared VT_AVAILABLE_STARTING(10_8); // Read-only, CFBoolean

/*!
	@constant	kVTDecompressionPropertyKey_OutputPoolRequestedMinimumBufferCount
	@abstract
		Requests that the VTDecompressionSession use the value provided as a minimum buffer
		count for its output CVPixelBufferPool, not releasing buffers while the number in
		use is below this level.
	@discussion
		This property effectively requests that the kCVPixelBufferPoolMinimumBufferCountKey key
		be used for the creation of the output CVPixelBufferPool.
		
		For general playback cases, standard CVPixelBufferPool age-out behaviour should be 
		sufficient and this property should not be needed.  This property should only be used in 
		unusual playback scenarios where a peak pool level is known, and the potential 
		memory overhead is an acceptable tradeoff for avoiding possible buffer reallocation.
		
		Setting this property to NULL or passing in the value 0 will clear this setting and
		remove the minimum buffer count.
		
		Setting this property while a VTDecompressionSession is in use will result in the 
		creation of a new CVPixelBufferPool. This will cause new buffers to be allocated, and 
		existing buffers to be deallocated when they are released.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_OutputPoolRequestedMinimumBufferCount VT_AVAILABLE_STARTING(10_9); // Read/Write, CFNumberRef

#pragma mark Asynchronous state

// Standard properties regarding asynchronous state.  
// These are implemented by the video toolbox.

/*!
	@constant	kVTDecompressionPropertyKey_NumberOfFramesBeingDecoded
	@abstract
		Returns the number of frames currently being decoded.
	@discussion
		This number may decrease asynchronously as frames are output.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_NumberOfFramesBeingDecoded VT_AVAILABLE_STARTING(10_8); // Read-only, CFNumber. 

/*!
	@constant	kVTDecompressionPropertyKey_MinOutputPresentationTimeStampOfFramesBeingDecoded
	@abstract
		The minimum output presentation timestamp of the frames currently being decoded.
	@discussion
		This may change asynchronously as frames are output.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_MinOutputPresentationTimeStampOfFramesBeingDecoded VT_AVAILABLE_STARTING(10_8); // Read-only, CMTime as CFDictionary.  

/*!
	@constant	kVTDecompressionPropertyKey_MaxOutputPresentationTimeStampOfFramesBeingDecoded
	@abstract
		The maximum output presentation timestamp of the frames currently being decoded.
	@discussion
		This may change asynchronously as frames are output.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_MaxOutputPresentationTimeStampOfFramesBeingDecoded VT_AVAILABLE_STARTING(10_8); // Read-only, CMTime as CFDictionary.  
	
#pragma mark Content

// Standard properties describing content.
// Video decoders may optionally report these.

/*!
	@constant	kVTDecompressionPropertyKey_ContentHasInterframeDependencies
	@abstract
		Indicates whether the content being decoded has interframe dependencies, if the decoder knows.
	@discussion
		This is an optional property for video decoders to implement.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_ContentHasInterframeDependencies VT_AVAILABLE_STARTING(10_8); // Read-only, CFBoolean

#pragma mark Hardware acceleration

/*!
	@constant	kVTVideoDecoderSpecification_EnableHardwareAcceleratedVideoDecoder
	@abstract
		If set to kCFBooleanTrue, the VideoToolbox will use a hardware accelerated video decoder if available.  If set to
		kCFBooleanFalse, hardware decode will never be used.
	@discussion
		This key is set in the decoderSpecification passed in to VTDecompressionSessionCreate.  Set it
		to kCFBooleanTrue to allow hardware accelerated decode.  To specifically prevent hardware decode,
		this property can be set to kCFBooleanFalse.
		This is useful for clients doing realtime decode operations to allow the VideoToolbox
		to choose the optimal decode path.
*/
VT_EXPORT const CFStringRef kVTVideoDecoderSpecification_EnableHardwareAcceleratedVideoDecoder VT_AVAILABLE_STARTING(10_9); // CFBoolean, Optional

/*!
	@constant	kVTVideoDecoderSpecification_RequireHardwareAcceleratedVideoDecoder
	@abstract
		If set to kCFBooleanTrue, the VideoToolbox will try to allocate a hardware accelerated decoder and
		return an error if that isn't possible.
		Setting this key automatically implies kVTVideoDecoderSpecification_EnableHardwareAcceleratedVideoDecoder --
		there is no need to set both and the Enable key does nothing if the Require key is set.
	@discussion
		This key is set in the decoderSpecification passed in to VTDecompressionSessionCreate.  Set it
		to kCFBooleanTrue to require hardware accelerated decode.  If hardware acceleration is not
		possible, the VTDecompressionSessionCreate call will fail.
		This key is useful for clients that have their own software decode implementation or
		those that may want to configure software and hardware decode sessions differently.
		Hardware acceleration may be unavailable for a number of reasons.  A few common cases are:
			- the machine does not have hardware acceleration capabilities
			- the requested decoding format or configuration is not supported
			- the hardware decode resources on the machine are busy
*/
VT_EXPORT const CFStringRef kVTVideoDecoderSpecification_RequireHardwareAcceleratedVideoDecoder VT_AVAILABLE_STARTING(10_9); // CFBoolean, Optional

/*!
	@constant	kVTDecompressionPropertyKey_UsingHardwareAcceleratedVideoDecoder
	@abstract
		If set to kCFBooleanTrue, a hardware accelerated video decoder is being used.
	@discussion
		You can query this property using VTSessionCopyProperty after you have enabled hardware
		accelerated decode using kVTVideoDecoderSpecification_EnableHardwareAcceleratedVideoDecoder
		to see if a hardware accelerated decoder was selected.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_UsingHardwareAcceleratedVideoDecoder VT_AVAILABLE_STARTING(10_9) ; // CFBoolean, Read; assumed false by default

#pragma mark Decoder behavior

// Standard properties regarding decoder behavior.
// Video decoders may report optionally report these.

/*!
	@constant	kVTDecompressionPropertyKey_ThreadCount
	@abstract
		Gets number of threads used by codec or suggests number of threads to use.
	@discussion
		This is an optional property for video decoders to implement.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_ThreadCount VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber

// Standard properties about quality of service.
// By default, a decoder should completely decode every frame at full resolution.
// A decoder may support properties to modify the quality of service, using these keys and/or custom keys.

/*!
	@constant	kVTDecompressionPropertyKey_FieldMode
	@abstract
		Requests special handling of interlaced content.  
	@discussion
		This is an optional property for video decoders to implement.
		Decoders should only accept the modes that they will implement.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_FieldMode VT_AVAILABLE_STARTING(10_8); // Read/write, CFString, one of
VT_EXPORT const CFStringRef kVTDecompressionProperty_FieldMode_BothFields VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTDecompressionProperty_FieldMode_TopFieldOnly VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTDecompressionProperty_FieldMode_BottomFieldOnly VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTDecompressionProperty_FieldMode_SingleField VT_AVAILABLE_STARTING(10_8);  // Most appropriate of either TopFieldOnly or BottomFieldOnly
VT_EXPORT const CFStringRef kVTDecompressionProperty_FieldMode_DeinterlaceFields VT_AVAILABLE_STARTING(10_8);

/*!
	@constant	kVTDecompressionPropertyKey_DeinterlaceMode
	@abstract
		Requests a specific deinterlacing technique.  
	@discussion
		This is an optional property for video decoders to implement.
		Decoders should only accept the modes that they will implement.
		This property is only applicable if kVTDecompressionPropertyKey_FieldMode 
		is set to kVTDecompressionProperty_FieldMode_DeinterlaceFields.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_DeinterlaceMode VT_AVAILABLE_STARTING(10_8);   // Read/write, CFString; only applicable if kVTDecompressionPropertyKey_FieldMode is kVTDecompressionProperty_FieldMode_DeinterlaceFields; supported values may include:
VT_EXPORT const CFStringRef kVTDecompressionProperty_DeinterlaceMode_VerticalFilter VT_AVAILABLE_STARTING(10_8);   // apply 0.25-0.50-0.25 vertical filter to individual interlaced frames; default mode
VT_EXPORT const CFStringRef kVTDecompressionProperty_DeinterlaceMode_Temporal VT_AVAILABLE_STARTING(10_8);	// apply filter that makes use of a window of multiple frames to generate deinterlaced results, and provides a better result at the expense of a pipeline delay; this mode is only used if kVTDecodeFrame_EnableTemporalProcessing is set, otherwise a non-temporal mode (eg, VerticalFilter) will be used instead

/*!
	@constant	kVTDecompressionPropertyKey_ReducedResolutionDecode
	@abstract
		Requests decoding at a smaller resolution than full-size.  
	@discussion
		This is an optional property for video decoders to implement.
		Decoders that only support a fixed set of resolutions should pick the smallest resolution 
		greater than or equal to the requested width x height.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_ReducedResolutionDecode VT_AVAILABLE_STARTING(10_8); // Read/write, CFDictionary containing width and height keys and CFNumber values:
VT_EXPORT const CFStringRef kVTDecompressionResolutionKey_Width VT_AVAILABLE_STARTING(10_8); // CFNumber
VT_EXPORT const CFStringRef kVTDecompressionResolutionKey_Height VT_AVAILABLE_STARTING(10_8); // CFNumber

/*!
	@constant	kVTDecompressionPropertyKey_ReducedCoefficientDecode
	@abstract
		Requests approximation during decoding.  
	@discussion
		This is an optional property for video decoders to implement.
		Only decoders for which such approximations make sense should implement this property.
		The meaning of the number of coefficients will be decoder-specific.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_ReducedCoefficientDecode VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber

/*!
	@constant	kVTDecompressionPropertyKey_ReducedFrameDelivery
	@abstract
		Requests frame dropping.
	@discussion
		This is an optional property for video decoders to implement.
		This number is a fraction between 0.0 and 1.0 that indicates what proportion of frames 
		should be delivered -- others may be dropped.  
		For example, 0.25 would indicate that only one frame in every 4 should be delivered.  
		This is a guideline; actual selection of frames is up to the decoder, which will know 
		which frames can be skipped without harm.
		If the decoder does not support this property directly, but reports that the content has 
		no interframe dependencies, the video toolbox may step in and perform simple frame dropping.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_ReducedFrameDelivery VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber in range [0.0,1.0].

/*!
	@constant	kVTDecompressionPropertyKey_OnlyTheseFrames
	@abstract
		Requests that frames be filtered by type.  
	@discussion
		This is an optional property for video decoders to implement.
		If kVTDecompressionPropertyKey_ReducedFrameDelivery is supported and used in conjunction with 
		this property, the ReducedFrameDelivery is the proportion of the frames selected by this property: 
		0.25 and IFrames would indicate that only one I frame in every four should be delivered.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_OnlyTheseFrames VT_AVAILABLE_STARTING(10_8); // Read/write, CFString, supported values may include:
VT_EXPORT const CFStringRef kVTDecompressionProperty_OnlyTheseFrames_AllFrames VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTDecompressionProperty_OnlyTheseFrames_NonDroppableFrames VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTDecompressionProperty_OnlyTheseFrames_IFrames VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTDecompressionProperty_OnlyTheseFrames_KeyFrames VT_AVAILABLE_STARTING(10_8);


/*!
	@constant	kVTDecompressionPropertyKey_SuggestedQualityOfServiceTiers
	@abstract
		Suggests how quality-of-service may be lowered in order to maintain realtime playback.
	@discussion
		This is an optional property for video decoders to implement.
		This property value is an array containing dictionaries of property key/value pairs.  
		The first dictionary in the array should contain the set of properties that restore the 
		default (full) quality of service; later dictionaries should contain property sets with 
		decreasing qualities of service.  Clients may work their way down these tiers until they are 
		able to keep up with the frame rate.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_SuggestedQualityOfServiceTiers VT_AVAILABLE_STARTING(10_8); // Read-only, CFArray of CFDictionaries containing property key/value pairs

/*!
	@constant	kVTDecompressionPropertyKey_SupportedPixelFormatsOrderedByQuality
	@abstract
		Provides hints about quality tradeoffs between pixel formats.
	@discussion
		This is an optional property for video decoders to implement.
		This property value is an array containing CFNumbers holding CMPixelFormatType values,
		ordered by quality from best to worse.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_SupportedPixelFormatsOrderedByQuality VT_AVAILABLE_STARTING(10_8); // Read-only, CFArray[CFNumber(CMPixelFormatType)] ordered best to worst, optional

/*!
	@constant	kVTDecompressionPropertyKey_SupportedPixelFormatsOrderedByPerformance
	@abstract
		Provides hints about speed tradeoffs between pixel formats.
	@discussion
		This is an optional property for video decoders to implement.
		This property value is an array containing CFNumbers holding CMPixelFormatType values,
		ordered by speed from fast to slow.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_SupportedPixelFormatsOrderedByPerformance VT_AVAILABLE_STARTING(10_8); // Read-only, CFArray[CFNumber(CMPixelFormatType)] ordered fast to slow, optional

/*!
	@constant	kVTDecompressionPropertyKey_PixelFormatsWithReducedResolutionSupport
	@abstract
		Indicates which pixel formats support reduced resolution decoding.
	@discussion
		This is an optional property for video decoders to implement.
		This property value is an array containing CFNumbers holding CMPixelFormatType values.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_PixelFormatsWithReducedResolutionSupport VT_AVAILABLE_STARTING(10_8); // Read-only, CFArray[CFNumber(CMPixelFormatType)], optional

#pragma mark Post-decompression processing

// Standard properties about processing to be performed after decompression.
// These are implemented by the video toolbox.

/*!
	@constant	kVTDecompressionPropertyKey_PixelTransferProperties
	@abstract
		Requests particular pixel transfer features.  
	@discussion
		This property is implemented by the video toolbox.
		This property value is a CFDictionary containing properties from VTPixelTransferProperties.h.
*/
VT_EXPORT const CFStringRef kVTDecompressionPropertyKey_PixelTransferProperties VT_AVAILABLE_STARTING(10_8); // Read/Write, CFDictionary containing properties from VTPixelTransferProperties.h.


#pragma pack(pop)
    
#if defined(__cplusplus)
}
#endif

#endif // VTDECOMPRESSIONPROPERTIES_H
