use std::{
    io::{self, IoSliceMut},
    mem::{self, MaybeUninit},
    net::{IpAddr, Ipv4Addr},
    os::windows::io::AsRawSocket,
    ptr,
    sync::{
        Mutex,
        atomic::{AtomicUsize, Ordering},
    },
    time::Instant,
};

use libc::{c_int, c_uint};
use windows_sys::Win32::Networking::WinSock;

use crate::{
    EcnCodepoint, IO_ERROR_LOG_INTERVAL, RecvMeta, Transmit, UdpSockRef,
    cmsg::{self, CMsgHdr},
    log::debug,
    log_sendmsg_error,
};

/// QUIC-friendly UDP socket for Windows
///
/// Unlike a standard Windows UDP socket, this allows ECN bits to be read and written.
#[derive(Debug)]
pub struct UdpSocketState {
    last_send_error: Mutex<Instant>,
    max_gso_segments: AtomicUsize,

    /// Whether the underlying Winsock provider supports IPv4 ECN socket options/control messages.
    ///
    /// Some environments (notably Wine/Proton) don't implement IP_RECVECN/IP_ECN.
    /// ECN is best-effort: when unsupported we continue without it.
    ecn_v4_supported: bool,

    /// Whether the underlying Winsock provider supports IPv6 ECN socket options/control messages.
    ecn_v6_supported: bool,

    /// `WSARecvMsg`, resolved for this socket's Winsock provider.
    wsa_recvmsg: WsaRecvMsg,
}

impl UdpSocketState {
    pub fn new(socket: UdpSockRef<'_>) -> io::Result<Self> {
        assert!(
            CMSG_LEN
                >= WinSock::CMSGHDR::cmsg_space(size_of::<WinSock::IN6_PKTINFO>())
                    + WinSock::CMSGHDR::cmsg_space(size_of::<c_int>())
                    + WinSock::CMSGHDR::cmsg_space(size_of::<u32>())
        );
        assert!(
            align_of::<WinSock::CMSGHDR>() <= align_of::<cmsg::Aligned<[u8; 0]>>(),
            "control message buffers will be misaligned"
        );

        socket.0.set_nonblocking(true)?;
        let info = unsafe {
            get_socket_option::<WinSock::WSAPROTOCOL_INFOW>(
                &*socket.0,
                WinSock::SOL_SOCKET,
                WinSock::SO_PROTOCOL_INFOW,
            )
        }?;
        let family = info.iAddressFamily;
        let is_ipv6 = family == c_int::from(WinSock::AF_INET6);
        let v6only = unsafe {
            get_socket_option::<u32>(&*socket.0, WinSock::IPPROTO_IPV6, WinSock::IPV6_V6ONLY as _)
        }?;
        let is_ipv4 = family == c_int::from(WinSock::AF_INET) || v6only == 0;

        // We don't support old versions of Windows that do not enable access to `WSARecvMsg()`
        let wsa_recvmsg = resolve_wsa_recvmsg(&*socket.0).ok_or_else(|| {
            io::Error::new(
                io::ErrorKind::Unsupported,
                "network stack does not support WSARecvMsg function",
            )
        })?;

        // ECN is best-effort on Windows: if the Winsock provider doesn't support these options
        // (common under Wine/Proton), we disable ECN and keep working.
        let is_ecn_unsupported = |e: &io::Error| {
            matches!(
                e.raw_os_error(),
                Some(code)
                    if code == WinSock::WSAENOPROTOOPT
                    || code == WinSock::WSAEOPNOTSUPP
            )
        };

        let mut ecn_v4_supported = true;
        let mut ecn_v6_supported = true;

        if is_ipv4 {
            set_socket_option(
                &*socket.0,
                WinSock::IPPROTO_IP,
                WinSock::IP_DONTFRAGMENT,
                OPTION_ON,
            )?;

            set_socket_option(
                &*socket.0,
                WinSock::IPPROTO_IP,
                WinSock::IP_PKTINFO,
                OPTION_ON,
            )?;

            if let Err(e) = set_socket_option(
                &*socket.0,
                WinSock::IPPROTO_IP,
                WinSock::IP_RECVECN,
                OPTION_ON,
            ) {
                if is_ecn_unsupported(&e) {
                    ecn_v4_supported = false;
                    debug!("quinn-udp: ECN disabled for IPv4 (IP_RECVECN unsupported): {e}");
                } else {
                    return Err(e);
                }
            }
        }

        if is_ipv6 {
            set_socket_option(
                &*socket.0,
                WinSock::IPPROTO_IPV6,
                WinSock::IPV6_DONTFRAG,
                OPTION_ON,
            )?;

            set_socket_option(
                &*socket.0,
                WinSock::IPPROTO_IPV6,
                WinSock::IPV6_PKTINFO,
                OPTION_ON,
            )?;

            if let Err(e) = set_socket_option(
                &*socket.0,
                WinSock::IPPROTO_IPV6,
                WinSock::IPV6_RECVECN,
                OPTION_ON,
            ) {
                if is_ecn_unsupported(&e) {
                    ecn_v6_supported = false;
                    debug!("quinn-udp: ECN disabled for IPv6 (IPV6_RECVECN unsupported): {e}");
                } else {
                    return Err(e);
                }
            }
        }

        let now = Instant::now();
        Ok(Self {
            last_send_error: Mutex::new(now.checked_sub(2 * IO_ERROR_LOG_INTERVAL).unwrap_or(now)),
            max_gso_segments: AtomicUsize::new(max_gso_segments(&*socket.0)),
            ecn_v4_supported,
            ecn_v6_supported,
            wsa_recvmsg,
        })
    }

