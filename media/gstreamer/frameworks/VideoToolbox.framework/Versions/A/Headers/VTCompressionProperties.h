/*
	File:  VTCompressionProperties.h
	
	Framework:  VideoToolbox
	
	Copyright 2007-2013 Apple Inc. All rights reserved.
	
	Standard Video Toolbox compression properties.
*/

#ifndef VTCOMPRESSIONPROPERTIES_H
#define VTCOMPRESSIONPROPERTIES_H

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
		Standard Video Toolbox compression properties
		
	@discussion
		This file defines standard properties used to describe and configure compression 
		operations managed by the video toolbox.  
		
		The video toolbox will provide direct support for some of these properties.
		Some properties are supported by individual encoders.
		
		Clients can query supported properties by calling VTSessionCopySupportedPropertyDictionary.
*/

#pragma mark Buffers

// Standard properties regarding buffer recycling.  
// These are implemented by the video toolbox.

/*!
	@constant	kVTCompressionPropertyKey_NumberOfPendingFrames
	@abstract
		The number of pending frames in the compression session. 
	@discussion
		This number may decrease asynchronously.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_NumberOfPendingFrames VT_AVAILABLE_STARTING(10_8); // Read-only, CFNumber<int>	
	
/*!
	@constant	kVTCompressionPropertyKey_PixelBufferPoolIsShared
	@abstract
		Indicates whether the a common pixel buffer pool is shared between
		the video encoder and the session client. 
	@discussion
		This is false if separate pools are used because the video encoder's 
		and the client's pixel buffer attributes were incompatible.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_PixelBufferPoolIsShared VT_AVAILABLE_STARTING(10_8); // Read-only, CFBoolean

/*!
	@constant	kVTCompressionPropertyKey_VideoEncoderPixelBufferAttributes
	@abstract
		The video encoder's pixel buffer attributes for the compression session. 
	@discussion
		You can use these to create a pixel buffer pool for source pixel buffers. 
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_VideoEncoderPixelBufferAttributes VT_AVAILABLE_STARTING(10_8); // Read-only, CFDictionary

// Standard properties describing content.

// Standard properties regarding encoder behavior.
// Video encoders may report optionally report these.

#pragma mark Frame dependency

/*!
	@constant	kVTCompressionPropertyKey_MaxKeyFrameInterval
	@abstract
		The maximum interval between key frames, also known as the key frame rate. 
	@discussion
		Key frames, also known as sync frames, reset inter-frame
		dependencies; decoding a key frame is sufficient to prepare a
		decoder for correctly decoding the difference frames that
		follow. 
		Video encoders are allowed to generate key frames more frequently if
		this would result in more efficient compression. 
		The default key frame interval is 0, which indicates that the
		video encoder should choose where to place all key frames. A key
		frame interval of 1 indicates that every frame must be a key
		frame, 2 indicates that at least every other frame must be a key
		frame, etc.
		See also kVTCompressionPropertyKey_AllowTemporalCompression.
		
		This key can be set in conjunction with 
		kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration,
		and both limits will be enforced - requiring a keyframe every X
		frames or every Y seconds, whichever comes first.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_MaxKeyFrameInterval VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber<int>, Optional

/*!
	@constant	kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration
	@abstract
		The maximum duration from one key frame to the next in seconds. 
	@discussion
		Zero by default, which means no limit.  
		This property is particularly useful when the frame rate is variable.
		See kVTCompressionPropertyKey_MaxKeyFrameInterval for more discussion
		of key frames.
		
		This key can be set in conjunction with 
		kVTCompressionPropertyKey_MaxKeyFrameInterval,
		and both limits will be enforced - requiring a keyframe every X
		frames or every Y seconds, whichever comes first.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber<seconds>, Optional


/*!
	@constant	kVTCompressionPropertyKey_AllowTemporalCompression
	@abstract
		Enables temporal compression.
	@discussion
		True by default.  Set this to false to require key-frame-only compression.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_AllowTemporalCompression VT_AVAILABLE_STARTING(10_8); // Read/Write, CFBoolean, Optional, defaults to true

/*!
	@constant	kVTCompressionPropertyKey_AllowFrameReordering
	@abstract
		Enables frame reordering. 
	@discussion
		In order to encode B frames, a video encoder must reorder frames,
		which means that the order in which they will be emitted and
		stored (the decode order) is different from the order in which
		they were presented to the video encoder (the display order). 
		True by default.  Set this to false to prevent frame reordering.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_AllowFrameReordering VT_AVAILABLE_STARTING(10_8); // Read/Write, CFBoolean, Optional, defaults to true

#pragma mark Rate control

/*!
	@constant	kVTCompressionPropertyKey_AverageBitRate
	@abstract
		The long-term desired average bit rate in bits per second. 
	@discussion
		This is not a hard limit; the bit rate may peak above this. 
		The default bit rate is zero, which indicates that the video encoder 
		should determine the size of compressed data. 
		Note that bit rate settings only have an effect when timing
		information is provided for source frames, and that some codecs do
		not support limiting to specified bit rates.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_AverageBitRate VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber<SInt32>, Optional

/*!
	@constant	kVTCompressionPropertyKey_DataRateLimits
	@abstract
		Zero, one or two hard limits on data rate.
	@discussion
		Each hard limit is described by a data size in bytes and a
		duration in seconds, and requires that the total size of
		compressed data for any contiguous segment of that duration (in
		decode time) must not exceed the data size. 
		By default, no data rate limits are set. 
		The property is a CFArray of an even number of CFNumbers,
		alternating between bytes and seconds.
		Note that data rate settings only have an effect when timing
		information is provided for source frames, and that some codecs do
		not support limiting to specified data rates.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_DataRateLimits VT_AVAILABLE_STARTING(10_8); // Read/write, CFArray[CFNumber], [bytes, seconds, bytes, seconds...], Optional

/*!
	@constant	kVTCompressionPropertyKey_Quality
	@abstract
		The desired compression quality.
	@discussion
		Some encoders, such as JPEG, describe the compression level of each
		image with a quality value.  This value should be specified as a
		number in the range of 0.0 to 1.0, where low = 0.25, normal = 0.50,
		high = 0.75, and 1.0 implies lossless compression for encoders that
		support it.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_Quality VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber<Float>, Optional

/*!
	@constant	kVTCompressionPropertyKey_MoreFramesBeforeStart
	@abstract
		Indicates whether and how a compression session's frames will be
		concatenated with other compressed frames to form a longer series.
	@discussion
		True if frames compressed in a separate session will be
		concatenated before the beginning of this one.  False if this is a
		stand-alone session, or if this session will encode the first
		segment of a multi-segment compression. By default, false.
		
		This information enables video encoders to ensure that compressed
		segments can be concatenated smoothly -- for example, avoiding
		data rate spikes where segments are joined. 
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_MoreFramesBeforeStart VT_AVAILABLE_STARTING(10_8); // Read/write, CFBoolean, Optional

/*!
	@constant	kVTCompressionPropertyKey_MoreFramesAfterEnd
	@abstract
		Indicates whether and how a compression session's frames will be
		concatenated with other compressed frames to form a longer series.
	@discussion
		True if frames compressed in a separate session will be
		concatenated following the end of this one. False if this is a
		stand-alone session, or if this session will encode the last
		segment of a multi-segment compression. By default, false.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_MoreFramesAfterEnd VT_AVAILABLE_STARTING(10_8); // Read/write, CFBoolean, Optional

#pragma mark Bitstream configuration

/*!
	@constant	kVTCompressionPropertyKey_ProfileLevel
	@abstract
		Specifies the profile and level for the encoded bitstream.
	@discussion
		Available profiles and levels vary across formats and between video encoders.
		Video encoders should use standard keys where available, and follow standard patterns where not.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_ProfileLevel VT_AVAILABLE_STARTING(10_8); // Read/write, CFString (enumeration), Optional

VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_1_3 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_3_0 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_3_1 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_3_2 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_4_0 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_4_1 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_4_2 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_5_0 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_5_1 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_5_2 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Baseline_AutoLevel VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_3_0 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_3_1 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_3_2 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_4_0 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_4_1 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_4_2 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_5_0 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_5_1 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_5_2 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Main_AutoLevel VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Extended_5_0 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_Extended_AutoLevel VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_3_0 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_3_1 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_3_2 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_4_0 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_4_1 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_4_2 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_5_0 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_5_1 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_5_2 VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTProfileLevel_H264_High_AutoLevel VT_AVAILABLE_STARTING(10_9);

VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_Simple_L0 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_Simple_L1 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_Simple_L2 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_Simple_L3 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_Main_L2 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_Main_L3 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_Main_L4 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_AdvancedSimple_L0 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_AdvancedSimple_L1 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_AdvancedSimple_L2 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_AdvancedSimple_L3 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_MP4V_AdvancedSimple_L4 VT_AVAILABLE_STARTING(10_8);

VT_EXPORT const CFStringRef kVTProfileLevel_H263_Profile0_Level10 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H263_Profile0_Level45 VT_AVAILABLE_STARTING(10_8);
VT_EXPORT const CFStringRef kVTProfileLevel_H263_Profile3_Level45 VT_AVAILABLE_STARTING(10_8);


/*!
	 @constant	kVTCompressionPropertyKey_H264EntropyMode
	 @abstract
		The entropy encoding mode for H.264 compression.
	 @discussion
		If supported by an H.264 encoder, this property controls whether the encoder should use
		Context-based Adaptive Variable Length Coding (CAVLC) or Context-based Adaptive Binary Arithmetic Coding (CABAC).
		CABAC generally gives better compression at the expense of higher computational overhead.
		The default value is encoder-specific and may change depending on other encoder settings.
		Care should be taken when using this property -- changes may result in a configuration
		which is not compatible with a requested Profile and Level.  Results in this case are undefined,
		and could include encode errors or a non-compliant output stream.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_H264EntropyMode VT_AVAILABLE_STARTING(10_9);	// Read/write, CFString, optional
VT_EXPORT const CFStringRef kVTH264EntropyMode_CAVLC VT_AVAILABLE_STARTING(10_9);
VT_EXPORT const CFStringRef kVTH264EntropyMode_CABAC VT_AVAILABLE_STARTING(10_9);
	

/*!
	@constant	kVTCompressionPropertyKey_Depth
	@abstract
		The pixel depth of the encoded video.
	@discussion
		This property is only supported by video encoders for formats that are 
		tied to particular pixel formats (eg, 16-bit RGB, 24-bit RGB).
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_Depth VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber (CMPixelFormatType), Optional

#pragma mark Runtime restrictions

/*!
	@constant	kVTCompressionPropertyKey_MaxFrameDelayCount
	@abstract
		The maximum frame delay count is the maximum number of frames that
		a compressor is allowed to hold before it must output a compressed
		frame.
	@discussion
		It limits the number of frames that may be held in the
		"compression window". If the maximum frame delay count is M, then
		before the call to encode frame N returns, frame N-M must have
		been emitted. 
		The default is kVTUnlimitedFrameDelayCount, which sets no limit
		on the compression window.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_MaxFrameDelayCount VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber, Optional
enum { kVTUnlimitedFrameDelayCount = -1 };
	
/*!
	@constant	kVTCompressionPropertyKey_MaxH264SliceBytes
	@abstract
		Specifies the maximum slice size for H.264 encoding
	@discussion
		If supported by an H.264 encoder, the value limits the size in bytes of 
		slices produced by the encoder, where possible.
		By default, no limit is specified.  A value of zero implies default behavior.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_MaxH264SliceBytes VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber<SInt32>, Optional

/*!
	@constant	kVTCompressionPropertyKey_RealTime
	@abstract
		Hints the video encoder that compression is, or is not, being performed in real time.
	@discussion
		For offline compression, clients may set this property to kCFBooleanFalse, which indicates that 
		it is OK for the video encoder to work slower than real time in order to produce a better result.
		For real-time compression, clients may set this property to kCFBooleanTrue to recommend that encoding stay timely.
		By default, this property is NULL, indicating unknown.  
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_RealTime VT_AVAILABLE_STARTING(10_9); // Read/write, CFBoolean or NULL, Optional, default NULL


#pragma mark Hints

/*!
	@constant	kVTCompressionPropertyKey_SourceFrameCount
	@abstract
		Indicates the number of source frames, if known.
	@discussion
		This property allows a client to give the video encoder advance guidance as to how 
		many frames will be encoded.
		If nonzero, this should be the exact number of times that the client calls
		VTCompressionSessionEncodeFrame in each pass. 
		The default is 0, which indicates that the number of source frames
		is not known.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_SourceFrameCount VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber, Optional

/*!
	@constant	kVTCompressionPropertyKey_ExpectedFrameRate
	@abstract
		Indicates the expected frame rate, if known.
	@discussion
		The frame rate is measured in frames per second. 
		This is not used to control the frame rate; it is provided as a hint to the 
		video encoder so that it can set up internal configuration before compression begins. 
		The actual frame rate will depend on frame durations and may vary. 
		By default, this is zero, indicating "unknown".
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_ExpectedFrameRate VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber, Optional

/*!
	@constant	kVTCompressionPropertyKey_ExpectedDuration
	@abstract
		Indicates the expected total duration for the compression session, if known.
	@discussion
		By default, this is zero, indicating "unknown".
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_ExpectedDuration VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber(seconds), Optional


#pragma mark Hardware acceleration

/*!
	@constant	kVTVideoEncoderSpecification_EnableHardwareAcceleratedVideoEncoder
	@abstract
		If set to kCFBooleanTrue, use a hardware accelerated video encoder if available.  If set to
		kCFBooleanFalse, hardware encode will never be used.
	@discussion
		This key is set in the encoderSpecification passed in to VTCompressionSessionCreate.  Set it
		to kCFBooleanTrue to allow hardware accelerated encode.  To specifically prevent hardware encode,
		this property can be set to kCFBooleanFalse.
		This is useful for clients doing realtime encode operations to allow the VideoToolbox
		to choose the optimal encode path.
*/
VT_EXPORT const CFStringRef kVTVideoEncoderSpecification_EnableHardwareAcceleratedVideoEncoder VT_AVAILABLE_STARTING(10_9); // CFBoolean, Optional

