use std::borrow::Cow;
use std::fmt;
use std::io::{self, Write};
use std::cell::RefCell;
use std::rc::Rc;

use log::Level;
use termcolor::{self, ColorChoice, ColorSpec, WriteColor};

use ::WriteStyle;
use ::fmt::{Formatter, Target};

pub(in ::fmt::writer) mod glob {
    pub use super::*;
}

impl Formatter {
    /// Begin a new [`Style`].
    ///
    /// # Examples
    ///
    /// Create a bold, red colored style and use it to print the log level:
    ///
    /// ```
    /// use std::io::Write;
    /// use env_logger::fmt::Color;
    ///
    /// let mut builder = env_logger::Builder::new();
    ///
    /// builder.format(|buf, record| {
    ///     let mut level_style = buf.style();
    ///
    ///     level_style.set_color(Color::Red).set_bold(true);
    ///
    ///     writeln!(buf, "{}: {}",
    ///         level_style.value(record.level()),
    ///         record.args())
    /// });
    /// ```
    ///
    /// [`Style`]: struct.Style.html
    pub fn style(&self) -> Style {
        Style {
            buf: self.buf.clone(),
            spec: ColorSpec::new(),
        }
    }

    /// Get the default [`Style`] for the given level.
    /// 
    /// The style can be used to print other values besides the level.
    pub fn default_level_style(&self, level: Level) -> Style {
        let mut level_style = self.style();
        match level {
            Level::Trace => level_style.set_color(Color::Black).set_intense(true),
            Level::Debug => level_style.set_color(Color::White),
            Level::Info => level_style.set_color(Color::Green),
            Level::Warn => level_style.set_color(Color::Yellow),
            Level::Error => level_style.set_color(Color::Red).set_bold(true),
        };
        level_style
    }

    /// Get a printable [`Style`] for the given level.
    /// 
    /// The style can only be used to print the level.
    pub fn default_styled_level(&self, level: Level) -> StyledValue<'static, Level> {
        self.default_level_style(level).into_value(level)
    }
}

pub(in ::fmt::writer) struct BufferWriter {
    inner: termcolor::BufferWriter,
    test_target: Option<Target>,
}

pub(in ::fmt) struct Buffer {
    inner: termcolor::Buffer,
    test_target: Option<Target>,
}

impl BufferWriter {
    pub(in ::fmt::writer) fn stderr(is_test: bool, write_style: WriteStyle) -> Self {
        BufferWriter {
            inner: termcolor::BufferWriter::stderr(write_style.into_color_choice()),
            test_target: if is_test {
                Some(Target::Stderr)
            } else {
                None
            },
        }
    }

    pub(in ::fmt::writer) fn stdout(is_test: bool, write_style: WriteStyle) -> Self {
        BufferWriter {
            inner: termcolor::BufferWriter::stdout(write_style.into_color_choice()),
            test_target: if is_test {
                Some(Target::Stdout)
            } else {
                None
            },
        }
    }

    pub(in ::fmt::writer) fn buffer(&self) -> Buffer {
        Buffer {
            inner: self.inner.buffer(),
            test_target: self.test_target,
        }
    }

    pub(in ::fmt::writer) fn print(&self, buf: &Buffer) -> io::Result<()> {
        if let Some(target) = self.test_target {
            // This impl uses the `eprint` and `print` macros
            // instead of `termcolor`'s buffer.
            // This is so their output can be captured by `cargo test`
            let log = String::from_utf8_lossy(buf.bytes());

            match target {
                Target::Stderr => eprint!("{}", log),
                Target::Stdout => print!("{}", log),
            }

            Ok(())
        } else {
            self.inner.print(&buf.inner)
        }
    }
}

impl Buffer {
    pub(in ::fmt) fn clear(&mut self) {
        self.inner.clear()
    }

    pub(in ::fmt) fn write(&mut self, buf: &[u8]) -> io::Result<usize> {
        self.inner.write(buf)
    }

    pub(in ::fmt) fn flush(&mut self) -> io::Result<()> {
        self.inner.flush()
    }

    pub(in ::fmt) fn bytes(&self) -> &[u8] {
        self.inner.as_slice()
    }

    fn set_color(&mut self, spec: &ColorSpec) -> io::Result<()> {
        // Ignore styles for test captured logs because they can't be printed
        if self.test_target.is_none() {
            self.inner.set_color(spec)
        } else {
            Ok(())
        }
    }

    fn reset(&mut self) -> io::Result<()> {
        // Ignore styles for test captured logs because they can't be printed
        if self.test_target.is_none() {
            self.inner.reset()
        } else {
            Ok(())
        }
    }
}