    /// Enable or disable receive offloading.
    ///
    /// Also referred to as UDP Receive Segment Coalescing Offload (URO) on Windows.
    ///
    /// <https://learn.microsoft.com/en-us/windows-hardware/drivers/network/udp-rsc-offload>
    ///
    /// Disabled by default on Windows due to <https://github.com/quinn-rs/quinn/issues/2041>.
    pub fn set_gro(&self, socket: UdpSockRef<'_>, enable: bool) -> io::Result<()> {
        set_socket_option(
            &*socket.0,
            WinSock::IPPROTO_UDP,
            WinSock::UDP_RECV_MAX_COALESCED_SIZE,
            match enable {
                // u32 per
                // https://learn.microsoft.com/en-us/windows/win32/winsock/ipproto-udp-socket-options.
                // Choice of 2^16 - 1 inspired by msquic.
                true => u16::MAX as u32,
                false => 0,
            },
        )
    }

    /// Sends a [`Transmit`] on the given socket.
    ///
    /// This function will only ever return errors of kind [`io::ErrorKind::WouldBlock`].
    /// All other errors will be logged and converted to `Ok`.
    ///
    /// UDP transmission errors are considered non-fatal because higher-level protocols must
    /// employ retransmits and timeouts anyway in order to deal with UDP's unreliable nature.
    /// Thus, logging is most likely the only thing you can do with these errors.
    ///
    /// If you would like to handle these errors yourself, use [`UdpSocketState::try_send`]
    /// instead.
    #[deprecated(note = "silences I/O errors; use `UdpSocketState::try_send() instead")]
    pub fn send(&self, socket: UdpSockRef<'_>, transmit: &Transmit<'_>) -> io::Result<()> {
        match send(
            socket,
            transmit,
            self.ecn_v4_supported,
            self.ecn_v6_supported,
        ) {
            Ok(()) => Ok(()),
            Err(e) if e.kind() == io::ErrorKind::WouldBlock => Err(e),
            Err(e) => {
                log_sendmsg_error(&self.last_send_error, e, transmit);

                Ok(())
            }
        }
    }

    /// Sends a [`Transmit`] on the given socket without any additional error handling.
    pub fn try_send(&self, socket: UdpSockRef<'_>, transmit: &Transmit<'_>) -> io::Result<()> {
        send(
            socket,
            transmit,
            self.ecn_v4_supported,
            self.ecn_v6_supported,
        )
    }

