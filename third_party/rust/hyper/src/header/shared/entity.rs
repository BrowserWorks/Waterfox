use std::str::FromStr;
use std::fmt::{self, Display};

// check that each char in the slice is either:
// 1. %x21, or
// 2. in the range %x23 to %x7E, or
// 3. in the range %x80 to %xFF
fn check_slice_validity(slice: &str) -> bool {
    slice.bytes().all(|c|
        c == b'\x21' || (c >= b'\x23' && c <= b'\x7e') | (c >= b'\x80' && c <= b'\xff'))
}

/// An entity tag, defined in [RFC7232](https://tools.ietf.org/html/rfc7232#section-2.3)
///
/// An entity tag consists of a string enclosed by two literal double quotes.
/// Preceding the first double quote is an optional weakness indicator,
/// which always looks like `W/`. Examples for valid tags are `"xyzzy"` and `W/"xyzzy"`.
///
/// # ABNF
/// ```plain
/// entity-tag = [ weak ] opaque-tag
/// weak       = %x57.2F ; "W/", case-sensitive
/// opaque-tag = DQUOTE *etagc DQUOTE
/// etagc      = %x21 / %x23-7E / obs-text
///            ; VCHAR except double quotes, plus obs-text
/// ```
///
/// # Comparison
/// To check if two entity tags are equivalent in an application always use the `strong_eq` or
/// `weak_eq` methods based on the context of the Tag. Only use `==` to check if two tags are
/// identical.
///
/// The example below shows the results for a set of entity-tag pairs and
/// both the weak and strong comparison function results:
///
/// | ETag 1  | ETag 2  | Strong Comparison | Weak Comparison |
/// |---------|---------|-------------------|-----------------|
/// | `W/"1"` | `W/"1"` | no match          | match           |
/// | `W/"1"` | `W/"2"` | no match          | no match        |
/// | `W/"1"` | `"1"`   | no match          | match           |
/// | `"1"`   | `"1"`   | match             | match           |
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct EntityTag {
    /// Weakness indicator for the tag
    pub weak: bool,
    /// The opaque string in between the DQUOTEs
    tag: String
}

impl EntityTag {
    /// Constructs a new EntityTag.
    /// # Panics
    /// If the tag contains invalid characters.
    pub fn new(weak: bool, tag: String) -> EntityTag {
        assert!(check_slice_validity(&tag), "Invalid tag: {:?}", tag);
        EntityTag { weak: weak, tag: tag }
    }

    /// Constructs a new weak EntityTag.
    /// # Panics
    /// If the tag contains invalid characters.
    pub fn weak(tag: String) -> EntityTag {
        EntityTag::new(true, tag)
    }

    /// Constructs a new strong EntityTag.
    /// # Panics
    /// If the tag contains invalid characters.
    pub fn strong(tag: String) -> EntityTag {
        EntityTag::new(false, tag)
    }

    /// Get the tag.
    pub fn tag(&self) -> &str {
        self.tag.as_ref()
    }

    /// Set the tag.
    /// # Panics
    /// If the tag contains invalid characters.
    pub fn set_tag(&mut self, tag: String) {
        assert!(check_slice_validity(&tag), "Invalid tag: {:?}", tag);
        self.tag = tag
    }

    /// For strong comparison two entity-tags are equivalent if both are not weak and their
    /// opaque-tags match character-by-character.
    pub fn strong_eq(&self, other: &EntityTag) -> bool {
        !self.weak && !other.weak && self.tag == other.tag
    }

    /// For weak comparison two entity-tags are equivalent if their
    /// opaque-tags match character-by-character, regardless of either or
    /// both being tagged as "weak".
    pub fn weak_eq(&self, other: &EntityTag) -> bool {
        self.tag == other.tag
    }

    /// The inverse of `EntityTag.strong_eq()`.
    pub fn strong_ne(&self, other: &EntityTag) -> bool {
        !self.strong_eq(other)
    }

    /// The inverse of `EntityTag.weak_eq()`.
    pub fn weak_ne(&self, other: &EntityTag) -> bool {
        !self.weak_eq(other)
    }
}

impl Display for EntityTag {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if self.weak {
            write!(f, "W/\"{}\"", self.tag)
        } else {
            write!(f, "\"{}\"", self.tag)
        }
    }
}

