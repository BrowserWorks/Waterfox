use std::{
    io,
    mem::{self, MaybeUninit},
    net::SocketAddr,
    os::fd::AsRawFd,
    ptr,
};

use socket2::SockRef;

use crate::{
    TransportError, TransportErrorPayload, cmsg,
    imp::{decode_socket_addr, retry_if_interrupted, set_socket_option},
};

/// Decoded entry from the Linux socket error queue (`MSG_ERRQUEUE`)
#[cfg(any(target_os = "linux", target_os = "android"))]
pub(crate) struct LinuxError {
    ee: libc::sock_extended_err,
    offender: Option<SocketAddr>,
}

#[cfg(any(target_os = "linux", target_os = "android"))]
impl LinuxError {
    /// Reads one entry from the Linux socket error queue (MSG_ERRQUEUE)
    pub(crate) fn recv(io: SockRef<'_>) -> io::Result<Option<Self>> {
        let mut name = MaybeUninit::<libc::sockaddr_storage>::uninit();
        let mut ctrl = cmsg::Aligned(MaybeUninit::<[u8; Self::ERR_CMSG_LEN]>::uninit());

        // Linux requires at least one iovec even for MSG_ERRQUEUE.
        let mut iov_data = [0u8; 1];
        let mut iov = libc::iovec {
            iov_base: iov_data.as_mut_ptr() as *mut _,
            iov_len: iov_data.len(),
        };

        let mut hdr = unsafe { mem::zeroed::<libc::msghdr>() };

        hdr.msg_name = name.as_mut_ptr() as _;
        hdr.msg_namelen = size_of::<libc::sockaddr_storage>() as _;
        hdr.msg_iov = &mut iov;
        hdr.msg_iovlen = 1;
        hdr.msg_control = ctrl.0.as_mut_ptr() as _;
        hdr.msg_controllen = Self::ERR_CMSG_LEN as _;

        if let Err(err) = retry_if_interrupted(|| unsafe {
            libc::recvmsg(
                io.as_raw_fd(),
                &mut hdr,
                libc::MSG_ERRQUEUE | libc::MSG_DONTWAIT,
            )
        }) {
            if err.kind() == io::ErrorKind::WouldBlock {
                return Ok(None);
            }
            return Err(err);
        };

        if hdr.msg_flags & libc::MSG_CTRUNC != 0 {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "control message truncated",
            ));
        }

        let cmsg_iter = unsafe { cmsg::Iter::new(&hdr) };

        for cmsg in cmsg_iter {
            if let Some(raw) = Self::decode(cmsg) {
                return Ok(Some(raw));
            }
        }

        Ok(None)
    }

    /// Attempts to decode a Linux `sock_extended_err` from a MSG_ERRQUEUE control message
    pub(crate) fn decode(cmsg: &libc::cmsghdr) -> Option<Self> {
        if cmsg.cmsg_level != libc::IPPROTO_IP && cmsg.cmsg_level != libc::IPPROTO_IPV6 {
            return None;
        }

        if cmsg.cmsg_type != libc::IP_RECVERR && cmsg.cmsg_type != libc::IPV6_RECVERR {
            return None;
        }

        let required =
            unsafe { libc::CMSG_LEN(size_of::<libc::sock_extended_err>() as _) as usize };

        #[allow(clippy::unnecessary_cast)] // cmsg.cmsg_len defined as size_t
        if (cmsg.cmsg_len as usize) < required {
            return None;
        }

        let ee_ptr = unsafe { libc::CMSG_DATA(cmsg) as *const libc::sock_extended_err };
        let (ee, offender_ptr, mut storage) = unsafe {
            (
                ptr::read_unaligned(ee_ptr),
                libc::SO_EE_OFFENDER(ee_ptr),
                mem::zeroed::<libc::sockaddr_storage>(),
            )
        };

        let family = unsafe { (*offender_ptr).sa_family as i32 };
        let len = match family {
            libc::AF_INET => size_of::<libc::sockaddr_in>(),
            libc::AF_INET6 => size_of::<libc::sockaddr_in6>(),
            libc::AF_UNSPEC => return Some(Self { ee, offender: None }),
            _ => return None,
        };

        unsafe {
            ptr::copy_nonoverlapping(
                offender_ptr as *const u8,
                &mut storage as *mut _ as *mut u8,
                len,
            );
        }

        Some(Self {
            ee,
            offender: Some(decode_socket_addr(&storage).ok()?),
        })
    }

    /// Control message buffer size for socket error queue (MSG_ERRQUEUE)
    const ERR_CMSG_LEN: usize = 256;
}

