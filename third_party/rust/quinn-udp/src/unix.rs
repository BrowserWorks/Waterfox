#[cfg(not(any(apple, target_os = "openbsd", solarish)))]
use std::ptr;
use std::{
    io::{self, IoSliceMut},
    mem::{self, MaybeUninit},
    net::{IpAddr, Ipv4Addr, Ipv6Addr, SocketAddr, SocketAddrV4, SocketAddrV6},
    os::fd::AsRawFd,
    sync::{
        Mutex,
        atomic::{AtomicBool, AtomicUsize, Ordering},
    },
    time::{Duration, Instant},
};

use socket2::SockRef;

use super::{
    EcnCodepoint, IO_ERROR_LOG_INTERVAL, RecvMeta, Transmit, TransportError, UdpSockRef, cmsg,
    log_sendmsg_error,
};

#[cfg(apple_fast)]
use super::apple_fast::{msghdr_x, recv_via_recvmsg_x, send};
#[cfg(any(target_os = "linux", target_os = "android"))]
use super::linux::{LinuxError, gso};

/// Tokio-compatible UDP socket with some useful specializations
///
/// Unlike a standard tokio UDP socket, this allows ECN bits to be read and written on some
/// platforms.
#[derive(Debug)]
pub struct UdpSocketState {
    last_send_error: Mutex<Instant>,
    max_gso_segments: AtomicUsize,
    gro_segments: usize,
    may_fragment: bool,

    /// True if we have received EINVAL error from `sendmsg` system call at least once.
    ///
    /// If enabled, we assume that old kernel is used and switch to fallback mode.
    /// In particular, we do not use IP_TOS cmsg_type in this case,
    /// which is not supported on Linux <3.13 and results in not sending the UDP packet at all.
    sendmsg_einval: AtomicBool,

    /// Whether to use Apple's fast `sendmsg_x`/`recvmsg_x` APIs.
    ///
    /// These private APIs provide better performance but may not be available on all
    /// Apple OS versions. Callers must verify availability before enabling.
    #[cfg(apple_fast)]
    apple_fast_path: AtomicBool,

    /// Cached `SO_SNDBUF`.
    #[cfg(apple)]
    send_buffer_size: AtomicUsize,
}

