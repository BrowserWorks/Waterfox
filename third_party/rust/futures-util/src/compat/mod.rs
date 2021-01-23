//! Futures 0.1 / 0.3 shims
//!
//! This module is only available when the `compat` feature of this
//! library is activated.

mod executor;
pub use self::executor::{Executor01CompatExt, Executor01Future, Executor01As03};

mod compat01as03;
pub use self::compat01as03::{Compat01As03, Future01CompatExt, Stream01CompatExt};
#[cfg(feature = "sink")]
pub use self::compat01as03::{Compat01As03Sink, Sink01CompatExt};
#[cfg(feature = "io-compat")]
pub use self::compat01as03::{AsyncRead01CompatExt, AsyncWrite01CompatExt};

mod compat03as01;
pub use self::compat03as01::Compat;
#[cfg(feature = "sink")]
pub use self::compat03as01::CompatSink;
