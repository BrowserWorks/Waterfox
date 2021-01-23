use std::str;

use find_byte::find_byte;

use re_bytes;
use re_unicode;

pub fn expand_str(
    caps: &re_unicode::Captures,
    mut replacement: &str,
    dst: &mut String,
) {
    while !replacement.is_empty() {
        match find_byte(b'$', replacement.as_bytes()) {
            None => break,
            Some(i) => {
                dst.push_str(&replacement[..i]);
                replacement = &replacement[i..];
            }
        }
        if replacement.as_bytes().get(1).map_or(false, |&b| b == b'$') {
            dst.push_str("$");
            replacement = &replacement[2..];
            continue;
        }
        debug_assert!(!replacement.is_empty());
        let cap_ref = match find_cap_ref(replacement) {
            Some(cap_ref) => cap_ref,
            None => {
                dst.push_str("$");
                replacement = &replacement[1..];
                continue;
            }
        };
        replacement = &replacement[cap_ref.end..];
        match cap_ref.cap {
            Ref::Number(i) => {
                dst.push_str(caps.get(i).map(|m| m.as_str()).unwrap_or(""));
            }
            Ref::Named(name) => {
                dst.push_str(
                    caps.name(name).map(|m| m.as_str()).unwrap_or(""),
                );
            }
        }
    }
    dst.push_str(replacement);
}

pub fn expand_bytes(
    caps: &re_bytes::Captures,
    mut replacement: &[u8],
    dst: &mut Vec<u8>,
) {
    while !replacement.is_empty() {
        match find_byte(b'$', replacement) {
            None => break,
            Some(i) => {
                dst.extend(&replacement[..i]);
                replacement = &replacement[i..];
            }
        }
        if replacement.get(1).map_or(false, |&b| b == b'$') {
            dst.push(b'$');
            replacement = &replacement[2..];
            continue;
        }
        debug_assert!(!replacement.is_empty());
        let cap_ref = match find_cap_ref(replacement) {
            Some(cap_ref) => cap_ref,
            None => {
                dst.push(b'$');
                replacement = &replacement[1..];
                continue;
            }
        };
        replacement = &replacement[cap_ref.end..];
        match cap_ref.cap {
            Ref::Number(i) => {
                dst.extend(caps.get(i).map(|m| m.as_bytes()).unwrap_or(b""));
            }
            Ref::Named(name) => {
                dst.extend(
                    caps.name(name).map(|m| m.as_bytes()).unwrap_or(b""),
                );
            }
        }
    }
    dst.extend(replacement);
}

/// `CaptureRef` represents a reference to a capture group inside some text.
/// The reference is either a capture group name or a number.
///
/// It is also tagged with the position in the text following the
/// capture reference.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct CaptureRef<'a> {
    cap: Ref<'a>,
    end: usize,
}

/// A reference to a capture group in some text.
///
/// e.g., `$2`, `$foo`, `${foo}`.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum Ref<'a> {
    Named(&'a str),
    Number(usize),
}

impl<'a> From<&'a str> for Ref<'a> {
    fn from(x: &'a str) -> Ref<'a> {
        Ref::Named(x)
    }
}

impl From<usize> for Ref<'static> {
    fn from(x: usize) -> Ref<'static> {
        Ref::Number(x)
    }
}

/// Parses a possible reference to a capture group name in the given text,
/// starting at the beginning of `replacement`.
///
/// If no such valid reference could be found, None is returned.
fn find_cap_ref<T: ?Sized + AsRef<[u8]>>(
    replacement: &T,
) -> Option<CaptureRef> {
    let mut i = 0;
    let rep: &[u8] = replacement.as_ref();
    if rep.len() <= 1 || rep[0] != b'$' {
        return None;
    }
    let mut brace = false;
    i += 1;
    if rep[i] == b'{' {
        brace = true;
        i += 1;
    }
    let mut cap_end = i;
    while rep.get(cap_end).map_or(false, is_valid_cap_letter) {
        cap_end += 1;
    }
    if cap_end == i {
        return None;
    }
    // We just verified that the range 0..cap_end is valid ASCII, so it must
    // therefore be valid UTF-8. If we really cared, we could avoid this UTF-8
    // check with either unsafe or by parsing the number straight from &[u8].
    let cap =
        str::from_utf8(&rep[i..cap_end]).expect("valid UTF-8 capture name");
    if brace {
        if !rep.get(cap_end).map_or(false, |&b| b == b'}') {
            return None;
        }
        cap_end += 1;
    }
    Some(CaptureRef {
        cap: match cap.parse::<u32>() {
            Ok(i) => Ref::Number(i as usize),
            Err(_) => Ref::Named(cap),
        },
        end: cap_end,
    })
}

/// Returns true if and only if the given byte is allowed in a capture name.
fn is_valid_cap_letter(b: &u8) -> bool {
    match *b {
        b'0'..=b'9' | b'a'..=b'z' | b'A'..=b'Z' | b'_' => true,
        _ => false,
    }
}

#[cfg(test)]
mod tests {
    use super::{find_cap_ref, CaptureRef};

    macro_rules! find {
        ($name:ident, $text:expr) => {
            #[test]
            fn $name() {
                assert_eq!(None, find_cap_ref($text));
            }
        };
        ($name:ident, $text:expr, $capref:expr) => {
            #[test]
            fn $name() {
                assert_eq!(Some($capref), find_cap_ref($text));
            }
        };
    }

    macro_rules! c {
        ($name_or_number:expr, $pos:expr) => {
            CaptureRef { cap: $name_or_number.into(), end: $pos }
        };
    }

    find!(find_cap_ref1, "$foo", c!("foo", 4));
    find!(find_cap_ref2, "${foo}", c!("foo", 6));
    find!(find_cap_ref3, "$0", c!(0, 2));
    find!(find_cap_ref4, "$5", c!(5, 2));
    find!(find_cap_ref5, "$10", c!(10, 3));
    // see https://github.com/rust-lang/regex/pull/585 for more on characters following numbers
    find!(find_cap_ref6, "$42a", c!("42a", 4));
    find!(find_cap_ref7, "${42}a", c!(42, 5));
    find!(find_cap_ref8, "${42");
    find!(find_cap_ref9, "${42 ");
    find!(find_cap_ref10, " $0 ");
    find!(find_cap_ref11, "$");
    find!(find_cap_ref12, " ");
    find!(find_cap_ref13, "");
    find!(find_cap_ref14, "$1-$2", c!(1, 2));
    find!(find_cap_ref15, "$1_$2", c!("1_", 3));
    find!(find_cap_ref16, "$x-$y", c!("x", 2));
    find!(find_cap_ref17, "$x_$y", c!("x_", 3));
}
