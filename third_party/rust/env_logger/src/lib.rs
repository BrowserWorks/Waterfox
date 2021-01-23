// Copyright 2014-2015 The Rust Project Developers. See the COPYRIGHT
// file at the top-level directory of this distribution and at
// http://rust-lang.org/COPYRIGHT.
//
// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

//! A simple logger configured via environment variables which writes
//! to stdout or stderr, for use with the logging facade exposed by the
//! [`log` crate][log-crate-url].
//!
//! ## Example
//!
//! ```
//! #[macro_use] extern crate log;
//! extern crate env_logger;
//!
//! use log::Level;
//!
//! fn main() {
//!     env_logger::init();
//!
//!     debug!("this is a debug {}", "message");
//!     error!("this is printed by default");
//!
//!     if log_enabled!(Level::Info) {
//!         let x = 3 * 4; // expensive computation
//!         info!("the answer was: {}", x);
//!     }
//! }
//! ```
//!
//! Assumes the binary is `main`:
//!
//! ```{.bash}
//! $ RUST_LOG=error ./main
//! [2017-11-09T02:12:24Z ERROR main] this is printed by default
//! ```
//!
//! ```{.bash}
//! $ RUST_LOG=info ./main
//! [2017-11-09T02:12:24Z ERROR main] this is printed by default
//! [2017-11-09T02:12:24Z INFO main] the answer was: 12
//! ```
//!
//! ```{.bash}
//! $ RUST_LOG=debug ./main
//! [2017-11-09T02:12:24Z DEBUG main] this is a debug message
//! [2017-11-09T02:12:24Z ERROR main] this is printed by default
//! [2017-11-09T02:12:24Z INFO main] the answer was: 12
//! ```
//!
//! You can also set the log level on a per module basis:
//!
//! ```{.bash}
//! $ RUST_LOG=main=info ./main
//! [2017-11-09T02:12:24Z ERROR main] this is printed by default
//! [2017-11-09T02:12:24Z INFO main] the answer was: 12
//! ```
//!
//! And enable all logging:
//!
//! ```{.bash}
//! $ RUST_LOG=main ./main
//! [2017-11-09T02:12:24Z DEBUG main] this is a debug message
//! [2017-11-09T02:12:24Z ERROR main] this is printed by default
//! [2017-11-09T02:12:24Z INFO main] the answer was: 12
//! ```
//!
//! If the binary name contains hyphens, you will need to replace
//! them with underscores:
//!
//! ```{.bash}
//! $ RUST_LOG=my_app ./my-app
//! [2017-11-09T02:12:24Z DEBUG my_app] this is a debug message
//! [2017-11-09T02:12:24Z ERROR my_app] this is printed by default
//! [2017-11-09T02:12:24Z INFO my_app] the answer was: 12
//! ```
//!
//! This is because Rust modules and crates cannot contain hyphens
//! in their name, although `cargo` continues to accept them.
//!
//! See the documentation for the [`log` crate][log-crate-url] for more
//! information about its API.
//!
//! ## Enabling logging
//!
//! Log levels are controlled on a per-module basis, and by default all logging
//! is disabled except for `error!`. Logging is controlled via the `RUST_LOG`
//! environment variable. The value of this environment variable is a
//! comma-separated list of logging directives. A logging directive is of the
//! form:
//!
//! ```text
//! path::to::module=level
//! ```
//!
//! The path to the module is rooted in the name of the crate it was compiled
//! for, so if your program is contained in a file `hello.rs`, for example, to
//! turn on logging for this file you would use a value of `RUST_LOG=hello`.
//! Furthermore, this path is a prefix-search, so all modules nested in the
//! specified module will also have logging enabled.
//!
//! The actual `level` is optional to specify. If omitted, all logging will
//! be enabled. If specified, it must be one of the strings `debug`, `error`,
//! `info`, `warn`, or `trace`.
//!
//! As the log level for a module is optional, the module to enable logging for
//! is also optional. If only a `level` is provided, then the global log
//! level for all modules is set to this value.
//!
//! Some examples of valid values of `RUST_LOG` are:
//!
//! * `hello` turns on all logging for the 'hello' module
//! * `info` turns on all info logging
//! * `hello=debug` turns on debug logging for 'hello'
//! * `hello,std::option` turns on hello, and std's option logging
//! * `error,hello=warn` turn on global error logging and also warn for hello
//!
//! ## Filtering results
//!
//! A `RUST_LOG` directive may include a regex filter. The syntax is to append `/`
//! followed by a regex. Each message is checked against the regex, and is only
//! logged if it matches. Note that the matching is done after formatting the
//! log string but before adding any logging meta-data. There is a single filter
//! for all modules.
//!
//! Some examples:
//!
//! * `hello/foo` turns on all logging for the 'hello' module where the log
//!   message includes 'foo'.
//! * `info/f.o` turns on all info logging where the log message includes 'foo',
//!   'f1o', 'fao', etc.
//! * `hello=debug/foo*foo` turns on debug logging for 'hello' where the log
//!   message includes 'foofoo' or 'fofoo' or 'fooooooofoo', etc.
//! * `error,hello=warn/[0-9]scopes` turn on global error logging and also
//!   warn for hello. In both cases the log message must include a single digit
//!   number followed by 'scopes'.
//! 
//! ## Capturing logs in tests
//! 
//! Records logged during `cargo test` will not be captured by the test harness by default.
//! The [`Builder::is_test`] method can be used in unit tests to ensure logs will be captured:
//! 
//! ```
//! # #[macro_use] extern crate log;
//! # extern crate env_logger;
//! # fn main() {}
//! #[cfg(test)]
//! mod tests {
//!     fn init() {
//!         let _ = env_logger::builder().is_test(true).try_init();
//!     }
//! 
//!     #[test]
//!     fn it_works() {
//!         init();
//! 
//!         info!("This record will be captured by `cargo test`");
//! 
//!         assert_eq!(2, 1 + 1);
//!     }
//! }
//! ```
//! 
//! Enabling test capturing comes at the expense of color and other style support
//! and may have performance implications.
//!
//! ## Disabling colors
//!
//! Colors and other styles can be configured with the `RUST_LOG_STYLE`
//! environment variable. It accepts the following values:
//!
//! * `auto` (default) will attempt to print style characters, but don't force the issue.
//! If the console isn't available on Windows, or if TERM=dumb, for example, then don't print colors.
//! * `always` will always print style characters even if they aren't supported by the terminal.
//! This includes emitting ANSI colors on Windows if the console API is unavailable.
//! * `never` will never print style characters.
//! 
//! ## Tweaking the default format
//! 
//! Parts of the default format can be excluded from the log output using the [`Builder`].
//! The following example excludes the timestamp from the log output:
//! 
//! ```
//! env_logger::builder()
//!     .default_format_timestamp(false)
//!     .init();
//! ```
//! 
//! ### Stability of the default format
//! 
//! The default format won't optimise for long-term stability, and explicitly makes no 
//! guarantees about the stability of its output across major, minor or patch version 
//! bumps during `0.x`.
//! 
//! If you want to capture or interpret the output of `env_logger` programmatically 
//! then you should use a custom format.
//! 
//! ### Using a custom format
//! 
//! Custom formats can be provided as closures to the [`Builder`].
//! These closures take a [`Formatter`] and `log::Record` as arguments:
//! 
//! ```
//! use std::io::Write;
//!
//! env_logger::builder()
//!     .format(|buf, record| {
//!         writeln!(buf, "{}: {}", record.level(), record.args())
//!     })
//!     .init();
//! ```
//! 
//! See the [`fmt`] module for more details about custom formats.
//! 
//! ## Specifying defaults for environment variables
//! 
//! `env_logger` can read configuration from environment variables.
//! If these variables aren't present, the default value to use can be tweaked with the [`Env`] type.
//! The following example defaults to log `warn` and above if the `RUST_LOG` environment variable
//! isn't set:
//! 
//! ```
//! use env_logger::Env;
//!
//! env_logger::from_env(Env::default().default_filter_or("warn")).init();
//! ```
//! 
//! [log-crate-url]: https://docs.rs/log/
//! [`Builder`]: struct.Builder.html
//! [`Builder::is_test`]: struct.Builder.html#method.is_test
//! [`Env`]: struct.Env.html
//! [`fmt`]: fmt/index.html

