/*
    File:  CMFormatDescription.h

	Framework:  CoreMedia
 
    Copyright 2005-2013 Apple Inc. All rights reserved.

*/

#ifndef CMFORMATDESCRIPTION_H
#define CMFORMATDESCRIPTION_H

/*!
	@header
	@abstract	API for creating and manipulating CMFormatDescriptions.
	@discussion	CMFormatDescriptions are immutable CF objects that are used to describe media data of various types, including
				audio, video, and muxed media data. There are two types of APIs in this header, media-type-agnostic APIs
				(supported by all CMFormatDescriptions) and media-type-specific APIs.  The media-type-agnostic APIs are
				prefixed with CMFormatDescription, and the media-type-specific APIs are prefixed with CMAudioFormatDescription,
				CMVideoFormatDescription, etc.
*/

#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMTime.h>
#include <CoreFoundation/CoreFoundation.h>
#include <CoreAudio/CoreAudioTypes.h>
#include <AudioToolbox/AudioFormat.h>

#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_OS_WIN32)
	#include <CoreGraphics/CGBase.h>
	#include <CoreGraphics/CGGeometry.h>
#elif TARGET_OS_MAC
	#include <ApplicationServices/../Frameworks/CoreGraphics.framework/Headers/CGBase.h>
	#include <ApplicationServices/../Frameworks/CoreGraphics.framework/Headers/CGGeometry.h>
#endif

#include <CoreVideo/CoreVideo.h>

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma pack(push, 4)

#pragma mark CMFormatDescription

/*!
	@enum CMFormatDescription Errors
	@discussion OSStatus errors returned by CMFormatDescription APIs.
	@constant	kCMFormatDescriptionError_InvalidParameter Invalid parameter.
	@constant	kCMFormatDescriptionError_AllocationFailed Returned when an allocation fails.
	@constant	kCMFormatDescriptionError_ValueNotAvailable Returned when the CMFormatDescription does not carry such a value.
*/
enum {
	kCMFormatDescriptionError_InvalidParameter		= -12710,
	kCMFormatDescriptionError_AllocationFailed		= -12711,
	kCMFormatDescriptionError_ValueNotAvailable		= -12718,
};

/*!
	@typedef	CMFormatDescriptionRef
	@abstract	A reference to a CMFormatDescription, a CF object describing media of a particular type (audio, video, muxed, etc).
*/
typedef const struct opaqueCMFormatDescription *CMFormatDescriptionRef;

/*!
	@enum CMMediaType
	@abstract The type of media described by a CMFormatDescription.
	@constant kCMMediaType_Video Video media
	@constant kCMMediaType_Audio Audio media
	@constant kCMMediaType_Muxed Muxed media
	@constant kCMMediaType_Text Text media
	@constant kCMMediaType_ClosedCaption Closed-caption media
	@constant kCMMediaType_Subtitle Subtitle media
	@constant kCMMediaType_TimeCode TimeCode media
	@constant kCMMediaType_Metadata Metadata media
*/
enum {
	kCMMediaType_Video				= 'vide',
	kCMMediaType_Audio				= 'soun',
	kCMMediaType_Muxed				= 'muxx',
	kCMMediaType_Text				= 'text',
	kCMMediaType_ClosedCaption		= 'clcp',
	kCMMediaType_Subtitle			= 'sbtl',
	kCMMediaType_TimeCode			= 'tmcd',
	kCMMediaType_Metadata			= 'meta'
};
typedef FourCharCode CMMediaType;

/*! 
	@functiongroup	Media-type-agnostic functions
*/

/*!
	@function	CMFormatDescriptionCreate
    @abstract   Creates a generic CMFormatDescription object.
    @discussion Use this call to create any CMFormatDescription that is composed solely of extensions, and for which 
    			CFEqual() of a the extensions dictionaries is a valid test for Format Description equality.
    @result     A new CMFormatDescription object.
*/
CM_EXPORT OSStatus 
CMFormatDescriptionCreate(
	CFAllocatorRef allocator,			/*! @param allocator
										Allocator to use when creating the CMFormatDescription. If NULL, the default
										allocator will be used. */
	CMMediaType mediaType,				/*! @param mediaType
										Four character code identifying the type of media associated with the CMFormatDescription. */
	FourCharCode mediaSubtype,			/*! @param mediaSubtype
										Four character code identifying the sub-type of media. */
	CFDictionaryRef extensions,			/*! @param extensions
										Dictionary of extensions to be attached to the CMFormatDescription. May be NULL. */
	CMFormatDescriptionRef *descOut)	/*! @param descOut
										Receives the newly-created CMFormatDescription. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMFormatDescriptionGetTypeID
	@abstract	Returns the CFTypeID of CMFormatDescription objects.
	@discussion	You can check if a CFTypeRef object is actually a CMFormatDescription
				by comparing CFGetTypeID(object) with CMFormatDescriptionGetTypeID().
*/
CM_EXPORT
CFTypeID CMFormatDescriptionGetTypeID(void)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMFormatDescriptionEqual
	@abstract	Compares two CMFormatDescription objects for equality.
	@discussion	This calls CFEqual on the provided CMFormatDescription objects.
                In contrast to the CF call it is NULL safe.
*/
CM_EXPORT
Boolean CMFormatDescriptionEqual(
	CMFormatDescriptionRef desc1,	/*! @param desc1
									The first formatDescription. */
	CMFormatDescriptionRef desc2)	/*! @param desc2
									The second formatDescription. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMFormatDescriptionEqualIgnoringExtensionKeys
	@abstract	Compares two CMFormatDescription objects for equality, ignoring differences in specified lists of format description extension keys and sample description extension keys.
	@discussion
		This function is NULL safe.
		If any keys are passed, kCMFormatDescriptionExtension_VerbatimSampleDescription
		and kCMFormatDescriptionExtension_VerbatimISOSampleEntry will also be automatically
		ignored for the purpose of comparison.
	@param formatDescriptionExtensionKeysToIgnore
		Either a single format description extension key (CFString) 
		or a CFArray of such keys.  
	@param sampleDescriptionExtensionAtomKeysToIgnore
		Either a single sample description extension atom key (four-character CFString) 
		or a CFArray of such keys.  
		See kCMFormatDescriptionExtension_SampleDescriptionExtensionAtoms.
*/
CM_EXPORT
Boolean CMFormatDescriptionEqualIgnoringExtensionKeys(
	CMFormatDescriptionRef desc1,
	CMFormatDescriptionRef desc2,
	CFTypeRef formatDescriptionExtensionKeysToIgnore,
	CFTypeRef sampleDescriptionExtensionAtomKeysToIgnore )
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_3);

/*!
	@function	CMFormatDescriptionGetMediaType
	@abstract	Returns the media type of a CMFormatDescription.
	@discussion	For example, returns kCMMediaType_Audio for a description of an audio stream.
	@result		The media type of the CMFormatDescription.
*/
CM_EXPORT
CMMediaType CMFormatDescriptionGetMediaType(
	CMFormatDescriptionRef desc)	/*! @param desc CMFormatDescription being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMFormatDescriptionGetMediaSubType
	@abstract	Returns the media subtype of a CMFormatDescription.
	@discussion	The media subtype is defined in a media-specific way.
				For audio streams, the media subtype is the asbd.mFormatID.
				For video streams, the media subtype is the video codec type. 
				For muxed streams, it is the format of the muxed stream.
				For example, 'aac ' is returned for a description of an AAC audio
				stream, 'avc1' is returned for a description of an H.264 video
				stream, and 'mp2t' is returned for a description of an MPEG-2
				transport (muxed) stream.  If a particular type of media stream
				does not have subtypes, this API may return 0.
	@result		The media subtype of the CMFormatDescription.
*/
CM_EXPORT
FourCharCode CMFormatDescriptionGetMediaSubType(
	CMFormatDescriptionRef desc)	/*! @param desc CMFormatDescription being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMFormatDescriptionGetExtensions
	@abstract	Returns an immutable dictionary containing all the extensions of a CMFormatDescription.
	@discussion If there are no extensions, NULL is returned. Extensions dictionaries are valid property list
				objects.  This means that dictionary keys are all CFStrings, and the values are all either
				CFNumber, CFString, CFBoolean, CFArray, CFDictionary, CFDate, or CFData. The returned
				dictionary is not retained by this call, so clients are required to retain it if they
				need to keep it longer.
	@result		An immutable dictionary containing all the extensions of the CMFormatDescription.  May be NULL.
*/
CM_EXPORT
CFDictionaryRef CMFormatDescriptionGetExtensions(
	CMFormatDescriptionRef desc)	/*! @param desc CMFormatDescription being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@define 	kCMFormatDescriptionExtension_OriginalCompressionSettings
	@abstract	This extension contains a media-type-specific dictionary of settings used to produce a compressed media buffer.
	@discussion This extension is valid for format descriptions of all media types, but the contents of the dictionary are defined
				in a media-specific way.  The dictionary and its contents are valid property list objects. This means that
				dictionary keys are all CFStrings, and the values are all either CFNumber, CFString, CFBoolean, CFArray,
				CFDictionary, CFDate, or CFData.
*/
CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_OriginalCompressionSettings	// CFDictionary
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@define 	kCMFormatDescriptionExtension_SampleDescriptionExtensionAtoms
	@abstract	Sample description extension atoms that were not translated into other entries in the extensions dictionary.
	@discussion	This key is used by sample description bridges to hold sample description
				extension atoms that they do not recognize.
				The extension is a CFDictionary mapping CFStrings of the four-char-code atom types
				to either CFDatas containing the atom payload or (to represent multiple atoms of a
				specific type) to CFArrays of CFData containing those payloads.
