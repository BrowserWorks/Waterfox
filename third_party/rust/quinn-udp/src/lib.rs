//! Uniform interface to send and receive UDP packets with advanced features useful for QUIC
//!
//! This crate exposes kernel UDP stack features available on most modern systems which are required
//! for an efficient and conformant QUIC implementation. As of this writing, these are not available
//! in std or major async runtimes, and their niche character and complexity are a barrier to adding
//! them. Hence, a dedicated crate.
//!
//! Exposed features include:
//!
//! - Segmentation offload for bulk send and receive operations, reducing CPU load.
//! - Reporting the exact destination address of received packets and specifying explicit source
//!   addresses for sent packets, allowing responses to be sent from the address that the peer
//!   expects when there are multiple possibilities. This is common when bound to a wildcard address
//!   in IPv6 due to [RFC 8981] temporary addresses.
//! - [Explicit Congestion Notification], which is required by QUIC to prevent packet loss and reduce
//!   latency on congested links when supported by the network path.
//! - Disabled IP-layer fragmentation, which allows the true physical MTU to be detected and reduces
//!   risk of QUIC packet loss.
//!
//! Some features are unavailable in some environments. This can be due to an outdated operating
//! system or drivers. Some operating systems may not implement desired features at all, or may not
//! yet be supported by the crate. When support is unavailable, functionality will gracefully
//! degrade.
//!
//! [RFC 8981]: https://www.rfc-editor.org/rfc/rfc8981.html
//! [Explicit Congestion Notification]: https://www.rfc-editor.org/rfc/rfc3168.html
#![warn(unreachable_pub)]
#![warn(clippy::use_self)]

use core::time::Duration;
#[cfg(any(unix, target_os = "wasi"))]
use std::os::fd::AsFd;
#[cfg(windows)]
use std::os::windows::io::AsSocket;
use std::{
    io,
    net::{IpAddr, Ipv6Addr, SocketAddr},
};
#[cfg(target_os = "wasi")]
use std::{
    mem::ManuallyDrop,
    net::UdpSocket,
    os::fd::{AsRawFd, FromRawFd},
};
#[cfg(not(wasm_browser))]
use std::{sync::Mutex, time::Instant};
#[cfg(windows)]
use windows_sys::Win32::Networking::WinSock;

#[cfg(apple_fast)]
mod apple_fast;

#[cfg(any(unix, windows))]
mod cmsg;

#[cfg(unix)]
#[path = "unix.rs"]
mod imp;

#[cfg(any(target_os = "linux", target_os = "android"))]
mod linux;

#[cfg(windows)]
#[path = "windows.rs"]
mod imp;

#[cfg(target_os = "wasi")]
#[path = "wasi.rs"]
mod imp;

#[allow(unused_imports, unused_macros)]
mod log {
    #[cfg(all(feature = "log", not(feature = "tracing-log")))]
    pub(crate) use log::{debug, error, info, trace, warn};

    #[cfg(feature = "tracing-log")]
    pub(crate) use tracing::{debug, error, info, trace, warn};

    #[cfg(not(any(feature = "log", feature = "tracing-log")))]
    mod no_op {
        macro_rules! trace    ( ($($tt:tt)*) => {{}} );
        macro_rules! debug    ( ($($tt:tt)*) => {{}} );
        macro_rules! info     ( ($($tt:tt)*) => {{}} );
        macro_rules! log_warn ( ($($tt:tt)*) => {{}} );
        macro_rules! error    ( ($($tt:tt)*) => {{}} );

        pub(crate) use {debug, error, info, log_warn as warn, trace};
    }

    #[cfg(not(any(feature = "log", feature = "tracing-log")))]
    pub(crate) use no_op::*;
}

#[cfg(not(wasm_browser))]
pub use imp::UdpSocketState;

/// Number of UDP packets to send/receive at a time
#[cfg(not(wasm_browser))]
pub const BATCH_SIZE: usize = imp::BATCH_SIZE;
/// Number of UDP packets to send/receive at a time
#[cfg(wasm_browser)]
pub const BATCH_SIZE: usize = 1;

/// Metadata for a single buffer filled with bytes received from the network
///
/// This associated buffer can contain one or more datagrams, see [`stride`].
///
/// [`stride`]: RecvMeta::stride
#[derive(Debug, Copy, Clone)]
#[non_exhaustive]
pub struct RecvMeta {
    /// The source address of the datagram(s) contained in the buffer
    pub addr: SocketAddr,
    /// The number of bytes the associated buffer has
    pub len: usize,
    /// The size of a single datagram in the associated buffer
    ///
    /// When GRO (Generic Receive Offload) is used this indicates the size of a single
    /// datagram inside the buffer. If the buffer is larger, that is if [`len`] is greater
    /// then this value, then the individual datagrams contained have their boundaries at
    /// `stride` increments from the start. The last datagram could be smaller than
    /// `stride`.
    ///
    /// [`len`]: RecvMeta::len
    pub stride: usize,
    /// The Explicit Congestion Notification bits for the datagram(s) in the buffer
    pub ecn: Option<EcnCodepoint>,
    /// The destination IP address which was encoded in this datagram
    ///
    /// Populated on platforms: Windows, Linux, Android (API level > 25),
    /// FreeBSD, OpenBSD, NetBSD, macOS, and iOS.
    pub dst_ip: Option<IpAddr>,
    /// The interface index of the interface on which the datagram was received
    pub interface_index: Option<u32>,
    /// Kernel receive timestamp as Unix epoch
    ///
    /// Populated on platforms: Linux, Android.
    pub timestamp: Option<Duration>,
}