impl FromStr for EntityTag {
    type Err = ::Error;
    fn from_str(s: &str) -> ::Result<EntityTag> {
        let length: usize = s.len();
        let slice = &s[..];
        // Early exits if it doesn't terminate in a DQUOTE.
        if !slice.ends_with('"') {
            return Err(::Error::Header);
        }
        // The etag is weak if its first char is not a DQUOTE.
        if slice.starts_with('"') && check_slice_validity(&slice[1..length-1]) {
            // No need to check if the last char is a DQUOTE,
            // we already did that above.
            return Ok(EntityTag { weak: false, tag: slice[1..length-1].to_owned() });
        } else if slice.starts_with("W/\"") && check_slice_validity(&slice[3..length-1]) {
            return Ok(EntityTag { weak: true, tag: slice[3..length-1].to_owned() });
        }
        Err(::Error::Header)
    }
}

#[cfg(test)]
mod tests {
    use super::EntityTag;

    #[test]
    fn test_etag_parse_success() {
        // Expected success
        assert_eq!("\"foobar\"".parse::<EntityTag>().unwrap(),
            EntityTag::strong("foobar".to_owned()));
        assert_eq!("\"\"".parse::<EntityTag>().unwrap(),
            EntityTag::strong("".to_owned()));
        assert_eq!("W/\"weaktag\"".parse::<EntityTag>().unwrap(),
            EntityTag::weak("weaktag".to_owned()));
        assert_eq!("W/\"\x65\x62\"".parse::<EntityTag>().unwrap(),
            EntityTag::weak("\x65\x62".to_owned()));
        assert_eq!("W/\"\"".parse::<EntityTag>().unwrap(), EntityTag::weak("".to_owned()));
    }

    #[test]
    fn test_etag_parse_failures() {
        // Expected failures
        assert!("no-dquotes".parse::<EntityTag>().is_err());
        assert!("w/\"the-first-w-is-case-sensitive\"".parse::<EntityTag>().is_err());
        assert!("".parse::<EntityTag>().is_err());
        assert!("\"unmatched-dquotes1".parse::<EntityTag>().is_err());
        assert!("unmatched-dquotes2\"".parse::<EntityTag>().is_err());
        assert!("matched-\"dquotes\"".parse::<EntityTag>().is_err());
    }

    #[test]
    fn test_etag_fmt() {
        assert_eq!(format!("{}", EntityTag::strong("foobar".to_owned())), "\"foobar\"");
        assert_eq!(format!("{}", EntityTag::strong("".to_owned())), "\"\"");
        assert_eq!(format!("{}", EntityTag::weak("weak-etag".to_owned())), "W/\"weak-etag\"");
        assert_eq!(format!("{}", EntityTag::weak("\u{0065}".to_owned())), "W/\"\x65\"");
        assert_eq!(format!("{}", EntityTag::weak("".to_owned())), "W/\"\"");
    }

    #[test]
    fn test_cmp() {
        // | ETag 1  | ETag 2  | Strong Comparison | Weak Comparison |
        // |---------|---------|-------------------|-----------------|
        // | `W/"1"` | `W/"1"` | no match          | match           |
        // | `W/"1"` | `W/"2"` | no match          | no match        |
        // | `W/"1"` | `"1"`   | no match          | match           |
        // | `"1"`   | `"1"`   | match             | match           |
        let mut etag1 = EntityTag::weak("1".to_owned());
        let mut etag2 = EntityTag::weak("1".to_owned());
        assert!(!etag1.strong_eq(&etag2));
        assert!(etag1.weak_eq(&etag2));
        assert!(etag1.strong_ne(&etag2));
        assert!(!etag1.weak_ne(&etag2));

        etag1 = EntityTag::weak("1".to_owned());
        etag2 = EntityTag::weak("2".to_owned());
        assert!(!etag1.strong_eq(&etag2));
        assert!(!etag1.weak_eq(&etag2));
        assert!(etag1.strong_ne(&etag2));
        assert!(etag1.weak_ne(&etag2));

        etag1 = EntityTag::weak("1".to_owned());
        etag2 = EntityTag::strong("1".to_owned());
        assert!(!etag1.strong_eq(&etag2));
        assert!(etag1.weak_eq(&etag2));
        assert!(etag1.strong_ne(&etag2));
        assert!(!etag1.weak_ne(&etag2));

        etag1 = EntityTag::strong("1".to_owned());
        etag2 = EntityTag::strong("1".to_owned());
        assert!(etag1.strong_eq(&etag2));
        assert!(etag1.weak_eq(&etag2));
        assert!(!etag1.strong_ne(&etag2));
        assert!(!etag1.weak_ne(&etag2));
    }
}