impl UdpSocketState {
    pub fn new(sock: UdpSockRef<'_>) -> io::Result<Self> {
        let io = sock.0;
        let mut cmsg_platform_space = 0;
        #[cfg(not(any(target_os = "redox", target_os = "hurd")))]
        if cfg!(target_os = "linux")
            || cfg!(bsd)
            || cfg!(apple)
            || cfg!(target_os = "android")
            || cfg!(solarish)
        {
            cmsg_platform_space +=
                unsafe { libc::CMSG_SPACE(size_of::<libc::in6_pktinfo>() as _) as usize };
        }

        assert!(
            cmsg::LEN
                >= unsafe { libc::CMSG_SPACE(size_of::<libc::c_int>() as _) as usize }
                    + cmsg_platform_space
        );
        assert!(
            align_of::<libc::cmsghdr>() <= align_of::<cmsg::Aligned<[u8; 0]>>(),
            "control message buffers will be misaligned"
        );

        io.set_nonblocking(true)?;

        let addr = io.local_addr()?;
        let is_ipv4 = addr.family() == libc::AF_INET as libc::sa_family_t;

        // mac and ios do not support IP_RECVTOS on dual-stack sockets :(
        // older macos versions also don't have the flag and will error out if we don't ignore it
        #[cfg(not(any(
            target_os = "openbsd",
            target_os = "netbsd",
            target_os = "dragonfly",
            target_os = "hurd",
            solarish
        )))]
        if is_ipv4 || !io.only_v6()? {
            if let Err(_err) =
                set_socket_option(&*io, libc::IPPROTO_IP, libc::IP_RECVTOS, OPTION_ON)
            {
                crate::log::debug!("Ignoring error setting IP_RECVTOS on socket: {_err:?}");
            }
        }

        let mut may_fragment = false;
        #[cfg_attr(
            not(any(target_os = "linux", target_os = "android")),
            expect(unused_mut)
        )]
        let mut gro_segments = 1;

        #[cfg(any(target_os = "linux", target_os = "android"))]
        {
            // Forbid IPv4 fragmentation. Set even for IPv6 to account for IPv6 mapped IPv4 addresses.
            // Set `may_fragment` to `true` if this option is not supported on the platform.
            may_fragment |= !set_socket_option_supported(
                &*io,
                libc::IPPROTO_IP,
                libc::IP_MTU_DISCOVER,
                libc::IP_PMTUDISC_PROBE,
            )?;

            if is_ipv4 {
                set_socket_option(&*io, libc::IPPROTO_IP, libc::IP_PKTINFO, OPTION_ON)?;
            } else {
                // Set `may_fragment` to `true` if this option is not supported on the platform.
                may_fragment |= !set_socket_option_supported(
                    &*io,
                    libc::IPPROTO_IPV6,
                    libc::IPV6_MTU_DISCOVER,
                    libc::IPV6_PMTUDISC_PROBE,
                )?;
            }

            if set_socket_option(&*io, libc::SOL_UDP, libc::UDP_GRO, OPTION_ON).is_ok() {
                // As defined in net/ipv4/udp_offload.c
                // #define UDP_GRO_CNT_MAX 64
                //
                // NOTE: this MUST be set to UDP_GRO_CNT_MAX to ensure that the receive buffer size
                // (get_max_udp_payload_size() * gro_segments()) is large enough to hold the largest GRO
                // list the kernel might potentially produce. See
                // https://github.com/quinn-rs/quinn/pull/1354.
                gro_segments = 64
            }

            if let Err(_err) =
                set_socket_option(&*io, libc::SOL_SOCKET, libc::SO_TIMESTAMPNS, OPTION_ON)
            {
                crate::log::debug!("Ignoring error setting SO_TIMESTAMPNS on socket: {_err:?}");
            }
        }
        #[cfg(any(target_os = "freebsd", apple))]
        {
            if is_ipv4 {
                // Set `may_fragment` to `true` if this option is not supported on the platform.
                may_fragment |= !set_socket_option_supported(
                    &*io,
                    libc::IPPROTO_IP,
                    libc::IP_DONTFRAG,
                    OPTION_ON,
                )?;
            }
        }
        #[cfg(any(bsd, apple, solarish))]
        // IP_RECVDSTADDR == IP_SENDSRCADDR on FreeBSD
        // macOS uses only IP_RECVDSTADDR, no IP_SENDSRCADDR on macOS (the same on Solaris)
        // macOS also supports IP_PKTINFO
        {
            if is_ipv4 {
                set_socket_option(&*io, libc::IPPROTO_IP, libc::IP_RECVDSTADDR, OPTION_ON)?;
            }
        }

        // Options standardized in RFC 3542
        #[cfg(not(target_os = "redox"))]
        if !is_ipv4 {
            set_socket_option(&*io, libc::IPPROTO_IPV6, libc::IPV6_RECVPKTINFO, OPTION_ON)?;
            set_socket_option(&*io, libc::IPPROTO_IPV6, libc::IPV6_RECVTCLASS, OPTION_ON)?;
            // Linux's IP_PMTUDISC_PROBE allows us to operate under interface MTU rather than the
            // kernel's path MTU guess, but actually disabling fragmentation requires this too. See
            // __ip6_append_data in ip6_output.c.
            // Set `may_fragment` to `true` if this option is not supported on the platform.
            may_fragment |= !set_socket_option_supported(
                &*io,
                libc::IPPROTO_IPV6,
                libc::IPV6_DONTFRAG,
                OPTION_ON,
            )?;
        }

        // Enlarge SO_SNDBUF to a safe minimum.
        #[cfg(apple)]
        if io
            .send_buffer_size()
            .is_ok_and(|cur| cur < Self::MIN_SAFE_SNDBUF)
        {
            let _ = io.set_send_buffer_size(Self::MIN_SAFE_SNDBUF);
        }

        let now = Instant::now();
        Ok(Self {
            last_send_error: Mutex::new(now.checked_sub(2 * IO_ERROR_LOG_INTERVAL).unwrap_or(now)),
            max_gso_segments: AtomicUsize::new(gso::max_gso_segments(&*io)),
            gro_segments,
            may_fragment,
            sendmsg_einval: AtomicBool::new(false),
            #[cfg(apple_fast)]
            apple_fast_path: AtomicBool::new(false),
            #[cfg(apple)]
            send_buffer_size: AtomicUsize::new(io.send_buffer_size().unwrap_or(usize::MAX)),
        })
    }

    /// Sends a [`Transmit`] on the given socket
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
        match send(self, socket.0, transmit) {
            Ok(()) => Ok(()),
            Err(e) if e.kind() == io::ErrorKind::WouldBlock => Err(e),
            // - EMSGSIZE is expected for MTU probes. Future work might be able to avoid
            //   these by automatically clamping the MTUD upper bound to the interface MTU.
            Err(e) if e.raw_os_error() == Some(libc::EMSGSIZE) => Ok(()),
            Err(e) => {
                log_sendmsg_error(&self.last_send_error, e, transmit);

                Ok(())
            }
        }
    }

    /// Sends a [`Transmit`] on the given socket without any additional error handling
    pub fn try_send(&self, socket: UdpSockRef<'_>, transmit: &Transmit<'_>) -> io::Result<()> {
        send(self, socket.0, transmit)
    }

    #[cfg(not(any(
        apple,
        target_os = "openbsd",
        target_os = "netbsd",
        target_os = "dragonfly",
        target_os = "redox",
        target_os = "hurd",
        solarish
    )))]
    pub fn recv(
        &self,
        socket: UdpSockRef<'_>,
        bufs: &mut [IoSliceMut<'_>],
        meta: &mut [RecvMeta],
    ) -> io::Result<usize> {
        recv_via_recvmmsg(socket.0, bufs, meta)
    }

    #[cfg(apple_fast)]
    pub fn recv(
        &self,
        socket: UdpSockRef<'_>,
        bufs: &mut [IoSliceMut<'_>],
        meta: &mut [RecvMeta],
    ) -> io::Result<usize> {
        if self.is_apple_fast_path_enabled() {
            recv_via_recvmsg_x(self, socket.0, bufs, meta)
        } else {
            recv_single(socket.0, bufs, meta)
        }
    }

    #[cfg(any(
        target_os = "openbsd",
        target_os = "netbsd",
        target_os = "dragonfly",
        target_os = "redox",
        target_os = "hurd",
        solarish,
        apple_slow
    ))]
    pub fn recv(
        &self,
        socket: UdpSockRef<'_>,
        bufs: &mut [IoSliceMut<'_>],
        meta: &mut [RecvMeta],
    ) -> io::Result<usize> {
        recv_single(socket.0, bufs, meta)
    }

    /// Enables asynchronous transport-layer error reception for this socket
    ///
    /// On Linux and Android, this enables the socket error queue via
    /// `IP_RECVERR`/`IPV6_RECVERR`, allowing ICMP errors to be retrieved with
    /// [`recv_transport_error`]. On other platforms, this method is a no-op and
    /// [`recv_transport_error`] will always return `None`.
    ///
    /// # Cost
    ///
    /// On Linux and Android, queued ICMP errors are charged against the socket's
    /// receive buffer (`sk_rmem_alloc`). If the buffer is full, incoming errors
    /// are silently dropped by the kernel. There is no overhead when the error
    /// queue is empty.
    ///
    /// # Usage
    ///
    /// When this feature is enabled, the kernel may return a pending error on the
    /// next `sendmsg` or `recvmsg` call, preventing that operation from completing.
    /// To avoid this, callers should drain the error queue via
    /// [`recv_transport_error`] before sending or receiving.
    ///
    /// [`recv_transport_error`]: Self::recv_transport_error
    pub fn enable_transport_errors(&self, _socket: UdpSockRef<'_>) -> io::Result<()> {
        #[cfg(any(target_os = "linux", target_os = "android"))]
        {
            let io = _socket.0;
            let addr = io.local_addr()?;
            let is_ipv4 = addr.family() == libc::AF_INET as libc::sa_family_t;

            if is_ipv4 || !io.only_v6()? {
                set_socket_option(&*io, libc::IPPROTO_IP, libc::IP_RECVERR, OPTION_ON)?;
            }

            if !is_ipv4 {
                set_socket_option(&*io, libc::IPPROTO_IPV6, libc::IPV6_RECVERR, OPTION_ON)?;
            }
        }

        Ok(())
    }

    /// Receives one pending asynchronous transport-layer error from this socket
    ///
    /// Returns `None` if the error queue is empty or the underlying platform is
    /// unsupported. On Linux and Android, errors are only available if
    /// [`enable_transport_errors`] has been called first.
    ///
    /// Returns an error if the underlying system call fails unexpectedly.
    ///
    /// [`enable_transport_errors`]: Self::enable_transport_errors
    pub fn recv_transport_error(
        &self,
        _socket: UdpSockRef<'_>,
    ) -> io::Result<Option<TransportError>> {
        #[cfg(any(target_os = "linux", target_os = "android"))]
        {
            Ok(LinuxError::recv(_socket.0)?.map(TransportError::from))
        }

        #[cfg(not(any(target_os = "linux", target_os = "android")))]
        {
            Ok(None)
        }
    }

    /// Maximum number of segments to transmit if Generic Send Offload (GSO) is enabled
    ///
    /// This is 1 if the platform doesn't support GSO.
    ///
    /// Subject to change if errors are detected while using GSO.
    #[inline]
    pub fn max_gso_segments(&self) -> usize {
        self.max_gso_segments.load(Ordering::Relaxed)
    }

    /// The number of segments to read when GRO is enabled
    ///
    /// Used as a factor to compute the receive buffer size.
    ///
    /// Returns 1 if the platform doesn't support GRO.
    #[inline]
    pub fn gro_segments(&self) -> usize {
        self.gro_segments
    }

    /// Resize the send buffer of `socket` to `bytes`
    ///
    /// On Apple platforms, `bytes` is silently raised to a safe minimum if smaller.
    #[inline]
    pub fn set_send_buffer_size(&self, socket: UdpSockRef<'_>, bytes: usize) -> io::Result<()> {
        #[cfg(apple)]
        let bytes = if bytes < Self::MIN_SAFE_SNDBUF {
            crate::log::debug!(
                "raising requested SO_SNDBUF from {bytes} to {}",
                Self::MIN_SAFE_SNDBUF
            );
            Self::MIN_SAFE_SNDBUF
        } else {
            bytes
        };
        socket.0.set_send_buffer_size(bytes)?;
        #[cfg(apple)]
        self.send_buffer_size.store(
            socket.0.send_buffer_size().unwrap_or(bytes),
            Ordering::Relaxed,
        );
        Ok(())
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

    /// Whether transmitted datagrams might get fragmented by the IP layer
    ///
    /// Returns `false` on targets which employ e.g. the `IPV6_DONTFRAG` socket option.
    #[inline]
    pub fn may_fragment(&self) -> bool {
        self.may_fragment
    }

    /// Returns true if we previously got an EINVAL error from `sendmsg` syscall.
    pub(crate) fn sendmsg_einval(&self) -> bool {
        self.sendmsg_einval.load(Ordering::Relaxed)
    }

    /// Sets the flag indicating we got EINVAL error from `sendmsg` syscall.
    #[cfg(not(any(apple, target_os = "openbsd", target_os = "netbsd")))]
    fn set_sendmsg_einval(&self) {
        self.sendmsg_einval.store(true, Ordering::Relaxed)
    }

    /// Enables Apple's fast UDP datapath using private `sendmsg_x`/`recvmsg_x` APIs
    ///
    /// Once enabled, this also updates [`max_gso_segments`] to allow batched sends.
    ///
    /// # Safety
    ///
    /// These APIs may crash on unsupported OS versions, so callers must verify
    /// availability before enabling.
    ///
    /// [`max_gso_segments`]: Self::max_gso_segments
    #[cfg(apple_fast)]
    pub unsafe fn set_apple_fast_path(&self) {
        self.apple_fast_path.store(true, Ordering::Relaxed);
        self.max_gso_segments.store(BATCH_SIZE, Ordering::Relaxed);
    }

    /// Returns whether Apple's fast UDP datapath is enabled for this socket
    #[cfg(apple_fast)]
    pub fn is_apple_fast_path_enabled(&self) -> bool {
        self.apple_fast_path.load(Ordering::Relaxed)
    }

    /// Disables Apple's fast UDP datapath, reverting to `sendmsg`/`recvmsg`
    #[cfg(apple_fast)]
    fn disable_apple_fast_path(&self) {
        self.apple_fast_path.store(false, Ordering::Relaxed);
        self.max_gso_segments.store(1, Ordering::Relaxed);
    }

    /// Resolves an Apple fast-path function pointer via `resolver`
    ///
    /// Disables the fast path if the symbol is absent so that future calls use the slow path
    /// directly.
    #[cfg(apple_fast)]
    pub(crate) fn resolve_apple_fast_fn<T>(&self, resolver: fn() -> Option<T>) -> Option<T> {
        let f = resolver();
        if f.is_none() {
            self.disable_apple_fast_path();
        }
        f
    }

    /// Smallest `SO_SNDBUF` that mitigates <https://feedbackassistant.apple.com/feedback/23671230>:
    /// On macOS, a non-blocking SOCK_DGRAM `sendmsg`/`sendmsg_x` call with ancillary data returns
    /// `EWOULDBLOCK` when the payload length is at or just under `SO_SNDBUF`.
    #[cfg(apple)]
    const MIN_SAFE_SNDBUF: usize = 65535 + cmsg::LEN;

    /// Safety net returning `EMSGSIZE` for payload sizes in the bug's region.
    #[cfg(apple)]
    pub(crate) fn check_send_buffer_limit(
        &self,
        resid: usize,
        hdr: &impl cmsg::MsgHdr,
    ) -> io::Result<()> {
        let needed = resid.saturating_add(hdr.control_len());
        let sndbuf = self.send_buffer_size.load(Ordering::Relaxed);
        if needed > sndbuf {
            crate::log::debug!("EMSGSIZE for {needed}-byte send: exceeds SO_SNDBUF ({sndbuf})");
            return Err(io::Error::from_raw_os_error(libc::EMSGSIZE));
        }
        Ok(())
    }
}

#[cfg(not(any(apple, target_os = "openbsd", target_os = "netbsd")))]
fn send(
    #[allow(unused_variables)] // only used on Linux
    state: &UdpSocketState,
    io: SockRef<'_>,
    transmit: &Transmit<'_>,
) -> io::Result<()> {
    #[allow(unused_mut)] // only mutable on FreeBSD
    let mut encode_src_ip = true;
    #[cfg(target_os = "freebsd")]
    {
        let addr = io.local_addr()?;
        let is_ipv4 = addr.family() == libc::AF_INET as libc::sa_family_t;
        if is_ipv4 {
            if let Some(socket) = addr.as_socket_ipv4() {
                encode_src_ip = socket.ip() == &Ipv4Addr::UNSPECIFIED;
            }
        }
    }
    let mut msg_hdr: libc::msghdr = unsafe { mem::zeroed() };
    let mut iovec: libc::iovec = unsafe { mem::zeroed() };
    let mut cmsgs = cmsg::Aligned([0u8; cmsg::LEN]);
    let dst_addr = socket2::SockAddr::from(transmit.destination);
    prepare_msg(
        transmit,
        &dst_addr,
        &mut msg_hdr,
        &mut iovec,
        &mut cmsgs,
        encode_src_ip,
        state.sendmsg_einval(),
    );

    loop {
        let n = unsafe { libc::sendmsg(io.as_raw_fd(), &msg_hdr, 0) };

        if n >= 0 {
            return Ok(());
        }

        let e = io::Error::last_os_error();
        match e.kind() {
            // Retry the transmission
            io::ErrorKind::Interrupted => continue,
            io::ErrorKind::WouldBlock => return Err(e),
            _ => {
                // Some network adapters and drivers do not support GSO. Unfortunately, Linux
                // offers no easy way for us to detect this short of an EIO or sometimes EINVAL
                // when we try to actually send datagrams using it.
                #[cfg(any(target_os = "linux", target_os = "android"))]
                if let Some(libc::EIO) | Some(libc::EINVAL) = e.raw_os_error() {
                    // Prevent new transmits from being scheduled using GSO. Existing GSO transmits
                    // may already be in the pipeline, so we need to tolerate additional failures.
                    if state.max_gso_segments() > 1 {
                        crate::log::info!(
                            "`libc::sendmsg` failed with {e}; halting segmentation offload"
                        );
                        state.max_gso_segments.store(1, Ordering::Relaxed);
                    }
                }

                // Some arguments to `sendmsg` are not supported. Switch to
                // fallback mode and retry if we haven't already.
                if matches!(e.raw_os_error(), Some(libc::EINVAL) | Some(libc::EIO))
                    && !state.sendmsg_einval()
                {
                    state.set_sendmsg_einval();
                    prepare_msg(
                        transmit,
                        &dst_addr,
                        &mut msg_hdr,
                        &mut iovec,
                        &mut cmsgs,
                        encode_src_ip,
                        state.sendmsg_einval(),
                    );
                    continue;
                }

                return Err(e);
            }
        }
    }
}

#[cfg(any(target_os = "openbsd", target_os = "netbsd", apple_slow))]
fn send(state: &UdpSocketState, io: SockRef<'_>, transmit: &Transmit<'_>) -> io::Result<()> {
    send_single(state, io, transmit)
}

#[cfg(any(target_os = "openbsd", target_os = "netbsd", apple))]
#[cfg_attr(apple_fast, allow(dead_code))] // Unused when apple_fast is enabled
pub(crate) fn send_single(
    state: &UdpSocketState,
    io: SockRef<'_>,
    transmit: &Transmit<'_>,
) -> io::Result<()> {
    let mut hdr: libc::msghdr = unsafe { mem::zeroed() };
    let mut iov: libc::iovec = unsafe { mem::zeroed() };
    let mut ctrl = cmsg::Aligned([0u8; cmsg::LEN]);
    let addr = socket2::SockAddr::from(transmit.destination);
    prepare_msg(
        transmit,
        &addr,
        &mut hdr,
        &mut iov,
        &mut ctrl,
        cfg!(apple) || cfg!(target_os = "openbsd") || cfg!(target_os = "netbsd"),
        state.sendmsg_einval(),
    );
    #[cfg(apple)]
    state.check_send_buffer_limit(transmit.contents.len(), &hdr)?;
    retry_if_interrupted(|| unsafe { libc::sendmsg(io.as_raw_fd(), &hdr, 0) })?;
    Ok(())
}

/// Receive using the batched `recvmmsg` syscall
#[cfg(not(any(
    apple,
    target_os = "openbsd",
    target_os = "netbsd",
    target_os = "dragonfly",
    target_os = "redox",
    target_os = "hurd",
    solarish
)))]
fn recv_via_recvmmsg(
    io: SockRef<'_>,
    bufs: &mut [IoSliceMut<'_>],
    meta: &mut [RecvMeta],
) -> io::Result<usize> {
    let mut names = [MaybeUninit::<libc::sockaddr_storage>::uninit(); BATCH_SIZE];
    let mut ctrls = [cmsg::Aligned(MaybeUninit::<[u8; cmsg::LEN]>::uninit()); BATCH_SIZE];
    let mut hdrs = unsafe { mem::zeroed::<[libc::mmsghdr; BATCH_SIZE]>() };
    let max_msg_count = bufs.len().min(BATCH_SIZE);
    for i in 0..max_msg_count {
        prepare_recv(
            &mut bufs[i],
            &mut names[i],
            &mut ctrls[i],
            &mut hdrs[i].msg_hdr,
        );
    }
    let msg_count = retry_if_interrupted(|| unsafe {
        libc::recvmmsg(
            io.as_raw_fd(),
            hdrs.as_mut_ptr(),
            bufs.len().min(BATCH_SIZE) as _,
            0,
            ptr::null_mut::<libc::timespec>(),
        ) as isize
    })?;
    for i in 0..(msg_count as usize) {
        meta[i] = decode_recv(&names[i], &hdrs[i].msg_hdr, hdrs[i].msg_len as usize)?;
    }
    Ok(msg_count as usize)
}

#[cfg(any(
    target_os = "openbsd",
    target_os = "netbsd",
    target_os = "dragonfly",
    target_os = "redox",
    target_os = "hurd",
    solarish,
    apple
))]
#[cfg_attr(apple_fast, allow(dead_code))] // Unused when apple_fast is enabled
pub(crate) fn recv_single(
    io: SockRef<'_>,
    bufs: &mut [IoSliceMut<'_>],
    meta: &mut [RecvMeta],
) -> io::Result<usize> {
    let mut name = MaybeUninit::<libc::sockaddr_storage>::uninit();
    let mut ctrl = cmsg::Aligned(MaybeUninit::<[u8; cmsg::LEN]>::uninit());
    let mut hdr = unsafe { mem::zeroed::<libc::msghdr>() };
    prepare_recv(&mut bufs[0], &mut name, &mut ctrl, &mut hdr);
    let n = loop {
        let n = unsafe { libc::recvmsg(io.as_raw_fd(), &mut hdr, 0) };

        if hdr.msg_flags & libc::MSG_TRUNC != 0 {
            continue;
        }

        if n >= 0 {
            break n;
        }

        let e = io::Error::last_os_error();
        match e.kind() {
            // Retry receiving
            io::ErrorKind::Interrupted => continue,
            _ => return Err(e),
        }
    };
    meta[0] = decode_recv(&name, &hdr, n as usize)?;
    Ok(1)
}

#[cfg_attr(apple_fast, allow(dead_code))] // Unused when apple_fast is enabled
fn prepare_msg(
    transmit: &Transmit<'_>,
    dst_addr: &socket2::SockAddr,
    hdr: &mut libc::msghdr,
    iov: &mut libc::iovec,
    ctrl: &mut cmsg::Aligned<[u8; cmsg::LEN]>,
    #[allow(unused_variables)] // only used on FreeBSD & macOS
    encode_src_ip: bool,
    sendmsg_einval: bool,
) {
    iov.iov_base = transmit.contents.as_ptr() as *const _ as *mut _;
    iov.iov_len = transmit.contents.len();

    // SAFETY: Casting the pointer to a mutable one is legal,
    // as sendmsg is guaranteed to not alter the mutable pointer
    // as per the POSIX spec. See the section on the sys/socket.h
    // header for details. The type is only mutable in the first
    // place because it is reused by recvmsg as well.
    let name = dst_addr.as_ptr() as *mut libc::c_void;
    let namelen = dst_addr.len();
    hdr.msg_name = name as *mut _;
    hdr.msg_namelen = namelen;
    hdr.msg_iov = iov;
    hdr.msg_iovlen = 1;

    hdr.msg_control = ctrl.0.as_mut_ptr() as _;
    hdr.msg_controllen = cmsg::LEN as _;
    let mut encoder = unsafe { cmsg::Encoder::new(hdr) };
    let ecn = transmit.ecn.map_or(0, |x| x as libc::c_int);
    // True for IPv4 or IPv4-Mapped IPv6
    let is_ipv4 = transmit.destination.is_ipv4()
        || matches!(transmit.destination.ip(), IpAddr::V6(addr) if addr.to_ipv4_mapped().is_some());
    if is_ipv4 {
        if !sendmsg_einval {
            #[cfg(not(target_os = "netbsd"))]
            {
                encoder.push(libc::IPPROTO_IP, libc::IP_TOS, ecn as IpTosTy);
            }
        }
    } else {
        #[cfg(not(target_os = "redox"))]
        encoder.push(libc::IPPROTO_IPV6, libc::IPV6_TCLASS, ecn);
    }

    // On apple_fast, prepare_msg is only compiled for send_single (fallback path), while the main
    // send path uses prepare_msg_x with msghdr_x. gso::set_segment_size has a different signature
    // when apple_fast is enabled, and it's a no-op on non-Linux platforms anyway.
    #[cfg(not(apple_fast))]
    if let Some(segment_size) = transmit.effective_segment_size() {
        gso::set_segment_size(&mut encoder, segment_size as u16);
    }

    if let Some(ip) = &transmit.src_ip {
        match ip {
            IpAddr::V4(v4) => {
                #[cfg(any(target_os = "linux", target_os = "android"))]
                {
                    let pktinfo = libc::in_pktinfo {
                        ipi_ifindex: 0,
                        ipi_spec_dst: libc::in_addr {
                            s_addr: u32::from_ne_bytes(v4.octets()),
                        },
                        ipi_addr: libc::in_addr { s_addr: 0 },
                    };
                    encoder.push(libc::IPPROTO_IP, libc::IP_PKTINFO, pktinfo);
                }
                #[cfg(any(bsd, apple, solarish))]
                {
                    if encode_src_ip {
                        let addr = libc::in_addr {
                            s_addr: u32::from_ne_bytes(v4.octets()),
                        };
                        encoder.push(libc::IPPROTO_IP, libc::IP_RECVDSTADDR, addr);
                    }
                }
            }
            #[cfg(any(target_os = "redox", target_os = "hurd"))]
            IpAddr::V6(_) => {}
            #[cfg(not(any(target_os = "redox", target_os = "hurd")))]
            IpAddr::V6(v6) => {
                let pktinfo = libc::in6_pktinfo {
                    ipi6_ifindex: 0,
                    ipi6_addr: libc::in6_addr {
                        s6_addr: v6.octets(),
                    },
                };
                encoder.push(libc::IPPROTO_IPV6, libc::IPV6_PKTINFO, pktinfo);
            }
        }
    }

    encoder.finish();
}

#[cfg_attr(apple_fast, allow(dead_code))] // Unused when apple_fast is enabled
fn prepare_recv(
    buf: &mut IoSliceMut<'_>,
    name: &mut MaybeUninit<libc::sockaddr_storage>,
    ctrl: &mut cmsg::Aligned<MaybeUninit<[u8; cmsg::LEN]>>,
    hdr: &mut libc::msghdr,
) {
    hdr.msg_name = name.as_mut_ptr() as _;
    hdr.msg_namelen = size_of::<libc::sockaddr_storage>() as _;
    hdr.msg_iov = buf as *mut IoSliceMut<'_> as *mut libc::iovec;
    hdr.msg_iovlen = 1;
    hdr.msg_control = ctrl.0.as_mut_ptr() as _;
    hdr.msg_controllen = cmsg::LEN as _;
    hdr.msg_flags = 0;
}

pub(crate) fn decode_recv<M: cmsg::MsgHdr<ControlMessage = libc::cmsghdr>>(
    name: &MaybeUninit<libc::sockaddr_storage>,
    hdr: &M,
    len: usize,
) -> io::Result<RecvMeta> {
    let name = unsafe { name.assume_init() };
    let mut ctrl = ControlMetadata {
        ecn_bits: 0,
        dst_ip: None,
        interface_index: None,
        stride: len,
        timestamp: None,
    };

    let cmsg_iter = unsafe { cmsg::Iter::new(hdr) };
    for cmsg in cmsg_iter {
        ctrl.decode(cmsg);
    }

    Ok(RecvMeta {
        len,
        stride: ctrl.stride,
        addr: decode_socket_addr(&name)?,
        ecn: EcnCodepoint::from_bits(ctrl.ecn_bits),
        dst_ip: ctrl.dst_ip,
        interface_index: ctrl.interface_index,
        timestamp: ctrl.timestamp,
    })
}

/// Metadata decoded from control messages
struct ControlMetadata {
    ecn_bits: u8,
    dst_ip: Option<IpAddr>,
    interface_index: Option<u32>,
    stride: usize,
    timestamp: Option<Duration>,
}

impl ControlMetadata {
    /// Decodes a control message and updates the metadata state
    fn decode(&mut self, cmsg: &libc::cmsghdr) {
        match (cmsg.cmsg_level, cmsg.cmsg_type) {
            (libc::IPPROTO_IP, libc::IP_TOS) => unsafe {
                self.ecn_bits = cmsg::decode::<u8, libc::cmsghdr>(cmsg);
            },
            // FreeBSD uses IP_RECVTOS here, and we can be liberal because cmsgs are opt-in.
            #[cfg(not(any(
                target_os = "openbsd",
                target_os = "netbsd",
                target_os = "dragonfly",
                target_os = "hurd",
                solarish
            )))]
            (libc::IPPROTO_IP, libc::IP_RECVTOS) => unsafe {
                self.ecn_bits = cmsg::decode::<u8, libc::cmsghdr>(cmsg);
            },
            #[cfg(not(target_os = "redox",))]
            (libc::IPPROTO_IPV6, libc::IPV6_TCLASS) => unsafe {
                // Temporary hack around broken macos ABI. Remove once upstream fixes it.
                // https://bugreport.apple.com/web/?problemID=48761855
                #[allow(clippy::unnecessary_cast)] // cmsg.cmsg_len defined as size_t
                if cfg!(apple)
                    && cmsg.cmsg_len as usize == libc::CMSG_LEN(size_of::<u8>() as _) as usize
                {
                    self.ecn_bits = cmsg::decode::<u8, libc::cmsghdr>(cmsg);
                } else {
                    self.ecn_bits = cmsg::decode::<libc::c_int, libc::cmsghdr>(cmsg) as u8;
                }
            },
            #[cfg(any(target_os = "linux", target_os = "android"))]
            (libc::IPPROTO_IP, libc::IP_PKTINFO) => {
                let pktinfo = unsafe { cmsg::decode::<libc::in_pktinfo, libc::cmsghdr>(cmsg) };
                self.dst_ip = Some(IpAddr::V4(Ipv4Addr::from(
                    pktinfo.ipi_addr.s_addr.to_ne_bytes(),
                )));
                self.interface_index = Some(pktinfo.ipi_ifindex as u32);
            }
            #[cfg(any(bsd, apple))]
            (libc::IPPROTO_IP, libc::IP_RECVDSTADDR) => {
                let in_addr = unsafe { cmsg::decode::<libc::in_addr, libc::cmsghdr>(cmsg) };
                self.dst_ip = Some(IpAddr::V4(Ipv4Addr::from(in_addr.s_addr.to_ne_bytes())));
            }
            #[cfg(not(any(target_os = "redox", target_os = "hurd")))]
            (libc::IPPROTO_IPV6, libc::IPV6_PKTINFO) => {
                let pktinfo = unsafe { cmsg::decode::<libc::in6_pktinfo, libc::cmsghdr>(cmsg) };
                self.dst_ip = Some(IpAddr::V6(Ipv6Addr::from(pktinfo.ipi6_addr.s6_addr)));
                #[cfg_attr(not(target_os = "android"), expect(clippy::unnecessary_cast))]
                {
                    self.interface_index = Some(pktinfo.ipi6_ifindex as u32);
                }
            }
            #[cfg(any(target_os = "linux", target_os = "android"))]
            (libc::SOL_UDP, libc::UDP_GRO) => unsafe {
                self.stride = cmsg::decode::<libc::c_int, libc::cmsghdr>(cmsg) as usize;
            },
            #[cfg(any(target_os = "linux", target_os = "android"))]
            (libc::SOL_SOCKET, libc::SCM_TIMESTAMPNS) => {
                let ts = unsafe { cmsg::decode::<libc::timespec, libc::cmsghdr>(cmsg) };
                let secs = u64::try_from(ts.tv_sec).unwrap_or(0);
                let nsecs = u32::try_from(ts.tv_nsec).unwrap_or(0);
                self.timestamp = Some(Duration::new(secs, nsecs));
            }
            _ => {}
        }
    }
}

