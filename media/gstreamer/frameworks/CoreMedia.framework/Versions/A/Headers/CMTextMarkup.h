/*
    File:  CMTextMarkup.h

    Framework:  CoreMedia
 
    Copyright 2012-2013 Apple Inc. All rights reserved.

*/

#ifndef CMTEXTMARKUP_H
#define CMTEXTMARKUP_H

/*!
    @header
    @abstract   Definition of text markup related attributes to which Core Media will respond.

    @discussion Core Media includes support for legible media streams such as subtitles, captions and text. In some
                cases, clients may need to specify style information to control the rendering. In other cases,
                information about the text and applied styling may be communicated from Core Media to the client.
                To carry this information, Core Media defines a set of attributes that may be used in dictionaries
                that Core Media uses. These attributes can also be used as CFAttributedString attributes.
*/

#include <CoreMedia/CMBase.h>
#include <CoreFoundation/CoreFoundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma pack(push, 4)

#pragma mark CMTextMarkup Attributes

/*!
    @const      kCMTextMarkupAttribute_ForegroundColorARGB
    @abstract   The foreground color for text.
 
    @discussion Value must be a CFArray of 4 CFNumbers representing alpha, red, green, and blue fields with values between 0.0 and 1.0. The
                red, green and blue components are interpreted in the sRGB color space. The alpha indicates the opacity from 0.0 for transparent to
                1.0 for 100% opaque.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_ForegroundColorARGB __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_6_0);

/*!
    @const      kCMTextMarkupAttribute_BackgroundColorARGB
    @abstract   The background color for the shape holding the text.
 
    @discussion Value must be a CFArray of 4 CFNumbers representing alpha, red, green, and blue fields with values between 0.0 and 1.0. The
                red, green and blue components are interpreted in the sRGB color space. The alpha indicates the opacity from 0.0 for transparent to
                1.0 for 100% opaque.

                The color applies to the geometry (e.g., a box) containing the text. The container's background color may have an 
                alpha of 0 so it is not displayed even though the text is displayed. The color behind individual characters
                is optionally controllable with the kCMTextMarkupAttribute_CharacterBackgroundColorARGB attribute. 
 
                If used, this attribute must be applied to the entire attributed string (i.e.,
                CFRangeMake(0, CFAttributedStringGetLength(...))).
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_BackgroundColorARGB __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_6_0);

/*!
    @const      kCMTextMarkupAttribute_CharacterBackgroundColorARGB
    @abstract   The background color behind individual text characters.
 
    @discussion Value must be a CFArray of 4 CFNumbers representing alpha, red, green, and blue fields with values between 0.0 and 1.0. The
                red, green and blue components are interpreted in the sRGB color space. The alpha indicates the opacity from 0.0 for transparent to
                1.0 for 100% opaque.
 */
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_CharacterBackgroundColorARGB __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

