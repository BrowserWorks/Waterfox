// This is a part of Chrono.
// See README.md and LICENSE.txt for details.

//! # Chrono: Date and Time for Rust
//!
//! It aims to be a feature-complete superset of
//! the [time](https://github.com/rust-lang-deprecated/time) library.
//! In particular,
//!
//! * Chrono strictly adheres to ISO 8601.
//! * Chrono is timezone-aware by default, with separate timezone-naive types.
//! * Chrono is space-optimal and (while not being the primary goal) reasonably efficient.
//!
//! There were several previous attempts to bring a good date and time library to Rust,
//! which Chrono builds upon and should acknowledge:
//!
//! * [Initial research on
//!    the wiki](https://github.com/rust-lang/rust-wiki-backup/blob/master/Lib-datetime.md)
//! * Dietrich Epp's [datetime-rs](https://github.com/depp/datetime-rs)
//! * Luis de Bethencourt's [rust-datetime](https://github.com/luisbg/rust-datetime)
//!
//! Any significant changes to Chrono are documented in
//! the [`CHANGELOG.md`](https://github.com/chronotope/chrono/blob/master/CHANGELOG.md) file.
//!
//! ## Usage
//!
//! Put this in your `Cargo.toml`:
//!
//! ```toml
//! [dependencies]
//! chrono = "0.4"
//! ```
//!
//! Or, if you want [Serde](https://github.com/serde-rs/serde) include the
//! feature like this:
//!
//! ```toml
//! [dependencies]
//! chrono = { version = "0.4", features = ["serde"] }
//! ```
//!
//! Then put this in your crate root:
//!
//! ```rust
//! extern crate chrono;
//! ```
//!
//! Avoid using `use chrono::*;` as Chrono exports several modules other than types.
//! If you prefer the glob imports, use the following instead:
//!
//! ```rust
//! use chrono::prelude::*;
//! ```
//!
//! ## Overview
//!
//! ### Duration
//!
//! Chrono currently uses
//! the [`time::Duration`](https://docs.rs/time/0.1.40/time/struct.Duration.html) type
//! from the `time` crate to represent the magnitude of a time span.
//! Since this has the same name to the newer, standard type for duration,
//! the reference will refer this type as `OldDuration`.
//! Note that this is an "accurate" duration represented as seconds and
//! nanoseconds and does not represent "nominal" components such as days or
//! months.
//!
//! Chrono does not yet natively support
//! the standard [`Duration`](https://doc.rust-lang.org/std/time/struct.Duration.html) type,
//! but it will be supported in the future.
//! Meanwhile you can convert between two types with
//! [`Duration::from_std`](https://docs.rs/time/0.1.40/time/struct.Duration.html#method.from_std)
//! and
//! [`Duration::to_std`](https://docs.rs/time/0.1.40/time/struct.Duration.html#method.to_std)
//! methods.
//!
//! ### Date and Time
//!
//! Chrono provides a
//! [**`DateTime`**](./struct.DateTime.html)
//! type to represent a date and a time in a timezone.
//!
//! For more abstract moment-in-time tracking such as internal timekeeping
//! that is unconcerned with timezones, consider
//! [`time::SystemTime`](https://doc.rust-lang.org/std/time/struct.SystemTime.html),
//! which tracks your system clock, or
//! [`time::Instant`](https://doc.rust-lang.org/std/time/struct.Instant.html), which
//! is an opaque but monotonically-increasing representation of a moment in time.
//!
//! `DateTime` is timezone-aware and must be constructed from
//! the [**`TimeZone`**](./offset/trait.TimeZone.html) object,
//! which defines how the local date is converted to and back from the UTC date.
//! There are three well-known `TimeZone` implementations:
//!
//! * [**`Utc`**](./offset/struct.Utc.html) specifies the UTC time zone. It is most efficient.
//!
//! * [**`Local`**](./offset/struct.Local.html) specifies the system local time zone.
//!
//! * [**`FixedOffset`**](./offset/struct.FixedOffset.html) specifies
//!   an arbitrary, fixed time zone such as UTC+09:00 or UTC-10:30.
//!   This often results from the parsed textual date and time.
//!   Since it stores the most information and does not depend on the system environment,
//!   you would want to normalize other `TimeZone`s into this type.
//!
//! `DateTime`s with different `TimeZone` types are distinct and do not mix,
//! but can be converted to each other using
//! the [`DateTime::with_timezone`](./struct.DateTime.html#method.with_timezone) method.
//!
//! You can get the current date and time in the UTC time zone
//! ([`Utc::now()`](./offset/struct.Utc.html#method.now))
//! or in the local time zone
//! ([`Local::now()`](./offset/struct.Local.html#method.now)).
//!
//! ```rust
//! use chrono::prelude::*;
//!
//! let utc: DateTime<Utc> = Utc::now();       // e.g. `2014-11-28T12:45:59.324310806Z`
//! let local: DateTime<Local> = Local::now(); // e.g. `2014-11-28T21:45:59.324310806+09:00`
//! # let _ = utc; let _ = local;
//! ```
//!
//! Alternatively, you can create your own date and time.
//! This is a bit verbose due to Rust's lack of function and method overloading,
//! but in turn we get a rich combination of initialization methods.
//!
//! ```rust
//! use chrono::prelude::*;
//! use chrono::offset::LocalResult;
//!
//! let dt = Utc.ymd(2014, 7, 8).and_hms(9, 10, 11); // `2014-07-08T09:10:11Z`
//! // July 8 is 188th day of the year 2014 (`o` for "ordinal")
//! assert_eq!(dt, Utc.yo(2014, 189).and_hms(9, 10, 11));
//! // July 8 is Tuesday in ISO week 28 of the year 2014.
//! assert_eq!(dt, Utc.isoywd(2014, 28, Weekday::Tue).and_hms(9, 10, 11));
//!
//! let dt = Utc.ymd(2014, 7, 8).and_hms_milli(9, 10, 11, 12); // `2014-07-08T09:10:11.012Z`
//! assert_eq!(dt, Utc.ymd(2014, 7, 8).and_hms_micro(9, 10, 11, 12_000));
//! assert_eq!(dt, Utc.ymd(2014, 7, 8).and_hms_nano(9, 10, 11, 12_000_000));
//!
//! // dynamic verification
//! assert_eq!(Utc.ymd_opt(2014, 7, 8).and_hms_opt(21, 15, 33),
//!            LocalResult::Single(Utc.ymd(2014, 7, 8).and_hms(21, 15, 33)));
//! assert_eq!(Utc.ymd_opt(2014, 7, 8).and_hms_opt(80, 15, 33), LocalResult::None);
//! assert_eq!(Utc.ymd_opt(2014, 7, 38).and_hms_opt(21, 15, 33), LocalResult::None);
//!
//! // other time zone objects can be used to construct a local datetime.
//! // obviously, `local_dt` is normally different from `dt`, but `fixed_dt` should be identical.
//! let local_dt = Local.ymd(2014, 7, 8).and_hms_milli(9, 10, 11, 12);
//! let fixed_dt = FixedOffset::east(9 * 3600).ymd(2014, 7, 8).and_hms_milli(18, 10, 11, 12);
//! assert_eq!(dt, fixed_dt);
//! # let _ = local_dt;
//! ```
//!
//! Various properties are available to the date and time, and can be altered individually.
//! Most of them are defined in the traits [`Datelike`](./trait.Datelike.html) and
//! [`Timelike`](./trait.Timelike.html) which you should `use` before.
//! Addition and subtraction is also supported.
//! The following illustrates most supported operations to the date and time:
//!
//! ```rust
//! # extern crate chrono;
//! extern crate time;
//!
//! # fn main() {
//! use chrono::prelude::*;
//! use time::Duration;
//!
//! // assume this returned `2014-11-28T21:45:59.324310806+09:00`:
//! let dt = FixedOffset::east(9*3600).ymd(2014, 11, 28).and_hms_nano(21, 45, 59, 324310806);
//!
//! // property accessors
//! assert_eq!((dt.year(), dt.month(), dt.day()), (2014, 11, 28));
//! assert_eq!((dt.month0(), dt.day0()), (10, 27)); // for unfortunate souls
//! assert_eq!((dt.hour(), dt.minute(), dt.second()), (21, 45, 59));
//! assert_eq!(dt.weekday(), Weekday::Fri);
//! assert_eq!(dt.weekday().number_from_monday(), 5); // Mon=1, ..., Sun=7
//! assert_eq!(dt.ordinal(), 332); // the day of year
//! assert_eq!(dt.num_days_from_ce(), 735565); // the number of days from and including Jan 1, 1
//!
//! // time zone accessor and manipulation
//! assert_eq!(dt.offset().fix().local_minus_utc(), 9 * 3600);
//! assert_eq!(dt.timezone(), FixedOffset::east(9 * 3600));
//! assert_eq!(dt.with_timezone(&Utc), Utc.ymd(2014, 11, 28).and_hms_nano(12, 45, 59, 324310806));
//!
//! // a sample of property manipulations (validates dynamically)
//! assert_eq!(dt.with_day(29).unwrap().weekday(), Weekday::Sat); // 2014-11-29 is Saturday
//! assert_eq!(dt.with_day(32), None);
//! assert_eq!(dt.with_year(-300).unwrap().num_days_from_ce(), -109606); // November 29, 301 BCE
//!
//! // arithmetic operations
//! let dt1 = Utc.ymd(2014, 11, 14).and_hms(8, 9, 10);
//! let dt2 = Utc.ymd(2014, 11, 14).and_hms(10, 9, 8);
//! assert_eq!(dt1.signed_duration_since(dt2), Duration::seconds(-2 * 3600 + 2));
//! assert_eq!(dt2.signed_duration_since(dt1), Duration::seconds(2 * 3600 - 2));
//! assert_eq!(Utc.ymd(1970, 1, 1).and_hms(0, 0, 0) + Duration::seconds(1_000_000_000),
//!            Utc.ymd(2001, 9, 9).and_hms(1, 46, 40));
//! assert_eq!(Utc.ymd(1970, 1, 1).and_hms(0, 0, 0) - Duration::seconds(1_000_000_000),
//!            Utc.ymd(1938, 4, 24).and_hms(22, 13, 20));
//! # }
//! ```
//!
//! ### Formatting and Parsing
//!
//! Formatting is done via the [`format`](./struct.DateTime.html#method.format) method,
//! which format is equivalent to the familiar `strftime` format.
//!
//! See [`format::strftime`](./format/strftime/index.html#specifiers)
//! documentation for full syntax and list of specifiers.
//!
//! The default `to_string` method and `{:?}` specifier also give a reasonable representation.
//! Chrono also provides [`to_rfc2822`](./struct.DateTime.html#method.to_rfc2822) and
//! [`to_rfc3339`](./struct.DateTime.html#method.to_rfc3339) methods
//! for well-known formats.
//!
//! ```rust
//! use chrono::prelude::*;
//!
//! let dt = Utc.ymd(2014, 11, 28).and_hms(12, 0, 9);
//! assert_eq!(dt.format("%Y-%m-%d %H:%M:%S").to_string(), "2014-11-28 12:00:09");
//! assert_eq!(dt.format("%a %b %e %T %Y").to_string(), "Fri Nov 28 12:00:09 2014");
//! assert_eq!(dt.format("%a %b %e %T %Y").to_string(), dt.format("%c").to_string());
//!
//! assert_eq!(dt.to_string(), "2014-11-28 12:00:09 UTC");
//! assert_eq!(dt.to_rfc2822(), "Fri, 28 Nov 2014 12:00:09 +0000");
//! assert_eq!(dt.to_rfc3339(), "2014-11-28T12:00:09+00:00");
//! assert_eq!(format!("{:?}", dt), "2014-11-28T12:00:09Z");
//!
//! // Note that milli/nanoseconds are only printed if they are non-zero
//! let dt_nano = Utc.ymd(2014, 11, 28).and_hms_nano(12, 0, 9, 1);
//! assert_eq!(format!("{:?}", dt_nano), "2014-11-28T12:00:09.000000001Z");
//! ```
//!
//! Parsing can be done with three methods:
//!
//! 1. The standard [`FromStr`](https://doc.rust-lang.org/std/str/trait.FromStr.html) trait
//!    (and [`parse`](https://doc.rust-lang.org/std/primitive.str.html#method.parse) method
//!    on a string) can be used for parsing `DateTime<FixedOffset>`, `DateTime<Utc>` and
//!    `DateTime<Local>` values. This parses what the `{:?}`
//!    ([`std::fmt::Debug`](https://doc.rust-lang.org/std/fmt/trait.Debug.html))
//!    format specifier prints, and requires the offset to be present.
//!
//! 2. [`DateTime::parse_from_str`](./struct.DateTime.html#method.parse_from_str) parses
//!    a date and time with offsets and returns `DateTime<FixedOffset>`.
//!    This should be used when the offset is a part of input and the caller cannot guess that.
//!    It *cannot* be used when the offset can be missing.
//!    [`DateTime::parse_from_rfc2822`](./struct.DateTime.html#method.parse_from_rfc2822)
//!    and
//!    [`DateTime::parse_from_rfc3339`](./struct.DateTime.html#method.parse_from_rfc3339)
//!    are similar but for well-known formats.
//!
//! 3. [`Offset::datetime_from_str`](./offset/trait.TimeZone.html#method.datetime_from_str) is
//!    similar but returns `DateTime` of given offset.
//!    When the explicit offset is missing from the input, it simply uses given offset.
//!    It issues an error when the input contains an explicit offset different
//!    from the current offset.
//!
//! More detailed control over the parsing process is available via
//! [`format`](./format/index.html) module.
//!
//! ```rust
//! use chrono::prelude::*;
//!
//! let dt = Utc.ymd(2014, 11, 28).and_hms(12, 0, 9);
//! let fixed_dt = dt.with_timezone(&FixedOffset::east(9*3600));
//!
//! // method 1
//! assert_eq!("2014-11-28T12:00:09Z".parse::<DateTime<Utc>>(), Ok(dt.clone()));
//! assert_eq!("2014-11-28T21:00:09+09:00".parse::<DateTime<Utc>>(), Ok(dt.clone()));
//! assert_eq!("2014-11-28T21:00:09+09:00".parse::<DateTime<FixedOffset>>(), Ok(fixed_dt.clone()));
//!
//! // method 2
//! assert_eq!(DateTime::parse_from_str("2014-11-28 21:00:09 +09:00", "%Y-%m-%d %H:%M:%S %z"),
//!            Ok(fixed_dt.clone()));
//! assert_eq!(DateTime::parse_from_rfc2822("Fri, 28 Nov 2014 21:00:09 +0900"),
//!            Ok(fixed_dt.clone()));
//! assert_eq!(DateTime::parse_from_rfc3339("2014-11-28T21:00:09+09:00"), Ok(fixed_dt.clone()));
//!
//! // method 3
//! assert_eq!(Utc.datetime_from_str("2014-11-28 12:00:09", "%Y-%m-%d %H:%M:%S"), Ok(dt.clone()));
//! assert_eq!(Utc.datetime_from_str("Fri Nov 28 12:00:09 2014", "%a %b %e %T %Y"), Ok(dt.clone()));
//!
//! // oops, the year is missing!
//! assert!(Utc.datetime_from_str("Fri Nov 28 12:00:09", "%a %b %e %T %Y").is_err());
//! // oops, the format string does not include the year at all!
//! assert!(Utc.datetime_from_str("Fri Nov 28 12:00:09", "%a %b %e %T").is_err());
//! // oops, the weekday is incorrect!
//! assert!(Utc.datetime_from_str("Sat Nov 28 12:00:09 2014", "%a %b %e %T %Y").is_err());
//! ```
//!
//! Again : See [`format::strftime`](./format/strftime/index.html#specifiers)
//! documentation for full syntax and list of specifiers.
//!
//! ### Conversion from and to EPOCH timestamps
//!
//! Use [`Utc.timestamp(seconds, nanoseconds)`](./offset/trait.TimeZone.html#method.timestamp)
//! to construct a [`DateTime<Utc>`](./struct.DateTime.html) from a UNIX timestamp
//! (seconds, nanoseconds that passed since January 1st 1970).
//!
//! Use [`DateTime.timestamp`](./struct.DateTime.html#method.timestamp) to get the timestamp (in seconds)
//! from a [`DateTime`](./struct.DateTime.html). Additionally, you can use
//! [`DateTime.timestamp_subsec_nanos`](./struct.DateTime.html#method.timestamp_subsec_nanos)
//! to get the number of additional number of nanoseconds.
//!
//! ```rust
//! // We need the trait in scope to use Utc::timestamp().
//! use chrono::{DateTime, TimeZone, Utc};
//!
//! // Construct a datetime from epoch:
//! let dt = Utc.timestamp(1_500_000_000, 0);
//! assert_eq!(dt.to_rfc2822(), "Fri, 14 Jul 2017 02:40:00 +0000");
//!
//! // Get epoch value from a datetime:
//! let dt = DateTime::parse_from_rfc2822("Fri, 14 Jul 2017 02:40:00 +0000").unwrap();
//! assert_eq!(dt.timestamp(), 1_500_000_000);
//! ```
//!
//! ### Individual date
//!
//! Chrono also provides an individual date type ([**`Date`**](./struct.Date.html)).
//! It also has time zones attached, and have to be constructed via time zones.
//! Most operations available to `DateTime` are also available to `Date` whenever appropriate.
//!
//! ```rust
//! use chrono::prelude::*;
//! use chrono::offset::LocalResult;
//!
//! # // these *may* fail, but only very rarely. just rerun the test if you were that unfortunate ;)
//! assert_eq!(Utc::today(), Utc::now().date());
//! assert_eq!(Local::today(), Local::now().date());
//!
//! assert_eq!(Utc.ymd(2014, 11, 28).weekday(), Weekday::Fri);
//! assert_eq!(Utc.ymd_opt(2014, 11, 31), LocalResult::None);
//! assert_eq!(Utc.ymd(2014, 11, 28).and_hms_milli(7, 8, 9, 10).format("%H%M%S").to_string(),
//!            "070809");
//! ```
//!
//! There is no timezone-aware `Time` due to the lack of usefulness and also the complexity.
//!
//! `DateTime` has [`date`](./struct.DateTime.html#method.date) method
//! which returns a `Date` which represents its date component.
//! There is also a [`time`](./struct.DateTime.html#method.time) method,
//! which simply returns a naive local time described below.
//!
//! ### Naive date and time
//!
//! Chrono provides naive counterparts to `Date`, (non-existent) `Time` and `DateTime`
//! as [**`NaiveDate`**](./naive/struct.NaiveDate.html),
//! [**`NaiveTime`**](./naive/struct.NaiveTime.html) and
//! [**`NaiveDateTime`**](./naive/struct.NaiveDateTime.html) respectively.
//!
//! They have almost equivalent interfaces as their timezone-aware twins,
//! but are not associated to time zones obviously and can be quite low-level.
//! They are mostly useful for building blocks for higher-level types.
//!
//! Timezone-aware `DateTime` and `Date` types have two methods returning naive versions:
//! [`naive_local`](./struct.DateTime.html#method.naive_local) returns
//! a view to the naive local time,
//! and [`naive_utc`](./struct.DateTime.html#method.naive_utc) returns
//! a view to the naive UTC time.
//!
//! ## Limitations
//!
//! Only proleptic Gregorian calendar (i.e. extended to support older dates) is supported.
//! Be very careful if you really have to deal with pre-20C dates, they can be in Julian or others.
//!
//! Date types are limited in about +/- 262,000 years from the common epoch.
//! Time types are limited in the nanosecond accuracy.
//!
//! [Leap seconds are supported in the representation but
//! Chrono doesn't try to make use of them](./naive/struct.NaiveTime.html#leap-second-handling).
//! (The main reason is that leap seconds are not really predictable.)
//! Almost *every* operation over the possible leap seconds will ignore them.
//! Consider using `NaiveDateTime` with the implicit TAI (International Atomic Time) scale
//! if you want.
//!
//! Chrono inherently does not support an inaccurate or partial date and time representation.
//! Any operation that can be ambiguous will return `None` in such cases.
//! For example, "a month later" of 2014-01-30 is not well-defined
//! and consequently `Utc.ymd(2014, 1, 30).with_month(2)` returns `None`.
//!
//! Advanced time zone handling is not yet supported.
//! For now you can try the [Chrono-tz](https://github.com/chronotope/chrono-tz/) crate instead.