/// Decodes a `sockaddr_storage` into a `SocketAddr`
pub(crate) fn decode_socket_addr(name: &libc::sockaddr_storage) -> io::Result<SocketAddr> {
    match libc::c_int::from(name.ss_family) {
        libc::AF_INET => {
            // Safety: if the ss_family field is AF_INET then storage must be a sockaddr_in.
            let addr: &libc::sockaddr_in =
                unsafe { &*(name as *const _ as *const libc::sockaddr_in) };
            Ok(SocketAddr::V4(SocketAddrV4::new(
                Ipv4Addr::from(addr.sin_addr.s_addr.to_ne_bytes()),
                u16::from_be(addr.sin_port),
            )))
        }
        libc::AF_INET6 => {
            // Safety: if the ss_family field is AF_INET6 then storage must be a sockaddr_in6.
            let addr: &libc::sockaddr_in6 =
                unsafe { &*(name as *const _ as *const libc::sockaddr_in6) };
            Ok(SocketAddr::V6(SocketAddrV6::new(
                Ipv6Addr::from(addr.sin6_addr.s6_addr),
                u16::from_be(addr.sin6_port),
                addr.sin6_flowinfo,
                addr.sin6_scope_id,
            )))
        }
        f => Err(io::Error::other(format!(
            "expected AF_INET or AF_INET6, got {f}"
        ))),
    }
}

