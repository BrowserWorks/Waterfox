/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

//! Specified color values.

use super::AllowQuirks;
#[cfg(feature = "gecko")]
use crate::gecko_bindings::structs::nscolor;
use crate::parser::{Parse, ParserContext};
use crate::values::computed::{Color as ComputedColor, Context, ToComputedValue};
use crate::values::generics::color::{GenericColorOrAuto, GenericCaretColor};
use crate::values::specified::calc::CalcNode;
use crate::values::specified::Percentage;
use cssparser::{AngleOrNumber, Color as CSSParserColor, Parser, Token, RGBA};
use cssparser::{BasicParseErrorKind, NumberOrPercentage, ParseErrorKind};
use itoa;
use std::fmt::{self, Write};
use std::io::Write as IoWrite;
use style_traits::{CssType, CssWriter, KeywordsCollectFn, ParseError, StyleParseErrorKind};
use style_traits::{SpecifiedValueInfo, ToCss, ValueParseErrorKind};

/// A restricted version of the css `color-mix()` function, which only supports
/// percentages and sRGB color-space interpolation.
///
/// https://drafts.csswg.org/css-color-5/#color-mix
#[derive(Clone, Debug, MallocSizeOf, PartialEq, ToShmem)]
#[allow(missing_docs)]
pub struct ColorMix {
    pub left: Color,
    pub left_percentage: Percentage,
    pub right: Color,
    pub right_percentage: Percentage,
}

// NOTE(emilio): Syntax is still a bit in-flux, since [1] doesn't seem
// particularly complete, and disagrees with the examples.
//
// [1]: https://github.com/w3c/csswg-drafts/commit/a4316446112f9e814668c2caff7f826f512f8fed
impl Parse for ColorMix {
    fn parse<'i, 't>(
        context: &ParserContext,
        input: &mut Parser<'i, 't>,
    ) -> Result<Self, ParseError<'i>> {
        let enabled =
            context.chrome_rules_enabled() || static_prefs::pref!("layout.css.color-mix.enabled");

        if !enabled {
            return Err(input.new_custom_error(StyleParseErrorKind::UnspecifiedError));
        }

        input.expect_function_matching("color-mix")?;

        // NOTE(emilio): This implements the syntax described here for now,
        // might need to get updated in the future.
        //
        // https://github.com/w3c/csswg-drafts/issues/6066#issuecomment-789836765
        input.parse_nested_block(|input| {
            input.expect_ident_matching("in")?;
            // TODO: support multiple interpolation spaces.
            input.expect_ident_matching("srgb")?;
            input.expect_comma()?;

            let left = Color::parse(context, input)?;
            let left_percentage = input.try_parse(|input| Percentage::parse(context, input)).ok();

            input.expect_comma()?;

            let right = Color::parse(context, input)?;
            let right_percentage = input
                .try_parse(|input| Percentage::parse(context, input))
                .unwrap_or_else(|_| {
                    Percentage::new(1.0 - left_percentage.map_or(0.5, |p| p.get()))
                });

            let left_percentage =
                left_percentage.unwrap_or_else(|| Percentage::new(1.0 - right_percentage.get()));
            Ok(ColorMix {
                left,
                left_percentage,
                right,
                right_percentage,
            })
        })
    }
}

impl ToCss for ColorMix {
    fn to_css<W>(&self, dest: &mut CssWriter<W>) -> fmt::Result
    where
        W: Write,
    {
        fn can_omit(percent: &Percentage, other: &Percentage, is_left: bool) -> bool {
            if percent.is_calc() {
                return false;
            }
            if percent.get() == 0.5 {
                return other.get() == 0.5;
            }
            if is_left {
                return false;
            }
            (1.0 - percent.get() - other.get()).abs() <= f32::EPSILON
        }

        dest.write_str("color-mix(in srgb, ")?;
        self.left.to_css(dest)?;
        if !can_omit(&self.left_percentage, &self.right_percentage, true) {
            dest.write_str(" ")?;
            self.left_percentage.to_css(dest)?;
        }
        dest.write_str(", ")?;
        self.right.to_css(dest)?;
        if !can_omit(&self.right_percentage, &self.left_percentage, false) {
            dest.write_str(" ")?;
            self.right_percentage.to_css(dest)?;
        }
        dest.write_str(")")
    }
}