#![doc(html_logo_url = "https://www.rust-lang.org/logos/rust-logo-128x128-blk-v2.png",
       html_favicon_url = "https://www.rust-lang.org/static/images/favicon.ico",
       html_root_url = "https://docs.rs/env_logger/0.6.2")]
#![cfg_attr(test, deny(warnings))]

// When compiled for the rustc compiler itself we want to make sure that this is
// an unstable crate
#![cfg_attr(rustbuild, feature(staged_api, rustc_private))]
#![cfg_attr(rustbuild, unstable(feature = "rustc_private", issue = "27812"))]

#![deny(missing_debug_implementations, missing_docs, warnings)]

extern crate log;

#[cfg(feature = "termcolor")]
extern crate termcolor;
#[cfg(feature = "humantime")]
extern crate humantime;
#[cfg(feature = "atty")]
extern crate atty;

use std::{env, io};
use std::borrow::Cow;
use std::cell::RefCell;

use log::{Log, LevelFilter, Record, SetLoggerError, Metadata};

pub mod filter;
pub mod fmt;

pub use self::fmt::glob::*;

use self::filter::Filter;
use self::fmt::Formatter;
use self::fmt::writer::{self, Writer};

/// The default name for the environment variable to read filters from.
pub const DEFAULT_FILTER_ENV: &'static str = "RUST_LOG";