*/
CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_SampleDescriptionExtensionAtoms	// CFDictionary of CFString (four-char-code, atom type) -> ( CFData (atom payload) or CFArray of CFData (atom payload) )
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@define 	kCMFormatDescriptionExtension_VerbatimSampleDescription
	@abstract	Preserves the original SampleDescription data.
	@discussion This extension is used to ensure that roundtrips from sample descriptions
				to CMFormatDescriptions back to sample descriptions preserve the exact original
				sample descriptions.
				IMPORTANT: If you make a modified clone of a CMFormatDescription, you must 
				delete this extension from the clone, or your modifications could be lost.
*/
CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_VerbatimSampleDescription		// CFData
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@define 	kCMFormatDescriptionExtension_VerbatimISOSampleEntry
	@abstract	Preserves the original ISOSampleEntry data.
	@discussion This extension is used to ensure that roundtrips from ISO Sample Entry (ie. AudioSampleEntry or VisualSampleEntry)
				to CMFormatDescriptions back to ISO Sample Entry preserve the exact original
				sample descriptions.
				IMPORTANT: If you make a modified clone of a CMFormatDescription, you must 
				delete this extension from the clone, or your modifications could be lost.
*/
CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_VerbatimISOSampleEntry		// CFData
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMFormatDescriptionGetExtension
	@abstract	Returns the specified extension of a CMFormatDescription.
	@discussion If the named extension does not exist, NULL is returned. The extension is always a valid
				property list object. This means that it will be either a CFNumber, CFString, CFBoolean,
				CFArray, CFDictionary, CFDate, or CFData. If it is a CFDictionary, the keys will all be
				CFStrings. The returned extension is not retained by this call, so it is only valid as
				long as the CMFormatDescription is valid. Clients are required to retain it if they
				need to keep it longer.
	@result		The specified extension of the CMFormatDescription.  May be NULL.
*/
CM_EXPORT
CFPropertyListRef CMFormatDescriptionGetExtension(
	CMFormatDescriptionRef desc,	/*! @param desc				CMFormatDescription being interrogated */
	CFStringRef extensionKey)		/*! @param extensionID		Key of extension to be returned. Cannot be NULL. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

				
#pragma mark CMAudioFormatDescription

/*! 
	@functiongroup	Audio-specific functions
*/

/*!
	@enum CMAudioCodecType
	@discussion Four-character codes identifying the code type. Certain codec types are also audio formats.
	@constant	kCMAudioCodecType_AAC_LCProtected iTMS protected low-complexity AAC.
	@constant	kCMAudioCodecType_AAC_AudibleProtected Audible's protected AAC.
*/
enum {
    kCMAudioCodecType_AAC_LCProtected      = 'paac',
	kCMAudioCodecType_AAC_AudibleProtected = 'aaac'
};
typedef FourCharCode CMAudioCodecType;

/*!
	@typedef CMAudioFormatDescriptionRef
	SYnonym type used for manipulating audio CMFormatDescriptions
*/
typedef CMFormatDescriptionRef CMAudioFormatDescriptionRef;

/*!
	@function	CMAudioFormatDescriptionCreate
	@abstract	Creates a format description for an audio media stream.
	@discussion	The ASBD is required, the channel layout is optional, and the magic cookie is required
				for some compression formats (and must be NULL for all others). The caller owns the
				returned CMFormatDescription, and must release it when done with it.  The ASBD,
				magic cookie, channel layout, and extensions are all copied (the extensions are
				deep-copied).  The caller can deallocate them or re-use them after making this call.
*/
CM_EXPORT
OSStatus CMAudioFormatDescriptionCreate(
	CFAllocatorRef allocator,					/*! @param allocator		CFAllocator to be used. Pass kCFAllocatorDefault or NULL to use the default allocator. */
	const AudioStreamBasicDescription *asbd,	/*! @param asbd				Audio format description (see CoreAudioTypes.h). This information is required. */
	size_t layoutSize,							/*! @param layoutSize		Size, in bytes, of audio channel layout. 0 if layout is NULL. */
	const AudioChannelLayout *layout,			/*! @param layout			Audio channel layout (see CoreAudioTypes.h). Can be NULL. */	
	size_t magicCookieSize,						/*! @param magicCookieSize	Size, in bytes, of magic cookie. 0 if magicCookie is NULL. */
	const void *magicCookie,					/*! @param magicCookie		Magic cookie. This information is required for some formats, and must be NULL for all others. */
	CFDictionaryRef extensions,					/*! @param extensions		Dictionary of extension key/value pairs.  Keys are always CFStrings.
																			Values are always property list objects (ie. CFData, CFString, CFArray, CFDictionary,
																			CFDate, CFBoolean, or CFNumber). Can be NULL. */
	CMAudioFormatDescriptionRef *outDesc)		/*! @param outDesc			Returned newly created audio CMFormatDescription */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMAudioFormatDescriptionGetStreamBasicDescription
	@abstract	Returns a read-only pointer to the AudioStreamBasicDescription inside an audio CMFormatDescription.
	@discussion	See CoreAudioTypes.h for the definition of AudioStreamBasicDescription.
				This API is specific to audio format descriptions, and will return NULL if
				used with a non-audio format descriptions.
*/
CM_EXPORT
const AudioStreamBasicDescription * CMAudioFormatDescriptionGetStreamBasicDescription(
	CMAudioFormatDescriptionRef desc)		/*! @param desc		CMFormatDescription being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMAudioFormatDescriptionGetMagicCookie
	@abstract	Returns a read-only pointer to (and size of) the magic cookie inside an audio CMFormatDescription.
	@discussion	The magic cookie is a completely opaque piece of data, written and read only by
				the codec itself. A magic cookie is only present for codecs that require it;
				this API will return NULL if one does not exist. This API is specific to audio
				format descriptions, and will return NULL if called with a non-audio format
				description.
	@result		A read-only pointer to the magic cookie inside the audio format description.
*/
CM_EXPORT
const void * CMAudioFormatDescriptionGetMagicCookie(
	CMAudioFormatDescriptionRef desc,		/*! @param desc				CMFormatDescription being interrogated. */
	size_t *cookieSizeOut)					/*! @param cookieSizeOut	Pointer to variable that will be written with the size of the cookie. Can be NULL. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMAudioFormatDescriptionGetChannelLayout
	@abstract	Returns a read-only pointer to (and size of) the AudioChannelLayout inside an audio CMFormatDescription.
	@discussion	See CoreAudioTypes.h for the definition of AudioChannelLayout.
				AudioChannelLayouts are optional; this API will return NULL if
				one does not exist. This API is specific to audio format
				descriptions, and will return NULL if called with a non-audio
				format description.
	@result		A read-only pointer to the AudioChannelLayout inside the audio format description.
*/
CM_EXPORT
const AudioChannelLayout * CMAudioFormatDescriptionGetChannelLayout(
	CMAudioFormatDescriptionRef desc,		/*! @param desc			CMFormatDescription being interrogated. */
	size_t *layoutSize)						/*! @param layoutSize	Pointer to variable that will be written with the size of the layout.
																	Can be NULL. */    
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMAudioFormatDescriptionGetFormatList
	@abstract	Returns a read-only pointer to (and size of) the array of AudioFormatListItem structs inside an audio CMFormatDescription.
	@discussion	This property is analogous to kAudioFormatProperty_FormatList (See AudioFormat.h) and follows
                its conventions.  Namely, formats are returned in order from the most to least 'rich', with 
                channel count taking the highest precedence followed by sample rate.
				This API is specific to audio format descriptions, and will return NULL if called with a non-audio
				format description.
	@result		A read-only pointer to the array of AudioFormatListItem structs inside the audio format description.
*/
CM_EXPORT
const AudioFormatListItem * CMAudioFormatDescriptionGetFormatList(
	CMAudioFormatDescriptionRef desc,		/*! @param desc             CMFormatDescription being interrogated. */
	size_t *formatListSize)	                /*! @param formatListSize	Pointer to variable that will be written with the size of the formatList.
                                                                        Can be NULL. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMAudioFormatDescriptionGetRichestDecodableFormat
	@abstract	Returns a read-only pointer to the appropriate AudioFormatListItem inside an audio CMFormatDescription.
	@discussion	This property performs validation on the formats represented by the audio in the description.  It
                finds the first AudioFormatListItem for which the current system has a valid decoder.
				This API is specific to audio format descriptions, and will return NULL if called with a non-audio
				format description.  It may also return NULL if there is no suitable decoder available on the
                current system for this audio format.
	@result		A read-only pointer to the appropriate AudioFormatListItem inside the audio format description.
*/
CM_EXPORT
const AudioFormatListItem * CMAudioFormatDescriptionGetRichestDecodableFormat(
	CMAudioFormatDescriptionRef desc)	     /*! @param desc             CMFormatDescription being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMAudioFormatDescriptionGetMostCompatibleFormat
	@abstract	Returns a read-only pointer to the appropriate AudioFormatListItem inside an audio CMFormatDescription.
	@discussion	This property returns a pointer to the last AudioFormatListItem in the kAudioFormatProperty_FormatList
                (see AudioFormat.h).  This API is specific to audio format descriptions, and will return NULL if called 
                with a non-audio format description.
	@result		A read-only pointer to the appropriate AudioFormatListItem inside the audio format description.
*/
CM_EXPORT
const AudioFormatListItem * CMAudioFormatDescriptionGetMostCompatibleFormat(
	CMAudioFormatDescriptionRef desc)	     /*! @param desc             CMFormatDescription being interrogated. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMAudioFormatDescriptionCreateSummary
	@abstract	Creates a summary audio format description from an array of audio format descriptions.
	@discussion
		The summary format description will be canonical LPCM and deep enough in 
		sample rate, channel layout and channel count to sensibly contain the result of decoding 
		and mixing the constituent format descriptions.
*/
CM_EXPORT OSStatus CMAudioFormatDescriptionCreateSummary(
		CFAllocatorRef allocator,
		CFArrayRef formatDescriptionArray, // CFArray[CMAudioFormatDescription]
		uint32_t flags, // pass 0
		CMAudioFormatDescriptionRef *summaryFormatDescriptionOut )
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@enum CMAudioFormatDescriptionMask
	@discussion Mask bits passed to (and returned from) CMAudioFormatDescriptionEqual,
				representing various parts of an audio format description.
	@constant	CMAudioFormatDescriptionMask_StreamBasicDescription	Represents the AudioStreamBasicDescription.
	@constant	CMAudioFormatDescriptionMask_MagicCookie				Represents the magic cookie.
	@constant	CMAudioFormatDescriptionMask_ChannelLayout				Represents the AudioChannelLayout.
	@constant	CMAudioFormatDescriptionMask_Extensions					Represents the format description extensions.
	@constant	CMAudioFormatDescriptionMask_All						Represents all the parts of an audio format description.