/// The color scheme for a specific system color.
#[cfg(feature = "gecko")]
#[derive(Clone, Copy, Debug, MallocSizeOf, Parse, PartialEq, ToCss, ToShmem)]
#[repr(u8)]
pub enum SystemColorScheme {
    /// The default color-scheme for the document.
    #[css(skip)]
    Default,
    /// A light color scheme.
    Light,
    /// A dark color scheme.
    Dark,
}

/// Specified color value
#[derive(Clone, Debug, MallocSizeOf, PartialEq, ToShmem)]
pub enum Color {
    /// The 'currentColor' keyword
    CurrentColor,
    /// A specific RGBA color
    Numeric {
        /// Parsed RGBA color
        parsed: RGBA,
        /// Authored representation
        authored: Option<Box<str>>,
    },
    /// A complex color value from computed value
    Complex(ComputedColor),
    /// Either a system color, or a `-moz-system-color(<system-color>, light|dark)`
    /// function which allows chrome code to choose between color schemes.
    #[cfg(feature = "gecko")]
    System(SystemColor, SystemColorScheme),
    /// A color mix.
    ColorMix(Box<ColorMix>),
    /// Quirksmode-only rule for inheriting color from the body
    #[cfg(feature = "gecko")]
    InheritFromBodyQuirk,
}

/// System colors.
#[allow(missing_docs)]
#[cfg(feature = "gecko")]
#[derive(Clone, Copy, Debug, MallocSizeOf, Parse, PartialEq, ToCss, ToShmem)]
#[repr(u8)]
pub enum SystemColor {
    #[css(skip)]
    WindowBackground,
    #[css(skip)]
    WindowForeground,
    #[css(skip)]
    WidgetBackground,
    #[css(skip)]
    WidgetForeground,
    #[css(skip)]
    WidgetSelectBackground,
    #[css(skip)]
    WidgetSelectForeground,
    #[css(skip)]
    Widget3DHighlight,
    #[css(skip)]
    Widget3DShadow,
    #[css(skip)]
    TextBackground,
    #[css(skip)]
    TextForeground,
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    TextSelectBackground,
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    TextSelectForeground,
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    TextSelectBackgroundDisabled,
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    TextSelectBackgroundAttention,
    #[css(skip)]
    TextHighlightBackground,
    #[css(skip)]
    TextHighlightForeground,
    #[css(skip)]
    IMERawInputBackground,
    #[css(skip)]
    IMERawInputForeground,
    #[css(skip)]
    IMERawInputUnderline,
    #[css(skip)]
    IMESelectedRawTextBackground,
    #[css(skip)]
    IMESelectedRawTextForeground,
    #[css(skip)]
    IMESelectedRawTextUnderline,
    #[css(skip)]
    IMEConvertedTextBackground,
    #[css(skip)]
    IMEConvertedTextForeground,
    #[css(skip)]
    IMEConvertedTextUnderline,
    #[css(skip)]
    IMESelectedConvertedTextBackground,
    #[css(skip)]
    IMESelectedConvertedTextForeground,
    #[css(skip)]
    IMESelectedConvertedTextUnderline,
    #[css(skip)]
    SpellCheckerUnderline,
    #[css(skip)]
    ThemedScrollbar,
    #[css(skip)]
    ThemedScrollbarInactive,
    #[css(skip)]
    ThemedScrollbarThumb,
    #[css(skip)]
    ThemedScrollbarThumbHover,
    #[css(skip)]
    ThemedScrollbarThumbActive,
    #[css(skip)]
    ThemedScrollbarThumbInactive,
    Activeborder,
    Activecaption,
    Appworkspace,
    Background,
    Buttonface,
    Buttonhighlight,
    Buttonshadow,
    Buttontext,
    Captiontext,
    #[parse(aliases = "-moz-field")]
    Field,
    #[parse(aliases = "-moz-fieldtext")]
    Fieldtext,
    Graytext,
    Highlight,
    Highlighttext,
    Inactiveborder,
    Inactivecaption,
    Inactivecaptiontext,
    Infobackground,
    Infotext,
    Menu,
    Menutext,
    Scrollbar,
    Threeddarkshadow,
    Threedface,
    Threedhighlight,
    Threedlightshadow,
    Threedshadow,
    Window,
    Windowframe,
    Windowtext,
    MozButtondefault,
    #[parse(aliases = "-moz-default-color")]
    Canvastext,
    #[parse(aliases = "-moz-default-background-color")]
    Canvas,
    MozDialog,
    MozDialogtext,
    /// Used to highlight valid regions to drop something onto.
    MozDragtargetzone,
    /// Used for selected but not focused cell backgrounds.
    MozCellhighlight,
    /// Used for selected but not focused cell text.
    MozCellhighlighttext,
    /// Used for selected but not focused html cell backgrounds.
    MozHtmlCellhighlight,
    /// Used for selected but not focused html cell text.
    MozHtmlCellhighlighttext,
    /// Used to button text background when hovered.
    MozButtonhoverface,
    /// Used to button text color when hovered.
    MozButtonhovertext,
    /// Used for menu item backgrounds when hovered.
    MozMenuhover,
    /// Used for menu item text when hovered.
    MozMenuhovertext,
    /// Used for menubar item text.
    MozMenubartext,
    /// Used for menubar item text when hovered.
    MozMenubarhovertext,