/*!
    @const      kCMTextMarkupAttribute_BoldStyle
    @abstract   Allows the setting of a bold style to be applied.

    @discussion Value must be a CFBoolean. The default is kCFBooleanFalse.
                If this attribute is kCFBooleanTrue, the text will be drawn 
                with a bold style. Other styles such as italic may or may 
                not be used as well.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_BoldStyle __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_6_0);

/*!
    @const      kCMTextMarkupAttribute_ItalicStyle
    @abstract   Allows the setting of an italic style to be applied.

    @discussion Value must be a CFBoolean. The default is kCFBooleanFalse.
                If this attribute is kCFBooleanTrue, the text will be rendered 
                with an italic style. Other styles such as bold may or may not 
                be used as well.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_ItalicStyle __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_6_0);

/*!
    @const      kCMTextMarkupAttribute_UnderlineStyle
    @abstract   Allows the setting of an underline to be applied at render
                time.

    @discussion Value must be a CFBoolean. The default is kCFBooleanFalse.
                If this attribute is kCFBooleanTrue, the text will be rendered 
                with an underline. Other styles such as bold may or may not 
                be used as well.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_UnderlineStyle __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_6_0);

/*!
    @const      kCMTextMarkupAttribute_FontFamilyName
    @abstract   The name of the font.
 
    @discussion Value must be a CFString holding the family name of an installed font
                (e.g., "Helvetica") that is used to render and/or measure text.
 
                When vended by legible output, an attributed string will have at most one of kCMTextMarkupAttribute_FontFamilyName or
                kCMTextMarkupAttribute_GenericFontFamilyName associated with each character.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_FontFamilyName __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_6_0);

/*!
    @const      kCMTextMarkupAttribute_GenericFontFamilyName
    @abstract   The attribute holding a generic font family identifier.
 
    @discussion	Value must be a CFString holding a generic font family name that is one of the kCMTextMarkupGenericFontName_* constants.
 				Generic fonts must be mapped to the family name of an installed font (e.g., kCMTextMarkupGenericFontName_SansSerif -> "Helvetica")
 				before rendering and/or measuring text.
 
                When vended by legible output, an attributed string will have at most one of kCMTextMarkupAttribute_FontFamilyName or
                kCMTextMarkupAttribute_GenericFontFamilyName associated with each character.
 
                Overview of Generic Font Family Names
                =====================================
                Some media formats allow the specification of font family names to be used to style text they carry. Sometimes, an
                external specification (e.g., CSS) may be used to style the text carried by the media format. In either case, the
                specification may be concrete, indicating an installed platform font (e.g., "Times New Roman", Helvetica). It may be
                abstract, indicating a category of font to use (e.g., serif, sans-serif). This abstract designation is often termed
                a "generic font family".

                CSS for example allows a 'font-family' property specification such as this:

                    font-family: Helvetica, sans-serif;

                This uses both the concrete family name "Helvetica" and the generic family name "sans-serif".

                Generic font families may be common across media formats (e.g., both CSS and 3GPP timed text allow "sans-serif" and "serif").
                Other formats may have generic font identifiers that do not align exactly (e.g., TTML allows "monospaceSerif and "monospaceSansSerif" in
                addition to "monospace"). Some formats might not carry names but have numeric values mapping to a generic font identifier.
                Simply put, different formats use different ways to express their generic fonts.

                The use of generic font families is also important for media accessibility. The Media Accessibility framework can map eight categories
                of abstract fonts to an installed font. Users may choose to override each of these categories to a different installed font. This
                remapping should work if the content or external styling indicates a generic font. It should not however try to remap a concrete font like "Helvetica".
                Consequently, it is important to distinguish between the generic and concrete fonts expressed by the author.

                To accommodate what is expressible in media formats and to support media accessibility overrides, generic font families can be
                specified with the kCMTextMarkupAttribute_GenericFontFamilyName attribute which carries the identifier for one of the various
                generic font specification forms supported across media formats. These generic font identifiers are the kCMTextMarkupGenericFontName_*
                prefixed constants also defined here. New identifers may be added in the future.
 
                Concrete fonts are specified using the kCMTextMarkupAttribute_FontFamilyName attribute also defined in this header.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_GenericFontFamilyName __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

/*!
	@abstract   Values for kCMTextMarkupAttribute_GenericFontFamilyName. 

	@const      kCMTextMarkupGenericFontName_Default
 				The generic font name indicating the default font. The default font may also be chosen if no font family is
 				specified (i.e., no kCMTextMarkupAttribute_FontFamilyName or kCMTextMarkupAttribute_GenericFontFamilyName is specified).

	@const      kCMTextMarkupGenericFontName_Serif
 				The generic font name indicating a font with serifs. The font may be proportional or monospaced. E.g., Times New Roman

	@const      kCMTextMarkupGenericFontName_SansSerif
 				The generic font name indicating a font without serifs. The font may be proportional or monospaced. E.g., Helvetica

	@const      kCMTextMarkupGenericFontName_Monospace
 				The generic font name indicating a monospaced font, with or without serifs. E.g., Courier

	@const      kCMTextMarkupGenericFontName_ProportionalSerif
 				The generic font name indicating a proportional font with serifs.

	@const      kCMTextMarkupGenericFontName_ProportionalSansSerif
 				The generic font name indicating a proportional font without serifs.

	@const      kCMTextMarkupGenericFontName_MonospaceSerif
 				The generic font name indicating a monospaced font with serifs.

	@const      kCMTextMarkupGenericFontName_MonospaceSansSerif
 				The generic font name indicating a monospaced font without serifs.

	@const      kCMTextMarkupGenericFontName_Casual
 				The generic font name indicating a "casual" font. E.g., Dom or Impress

	@const      kCMTextMarkupGenericFontName_Cursive
 				The generic font name indicating a cursive font. E.g., Coronet or Marigold

	@const      kCMTextMarkupGenericFontName_Fantasy
 				The generic font name indicating a "fantasy" font.

	@const      kCMTextMarkupGenericFontName_SmallCapital
 				The generic font name indicating a font with lowercase letters set as small capitals. E.g., Engravers Gothic
 */
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_Default               __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_Serif                 __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_SansSerif             __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_Monospace             __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_ProportionalSerif     __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_ProportionalSansSerif __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_MonospaceSerif        __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_MonospaceSansSerif    __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_Casual                __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_Cursive               __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_Fantasy               __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupGenericFontName_SmallCapital          __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);