*/
enum
{
	kCMAudioFormatDescriptionMask_StreamBasicDescription	= (1<<0),
	kCMAudioFormatDescriptionMask_MagicCookie				= (1<<1),
	kCMAudioFormatDescriptionMask_ChannelLayout				= (1<<2),
	kCMAudioFormatDescriptionMask_Extensions				= (1<<3),
	kCMAudioFormatDescriptionMask_All						= kCMAudioFormatDescriptionMask_StreamBasicDescription
															| kCMAudioFormatDescriptionMask_MagicCookie
															| kCMAudioFormatDescriptionMask_ChannelLayout
															| kCMAudioFormatDescriptionMask_Extensions
};
typedef uint32_t CMAudioFormatDescriptionMask;

/*!
	@function	CMAudioFormatDescriptionEqual
	@abstract	Evaluates equality for the specified parts of two audio format descriptions.
	@discussion	Bits in equalityMask specify the caller's interest in the equality of various parts of the descriptions.
				Bits set and returned in equalityMaskOut represent the subset of those parts that are equal.
				If there is any sort of error that prevents the comparison from occurring, false will be returned, and
				all bits in equalityMaskOut will be cleared. If you pass kCMAudioFormatDescriptionMask_All in equalityMask,
				and NULL for equalityMaskOut, this API is equivalent to CFEqual(desc1, desc2).
	@result		The result of the comparison.  True if all parts in which the caller is interested are equal.
				False if any of the parts in which the caller is interested are not equal.
*/
CM_EXPORT
Boolean CMAudioFormatDescriptionEqual(
	CMAudioFormatDescriptionRef desc1,				/*! @param desc1			The CMAudioFormatDescription being compared. */
	CMAudioFormatDescriptionRef desc2,				/*! @param desc2			The CMAudioFormatDescription to which it is being compared. */
	CMAudioFormatDescriptionMask equalityMask,		/*! @param equalityMask		Mask specifying which parts of the descriptions to compare. */
	CMAudioFormatDescriptionMask *equalityMaskOut)	/*! @param equalityMaskOut  Pointer to variable that will be written with the results by part.
																				Bits not set in equalityMask will not be set in equalityMaskOut.
																				Can be NULL. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#pragma mark CMVideoFormatDescription

/*! 
	@functiongroup	Video-specific functions
*/

/*!
	@typedef CMVideoFormatDescriptionRef
	Synonym type used for manipulating audio CMFormatDescriptions
*/
typedef CMFormatDescriptionRef CMVideoFormatDescriptionRef;

/*!
	@enum CMPixelFormatType
	@discussion Four-character codes identifying the pixel format. Only some codec types are pixel formats.
		In general, CoreVideo CVPixelFormatType constants may be used too.
	@constant	kCMPixelFormat_32ARGB 32-bit ARGB
	@constant	kCMPixelFormat_32BGRA 32-bit BGRA
	@constant	kCMPixelFormat_24RGB 24-bit RGB
	@constant	kCMPixelFormat_16BE555 16-bit big-endian 5-5-5
	@constant	kCMPixelFormat_16BE565 16-bit big-endian 5-6-5
	@constant	kCMPixelFormat_16LE555 16-bit little-endian 5-5-5
	@constant	kCMPixelFormat_16LE565 16-bit little-endian 5-6-5
	@constant	kCMPixelFormat_16LE5551 16-bit little-endian 5-5-5-1
	@constant	kCMPixelFormat_422YpCbCr8 Component Y'CbCr 8-bit 4:2:2 ordered Cb Y'0 Cr Y'1
	@constant	kCMPixelFormat_422YpCbCr8_yuvs Component Y'CbCr 8-bit 4:2:2 ordered Y'0 Cb Y'1 Cr
	@constant	kCMPixelFormat_444YpCbCr8 Component Y'CbCr 8-bit 4:4:4
	@constant	kCMPixelFormat_4444YpCbCrA8 Component Y'CbCrA 8-bit 4:4:4:4
	@constant	kCMPixelFormat_422YpCbCr16 Component Y'CbCr 10,12,14,16-bit 4:2:2
	@constant	kCMPixelFormat_422YpCbCr10 Component Y'CbCr 10-bit 4:2:2
	@constant	kCMPixelFormat_444YpCbCr10 Component Y'CbCr 10-bit 4:4:4
	@constant	kCMPixelFormat_8IndexedGray_WhiteIsZero 8 bit indexed gray, white is zero
*/
enum {
	kCMPixelFormat_32ARGB                   = 32,
	kCMPixelFormat_32BGRA                   = 'BGRA',
	kCMPixelFormat_24RGB                    = 24,
	kCMPixelFormat_16BE555                  = 16,
	kCMPixelFormat_16BE565                  = 'B565',
	kCMPixelFormat_16LE555                  = 'L555',
	kCMPixelFormat_16LE565                  = 'L565',
	kCMPixelFormat_16LE5551                 = '5551',
	kCMPixelFormat_422YpCbCr8               = '2vuy',
	kCMPixelFormat_422YpCbCr8_yuvs          = 'yuvs',
	kCMPixelFormat_444YpCbCr8               = 'v308',
	kCMPixelFormat_4444YpCbCrA8             = 'v408',
	kCMPixelFormat_422YpCbCr16              = 'v216',
	kCMPixelFormat_422YpCbCr10              = 'v210',
	kCMPixelFormat_444YpCbCr10              = 'v410',
	kCMPixelFormat_8IndexedGray_WhiteIsZero = 0x00000028,
};
typedef FourCharCode CMPixelFormatType; 

/*!
	@enum CMVideoCodecType
	@discussion Four-character codes identifying the video codec. Certain codec types are also pixel formats.
				  Note: There is no kCMVideoCodecType_Raw -- use the appropriate pixel format type as the codec type.
	@constant	kCMVideoCodecType_422YpCbCr8	Component Y'CbCr 8-bit 4:2:2 ordered Cb Y'0 Cr Y'1
	@constant	kCMVideoCodecType_Animation		Apple Animation format
	@constant	kCMVideoCodecType_Cinepak	Cinepak format
	@constant	kCMVideoCodecType_JPEG	Joint Photographic Experts Group (JPEG) format
	@constant	kCMVideoCodecType_JPEG_OpenDML	JPEG format with Open-DML extensions
	@constant	kCMVideoCodecType_SorensonVideo		Sorenson video format
	@constant	kCMVideoCodecType_SorensonVideo3	Sorenson 3 video format
	@constant	kCMVideoCodecType_H263	ITU-T H.263 format
	@constant	kCMVideoCodecType_H264	ITU-T H.264 format (AKA ISO/IEC 14496-10 - MPEG-4 Part 10, Advanced Video Coding format)
	@constant	kCMVideoCodecType_MPEG4Video	ISO/IEC Moving Picture Experts Group (MPEG) MPEG-4 Part 2 video format
	@constant	kCMVideoCodecType_MPEG2Video	MPEG-2 video format
	@constant	kCMVideoCodecType_MPEG1Video	MPEG-1 video format
	@constant	kCMVideoCodecType_DVCNTSC	DV NTSC format
	@constant	kCMVideoCodecType_DVCPAL	DV PAL format
	@constant	kCMVideoCodecType_DVCProPAL		Panasonic DVCPro PAL format
	@constant	kCMVideoCodecType_DVCPro50NTSC	Panasonic DVCPro-50 NTSC format
	@constant	kCMVideoCodecType_DVCPro50PAL	Panasonic DVCPro-50 PAL format
	@constant	kCMVideoCodecType_DVCPROHD720p60	Panasonic DVCPro-HD 720p60 format
	@constant	kCMVideoCodecType_DVCPROHD720p50	Panasonic DVCPro-HD 720p50 format
	@constant	kCMVideoCodecType_DVCPROHD1080i60	Panasonic DVCPro-HD 1080i60 format
	@constant	kCMVideoCodecType_DVCPROHD1080i50	Panasonic DVCPro-HD 1080i50 format
	@constant	kCMVideoCodecType_DVCPROHD1080p30	Panasonic DVCPro-HD 1080p30 format
	@constant	kCMVideoCodecType_DVCPROHD1080p25	Panasonic DVCPro-HD 1080p25 format
	@constant	kCMVideoCodecType_AppleProRes4444	Apple ProRes 4444 format
	@constant	kCMVideoCodecType_AppleProRes422HQ	Apple ProRes 422 HQ format
	@constant	kCMVideoCodecType_AppleProRes422	Apple ProRes 422 format
	@constant	kCMVideoCodecType_AppleProRes422LT	Apple ProRes 422 LT format
	@constant	kCMVideoCodecType_AppleProRes422Proxy	Apple ProRes 422 Proxy format
*/
enum {
	kCMVideoCodecType_422YpCbCr8       = kCMPixelFormat_422YpCbCr8,
	kCMVideoCodecType_Animation        = 'rle ',
	kCMVideoCodecType_Cinepak          = 'cvid',
	kCMVideoCodecType_JPEG             = 'jpeg',
	kCMVideoCodecType_JPEG_OpenDML     = 'dmb1',
	kCMVideoCodecType_SorensonVideo    = 'SVQ1',
	kCMVideoCodecType_SorensonVideo3   = 'SVQ3',
	kCMVideoCodecType_H263             = 'h263',
	kCMVideoCodecType_H264             = 'avc1',
	kCMVideoCodecType_MPEG4Video       = 'mp4v',
	kCMVideoCodecType_MPEG2Video       = 'mp2v',
	kCMVideoCodecType_MPEG1Video       = 'mp1v',