#[cfg(not(apple_slow))]
// Chosen somewhat arbitrarily; might benefit from additional tuning.
pub(crate) const BATCH_SIZE: usize = 32;

#[cfg(apple_slow)]
pub(crate) const BATCH_SIZE: usize = 1;

// On Apple platforms using the `sendmsg_x` call, UDP datagram segmentation is not
// offloaded to the NIC or even the kernel, but instead done here in user space in
// [`send`]) and then passed to the OS as individual `iovec`s (up to `BATCH_SIZE`).
// The initial value is 1 (no batching); callers can enable batching via
// `UdpSocketState::set_apple_fast_path()` which updates `max_gso_segments`.
#[cfg(not(any(target_os = "linux", target_os = "android")))]
mod gso {
    use super::*;

    pub(super) fn max_gso_segments(_socket: &impl AsRawFd) -> usize {
        1
    }

    #[cfg_attr(apple_fast, allow(dead_code))] // Unused when apple_fast is enabled
    pub(super) fn set_segment_size(
        #[cfg(not(apple_fast))] _encoder: &mut cmsg::Encoder<'_, libc::msghdr>,
        #[cfg(apple_fast)] _encoder: &mut cmsg::Encoder<'_, msghdr_x>,
        _segment_size: u16,
    ) {
    }
}