impl Default for RecvMeta {
    /// Constructs a value with arbitrary fields, intended to be overwritten
    fn default() -> Self {
        Self {
            addr: SocketAddr::new(Ipv6Addr::UNSPECIFIED.into(), 0),
            len: 0,
            stride: 0,
            ecn: None,
            dst_ip: None,
            interface_index: None,
            timestamp: None,
        }
    }
}

/// An outgoing packet
#[derive(Debug, Clone)]
pub struct Transmit<'a> {
    /// The socket this datagram should be sent to
    pub destination: SocketAddr,
    /// Explicit congestion notification bits to set on the packet
    pub ecn: Option<EcnCodepoint>,
    /// Contents of the datagram
    pub contents: &'a [u8],
    /// The segment size if this transmission contains multiple datagrams.
    /// This is `None` if the transmit only contains a single datagram
    pub segment_size: Option<usize>,
    /// Optional source IP address for the datagram
    pub src_ip: Option<IpAddr>,
}

impl Transmit<'_> {
    /// Computes the effective segment-size of the packet.
    ///
    /// Some (older) network drivers don't like being told to do GSO even if
    /// there is effectively only a single segment.
    /// (i.e. `segment_size == contents.len()`)
    /// Additionally, a `segment_size` that is greater than the content also
    /// means there is effectively only a single segment.
    /// This case is actually quite common when splitting up a prepared GSO batch
    /// again after GSO has been disabled because the last datagram in a GSO
    /// batch is allowed to be smaller than the segment size.
    #[cfg_attr(apple_fast, allow(dead_code))] // Used by prepare_msg, which is unused when apple_fast
    fn effective_segment_size(&self) -> Option<usize> {
        match self.segment_size? {
            size if size >= self.contents.len() => None,
            size => Some(size),
        }
    }
}

/// Asynchronous transport-layer errors reported by the operating system
///
/// On Linux and Android these are delivered via the socket error queue
/// (`MSG_ERRQUEUE`) and originate from ICMP messages.
///
/// These errors are out-of-band and do not correspond to a received packet.
#[derive(Debug, Copy, Clone)]
#[non_exhaustive]
pub struct TransportError {
    /// Address associated with the error
    ///
    /// This is the remote peer or an intermediate network device that triggered the error.
    /// Returns `None` if the kernel cannot determine the source (e.g. `AF_UNSPEC`).
    pub addr: Option<SocketAddr>,
    /// Transport-layer error details
    pub payload: TransportErrorPayload,
    /// The raw error code from the underlying operating system
    pub raw_errno: i32,
}

impl TransportError {
    /// Returns the recommended MTU for packet-too-big errors
    pub fn mtu(&self) -> Option<u32> {
        match self.payload {
            TransportErrorPayload::TooBig { mtu } => Some(mtu),
            _ => None,
        }
    }
}

/// Transport-layer error details reported by the kernel
#[derive(Debug, Copy, Clone)]
#[non_exhaustive]
pub enum TransportErrorPayload {
    /// Destination host or port is unreachable
    Unreachable,
    /// Packet exceeds path MTU
    TooBig {
        /// Recommended Maximum Transmission Unit
        mtu: u32,
    },
    /// Other transport-layer or kernel-reported error
    Other,
}

/// Returns true if the given I/O error corresponds to a message size error
///
/// Useful, for example, after invoking `std::io::Error::last_os_error()`
/// to check if the last OS error was a message size error
/// (EMSGSIZE on Unix, WSAEMSGSIZE on Windows).
///
/// Note: EMSGSIZE's value is not standardized across OSes (90 on Linux,
/// 40 on macOS/iOS/BSD; on Windows, `io::Error::raw_os_error()` returns
/// the Winsock error WSAEMSGSIZE (10040) via `GetLastError()`, which is
/// distinct from the MSVCRT `errno.h` EMSGSIZE value of 115, which is
/// never actually populated by socket operations).
pub fn is_msg_size_err(err: &io::Error) -> bool {
    #[cfg(unix)]
    {
        err.raw_os_error() == Some(libc::EMSGSIZE)
    }
    #[cfg(windows)]
    {
        err.raw_os_error() == Some(WinSock::WSAEMSGSIZE)
    }
    #[cfg(not(any(unix, windows)))]
    {
        false
    }
}