/// The default name for the environment variable to read style preferences from.
pub const DEFAULT_WRITE_STYLE_ENV: &'static str = "RUST_LOG_STYLE";

/// Set of environment variables to configure from.
///
/// # Default environment variables
///
/// By default, the `Env` will read the following environment variables:
///
/// - `RUST_LOG`: the level filter
/// - `RUST_LOG_STYLE`: whether or not to print styles with records.
///
/// These sources can be configured using the builder methods on `Env`.
#[derive(Debug)]
pub struct Env<'a> {
    filter: Var<'a>,
    write_style: Var<'a>,
}

#[derive(Debug)]
struct Var<'a> {
    name: Cow<'a, str>,
    default: Option<Cow<'a, str>>,
}

/// The env logger.
///
/// This struct implements the `Log` trait from the [`log` crate][log-crate-url],
/// which allows it to act as a logger.
///
/// The [`init()`], [`try_init()`], [`Builder::init()`] and [`Builder::try_init()`]
/// methods will each construct a `Logger` and immediately initialize it as the
/// default global logger.
///
/// If you'd instead need access to the constructed `Logger`, you can use
/// the associated [`Builder`] and install it with the
/// [`log` crate][log-crate-url] directly.
///
/// [log-crate-url]: https://docs.rs/log/
/// [`init()`]: fn.init.html
/// [`try_init()`]: fn.try_init.html
/// [`Builder::init()`]: struct.Builder.html#method.init
/// [`Builder::try_init()`]: struct.Builder.html#method.try_init
/// [`Builder`]: struct.Builder.html
pub struct Logger {
    writer: Writer,
    filter: Filter,
    #[allow(unknown_lints, bare_trait_objects)]
    format: Box<Fn(&mut Formatter, &Record) -> io::Result<()> + Sync + Send>,
}

/// `Builder` acts as builder for initializing a `Logger`.
///
/// It can be used to customize the log format, change the environment variable used
/// to provide the logging directives and also set the default log level filter.
///
/// # Examples
///
/// ```
/// #[macro_use]
/// extern crate log;
/// extern crate env_logger;
///
/// use std::env;
/// use std::io::Write;
/// use log::LevelFilter;
/// use env_logger::Builder;
///
/// fn main() {
///     let mut builder = Builder::from_default_env();
///
///     builder.format(|buf, record| writeln!(buf, "{} - {}", record.level(), record.args()))
///            .filter(None, LevelFilter::Info)
///            .init();
///
///     error!("error message");
///     info!("info message");
/// }
/// ```
#[derive(Default)]
pub struct Builder {
    filter: filter::Builder,
    writer: writer::Builder,
    format: fmt::Builder,
    built: bool,
}

impl Builder {
    /// Initializes the log builder with defaults.
    /// 
    /// **NOTE:** This method won't read from any environment variables.
    /// Use the [`filter`] and [`write_style`] methods to configure the builder
    /// or use [`from_env`] or [`from_default_env`] instead.
    /// 
    /// # Examples
    /// 
    /// Create a new builder and configure filters and style:
    /// 
    /// ```
    /// # extern crate log;
    /// # extern crate env_logger;
    /// # fn main() {
    /// use log::LevelFilter;
    /// use env_logger::{Builder, WriteStyle};
    /// 
    /// let mut builder = Builder::new();
    /// 
    /// builder.filter(None, LevelFilter::Info)
    ///        .write_style(WriteStyle::Always)
    ///        .init();
    /// # }
    /// ```
    /// 
    /// [`filter`]: #method.filter
    /// [`write_style`]: #method.write_style
    /// [`from_env`]: #method.from_env
    /// [`from_default_env`]: #method.from_default_env
    pub fn new() -> Builder {
        Default::default()
    }