#![doc(html_root_url = "https://docs.rs/chrono/latest/")]

#![cfg_attr(feature = "bench", feature(test))] // lib stability features as per RFC #507
#![deny(missing_docs)]
#![deny(missing_debug_implementations)]
#![deny(dead_code)]

#![cfg_attr(not(any(feature = "std", test)), no_std)]

// The explicit 'static lifetimes are still needed for rustc 1.13-16
// backward compatibility, and this appeases clippy. If minimum rustc
// becomes 1.17, should be able to remove this, those 'static lifetimes,
// and use `static` in a lot of places `const` is used now.
//
// Similarly, redundant_field_names lints on not using the
// field-init-shorthand, which was stabilized in rust 1.17.
//
// Changing trivially_copy_pass_by_ref would require an incompatible version
// bump.
#![cfg_attr(feature = "cargo-clippy", allow(
    const_static_lifetime,
    redundant_field_names,
    trivially_copy_pass_by_ref,
))]

#[cfg(feature = "alloc")]
extern crate alloc;
#[cfg(any(feature = "std", test))]
extern crate std as core;
#[cfg(all(feature = "std", not(feature="alloc")))]
extern crate std as alloc;

#[cfg(feature="clock")]
extern crate time as oldtime;
extern crate num_integer;
extern crate num_traits;
#[cfg(feature = "rustc-serialize")]
extern crate rustc_serialize;
#[cfg(feature = "serde")]
extern crate serde as serdelib;
#[cfg(test)]
#[macro_use]
extern crate doc_comment;
#[cfg(all(target_arch = "wasm32", feature="wasmbind"))]
extern crate wasm_bindgen;
#[cfg(all(target_arch = "wasm32", feature="wasmbind"))]
extern crate js_sys;
#[cfg(feature = "bench")]
extern crate test;

