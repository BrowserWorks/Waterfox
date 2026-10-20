#[cfg(apple)]
use std::io::{self, IoSlice};
#[cfg(not(any(
    target_os = "openbsd",
    target_os = "netbsd",
    target_os = "wasi",
    solarish
)))]
use std::net::{SocketAddr, SocketAddrV6};
#[cfg(apple)]
use std::os::fd::AsRawFd;
#[cfg(any(target_os = "linux", target_os = "android"))]
use std::time::Duration;
use std::{
    io::IoSliceMut,
    net::{IpAddr, Ipv4Addr, Ipv6Addr, SocketAddrV4, UdpSocket},
    slice,
};

#[cfg(not(target_os = "wasi"))]
use quinn_udp::EcnCodepoint;
use quinn_udp::{RecvMeta, Transmit, UdpSockRef, UdpSocketState};
#[cfg(apple)]
use socket2::MsgHdr;
use socket2::Socket;

#[test]
fn basic() {
    let send = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0))
        .or_else(|_| UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)))
        .unwrap();
    let recv = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0))
        .or_else(|_| UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)))
        .unwrap();
    let dst_addr = recv.local_addr().unwrap();
    test_send_recv(
        &send.into(),
        &recv.into(),
        Transmit {
            destination: dst_addr,
            ecn: None,
            contents: b"hello",
            segment_size: None,
            src_ip: None,
        },
    );
}

#[test]
fn state_before_bind() {
    for domain in [socket2::Domain::IPV6, socket2::Domain::IPV4] {
        let Ok(socket) = Socket::new(domain, socket2::Type::DGRAM, None) else {
            continue;
        };
        UdpSocketState::new((&socket).into()).unwrap();
    }
}

#[test]
fn basic_src_ip() {
    let send = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0))
        .or_else(|_| UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)))
        .unwrap();
    let recv = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0))
        .or_else(|_| UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)))
        .unwrap();
    let src_ip = send.local_addr().unwrap().ip();
    let dst_addr = recv.local_addr().unwrap();
    test_send_recv(
        &send.into(),
        &recv.into(),
        Transmit {
            destination: dst_addr,
            ecn: None,
            contents: b"hello",
            segment_size: None,
            src_ip: Some(src_ip),
        },
    );
}

// The WASI backend sets no ECN codepoint and always reports `None`.
#[test]
#[cfg(not(target_os = "wasi"))]
fn ecn_v6() {
    let send = Socket::from(UdpSocket::bind((Ipv6Addr::LOCALHOST, 0)).unwrap());
    let recv = Socket::from(UdpSocket::bind((Ipv6Addr::LOCALHOST, 0)).unwrap());
    for codepoint in [EcnCodepoint::Ect0, EcnCodepoint::Ect1] {
        test_send_recv(
            &send,
            &recv,
            Transmit {
                destination: recv.local_addr().unwrap().as_socket().unwrap(),
                ecn: Some(codepoint),
                contents: b"hello",
                segment_size: None,
                src_ip: None,
            },
        );
    }
}

#[test]
#[cfg(not(any(
    target_os = "openbsd",
    target_os = "netbsd",
    target_os = "wasi",
    solarish
)))]
fn ecn_v4() {
    let send = Socket::from(UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap());
    let recv = Socket::from(UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap());
    for codepoint in [EcnCodepoint::Ect0, EcnCodepoint::Ect1] {
        test_send_recv(
            &send,
            &recv,
            Transmit {
                destination: recv.local_addr().unwrap().as_socket().unwrap(),
                ecn: Some(codepoint),
                contents: b"hello",
                segment_size: None,
                src_ip: None,
            },
        );
    }
}

