/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#[cfg(feature = "bench")]
extern crate test;

use encoding_rs;
use std::borrow::Cow::{self, Borrowed};
use rustc_serialize::json::{self, Json, ToJson};

#[cfg(feature = "bench")]
use self::test::Bencher;

use super::{Parser, Delimiter, Token, NumericValue, PercentageValue, SourceLocation, ParseError,
            DeclarationListParser, DeclarationParser, RuleListParser, BasicParseError,
            AtRuleType, AtRuleParser, QualifiedRuleParser, ParserInput,
            parse_one_declaration, parse_one_rule, parse_important,
            stylesheet_encoding, EncodingSupport,
            TokenSerializationType,
            Color, RGBA, parse_nth, UnicodeRange, ToCss};

macro_rules! JArray {
    ($($e: expr,)*) => { JArray![ $( $e ),* ] };
    ($($e: expr),*) => { Json::Array(vec!( $( $e.to_json() ),* )) }
}

fn almost_equals(a: &Json, b: &Json) -> bool {
    match (a, b) {
        (&Json::I64(a), _) => almost_equals(&Json::F64(a as f64), b),
        (&Json::U64(a), _) => almost_equals(&Json::F64(a as f64), b),
        (_, &Json::I64(b)) => almost_equals(a, &Json::F64(b as f64)),
        (_, &Json::U64(b)) => almost_equals(a, &Json::F64(b as f64)),

        (&Json::F64(a), &Json::F64(b)) => (a - b).abs() < 1e-6,

        (&Json::Boolean(a), &Json::Boolean(b)) => a == b,
        (&Json::String(ref a), &Json::String(ref b)) => a == b,
        (&Json::Array(ref a), &Json::Array(ref b)) => {
            a.len() == b.len() &&
            a.iter().zip(b.iter()).all(|(ref a, ref b)| almost_equals(*a, *b))
        },
        (&Json::Object(_), &Json::Object(_)) => panic!("Not implemented"),
        (&Json::Null, &Json::Null) => true,
        _ => false,
    }
}

fn normalize(json: &mut Json) {
    match *json {
        Json::Array(ref mut list) => {
            for item in list.iter_mut() {
                normalize(item)
            }
        }
        Json::String(ref mut s) => {
            if *s == "extra-input" || *s == "empty" {
                *s = "invalid".to_string()
            }
        }
        _ => {}
    }
}

fn assert_json_eq(results: json::Json, mut expected: json::Json, message: &str) {
    normalize(&mut expected);
    if !almost_equals(&results, &expected) {
        println!("{}", ::difference::Changeset::new(
            &results.pretty().to_string(),
            &expected.pretty().to_string(),
            "\n",
        ));
        panic!("{}", message)
    }
}

fn run_raw_json_tests<F: Fn(Json, Json) -> ()>(json_data: &str, run: F) {
    let items = match Json::from_str(json_data) {
        Ok(Json::Array(items)) => items,
        _ => panic!("Invalid JSON")
    };
    assert!(items.len() % 2 == 0);
    let mut input = None;
    for item in items.into_iter() {
        match (&input, item) {
            (&None, json_obj) => input = Some(json_obj),
            (&Some(_), expected) => {
                let input = input.take().unwrap();
                run(input, expected)
            },
        };
    }
}


fn run_json_tests<F: Fn(&mut Parser) -> Json>(json_data: &str, parse: F) {
    run_raw_json_tests(json_data, |input, expected| {
        match input {
            Json::String(input) => {
                let mut parse_input = ParserInput::new(&input);
                let result = parse(&mut Parser::new(&mut parse_input));
                assert_json_eq(result, expected, &input);
            },
            _ => panic!("Unexpected JSON")
        }
    });
}


#[test]
fn component_value_list() {
    run_json_tests(include_str!("css-parsing-tests/component_value_list.json"), |input| {
        Json::Array(component_values_to_json(input))
    });
}


#[test]
fn one_component_value() {
    run_json_tests(include_str!("css-parsing-tests/one_component_value.json"), |input| {
        let result: Result<Json, ParseError<()>> = input.parse_entirely(|input| {
            Ok(one_component_value_to_json(try!(input.next()), input))
        });
        result.unwrap_or(JArray!["error", "invalid"])
    });
}


#[test]
fn declaration_list() {
    run_json_tests(include_str!("css-parsing-tests/declaration_list.json"), |input| {
        Json::Array(DeclarationListParser::new(input, JsonParser).map(|result| {
            result.unwrap_or(JArray!["error", "invalid"])
        }).collect())
    });
}