#[cfg(test)]
doctest!("../README.md");

// this reexport is to aid the transition and should not be in the prelude!
pub use oldtime::Duration;

#[cfg(feature="clock")]
#[doc(no_inline)] pub use offset::Local;
#[doc(no_inline)] pub use offset::{TimeZone, Offset, LocalResult, Utc, FixedOffset};
#[doc(no_inline)] pub use naive::{NaiveDate, IsoWeek, NaiveTime, NaiveDateTime};
pub use date::{Date, MIN_DATE, MAX_DATE};
pub use datetime::{DateTime, SecondsFormat};
#[cfg(feature = "rustc-serialize")]
pub use datetime::rustc_serialize::TsSeconds;
pub use format::{ParseError, ParseResult};
pub use round::SubsecRound;

/// A convenience module appropriate for glob imports (`use chrono::prelude::*;`).
pub mod prelude {
    #[doc(no_inline)] pub use {Datelike, Timelike, Weekday};
    #[doc(no_inline)] pub use {TimeZone, Offset};
    #[cfg(feature="clock")]
    #[doc(no_inline)] pub use Local;
    #[doc(no_inline)] pub use {Utc, FixedOffset};
    #[doc(no_inline)] pub use {NaiveDate, NaiveTime, NaiveDateTime};
    #[doc(no_inline)] pub use Date;
    #[doc(no_inline)] pub use {DateTime, SecondsFormat};
    #[doc(no_inline)] pub use SubsecRound;
}

