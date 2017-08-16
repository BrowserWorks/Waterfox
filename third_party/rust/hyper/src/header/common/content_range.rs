use std::fmt::{self, Display};
use std::str::FromStr;

header! {
    /// `Content-Range` header, defined in
    /// [RFC7233](http://tools.ietf.org/html/rfc7233#section-4.2)
    (ContentRange, "Content-Range") => [ContentRangeSpec]

    test_content_range {
        test_header!(test_bytes,
            vec![b"bytes 0-499/500"],
            Some(ContentRange(ContentRangeSpec::Bytes {
                range: Some((0, 499)),
                instance_length: Some(500)
            })));

        test_header!(test_bytes_unknown_len,
            vec![b"bytes 0-499/*"],
            Some(ContentRange(ContentRangeSpec::Bytes {
                range: Some((0, 499)),
                instance_length: None
            })));

        test_header!(test_bytes_unknown_range,
            vec![b"bytes */500"],
            Some(ContentRange(ContentRangeSpec::Bytes {
                range: None,
                instance_length: Some(500)
            })));

        test_header!(test_unregistered,
            vec![b"seconds 1-2"],
            Some(ContentRange(ContentRangeSpec::Unregistered {
                unit: "seconds".to_owned(),
                resp: "1-2".to_owned()
            })));

        test_header!(test_no_len,
            vec![b"bytes 0-499"],
            None::<ContentRange>);

        test_header!(test_only_unit,
            vec![b"bytes"],
            None::<ContentRange>);

        test_header!(test_end_less_than_start,
            vec![b"bytes 499-0/500"],
            None::<ContentRange>);

        test_header!(test_blank,
            vec![b""],
            None::<ContentRange>);

        test_header!(test_bytes_many_spaces,
            vec![b"bytes 1-2/500 3"],
            None::<ContentRange>);

        test_header!(test_bytes_many_slashes,
            vec![b"bytes 1-2/500/600"],
            None::<ContentRange>);

        test_header!(test_bytes_many_dashes,
            vec![b"bytes 1-2-3/500"],
            None::<ContentRange>);

    }
}


/// Content-Range, described in [RFC7233](https://tools.ietf.org/html/rfc7233#section-4.2)
///
/// # ABNF
/// ```plain
/// Content-Range       = byte-content-range
///                     / other-content-range
///
/// byte-content-range  = bytes-unit SP
///                       ( byte-range-resp / unsatisfied-range )
///
/// byte-range-resp     = byte-range "/" ( complete-length / "*" )
/// byte-range          = first-byte-pos "-" last-byte-pos
/// unsatisfied-range   = "*/" complete-length
///
/// complete-length     = 1*DIGIT
///
/// other-content-range = other-range-unit SP other-range-resp
/// other-range-resp    = *CHAR
/// ```
#[derive(PartialEq, Clone, Debug)]
pub enum ContentRangeSpec {
    /// Byte range
    Bytes {
        /// First and last bytes of the range, omitted if request could not be
        /// satisfied
        range: Option<(u64, u64)>,

        /// Total length of the instance, can be omitted if unknown
        instance_length: Option<u64>
    },

    /// Custom range, with unit not registered at IANA
    Unregistered {
        /// other-range-unit
        unit: String,

        /// other-range-resp
        resp: String
    }
}

fn split_in_two(s: &str, separator: char) -> Option<(&str, &str)> {
    let mut iter = s.splitn(2, separator);
    match (iter.next(), iter.next()) {
        (Some(a), Some(b)) => Some((a, b)),
        _ => None
    }
}

impl FromStr for ContentRangeSpec {
    type Err = ::Error;

    fn from_str(s: &str) -> ::Result<Self> {
        let res = match split_in_two(s, ' ') {
            Some(("bytes", resp)) => {
                let (range, instance_length) = try!(split_in_two(resp, '/').ok_or(::Error::Header));

                let instance_length = if instance_length == "*" {
                    None
                } else {
                    Some(try!(instance_length.parse().map_err(|_| ::Error::Header)))
                };

                let range = if range == "*" {
                    None
                } else {
                    let (first_byte, last_byte) = try!(split_in_two(range, '-').ok_or(::Error::Header));
                    let first_byte = try!(first_byte.parse().map_err(|_| ::Error::Header));
                    let last_byte = try!(last_byte.parse().map_err(|_| ::Error::Header));
                    if last_byte < first_byte {
                        return Err(::Error::Header);
                    }
                    Some((first_byte, last_byte))
                };

                ContentRangeSpec::Bytes {
                    range: range,
                    instance_length: instance_length
                }
            }
            Some((unit, resp)) => {
                ContentRangeSpec::Unregistered {
                    unit: unit.to_owned(),
                    resp: resp.to_owned()
                }
            }
            _ => return Err(::Error::Header)
        };
        Ok(res)
    }
}

impl Display for ContentRangeSpec {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            ContentRangeSpec::Bytes { range, instance_length } => {
                try!(f.write_str("bytes "));
                match range {
                    Some((first_byte, last_byte)) => {
                        try!(write!(f, "{}-{}", first_byte, last_byte));
                    },
                    None => {
                        try!(f.write_str("*"));
                    }
                };
                try!(f.write_str("/"));
                if let Some(v) = instance_length {
                    write!(f, "{}", v)
                } else {
                    f.write_str("*")
                }
            }
            ContentRangeSpec::Unregistered { ref unit, ref resp } => {
                try!(f.write_str(&unit));
                try!(f.write_str(" "));
                f.write_str(&resp)
            }
        }
    }
}