    /// Initializes the log builder from the environment.
    ///
    /// The variables used to read configuration from can be tweaked before
    /// passing in.
    ///
    /// # Examples
    /// 
    /// Initialise a logger reading the log filter from an environment variable
    /// called `MY_LOG`:
    /// 
    /// ```
    /// use env_logger::Builder;
    /// 
    /// let mut builder = Builder::from_env("MY_LOG");
    /// builder.init();
    /// ```
    ///
    /// Initialise a logger using the `MY_LOG` variable for filtering and
    /// `MY_LOG_STYLE` for whether or not to write styles:
    ///
    /// ```
    /// use env_logger::{Builder, Env};
    ///
    /// let env = Env::new().filter("MY_LOG").write_style("MY_LOG_STYLE");
    ///
    /// let mut builder = Builder::from_env(env);
    /// builder.init();
    /// ```
    pub fn from_env<'a, E>(env: E) -> Self
    where
        E: Into<Env<'a>>
    {
        let mut builder = Builder::new();
        let env = env.into();

        if let Some(s) = env.get_filter() {
            builder.parse_filters(&s);
        }

        if let Some(s) = env.get_write_style() {
            builder.parse_write_style(&s);
        }

        builder
    }

    /// Initializes the log builder from the environment using default variable names.
    /// 
    /// This method is a convenient way to call `from_env(Env::default())` without
    /// having to use the `Env` type explicitly. The builder will use the
    /// [default environment variables].
    /// 
    /// # Examples
    /// 
    /// Initialise a logger using the default environment variables:
    /// 
    /// ```
    /// use env_logger::Builder;
    /// 
    /// let mut builder = Builder::from_default_env();
    /// builder.init();
    /// ```
    ///
    /// [default environment variables]: struct.Env.html#default-environment-variables
    pub fn from_default_env() -> Self {
        Self::from_env(Env::default())
    }

    /// Sets the format function for formatting the log output.
    ///
    /// This function is called on each record logged and should format the
    /// log record and output it to the given [`Formatter`].
    ///
    /// The format function is expected to output the string directly to the
    /// `Formatter` so that implementations can use the [`std::fmt`] macros
    /// to format and output without intermediate heap allocations. The default
    /// `env_logger` formatter takes advantage of this.
    /// 
    /// # Examples
    /// 
    /// Use a custom format to write only the log message:
    /// 
    /// ```
    /// use std::io::Write;
    /// use env_logger::Builder;
    /// 
    /// let mut builder = Builder::new();
    /// 
    /// builder.format(|buf, record| writeln!(buf, "{}", record.args()));
    /// ```
    ///
    /// [`Formatter`]: fmt/struct.Formatter.html
    /// [`String`]: https://doc.rust-lang.org/stable/std/string/struct.String.html
    /// [`std::fmt`]: https://doc.rust-lang.org/std/fmt/index.html
    pub fn format<F: 'static>(&mut self, format: F) -> &mut Self
        where F: Fn(&mut Formatter, &Record) -> io::Result<()> + Sync + Send
    {
        self.format.custom_format = Some(Box::new(format));
        self
    }

    /// Use the default format.
    /// 
    /// This method will clear any custom format set on the builder.
    pub fn default_format(&mut self) -> &mut Self {
        self.format.custom_format = None;
        self
    }

    /// Whether or not to write the level in the default format.
    pub fn default_format_level(&mut self, write: bool) -> &mut Self {
        self.format.default_format_level = write;
        self
    }

    /// Whether or not to write the module path in the default format.
    pub fn default_format_module_path(&mut self, write: bool) -> &mut Self {
        self.format.default_format_module_path = write;
        self
    }

    /// Whether or not to write the timestamp in the default format.
    pub fn default_format_timestamp(&mut self, write: bool) -> &mut Self {
        self.format.default_format_timestamp = write;
        self
    }

    /// Whether or not to write the timestamp with nanos.
    pub fn default_format_timestamp_nanos(&mut self, write: bool) -> &mut Self {
        self.format.default_format_timestamp_nanos = write;
        self
    }