// useful throughout the codebase
macro_rules! try_opt {
    ($e:expr) => (match $e { Some(v) => v, None => return None })
}

mod div;
#[cfg(not(feature="clock"))]
mod oldtime;
pub mod offset;
pub mod naive {
    //! Date and time types unconcerned with timezones.
    //!
    //! They are primarily building blocks for other types
    //! (e.g. [`TimeZone`](../offset/trait.TimeZone.html)),
    //! but can be also used for the simpler date and time handling.

    mod internals;
    mod date;
    mod isoweek;
    mod time;
    mod datetime;

    pub use self::date::{NaiveDate, MIN_DATE, MAX_DATE};
    pub use self::isoweek::IsoWeek;
    pub use self::time::NaiveTime;
    pub use self::datetime::NaiveDateTime;
    #[cfg(feature = "rustc-serialize")]
    #[allow(deprecated)]
    pub use self::datetime::rustc_serialize::TsSeconds;


    /// Serialization/Deserialization of naive types in alternate formats
    ///
    /// The various modules in here are intended to be used with serde's [`with`
    /// annotation][1] to serialize as something other than the default [RFC
    /// 3339][2] format.
    ///
    /// [1]: https://serde.rs/attributes.html#field-attributes
    /// [2]: https://tools.ietf.org/html/rfc3339
    #[cfg(feature = "serde")]
    pub mod serde {
        pub use super::datetime::serde::*;
    }
}
mod date;
mod datetime;
pub mod format;
mod round;