#[test]
#[cfg(not(any(
    target_os = "openbsd",
    target_os = "netbsd",
    target_os = "wasi",
    solarish
)))]
fn ecn_v6_dualstack() {
    let recv = Socket::new(
        socket2::Domain::IPV6,
        socket2::Type::DGRAM,
        Some(socket2::Protocol::UDP),
    )
    .unwrap();
    recv.set_only_v6(false).unwrap();
    // We must use the unspecified address here, rather than a local address, to support dual-stack
    // mode
    recv.bind(&socket2::SockAddr::from(
        "[::]:0".parse::<SocketAddr>().unwrap(),
    ))
    .unwrap();
    let recv_v6 = SocketAddr::V6(SocketAddrV6::new(
        Ipv6Addr::LOCALHOST,
        recv.local_addr().unwrap().as_socket().unwrap().port(),
        0,
        0,
    ));
    let recv_v4 = SocketAddr::V4(SocketAddrV4::new(Ipv4Addr::LOCALHOST, recv_v6.port()));
    for (src, dst) in [
        (SocketAddr::new(IpAddr::V6(Ipv6Addr::LOCALHOST), 0), recv_v6),
        (SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 0), recv_v4),
    ] {
        dbg!(src, dst);
        let send = UdpSocket::bind(src).unwrap();
        let send = Socket::from(send);
        for codepoint in [EcnCodepoint::Ect0, EcnCodepoint::Ect1] {
            test_send_recv(
                &send,
                &recv,
                Transmit {
                    destination: dst,
                    ecn: Some(codepoint),
                    contents: b"hello",
                    segment_size: None,
                    src_ip: None,
                },
            );
        }
    }
}

#[test]
#[cfg(not(any(
    target_os = "openbsd",
    target_os = "netbsd",
    target_os = "wasi",
    solarish
)))]
fn ecn_v4_mapped_v6() {
    let send = Socket::new(
        socket2::Domain::IPV6,
        socket2::Type::DGRAM,
        Some(socket2::Protocol::UDP),
    )
    .unwrap();
    send.set_only_v6(false).unwrap();
    send.bind(&socket2::SockAddr::from(
        "[::]:0".parse::<SocketAddr>().unwrap(),
    ))
    .unwrap();

    let recv = UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap();
    let recv = Socket::from(recv);
    let recv_v4_mapped_v6 = SocketAddr::V6(SocketAddrV6::new(
        Ipv4Addr::LOCALHOST.to_ipv6_mapped(),
        recv.local_addr().unwrap().as_socket().unwrap().port(),
        0,
        0,
    ));

    for codepoint in [EcnCodepoint::Ect0, EcnCodepoint::Ect1] {
        test_send_recv(
            &send,
            &recv,
            Transmit {
                destination: recv_v4_mapped_v6,
                ecn: Some(codepoint),
                contents: b"hello",
                segment_size: None,
                src_ip: None,
            },
        );
    }
}

#[test]
#[cfg_attr(
    not(any(target_os = "linux", target_os = "windows", target_os = "android")),
    ignore
)]
fn gso() {
    let send = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0))
        .or_else(|_| UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)))
        .unwrap();
    let recv = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0))
        .or_else(|_| UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)))
        .unwrap();
    let max_segments = UdpSocketState::new((&send).into())
        .unwrap()
        .max_gso_segments();
    let dst_addr = recv.local_addr().unwrap();
    const SEGMENT_SIZE: usize = 128;
    let msg = vec![0xAB; SEGMENT_SIZE * max_segments];
    test_send_recv(
        &send.into(),
        &recv.into(),
        Transmit {
            destination: dst_addr,
            ecn: None,
            contents: &msg,
            segment_size: Some(SEGMENT_SIZE),
            src_ip: None,
        },
    );
}

/// A single datagram larger than the segment size used to probe for GSO support must be
/// delivered as one datagram. The probe must not leave segmentation enabled on the socket.
#[test]
fn large_single_datagram_is_not_segmented() {
    let send = UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap();
    let recv = UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap();
    let dst_addr = recv.local_addr().unwrap();
    // Larger than the 1500 byte segment size of the GSO probe.
    let msg = vec![0xCD; 2048];
    test_send_recv(
        &send.into(),
        &recv.into(),
        Transmit {
            destination: dst_addr,
            ecn: None,
            contents: &msg,
            segment_size: None,
            src_ip: None,
        },
    );
}