/*!
	@constant	kVTVideoEncoderSpecification_RequireHardwareAcceleratedVideoEncoder
	@abstract
		If set to kCFBooleanTrue, only use hardware encode and return an error if this isn't possible.
		Setting this key automatically implies kVTVideoEncoderSpecification_EnableHardwareAcceleratedVideoEncoder -- 
		there is no need to set both and the Enable key does nothing if the Require key is set.
	@discussion
		This key is set in the encoderSpecification passed in to VTCompressionSessionCreate.  Set it
		to kCFBooleanTrue to require hardware accelerated encode.  If hardware acceleration is not
		possible, the VTCompressionSessionCreate call will fail.
		This key is useful for clients that have their own software encode implementation or
		those that may want to configure software and hardware encode sessions differently.
		Hardware acceleration may be unavailable for a number of reasons.  A few common cases are:
			- the machine does not have hardware acceleration capabilities
			- the requested encoding format or encoding configuration is not supported
			- the hardware encoding resources on the machine are busy
*/
VT_EXPORT const CFStringRef kVTVideoEncoderSpecification_RequireHardwareAcceleratedVideoEncoder VT_AVAILABLE_STARTING(10_9); // CFBoolean, Optional

/*!
	@constant	kVTCompressionPropertyKey_UsingHardwareAcceleratedVideoEncoder
	@abstract
		If set to kCFBooleanTrue, a hardware accelerated video encoder is being used.
	@discussion
		You can query this property using VTSessionCopyProperty after you have enabled hardware
		accelerated encode using kVTVideoEncoderSpecification_EnableHardwareAcceleratedVideoEncoder
		to see if a hardware accelerated encoder was selected.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_UsingHardwareAcceleratedVideoEncoder VT_AVAILABLE_STARTING(10_9); // CFBoolean, Read; assumed false by default

#pragma mark Per-frame configuration
	
/*!
	@constant	kVTEncodeFrameOptionKey_ForceKeyFrame
	@abstract
		CFBoolean forcing the current frame to be a key frame
	@discussion
		This value is set in the frameProperties CFDictionary passed to 
		VTCompressionSessionEncodeFrame to force the current frame to be a 
		keyframe or not.  
		Note that it may not be possible for the encoder to accomodate all
		requests.
*/
VT_EXPORT const CFStringRef kVTEncodeFrameOptionKey_ForceKeyFrame VT_AVAILABLE_STARTING(10_8); //  CFBoolean