    /// Adds a directive to the filter for a specific module.
    ///
    /// # Examples
    ///
    /// Only include messages for warning and above for logs in `path::to::module`:
    ///
    /// ```
    /// # extern crate log;
    /// # extern crate env_logger;
    /// # fn main() {
    /// use log::LevelFilter;
    /// use env_logger::Builder;
    ///
    /// let mut builder = Builder::new();
    ///
    /// builder.filter_module("path::to::module", LevelFilter::Info);
    /// # }
    /// ```
    pub fn filter_module(&mut self, module: &str, level: LevelFilter) -> &mut Self {
        self.filter.filter_module(module, level);
        self
    }

    /// Adds a directive to the filter for all modules.
    ///
    /// # Examples
    ///
    /// Only include messages for warning and above for logs in `path::to::module`:
    ///
    /// ```
    /// # extern crate log;
    /// # extern crate env_logger;
    /// # fn main() {
    /// use log::LevelFilter;
    /// use env_logger::Builder;
    ///
    /// let mut builder = Builder::new();
    ///
    /// builder.filter_level(LevelFilter::Info);
    /// # }
    /// ```
    pub fn filter_level(&mut self, level: LevelFilter) -> &mut Self {
        self.filter.filter_level(level);
        self
    }

    /// Adds filters to the logger.
    ///
    /// The given module (if any) will log at most the specified level provided.
    /// If no module is provided then the filter will apply to all log messages.
    /// 
    /// # Examples
    /// 
    /// Only include messages for warning and above for logs in `path::to::module`:
    /// 
    /// ```
    /// # extern crate log;
    /// # extern crate env_logger;
    /// # fn main() {
    /// use log::LevelFilter;
    /// use env_logger::Builder;
    /// 
    /// let mut builder = Builder::new();
    /// 
    /// builder.filter(Some("path::to::module"), LevelFilter::Info);
    /// # }
    /// ```
    pub fn filter(&mut self,
                  module: Option<&str>,
                  level: LevelFilter) -> &mut Self {
        self.filter.filter(module, level);
        self
    }

    /// Parses the directives string in the same form as the `RUST_LOG`
    /// environment variable.
    ///
    /// See the module documentation for more details.
    #[deprecated(since = "0.6.1", note = "use `parse_filters` instead.")]
    pub fn parse(&mut self, filters: &str) -> &mut Self {
        self.parse_filters(filters)
    }

    /// Parses the directives string in the same form as the `RUST_LOG`
    /// environment variable.
    ///
    /// See the module documentation for more details.
    pub fn parse_filters(&mut self, filters: &str) -> &mut Self {
        self.filter.parse(filters);
        self
    }

    /// Sets the target for the log output.
    ///
    /// Env logger can log to either stdout or stderr. The default is stderr.
    /// 
    /// # Examples
    /// 
    /// Write log message to `stdout`:
    /// 
    /// ```
    /// use env_logger::{Builder, Target};
    /// 
    /// let mut builder = Builder::new();
    /// 
    /// builder.target(Target::Stdout);
    /// ```
    pub fn target(&mut self, target: fmt::Target) -> &mut Self {
        self.writer.target(target);
        self
    }

    /// Sets whether or not styles will be written.
    ///
    /// This can be useful in environments that don't support control characters
    /// for setting colors.
    /// 
    /// # Examples
    /// 
    /// Never attempt to write styles:
    /// 
    /// ```
    /// use env_logger::{Builder, WriteStyle};
    /// 
    /// let mut builder = Builder::new();
    /// 
    /// builder.write_style(WriteStyle::Never);
    /// ```
    pub fn write_style(&mut self, write_style: fmt::WriteStyle) -> &mut Self {
        self.writer.write_style(write_style);
        self
    }

    /// Parses whether or not to write styles in the same form as the `RUST_LOG_STYLE`
    /// environment variable.
    ///
    /// See the module documentation for more details.
    pub fn parse_write_style(&mut self, write_style: &str) -> &mut Self {
        self.writer.parse_write_style(write_style);
        self
    }

    /// Sets whether or not the logger will be used in unit tests.
    /// 
    /// If `is_test` is `true` then the logger will allow the testing framework to
    /// capture log records rather than printing them to the terminal directly.
    pub fn is_test(&mut self, is_test: bool) -> &mut Self {
        self.writer.is_test(is_test);
        self
    }