/// Serialization/Deserialization in alternate formats
///
/// The various modules in here are intended to be used with serde's [`with`
/// annotation][1] to serialize as something other than the default [RFC
/// 3339][2] format.
///
/// [1]: https://serde.rs/attributes.html#field-attributes
/// [2]: https://tools.ietf.org/html/rfc3339
#[cfg(feature = "serde")]
pub mod serde {
    pub use super::datetime::serde::*;
}

// Until rust 1.18 there  is no "pub(crate)" so to share this we need it in the root

#[cfg(feature = "serde")]
enum SerdeError<V: fmt::Display, D: fmt::Display> {
    NonExistent { timestamp: V },
    Ambiguous { timestamp: V, min: D, max: D },
}

/// Construct a [`SerdeError::NonExistent`]
#[cfg(feature = "serde")]
fn ne_timestamp<T: fmt::Display>(ts: T) -> SerdeError<T, u8> {
    SerdeError::NonExistent::<T, u8> { timestamp: ts }
}

#[cfg(feature = "serde")]
impl<V: fmt::Display, D: fmt::Display> fmt::Debug for SerdeError<V, D> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "ChronoSerdeError({})", self)
    }
}

// impl<V: fmt::Display, D: fmt::Debug> core::error::Error for SerdeError<V, D> {}
#[cfg(feature = "serde")]
impl<V: fmt::Display, D: fmt::Display> fmt::Display for SerdeError<V, D> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            &SerdeError::NonExistent { ref timestamp } => write!(
                f, "value is not a legal timestamp: {}", timestamp),
            &SerdeError::Ambiguous { ref timestamp, ref min, ref max } => write!(
                f, "value is an ambiguous timestamp: {}, could be either of {}, {}",
                timestamp, min, max),
        }
    }
}

/// The day of week.
///
/// The order of the days of week depends on the context.
/// (This is why this type does *not* implement `PartialOrd` or `Ord` traits.)
/// One should prefer `*_from_monday` or `*_from_sunday` methods to get the correct result.
#[derive(PartialEq, Eq, Copy, Clone, Debug, Hash)]
#[cfg_attr(feature = "rustc-serialize", derive(RustcEncodable, RustcDecodable))]
pub enum Weekday {
    /// Monday.
    Mon = 0,
    /// Tuesday.
    Tue = 1,
    /// Wednesday.
    Wed = 2,
    /// Thursday.
    Thu = 3,
    /// Friday.
    Fri = 4,
    /// Saturday.
    Sat = 5,
    /// Sunday.
    Sun = 6,
}