#[test]
fn one_declaration() {
    run_json_tests(include_str!("css-parsing-tests/one_declaration.json"), |input| {
        parse_one_declaration(input, &mut JsonParser).unwrap_or(JArray!["error", "invalid"])
    });
}


#[test]
fn rule_list() {
    run_json_tests(include_str!("css-parsing-tests/rule_list.json"), |input| {
        Json::Array(RuleListParser::new_for_nested_rule(input, JsonParser).map(|result| {
            result.unwrap_or(JArray!["error", "invalid"])
        }).collect())
    });
}


#[test]
fn stylesheet() {
    run_json_tests(include_str!("css-parsing-tests/stylesheet.json"), |input| {
        Json::Array(RuleListParser::new_for_stylesheet(input, JsonParser).map(|result| {
            result.unwrap_or(JArray!["error", "invalid"])
        }).collect())
    });
}


#[test]
fn one_rule() {
    run_json_tests(include_str!("css-parsing-tests/one_rule.json"), |input| {
        parse_one_rule(input, &mut JsonParser).unwrap_or(JArray!["error", "invalid"])
    });
}


#[test]
fn stylesheet_from_bytes() {
    pub struct EncodingRs;

    impl EncodingSupport for EncodingRs {
        type Encoding = &'static encoding_rs::Encoding;

        fn utf8() -> Self::Encoding {
            encoding_rs::UTF_8
        }

        fn is_utf16_be_or_le(encoding: &Self::Encoding) -> bool {
            *encoding == encoding_rs::UTF_16LE ||
            *encoding == encoding_rs::UTF_16BE
        }

        fn from_label(ascii_label: &[u8]) -> Option<Self::Encoding> {
            encoding_rs::Encoding::for_label(ascii_label)
        }
    }


    run_raw_json_tests(include_str!("css-parsing-tests/stylesheet_bytes.json"),
                       |input, expected| {
        let map = match input {
            Json::Object(map) => map,
            _ => panic!("Unexpected JSON")
        };

        let result = {
            let css = get_string(&map, "css_bytes").unwrap().chars().map(|c| {
                assert!(c as u32 <= 0xFF);
                c as u8
            }).collect::<Vec<u8>>();
            let protocol_encoding_label = get_string(&map, "protocol_encoding")
                .map(|s| s.as_bytes());
            let environment_encoding = get_string(&map, "environment_encoding")
                .map(|s| s.as_bytes())
                .and_then(EncodingRs::from_label);

            let encoding = stylesheet_encoding::<EncodingRs>(
                &css, protocol_encoding_label, environment_encoding);
            let (css_unicode, used_encoding, _) = encoding.decode(&css);
            let mut input = ParserInput::new(&css_unicode);
            let input = &mut Parser::new(&mut input);
            let rules = RuleListParser::new_for_stylesheet(input, JsonParser)
                        .map(|result| result.unwrap_or(JArray!["error", "invalid"]))
                        .collect::<Vec<_>>();
            JArray![rules, used_encoding.name().to_lowercase()]
        };
        assert_json_eq(result, expected, &Json::Object(map).to_string());
    });

    fn get_string<'a>(map: &'a json::Object, key: &str) -> Option<&'a str> {
        match map.get(key) {
            Some(&Json::String(ref s)) => Some(s),
            Some(&Json::Null) => None,
            None => None,
            _ => panic!("Unexpected JSON"),
        }
    }
}


#[test]
fn expect_no_error_token() {
    let mut input = ParserInput::new("foo 4px ( / { !bar }");
    assert!(Parser::new(&mut input).expect_no_error_token().is_ok());
    let mut input = ParserInput::new(")");
    assert!(Parser::new(&mut input).expect_no_error_token().is_err());
    let mut input = ParserInput::new("}");
    assert!(Parser::new(&mut input).expect_no_error_token().is_err());
    let mut input = ParserInput::new("(a){]");
    assert!(Parser::new(&mut input).expect_no_error_token().is_err());
    let mut input = ParserInput::new("'\n'");
    assert!(Parser::new(&mut input).expect_no_error_token().is_err());
    let mut input = ParserInput::new("url('\n'");
    assert!(Parser::new(&mut input).expect_no_error_token().is_err());
    let mut input = ParserInput::new("url(a b)");
    assert!(Parser::new(&mut input).expect_no_error_token().is_err());
    let mut input = ParserInput::new("url(\u{7F}))");
    assert!(Parser::new(&mut input).expect_no_error_token().is_err());
}