#[test]
fn socket_buffers() {
    const BUFFER_SIZE: usize = 123456;
    const FACTOR: usize = if cfg!(any(target_os = "linux", target_os = "android")) {
        2 // Linux and Android set the buffer to double the requested size
    } else {
        1 // Everyone else is sane.
    };

    let send = Socket::new(
        socket2::Domain::IPV4,
        socket2::Type::DGRAM,
        Some(socket2::Protocol::UDP),
    )
    .unwrap();
    let recv = Socket::new(
        socket2::Domain::IPV4,
        socket2::Type::DGRAM,
        Some(socket2::Protocol::UDP),
    )
    .unwrap();
    for sock in [&send, &recv] {
        sock.bind(&socket2::SockAddr::from(SocketAddrV4::new(
            Ipv4Addr::LOCALHOST,
            0,
        )))
        .unwrap();

        let socket_state = UdpSocketState::new(sock.into()).expect("created socket state");

        // Change the send buffer size.
        let buffer_before = socket_state.send_buffer_size(sock.into()).unwrap();
        assert_ne!(
            buffer_before,
            BUFFER_SIZE * FACTOR,
            "make sure buffer is not already desired size"
        );
        socket_state
            .set_send_buffer_size(sock.into(), BUFFER_SIZE)
            .expect("set send buffer size {buffer_before} -> {BUFFER_SIZE}");
        let buffer_after = socket_state.send_buffer_size(sock.into()).unwrap();
        assert_eq!(
            buffer_after,
            BUFFER_SIZE * FACTOR,
            "setting send buffer size to {BUFFER_SIZE} resulted in {buffer_before} -> {buffer_after}",
        );

        // Change the receive buffer size.
        let buffer_before = socket_state.recv_buffer_size(sock.into()).unwrap();
        socket_state
            .set_recv_buffer_size(sock.into(), BUFFER_SIZE)
            .expect("set recv buffer size {buffer_before} -> {BUFFER_SIZE}");
        let buffer_after = socket_state.recv_buffer_size(sock.into()).unwrap();
        assert_eq!(
            buffer_after,
            BUFFER_SIZE * FACTOR,
            "setting recv buffer size to {BUFFER_SIZE} resulted in {buffer_before} -> {buffer_after}",
        );
    }

    test_send_recv(
        &send,
        &recv,
        Transmit {
            destination: recv.local_addr().unwrap().as_socket().unwrap(),
            ecn: None,
            contents: b"hello",
            segment_size: None,
            src_ip: None,
        },
    );
}