	kCMVideoCodecType_DVCNTSC          = 'dvc ',
	kCMVideoCodecType_DVCPAL           = 'dvcp',
	kCMVideoCodecType_DVCProPAL        = 'dvpp',
	kCMVideoCodecType_DVCPro50NTSC     = 'dv5n',
	kCMVideoCodecType_DVCPro50PAL      = 'dv5p',
	kCMVideoCodecType_DVCPROHD720p60   = 'dvhp',
	kCMVideoCodecType_DVCPROHD720p50   = 'dvhq',
	kCMVideoCodecType_DVCPROHD1080i60  = 'dvh6',
	kCMVideoCodecType_DVCPROHD1080i50  = 'dvh5',
	kCMVideoCodecType_DVCPROHD1080p30  = 'dvh3',
	kCMVideoCodecType_DVCPROHD1080p25  = 'dvh2',
	
	kCMVideoCodecType_AppleProRes4444  = 'ap4h',
	kCMVideoCodecType_AppleProRes422HQ = 'apch',
	kCMVideoCodecType_AppleProRes422   = 'apcn',
	kCMVideoCodecType_AppleProRes422LT = 'apcs',
	kCMVideoCodecType_AppleProRes422Proxy = 'apco',
};
typedef FourCharCode CMVideoCodecType;

/*!
	@typedef CMVideoDimensions
	Type used for video dimensions, units are pixels
*/
typedef struct {
	int32_t width;
	int32_t height;
} CMVideoDimensions;

CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_FormatName	// CFString
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_Depth			// CFNumber with depth value as directed by http://developer.apple.com/qa/qa2001/qa1183.html
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

// Many of the following extension keys and values are the same as the corresponding CVImageBuffer attachment keys and values
#define kCMFormatDescriptionExtension_CleanAperture				kCVImageBufferCleanApertureKey					// CFDictionary containing the following four keys
#define kCMFormatDescriptionKey_CleanApertureWidth				kCVImageBufferCleanApertureWidthKey				// CFNumber
#define kCMFormatDescriptionKey_CleanApertureHeight				kCVImageBufferCleanApertureHeightKey			// CFNumber
#define kCMFormatDescriptionKey_CleanApertureHorizontalOffset	kCVImageBufferCleanApertureHorizontalOffsetKey	// CFNumber
#define kCMFormatDescriptionKey_CleanApertureVerticalOffset		kCVImageBufferCleanApertureVerticalOffsetKey	// CFNumber

// These additional keys are used to record the precise numerator and denominator in cases where the number is not an integer.
CM_EXPORT const CFStringRef kCMFormatDescriptionKey_CleanApertureWidthRational									// CFArray of 2 CFNumbers: numerator, denominator
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMFormatDescriptionKey_CleanApertureHeightRational									// CFArray of 2 CFNumbers: numerator, denominator
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMFormatDescriptionKey_CleanApertureHorizontalOffsetRational						// CFArray of 2 CFNumbers: numerator, denominator
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMFormatDescriptionKey_CleanApertureVerticalOffsetRational							// CFArray of 2 CFNumbers: numerator, denominator
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#define kCMFormatDescriptionExtension_FieldCount				kCVImageBufferFieldCountKey						// CFNumber, 1 or 2

#define kCMFormatDescriptionExtension_FieldDetail				kCVImageBufferFieldDetailKey					// CFString with one of the following four values
#define kCMFormatDescriptionFieldDetail_TemporalTopFirst		kCVImageBufferFieldDetailTemporalTopFirst
#define kCMFormatDescriptionFieldDetail_TemporalBottomFirst		kCVImageBufferFieldDetailTemporalBottomFirst
#define kCMFormatDescriptionFieldDetail_SpatialFirstLineEarly	kCVImageBufferFieldDetailSpatialFirstLineEarly
#define kCMFormatDescriptionFieldDetail_SpatialFirstLineLate	kCVImageBufferFieldDetailSpatialFirstLineLate

#define kCMFormatDescriptionExtension_PixelAspectRatio			kCVImageBufferPixelAspectRatioKey				// CFDictionary with the following two keys
#define kCMFormatDescriptionKey_PixelAspectRatioHorizontalSpacing	kCVImageBufferPixelAspectRatioHorizontalSpacingKey	// CFNumber
#define kCMFormatDescriptionKey_PixelAspectRatioVerticalSpacing	kCVImageBufferPixelAspectRatioVerticalSpacingKey	// CFNumber

#define kCMFormatDescriptionExtension_ColorPrimaries			kCVImageBufferColorPrimariesKey					// CFString describing the color primaries. This key can be one of the following values:
#define kCMFormatDescriptionColorPrimaries_ITU_R_709_2			kCVImageBufferColorPrimaries_ITU_R_709_2		// CFString
#define kCMFormatDescriptionColorPrimaries_EBU_3213				kCVImageBufferColorPrimaries_EBU_3213			// CFString
#define kCMFormatDescriptionColorPrimaries_SMPTE_C				kCVImageBufferColorPrimaries_SMPTE_C			// CFString
CM_EXPORT const CFStringRef kCMFormatDescriptionColorPrimaries_P22												// same as kCVImageBufferColorPrimaries_P22
							__OSX_AVAILABLE_STARTING(__MAC_10_8,__IPHONE_6_0);

#define kCMFormatDescriptionExtension_TransferFunction			kCVImageBufferTransferFunctionKey				// CFString describing the transfer function. This key can be one of the following values:
#define kCMFormatDescriptionTransferFunction_ITU_R_709_2		kCVImageBufferTransferFunction_ITU_R_709_2		// CFString
#define kCMFormatDescriptionTransferFunction_SMPTE_240M_1995	kCVImageBufferTransferFunction_SMPTE_240M_1995	// CFString
#define kCMFormatDescriptionTransferFunction_UseGamma			kCVImageBufferTransferFunction_UseGamma			// CFString

#define kCMFormatDescriptionExtension_GammaLevel				kCVImageBufferGammaLevelKey						// CFNumber describing the gamma level, used in absence of (or ignorance of) kCMFormatDescriptionExtension_TransferFunction

#define kCMFormatDescriptionExtension_YCbCrMatrix				kCVImageBufferYCbCrMatrixKey					// CFString describing the color matrix for YCbCr->RGB. This key can be one of the following values:
#define kCMFormatDescriptionYCbCrMatrix_ITU_R_709_2				kCVImageBufferYCbCrMatrix_ITU_R_709_2			// CFString
#define kCMFormatDescriptionYCbCrMatrix_ITU_R_601_4				kCVImageBufferYCbCrMatrix_ITU_R_601_4			// CFString
#define kCMFormatDescriptionYCbCrMatrix_SMPTE_240M_1995			kCVImageBufferYCbCrMatrix_SMPTE_240M_1995		// CFString

CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_FullRangeVideo										// CFBoolean; by default, false for YCbCr-based compressed formats, indicating that pixel values are video-range rather than full-range
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_3);

CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_ICCProfile											// CFData
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_BytesPerRow											// CFNumber describing the bytes per row of raster pixel data (not used for compressed, planar, tiled or downsampled formats)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/* Chroma siting information. For progressive images, only the TopField value is used. */
#define kCMFormatDescriptionExtension_ChromaLocationTopField		kCVImageBufferChromaLocationTopFieldKey		// CFString with one of the following CFString values
#define kCMFormatDescriptionExtension_ChromaLocationBottomField 	kCVImageBufferChromaLocationBottomFieldKey	// CFString with one of the following CFString values
#define kCMFormatDescriptionChromaLocation_Left						kCVImageBufferChromaLocation_Left			// Chroma sample is horizontally co-sited with the left column of luma samples, but centered vertically.
#define kCMFormatDescriptionChromaLocation_Center					kCVImageBufferChromaLocation_Center			// Chroma sample is fully centered
#define kCMFormatDescriptionChromaLocation_TopLeft					kCVImageBufferChromaLocation_TopLeft		// Chroma sample is co-sited with the top-left luma sample.
#define kCMFormatDescriptionChromaLocation_Top						kCVImageBufferChromaLocation_Top			// Chroma sample is horizontally centered, but co-sited with the top row of luma samples.
#define kCMFormatDescriptionChromaLocation_BottomLeft				kCVImageBufferChromaLocation_BottomLeft		// Chroma sample is co-sited with the bottom-left luma sample.
#define kCMFormatDescriptionChromaLocation_Bottom					kCVImageBufferChromaLocation_Bottom			// Chroma sample is horizontally centered, but co-sited with the bottom row of luma samples.
#define kCMFormatDescriptionChromaLocation_DV420					kCVImageBufferChromaLocation_DV420			// Cr and Cb samples are alternately co-sited with the left luma samples of the same field.