/// https://github.com/servo/rust-cssparser/issues/71
#[test]
fn outer_block_end_consumed() {
    let mut input = ParserInput::new("(calc(true))");
    let mut input = Parser::new(&mut input);
    assert!(input.expect_parenthesis_block().is_ok());
    assert!(input.parse_nested_block(|input| {
        let result: Result<_, ParseError<()>> = input.expect_function_matching("calc")
            .map_err(|e| ParseError::Basic(e));
        result
    }).is_ok());
    println!("{:?}", input.position());
    assert!(input.next().is_err());
}

#[test]
fn unquoted_url_escaping() {
    let token = Token::UnquotedUrl("\
        \x01\x02\x03\x04\x05\x06\x07\x08\t\n\x0b\x0c\r\x0e\x0f\x10\
        \x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f \
        !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]\
        ^_`abcdefghijklmnopqrstuvwxyz{|}~\x7fé\
    ".into());
    let serialized = token.to_css_string();
    assert_eq!(serialized, "\
        url(\
            \\1 \\2 \\3 \\4 \\5 \\6 \\7 \\8 \\9 \\A \\B \\C \\D \\E \\F \\10 \
            \\11 \\12 \\13 \\14 \\15 \\16 \\17 \\18 \\19 \\1A \\1B \\1C \\1D \\1E \\1F \\20 \
            !\\\"#$%&\\'\\(\\)*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\]\
            ^_`abcdefghijklmnopqrstuvwxyz{|}~\\7F é\
        )\
        ");
    let mut input = ParserInput::new(&serialized);
    assert_eq!(Parser::new(&mut input).next(), Ok(token))
}

#[test]
fn test_expect_url() {
    fn parse<'a>(s: &mut ParserInput<'a>) -> Result<Cow<'a, str>, BasicParseError<'a>> {
        Parser::new(s).expect_url()
    }
    let mut input = ParserInput::new("url()");
    assert_eq!(parse(&mut input).unwrap(), "");
    let mut input = ParserInput::new("url( ");
    assert_eq!(parse(&mut input).unwrap(), "");
    let mut input = ParserInput::new("url( abc");
    assert_eq!(parse(&mut input).unwrap(), "abc");
    let mut input = ParserInput::new("url( abc \t)");
    assert_eq!(parse(&mut input).unwrap(), "abc");
    let mut input = ParserInput::new("url( 'abc' \t)");
    assert_eq!(parse(&mut input).unwrap(), "abc");
    let mut input = ParserInput::new("url(abc more stuff)");
    assert!(parse(&mut input).is_err());
    // The grammar at https://drafts.csswg.org/css-values/#urls plans for `<url-modifier>*`
    // at the position of "more stuff", but no such modifier is defined yet.
    let mut input = ParserInput::new("url('abc' more stuff)");
    assert!(parse(&mut input).is_err());
}


fn run_color_tests<F: Fn(Result<Color, ()>) -> Json>(json_data: &str, to_json: F) {
    run_json_tests(json_data, |input| {
        let result: Result<_, ParseError<()>> = input.parse_entirely(|i| {
            Color::parse(i).map_err(|e| ParseError::Basic(e))
        });
        to_json(result.map_err(|_| ()))
    });
}


#[test]
fn color3() {
    run_color_tests(include_str!("css-parsing-tests/color3.json"), |c| c.ok().to_json())
}


#[test]
fn color3_hsl() {
    run_color_tests(include_str!("css-parsing-tests/color3_hsl.json"), |c| c.ok().to_json())
}


/// color3_keywords.json is different: R, G and B are in 0..255 rather than 0..1
#[test]
fn color3_keywords() {
    run_color_tests(include_str!("css-parsing-tests/color3_keywords.json"), |c| c.ok().to_json())
}


#[test]
fn nth() {
    run_json_tests(include_str!("css-parsing-tests/An+B.json"), |input| {
        input.parse_entirely(|i| {
            let result: Result<_, ParseError<()>> = parse_nth(i).map_err(|e| ParseError::Basic(e));
            result
        }).ok().to_json()
    });
}