    /// On platforms where these colors are the same as -moz-field, use
    /// -moz-fieldtext as foreground color
    MozEventreerow,
    MozOddtreerow,

    /// Used for button text when pressed.
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    MozGtkButtonactivetext,

    /// Used for button text when pressed.
    MozMacButtonactivetext,
    /// Background color of chrome toolbars in active windows.
    MozMacChromeActive,
    /// Background color of chrome toolbars in inactive windows.
    MozMacChromeInactive,
    /// Foreground color of default buttons.
    MozMacDefaultbuttontext,
    /// Ring color around text fields and lists.
    MozMacFocusring,
    /// Color used when mouse is over a menu item.
    MozMacMenuselect,
    /// Color used to do shadows on menu items.
    MozMacMenushadow,
    /// Color used to display text for disabled menu items.
    MozMacMenutextdisable,
    /// Color used to display text while mouse is over a menu item.
    MozMacMenutextselect,
    /// Text color of disabled text on toolbars.
    MozMacDisabledtoolbartext,
    /// Inactive light hightlight
    MozMacSecondaryhighlight,

    /// Font smoothing background colors needed by the Mac OS X theme, based on
    /// -moz-appearance names.
    MozMacVibrantTitlebarLight,
    MozMacVibrantTitlebarDark,
    MozMacMenupopup,
    MozMacMenuitem,
    MozMacActiveMenuitem,
    MozMacSourceList,
    MozMacSourceListSelection,
    MozMacActiveSourceListSelection,
    MozMacTooltip,

    /// Theme accent color.
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    MozAccentColor,

    /// Foreground for the accent color.
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    MozAccentColorForeground,

    /// Media rebar text.
    MozWinMediatext,
    /// Communications rebar text.
    MozWinCommunicationstext,

    /// Hyperlink color extracted from the system, not affected by the
    /// browser.anchor_color user pref.
    ///
    /// There is no OS-specified safe background color for this text, but it is
    /// used regularly within Windows and the Gnome DE on Dialog and Window
    /// colors.
    MozNativehyperlinktext,

    #[parse(aliases = "-moz-hyperlinktext")]
    Linktext,
    #[parse(aliases = "-moz-activehyperlinktext")]
    Activetext,
    #[parse(aliases = "-moz-visitedhyperlinktext")]
    Visitedtext,

    /// Combobox widgets
    MozComboboxtext,
    MozCombobox,

    /// Color of tree column headers
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    MozColheadertext,
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    MozColheaderhovertext,

    /// Color of text in the (active) titlebar.
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    MozGtkTitlebarText,

    /// Color of text in the (inactive) titlebar.
    #[parse(condition = "ParserContext::in_ua_or_chrome_sheet")]
    MozGtkTitlebarInactiveText,