fn test_send_recv(send: &Socket, recv: &Socket, transmit: Transmit<'_>) {
    let send_state = UdpSocketState::new(send.into()).unwrap();
    let recv_state = UdpSocketState::new(recv.into()).unwrap();

    // Reverse non-blocking flag set by `UdpSocketState` to make the test non-racy
    UdpSockRef::from(send).set_nonblocking(false).unwrap();
    UdpSockRef::from(recv).set_nonblocking(false).unwrap();

    send_state.try_send(send.into(), &transmit).unwrap();

    let mut buf = [0; u16::MAX as usize];
    let mut meta = RecvMeta::default();
    let segment_size = transmit.segment_size.unwrap_or(transmit.contents.len());
    let expected_datagrams = transmit.contents.len() / segment_size;
    let mut datagrams = 0;
    while datagrams < expected_datagrams {
        let n = recv_state
            .recv(
                recv.into(),
                &mut [IoSliceMut::new(&mut buf)],
                slice::from_mut(&mut meta),
            )
            .unwrap();
        assert_eq!(n, 1);
        let segments = meta.len / meta.stride;
        for i in 0..segments {
            assert_eq!(
                &buf[(i * meta.stride)..((i + 1) * meta.stride)],
                &transmit.contents
                    [(datagrams + i) * segment_size..(datagrams + i + 1) * segment_size]
            );
        }
        datagrams += segments;

        assert_eq!(
            meta.addr.port(),
            send.local_addr().unwrap().as_socket().unwrap().port()
        );
        let send_v6 = send.local_addr().unwrap().as_socket().unwrap().is_ipv6();
        let recv_v6 = recv.local_addr().unwrap().as_socket().unwrap().is_ipv6();
        let mut addresses = vec![meta.addr.ip()];
        // Not populated on every OS. See `RecvMeta::dst_ip` for details.
        if let Some(addr) = meta.dst_ip {
            addresses.push(addr);
        }
        for addr in addresses {
            match (send_v6, recv_v6) {
                (_, false) => assert_eq!(addr, Ipv4Addr::LOCALHOST),
                // Windows gives us real IPv4 addrs, whereas *nix use IPv6-mapped IPv4
                // addrs. Canonicalize to IPv6-mapped for robustness.
                (false, true) => {
                    assert_eq!(ip_to_v6_mapped(addr), Ipv4Addr::LOCALHOST.to_ipv6_mapped())
                }
                (true, true) => assert!(
                    addr == Ipv6Addr::LOCALHOST || addr == Ipv4Addr::LOCALHOST.to_ipv6_mapped()
                ),
            }
        }

        let ipv4_or_ipv4_mapped_ipv6 = match transmit.destination.ip() {
            IpAddr::V4(_) => true,
            IpAddr::V6(a) => a.to_ipv4_mapped().is_some(),
        };

        // On Android API level <= 25 the IPv4 `IP_TOS` control message is
        // not supported and thus ECN bits can not be received.
        if ipv4_or_ipv4_mapped_ipv6
            && cfg!(target_os = "android")
            && std::env::var("API_LEVEL")
                .ok()
                .and_then(|v| v.parse::<u32>().ok())
                .expect("API_LEVEL environment variable to be set on Android")
                <= 25
        {
            assert_eq!(meta.ecn, None);
        } else {
            assert_eq!(meta.ecn, transmit.ecn);
        }

        // On Linux and Android, we expect the kernel to provide a receive timestamp
        // since we explicitly enabled `SO_TIMESTAMPNS`.
        #[cfg(any(target_os = "linux", target_os = "android"))]
        {
            assert!(
                meta.timestamp.is_some(),
                "Kernel timestamp should be present on Linux/Android"
            );
            assert!(
                meta.timestamp.unwrap() > Duration::ZERO,
                "Kernel timestamp should be non-zero"
            );
        }

        // On other platforms, the timestamp should remain `None`.
        #[cfg(not(any(target_os = "linux", target_os = "android")))]
        {
            assert!(meta.timestamp.is_none());
        }
    }
    assert_eq!(datagrams, expected_datagrams);
}

fn ip_to_v6_mapped(x: IpAddr) -> IpAddr {
    match x {
        IpAddr::V4(x) => IpAddr::V6(x.to_ipv6_mapped()),
        IpAddr::V6(_) => x,
    }
}