#[test]
fn unicode_range() {
    run_json_tests(include_str!("css-parsing-tests/urange.json"), |input| {
        let result: Result<_, ParseError<()>> = input.parse_comma_separated(|input| {
            let result = UnicodeRange::parse(input).ok().map(|r| (r.start, r.end));
            if input.is_exhausted() {
                Ok(result)
            } else {
                while let Ok(_) = input.next() {}
                Ok(None)
            }
        });
        result.unwrap().to_json()
    });
}


#[test]
fn serializer_not_preserving_comments() {
    serializer(false)
}

#[test]
fn serializer_preserving_comments() {
    serializer(true)
}

fn serializer(preserve_comments: bool) {
    run_json_tests(include_str!("css-parsing-tests/component_value_list.json"), |input| {
        fn write_to(mut previous_token: TokenSerializationType,
                    input: &mut Parser,
                    string: &mut String,
                    preserve_comments: bool) {
            while let Ok(token) = if preserve_comments {
                input.next_including_whitespace_and_comments()
            } else {
                input.next_including_whitespace()
            } {
                let token_type = token.serialization_type();
                if !preserve_comments && previous_token.needs_separator_when_before(token_type) {
                    string.push_str("/**/")
                }
                previous_token = token_type;
                token.to_css(string).unwrap();
                let closing_token = match token {
                    Token::Function(_) | Token::ParenthesisBlock => Some(Token::CloseParenthesis),
                    Token::SquareBracketBlock => Some(Token::CloseSquareBracket),
                    Token::CurlyBracketBlock => Some(Token::CloseCurlyBracket),
                    _ => None
                };
                if let Some(closing_token) = closing_token {
                    let result: Result<_, ParseError<()>> = input.parse_nested_block(|input| {
                        write_to(previous_token, input, string, preserve_comments);
                        Ok(())
                    });
                    result.unwrap();
                    closing_token.to_css(string).unwrap();
                }
            }
        }
        let mut serialized = String::new();
        write_to(TokenSerializationType::nothing(), input, &mut serialized, preserve_comments);
        let mut input = ParserInput::new(&serialized);
        let parser = &mut Parser::new(&mut input);
        Json::Array(component_values_to_json(parser))
    });
}

#[test]
fn serialize_current_color() {
    let c = Color::CurrentColor;
    assert!(c.to_css_string() == "currentColor");
}

#[test]
fn serialize_rgb_full_alpha() {
    let c = Color::RGBA(RGBA::new(255, 230, 204, 255));
    assert_eq!(c.to_css_string(), "rgb(255, 230, 204)");
}

#[test]
fn serialize_rgba() {
    let c = Color::RGBA(RGBA::new(26, 51, 77, 32));
    assert_eq!(c.to_css_string(), "rgba(26, 51, 77, 0.125)");
}

#[test]
fn serialize_rgba_two_digit_float_if_roundtrips() {
    let c = Color::RGBA(RGBA::from_floats(0., 0., 0., 0.5));
    assert_eq!(c.to_css_string(), "rgba(0, 0, 0, 0.5)");
}

#[test]
fn line_numbers() {
    let mut input = ParserInput::new("foo bar\nbaz\r\n\n\"a\\\r\nb\"");
    let mut input = Parser::new(&mut input);
    assert_eq!(input.current_source_location(), SourceLocation { line: 1, column: 1 });
    assert_eq!(input.next_including_whitespace(), Ok(Token::Ident(Borrowed("foo"))));
    assert_eq!(input.current_source_location(), SourceLocation { line: 1, column: 4 });
    assert_eq!(input.next_including_whitespace(), Ok(Token::WhiteSpace(" ")));
    assert_eq!(input.current_source_location(), SourceLocation { line: 1, column: 5 });
    assert_eq!(input.next_including_whitespace(), Ok(Token::Ident(Borrowed("bar"))));
    assert_eq!(input.current_source_location(), SourceLocation { line: 1, column: 8 });
    assert_eq!(input.next_including_whitespace(), Ok(Token::WhiteSpace("\n")));
    assert_eq!(input.current_source_location(), SourceLocation { line: 2, column: 1 });
    assert_eq!(input.next_including_whitespace(), Ok(Token::Ident(Borrowed("baz"))));
    assert_eq!(input.current_source_location(), SourceLocation { line: 2, column: 4 });
    let position = input.position();

    assert_eq!(input.next_including_whitespace(), Ok(Token::WhiteSpace("\r\n\n")));
    assert_eq!(input.current_source_location(), SourceLocation { line: 4, column: 1 });

    assert_eq!(input.source_location(position), SourceLocation { line: 2, column: 4 });

    assert_eq!(input.next_including_whitespace(), Ok(Token::QuotedString(Borrowed("ab"))));
    assert_eq!(input.current_source_location(), SourceLocation { line: 5, column: 3 });
    assert!(input.next_including_whitespace().is_err());
}