impl WriteStyle {
    fn into_color_choice(self) -> ColorChoice {
        match self {
            WriteStyle::Always => ColorChoice::Always,
            WriteStyle::Auto => ColorChoice::Auto,
            WriteStyle::Never => ColorChoice::Never,
        }
    }
}

/// A set of styles to apply to the terminal output.
///
/// Call [`Formatter::style`] to get a `Style` and use the builder methods to
/// set styling properties, like [color] and [weight].
/// To print a value using the style, wrap it in a call to [`value`] when the log
/// record is formatted.
///
/// # Examples
///
/// Create a bold, red colored style and use it to print the log level:
///
/// ```
/// use std::io::Write;
/// use env_logger::fmt::Color;
///
/// let mut builder = env_logger::Builder::new();
///
/// builder.format(|buf, record| {
///     let mut level_style = buf.style();
///
///     level_style.set_color(Color::Red).set_bold(true);
///
///     writeln!(buf, "{}: {}",
///         level_style.value(record.level()),
///         record.args())
/// });
/// ```
///
/// Styles can be re-used to output multiple values:
///
/// ```
/// use std::io::Write;
/// use env_logger::fmt::Color;
///
/// let mut builder = env_logger::Builder::new();
///
/// builder.format(|buf, record| {
///     let mut bold = buf.style();
///
///     bold.set_bold(true);
///
///     writeln!(buf, "{}: {} {}",
///         bold.value(record.level()),
///         bold.value("some bold text"),
///         record.args())
/// });
/// ```
///
/// [`Formatter::style`]: struct.Formatter.html#method.style
/// [color]: #method.set_color
/// [weight]: #method.set_bold
/// [`value`]: #method.value
#[derive(Clone)]
pub struct Style {
    buf: Rc<RefCell<Buffer>>,
    spec: ColorSpec,
}

/// A value that can be printed using the given styles.
///
/// It is the result of calling [`Style::value`].
///
/// [`Style::value`]: struct.Style.html#method.value
pub struct StyledValue<'a, T> {
    style: Cow<'a, Style>,
    value: T,
}

impl Style {
    /// Set the text color.
    ///
    /// # Examples
    ///
    /// Create a style with red text:
    ///
    /// ```
    /// use std::io::Write;
    /// use env_logger::fmt::Color;
    ///
    /// let mut builder = env_logger::Builder::new();
    ///
    /// builder.format(|buf, record| {
    ///     let mut style = buf.style();
    ///
    ///     style.set_color(Color::Red);
    ///
    ///     writeln!(buf, "{}", style.value(record.args()))
    /// });
    /// ```
    pub fn set_color(&mut self, color: Color) -> &mut Style {
        self.spec.set_fg(color.into_termcolor());
        self
    }

    /// Set the text weight.
    ///
    /// If `yes` is true then text will be written in bold.
    /// If `yes` is false then text will be written in the default weight.
    ///
    /// # Examples
    ///
    /// Create a style with bold text:
    ///
    /// ```
    /// use std::io::Write;
    ///
    /// let mut builder = env_logger::Builder::new();
    ///
    /// builder.format(|buf, record| {
    ///     let mut style = buf.style();
    ///
    ///     style.set_bold(true);
    ///
    ///     writeln!(buf, "{}", style.value(record.args()))
    /// });
    /// ```
    pub fn set_bold(&mut self, yes: bool) -> &mut Style {
        self.spec.set_bold(yes);
        self
    }

    /// Set the text intensity.
    ///
    /// If `yes` is true then text will be written in a brighter color.
    /// If `yes` is false then text will be written in the default color.
    ///
    /// # Examples
    ///
    /// Create a style with intense text:
    ///
    /// ```
    /// use std::io::Write;
    ///
    /// let mut builder = env_logger::Builder::new();
    ///
    /// builder.format(|buf, record| {
    ///     let mut style = buf.style();
    ///
    ///     style.set_intense(true);
    ///
    ///     writeln!(buf, "{}", style.value(record.args()))
    /// });
    /// ```
    pub fn set_intense(&mut self, yes: bool) -> &mut Style {
        self.spec.set_intense(yes);
        self
    }

    /// Set the background color.
    ///
    /// # Examples
    ///
    /// Create a style with a yellow background:
    ///
    /// ```
    /// use std::io::Write;
    /// use env_logger::fmt::Color;
    ///
    /// let mut builder = env_logger::Builder::new();
    ///
    /// builder.format(|buf, record| {
    ///     let mut style = buf.style();
    ///
    ///     style.set_bg(Color::Yellow);
    ///
    ///     writeln!(buf, "{}", style.value(record.args()))
    /// });
    /// ```
    pub fn set_bg(&mut self, color: Color) -> &mut Style {
        self.spec.set_bg(color.into_termcolor());
        self
    }