/// Log at most 1 IO error per minute
#[cfg(not(wasm_browser))]
const IO_ERROR_LOG_INTERVAL: Duration = Duration::from_secs(60);

/// Logs a warning message when sendmsg fails
///
/// Logging will only be performed if at least [`IO_ERROR_LOG_INTERVAL`]
/// has elapsed since the last error was logged.
#[cfg(all(not(wasm_browser), any(feature = "tracing-log", feature = "log")))]
fn log_sendmsg_error(
    last_send_error: &Mutex<Instant>,
    err: impl core::fmt::Debug,
    transmit: &Transmit<'_>,
) {
    let now = Instant::now();
    let last_send_error = &mut *last_send_error.lock().expect("poisend lock");
    if now.saturating_duration_since(*last_send_error) > IO_ERROR_LOG_INTERVAL {
        *last_send_error = now;
        log::warn!(
            "sendmsg error: {:?}, Transmit: {{ destination: {:?}, src_ip: {:?}, ecn: {:?}, len: {:?}, segment_size: {:?} }}",
            err,
            transmit.destination,
            transmit.src_ip,
            transmit.ecn,
            transmit.contents.len(),
            transmit.segment_size
        );
    }
}

// No-op
#[cfg(not(any(wasm_browser, feature = "tracing-log", feature = "log")))]
fn log_sendmsg_error(_: &Mutex<Instant>, _: impl core::fmt::Debug, _: &Transmit<'_>) {}

/// A borrowed UDP socket
///
/// On Unix, constructible via `From<T: AsFd>`. On Windows, constructible via `From<T:
/// AsSocket>`.
// Wrapper around socket2 to avoid making it a public dependency and incurring stability risk
#[cfg(not(wasm_browser))]
pub struct UdpSockRef<'a>(socket2::SockRef<'a>);

#[cfg(not(wasm_browser))]
impl UdpSockRef<'_> {
    /// Configures the socket for non-blocking or blocking operation.
    pub fn set_nonblocking(&self, nonblocking: bool) -> io::Result<()> {
        #[cfg(not(target_os = "wasi"))]
        self.0.set_nonblocking(nonblocking)?;

        #[cfg(target_os = "wasi")]
        {
            // socket2 uses `fcntl`, which WASI rejects; `std` uses `ioctl(FIONBIO)`.
            // Safety: `self` outlives the borrow, and `ManuallyDrop` prevents a second close.
            let borrowed = ManuallyDrop::new(unsafe { UdpSocket::from_raw_fd(self.0.as_raw_fd()) });
            borrowed.set_nonblocking(nonblocking)?;
        }

        Ok(())
    }
}

#[cfg(any(unix, target_os = "wasi"))]
impl<'s, S> From<&'s S> for UdpSockRef<'s>
where
    S: AsFd,
{
    fn from(socket: &'s S) -> Self {
        Self(socket.into())
    }
}

#[cfg(windows)]
impl<'s, S> From<&'s S> for UdpSockRef<'s>
where
    S: AsSocket,
{
    fn from(socket: &'s S) -> Self {
        Self(socket.into())
    }
}

/// Explicit congestion notification codepoint
#[repr(u8)]
#[derive(Debug, Copy, Clone, Eq, PartialEq)]
pub enum EcnCodepoint {
    /// The ECT(0) codepoint, indicating that an endpoint is ECN-capable
    Ect0 = 0b10,
    /// The ECT(1) codepoint, indicating that an endpoint is ECN-capable
    Ect1 = 0b01,
    /// The CE codepoint, signalling that congestion was experienced
    Ce = 0b11,
}

impl EcnCodepoint {
    /// Create new object from the given bits
    pub fn from_bits(x: u8) -> Option<Self> {
        use EcnCodepoint::*;
        Some(match x & 0b11 {
            0b10 => Ect0,
            0b01 => Ect1,
            0b11 => Ce,
            _ => {
                return None;
            }
        })
    }
}

#[cfg(test)]
mod tests {
    use std::net::Ipv4Addr;

    use super::*;

    #[test]
    fn effective_segment_size() {
        assert_eq!(
            make_transmit(&[0u8; 10], Some(15)).effective_segment_size(),
            None,
            "segment_size > content_len should yield no effective segment_size"
        );
        assert_eq!(
            make_transmit(&[0u8; 10], Some(10)).effective_segment_size(),
            None,
            "segment_size == content_len should yield no effective segment_size"
        );
        assert_eq!(
            make_transmit(&[0u8; 10], None).effective_segment_size(),
            None,
            "no segment_size should yield no effective segment_size"
        );
        assert_eq!(
            make_transmit(&[0u8; 10], Some(5)).effective_segment_size(),
            Some(5),
            "segment_size < content_len should yield effective segment_size"
        );
    }

    fn make_transmit(contents: &[u8], segment_size: Option<usize>) -> Transmit<'_> {
        Transmit {
            destination: SocketAddr::from((Ipv4Addr::UNSPECIFIED, 1)),
            ecn: None,
            contents,
            segment_size,
            src_ip: None,
        }
    }
}