/// Test Apple fast datapath enable/disable functionality.
///
/// This test verifies that:
/// 1. `max_gso_segments()` returns 1 by default (fast path disabled)
/// 2. After calling `set_apple_fast_path()`, `max_gso_segments()` returns `BATCH_SIZE`
/// 3. Send/recv still works correctly with the fast path enabled
#[test]
#[cfg(apple_fast)]
fn apple_fast_datapath() {
    let send = UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap();
    let recv = UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap();
    let dst_addr = recv.local_addr().unwrap();

    let send_state = UdpSocketState::new((&send).into()).unwrap();
    let recv_state = UdpSocketState::new((&recv).into()).unwrap();

    // Initially, fast path should be disabled and max_gso_segments should be 1
    assert!(
        !send_state.is_apple_fast_path_enabled(),
        "fast path should be disabled initially"
    );
    assert_eq!(
        send_state.max_gso_segments(),
        1,
        "max_gso_segments should be 1 before enabling fast path"
    );

    // Enable the fast path
    // SAFETY: Assume that sendmsg_x/recvmsg_x are available on the macOS test host.
    unsafe {
        send_state.set_apple_fast_path();
        recv_state.set_apple_fast_path();
    }

    // After enabling, fast path should be enabled and max_gso_segments should be BATCH_SIZE
    assert!(
        send_state.is_apple_fast_path_enabled(),
        "fast path should be enabled after calling set_apple_fast_path()"
    );
    assert_eq!(
        send_state.max_gso_segments(),
        quinn_udp::BATCH_SIZE,
        "max_gso_segments should be BATCH_SIZE after enabling fast path"
    );

    // Verify send/recv still works with fast path enabled
    recv.set_nonblocking(false).unwrap();

    const SEGMENT_SIZE: usize = 128;
    let segments = send_state.max_gso_segments();
    let msg = vec![0xAB; SEGMENT_SIZE * segments];

    send_state
        .try_send(
            (&send).into(),
            &Transmit {
                destination: dst_addr,
                ecn: None,
                contents: &msg,
                segment_size: Some(SEGMENT_SIZE),
                src_ip: None,
            },
        )
        .unwrap();

    // Receive all segments
    let mut buf = [0u8; u16::MAX as usize];
    let mut total_received = 0;
    while total_received < segments {
        let mut meta = RecvMeta::default();
        let n = recv_state
            .recv(
                (&recv).into(),
                &mut [IoSliceMut::new(&mut buf)],
                slice::from_mut(&mut meta),
            )
            .unwrap();
        assert_eq!(n, 1);
        let received_segments = meta.len / meta.stride;
        for i in 0..received_segments {
            assert_eq!(
                &buf[i * meta.stride..(i + 1) * meta.stride],
                &msg[(total_received + i) * SEGMENT_SIZE..(total_received + i + 1) * SEGMENT_SIZE],
                "segment {} content mismatch",
                total_received + i
            );
        }
        total_received += received_segments;
    }
    assert_eq!(total_received, segments, "should receive all segments");
}

#[test]
#[cfg(apple)]
fn sndbuf_cmsg_boundary() {
    let send = Socket::from(UdpSocket::bind((Ipv6Addr::LOCALHOST, 0)).unwrap());
    let recv = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0)).unwrap();
    let dst = recv.local_addr().unwrap();
    send.set_nonblocking(true).unwrap();

    let _ = send.set_send_buffer_size(9216);
    let sndbuf = send.send_buffer_size().unwrap();
    let clen = tclass_cmsg_space();

    let payload = vec![0u8; sndbuf];
    for attempt in 1..=3 {
        match raw_send_with_tclass_cmsg(&send, dst, &payload) {
            Err(e) if e.kind() == io::ErrorKind::WouldBlock => wait_writable(&send),
            other => panic!(
                "expected macOS SO_SNDBUF/cmsg kernel bug to reproduce on attempt {attempt}, got {other:?}"
            ),
        }
    }

    let state = UdpSocketState::new((&send).into()).unwrap();
    assert_min_sndbuf_enforced(&state, &send, dst, clen);
}

/// Asserts `UdpSocketState`'s `SO_SNDBUF` floor holds on `sendmsg_x`.
#[test]
#[cfg(apple_fast)]
fn sndbuf_cmsg_boundary_fast_path() {
    let send = Socket::from(UdpSocket::bind((Ipv6Addr::LOCALHOST, 0)).unwrap());
    let recv = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0)).unwrap();
    let dst = recv.local_addr().unwrap();
    send.set_nonblocking(true).unwrap();

    let state = UdpSocketState::new((&send).into()).unwrap();
    // SAFETY: assumes sendmsg_x is available on the macOS test host.
    unsafe { state.set_apple_fast_path() };
    assert_min_sndbuf_enforced(&state, &send, dst, tclass_cmsg_space());
}

/// Asserts `UdpSocketState`'s `SO_SNDBUF` floor holds on `send`.
#[cfg(apple)]
fn assert_min_sndbuf_enforced(state: &UdpSocketState, send: &Socket, dst: SocketAddr, clen: usize) {
    let _ = state.set_send_buffer_size(send.into(), 1);
    let sndbuf = state.send_buffer_size(send.into()).unwrap();
    assert!(sndbuf >= 65535 + clen);

    let transmit = Transmit {
        destination: dst,
        ecn: Some(EcnCodepoint::Ect0),
        contents: &vec![0u8; 60_000],
        segment_size: None,
        src_ip: None,
    };
    match state.try_send(send.into(), &transmit) {
        Ok(()) => {}
        Err(e) if e.raw_os_error() == Some(libc::EMSGSIZE) => {}
        Err(e) if e.kind() == io::ErrorKind::WouldBlock => {
            panic!("regressed: permanently stuck EWOULDBLOCK sending a large datagram")
        }
        Err(e) => panic!("unexpected error: {e}"),
    }
}