impl Weekday {
    /// The next day in the week.
    ///
    /// `w`:        | `Mon` | `Tue` | `Wed` | `Thu` | `Fri` | `Sat` | `Sun`
    /// ----------- | ----- | ----- | ----- | ----- | ----- | ----- | -----
    /// `w.succ()`: | `Tue` | `Wed` | `Thu` | `Fri` | `Sat` | `Sun` | `Mon`
    #[inline]
    pub fn succ(&self) -> Weekday {
        match *self {
            Weekday::Mon => Weekday::Tue,
            Weekday::Tue => Weekday::Wed,
            Weekday::Wed => Weekday::Thu,
            Weekday::Thu => Weekday::Fri,
            Weekday::Fri => Weekday::Sat,
            Weekday::Sat => Weekday::Sun,
            Weekday::Sun => Weekday::Mon,
        }
    }

    /// The previous day in the week.
    ///
    /// `w`:        | `Mon` | `Tue` | `Wed` | `Thu` | `Fri` | `Sat` | `Sun`
    /// ----------- | ----- | ----- | ----- | ----- | ----- | ----- | -----
    /// `w.pred()`: | `Sun` | `Mon` | `Tue` | `Wed` | `Thu` | `Fri` | `Sat`
    #[inline]
    pub fn pred(&self) -> Weekday {
        match *self {
            Weekday::Mon => Weekday::Sun,
            Weekday::Tue => Weekday::Mon,
            Weekday::Wed => Weekday::Tue,
            Weekday::Thu => Weekday::Wed,
            Weekday::Fri => Weekday::Thu,
            Weekday::Sat => Weekday::Fri,
            Weekday::Sun => Weekday::Sat,
        }
    }

    /// Returns a day-of-week number starting from Monday = 1. (ISO 8601 weekday number)
    ///
    /// `w`:                      | `Mon` | `Tue` | `Wed` | `Thu` | `Fri` | `Sat` | `Sun`
    /// ------------------------- | ----- | ----- | ----- | ----- | ----- | ----- | -----
    /// `w.number_from_monday()`: | 1     | 2     | 3     | 4     | 5     | 6     | 7
    #[inline]
    pub fn number_from_monday(&self) -> u32 {
        match *self {
            Weekday::Mon => 1,
            Weekday::Tue => 2,
            Weekday::Wed => 3,
            Weekday::Thu => 4,
            Weekday::Fri => 5,
            Weekday::Sat => 6,
            Weekday::Sun => 7,
        }
    }

    /// Returns a day-of-week number starting from Sunday = 1.
    ///
    /// `w`:                      | `Mon` | `Tue` | `Wed` | `Thu` | `Fri` | `Sat` | `Sun`
    /// ------------------------- | ----- | ----- | ----- | ----- | ----- | ----- | -----
    /// `w.number_from_sunday()`: | 2     | 3     | 4     | 5     | 6     | 7     | 1
    #[inline]
    pub fn number_from_sunday(&self) -> u32 {
        match *self {
            Weekday::Mon => 2,
            Weekday::Tue => 3,
            Weekday::Wed => 4,
            Weekday::Thu => 5,
            Weekday::Fri => 6,
            Weekday::Sat => 7,
            Weekday::Sun => 1,
        }
    }

    /// Returns a day-of-week number starting from Monday = 0.
    ///
    /// `w`:                        | `Mon` | `Tue` | `Wed` | `Thu` | `Fri` | `Sat` | `Sun`
    /// --------------------------- | ----- | ----- | ----- | ----- | ----- | ----- | -----
    /// `w.num_days_from_monday()`: | 0     | 1     | 2     | 3     | 4     | 5     | 6
    #[inline]
    pub fn num_days_from_monday(&self) -> u32 {
        match *self {
            Weekday::Mon => 0,
            Weekday::Tue => 1,
            Weekday::Wed => 2,
            Weekday::Thu => 3,
            Weekday::Fri => 4,
            Weekday::Sat => 5,
            Weekday::Sun => 6,
        }
    }

    /// Returns a day-of-week number starting from Sunday = 0.
    ///
    /// `w`:                        | `Mon` | `Tue` | `Wed` | `Thu` | `Fri` | `Sat` | `Sun`
    /// --------------------------- | ----- | ----- | ----- | ----- | ----- | ----- | -----
    /// `w.num_days_from_sunday()`: | 1     | 2     | 3     | 4     | 5     | 6     | 0
    #[inline]
    pub fn num_days_from_sunday(&self) -> u32 {
        match *self {
            Weekday::Mon => 1,
            Weekday::Tue => 2,
            Weekday::Wed => 3,
            Weekday::Thu => 4,
            Weekday::Fri => 5,
            Weekday::Sat => 6,
            Weekday::Sun => 0,
        }
    }
}

impl fmt::Display for Weekday {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.write_str(match *self {
            Weekday::Mon => "Mon",
            Weekday::Tue => "Tue",
            Weekday::Wed => "Wed",
            Weekday::Thu => "Thu",
            Weekday::Fri => "Fri",
            Weekday::Sat => "Sat",
            Weekday::Sun => "Sun",
        })
    }
}