#[cfg(any(target_os = "linux", target_os = "android"))]
impl From<LinuxError> for TransportError {
    fn from(raw: LinuxError) -> Self {
        crate::log::trace!(
            "decoding Linux socket error: ee_origin={} ee_type={} ee_code={} ee_errno={} ee_info={}",
            raw.ee.ee_origin,
            raw.ee.ee_type,
            raw.ee.ee_code,
            raw.ee.ee_errno,
            raw.ee.ee_info,
        );
        let payload = match (raw.ee.ee_origin, raw.ee.ee_type, raw.ee.ee_code) {
            // IPv4: Fragmentation Needed (Type 3, Code 4)
            (libc::SO_EE_ORIGIN_ICMP, 3, 4) => TransportErrorPayload::TooBig {
                mtu: raw.ee.ee_info,
            },
            // IPv6: Packet Too Big (Type 2, Code 0)
            (libc::SO_EE_ORIGIN_ICMP6, 2, 0) => TransportErrorPayload::TooBig {
                mtu: raw.ee.ee_info,
            },
            // Unreachable cases
            (libc::SO_EE_ORIGIN_ICMP, 3, _) | (libc::SO_EE_ORIGIN_ICMP6, 1, _) => {
                TransportErrorPayload::Unreachable
            }
            _ => TransportErrorPayload::Other,
        };

        Self {
            addr: raw.offender,
            payload,
            raw_errno: raw.ee.ee_errno as i32,
        }
    }
}

pub(super) mod gso {
    use super::*;
    use std::{ffi::CStr, mem, str::FromStr, sync::OnceLock};

    // Support for UDP GSO has been added to linux kernel in version 4.18
    // https://github.com/torvalds/linux/commit/cb586c63e3fc5b227c51fd8c4cb40b34d3750645
    const SUPPORTED_SINCE: KernelVersion = KernelVersion {
        version: 4,
        major_revision: 18,
    };

    /// Checks whether GSO support is available
    ///
    /// Checks the kernel version followed by setting the UDP_SEGMENT option on a socket.
    pub(crate) fn max_gso_segments(socket: &impl AsRawFd) -> usize {
        const GSO_SIZE: libc::c_int = 1500;

        if !SUPPORTED_BY_CURRENT_KERNEL.get_or_init(supported_by_current_kernel) {
            return 1;
        }

        // As defined in linux/udp.h
        // #define UDP_MAX_SEGMENTS        (1 << 6UL)
        match set_socket_option(socket, libc::SOL_UDP, libc::UDP_SEGMENT, GSO_SIZE) {
            Ok(()) => {
                // Disable GSO again globally to ensure we can selectively enable it via cmsg.
                // See:
                // - https://github.com/quinn-rs/quinn/issues/2575
                // - https://man7.org/linux/man-pages/man7/udp.7.html
                let _ = set_socket_option(socket, libc::SOL_UDP, libc::UDP_SEGMENT, 0);

                64
            }
            Err(_e) => {
                crate::log::debug!(
                    "failed to set `UDP_SEGMENT` socket option ({_e}); setting `max_gso_segments = 1`"
                );

                1
            }
        }
    }

    pub(crate) fn set_segment_size(
        encoder: &mut cmsg::Encoder<'_, libc::msghdr>,
        segment_size: u16,
    ) {
        encoder.push(libc::SOL_UDP, libc::UDP_SEGMENT, segment_size);
    }

    // Avoid calling `supported_by_current_kernel` for each socket by using `OnceLock`.
    static SUPPORTED_BY_CURRENT_KERNEL: OnceLock<bool> = OnceLock::new();

    fn supported_by_current_kernel() -> bool {
        let kernel_version_string = match kernel_version_string() {
            Ok(kernel_version_string) => kernel_version_string,
            Err(_e) => {
                crate::log::warn!("GSO disabled: uname returned {_e}");
                return false;
            }
        };

        let Some(kernel_version) = KernelVersion::from_str(&kernel_version_string) else {
            crate::log::warn!(
                "GSO disabled: failed to parse kernel version ({kernel_version_string})"
            );
            return false;
        };

        if kernel_version < SUPPORTED_SINCE {
            crate::log::info!("GSO disabled: kernel too old ({kernel_version_string}); need 4.18+",);
            return false;
        }

        true
    }