/// Sends `payload` with an `IPV6_TCLASS` cmsg attached via `Socket::sendmsg`.
#[cfg(apple)]
fn raw_send_with_tclass_cmsg(sock: &Socket, dst: SocketAddr, payload: &[u8]) -> io::Result<()> {
    let addr = socket2::SockAddr::from(dst);
    let iov = [IoSlice::new(payload)];

    let mut cbuf = AlignedCmsgBuf([0u8; 32]); // room for one aligned c_int cmsg
    let mut scratch: libc::msghdr = unsafe { std::mem::zeroed() };
    scratch.msg_control = cbuf.0.as_mut_ptr() as *mut _;
    scratch.msg_controllen = tclass_cmsg_space() as _;
    unsafe {
        let cmsg = libc::CMSG_FIRSTHDR(&scratch);
        (*cmsg).cmsg_level = libc::IPPROTO_IPV6;
        (*cmsg).cmsg_type = libc::IPV6_TCLASS;
        (*cmsg).cmsg_len = libc::CMSG_LEN(size_of::<libc::c_int>() as _) as _;
        std::ptr::write(
            libc::CMSG_DATA(cmsg) as *mut libc::c_int,
            EcnCodepoint::Ect0 as libc::c_int,
        );
    }

    let msg = MsgHdr::new()
        .with_addr(&addr)
        .with_buffers(&iov)
        .with_control(&cbuf.0[..tclass_cmsg_space()]);
    sock.sendmsg(&msg, 0).map(|_| ())
}

/// Blocks (via `poll()`) until `sock` reports `POLLOUT`, or panics after 2s.
#[cfg(apple)]
fn wait_writable(sock: &Socket) {
    let mut pfd = libc::pollfd {
        fd: sock.as_raw_fd(),
        events: libc::POLLOUT,
        revents: 0,
    };
    let n = unsafe { libc::poll(&mut pfd, 1, 2000) };
    assert!(n != 0, "poll() itself timed out waiting for POLLOUT");
}

#[cfg(apple)]
fn tclass_cmsg_space() -> usize {
    unsafe { libc::CMSG_SPACE(size_of::<libc::c_int>() as _) as usize }
}

#[cfg(apple)]
#[repr(align(8))]
struct AlignedCmsgBuf([u8; 32]);

#[test]
#[cfg(any(target_os = "linux", target_os = "android"))]
fn recv_transport_error() {
    let sock = Socket::from(UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap());

    let state = UdpSocketState::new((&sock).into()).unwrap();
    state
        .enable_transport_errors((&sock).into())
        .expect("failed to enable transport error recv");

    // Pick an unused port by binding then dropping.
    let unused_port = {
        let tmp = UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap();
        tmp.local_addr().unwrap().port()
    };

    let dst = SocketAddr::V4(SocketAddrV4::new(Ipv4Addr::LOCALHOST, unused_port));

    state
        .try_send(
            (&sock).into(),
            &Transmit {
                destination: dst,
                ecn: None,
                contents: b"hello",
                segment_size: None,
                src_ip: None,
            },
        )
        .unwrap();

    let mut received = None;
    for _ in 0..100 {
        match state.recv_transport_error((&sock).into()) {
            Ok(Some(err)) => {
                received = Some(err);
                break;
            }
            _ => {
                std::thread::sleep(Duration::from_millis(10));
            }
        }
    }

    let err = received.expect("ICMP Port Unreachable was not received");

    assert!(
        matches!(err.payload, quinn_udp::TransportErrorPayload::Unreachable),
        "expected ICMP destination unreachable transport error"
    );
    assert_eq!(
        err.raw_errno,
        libc::ECONNREFUSED,
        "unexpected errno decoded from MSG_ERRQUEUE"
    );
    // Linux may report port 0 in SO_EE_OFFENDER for ICMP errors.
    if let Some(addr) = err.addr {
        assert_eq!(
            addr.ip(),
            dst.ip(),
            "decoded offender IP does not match destination"
        );
    }
}