    #[css(skip)]
    End, // Just for array-indexing purposes.
}

#[cfg(feature = "gecko")]
impl SystemColor {
    #[inline]
    fn compute(&self, cx: &Context, scheme: SystemColorScheme) -> ComputedColor {
        use crate::gecko_bindings::bindings;

        let prefs = cx.device().pref_sheet_prefs();

        convert_nscolor_to_computedcolor(match *self {
            SystemColor::Canvastext => prefs.mDefaultColor,
            SystemColor::Canvas => prefs.mDefaultBackgroundColor,
            SystemColor::Linktext => prefs.mLinkColor,
            SystemColor::Activetext => prefs.mActiveLinkColor,
            SystemColor::Visitedtext => prefs.mVisitedLinkColor,

            _ => {
                let color = unsafe {
                    bindings::Gecko_GetLookAndFeelSystemColor(*self as i32, cx.device().document(), scheme)
                };
                if color == bindings::NS_SAME_AS_FOREGROUND_COLOR {
                    return ComputedColor::currentcolor();
                }
                color
            }
        })
    }
}

impl From<RGBA> for Color {
    fn from(value: RGBA) -> Self {
        Color::rgba(value)
    }
}

struct ColorComponentParser<'a, 'b: 'a>(&'a ParserContext<'b>);
impl<'a, 'b: 'a, 'i: 'a> ::cssparser::ColorComponentParser<'i> for ColorComponentParser<'a, 'b> {
    type Error = StyleParseErrorKind<'i>;

    fn parse_angle_or_number<'t>(
        &self,
        input: &mut Parser<'i, 't>,
    ) -> Result<AngleOrNumber, ParseError<'i>> {
        use crate::values::specified::Angle;

        let location = input.current_source_location();
        let token = input.next()?.clone();
        match token {
            Token::Dimension {
                value, ref unit, ..
            } => {
                let angle = Angle::parse_dimension(value, unit, /* from_calc = */ false);

                let degrees = match angle {
                    Ok(angle) => angle.degrees(),
                    Err(()) => return Err(location.new_unexpected_token_error(token.clone())),
                };

                Ok(AngleOrNumber::Angle { degrees })
            },
            Token::Number { value, .. } => Ok(AngleOrNumber::Number { value }),
            Token::Function(ref name) => {
                let function = CalcNode::math_function(name, location)?;
                CalcNode::parse_angle_or_number(self.0, input, function)
            },
            t => return Err(location.new_unexpected_token_error(t)),
        }
    }

    fn parse_percentage<'t>(&self, input: &mut Parser<'i, 't>) -> Result<f32, ParseError<'i>> {
        Ok(Percentage::parse(self.0, input)?.get())
    }

    fn parse_number<'t>(&self, input: &mut Parser<'i, 't>) -> Result<f32, ParseError<'i>> {
        use crate::values::specified::Number;

        Ok(Number::parse(self.0, input)?.get())
    }

    fn parse_number_or_percentage<'t>(
        &self,
        input: &mut Parser<'i, 't>,
    ) -> Result<NumberOrPercentage, ParseError<'i>> {
        let location = input.current_source_location();

        match *input.next()? {
            Token::Number { value, .. } => Ok(NumberOrPercentage::Number { value }),
            Token::Percentage { unit_value, .. } => {
                Ok(NumberOrPercentage::Percentage { unit_value })
            },
            Token::Function(ref name) => {
                let function = CalcNode::math_function(name, location)?;
                CalcNode::parse_number_or_percentage(self.0, input, function)
            },
            ref t => return Err(location.new_unexpected_token_error(t.clone())),
        }
    }
}

fn parse_moz_system_color<'i, 't>(
    context: &ParserContext,
    input: &mut Parser<'i, 't>,
) -> Result<(SystemColor, SystemColorScheme), ParseError<'i>> {
    debug_assert!(context.chrome_rules_enabled());
    input.expect_function_matching("-moz-system-color")?;
    input.parse_nested_block(|input| {
        let color = SystemColor::parse(context, input)?;
        input.expect_comma()?;
        let scheme = SystemColorScheme::parse(input)?;
        Ok((color, scheme))
    })
}