/* MPEG-2-conformant formats */
CM_EXPORT const CFStringRef kCMFormatDescriptionConformsToMPEG2VideoProfile			// CFNumber specifying a kCMMPEG2VideoProfile_*
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

enum
{
	kCMMPEG2VideoProfile_HDV_720p30 =				'hdv1',
	kCMMPEG2VideoProfile_HDV_1080i60 =				'hdv2',
	kCMMPEG2VideoProfile_HDV_1080i50 =				'hdv3',
	kCMMPEG2VideoProfile_HDV_720p24 =				'hdv4',
	kCMMPEG2VideoProfile_HDV_720p25 =				'hdv5',
	kCMMPEG2VideoProfile_HDV_1080p24 =				'hdv6',
	kCMMPEG2VideoProfile_HDV_1080p25 =				'hdv7',
	kCMMPEG2VideoProfile_HDV_1080p30 =				'hdv8',
	kCMMPEG2VideoProfile_HDV_720p60 =				'hdv9',
	kCMMPEG2VideoProfile_HDV_720p50 =				'hdva',
	kCMMPEG2VideoProfile_XDCAM_HD_1080i60_VBR35 =	'xdv2',
	kCMMPEG2VideoProfile_XDCAM_HD_1080i50_VBR35 =	'xdv3',
	kCMMPEG2VideoProfile_XDCAM_HD_1080p24_VBR35 =	'xdv6',
	kCMMPEG2VideoProfile_XDCAM_HD_1080p25_VBR35 =	'xdv7',
	kCMMPEG2VideoProfile_XDCAM_HD_1080p30_VBR35 =	'xdv8',
	kCMMPEG2VideoProfile_XDCAM_EX_720p24_VBR35 =	'xdv4',
	kCMMPEG2VideoProfile_XDCAM_EX_720p25_VBR35 =	'xdv5',
	kCMMPEG2VideoProfile_XDCAM_EX_720p30_VBR35 =	'xdv1',
	kCMMPEG2VideoProfile_XDCAM_EX_720p50_VBR35 =	'xdva',
	kCMMPEG2VideoProfile_XDCAM_EX_720p60_VBR35 =	'xdv9',
	kCMMPEG2VideoProfile_XDCAM_EX_1080i60_VBR35 =	'xdvb',
	kCMMPEG2VideoProfile_XDCAM_EX_1080i50_VBR35 =	'xdvc',
	kCMMPEG2VideoProfile_XDCAM_EX_1080p24_VBR35 =	'xdvd',
	kCMMPEG2VideoProfile_XDCAM_EX_1080p25_VBR35 =	'xdve',
	kCMMPEG2VideoProfile_XDCAM_EX_1080p30_VBR35 =	'xdvf',
	kCMMPEG2VideoProfile_XDCAM_HD422_720p50_CBR50 =	'xd5a',
	kCMMPEG2VideoProfile_XDCAM_HD422_720p60_CBR50 =	'xd59',
	kCMMPEG2VideoProfile_XDCAM_HD422_1080i60_CBR50 =	'xd5b',
	kCMMPEG2VideoProfile_XDCAM_HD422_1080i50_CBR50 =	'xd5c',
	kCMMPEG2VideoProfile_XDCAM_HD422_1080p24_CBR50 =	'xd5d',
	kCMMPEG2VideoProfile_XDCAM_HD422_1080p25_CBR50 =	'xd5e',
	kCMMPEG2VideoProfile_XDCAM_HD422_1080p30_CBR50 =	'xd5f',
	kCMMPEG2VideoProfile_XDCAM_HD_540p =				'xdhd',
	kCMMPEG2VideoProfile_XDCAM_HD422_540p =			'xdh2',
	kCMMPEG2VideoProfile_XDCAM_HD422_720p24_CBR50 = 'xd54',
	kCMMPEG2VideoProfile_XDCAM_HD422_720p25_CBR50 = 'xd55',
	kCMMPEG2VideoProfile_XDCAM_HD422_720p30_CBR50 = 'xd51',
	kCMMPEG2VideoProfile_XF = 'xfz1',
};

CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_TemporalQuality			// CFNumber
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_SpatialQuality			// CFNumber
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#define kCMFormatDescriptionExtension_VerbatimImageDescription	kCMFormatDescriptionExtension_VerbatimSampleDescription

CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_Version					// CFNumber
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_RevisionLevel				// CFNumber
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMFormatDescriptionExtension_Vendor					// CFString of fourCC
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

CM_EXPORT const CFStringRef kCMFormatDescriptionVendor_Apple
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMVideoFormatDescriptionCreate
	@abstract	Creates a format description for a video media stream.
	@discussion	The caller owns the returned CMFormatDescription, and must release it when done with it. All input parameters
				are copied (the extensions are deep-copied).  The caller can deallocate them or re-use them after making this call.