#[cfg(target_os = "freebsd")]
type IpTosTy = libc::c_uchar;
#[cfg(not(any(target_os = "freebsd", target_os = "netbsd")))]
pub(crate) type IpTosTy = libc::c_int;

/// Returns whether the given socket option is supported on the current platform
///
/// Yields `Ok(true)` if the option was set successfully, `Ok(false)` if setting
/// the option raised an `ENOPROTOOPT` or `EOPNOTSUPP` error, and `Err` for any other error.
fn set_socket_option_supported(
    socket: &impl AsRawFd,
    level: libc::c_int,
    name: libc::c_int,
    value: libc::c_int,
) -> io::Result<bool> {
    match set_socket_option(socket, level, name, value) {
        Ok(()) => Ok(true),
        Err(err) if err.raw_os_error() == Some(libc::ENOPROTOOPT) => Ok(false),
        Err(err) if err.raw_os_error() == Some(libc::EOPNOTSUPP) => Ok(false),
        Err(err) => Err(err),
    }
}

pub(crate) fn set_socket_option(
    socket: &impl AsRawFd,
    level: libc::c_int,
    name: libc::c_int,
    value: libc::c_int,
) -> io::Result<()> {
    let rc = unsafe {
        libc::setsockopt(
            socket.as_raw_fd(),
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

const OPTION_ON: libc::c_int = 1;

/// Calls `f` in a loop, retrying on `EINTR`
///
/// Returns the non-negative result or the first non-`EINTR` error.
pub(crate) fn retry_if_interrupted(mut f: impl FnMut() -> isize) -> io::Result<isize> {
    loop {
        let n = f();
        if n >= 0 {
            return Ok(n);
        }
        let e = io::Error::last_os_error();
        if e.kind() != io::ErrorKind::Interrupted {
            return Err(e);
        }
    }
}