    /// Wrap a value in the style.
    ///
    /// The same `Style` can be used to print multiple different values.
    ///
    /// # Examples
    ///
    /// Create a bold, red colored style and use it to print the log level:
    ///
    /// ```
    /// use std::io::Write;
    /// use env_logger::fmt::Color;
    ///
    /// let mut builder = env_logger::Builder::new();
    ///
    /// builder.format(|buf, record| {
    ///     let mut style = buf.style();
    ///
    ///     style.set_color(Color::Red).set_bold(true);
    ///
    ///     writeln!(buf, "{}: {}",
    ///         style.value(record.level()),
    ///         record.args())
    /// });
    /// ```
    pub fn value<T>(&self, value: T) -> StyledValue<T> {
        StyledValue {
            style: Cow::Borrowed(self),
            value
        }
    }

    /// Wrap a value in the style by taking ownership of it.
    pub(crate) fn into_value<T>(&mut self, value: T) -> StyledValue<'static, T> {
        StyledValue {
            style: Cow::Owned(self.clone()),
            value
        }
    }
}

impl<'a, T> StyledValue<'a, T> {
    fn write_fmt<F>(&self, f: F) -> fmt::Result
    where
        F: FnOnce() -> fmt::Result,
    {
        self.style.buf.borrow_mut().set_color(&self.style.spec).map_err(|_| fmt::Error)?;

        // Always try to reset the terminal style, even if writing failed
        let write = f();
        let reset = self.style.buf.borrow_mut().reset().map_err(|_| fmt::Error);

        write.and(reset)
    }
}

impl fmt::Debug for Style {
    fn fmt(&self, f: &mut fmt::Formatter)->fmt::Result {
        f.debug_struct("Style").field("spec", &self.spec).finish()
    }
}

macro_rules! impl_styled_value_fmt {
    ($($fmt_trait:path),*) => {
        $(
            impl<'a, T: $fmt_trait> $fmt_trait for StyledValue<'a, T> {
                fn fmt(&self, f: &mut fmt::Formatter)->fmt::Result {
                    self.write_fmt(|| T::fmt(&self.value, f))
                }
            }
        )*
    };
}

impl_styled_value_fmt!(
    fmt::Debug,
    fmt::Display,
    fmt::Pointer,
    fmt::Octal,
    fmt::Binary,
    fmt::UpperHex,
    fmt::LowerHex,
    fmt::UpperExp,
    fmt::LowerExp);

// The `Color` type is copied from https://github.com/BurntSushi/ripgrep/tree/master/termcolor

/// The set of available colors for the terminal foreground/background.
///
/// The `Ansi256` and `Rgb` colors will only output the correct codes when
/// paired with the `Ansi` `WriteColor` implementation.
///
/// The `Ansi256` and `Rgb` color types are not supported when writing colors
/// on Windows using the console. If they are used on Windows, then they are
/// silently ignored and no colors will be emitted.
///
/// This set may expand over time.
///
/// This type has a `FromStr` impl that can parse colors from their human
/// readable form. The format is as follows:
///
/// 1. Any of the explicitly listed colors in English. They are matched
///    case insensitively.
/// 2. A single 8-bit integer, in either decimal or hexadecimal format.
/// 3. A triple of 8-bit integers separated by a comma, where each integer is
///    in decimal or hexadecimal format.
///
/// Hexadecimal numbers are written with a `0x` prefix.
#[allow(missing_docs)]
#[derive(Clone, Debug, Eq, PartialEq)]
pub enum Color {
    Black,
    Blue,
    Green,
    Red,
    Cyan,
    Magenta,
    Yellow,
    White,
    Ansi256(u8),
    Rgb(u8, u8, u8),
    #[doc(hidden)]
    __Nonexhaustive,
}

impl Color {
    fn into_termcolor(self) -> Option<termcolor::Color> {
        match self {
            Color::Black => Some(termcolor::Color::Black),
            Color::Blue => Some(termcolor::Color::Blue),
            Color::Green => Some(termcolor::Color::Green),
            Color::Red => Some(termcolor::Color::Red),
            Color::Cyan => Some(termcolor::Color::Cyan),
            Color::Magenta => Some(termcolor::Color::Magenta),
            Color::Yellow => Some(termcolor::Color::Yellow),
            Color::White => Some(termcolor::Color::White),
            Color::Ansi256(value) => Some(termcolor::Color::Ansi256(value)),
            Color::Rgb(r, g, b) => Some(termcolor::Color::Rgb(r, g, b)),
            _ => None,
        }
    }
}