/// Any weekday can be represented as an integer from 0 to 6, which equals to
/// [`Weekday::num_days_from_monday`](#method.num_days_from_monday) in this implementation.
/// Do not heavily depend on this though; use explicit methods whenever possible.
impl num_traits::FromPrimitive for Weekday {
    #[inline]
    fn from_i64(n: i64) -> Option<Weekday> {
        match n {
            0 => Some(Weekday::Mon),
            1 => Some(Weekday::Tue),
            2 => Some(Weekday::Wed),
            3 => Some(Weekday::Thu),
            4 => Some(Weekday::Fri),
            5 => Some(Weekday::Sat),
            6 => Some(Weekday::Sun),
            _ => None,
        }
    }

    #[inline]
    fn from_u64(n: u64) -> Option<Weekday> {
        match n {
            0 => Some(Weekday::Mon),
            1 => Some(Weekday::Tue),
            2 => Some(Weekday::Wed),
            3 => Some(Weekday::Thu),
            4 => Some(Weekday::Fri),
            5 => Some(Weekday::Sat),
            6 => Some(Weekday::Sun),
            _ => None,
        }
    }
}

use core::fmt;

/// An error resulting from reading `Weekday` value with `FromStr`.
#[derive(Clone, PartialEq)]
pub struct ParseWeekdayError {
    _dummy: (),
}

impl fmt::Debug for ParseWeekdayError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "ParseWeekdayError {{ .. }}")
    }
}

// the actual `FromStr` implementation is in the `format` module to leverage the existing code

#[cfg(feature = "serde")]
mod weekday_serde {
    use super::Weekday;
    use core::fmt;
    use serdelib::{ser, de};

    impl ser::Serialize for Weekday {
        fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
            where S: ser::Serializer
        {
            serializer.collect_str(&self)
        }
    }

    struct WeekdayVisitor;

    impl<'de> de::Visitor<'de> for WeekdayVisitor {
        type Value = Weekday;

        fn expecting(&self, f: &mut fmt::Formatter) -> fmt::Result {
            write!(f, "Weekday")
        }

        fn visit_str<E>(self, value: &str) -> Result<Self::Value, E>
            where E: de::Error
        {
            value.parse().map_err(|_| E::custom("short or long weekday names expected"))
        }
    }

    impl<'de> de::Deserialize<'de> for Weekday {
        fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
            where D: de::Deserializer<'de>
        {
            deserializer.deserialize_str(WeekdayVisitor)
        }
    }

    #[cfg(test)]
    extern crate serde_json;

    #[test]
    fn test_serde_serialize() {
        use self::serde_json::to_string;
        use Weekday::*;

        let cases: Vec<(Weekday, &str)> = vec![
            (Mon, "\"Mon\""),
            (Tue, "\"Tue\""),
            (Wed, "\"Wed\""),
            (Thu, "\"Thu\""),
            (Fri, "\"Fri\""),
            (Sat, "\"Sat\""),
            (Sun, "\"Sun\""),
        ];

        for (weekday, expected_str) in cases {
            let string = to_string(&weekday).unwrap();
            assert_eq!(string, expected_str);
        }
    }

    #[test]
    fn test_serde_deserialize() {
        use self::serde_json::from_str;
        use Weekday::*;

        let cases: Vec<(&str, Weekday)> = vec![
            ("\"mon\"", Mon),
            ("\"MONDAY\"", Mon),
            ("\"MonDay\"", Mon),
            ("\"mOn\"", Mon),
            ("\"tue\"", Tue),
            ("\"tuesday\"", Tue),
            ("\"wed\"", Wed),
            ("\"wednesday\"", Wed),
            ("\"thu\"", Thu),
            ("\"thursday\"", Thu),
            ("\"fri\"", Fri),
            ("\"friday\"", Fri),
            ("\"sat\"", Sat),
            ("\"saturday\"", Sat),
            ("\"sun\"", Sun),
            ("\"sunday\"", Sun),
        ];

        for (str, expected_weekday) in cases {
            let weekday = from_str::<Weekday>(str).unwrap();
            assert_eq!(weekday, expected_weekday);
        }

        let errors: Vec<&str> = vec![
            "\"not a weekday\"",
            "\"monDAYs\"",
            "\"mond\"",
            "mon",
            "\"thur\"",
            "\"thurs\"",
        ];

        for str in errors {
            from_str::<Weekday>(str).unwrap_err();
        }
    }
}

/// The common set of methods for date component.
pub trait Datelike: Sized {
    /// Returns the year number in the [calendar date](./naive/struct.NaiveDate.html#calendar-date).
    fn year(&self) -> i32;

    /// Returns the absolute year number starting from 1 with a boolean flag,
    /// which is false when the year predates the epoch (BCE/BC) and true otherwise (CE/AD).
    #[inline]
    fn year_ce(&self) -> (bool, u32) {
        let year = self.year();
        if year < 1 {
            (false, (1 - year) as u32)
        } else {
            (true, year as u32)
        }
    }

    /// Returns the month number starting from 1.
    ///
    /// The return value ranges from 1 to 12.
    fn month(&self) -> u32;

    /// Returns the month number starting from 0.
    ///
    /// The return value ranges from 0 to 11.
    fn month0(&self) -> u32;

    /// Returns the day of month starting from 1.
    ///
    /// The return value ranges from 1 to 31. (The last day of month differs by months.)
    fn day(&self) -> u32;

    /// Returns the day of month starting from 0.
    ///
    /// The return value ranges from 0 to 30. (The last day of month differs by months.)
    fn day0(&self) -> u32;

    /// Returns the day of year starting from 1.
    ///
    /// The return value ranges from 1 to 366. (The last day of year differs by years.)
    fn ordinal(&self) -> u32;