#[test]
fn overflow() {
    use std::iter::repeat;
    use std::f32;

    let css = r"
         2147483646
         2147483647
         2147483648
         10000000000000
         1000000000000000000000000000000000000000
         1{309 zeros}

         -2147483647
         -2147483648
         -2147483649
         -10000000000000
         -1000000000000000000000000000000000000000
         -1{309 zeros}

         3.30282347e+38
         3.40282347e+38
         3.402824e+38

         -3.30282347e+38
         -3.40282347e+38
         -3.402824e+38

    ".replace("{309 zeros}", &repeat('0').take(309).collect::<String>());
    let mut input = ParserInput::new(&css);
    let mut input = Parser::new(&mut input);

    assert_eq!(input.expect_integer(), Ok(2147483646));
    assert_eq!(input.expect_integer(), Ok(2147483647));
    assert_eq!(input.expect_integer(), Ok(2147483647)); // Clamp on overflow
    assert_eq!(input.expect_integer(), Ok(2147483647));
    assert_eq!(input.expect_integer(), Ok(2147483647));
    assert_eq!(input.expect_integer(), Ok(2147483647));

    assert_eq!(input.expect_integer(), Ok(-2147483647));
    assert_eq!(input.expect_integer(), Ok(-2147483648));
    assert_eq!(input.expect_integer(), Ok(-2147483648)); // Clamp on overflow
    assert_eq!(input.expect_integer(), Ok(-2147483648));
    assert_eq!(input.expect_integer(), Ok(-2147483648));
    assert_eq!(input.expect_integer(), Ok(-2147483648));

    assert_eq!(input.expect_number(), Ok(3.30282347e+38));
    assert_eq!(input.expect_number(), Ok(f32::MAX));
    assert_eq!(input.expect_number(), Ok(f32::INFINITY));
    assert!(f32::MAX != f32::INFINITY);

    assert_eq!(input.expect_number(), Ok(-3.30282347e+38));
    assert_eq!(input.expect_number(), Ok(f32::MIN));
    assert_eq!(input.expect_number(), Ok(f32::NEG_INFINITY));
    assert!(f32::MIN != f32::NEG_INFINITY);
}

#[test]
fn line_delimited() {
    let mut input = ParserInput::new(" { foo ; bar } baz;,");
    let mut input = Parser::new(&mut input);
    assert_eq!(input.next(), Ok(Token::CurlyBracketBlock));
    assert!({
        let result: Result<_, ParseError<()>> = input.parse_until_after(Delimiter::Semicolon, |_| Ok(42));
        result
    }.is_err());
    assert_eq!(input.next(), Ok(Token::Comma));
    assert!(input.next().is_err());
}