*/
CM_EXPORT
OSStatus CMVideoFormatDescriptionCreate(
	CFAllocatorRef allocator,				/*! @param allocator	CFAllocator to be used. kCFAllocatorDefault used if NULL. */
	CMVideoCodecType codecType,				/*! @param codecType	The type of video compression. */
	int32_t width,							/*! @param width		The width of encoded video. */
	int32_t height,							/*! @param height		The height of encoded video. */
	CFDictionaryRef extensions,				/*! @param extensions	Dictionary of extension key/value pairs. Keys are always CFStrings.
																	Values are always property list objects (ie. CFData, CFString, CFArray,
																	CFDictionary, CFDate, CFBoolean, or CFNumber). Can be NULL. */
	CMVideoFormatDescriptionRef *outDesc)	/*! @param outDesc		Returned newly created video CMFormatDescription */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMVideoFormatDescriptionCreateForImageBuffer
	@abstract	Creates a format description for a video media stream contained in CVImageBuffers of the type provided.
	@discussion	This convenience function is equivalent to:
	
				CMVideoFormatDescriptionCreate( allocator,
												 ( CVPixelBufferGetTypeID() == CFGetTypeID( imageBuffer ) ? CVPixelBufferGetPixelFormatType( imageBuffer ) : 0,
												 width of image,
												 height of image,
												 extensions );
				
				where extensions is a CFDictionary of attachments to image buffer with keys specified by 
				CMVideoFormatDescriptionGetExtensionKeysCommonWithImageBuffers, and also 
				kCMFormatDescriptionExtension_BytesPerRow if applicable.
*/
CM_EXPORT
OSStatus CMVideoFormatDescriptionCreateForImageBuffer(
	CFAllocatorRef allocator,				/*! @param allocator
											CFAllocator to be used when creating the CMFormatDescription. NULL will cause the default allocator to be used */
	CVImageBufferRef imageBuffer,			/*! @param imageBuffer
											Image buffer for which we are creating the format description. */
	CMVideoFormatDescriptionRef *outDesc)	/*! @param outDesc
											Returned newly-created video CMFormatDescription */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMVideoFormatDescriptionCreateFromH264ParameterSets
	@abstract	Creates a format description for a video media stream described by H.264 parameter set NAL units.
	@discussion	This function parses the dimensions provided by the parameter sets and creates a format description suitable for a raw H.264 stream.
				The parameter sets data can come from raw NAL units and must have any emulation prevention bytes needed.
				The supported NAL unit types to be included in the format description are 7 (sequence parameter set), 8 (picture parameter set) and 13 (sequence parameter set extension). At least one sequence parameter set and one picture parameter set must be provided.
*/
CM_EXPORT
OSStatus CMVideoFormatDescriptionCreateFromH264ParameterSets(
	 CFAllocatorRef allocator,						/*! @param allocator
													CFAllocator to be used when creating the CMFormatDescription. Pass NULL to use the default allocator. */
	 size_t parameterSetCount,						/*! @param parameterSetCount
													The number of parameter sets to include in the format description. This parameter must be greater than two. */
	 const uint8_t * const * parameterSetPointers,	/*! @param parameterSetPointers
													Points to a C array containing parameterSetCount pointers to parameter sets. */
	 const size_t * parameterSetSizes,				/*! @param parameterSetSizes
													Points to a C array containing the size, in bytes, of each of the parameter sets. */
	 int NALUnitHeaderLength,						/*! @param NALUnitHeaderLength
													Size, in bytes, of the NALUnitLength field in an AVC video sample or AVC parameter set sample. Pass 1, 2 or 4. */
	 CMFormatDescriptionRef *formatDescriptionOut )	/*! @param formatDescriptionOut
													Returned newly-created video CMFormatDescription */
							__OSX_AVAILABLE_STARTING(__MAC_10_9,__IPHONE_7_0);

/*!
	@function	CMVideoFormatDescriptionGetH264ParameterSetAtIndex
	@abstract	Returns a parameter set contained in a H.264 format description.
	@discussion	This function parses the AVC decoder configuration record contained in a H.264 video format description and returns the parameter set NAL unit at the given index from it.
				Both parameterSetPointerOut and parameterSetSizeOut may be NULL, parameterSetCountOut will return the total number of parameter set NAL units contained in the AVC decoder configuration record.
				The parameter set NAL units returned will already have any emulation prevention bytes needed.
				The pointer returned in parameterSetPointerOut points to internal memory of videoDesc, and may only be accessed as long as a retain on videoDesc is held.
*/
CM_EXPORT
OSStatus CMVideoFormatDescriptionGetH264ParameterSetAtIndex(
		CMFormatDescriptionRef videoDesc,			/*! @param videoDesc
													FormatDescription being interrogated. */
		size_t parameterSetIndex,					/*! @param parameterSetIndex
													Index of the parameter set to be returned in parameterSetPointerOut and parameterSetSizeOut. This parameter is ignored if both parameterSetPointerOut and parameterSetSizeOut are NULL. */
		const uint8_t **parameterSetPointerOut,		/*! @param parameterSetPointerOut
													Points to a pointer to receive the parameter set. Pass NULL if you do not want this information. */
		size_t *parameterSetSizeOut,				/*! @param parameterSetSizeOut
													Points to a size_t to receive the size in bytes of the parameter set. Pass NULL if you do not want this information. */
		size_t *parameterSetCountOut,				/*! @param parameterSetCountOut
													Number of parameter sets in the AVC decoder configuration record contained in videoDesc. Pass NULL if you do not want this information. */
		int *NALUnitHeaderLengthOut )				/*! @param NALUnitHeaderLengthOut
													Points to an int to receive the size, in bytes, of the NALUnitLength field in an AVC video sample or AVC parameter set sample. Pass NULL if you do not want this information. */
							__OSX_AVAILABLE_STARTING(__MAC_10_9,__IPHONE_7_0);

#define CMVideoFormatDescriptionGetCodecType(desc)  CMFormatDescriptionGetMediaSubType(desc)

/*!
	@function	CMVideoFormatDescriptionGetDimensions
	@abstract	Returns the dimensions (in encoded pixels)
	@discussion	This does not take into account pixel aspect ratio or clean aperture tags.
*/
CM_EXPORT
CMVideoDimensions CMVideoFormatDescriptionGetDimensions(
	CMVideoFormatDescriptionRef videoDesc)	/*! @param videoDesc
											FormatDescription being interrogated. */ 
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMVideoFormatDescriptionGetPresentationDimensions
	@abstract	Returns the dimensions, adjusted to take pixel aspect ratio and/or clean aperture into account.
	@discussion
		Pixel aspect ratio is used to adjust the width, leaving the height alone.
*/
CM_EXPORT
CGSize CMVideoFormatDescriptionGetPresentationDimensions(
		CMVideoFormatDescriptionRef videoDesc,		/*! @param videoDesc
													FormatDescription being interrogated. */ 
		Boolean usePixelAspectRatio,				/*! @param usePixelAspectRatio
													Compute the dimensions maintaining pixel aspect ratio */
		Boolean useCleanAperture )					/*! @param useCleanAperture
													Compute the dimensions using the clean aperture */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMVideoFormatDescriptionGetCleanAperture
	@abstract	Returns the clean aperture.
	@discussion
		The clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
		that represents image data valid for display.  
*/
CM_EXPORT
CGRect CMVideoFormatDescriptionGetCleanAperture( 
		CMVideoFormatDescriptionRef videoDesc,		/*! @param videoDesc
													FormatDescription being interrogated. */ 
		Boolean originIsAtTopLeft )					/*! @param originIsAtTopLeft
													Pass true if the CGRect will be used in an environment 
													where (0,0) is at the top-left corner of an enclosing rectangle 
													and y coordinates increase as you go down.
													Pass false if the CGRect will be used in an environment 
													where (0,0) is at the bottom-left corner of an enclosing rectangle 
													and y coordinates increase as you go up. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMVideoFormatDescriptionGetExtensionKeysCommonWithImageBuffers
	@abstract	Returns an array of the keys that are used both as CMVideoFormatDescription extensions
				and CVImageBuffer attachments and attributes.
	@discussion	When specifying a CMFormatDescription for a CMSampleBuffer, the format description must
				be consistent with formatting information attached to the CVImageBuffer. The width, height,
				and codecType must match (for CVPixelBuffers the codec type is given by
				CVPixelBufferGetPixelFormatType(pixelBuffer); for other CVImageBuffers, the codecType must be 0).
				The format description extensions must match the image buffer attachments for all the keys in the
				list returned by this function (if absent in either they must be absent in both).
				
				Currently, the list is:
				
				kCMFormatDescriptionExtension_CleanAperture
				kCMFormatDescriptionExtension_FieldCount
				kCMFormatDescriptionExtension_FieldDetail
				kCMFormatDescriptionExtension_PixelAspectRatio
				kCMFormatDescriptionExtension_ColorPrimaries
				kCMFormatDescriptionExtension_TransferFunction
				kCMFormatDescriptionExtension_GammaLevel
				kCMFormatDescriptionExtension_YCbCrMatrix
				kCMFormatDescriptionExtension_ICCProfile
				kCMFormatDescriptionExtension_ChromaLocationTopField
				kCMFormatDescriptionExtension_ChromaLocationBottomField
*/
CM_EXPORT
CFArrayRef CMVideoFormatDescriptionGetExtensionKeysCommonWithImageBuffers(void)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMVideoFormatDescriptionMatchesImageBuffer
	@abstract	Checks to see if a given format description matches an image buffer.
	@discussion	This function uses the keys returned by CMVideoFormatDescriptionGetExtensionKeysCommonWithImageBuffers
				to compares the extensions of the given format description to the attachments of the
				given image buffer (if an attachment is absent in either it must be absent in both).
				It also checks kCMFormatDescriptionExtension_BytesPerRow against CVPixelBufferGetBytesPerRow, if applicable.
*/
CM_EXPORT
Boolean CMVideoFormatDescriptionMatchesImageBuffer(
	CMVideoFormatDescriptionRef desc,	/*! @param desc			format description to validate. */
	CVImageBufferRef imageBuffer)		/*! @param imageBuffer	image buffer validate against. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#pragma mark CMMuxedFormatDescription

/*! 
	@functiongroup	Muxed-specific functions
*/

/*!
	@typedef CMMuxedFormatDescriptionRef
	Synonym type used for manipulating muxed media CMFormatDescriptions
*/
typedef CMFormatDescriptionRef CMMuxedFormatDescriptionRef;

/*!
	@enum CMMuxedStreamType
	@discussion Muxed media format/subtype.
	@constant	kCMMuxedStreamType_MPEG1System	MPEG-1 System stream
	@constant	kCMMuxedStreamType_MPEG2Transport	MPEG-2 Transport stream
	@constant	kCMMuxedStreamType_MPEG2Program	MPEG-2 Program stream
	@constant	kCMMuxedStreamType_DV	DV stream
*/
enum {
	kCMMuxedStreamType_MPEG1System		= 'mp1s',
	kCMMuxedStreamType_MPEG2Transport	= 'mp2t',
	kCMMuxedStreamType_MPEG2Program		= 'mp2p',
	kCMMuxedStreamType_DV				= 'dv  '
};
typedef FourCharCode CMMuxedStreamType;

#define CMMuxedFormatDescriptionGetStreamType(desc)  CMFormatDescriptionGetMediaSubType(desc)

/*!
	@function	CMMuxedFormatDescriptionCreate
	@abstract	Creates a format description for a muxed media stream.
	@discussion	A muxed format description does not know what the formats are of the substreams within the muxed stream.
				That information will only be discoverable by the demuxer software (or other software which understands
				the details of the muxed bitstream) which will need to produce separate format descriptions for each of
				its output streams. The caller owns the returned CMFormatDescription, and must release it when done
				with it. All input parameters are copied (the extensions are deep-copied).  The caller can deallocate
				them or re-use them after making this call.
*/
CM_EXPORT
OSStatus CMMuxedFormatDescriptionCreate(
	CFAllocatorRef allocator,			/*! @param allocator		CFAllocator to be used. kCFAllocatorDefault if you don't care. */
	CMMuxedStreamType muxType,			/*! @param muxType			Type of the muxed stream (eg. kCMMuxedStreamType_MPEG2Transport
																	for MPEG-2 transport stream). This is the media subtype, and will
																	be returned if you subsequently call CMFormatDescriptionGetMediaSubType
																	(or CMMuxedFormatDescriptionGetStreamType). */
	CFDictionaryRef extensions,			/*! @param extensions		Dictionary of extension key/value pairs. Keys are always CFStrings.
																	Values are always property list objects (ie. CFData, CFString, CFArray,
																	CFDictionary, CFDate, CFBoolean, or CFNumber). Can be NULL. */
	CMMuxedFormatDescriptionRef *outDesc)	/*! @param outDesc		Returned newly created muxed CMFormatDescription */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


#pragma mark CMClosedCaptionFormatDescription

/*! 
	@functiongroup	Closed caption-specific functions
*/

/*!
	@typedef CMClosedCaptionFormatDescriptionRef
	Synonym type used for manipulating closed-caption media CMFormatDescriptions
*/
typedef CMFormatDescriptionRef CMClosedCaptionFormatDescriptionRef;

/*!
	@enum CMClosedCaptionFormatType
	@discussion Closed-caption media format/subtype.
				Note:  use CMFormatDescriptionCreate to create a CMClosedCaptionFormatDescriptionRef.
	@constant	kCMClosedCaptionFormatType_CEA608	CEA 608-compliant samples
	@constant	kCMClosedCaptionFormatType_CEA708	CEA 708-compliant samples
	@constant	kCMClosedCaptionFormatType_ATSC		ATSC/52 part-4 compliant samples
*/
enum {
	kCMClosedCaptionFormatType_CEA608	= 'c608',
	kCMClosedCaptionFormatType_CEA708	= 'c708',
	kCMClosedCaptionFormatType_ATSC		= 'atcc'
};
typedef FourCharCode CMClosedCaptionFormatType;

#define CMClosedCaptionFormatDescriptionGetFormatType(desc)  CMFormatDescriptionGetMediaSubType(desc)


#pragma mark CMTextFormatDescription

/*!
	@enum CMTextFormatType
	@discussion Text media format/subtype.
	@constant	kCMTextFormatType_QTText	QuickTime Text media
	@constant	kCMTextFormatType_3GText	3GPP Text media
*/
enum {
    kCMTextFormatType_QTText           = 'text',
    kCMTextFormatType_3GText           = 'tx3g'
};
typedef FourCharCode CMTextFormatType;

/*!
	@enum CMTextDisplayFlags
	@discussion Display mode flags for text media.
	@constant	kCMTextDisplayFlag_scrollIn		Text scrolls into the display region.
	@constant	kCMTextDisplayFlag_scrollOut	Text scrolls out of the display region.
	@constant	kCMTextDisplayFlag_scrollDirectionMask	The scrolling direction is set by a two-bit field, obtained from displayFlags using kCMTextDisplayFlag_scrollDirectionMask.
	@constant	kCMTextDisplayFlag_scrollDirection_bottomToTop	Text is vertically scrolled up ("credits style"), entering from the bottom and leaving towards the top.
	@constant	kCMTextDisplayFlag_scrollDirection_rightToLeft	Text is horizontally scrolled ("marquee style"), entering from the right and leaving towards the left.
	@constant	kCMTextDisplayFlag_scrollDirection_topToBottom	Text is vertically scrolled down, entering from the top and leaving towards the bottom.
	@constant	kCMTextDisplayFlag_scrollDirection_leftToRight	Text is horizontally scrolled, entering from the left and leaving towards the right.
	@constant	kCMTextDisplayFlag_continuousKaraoke	Enables the Continuous Karaoke mode where the range of karaoke highlighting extends to include additional ranges rather than the highlighting moves onto the next range.
	@constant	kCMTextDisplayFlag_writeTextVertically	Specifies the text to be rendered vertically.
	@constant	kCMTextDisplayFlag_fillTextRegion	The subtitle display bounds are to be filled with the color specified by kCMTextFormatDescriptionExtension_BackgroundColor.
	@constant	kCMTextDisplayFlag_obeySubtitleFormatting	Specifies that the subtitle display bounds should be used to determine if the subtitles should be placed near the top or the bottom of the video. Otherwise, subtitles should be placed at the bottom of the video.
	@constant	kCMTextDisplayFlag_forcedSubtitlesPresent	There are forced subtitles present, e.g., a subtitle which only displays during foreign language sections of the video. Check individual samples to determine what type of subtitle is contained.
	@constant	kCMTextDisplayFlag_allSubtitlesForced	Treat all subtitle samples as if they contain forced subtitles.
*/
enum {
    kCMTextDisplayFlag_scrollIn                    = 0x00000020,
    kCMTextDisplayFlag_scrollOut                   = 0x00000040,
    kCMTextDisplayFlag_scrollDirectionMask         = 0x00000180,
    kCMTextDisplayFlag_scrollDirection_bottomToTop = 0x00000000,
    kCMTextDisplayFlag_scrollDirection_rightToLeft = 0x00000080,
    kCMTextDisplayFlag_scrollDirection_topToBottom = 0x00000100,
    kCMTextDisplayFlag_scrollDirection_leftToRight = 0x00000180,
    kCMTextDisplayFlag_continuousKaraoke           = 0x00000800,
    kCMTextDisplayFlag_writeTextVertically         = 0x00020000,
    kCMTextDisplayFlag_fillTextRegion              = 0x00040000,
    kCMTextDisplayFlag_obeySubtitleFormatting      = 0x20000000,
    kCMTextDisplayFlag_forcedSubtitlesPresent      = 0x40000000,
    kCMTextDisplayFlag_allSubtitlesForced          = 0x80000000,
};
typedef uint32_t CMTextDisplayFlags;

/*!
	@enum CMTextJustificationValue
	@discussion Justification modes for text media. Used when specifying either horizontal or vertical justification.
	@constant	kCMTextJustification_left_top	Left justification when specified for horizontal justification, top justification for vertical justification.
	@constant	kCMTextJustification_centered	Center justification (both horizontal and vertical justification).
	@constant	kCMTextJustification_bottom_right	Bottom justification when specified for vertical justification, right justification for horizontal justification.
*/
enum {
	kCMTextJustification_left_top		=  0,
	kCMTextJustification_centered		=  1,
	kCMTextJustification_bottom_right	= -1
};
typedef int8_t CMTextJustificationValue;

// Extension keys and values common to kCMTextFormatType_QTText and kCMTextFormatType_3GText format descriptions
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_DisplayFlags                 // CFNumber (SInt32 holding CMTextDisplayFlags)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_BackgroundColor              // CFDictionary
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionColor_Red                          // CFNumber (SInt8 for 3G), (SInt16 for QT)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionColor_Green                        // CFNumber (SInt8 for 3G), (SInt16 for QT)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionColor_Blue                         // CFNumber (SInt8 for 3G), (SInt16 for QT)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionColor_Alpha                        // CFNumber (SInt8 for 3G), not applicable for QT text.
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_DefaultTextBox               // CFDictionary
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionRect_Top                           // CFNumber (SInt16)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionRect_Left                          // CFNumber (SInt16)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionRect_Bottom                        // CFNumber (SInt16)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionRect_Right                         // CFNumber (SInt16)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_DefaultStyle                 // CFDictionary
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionStyle_StartChar             		// CFNumber (SInt16 for 3G), (SInt32 for QT)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionStyle_Font                  		// CFNumber (SInt16)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionStyle_FontFace              		// CFNumber (SInt8)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionStyle_ForegroundColor       		// CFDictionary (kCMTextFormatDescriptionColor_Red, kCMTextFormatDescriptionColor_Green, etc)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionStyle_FontSize              		// CFNumber (SInt8 for 3G), (SInt16 for QT)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    
// Extension keys and values specific to kCMTextFormatType_3GText
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_HorizontalJustification      // CFNumber (SInt8 holding a CMTextJustificationValue)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_VerticalJustification        // CFNumber (SInt8 holding a CMTextJustificationValue)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    // Extension keys and values specific to the kCMTextFormatType_3GText kCMTextFormatDescriptionExtension_DefaultStyle dictionary
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionStyle_EndChar               		// CFNumber (SInt16)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_FontTable                    // CFDictionary (Keys are FontIDs as CFStrings, vals are font names as CFStrings)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    
// Extension keys and values specific to kCMTextFormatType_QTText
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_TextJustification            // CFNumber (SInt32 holding a CMTextJustificationValue)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    // Extension keys and values specific to the kCMTextFormatType_QTText kCMTextFormatDescriptionExtension_DefaultStyle dictionary
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionStyle_Height                		// CFNumber (SInt16)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
    CM_EXPORT const CFStringRef kCMTextFormatDescriptionStyle_Ascent                		// CFNumber (SInt16)
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMTextFormatDescriptionExtension_DefaultFontName              // CFString
								__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);