    /// Initializes the global logger with the built env logger.
    ///
    /// This should be called early in the execution of a Rust program. Any log
    /// events that occur before initialization will be ignored.
    ///
    /// # Errors
    ///
    /// This function will fail if it is called more than once, or if another
    /// library has already initialized a global logger.
    pub fn try_init(&mut self) -> Result<(), SetLoggerError> {
        let logger = self.build();

        let max_level = logger.filter();
        let r = log::set_boxed_logger(Box::new(logger));

        if r.is_ok() {
            log::set_max_level(max_level);
        }

        r
    }

    /// Initializes the global logger with the built env logger.
    ///
    /// This should be called early in the execution of a Rust program. Any log
    /// events that occur before initialization will be ignored.
    ///
    /// # Panics
    ///
    /// This function will panic if it is called more than once, or if another
    /// library has already initialized a global logger.
    pub fn init(&mut self) {
        self.try_init().expect("Builder::init should not be called after logger initialized");
    }

    /// Build an env logger.
    ///
    /// The returned logger implements the `Log` trait and can be installed manually
    /// or nested within another logger.
    pub fn build(&mut self) -> Logger {
        assert!(!self.built, "attempt to re-use consumed builder");
        self.built = true;

        Logger {
            writer: self.writer.build(),
            filter: self.filter.build(),
            format: self.format.build(),
        }
    }
}

impl Logger {
    /// Creates the logger from the environment.
    ///
    /// The variables used to read configuration from can be tweaked before
    /// passing in.
    ///
    /// # Examples
    ///
    /// Create a logger reading the log filter from an environment variable
    /// called `MY_LOG`:
    ///
    /// ```
    /// use env_logger::Logger;
    ///
    /// let logger = Logger::from_env("MY_LOG");
    /// ```
    ///
    /// Create a logger using the `MY_LOG` variable for filtering and
    /// `MY_LOG_STYLE` for whether or not to write styles:
    ///
    /// ```
    /// use env_logger::{Logger, Env};
    ///
    /// let env = Env::new().filter_or("MY_LOG", "info").write_style_or("MY_LOG_STYLE", "always");
    ///
    /// let logger = Logger::from_env(env);
    /// ```
    pub fn from_env<'a, E>(env: E) -> Self
        where
            E: Into<Env<'a>>
    {
        Builder::from_env(env).build()
    }

    /// Creates the logger from the environment using default variable names.
    ///
    /// This method is a convenient way to call `from_env(Env::default())` without
    /// having to use the `Env` type explicitly. The logger will use the
    /// [default environment variables].
    ///
    /// # Examples
    ///
    /// Creates a logger using the default environment variables:
    ///
    /// ```
    /// use env_logger::Logger;
    ///
    /// let logger = Logger::from_default_env();
    /// ```
    ///
    /// [default environment variables]: struct.Env.html#default-environment-variables
    pub fn from_default_env() -> Self {
        Builder::from_default_env().build()
    }

    /// Returns the maximum `LevelFilter` that this env logger instance is
    /// configured to output.
    pub fn filter(&self) -> LevelFilter {
        self.filter.filter()
    }

    /// Checks if this record matches the configured filter.
    pub fn matches(&self, record: &Record) -> bool {
        self.filter.matches(record)
    }
}

impl Log for Logger {
    fn enabled(&self, metadata: &Metadata) -> bool {
        self.filter.enabled(metadata)
    }

    fn log(&self, record: &Record) {
        if self.matches(record) {
            // Log records are written to a thread-local buffer before being printed
            // to the terminal. We clear these buffers afterwards, but they aren't shrinked
            // so will always at least have capacity for the largest log record formatted
            // on that thread.
            //
            // If multiple `Logger`s are used by the same threads then the thread-local
            // formatter might have different color support. If this is the case the
            // formatter and its buffer are discarded and recreated.

            thread_local! {
                static FORMATTER: RefCell<Option<Formatter>> = RefCell::new(None);
            }

            FORMATTER.with(|tl_buf| {
                // It's possible for implementations to sometimes
                // log-while-logging (e.g. a `std::fmt` implementation logs
                // internally) but it's super rare. If this happens make sure we
                // at least don't panic and ship some output to the screen.
                let mut a;
                let mut b = None;
                let tl_buf = match tl_buf.try_borrow_mut() {
                    Ok(f) => {
                        a = f;
                        &mut *a
                    }
                    Err(_) => &mut b,
                };

                // Check the buffer style. If it's different from the logger's
                // style then drop the buffer and recreate it.
                match *tl_buf {
                    Some(ref mut formatter) => {
                        if formatter.write_style() != self.writer.write_style() {
                            *formatter = Formatter::new(&self.writer)
                        }
                    },
                    ref mut tl_buf => *tl_buf = Some(Formatter::new(&self.writer))
                }

                // The format is guaranteed to be `Some` by this point
                let mut formatter = tl_buf.as_mut().unwrap();

                let _ = (self.format)(&mut formatter, record).and_then(|_| formatter.print(&self.writer));

                // Always clear the buffer afterwards
                formatter.clear();
            });
        }
    }