#[test]
#[cfg(any(target_os = "linux", target_os = "android"))]
fn recv_transport_error_ipv6() {
    let sock = Socket::from(UdpSocket::bind((Ipv6Addr::LOCALHOST, 0)).unwrap());

    let state = UdpSocketState::new((&sock).into()).unwrap();
    state
        .enable_transport_errors((&sock).into())
        .expect("failed to enable transport error recv");

    let unused_port = {
        let tmp = UdpSocket::bind((Ipv6Addr::LOCALHOST, 0)).unwrap();
        tmp.local_addr().unwrap().port()
    };

    let dst = SocketAddr::V6(SocketAddrV6::new(Ipv6Addr::LOCALHOST, unused_port, 0, 0));

    state
        .try_send(
            (&sock).into(),
            &Transmit {
                destination: dst,
                ecn: None,
                contents: b"hello",
                segment_size: None,
                src_ip: None,
            },
        )
        .unwrap();

    let mut received = None;

    for _ in 0..100 {
        if let Ok(Some(err)) = state.recv_transport_error((&sock).into()) {
            received = Some(err);
            break;
        }
        std::thread::sleep(Duration::from_millis(10));
    }

    let err = received.expect("ICMPv6 Port Unreachable not received");

    assert!(matches!(
        err.payload,
        quinn_udp::TransportErrorPayload::Unreachable
    ));

    assert_eq!(err.raw_errno, libc::ECONNREFUSED);

    if let Some(addr) = err.addr {
        assert_eq!(addr.ip(), dst.ip());
    }
}

/// Draining the error queue prevents queued ICMP errors from absorbing unrelated sends
///
/// When `enable_transport_errors` is active, callers are expected to drain pending
/// errors via `recv_transport_error` before transmitting. This test confirms that
/// doing so allows a subsequent send to succeed and deliver its payload.
#[test]
#[cfg(any(target_os = "linux", target_os = "android"))]
fn draining_error_queue_before_send_prevents_absorption() {
    let sock = Socket::from(UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap());

    let state = UdpSocketState::new((&sock).into()).unwrap();
    state
        .enable_transport_errors((&sock).into())
        .expect("failed to enable transport error recv");

    // Pick an unused port by binding then dropping.
    let unused_port = {
        let tmp = UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap();
        tmp.local_addr().unwrap().port()
    };

    // Enqueue an ICMP port-unreachable error
    let dst = SocketAddr::V4(SocketAddrV4::new(Ipv4Addr::LOCALHOST, unused_port));
    state
        .try_send(
            (&sock).into(),
            &Transmit {
                destination: dst,
                ecn: None,
                contents: b"hello",
                segment_size: None,
                src_ip: None,
            },
        )
        .unwrap();

    std::thread::sleep(Duration::from_millis(20));

    // Drain the error queue before sending — this is the intended usage pattern
    let mut got_error = false;
    for _ in 0..10 {
        match state.recv_transport_error((&sock).into()) {
            Ok(Some(_)) => {
                got_error = true;
                break;
            }
            _ => std::thread::sleep(Duration::from_millis(10)),
        }
    }
    assert!(got_error, "expected one queued error");

    let receiver = UdpSocket::bind((Ipv4Addr::LOCALHOST, 0)).unwrap();
    receiver.set_nonblocking(true).unwrap();

    state
        .try_send(
            (&sock).into(),
            &Transmit {
                destination: receiver.local_addr().unwrap(),
                ecn: None,
                contents: b"connection close",
                segment_size: None,
                src_ip: None,
            },
        )
        .expect("send failed after draining the error queue");

    std::thread::sleep(Duration::from_millis(20));

    let mut buf = [0u8; 64];
    let n = receiver
        .recv(&mut buf)
        .expect("packet was not delivered after draining the error queue");
    assert_eq!(&buf[..n], b"connection close");
}