    /// Returns the day of year starting from 0.
    ///
    /// The return value ranges from 0 to 365. (The last day of year differs by years.)
    fn ordinal0(&self) -> u32;

    /// Returns the day of week.
    fn weekday(&self) -> Weekday;

    /// Returns the ISO week.
    fn iso_week(&self) -> IsoWeek;

    /// Makes a new value with the year number changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_year(&self, year: i32) -> Option<Self>;

    /// Makes a new value with the month number (starting from 1) changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_month(&self, month: u32) -> Option<Self>;

    /// Makes a new value with the month number (starting from 0) changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_month0(&self, month0: u32) -> Option<Self>;

    /// Makes a new value with the day of month (starting from 1) changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_day(&self, day: u32) -> Option<Self>;

    /// Makes a new value with the day of month (starting from 0) changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_day0(&self, day0: u32) -> Option<Self>;

    /// Makes a new value with the day of year (starting from 1) changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_ordinal(&self, ordinal: u32) -> Option<Self>;

    /// Makes a new value with the day of year (starting from 0) changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_ordinal0(&self, ordinal0: u32) -> Option<Self>;

    /// Counts the days in the proleptic Gregorian calendar, with January 1, Year 1 (CE) as day 1.
    ///
    /// # Examples
    ///
    /// ```
    /// use chrono::{NaiveDate, Datelike};
    ///
    /// assert_eq!(NaiveDate::from_ymd(1970, 1, 1).num_days_from_ce(), 719_163);
    /// assert_eq!(NaiveDate::from_ymd(2, 1, 1).num_days_from_ce(), 366);
    /// assert_eq!(NaiveDate::from_ymd(1, 1, 1).num_days_from_ce(), 1);
    /// assert_eq!(NaiveDate::from_ymd(0, 1, 1).num_days_from_ce(), -365);
    /// ```
    fn num_days_from_ce(&self) -> i32 {
        // we know this wouldn't overflow since year is limited to 1/2^13 of i32's full range.
        let mut year = self.year() - 1;
        let mut ndays = 0;
        if year < 0 {
            let excess = 1 + (-year) / 400;
            year += excess * 400;
            ndays -= excess * 146_097;
        }
        let div_100 = year / 100;
        ndays += ((year * 1461) >> 2) - div_100 + (div_100 >> 2);
        ndays + self.ordinal() as i32
    }
}

/// The common set of methods for time component.
pub trait Timelike: Sized {
    /// Returns the hour number from 0 to 23.
    fn hour(&self) -> u32;

    /// Returns the hour number from 1 to 12 with a boolean flag,
    /// which is false for AM and true for PM.
    #[inline]
    fn hour12(&self) -> (bool, u32) {
        let hour = self.hour();
        let mut hour12 = hour % 12;
        if hour12 == 0 {
            hour12 = 12;
        }
        (hour >= 12, hour12)
    }

    /// Returns the minute number from 0 to 59.
    fn minute(&self) -> u32;

    /// Returns the second number from 0 to 59.
    fn second(&self) -> u32;

    /// Returns the number of nanoseconds since the whole non-leap second.
    /// The range from 1,000,000,000 to 1,999,999,999 represents
    /// the [leap second](./naive/struct.NaiveTime.html#leap-second-handling).
    fn nanosecond(&self) -> u32;

    /// Makes a new value with the hour number changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_hour(&self, hour: u32) -> Option<Self>;

    /// Makes a new value with the minute number changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    fn with_minute(&self, min: u32) -> Option<Self>;

    /// Makes a new value with the second number changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    /// As with the [`second`](#tymethod.second) method,
    /// the input range is restricted to 0 through 59.
    fn with_second(&self, sec: u32) -> Option<Self>;

    /// Makes a new value with nanoseconds since the whole non-leap second changed.
    ///
    /// Returns `None` when the resulting value would be invalid.
    /// As with the [`nanosecond`](#tymethod.nanosecond) method,
    /// the input range can exceed 1,000,000,000 for leap seconds.
    fn with_nanosecond(&self, nano: u32) -> Option<Self>;

    /// Returns the number of non-leap seconds past the last midnight.
    #[inline]
    fn num_seconds_from_midnight(&self) -> u32 {
        self.hour() * 3600 + self.minute() * 60 + self.second()
    }
}

#[cfg(test)] extern crate num_iter;

#[test]
fn test_readme_doomsday() {
    use num_iter::range_inclusive;

    for y in range_inclusive(naive::MIN_DATE.year(), naive::MAX_DATE.year()) {
        // even months
        let d4 = NaiveDate::from_ymd(y, 4, 4);
        let d6 = NaiveDate::from_ymd(y, 6, 6);
        let d8 = NaiveDate::from_ymd(y, 8, 8);
        let d10 = NaiveDate::from_ymd(y, 10, 10);
        let d12 = NaiveDate::from_ymd(y, 12, 12);

        // nine to five, seven-eleven
        let d59 = NaiveDate::from_ymd(y, 5, 9);
        let d95 = NaiveDate::from_ymd(y, 9, 5);
        let d711 = NaiveDate::from_ymd(y, 7, 11);
        let d117 = NaiveDate::from_ymd(y, 11, 7);

        // "March 0"
        let d30 = NaiveDate::from_ymd(y, 3, 1).pred();

        let weekday = d30.weekday();
        let other_dates = [d4, d6, d8, d10, d12, d59, d95, d711, d117];
        assert!(other_dates.iter().all(|d| d.weekday() == weekday));
    }
}