#[test]
fn identifier_serialization() {
    // Null bytes
    assert_eq!(Token::Ident("\0".into()).to_css_string(), "\u{FFFD}");
    assert_eq!(Token::Ident("a\0".into()).to_css_string(), "a\u{FFFD}");
    assert_eq!(Token::Ident("\0b".into()).to_css_string(), "\u{FFFD}b");
    assert_eq!(Token::Ident("a\0b".into()).to_css_string(), "a\u{FFFD}b");

    // Replacement character
    assert_eq!(Token::Ident("\u{FFFD}".into()).to_css_string(), "\u{FFFD}");
    assert_eq!(Token::Ident("a\u{FFFD}".into()).to_css_string(), "a\u{FFFD}");
    assert_eq!(Token::Ident("\u{FFFD}b".into()).to_css_string(), "\u{FFFD}b");
    assert_eq!(Token::Ident("a\u{FFFD}b".into()).to_css_string(), "a\u{FFFD}b");

    // Number prefix
    assert_eq!(Token::Ident("0a".into()).to_css_string(), "\\30 a");
    assert_eq!(Token::Ident("1a".into()).to_css_string(), "\\31 a");
    assert_eq!(Token::Ident("2a".into()).to_css_string(), "\\32 a");
    assert_eq!(Token::Ident("3a".into()).to_css_string(), "\\33 a");
    assert_eq!(Token::Ident("4a".into()).to_css_string(), "\\34 a");
    assert_eq!(Token::Ident("5a".into()).to_css_string(), "\\35 a");
    assert_eq!(Token::Ident("6a".into()).to_css_string(), "\\36 a");
    assert_eq!(Token::Ident("7a".into()).to_css_string(), "\\37 a");
    assert_eq!(Token::Ident("8a".into()).to_css_string(), "\\38 a");
    assert_eq!(Token::Ident("9a".into()).to_css_string(), "\\39 a");

    // Letter number prefix
    assert_eq!(Token::Ident("a0b".into()).to_css_string(), "a0b");
    assert_eq!(Token::Ident("a1b".into()).to_css_string(), "a1b");
    assert_eq!(Token::Ident("a2b".into()).to_css_string(), "a2b");
    assert_eq!(Token::Ident("a3b".into()).to_css_string(), "a3b");
    assert_eq!(Token::Ident("a4b".into()).to_css_string(), "a4b");
    assert_eq!(Token::Ident("a5b".into()).to_css_string(), "a5b");
    assert_eq!(Token::Ident("a6b".into()).to_css_string(), "a6b");
    assert_eq!(Token::Ident("a7b".into()).to_css_string(), "a7b");
    assert_eq!(Token::Ident("a8b".into()).to_css_string(), "a8b");
    assert_eq!(Token::Ident("a9b".into()).to_css_string(), "a9b");

    // Dash number prefix
    assert_eq!(Token::Ident("-0a".into()).to_css_string(), "-\\30 a");
    assert_eq!(Token::Ident("-1a".into()).to_css_string(), "-\\31 a");
    assert_eq!(Token::Ident("-2a".into()).to_css_string(), "-\\32 a");
    assert_eq!(Token::Ident("-3a".into()).to_css_string(), "-\\33 a");
    assert_eq!(Token::Ident("-4a".into()).to_css_string(), "-\\34 a");
    assert_eq!(Token::Ident("-5a".into()).to_css_string(), "-\\35 a");
    assert_eq!(Token::Ident("-6a".into()).to_css_string(), "-\\36 a");
    assert_eq!(Token::Ident("-7a".into()).to_css_string(), "-\\37 a");
    assert_eq!(Token::Ident("-8a".into()).to_css_string(), "-\\38 a");
    assert_eq!(Token::Ident("-9a".into()).to_css_string(), "-\\39 a");

    // Double dash prefix
    assert_eq!(Token::Ident("--a".into()).to_css_string(), "--a");

    // Various tests
    assert_eq!(Token::Ident("\x01\x02\x1E\x1F".into()).to_css_string(), "\\1 \\2 \\1e \\1f ");
    assert_eq!(Token::Ident("\u{0080}\x2D\x5F\u{00A9}".into()).to_css_string(), "\u{0080}\x2D\x5F\u{00A9}");
    assert_eq!(Token::Ident("\x7F\u{0080}\u{0081}\u{0082}\u{0083}\u{0084}\u{0085}\u{0086}\u{0087}\u{0088}\u{0089}\
        \u{008A}\u{008B}\u{008C}\u{008D}\u{008E}\u{008F}\u{0090}\u{0091}\u{0092}\u{0093}\u{0094}\u{0095}\u{0096}\
        \u{0097}\u{0098}\u{0099}\u{009A}\u{009B}\u{009C}\u{009D}\u{009E}\u{009F}".into()).to_css_string(),
        "\\7f \u{0080}\u{0081}\u{0082}\u{0083}\u{0084}\u{0085}\u{0086}\u{0087}\u{0088}\u{0089}\u{008A}\u{008B}\u{008C}\
        \u{008D}\u{008E}\u{008F}\u{0090}\u{0091}\u{0092}\u{0093}\u{0094}\u{0095}\u{0096}\u{0097}\u{0098}\u{0099}\
        \u{009A}\u{009B}\u{009C}\u{009D}\u{009E}\u{009F}");
    assert_eq!(Token::Ident("\u{00A0}\u{00A1}\u{00A2}".into()).to_css_string(), "\u{00A0}\u{00A1}\u{00A2}");
    assert_eq!(Token::Ident("a0123456789b".into()).to_css_string(), "a0123456789b");
    assert_eq!(Token::Ident("abcdefghijklmnopqrstuvwxyz".into()).to_css_string(), "abcdefghijklmnopqrstuvwxyz");
    assert_eq!(Token::Ident("ABCDEFGHIJKLMNOPQRSTUVWXYZ".into()).to_css_string(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    assert_eq!(Token::Ident("\x20\x21\x78\x79".into()).to_css_string(), "\\ \\!xy");

    // astral symbol (U+1D306 TETRAGRAM FOR CENTRE)
    assert_eq!(Token::Ident("\u{1D306}".into()).to_css_string(), "\u{1D306}");
}

impl ToJson for Color {
    fn to_json(&self) -> json::Json {
        match *self {
            Color::RGBA(ref rgba) => {
                [rgba.red, rgba.green, rgba.blue, rgba.alpha].to_json()
            },
            Color::CurrentColor => "currentColor".to_json(),
        }
    }
}

#[cfg(feature = "bench")]
const BACKGROUND_IMAGE: &'static str = include_str!("big-data-url.css");

#[cfg(feature = "bench")]
#[bench]
fn unquoted_url(b: &mut Bencher) {
    b.iter(|| {
        let mut input = ParserInput::new(BACKGROUND_IMAGE);
        let mut input = Parser::new(&mut input);
        input.look_for_var_functions();

        let result = input.try(|input| input.expect_url());

        assert!(result.is_ok());

        input.seen_var_functions();
        (result.is_ok(), input.seen_var_functions())
    })
}


#[cfg(feature = "bench")]
#[bench]
fn numeric(b: &mut Bencher) {
    b.iter(|| {
        for _ in 0..1000000 {
            let mut input = ParserInput::new("10px");
            let mut input = Parser::new(&mut input);
            let _ = test::black_box(input.next());
        }
    })
}

struct JsonParser;

#[test]
fn no_stack_overflow_multiple_nested_blocks() {
    let mut input: String = "{{".into();
    for _ in 0..20 {
        let dup = input.clone();
        input.push_str(&dup);
    }
    let mut input = ParserInput::new(&input);
    let mut input = Parser::new(&mut input);
    while let Ok(..) = input.next() { }
}

impl<'i> DeclarationParser<'i> for JsonParser {
    type Declaration = Json;
    type Error = ();

    fn parse_value<'t>(&mut self, name: Cow<'i, str>, input: &mut Parser<'i, 't>)
                       -> Result<Json, ParseError<'i, ()>> {
        let mut value = vec![];
        let mut important = false;
        loop {
            let start_position = input.position();
            if let Ok(mut token) = input.next_including_whitespace() {
                // Hack to deal with css-parsing-tests assuming that
                // `!important` in the middle of a declaration value is OK.
                // This can never happen per spec
                // (even CSS Variables forbid top-level `!`)
                if token == Token::Delim('!') {
                    input.reset(start_position);
                    if parse_important(input).is_ok() {
                        if input.is_exhausted() {
                            important = true;
                            break
                        }
                    }
                    input.reset(start_position);
                    token = input.next_including_whitespace().unwrap();
                }
                value.push(one_component_value_to_json(token, input));
            } else {
                break
            }
        }
        Ok(JArray![
            "declaration",
            name,
            value,
            important,
        ])
    }
}