/*!
    @const      kCMTextMarkupAttribute_BaseFontSizePercentageRelativeToVideoHeight
    @abstract   The base font size expressed as a percentage of the video height.
 
    @discussion Value must be a non-negative CFNumber.  This is a number holding a percentage of the height of the video frame.  For example, a value of 5 indicates that the base font size should be 5% of the height of the video.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_BaseFontSizePercentageRelativeToVideoHeight __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

/*!
    @const      kCMTextMarkupAttribute_RelativeFontSize
    @abstract   The font size expressed as a percentage of the current default font size.
 
    @discussion Value must be a non-negative CFNumber. This is a number holding a percentage
                of the size of the calculated default font size.  A value
                of 120 indicates 20% larger than the default font size. A value of 80
                indicates 80% of the default font size.  The value 100 indicates no size
                difference and is the default.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_RelativeFontSize __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_6_0);

/*!
	@const      kCMTextMarkupAttribute_VerticalLayout
	@abstract   The kind of vertical layout of the text block.

	@discussion Value must be a CFString.
 				A CFString holding one of several values indicating the progression direction for new vertical
 				lines of text. If this attribute is present, it indicates the writing direction is vertical. The 
				attribute value indicates whether new vertical text lines are added from left to right or from 
				right to left. If this attribute is missing, the writing direction is horizontal.
				
				If used, this attribute must be applied to the entire attributed string (i.e., 
                CFRangeMake(0, CFAttributedStringGetLength(...))).
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_VerticalLayout __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

/*!
	@abstract   Values for kCMTextMarkupAttribute_VerticalLayout. 
	
	@const      kCMTextVerticalLayout_LeftToRight
				Newly added vertical lines are added from the left toward the right.
				
	@const      kCMTextVerticalLayout_RightToLeft
				Newly added vertical lines are added from the right toward the left.
*/
CM_EXPORT const CFStringRef kCMTextVerticalLayout_LeftToRight __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT const CFStringRef kCMTextVerticalLayout_RightToLeft __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);


/*!
	@const      kCMTextMarkupAttribute_Alignment
	@abstract   The alignment of text in the writing direction of the first line of text.

	@discussion Value must be a CFString.
				A CFString holding one of several values indicating the alignment 
				in the writing direction of the first line of text of the cue. 
				The writing direction is indicated by the value (or absence) of 
				the kCMTextMarkupAttribute_VerticalLayout. 
				
				If this attribute is missing, the kCMTextMarkupAlignmentType_Middle value should
				be used as the default.
				
				If used, this attribute must be applied to the entire attributed string (i.e., 
                CFRangeMake(0, CFAttributedStringGetLength(...))).
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_Alignment __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

/*!
	@abstract   Values for kCMTextMarkupAttribute_Alignment. 
	
	@const      kCMTextMarkupAlignmentType_Start
				The text is visually aligned at its starting side. For horizontally written text, the alignment is left for 
				left-to-right text and right for right-to-left text. For vertical text, alignment is always at the top.

	@const      kCMTextMarkupAlignmentType_Middle
				The text is visually center-aligned (i.e., aligned between its starting and ending sides). 

	@const      kCMTextMarkupAlignmentType_End
				The text is visually aligned at its ending side. For horizontally written text, the alignment is right for 
				left-to-right text and left for right-to-left text. For vertical text, alignment is always at the bottom.

	@const      kCMTextMarkupAlignmentType_Left
				For horizontally written text, the text alignment is always visually left-aligned (i.e., left-to-right and right-to-left 
				are treated uniformly). For vertical text, this is equivalent to kCMTextMarkupAlignmentType_Start. While readers
				should be prepared to account for kCMTextMarkupAlignmentType_Left being equivalent to 
				kCMTextMarkupAlignmentType_Start for vertical text, authors are discouraged from using kCMTextMarkupAlignmentType_Left
				for vertical text.

	@const      kCMTextMarkupAlignmentType_Right
				For horizontally written text, the text alignment is always visually right-aligned (i.e., left-to-right and right-to-left 
				are treated uniformly). For vertical text, this is equivalent to kCMTextMarkupAlignmentType_End. While readers
				should be prepared to account for kCMTextMarkupAlignmentType_Right being equivalent to 
				kCMTextMarkupAlignmentType_End for vertical text, authors are discouraged from using kCMTextMarkupAlignmentType_Right
				for vertical text.
*/
CM_EXPORT const CFStringRef kCMTextMarkupAlignmentType_Start __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT const CFStringRef kCMTextMarkupAlignmentType_Middle __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT const CFStringRef kCMTextMarkupAlignmentType_End __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT const CFStringRef kCMTextMarkupAlignmentType_Left __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT const CFStringRef kCMTextMarkupAlignmentType_Right __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);