/*!
	@function	CMTextFormatDescriptionGetDisplayFlags
	@abstract	Returns the displayFlags.
	@discussion
		These are the flags that control how the text appears. The function can return kCMFormatDescriptionError_ValueNotAvailable for formats without display flags.
*/
CM_EXPORT
OSStatus CMTextFormatDescriptionGetDisplayFlags(
	CMFormatDescriptionRef desc,			/*! @param desc
											FormatDescription being interrogated. */
	CMTextDisplayFlags *outDisplayFlags)	/*! @param outDisplayFlags
											Receives the display flags. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTextFormatDescriptionGetJustification
	@abstract	Returns horizontal and vertical justification.
	@discussion
		Values are kCMTextJustification_* constants. The function returns kCMFormatDescriptionError_ValueNotAvailable for format descriptions that do not carry text justification.
*/
CM_EXPORT
OSStatus CMTextFormatDescriptionGetJustification(
	CMFormatDescriptionRef desc,					/*! @param desc
													FormatDescription being interrogated. */
	CMTextJustificationValue *outHorizontalJust,	/*! @param outHorizontalJust
													Horizontal justification mode. May be NULL. */
	CMTextJustificationValue *outVerticalJust)		/*! @param outVerticalJust
													Vertical justification mode. May be NULL. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTextFormatDescriptionGetDefaultTextBox
	@abstract	Returns the default text box.
	@discussion
		Within a text track, text is rendered within a text box.  There is a default text box set, which can be over-ridden by a sample. The function can return kCMFormatDescriptionError_ValueNotAvailable for format descriptions that do not carry a default text box.
*/
CM_EXPORT
OSStatus CMTextFormatDescriptionGetDefaultTextBox(
	CMFormatDescriptionRef desc,	/*! @param desc
									FormatDescription being interrogated. */
	Boolean originIsAtTopLeft,		/*! @param originIsAtTopLeft
									Pass true if the CGRect will be used in an environment 
									where (0,0) is at the top-left corner of an enclosing rectangle 
									and y coordinates increase as you go down.
									Pass false if the CGRect will be used in an environment 
									where (0,0) is at the bottom-left corner of an enclosing rectangle 
									and y coordinates increase as you go up. */
	CGFloat heightOfTextTrack,		/*! @param heightOfTextTrack
									If originIsAtTopLeft is false, pass the height of the enclosing text track or destination.
									This value will be used to properly compute the default text box for the given origin.
									Ignored if originIsAtTopLeft is true. */
	CGRect *outDefaultTextBox)		/*! @param outDefaultTextBox
									Receives the default text box. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTextFormatDescriptionGetDefaultStyle
	@abstract	Returns the default style. 
	@discussion	
		The function returns kCMFormatDescriptionError_ValueNotAvailable for format descriptions that do not carry default style information.
*/
CM_EXPORT
OSStatus CMTextFormatDescriptionGetDefaultStyle(
	CMFormatDescriptionRef desc,	/*! @param desc
									FormatDescription being interrogated. */
	uint16_t *outLocalFontID,		/*! @param localFontID
									Font number, local to the FormatDescription. May be NULL. */
	Boolean *outBold,				/*! @param outBold
									Returned true if style includes Bold. May be NULL. */
	Boolean *outItalic,				/*! @param outItalic
									Returned true if style includes Italic. May be NULL. */
	Boolean *outUnderline,			/*! @param outUnderline
									Returned true if style includes Underline. May be NULL. */
	CGFloat *outFontSize,			/*! @param outFontSize
									FontSize in points. May be NULL. */
	CGFloat outColorComponents[4])	/*! @param outColorComponents
									Components are in order red, green, blue, alpha. May be NULL. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTextFormatDescriptionGetFontName
	@abstract	Returns the font name for a local font ID.
	@discussion
		Some format descriptions carry a mapping from local font IDs to font names. The function returns kCMFormatDescriptionError_ValueNotAvailable for format descriptions that do not carry such a font mapping table.
*/
CM_EXPORT
OSStatus CMTextFormatDescriptionGetFontName(
	CMFormatDescriptionRef desc,	/*! @param desc
									FormatDescription being interrogated. */
	uint16_t localFontID,			/*! @param localFontID
									Font number, local to the FormatDescription. */
	CFStringRef *outFontName)		/*! @param outFontName
									Name of the font. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#pragma mark CMSubtitleFormatDescription
	
enum {
    kCMSubtitleFormatType_3GText = 'tx3g',
	kCMSubtitleFormatType_WebVTT = 'wvtt',
};

typedef FourCharCode CMSubtitleFormatType;
	
#define CMSubtitleFormatDescriptionGetFormatType(desc)	CMFormatDescriptionGetMediaSubType(desc)

#pragma mark CMTimeCodeFormatDescription

/*! 
	@functiongroup	TimeCode-specific functions
*/