    fn kernel_version_string() -> io::Result<String> {
        let mut n = unsafe { mem::zeroed() };
        let r = unsafe { libc::uname(&mut n) };
        if r != 0 {
            return Err(io::Error::last_os_error());
        }
        Ok(unsafe {
            CStr::from_ptr(n.release[..].as_ptr())
                .to_string_lossy()
                .into_owned()
        })
    }

    // https://www.linfo.org/kernel_version_numbering.html
    #[derive(Eq, PartialEq, Ord, PartialOrd, Debug)]
    struct KernelVersion {
        version: u8,
        major_revision: u8,
    }

    impl KernelVersion {
        fn from_str(release: &str) -> Option<Self> {
            let mut split = release
                .split_once('-')
                .map(|pair| pair.0)
                .unwrap_or(release)
                .split('.');

            let version = u8::from_str(split.next()?).ok()?;
            let major_revision = u8::from_str(split.next()?).ok()?;

            Some(Self {
                version,
                major_revision,
            })
        }
    }

    #[cfg(test)]
    mod test {
        use super::*;

        #[test]
        fn parse_current_kernel_version_release_string() {
            let release = kernel_version_string().unwrap();
            KernelVersion::from_str(&release).unwrap();
        }

        #[test]
        fn parse_kernel_version_release_string() {
            // These are made up for the test
            assert_eq!(
                KernelVersion::from_str("4.14"),
                Some(KernelVersion {
                    version: 4,
                    major_revision: 14
                })
            );
            assert_eq!(
                KernelVersion::from_str("4.18"),
                Some(KernelVersion {
                    version: 4,
                    major_revision: 18
                })
            );
            // These were seen in the wild
            assert_eq!(
                KernelVersion::from_str("4.14.186-27095505"),
                Some(KernelVersion {
                    version: 4,
                    major_revision: 14
                })
            );
            assert_eq!(
                KernelVersion::from_str("6.8.0-59-generic"),
                Some(KernelVersion {
                    version: 6,
                    major_revision: 8
                })
            );
        }
    }
}

#[cfg(test)]
mod tests {
    use std::net::Ipv4Addr;

    use super::*;

    // Tests LinuxError::decode with a mocked MSG_ERRQUEUE control message.
    //
    // Validates CMSG parsing, SO_EE_OFFENDER handling, and sockaddr decoding.
    #[test]
    fn decode_mock_ip_recverr() {
        let mock_ee = libc::sock_extended_err {
            ee_errno: libc::EMSGSIZE as u32,
            ee_origin: libc::SO_EE_ORIGIN_ICMP,
            ee_type: 3,
            ee_code: 4,
            ee_pad: 0,
            ee_info: 1420,
            ee_data: 0,
        };

        let mock_addr = libc::sockaddr_in {
            sin_family: libc::AF_INET as libc::sa_family_t,
            sin_port: 443u16.to_be(),
            sin_addr: libc::in_addr {
                s_addr: u32::from_ne_bytes([127, 0, 0, 1]),
            },
            sin_zero: [0; 8],
        };

        let payload_len = size_of::<libc::sock_extended_err>() + size_of::<libc::sockaddr_in>();
        let cmsg_len = unsafe { libc::CMSG_LEN(payload_len as _) as usize };
        let mut buffer = vec![0u8; cmsg_len];

        let decoded = unsafe {
            let cmsg = buffer.as_mut_ptr() as *mut libc::cmsghdr;

            (*cmsg).cmsg_len = cmsg_len as _;
            (*cmsg).cmsg_level = libc::IPPROTO_IP;
            (*cmsg).cmsg_type = libc::IP_RECVERR;

            let data = libc::CMSG_DATA(cmsg);
            ptr::write(data as *mut libc::sock_extended_err, mock_ee);

            let offender_ptr = data.add(size_of::<libc::sock_extended_err>());
            ptr::write(offender_ptr as *mut libc::sockaddr_in, mock_addr);

            LinuxError::decode(&*cmsg)
        }
        .expect("decode failed");

        assert_eq!(decoded.ee.ee_errno, libc::EMSGSIZE as u32);
        assert_eq!(decoded.ee.ee_info, 1420);

        let offender = decoded.offender.unwrap();

        assert_eq!(offender.port(), 443);
        assert_eq!(offender.ip(), Ipv4Addr::new(127, 0, 0, 1));

        let transport = TransportError::from(decoded);
        assert!(matches!(
            transport.payload,
            TransportErrorPayload::TooBig { mtu: 1420 }
        ));
    }
}