    pub fn recv(
        &self,
        socket: UdpSockRef<'_>,
        bufs: &mut [IoSliceMut<'_>],
        meta: &mut [RecvMeta],
    ) -> io::Result<usize> {
        // we cannot use [`socket2::MsgHdrMut`] as we do not have access to inner field which holds the WSAMSG
        let mut ctrl_buf = cmsg::Aligned([0; CMSG_LEN]);
        let mut source: WinSock::SOCKADDR_INET = unsafe { mem::zeroed() };
        let mut data = WinSock::WSABUF {
            buf: bufs[0].as_mut_ptr(),
            len: bufs[0].len() as _,
        };

        let ctrl = WinSock::WSABUF {
            buf: ctrl_buf.0.as_mut_ptr(),
            len: ctrl_buf.0.len() as _,
        };

        let mut wsa_msg = WinSock::WSAMSG {
            name: &mut source as *mut _ as *mut _,
            namelen: size_of_val(&source) as _,
            lpBuffers: &mut data,
            Control: ctrl,
            dwBufferCount: 1,
            dwFlags: 0,
        };

        let mut len = 0;
        unsafe {
            let rc = (self.wsa_recvmsg)(
                socket.0.as_raw_socket() as usize,
                &mut wsa_msg,
                &mut len,
                ptr::null_mut(),
                None,
            );
            if rc == -1 {
                return Err(io::Error::last_os_error());
            }
        }

        let addr = unsafe {
            let (_, addr) = socket2::SockAddr::try_init(|addr_storage, len| {
                *len = size_of_val(&source) as _;
                ptr::copy_nonoverlapping(&source, addr_storage as _, 1);
                Ok(())
            })?;
            addr.as_socket()
        };

        // Decode control messages (PKTINFO and ECN)
        let mut ecn_bits = 0;
        let mut dst_ip = None;
        let mut interface_index = None;
        let mut stride = len;

        let cmsg_iter = unsafe { cmsg::Iter::new(&wsa_msg) };
        for cmsg in cmsg_iter {
            const UDP_COALESCED_INFO: i32 = WinSock::UDP_COALESCED_INFO as i32;
            // [header (len)][data][padding(len + sizeof(data))] -> [header][data][padding]
            match (cmsg.cmsg_level, cmsg.cmsg_type) {
                (WinSock::IPPROTO_IP, WinSock::IP_PKTINFO) => {
                    let pktinfo =
                        unsafe { cmsg::decode::<WinSock::IN_PKTINFO, WinSock::CMSGHDR>(cmsg) };
                    // Addr is stored in big endian format
                    let ip4 = Ipv4Addr::from(u32::from_be(unsafe { pktinfo.ipi_addr.S_un.S_addr }));
                    dst_ip = Some(ip4.into());
                    interface_index = Some(pktinfo.ipi_ifindex);
                }
                (WinSock::IPPROTO_IPV6, WinSock::IPV6_PKTINFO) => {
                    let pktinfo =
                        unsafe { cmsg::decode::<WinSock::IN6_PKTINFO, WinSock::CMSGHDR>(cmsg) };
                    // Addr is stored in big endian format
                    dst_ip = Some(IpAddr::from(unsafe { pktinfo.ipi6_addr.u.Byte }));
                    interface_index = Some(pktinfo.ipi6_ifindex);
                }
                (WinSock::IPPROTO_IP, WinSock::IP_ECN) => {
                    // ECN is a C integer https://learn.microsoft.com/en-us/windows/win32/winsock/winsock-ecn
                    ecn_bits = unsafe { cmsg::decode::<c_int, WinSock::CMSGHDR>(cmsg) };
                }
                (WinSock::IPPROTO_IPV6, WinSock::IPV6_ECN) => {
                    // ECN is a C integer https://learn.microsoft.com/en-us/windows/win32/winsock/winsock-ecn
                    ecn_bits = unsafe { cmsg::decode::<c_int, WinSock::CMSGHDR>(cmsg) };
                }
                (WinSock::IPPROTO_UDP, UDP_COALESCED_INFO) => {
                    // Has type u32 (aka DWORD) per
                    // https://learn.microsoft.com/en-us/windows/win32/winsock/ipproto-udp-socket-options
                    stride = unsafe { cmsg::decode::<u32, WinSock::CMSGHDR>(cmsg) };
                }
                _ => {}
            }
        }

        meta[0] = RecvMeta {
            len: len as usize,
            stride: stride as usize,
            addr: addr.unwrap(),
            ecn: EcnCodepoint::from_bits(ecn_bits as u8),
            dst_ip,
            interface_index,
            timestamp: None,
        };
        Ok(1)
    }

    /// The maximum amount of segments which can be transmitted if a platform
    /// supports Generic Send Offload (GSO).
    ///
    /// This is 1 if the platform doesn't support GSO. Subject to change if errors are detected
    /// while using GSO.
    #[inline]
    pub fn max_gso_segments(&self) -> usize {
        self.max_gso_segments.load(Ordering::Relaxed)
    }

    /// The number of segments to read when GRO is enabled. Used as a factor to
    /// compute the receive buffer size.
    ///
    /// Returns 1 if the platform doesn't support GRO.
    #[inline]
    pub fn gro_segments(&self) -> usize {
        // Arbitrary reasonable value inspired by Linux and msquic
        64
    }

    /// Resize the send buffer of `socket` to `bytes`
    #[inline]
    pub fn set_send_buffer_size(&self, socket: UdpSockRef<'_>, bytes: usize) -> io::Result<()> {
        socket.0.set_send_buffer_size(bytes)
    }

    /// Resize the receive buffer of `socket` to `bytes`
    #[inline]
    pub fn set_recv_buffer_size(&self, socket: UdpSockRef<'_>, bytes: usize) -> io::Result<()> {
        socket.0.set_recv_buffer_size(bytes)
    }

    /// Get the size of the `socket` send buffer
    #[inline]
    pub fn send_buffer_size(&self, socket: UdpSockRef<'_>) -> io::Result<usize> {
        socket.0.send_buffer_size()
    }

    /// Get the size of the `socket` receive buffer
    #[inline]
    pub fn recv_buffer_size(&self, socket: UdpSockRef<'_>) -> io::Result<usize> {
        socket.0.recv_buffer_size()
    }

    #[inline]
    pub fn may_fragment(&self) -> bool {
        false
    }
}

fn send(
    socket: UdpSockRef<'_>,
    transmit: &Transmit<'_>,
    ecn_v4_supported: bool,
    ecn_v6_supported: bool,
) -> io::Result<()> {
    // we cannot use [`socket2::sendmsg()`] and [`socket2::MsgHdr`] as we do not have access
    // to the inner field which holds the WSAMSG
    let mut ctrl_buf = cmsg::Aligned([0; CMSG_LEN]);
    let daddr = socket2::SockAddr::from(transmit.destination);

    let mut data = WinSock::WSABUF {
        buf: transmit.contents.as_ptr() as *mut _,
        len: transmit.contents.len() as _,
    };

    let ctrl = WinSock::WSABUF {
        buf: ctrl_buf.0.as_mut_ptr(),
        len: ctrl_buf.0.len() as _,
    };

    let mut wsa_msg = WinSock::WSAMSG {
        name: daddr.as_ptr() as *mut _,
        namelen: daddr.len(),
        lpBuffers: &mut data,
        Control: ctrl,
        dwBufferCount: 1,
        dwFlags: 0,
    };

    // Add control messages (ECN and PKTINFO)
    let mut encoder = unsafe { cmsg::Encoder::new(&mut wsa_msg) };

    if let Some(ip) = transmit.src_ip {
        let ip = std::net::SocketAddr::new(ip, 0);
        let ip = socket2::SockAddr::from(ip);
        match ip.family() {
            WinSock::AF_INET => {
                let src_ip = unsafe { ptr::read(ip.as_ptr() as *const WinSock::SOCKADDR_IN) };
                let pktinfo = WinSock::IN_PKTINFO {
                    ipi_addr: src_ip.sin_addr,
                    ipi_ifindex: 0,
                };
                encoder.push(WinSock::IPPROTO_IP, WinSock::IP_PKTINFO, pktinfo);
            }
            WinSock::AF_INET6 => {
                let src_ip = unsafe { ptr::read(ip.as_ptr() as *const WinSock::SOCKADDR_IN6) };
                let pktinfo = WinSock::IN6_PKTINFO {
                    ipi6_addr: src_ip.sin6_addr,
                    ipi6_ifindex: unsafe { src_ip.Anonymous.sin6_scope_id },
                };
                encoder.push(WinSock::IPPROTO_IPV6, WinSock::IPV6_PKTINFO, pktinfo);
            }
            _ => {
                return Err(io::Error::from(io::ErrorKind::InvalidInput));
            }
        }
    }

    // True for IPv4 or IPv4-Mapped IPv6
    let is_ipv4 = transmit.destination.is_ipv4()
        || matches!(transmit.destination.ip(), IpAddr::V6(addr) if addr.to_ipv4_mapped().is_some());

    if (is_ipv4 && ecn_v4_supported) || (!is_ipv4 && ecn_v6_supported) {
        // ECN is a C integer https://learn.microsoft.com/en-us/windows/win32/winsock/winsock-ecn
        let ecn = transmit.ecn.map_or(0, |x| x as c_int);
        if is_ipv4 {
            encoder.push(WinSock::IPPROTO_IP, WinSock::IP_ECN, ecn);
        } else {
            encoder.push(WinSock::IPPROTO_IPV6, WinSock::IPV6_ECN, ecn);
        }
    }

    // Segment size is a u32 https://learn.microsoft.com/en-us/windows/win32/api/ws2tcpip/nf-ws2tcpip-wsasetudpsendmessagesize
    if let Some(segment_size) = transmit.effective_segment_size() {
        encoder.push(
            WinSock::IPPROTO_UDP,
            WinSock::UDP_SEND_MSG_SIZE,
            segment_size as u32,
        );
    }

    encoder.finish();

    let mut len = 0;
    let rc = unsafe {
        WinSock::WSASendMsg(
            socket.0.as_raw_socket() as usize,
            &wsa_msg,
            0,
            &mut len,
            ptr::null_mut(),
            None,
        )
    };

    match rc {
        0 => Ok(()),
        _ => Err(io::Error::last_os_error()),
    }
}

/// Reads a socket option into a zero-initialized `T`.
///
/// # Safety
///
/// `T` must be valid for the all-zero bit pattern: Windows may fill fewer bytes than
/// `size_of::<T>()`, as it does for `IPV6_V6ONLY`.
unsafe fn get_socket_option<T>(socket: &impl AsRawSocket, level: i32, name: i32) -> io::Result<T> {
    let mut value = MaybeUninit::<T>::zeroed();
    let mut len = size_of::<T>() as i32;
    let rc = unsafe {
        WinSock::getsockopt(
            socket.as_raw_socket() as usize,
            level,
            name,
            value.as_mut_ptr() as _,
            &mut len,
        )
    };

    match rc == 0 {
        // SAFETY: `value` is zero-initialized and `getsockopt` only writes within it.
        true => Ok(unsafe { value.assume_init() }),
        false => Err(io::Error::last_os_error()),
    }
}

fn set_socket_option(
    socket: &impl AsRawSocket,
    level: i32,
    name: i32,
    value: u32,
) -> io::Result<()> {
    let rc = unsafe {
        WinSock::setsockopt(
            socket.as_raw_socket() as usize,
            level,
            name,
            &value as *const _ as _,
            size_of_val(&value) as _,
        )
    };

    match rc == 0 {
        true => Ok(()),
        false => Err(io::Error::last_os_error()),
    }
}

pub(crate) const BATCH_SIZE: usize = 1;
// Enough to store max(IP_PKTINFO + IP_ECN, IPV6_PKTINFO + IPV6_ECN) + max(UDP_SEND_MSG_SIZE, UDP_COALESCED_INFO) bytes (header + data) and some extra margin
const CMSG_LEN: usize = 128;
const OPTION_ON: u32 = 1;

/// Names the function type inside [`WinSock::LPFN_WSARECVMSG`] without restating its signature.
trait Inner {
    type Type;
}

impl<T> Inner for Option<T> {
    type Type = T;
}

type WsaRecvMsg = <WinSock::LPFN_WSARECVMSG as Inner>::Type;

/// Resolve `WSARecvMsg` for `socket`.
///
/// The pointer belongs to the Winsock provider serving `socket`, so it has to be resolved per
/// socket: calling one provider's `WSARecvMsg` on another provider's socket crashes when a layered
/// service provider is installed. See <https://bugzilla.mozilla.org/show_bug.cgi?id=2068899>.
fn resolve_wsa_recvmsg(socket: &impl AsRawSocket) -> WinSock::LPFN_WSARECVMSG {
    // Detect if OS expose WSARecvMsg API based on
    // https://github.com/Azure/mio-uds-windows/blob/a3c97df82018086add96d8821edb4aa85ec1b42b/src/stdnet/ext.rs#L601
    let guid = WinSock::WSAID_WSARECVMSG;
    let mut func = None;
    let mut len = 0;

    // Safety: Option handles the NULL pointer with a None value
    let rc = unsafe {
        WinSock::WSAIoctl(
            socket.as_raw_socket() as _,
            WinSock::SIO_GET_EXTENSION_FUNCTION_POINTER,
            &guid as *const _ as *const _,
            size_of_val(&guid) as u32,
            &mut func as *mut _ as *mut _,
            size_of_val(&func) as u32,
            &mut len,
            ptr::null_mut(),
            None,
        )
    };

    if rc == -1 {
        debug!(
            "ignoring WSARecvMsg function pointer due to ioctl error: {}",
            io::Error::last_os_error()
        );
        return None;
    }
    if len as usize != size_of_val(&func) {
        debug!("ignoring WSARecvMsg function pointer due to pointer size mismatch");
        return None;
    }

    func
}

fn max_gso_segments(socket: &impl AsRawSocket) -> usize {
    const GSO_SIZE: c_uint = 1500;
    match set_socket_option(
        socket,
        WinSock::IPPROTO_UDP,
        WinSock::UDP_SEND_MSG_SIZE,
        GSO_SIZE,
    ) {
        Ok(()) => {
            // Disable USO again at the socket level so that it is only enabled per message through
            // the `UDP_SEND_MSG_SIZE` control message. This mirrors the Linux behaviour, see:
            // - https://github.com/quinn-rs/quinn/issues/2818
            // - https://learn.microsoft.com/en-us/windows/win32/winsock/ipproto-udp-socket-options
            let _ = set_socket_option(socket, WinSock::IPPROTO_UDP, WinSock::UDP_SEND_MSG_SIZE, 0);

            // Empirically found on Windows 11 x64
            512
        }
        Err(_) => 1,
    }
}