    fn flush(&self) {}
}

impl<'a> Env<'a> {
    /// Get a default set of environment variables.
    pub fn new() -> Self {
        Self::default()
    }

    /// Specify an environment variable to read the filter from.
    pub fn filter<E>(mut self, filter_env: E) -> Self
    where
        E: Into<Cow<'a, str>>
    {
        self.filter = Var::new(filter_env);

        self
    }

    /// Specify an environment variable to read the filter from.
    ///
    /// If the variable is not set, the default value will be used.
    pub fn filter_or<E, V>(mut self, filter_env: E, default: V) -> Self
    where
        E: Into<Cow<'a, str>>,
        V: Into<Cow<'a, str>>,
    {
        self.filter = Var::new_with_default(filter_env, default);

        self
    }

    /// Use the default environment variable to read the filter from.
    /// 
    /// If the variable is not set, the default value will be used.
    pub fn default_filter_or<V>(mut self, default: V) -> Self
    where
        V: Into<Cow<'a, str>>,
    {
        self.filter = Var::new_with_default(DEFAULT_FILTER_ENV, default);

        self
    }

    fn get_filter(&self) -> Option<String> {
        self.filter.get()
    }

    /// Specify an environment variable to read the style from.
    pub fn write_style<E>(mut self, write_style_env: E) -> Self
    where
        E: Into<Cow<'a, str>>
    {
        self.write_style = Var::new(write_style_env);

        self
    }

    /// Specify an environment variable to read the style from.
    ///
    /// If the variable is not set, the default value will be used.
    pub fn write_style_or<E, V>(mut self, write_style_env: E, default: V) -> Self
        where
            E: Into<Cow<'a, str>>,
            V: Into<Cow<'a, str>>,
    {
        self.write_style = Var::new_with_default(write_style_env, default);

        self
    }

    /// Use the default environment variable to read the style from.
    ///
    /// If the variable is not set, the default value will be used.
    pub fn default_write_style_or<V>(mut self, default: V) -> Self
        where
            V: Into<Cow<'a, str>>,
    {
        self.write_style = Var::new_with_default(DEFAULT_WRITE_STYLE_ENV, default);

        self
    }

    fn get_write_style(&self) -> Option<String> {
        self.write_style.get()
    }
}

impl<'a> Var<'a> {
    fn new<E>(name: E) -> Self
        where
            E: Into<Cow<'a, str>>,
    {
        Var {
            name: name.into(),
            default: None,
        }
    }

    fn new_with_default<E, V>(name: E, default: V) -> Self
    where
        E: Into<Cow<'a, str>>,
        V: Into<Cow<'a, str>>,
    {
        Var {
            name: name.into(),
            default: Some(default.into()),
        }
    }

    fn get(&self) -> Option<String> {
        env::var(&*self.name)
            .ok()
            .or_else(|| self.default
                .to_owned()
                .map(|v| v.into_owned()))
    }
}

impl<'a, T> From<T> for Env<'a>
where
    T: Into<Cow<'a, str>>
{
    fn from(filter_env: T) -> Self {
        Env::default().filter(filter_env.into())
    }
}

impl<'a> Default for Env<'a> {
    fn default() -> Self {
        Env {
            filter: Var::new(DEFAULT_FILTER_ENV),
            write_style: Var::new(DEFAULT_WRITE_STYLE_ENV),
        }
    }
}

mod std_fmt_impls {
    use std::fmt;
    use super::*;

    impl fmt::Debug for Logger{
        fn fmt(&self, f: &mut fmt::Formatter)->fmt::Result {
            f.debug_struct("Logger")
                .field("filter", &self.filter)
                .finish()
        }
    }

    impl fmt::Debug for Builder{
        fn fmt(&self, f: &mut fmt::Formatter)->fmt::Result {
            if self.built {
                f.debug_struct("Logger")
                .field("built", &true)
                .finish()
            } else {
                f.debug_struct("Logger")
                .field("filter", &self.filter)
                .field("writer", &self.writer)
                .finish()
            }
        }
    }
}