impl<'i> AtRuleParser<'i> for JsonParser {
    type Prelude = Vec<Json>;
    type AtRule = Json;
    type Error = ();

    fn parse_prelude<'t>(&mut self, name: Cow<'i, str>, input: &mut Parser<'i, 't>)
                         -> Result<AtRuleType<Vec<Json>, Json>, ParseError<'i, ()>> {
        Ok(AtRuleType::OptionalBlock(vec![
            "at-rule".to_json(),
            name.to_json(),
            Json::Array(component_values_to_json(input)),
        ]))
    }

    fn parse_block<'t>(&mut self, mut prelude: Vec<Json>, input: &mut Parser<'i, 't>)
                       -> Result<Json, ParseError<'i, ()>> {
        prelude.push(Json::Array(component_values_to_json(input)));
        Ok(Json::Array(prelude))
    }

    fn rule_without_block(&mut self, mut prelude: Vec<Json>) -> Json {
        prelude.push(Json::Null);
        Json::Array(prelude)
    }
}

impl<'i> QualifiedRuleParser<'i> for JsonParser {
    type Prelude = Vec<Json>;
    type QualifiedRule = Json;
    type Error = ();

    fn parse_prelude<'t>(&mut self, input: &mut Parser<'i, 't>) -> Result<Vec<Json>, ParseError<'i, ()>> {
        Ok(component_values_to_json(input))
    }