/*!
	 @const      kCMTextMarkupAttribute_TextPositionPercentageRelativeToWritingDirection
	 @abstract   The placement of the block of text specified as a percentage in the writing direction.
	 
	 @discussion Value must be a non-negative CFNumber.
				 A CFNumber expressing the position of the
				 center of the text in the writing direction as a percentage of the video dimensions in 
				 the writing direction. For horizontal cues, this is the horizontal position. 
				 For vertical, it is the vertical position. The percentage is calculated 
				 from the edge of the frame where the text begins (so for left-to-right 
				 English, it is the left edge).
				 
				 If used, this attribute must be applied to the entire attributed string (i.e., 
                 CFRangeMake(0, CFAttributedStringGetLength(...))).
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_TextPositionPercentageRelativeToWritingDirection __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0); 

/*!
	@const      kCMTextMarkupAttribute_OrthogonalLinePositionPercentageRelativeToWritingDirection
	@abstract   The placement of the block of text's first line specified as a percentage in the 
				direction orthogonal to the writing direction.

	@discussion Value must be a non-negative CFNumber.
				A CFNumber expressing the position of the center of the
				cue relative to the writing direction. The line 
				position is orthogonal (or perpendicular) to the writing direction (i.e., 
				for a horizontal writing direction, it is vertical and for a vertical writing 
				direction, is is horizontal). This attribute expresses the line position as 
				a percentage of the dimensions of the video frame in the relevant direction. 
				For example, 0% is the top of the video frame and 100% is the bottom of the 
				video frame for horizontal writing layout.
				
				If used, this attribute must be applied to the entire attributed string (i.e., 
                CFRangeMake(0, CFAttributedStringGetLength(...))).
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_OrthogonalLinePositionPercentageRelativeToWritingDirection __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
	
/*!
	@const      kCMTextMarkupAttribute_WritingDirectionSizePercentage
	@abstract   The dimension (e.g., width) of the bounding box containing the text expressed as a percentage.

	@discussion Value must be a non-negative CFNumber.
				A CFNumber expressing the width of the 
				bounding box for text layout as a percentage of the video frame's dimension
				in the writing direction. 
				For a horizontal writing direction, it is the width. For a vertical writing 
				direction, it is the horizontal writing direction.
				
				If used, this attribute must be applied to the entire attributed string (i.e., 
                CFRangeMake(0, CFAttributedStringGetLength(...))).
*/
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_WritingDirectionSizePercentage __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

/*!
	@const      kCMTextMarkupAttribute_CharacterEdgeStyle
	@abstract   Allows the setting of the style of character edges at render time.

	@discussion Value must be a CFString. This controls the shape of the edges of
				drawn characters. Set a value of something other than kCMTextMarkupEdgeStyle_None
				to draw using an alternative shape for edges of characters from the set of constants
				prefixed with "kCMTextMarkupEdgeStyle_". These correspond to text edge styles available
				with Media Accessibility preferences (see <MediaAccessibility/MACaptionAppearance.h>)
				although the values are not enumerated integers here.
				
				The absence of this attribute should be treated as though kCMTextMarkupCharacterEdgeStyle_None
				is specified.
 */
CM_EXPORT const CFStringRef kCMTextMarkupAttribute_CharacterEdgeStyle __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

/*!
	@abstract   Values for kCMTextMarkupAttribute_CharacterEdgeStyle. 

	@const      kCMTextMarkupCharacterEdgeStyle_None
				The character edge style indicating no edge style.

	@const      kCMTextMarkupCharacterEdgeStyle_Raised
				The character edge style indicating a raised edge style should be drawn.

	@const      kCMTextMarkupCharacterEdgeStyle_Depressed
				The character edge style indicating a depressed edge style should be drawn.

	@const      kCMTextMarkupCharacterEdgeStyle_Uniform
				The character edge style indicating a uniform border around the character should be drawn.

	@const      kCMTextMarkupCharacterEdgeStyle_DropShadow
				The character edge style indicating a drop shadow should be drawn.
 */
CM_EXPORT  const CFStringRef kCMTextMarkupCharacterEdgeStyle_None       __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupCharacterEdgeStyle_Raised     __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupCharacterEdgeStyle_Depressed  __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupCharacterEdgeStyle_Uniform    __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
CM_EXPORT  const CFStringRef kCMTextMarkupCharacterEdgeStyle_DropShadow __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

#pragma pack(pop)

#ifdef __cplusplus
}
#endif

#endif // CMTEXTMARKUP_H