impl Parse for Color {
    fn parse<'i, 't>(
        context: &ParserContext,
        input: &mut Parser<'i, 't>,
    ) -> Result<Self, ParseError<'i>> {
        // Currently we only store authored value for color keywords,
        // because all browsers serialize those values as keywords for
        // specified value.
        let start = input.state();
        let authored = input.expect_ident_cloned().ok();
        input.reset(&start);

        let compontent_parser = ColorComponentParser(&*context);
        match input.try_parse(|i| CSSParserColor::parse_with(&compontent_parser, i)) {
            Ok(value) => Ok(match value {
                CSSParserColor::CurrentColor => Color::CurrentColor,
                CSSParserColor::RGBA(rgba) => Color::Numeric {
                    parsed: rgba,
                    authored: authored.map(|s| s.to_ascii_lowercase().into_boxed_str()),
                },
            }),
            Err(e) => {
                #[cfg(feature = "gecko")]
                {
                    if let Ok(system) = input.try_parse(|i| SystemColor::parse(context, i)) {
                        return Ok(Color::System(system, SystemColorScheme::Default));
                    }

                    if context.chrome_rules_enabled() {
                        if let Ok((color, scheme)) = input.try_parse(|i| parse_moz_system_color(context, i)) {
                            return Ok(Color::System(color, scheme));
                        }
                    }
                }

                if let Ok(mix) = input.try_parse(|i| ColorMix::parse(context, i)) {
                    return Ok(Color::ColorMix(Box::new(mix)));
                }

                match e.kind {
                    ParseErrorKind::Basic(BasicParseErrorKind::UnexpectedToken(t)) => {
                        Err(e.location.new_custom_error(StyleParseErrorKind::ValueError(
                            ValueParseErrorKind::InvalidColor(t),
                        )))
                    },
                    _ => Err(e),
                }
            },
        }
    }
}

impl ToCss for Color {
    fn to_css<W>(&self, dest: &mut CssWriter<W>) -> fmt::Result
    where
        W: Write,
    {
        match *self {
            Color::CurrentColor => CSSParserColor::CurrentColor.to_css(dest),
            Color::Numeric {
                authored: Some(ref authored),
                ..
            } => dest.write_str(authored),
            Color::Numeric {
                parsed: ref rgba, ..
            } => rgba.to_css(dest),
            // TODO: Could represent this as a color-mix() instead.
            Color::Complex(_) => Ok(()),
            Color::ColorMix(ref mix) => mix.to_css(dest),
            #[cfg(feature = "gecko")]
            Color::System(system, scheme) => {
                if scheme == SystemColorScheme::Default {
                    system.to_css(dest)
                } else {
                    dest.write_str("-moz-system-color(")?;
                    system.to_css(dest)?;
                    dest.write_str(", ")?;
                    scheme.to_css(dest)?;
                    dest.write_char(')')
                }
            }
            #[cfg(feature = "gecko")]
            Color::InheritFromBodyQuirk => Ok(()),
        }
    }
}

/// A wrapper of cssparser::Color::parse_hash.
///
/// That function should never return CurrentColor, so it makes no sense to
/// handle a cssparser::Color here. This should really be done in cssparser
/// directly rather than here.
fn parse_hash_color(value: &[u8]) -> Result<RGBA, ()> {
    CSSParserColor::parse_hash(value).map(|color| match color {
        CSSParserColor::RGBA(rgba) => rgba,
        CSSParserColor::CurrentColor => unreachable!("parse_hash should never return currentcolor"),
    })
}

impl Color {
    /// Returns whether this color is a system color.
    pub fn is_system(&self) -> bool {
        matches!(self, Color::System(..))
    }

    /// Returns currentcolor value.
    #[inline]
    pub fn currentcolor() -> Color {
        Color::CurrentColor
    }

    /// Returns transparent value.
    #[inline]
    pub fn transparent() -> Color {
        // We should probably set authored to "transparent", but maybe it doesn't matter.
        Color::rgba(RGBA::transparent())
    }

    /// Returns a numeric RGBA color value.
    #[inline]
    pub fn rgba(rgba: RGBA) -> Self {
        Color::Numeric {
            parsed: rgba,
            authored: None,
        }
    }