/*!
	@typedef CMTimeCodeFormatDescriptionRef
	SYnonym type used for manipulating TimeCode media CMFormatDescriptions
*/
typedef CMFormatDescriptionRef CMTimeCodeFormatDescriptionRef;

/*!
	@enum CMTimeCodeFormatType
	@discussion The types of TimeCode.
	@constant	kCMTimeCodeFormatType_TimeCode32 32-bit timeCode sample.
	@constant	kCMTimeCodeFormatType_TimeCode64 64-bit timeCode sample.
	@constant	kCMTimeCodeFormatType_Counter32 32-bit counter-mode sample.
	@constant	kCMTimeCodeFormatType_Counter64 64-bit counter-mode sample.
*/	
enum {
	kCMTimeCodeFormatType_TimeCode32	= 'tmcd',
	kCMTimeCodeFormatType_TimeCode64	= 'tc64',
	kCMTimeCodeFormatType_Counter32		= 'cn32',
	kCMTimeCodeFormatType_Counter64		= 'cn64'
};
typedef FourCharCode CMTimeCodeFormatType;

#define CMTimeCodeFormatDescriptionGetFormatType(desc)	CMFormatDescriptionGetMediaSubType(desc)

/*!
	@enum TimeCode Flags
	@discussion Flags passed to CMTimeCodeFormatDescriptionCreate.
	@constant	kCMTimeCodeFlag_DropFrame	Timecodes are to be rendered in drop-frame format.
	@constant	kCMTimeCodeFlag_24HourMax	Timecode rolls over every 24 hours.
	@constant	kCMTimeCodeFlag_NegTimesOK	Track may contain negative timecodes.
*/
enum {
	kCMTimeCodeFlag_DropFrame	= 1 << 0,
	kCMTimeCodeFlag_24HourMax	= 1 << 1,
	kCMTimeCodeFlag_NegTimesOK	= 1 << 2
};

/*!
	@function	CMTimeCodeFormatDescriptionCreate
	@abstract	Creates a format description for a timecode media.
	@discussion	The caller owns the returned CMFormatDescription, and must release it when done with it. All input parameters
				are copied (the extensions are deep-copied).  The caller can deallocate them or re-use them after making this call.
*/
CM_EXPORT
OSStatus CMTimeCodeFormatDescriptionCreate(
	CFAllocatorRef allocator,					/*! @param allocator
												Allocator to be used for creating the FormatDescription object */
	CMTimeCodeFormatType timeCodeFormatType,	/*! @param timeCodeFormatType
												One of the CMTimeCodeFormatTypes */
	CMTime frameDuration,						/*! @param frameDuration
												Duration of each frame (eg. 100/2997) */
	uint32_t frameQuanta,						/*! @param frameQuanta
												Frames/sec for timecode (eg. 30) OR frames/tick for counter mode */
	uint32_t tcFlags,							/*! @param tcFlags
												kCMTimeCodeFlag_DropFrame, kCMTimeCodeFlag_24HourMax, kCMTimeCodeFlag_NegTimesOK */
	CFDictionaryRef extensions,					/*! @param extensions
												Keys are always CFStrings. Values are always property list objects (ie. CFData). May be NULL. */
	CMTimeCodeFormatDescriptionRef *descOut)	/*! @param descOut
												Receives the newly-created CMFormatDescription. */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeCodeFormatDescriptionGetFrameDuration
	@abstract	Returns the duration of each frame (eg. 100/2997)
*/
CM_EXPORT
CMTime CMTimeCodeFormatDescriptionGetFrameDuration(
	CMTimeCodeFormatDescriptionRef timeCodeFormatDescription)	/*! @param timeCodeFormatDescription
																FormatDescription being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeCodeFormatDescriptionGetFrameQuanta
	@abstract	Returns the frames/sec for timecode (eg. 30) OR frames/tick for counter mode
*/
CM_EXPORT
uint32_t CMTimeCodeFormatDescriptionGetFrameQuanta(
	CMTimeCodeFormatDescriptionRef timeCodeFormatDescription)	/*! @param timeCodeFormatDescription
																FormatDescription being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

/*!
	@function	CMTimeCodeFormatDescriptionGetTimeCodeFlags
	@abstract	Returns the flags for kCMTimeCodeFlag_DropFrame, kCMTimeCodeFlag_24HourMax, kCMTimeCodeFlag_NegTimesOK
*/
CM_EXPORT
uint32_t CMTimeCodeFormatDescriptionGetTimeCodeFlags(
	CMTimeCodeFormatDescriptionRef desc)	/*! @param desc
											FormatDescription being interrogated */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

CM_EXPORT const CFStringRef kCMTimeCodeFormatDescriptionExtension_SourceReferenceName	// CFDictionary containing the following two keys
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMTimeCodeFormatDescriptionKey_Value						// CFString
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
CM_EXPORT const CFStringRef kCMTimeCodeFormatDescriptionKey_LangCode					// CFNumber
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#pragma mark CMMetadataFormatDescription

/*! 
	@functiongroup	Metadata-specific functions
*/

/*!
	@typedef CMMetadataFormatDescriptionRef
	SYnonym type used for manipulating Metadata media CMFormatDescriptions
*/
typedef CMFormatDescriptionRef CMMetadataFormatDescriptionRef;

/*!
	@enum CMMetadataFormatType
	@discussion The subtypes of Metadata media type.
	@constant	kCMMetadataFormatType_ICY		SHOUTCast format.
	@constant	kCMMetadataFormatType_ID3		ID3 format.
	@constant	kCMMetadataFormatType_Boxed		Boxed format.
*/
enum {
	kCMMetadataFormatType_ICY   = 'icy ',
	kCMMetadataFormatType_ID3   = 'id3 ',
	kCMMetadataFormatType_Boxed = 'mebx',
};
typedef FourCharCode CMMetadataFormatType;

CM_EXPORT const CFStringRef kCMFormatDescriptionExtensionKey_MetadataKeyTable
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
	CM_EXPORT const CFStringRef kCMMetadataFormatDescriptionKey_Namespace	// CFNumber(OSType) native endian
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
	CM_EXPORT const CFStringRef kCMMetadataFormatDescriptionKey_Value		// CFData
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);
	CM_EXPORT const CFStringRef kCMMetadataFormatDescriptionKey_LocalID 	// CFNumber(OSType) native endian
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

CM_EXPORT
OSStatus CMMetadataFormatDescriptionCreateWithKeys(
	CFAllocatorRef allocator,					/*! @param allocator	CFAllocator to be used. kCFAllocatorDefault if you don't care. */
	CMMetadataFormatType metadataType,			/*! @param metadataType The type of metadata (kCMMetadataFormatType_Boxed). */
	CFArrayRef keys,							/*! @param keys			Array of metadata keys. Each key is a dictionary of key
																		properties. The required properties are: 
																			kCMMetadataFormatDescriptionKey_Namespace
																			kCMMetadataFormatDescriptionKey_Value
																			kCMMetadataFormatDescriptionKey_LocalID */
	CMMetadataFormatDescriptionRef *outDesc)	/*! @param outDesc		Returned newly created metadata CMFormatDescription */
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

CM_EXPORT
CFDictionaryRef CMMetadataFormatDescriptionGetKeyWithLocalID( CMMetadataFormatDescriptionRef desc, OSType localKeyID)
							__OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

#pragma pack(pop)

#ifdef __cplusplus
}
#endif
		
#endif // FIGFORMATDESCRIPTION_H