#pragma mark Clean aperture and pixel aspect ratio

/*!
	@constant	kVTCompressionPropertyKey_CleanAperture
	@abstract
		Describes the clean aperture for encoded frames.
	@discussion
		Some video encoders may enforce specific clean apertures; 
		in those cases this property will be read-only (SetProperty will return kVTPropertyReadOnlyErr).
		The clean aperture will be set on the format description for output samples,
		and may affect source frame scaling.
		NULL is a valid value for this property, meaning that the clean aperture is the full width and height.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_CleanAperture VT_AVAILABLE_STARTING(10_8); // Read/write, CFDictionary (see CMFormatDescription.h), Optional

/*!
	@constant	kVTCompressionPropertyKey_PixelAspectRatio
	@abstract
		Describes the pixel aspect ratio for encoded frames.
	@discussion
		Some video encoders may enforce specific pixel aspect ratios; 
		in those cases this property will be read-only (SetProperty will return kVTPropertyReadOnlyErr).
		The pixel aspect ratio will be set on the format description for output samples,
		and may affect source frame scaling.
		NULL is a valid value for this property, meaning square pixels (1:1).
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_PixelAspectRatio VT_AVAILABLE_STARTING(10_8); // Read/write, CFDictionary (see CMFormatDescription.h), Optional

/*!
	@constant	kVTCompressionPropertyKey_FieldCount
	@abstract
		Indicates whether the frames should be encoded progressive (1) or interlaced (2).
	@discussion
		The field count will be set on the format description for output samples,
		and may affect source frame scaling.
		NULL is a valid value for this property.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_FieldCount VT_AVAILABLE_STARTING(10_8); // Read/write, CFNumber (see kCMFormatDescriptionExtension_FieldCount), Optional

/*!
	@constant	kVTCompressionPropertyKey_FieldDetail
	@abstract
		Indicates field ordering for encoded interlaced frames.
	@discussion
		Some video encoders may enforce specific field ordering; 
		in those cases this property will be read-only (SetProperty will return kVTPropertyReadOnlyErr).
		The field detail will be set on the format description for output samples,
		and may affect source frame scaling.
		NULL is a valid value for this property.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_FieldDetail VT_AVAILABLE_STARTING(10_8); // Read/write, CFString (see kCMFormatDescriptionExtension_FieldDetail), Optional

/*!
	@constant	kVTCompressionPropertyKey_AspectRatio16x9
	@abstract
		Indicates that the DV video stream should have the 16x9 flag set.
	@discussion
		This property is supported by the DV25/50 family of encoders.
		When false, the picture aspect ratio is 4:3.  
		When true, the picture aspect ratio is 16:9.
		Either way, a fixed PixelAspectRatio is used (the specific value depends on whether the format is NTSC or PAL).
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_AspectRatio16x9 VT_AVAILABLE_STARTING(10_8); // Read/write, CFBoolean, Optional

/*!
	@constant	kVTCompressionPropertyKey_ProgressiveScan
	@abstract
		Indicates that the DV video stream should have the progressive flag set.
	@discussion
		This property is supported by the DV25/50 family of encoders.
		If false, content is encoded as interlaced.
		If true, content is encoded as progressive.
		The value of this property fixes the FieldCount and FieldDetail properties.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_ProgressiveScan VT_AVAILABLE_STARTING(10_8); // Read/write, CFBoolean, Optional

#pragma mark Color

/*!
	@constant	kVTCompressionPropertyKey_ColorPrimaries
	@abstract
		Indicates color primaries for compressed content.
	@discussion
		Some video encoders may enforce specific colorimetry; 
		in those cases this property will be read-only (SetProperty will return kVTPropertyReadOnlyErr).
		The value will be set on the format description for output sample buffers.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_ColorPrimaries VT_AVAILABLE_STARTING(10_8); // Read/write, CFString (see kCMFormatDescriptionExtension_ColorPrimaries), Optional

/*!
	@constant	kVTCompressionPropertyKey_TransferFunction
	@abstract
		Indicates transfer function for compressed content.
	@discussion
		Some video encoders may enforce specific colorimetry; 
		in those cases this property will be read-only (SetProperty will return kVTPropertyReadOnlyErr).
		The value will be set on the format description for output sample buffers.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_TransferFunction VT_AVAILABLE_STARTING(10_8); // Read/write, CFString (see kCMFormatDescriptionExtension_TransferFunction), Optional

/*!
	@constant	kVTCompressionPropertyKey_YCbCrMatrix
	@abstract
		Indicates YCbCr matrix for compressed content.
	@discussion
		Some video encoders may enforce specific colorimetry; 
		in those cases this property will be read-only (SetProperty will return kVTPropertyReadOnlyErr).
		The value will be set on the format description for output sample buffers.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_YCbCrMatrix VT_AVAILABLE_STARTING(10_8); // Read/write, CFString (see kCMFormatDescriptionExtension_YCbCrMatrix), Optional

/*!
	@constant	kVTCompressionPropertyKey_ICCProfile
	@abstract
		Indicates ICC profile for compressed content.
	@discussion
		Some video encoders may enforce specific colorimetry; 
		in those cases this property will be read-only (SetProperty will return kVTPropertyReadOnlyErr).
		If this property and any of the previous three are all set, they should be set to consistent values, 
		or undefined behavior may occur.
		The value will be set on the format description for output sample buffers.
		NULL can be a valid value for this property.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_ICCProfile VT_AVAILABLE_STARTING(10_8); // Read/write, CFData (see kCMFormatDescriptionExtension_ICCProfile), Optional

#pragma mark Pre-compression processing

// Standard properties about processing to be performed before compression.
// These are implemented by the video toolbox.

/*!
	@constant	kVTCompressionPropertyKey_PixelTransferProperties
	@abstract
		Specifies properties to configure a VTPixelTransferSession used to transfer source frames
		from the client's image buffers to the video encoder's image buffers, if necessary.
	@discussion
		Setting this property alone does not necessarily guarantee that a VTPixelTransferSession will be created.
		See VTPixelTransferProperties.h.
*/
VT_EXPORT const CFStringRef kVTCompressionPropertyKey_PixelTransferProperties VT_AVAILABLE_STARTING(10_8); // Read/Write, CFDictionary containing properties from VTPixelTransferProperties.h.


#pragma pack(pop)
    
#if defined(__cplusplus)
}
#endif

#endif // VTCOMPRESSIONPROPERTIES_H