    fn parse_block<'t>(&mut self, prelude: Vec<Json>, input: &mut Parser<'i, 't>)
                       -> Result<Json, ParseError<'i, ()>> {
        Ok(JArray![
            "qualified rule",
            prelude,
            component_values_to_json(input),
        ])
    }
}

fn component_values_to_json(input: &mut Parser) -> Vec<Json> {
    let mut values = vec![];
    while let Ok(token) = input.next_including_whitespace() {
        values.push(one_component_value_to_json(token, input));
    }
    values
}

fn one_component_value_to_json(token: Token, input: &mut Parser) -> Json {
    fn numeric(value: NumericValue) -> Vec<json::Json> {
        vec![
            Token::Number(value).to_css_string().to_json(),
            match value.int_value { Some(i) => i.to_json(), None => value.value.to_json() },
            match value.int_value { Some(_) => "integer", None => "number" }.to_json()
        ]
    }

    fn nested(input: &mut Parser) -> Vec<Json> {
        let result: Result<_, ParseError<()>> = input.parse_nested_block(|input| {
            Ok(component_values_to_json(input))
        });
        result.unwrap()
    }

    match token {
        Token::Ident(value) => JArray!["ident", value],
        Token::AtKeyword(value) => JArray!["at-keyword", value],
        Token::Hash(value) => JArray!["hash", value, "unrestricted"],
        Token::IDHash(value) => JArray!["hash", value, "id"],
        Token::QuotedString(value) => JArray!["string", value],
        Token::UnquotedUrl(value) => JArray!["url", value],
        Token::Delim('\\') => "\\".to_json(),
        Token::Delim(value) => value.to_string().to_json(),

        Token::Number(value) => Json::Array({
            let mut v = vec!["number".to_json()];
            v.extend(numeric(value));
            v
        }),
        Token::Percentage(PercentageValue { unit_value, int_value, has_sign }) => Json::Array({
            let mut v = vec!["percentage".to_json()];
            v.extend(numeric(NumericValue {
                value: unit_value * 100.,
                int_value: int_value,
                has_sign: has_sign,
            }));
            v
        }),
        Token::Dimension(value, unit) => Json::Array({
            let mut v = vec!["dimension".to_json()];
            v.extend(numeric(value));
            v.push(unit.to_json());
            v
        }),

        Token::WhiteSpace(_) => " ".to_json(),
        Token::Comment(_) => "/**/".to_json(),
        Token::Colon => ":".to_json(),
        Token::Semicolon => ";".to_json(),
        Token::Comma => ",".to_json(),
        Token::IncludeMatch => "~=".to_json(),
        Token::DashMatch => "|=".to_json(),
        Token::PrefixMatch => "^=".to_json(),
        Token::SuffixMatch => "$=".to_json(),
        Token::SubstringMatch => "*=".to_json(),
        Token::Column => "||".to_json(),
        Token::CDO => "<!--".to_json(),
        Token::CDC => "-->".to_json(),

        Token::Function(name) => Json::Array({
            let mut v = vec!["function".to_json(), name.to_json()];
            v.extend(nested(input));
            v
        }),
        Token::ParenthesisBlock => Json::Array({
            let mut v = vec!["()".to_json()];
            v.extend(nested(input));
            v
        }),
        Token::SquareBracketBlock => Json::Array({
            let mut v = vec!["[]".to_json()];
            v.extend(nested(input));
            v
        }),
        Token::CurlyBracketBlock => Json::Array({
            let mut v = vec!["{}".to_json()];
            v.extend(nested(input));
            v
        }),
        Token::BadUrl => JArray!["error", "bad-url"],
        Token::BadString => JArray!["error", "bad-string"],
        Token::CloseParenthesis => JArray!["error", ")"],
        Token::CloseSquareBracket => JArray!["error", "]"],
        Token::CloseCurlyBracket => JArray!["error", "}"],
    }
}

/// A previous version of procedural-masquerade had a bug where it
/// would normalize consecutive whitespace to a single space,
/// including in string literals.
#[test]
fn procedural_masquerade_whitespace() {
    ascii_case_insensitive_phf_map! {
        map -> () = {
            "  \t\n" => ()
        }
    }
    assert_eq!(map("  \t\n"), Some(&()));
    assert_eq!(map(" "), None);

    match_ignore_ascii_case! { "  \t\n",
        " " => panic!("1"),
        "  \t\n" => {},
        _ => panic!("2"),
    }

    match_ignore_ascii_case! { " ",
        "  \t\n" => panic!("3"),
        " " => {},
        _ => panic!("4"),
    }
}