    /// Parse a color, with quirks.
    ///
    /// <https://quirks.spec.whatwg.org/#the-hashless-hex-color-quirk>
    pub fn parse_quirky<'i, 't>(
        context: &ParserContext,
        input: &mut Parser<'i, 't>,
        allow_quirks: AllowQuirks,
    ) -> Result<Self, ParseError<'i>> {
        input.try_parse(|i| Self::parse(context, i)).or_else(|e| {
            if !allow_quirks.allowed(context.quirks_mode) {
                return Err(e);
            }
            Color::parse_quirky_color(input)
                .map(Color::rgba)
                .map_err(|_| e)
        })
    }

    /// Parse a <quirky-color> value.
    ///
    /// <https://quirks.spec.whatwg.org/#the-hashless-hex-color-quirk>
    fn parse_quirky_color<'i, 't>(input: &mut Parser<'i, 't>) -> Result<RGBA, ParseError<'i>> {
        let location = input.current_source_location();
        let (value, unit) = match *input.next()? {
            Token::Number {
                int_value: Some(integer),
                ..
            } => (integer, None),
            Token::Dimension {
                int_value: Some(integer),
                ref unit,
                ..
            } => (integer, Some(unit)),
            Token::Ident(ref ident) => {
                if ident.len() != 3 && ident.len() != 6 {
                    return Err(location.new_custom_error(StyleParseErrorKind::UnspecifiedError));
                }
                return parse_hash_color(ident.as_bytes()).map_err(|()| {
                    location.new_custom_error(StyleParseErrorKind::UnspecifiedError)
                });
            },
            ref t => {
                return Err(location.new_unexpected_token_error(t.clone()));
            },
        };
        if value < 0 {
            return Err(location.new_custom_error(StyleParseErrorKind::UnspecifiedError));
        }
        let length = if value <= 9 {
            1
        } else if value <= 99 {
            2
        } else if value <= 999 {
            3
        } else if value <= 9999 {
            4
        } else if value <= 99999 {
            5
        } else if value <= 999999 {
            6
        } else {
            return Err(location.new_custom_error(StyleParseErrorKind::UnspecifiedError));
        };
        let total = length + unit.as_ref().map_or(0, |d| d.len());
        if total > 6 {
            return Err(location.new_custom_error(StyleParseErrorKind::UnspecifiedError));
        }
        let mut serialization = [b'0'; 6];
        let space_padding = 6 - total;
        let mut written = space_padding;
        written += itoa::write(&mut serialization[written..], value).unwrap();
        if let Some(unit) = unit {
            written += (&mut serialization[written..])
                .write(unit.as_bytes())
                .unwrap();
        }
        debug_assert_eq!(written, 6);
        parse_hash_color(&serialization)
            .map_err(|()| location.new_custom_error(StyleParseErrorKind::UnspecifiedError))
    }
}

#[cfg(feature = "gecko")]
fn convert_nscolor_to_computedcolor(color: nscolor) -> ComputedColor {
    use crate::gecko::values::convert_nscolor_to_rgba;
    ComputedColor::rgba(convert_nscolor_to_rgba(color))
}

impl Color {
    /// Converts this Color into a ComputedColor.
    ///
    /// If `context` is `None`, and the specified color requires data from
    /// the context to resolve, then `None` is returned.
    pub fn to_computed_color(&self, context: Option<&Context>) -> Option<ComputedColor> {
        Some(match *self {
            Color::CurrentColor => ComputedColor::currentcolor(),
            Color::Numeric { ref parsed, .. } => ComputedColor::rgba(*parsed),
            Color::Complex(ref complex) => *complex,
            Color::ColorMix(ref mix) => {
                use crate::values::animated::color::Color as AnimatedColor;
                use crate::values::animated::ToAnimatedValue;

                let left = mix.left.to_computed_color(context)?.to_animated_value();
                let right = mix.right.to_computed_color(context)?.to_animated_value();
                ToAnimatedValue::from_animated_value(AnimatedColor::mix(
                    &left,
                    mix.left_percentage.get(),
                    &right,
                    mix.right_percentage.get(),
                ))
            },
            #[cfg(feature = "gecko")]
            Color::System(system, scheme) => system.compute(context?, scheme),
            #[cfg(feature = "gecko")]
            Color::InheritFromBodyQuirk => ComputedColor::rgba(context?.device().body_text_color()),
        })
    }
}