/// Attempts to initialize the global logger with an env logger.
///
/// This should be called early in the execution of a Rust program. Any log
/// events that occur before initialization will be ignored.
///
/// # Errors
///
/// This function will fail if it is called more than once, or if another
/// library has already initialized a global logger.
pub fn try_init() -> Result<(), SetLoggerError> {
    try_init_from_env(Env::default())
}

/// Initializes the global logger with an env logger.
///
/// This should be called early in the execution of a Rust program. Any log
/// events that occur before initialization will be ignored.
///
/// # Panics
///
/// This function will panic if it is called more than once, or if another
/// library has already initialized a global logger.
pub fn init() {
    try_init().expect("env_logger::init should not be called after logger initialized");
}

/// Attempts to initialize the global logger with an env logger from the given
/// environment variables.
///
/// This should be called early in the execution of a Rust program. Any log
/// events that occur before initialization will be ignored.
///
/// # Examples
///
/// Initialise a logger using the `MY_LOG` environment variable for filters
/// and `MY_LOG_STYLE` for writing colors:
///
/// ```
/// # extern crate env_logger;
/// use env_logger::{Builder, Env};
///
/// # fn run() -> Result<(), Box<::std::error::Error>> {
/// let env = Env::new().filter("MY_LOG").write_style("MY_LOG_STYLE");
///
/// env_logger::try_init_from_env(env)?;
///
/// Ok(())
/// # }
/// # fn main() { run().unwrap(); }
/// ```
///
/// # Errors
///
/// This function will fail if it is called more than once, or if another
/// library has already initialized a global logger.
pub fn try_init_from_env<'a, E>(env: E) -> Result<(), SetLoggerError>
where
    E: Into<Env<'a>>
{
    let mut builder = Builder::from_env(env);

    builder.try_init()
}

/// Initializes the global logger with an env logger from the given environment
/// variables.
///
/// This should be called early in the execution of a Rust program. Any log
/// events that occur before initialization will be ignored.
///
/// # Examples
///
/// Initialise a logger using the `MY_LOG` environment variable for filters
/// and `MY_LOG_STYLE` for writing colors:
///
/// ```
/// use env_logger::{Builder, Env};
///
/// let env = Env::new().filter("MY_LOG").write_style("MY_LOG_STYLE");
///
/// env_logger::init_from_env(env);
/// ```
///
/// # Panics
///
/// This function will panic if it is called more than once, or if another
/// library has already initialized a global logger.
pub fn init_from_env<'a, E>(env: E)
where
    E: Into<Env<'a>>
{
    try_init_from_env(env).expect("env_logger::init_from_env should not be called after logger initialized");
}

/// Create a new builder with the default environment variables.
/// 
/// The builder can be configured before being initialized.
pub fn builder() -> Builder {
    Builder::from_default_env()
}

/// Create a builder from the given environment variables.
/// 
/// The builder can be configured before being initialized.
pub fn from_env<'a, E>(env: E) -> Builder
where
    E: Into<Env<'a>>
{
    Builder::from_env(env)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn env_get_filter_reads_from_var_if_set() {
        env::set_var("env_get_filter_reads_from_var_if_set", "from var");

        let env = Env::new().filter_or("env_get_filter_reads_from_var_if_set", "from default");

        assert_eq!(Some("from var".to_owned()), env.get_filter());
    }

    #[test]
    fn env_get_filter_reads_from_default_if_var_not_set() {
        env::remove_var("env_get_filter_reads_from_default_if_var_not_set");

        let env = Env::new().filter_or("env_get_filter_reads_from_default_if_var_not_set", "from default");

        assert_eq!(Some("from default".to_owned()), env.get_filter());
    }

    #[test]
    fn env_get_write_style_reads_from_var_if_set() {
        env::set_var("env_get_write_style_reads_from_var_if_set", "from var");

        let env = Env::new().write_style_or("env_get_write_style_reads_from_var_if_set", "from default");

        assert_eq!(Some("from var".to_owned()), env.get_write_style());
    }

    #[test]
    fn env_get_write_style_reads_from_default_if_var_not_set() {
        env::remove_var("env_get_write_style_reads_from_default_if_var_not_set");

        let env = Env::new().write_style_or("env_get_write_style_reads_from_default_if_var_not_set", "from default");

        assert_eq!(Some("from default".to_owned()), env.get_write_style());
    }
}