impl ToComputedValue for Color {
    type ComputedValue = ComputedColor;

    fn to_computed_value(&self, context: &Context) -> ComputedColor {
        self.to_computed_color(Some(context)).unwrap()
    }

    fn from_computed_value(computed: &ComputedColor) -> Self {
        if computed.is_numeric() {
            return Color::rgba(computed.color);
        }
        if computed.is_currentcolor() {
            return Color::currentcolor();
        }
        Color::Complex(*computed)
    }
}

/// Specified color value for `-moz-font-smoothing-background-color`.
///
/// This property does not support `currentcolor`. We could drop it at
/// parse-time, but it's not exposed to the web so it doesn't really matter.
///
/// We resolve it to `transparent` instead.
#[derive(Clone, Debug, MallocSizeOf, PartialEq, SpecifiedValueInfo, ToCss, ToShmem)]
pub struct MozFontSmoothingBackgroundColor(pub Color);

impl Parse for MozFontSmoothingBackgroundColor {
    fn parse<'i, 't>(
        context: &ParserContext,
        input: &mut Parser<'i, 't>,
    ) -> Result<Self, ParseError<'i>> {
        Color::parse(context, input).map(MozFontSmoothingBackgroundColor)
    }
}

impl ToComputedValue for MozFontSmoothingBackgroundColor {
    type ComputedValue = RGBA;

    fn to_computed_value(&self, context: &Context) -> RGBA {
        self.0
            .to_computed_value(context)
            .to_rgba(RGBA::transparent())
    }

    fn from_computed_value(computed: &RGBA) -> Self {
        MozFontSmoothingBackgroundColor(Color::rgba(*computed))
    }
}

impl SpecifiedValueInfo for Color {
    const SUPPORTED_TYPES: u8 = CssType::COLOR;

    fn collect_completion_keywords(f: KeywordsCollectFn) {
        // We are not going to insert all the color names here. Caller and
        // devtools should take care of them. XXX Actually, transparent
        // should probably be handled that way as well.
        // XXX `currentColor` should really be `currentcolor`. But let's
        // keep it consistent with the old system for now.
        f(&["rgb", "rgba", "hsl", "hsla", "currentColor", "transparent"]);
    }
}

/// Specified value for the "color" property, which resolves the `currentcolor`
/// keyword to the parent color instead of self's color.
#[cfg_attr(feature = "gecko", derive(MallocSizeOf))]
#[derive(Clone, Debug, PartialEq, SpecifiedValueInfo, ToCss, ToShmem)]
pub struct ColorPropertyValue(pub Color);

impl ToComputedValue for ColorPropertyValue {
    type ComputedValue = RGBA;

    #[inline]
    fn to_computed_value(&self, context: &Context) -> RGBA {
        self.0
            .to_computed_value(context)
            .to_rgba(context.builder.get_parent_inherited_text().clone_color())
    }

    #[inline]
    fn from_computed_value(computed: &RGBA) -> Self {
        ColorPropertyValue(Color::rgba(*computed).into())
    }
}

impl Parse for ColorPropertyValue {
    fn parse<'i, 't>(
        context: &ParserContext,
        input: &mut Parser<'i, 't>,
    ) -> Result<Self, ParseError<'i>> {
        Color::parse_quirky(context, input, AllowQuirks::Yes).map(ColorPropertyValue)
    }
}

/// auto | <color>
pub type ColorOrAuto = GenericColorOrAuto<Color>;

/// caret-color
pub type CaretColor = GenericCaretColor<Color>;

impl Parse for CaretColor {
    fn parse<'i, 't>(
        context: &ParserContext,
        input: &mut Parser<'i, 't>,
    ) -> Result<Self, ParseError<'i>> {
        ColorOrAuto::parse(context, input).map(GenericCaretColor)
    }
}
