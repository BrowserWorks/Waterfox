// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

pub use crate::agentio::{as_c_void, Record, RecordList};
use crate::agentio::{AgentIo, METHODS};
use crate::assert_initialized;
use crate::auth::AuthenticationStatus;
pub use crate::cert::CertificateInfo;
use crate::constants::*;
use crate::err::{is_blocked, secstatus_to_res, Error, PRErrorCode, Res};
use crate::ext::{ExtensionHandler, ExtensionTracker};
use crate::p11;
use crate::prio;
use crate::replay::AntiReplay;
use crate::secrets::SecretHolder;
use crate::ssl::{self, PRBool};
use crate::time::TimeHolder;

use neqo_common::{matches, qdebug, qinfo, qtrace, qwarn};
use std::cell::RefCell;
use std::convert::TryFrom;
use std::ffi::CString;
use std::mem::{self, MaybeUninit};
use std::ops::{Deref, DerefMut};
use std::os::raw::{c_uint, c_void};
use std::pin::Pin;
use std::ptr::{null, null_mut, NonNull};
use std::rc::Rc;
use std::time::Instant;

#[derive(Clone, Debug, PartialEq)]
pub enum HandshakeState {
    New,
    InProgress,
    AuthenticationPending,
    Authenticated(PRErrorCode),
    Complete(SecretAgentInfo),
    Failed(Error),
}

impl HandshakeState {
    #[must_use]
    pub fn is_connected(&self) -> bool {
        matches!(self, Self::Complete(_))
    }

    #[must_use]
    pub fn is_final(&self) -> bool {
        matches!(self, Self::Complete(_) | Self::Failed(_))
    }
}

fn get_alpn(fd: *mut ssl::PRFileDesc, pre: bool) -> Res<Option<String>> {
    let mut alpn_state = ssl::SSLNextProtoState::SSL_NEXT_PROTO_NO_SUPPORT;
    let mut chosen = vec![0_u8; 255];
    let mut chosen_len: c_uint = 0;
    secstatus_to_res(unsafe {
        ssl::SSL_GetNextProto(
            fd,
            &mut alpn_state,
            chosen.as_mut_ptr(),
            &mut chosen_len,
            c_uint::try_from(chosen.len())?,
        )
    })?;

    let alpn = match (pre, alpn_state) {
        (true, ssl::SSLNextProtoState::SSL_NEXT_PROTO_EARLY_VALUE)
        | (false, ssl::SSLNextProtoState::SSL_NEXT_PROTO_NEGOTIATED)
        | (false, ssl::SSLNextProtoState::SSL_NEXT_PROTO_SELECTED) => {
            chosen.truncate(chosen_len as usize);
            Some(match String::from_utf8(chosen) {
                Ok(a) => a,
                _ => return Err(Error::InternalError),
            })
        }
        _ => None,
    };
    qtrace!([format!("{:p}", fd)], "got ALPN {:?}", alpn);
    Ok(alpn)
}

pub struct SecretAgentPreInfo {
    info: ssl::SSLPreliminaryChannelInfo,
    alpn: Option<String>,
}

macro_rules! preinfo_arg {
    ($v:ident, $m:ident, $f:ident: $t:ident $(,)?) => {
        #[must_use]
        pub fn $v(&self) -> Option<$t> {
            match self.info.valuesSet & ssl::$m {
                0 => None,
                _ => Some(self.info.$f as $t)
            }
        }
    };
}

impl SecretAgentPreInfo {
    fn new(fd: *mut ssl::PRFileDesc) -> Res<Self> {
        let mut info: MaybeUninit<ssl::SSLPreliminaryChannelInfo> = MaybeUninit::uninit();
        secstatus_to_res(unsafe {
            ssl::SSL_GetPreliminaryChannelInfo(
                fd,
                info.as_mut_ptr(),
                c_uint::try_from(mem::size_of::<ssl::SSLPreliminaryChannelInfo>())?,
            )
        })?;

        Ok(Self {
            info: unsafe { info.assume_init() },
            alpn: get_alpn(fd, true)?,
        })
    }

    preinfo_arg!(version, ssl_preinfo_version, protocolVersion: Version);
    preinfo_arg!(cipher_suite, ssl_preinfo_cipher_suite, cipherSuite: Cipher);
    #[must_use]
    pub fn early_data(&self) -> bool {
        self.info.canSendEarlyData != 0
    }
    #[must_use]
    pub fn max_early_data(&self) -> usize {
        usize::try_from(self.info.maxEarlyDataSize).unwrap()
    }
    #[must_use]
    pub fn alpn(&self) -> Option<&String> {
        self.alpn.as_ref()
    }

    preinfo_arg!(
        early_data_cipher,
        ssl_preinfo_0rtt_cipher_suite,
        zeroRttCipherSuite: Cipher,
    );
}

#[derive(Clone, Debug, Default, PartialEq)]
pub struct SecretAgentInfo {
    version: Version,
    cipher: Cipher,
    group: Group,
    resumed: bool,
    early_data: bool,
    alpn: Option<String>,
    signature_scheme: SignatureScheme,
}

impl SecretAgentInfo {
    fn new(fd: *mut ssl::PRFileDesc) -> Res<Self> {
        let mut info: MaybeUninit<ssl::SSLChannelInfo> = MaybeUninit::uninit();
        secstatus_to_res(unsafe {
            ssl::SSL_GetChannelInfo(
                fd,
                info.as_mut_ptr(),
                c_uint::try_from(mem::size_of::<ssl::SSLChannelInfo>())?,
            )
        })?;
        let info = unsafe { info.assume_init() };
        Ok(Self {
            version: info.protocolVersion as Version,
            cipher: info.cipherSuite as Cipher,
            group: Group::try_from(info.keaGroup)?,
            resumed: info.resumed != 0,
            early_data: info.earlyDataAccepted != 0,
            alpn: get_alpn(fd, false)?,
            signature_scheme: SignatureScheme::try_from(info.signatureScheme)?,
        })
    }
    #[must_use]
    pub fn version(&self) -> Version {
        self.version
    }
    #[must_use]
    pub fn cipher_suite(&self) -> Cipher {
        self.cipher
    }
    #[must_use]
    pub fn key_exchange(&self) -> Group {
        self.group
    }
    #[must_use]
    pub fn resumed(&self) -> bool {
        self.resumed
    }
    #[must_use]
    pub fn early_data_accepted(&self) -> bool {
        self.early_data
    }
    #[must_use]
    pub fn alpn(&self) -> Option<&String> {
        self.alpn.as_ref()
    }
    #[must_use]
    pub fn signature_scheme(&self) -> SignatureScheme {
        self.signature_scheme
    }
}

/// `SecretAgent` holds the common parts of client and server.
#[derive(Debug)]
#[allow(clippy::module_name_repetitions)]
pub struct SecretAgent {
    fd: *mut ssl::PRFileDesc,
    secrets: SecretHolder,
    raw: Option<bool>,
    io: Pin<Box<AgentIo>>,
    state: HandshakeState,

    /// Records whether authentication of certificates is required.
    auth_required: Pin<Box<bool>>,
    /// Records any fatal alert that is sent by the stack.
    alert: Pin<Box<Option<Alert>>>,
    /// The current time.
    now: TimeHolder,

    extension_handlers: Vec<ExtensionTracker>,
    inf: Option<SecretAgentInfo>,

    /// Whether or not EndOfEarlyData should be suppressed.
    no_eoed: bool,
}

impl SecretAgent {
    fn new() -> Res<Self> {
        let mut io = Box::pin(AgentIo::new());
        let fd = Self::create_fd(&mut io)?;
        Ok(Self {
            fd,
            secrets: SecretHolder::default(),
            raw: None,
            io,
            state: HandshakeState::New,

            auth_required: Box::pin(false),
            alert: Box::pin(None),
            now: TimeHolder::default(),

            extension_handlers: Vec::new(),
            inf: None,

            no_eoed: false,
        })
    }

    // Create a new SSL file descriptor.
    //
    // Note that we create separate bindings for PRFileDesc as both
    // ssl::PRFileDesc and prio::PRFileDesc.  This keeps the bindings
    // minimal, but it means that the two forms need casts to translate
    // between them.  ssl::PRFileDesc is left as an opaque type, as the
    // ssl::SSL_* APIs only need an opaque type.
    fn create_fd(io: &mut Pin<Box<AgentIo>>) -> Res<*mut ssl::PRFileDesc> {
        assert_initialized();
        let label = CString::new("sslwrapper")?;
        let id = unsafe { prio::PR_GetUniqueIdentity(label.as_ptr()) };

        let base_fd = unsafe { prio::PR_CreateIOLayerStub(id, METHODS) };
        if base_fd.is_null() {
            return Err(Error::CreateSslSocket);
        }
        let fd = unsafe {
            (*base_fd).secret = as_c_void(io) as *mut _;
            ssl::SSL_ImportFD(null_mut(), base_fd as *mut ssl::PRFileDesc)
        };
        if fd.is_null() {
            unsafe { prio::PR_Close(base_fd) };
            return Err(Error::CreateSslSocket);
        }
        Ok(fd)
    }

    unsafe extern "C" fn auth_complete_hook(
        arg: *mut c_void,
        _fd: *mut ssl::PRFileDesc,
        _check_sig: ssl::PRBool,
        _is_server: ssl::PRBool,
    ) -> ssl::SECStatus {
        let auth_required_ptr = arg as *mut bool;
        *auth_required_ptr = true;
        // NSS insists on getting SECWouldBlock here rather than accepting
        // the usual combination of PR_WOULD_BLOCK_ERROR and SECFailure.
        ssl::_SECStatus_SECWouldBlock
    }

    unsafe extern "C" fn alert_sent_cb(
        fd: *const ssl::PRFileDesc,
        arg: *mut c_void,
        alert: *const ssl::SSLAlert,
    ) {
        let alert = alert.as_ref().unwrap();
        if alert.level == 2 {
            // Fatal alerts demand attention.
            let p = arg as *mut Option<Alert>;
            let st = p.as_mut().unwrap();
            if st.is_none() {
                *st = Some(alert.description);
            } else {
                qwarn!(
                    [format!("{:p}", fd)],
                    "duplicate alert {}",
                    alert.description
                );
            }
        }
    }

    // Ready this for connecting.
    fn ready(&mut self, is_server: bool) -> Res<()> {
        secstatus_to_res(unsafe {
            ssl::SSL_AuthCertificateHook(
                self.fd,
                Some(Self::auth_complete_hook),
                as_c_void(&mut self.auth_required),
            )
        })?;

        secstatus_to_res(unsafe {
            ssl::SSL_AlertSentCallback(
                self.fd,
                Some(Self::alert_sent_cb),
                as_c_void(&mut self.alert),
            )
        })?;

        self.now.bind(self.fd)?;
        self.configure()?;
        secstatus_to_res(unsafe { ssl::SSL_ResetHandshake(self.fd, is_server as ssl::PRBool) })
    }

    /// Default configuration.
    ///
    /// # Errors
    /// If `set_version_range` fails.
    fn configure(&mut self) -> Res<()> {
        self.set_version_range(TLS_VERSION_1_3, TLS_VERSION_1_3)?;
        self.set_option(ssl::Opt::Locking, false)?;
        self.set_option(ssl::Opt::Tickets, false)?;
        self.set_option(ssl::Opt::OcspStapling, true)?;
        Ok(())
    }

    /// Set the versions that are supported.
    ///
    /// # Errors
    /// If the range of versions isn't supported.
    pub fn set_version_range(&mut self, min: Version, max: Version) -> Res<()> {
        let range = ssl::SSLVersionRange {
            min: min as ssl::PRUint16,
            max: max as ssl::PRUint16,
        };
        secstatus_to_res(unsafe { ssl::SSL_VersionRangeSet(self.fd, &range) })
    }

    /// Enable a set of ciphers.  Note that the order of these is not respected.
    ///
    /// # Errors
    /// If NSS can't enable or disable ciphers.
    pub fn enable_ciphers(&mut self, ciphers: &[Cipher]) -> Res<()> {
        let all_ciphers = unsafe { ssl::SSL_GetImplementedCiphers() };
        let cipher_count = unsafe { ssl::SSL_GetNumImplementedCiphers() } as usize;
        for i in 0..cipher_count {
            let p = all_ciphers.wrapping_add(i);
            secstatus_to_res(unsafe {
                ssl::SSL_CipherPrefSet(self.fd, i32::from(*p), false as ssl::PRBool)
            })?;
        }

        for c in ciphers {
            secstatus_to_res(unsafe {
                ssl::SSL_CipherPrefSet(self.fd, i32::from(*c), true as ssl::PRBool)
            })?;
        }
        Ok(())
    }

    /// Set key exchange groups.
    ///
    /// # Errors
    /// If the underlying API fails (which shouldn't happen).
    pub fn set_groups(&mut self, groups: &[Group]) -> Res<()> {
        // SSLNamedGroup is a different size to Group, so copy one by one.
        let group_vec: Vec<_> = groups
            .iter()
            .map(|&g| ssl::SSLNamedGroup::Type::from(g))
            .collect();

        let ptr = group_vec.as_slice().as_ptr();
        secstatus_to_res(unsafe {
            ssl::SSL_NamedGroupConfig(self.fd, ptr, c_uint::try_from(group_vec.len())?)
        })
    }

    /// Set TLS options.
    ///
    /// # Errors
    /// Returns an error if the option or option value is invalid; i.e., never.
    pub fn set_option(&mut self, opt: ssl::Opt, value: bool) -> Res<()> {
        secstatus_to_res(unsafe {
            ssl::SSL_OptionSet(self.fd, opt.as_int(), opt.map_enabled(value))
        })
    }

    /// Enable 0-RTT.
    ///
    /// # Errors
    /// See `set_option`.
    pub fn enable_0rtt(&mut self) -> Res<()> {
        self.set_option(ssl::Opt::EarlyData, true)
    }

    /// Disable the `EndOfEarlyData` message.
    pub fn disable_end_of_early_data(&mut self) {
        self.no_eoed = true;
    }

    /// `set_alpn` sets a list of preferred protocols, starting with the most preferred.
    /// Though ALPN [RFC7301] permits octet sequences, this only allows for UTF-8-encoded
    /// strings.
    ///
    /// This asserts if no items are provided, or if any individual item is longer than
    /// 255 octets in length.
    ///
    /// # Errors
    /// This should always panic rather than return an error.
    pub fn set_alpn(&mut self, protocols: &[impl AsRef<str>]) -> Res<()> {
        // Validate and set length.
        let mut encoded_len = protocols.len();
        for v in protocols {
            assert!(v.as_ref().len() < 256);
            encoded_len += v.as_ref().len();
        }

        // Prepare to encode.
        let mut encoded = Vec::with_capacity(encoded_len);
        let mut add = |v: &str| {
            if let Ok(s) = u8::try_from(v.len()) {
                encoded.push(s);
                encoded.extend_from_slice(v.as_bytes());
            }
        };

        // NSS inherited an idiosyncratic API as a result of having implemented NPN
        // before ALPN.  For that reason, we need to put the "best" option last.
        let (first, rest) = protocols
            .split_first()
            .expect("at least one ALPN value needed");
        for v in rest {
            add(v.as_ref());
        }
        add(first.as_ref());
        assert_eq!(encoded_len, encoded.len());

        // Now give the result to NSS.
        secstatus_to_res(unsafe {
            ssl::SSL_SetNextProtoNego(
                self.fd,
                encoded.as_slice().as_ptr(),
                c_uint::try_from(encoded.len())?,
            )
        })
    }

    /// Install an extension handler.
    ///
    /// This can be called multiple times with different values for `ext`.  The handler is provided as
    /// Rc<RefCell<>> so that the caller is able to hold a reference to the handler and later access any
    /// state that it accumulates.
    ///
    /// # Errors
    /// When the extension handler can't be successfully installed.
    pub fn extension_handler(
        &mut self,
        ext: Extension,
        handler: Rc<RefCell<dyn ExtensionHandler>>,
    ) -> Res<()> {
        let tracker = unsafe { ExtensionTracker::new(self.fd, ext, handler) }?;
        self.extension_handlers.push(tracker);
        Ok(())
    }

    // This function tracks whether handshake() or handshake_raw() was used
    // and prevents the other from being used.
    fn set_raw(&mut self, r: bool) -> Res<()> {
        if self.raw.is_none() {
            self.secrets.register(self.fd)?;
            self.raw = Some(r);
            Ok(())
        } else if self.raw.unwrap() == r {
            Ok(())
        } else {
            Err(Error::MixedHandshakeMethod)
        }
    }

    /// Get information about the connection.
    /// This includes the version, ciphersuite, and ALPN.
    ///
    /// Calling this function returns None until the connection is complete.
    #[must_use]
    pub fn info(&self) -> Option<&SecretAgentInfo> {
        match self.state {
            HandshakeState::Complete(ref info) => Some(info),
            _ => None,
        }
    }

    /// Get any preliminary information about the status of the connection.
    ///
    /// This includes whether 0-RTT was accepted and any information related to that.
    /// Calling this function collects all the relevant information.
    ///
    /// # Errors
    /// When the underlying socket functions fail.
    pub fn preinfo(&self) -> Res<SecretAgentPreInfo> {
        SecretAgentPreInfo::new(self.fd)
    }

    /// Get the peer's certificate chain.
    #[must_use]
    pub fn peer_certificate(&self) -> Option<CertificateInfo> {
        CertificateInfo::new(self.fd)
    }

    /// Return any fatal alert that the TLS stack might have sent.
    #[must_use]
    pub fn alert(&self) -> Option<&Alert> {
        (&*self.alert).as_ref()
    }

    /// Call this function to mark the peer as authenticated.
    /// Only call this function if `handshake/handshake_raw` returns
    /// `HandshakeState::AuthenticationPending`, or it will panic.
    pub fn authenticated(&mut self, status: AuthenticationStatus) {
        assert_eq!(self.state, HandshakeState::AuthenticationPending);
        *self.auth_required = false;
        self.state = HandshakeState::Authenticated(status.into());
    }

    fn capture_error<T>(&mut self, res: Res<T>) -> Res<T> {
        if let Err(e) = &res {
            qwarn!([self], "error: {:?}", e);
            self.state = HandshakeState::Failed(e.clone());
        }
        res
    }

    fn update_state(&mut self, res: Res<()>) -> Res<()> {
        self.state = if is_blocked(&res) {
            if *self.auth_required {
                HandshakeState::AuthenticationPending
            } else {
                HandshakeState::InProgress
            }
        } else {
            self.capture_error(res)?;
            let info = self.capture_error(SecretAgentInfo::new(self.fd))?;
            HandshakeState::Complete(info)
        };
        qinfo!([self], "state -> {:?}", self.state);
        Ok(())
    }

    /// Drive the TLS handshake, taking bytes from `input` and putting
    /// any bytes necessary into `output`.
    /// This takes the current time as `now`.
    /// On success a tuple of a `HandshakeState` and usize indicate whether the handshake
    /// is complete and how many bytes were written to `output`, respectively.
    /// If the state is `HandshakeState::AuthenticationPending`, then ONLY call this
    /// function if you want to proceed, because this will mark the certificate as OK.
    ///
    /// # Errors
    /// When the handshake fails this returns an error.
    pub fn handshake(&mut self, now: Instant, input: &[u8]) -> Res<Vec<u8>> {
        self.now.set(now)?;
        self.set_raw(false)?;

        let rv = {
            // Within this scope, _h maintains a mutable reference to self.io.
            let _h = self.io.wrap(input);
            match self.state {
                HandshakeState::Authenticated(ref err) => unsafe {
                    ssl::SSL_AuthCertificateComplete(self.fd, *err)
                },
                _ => unsafe { ssl::SSL_ForceHandshake(self.fd) },
            }
        };
        // Take before updating state so that we leave the output buffer empty
        // even if there is an error.
        let output = self.io.take_output();
        self.update_state(secstatus_to_res(rv))?;
        Ok(output)
    }

    /// Setup to receive records for raw handshake functions.
    fn setup_raw(&mut self) -> Res<Pin<Box<RecordList>>> {
        self.set_raw(true)?;
        self.capture_error(RecordList::setup(self.fd))
    }

    fn inject_eoed(&mut self) -> Res<()> {
        // EndOfEarlyData is as follows:
        // struct {
        //    HandshakeType msg_type = end_of_early_data(5);
        //    uint24 length = 0;
        // };
        const END_OF_EARLY_DATA: &[u8] = &[5, 0, 0, 0];

        if self.no_eoed {
            let mut read_epoch: u16 = 0;
            unsafe { ssl::SSL_GetCurrentEpoch(self.fd, &mut read_epoch, null_mut()) }?;
            if read_epoch == 1 {
                // It's waiting for EndOfEarlyData, so feed one in.
                // Note that this is the test that ensures that we only do this for the server.
                let eoed = Record::new(1, 22, END_OF_EARLY_DATA);
                self.capture_error(eoed.write(self.fd))?;
                self.no_eoed = false;
            }
        }
        Ok(())
    }

    /// Drive the TLS handshake, but get the raw content of records, not
    /// protected records as bytes. This function is incompatible with
    /// `handshake()`; use either this or `handshake()` exclusively.
    ///
    /// Ideally, this only includes records from the current epoch.
    /// If you send data from multiple epochs, you might end up being sad.
    ///
    /// # Errors
    /// When the handshake fails this returns an error.
    pub fn handshake_raw(&mut self, now: Instant, input: Option<Record>) -> Res<RecordList> {
        self.now.set(now)?;
        let mut records = self.setup_raw()?;

        // Fire off any authentication we might need to complete.
        if let HandshakeState::Authenticated(ref err) = self.state {
            let result =
                secstatus_to_res(unsafe { ssl::SSL_AuthCertificateComplete(self.fd, *err) });
            qdebug!([self], "SSL_AuthCertificateComplete: {:?}", result);
            // This should return SECSuccess, so don't use update_state().
            self.capture_error(result)?;
        }

        // Feed in any records.
        if let Some(rec) = input {
            if rec.epoch == 2 {
                self.inject_eoed()?;
            }
            self.capture_error(rec.write(self.fd))?;
        }

        // Drive the handshake once more.
        let rv = secstatus_to_res(unsafe { ssl::SSL_ForceHandshake(self.fd) });
        self.update_state(rv)?;

        if self.no_eoed {
            records.remove_eoed();
        }

        Ok(*Pin::into_inner(records))
    }

    pub fn close(&mut self) {
        // It should be safe to close multiple times.
        if self.fd.is_null() {
            return;
        }
        if let Some(true) = self.raw {
            // Need to hold the record list in scope until the close is done.
            let _records = self.setup_raw().expect("Can only close");
            unsafe { prio::PR_Close(self.fd as *mut prio::PRFileDesc) };
        } else {
            // Need to hold the IO wrapper in scope until the close is done.
            let _io = self.io.wrap(&[]);
            unsafe { prio::PR_Close(self.fd as *mut prio::PRFileDesc) };
        };
        let _output = self.io.take_output();
        self.fd = null_mut();
    }

    /// State returns the status of the handshake.
    #[must_use]
    pub fn state(&self) -> &HandshakeState {
        &self.state
    }
    /// Take a read secret.  This will only return a non-`None` value once.
    #[must_use]
    pub fn read_secret(&mut self, epoch: Epoch) -> Option<p11::SymKey> {
        self.secrets.take_read(epoch)
    }
    /// Take a write secret.
    #[must_use]
    pub fn write_secret(&mut self, epoch: Epoch) -> Option<p11::SymKey> {
        self.secrets.take_write(epoch)
    }
}

impl Drop for SecretAgent {
    fn drop(&mut self) {
        self.close();
    }
}

impl ::std::fmt::Display for SecretAgent {
    fn fmt(&self, f: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        write!(f, "Agent {:p}", self.fd)
    }
}

/// A TLS Client.
#[derive(Debug)]
pub struct Client {
    agent: SecretAgent,

    /// Records the last resumption token.
    resumption: Pin<Box<Option<Vec<u8>>>>,
}

impl Client {
    /// Create a new client agent.
    ///
    /// # Errors
    /// Errors returned if the socket can't be created or configured.
    pub fn new(server_name: &str) -> Res<Self> {
        let mut agent = SecretAgent::new()?;
        let url = CString::new(server_name)?;
        secstatus_to_res(unsafe { ssl::SSL_SetURL(agent.fd, url.as_ptr()) })?;
        agent.ready(false)?;
        let mut client = Self {
            agent,
            resumption: Box::pin(None),
        };
        client.ready()?;
        Ok(client)
    }

    unsafe extern "C" fn resumption_token_cb(
        fd: *mut ssl::PRFileDesc,
        token: *const u8,
        len: c_uint,
        arg: *mut c_void,
    ) -> ssl::SECStatus {
        let resumption_ptr = arg as *mut Option<Vec<u8>>;
        let resumption = resumption_ptr.as_mut().unwrap();
        let mut v = Vec::with_capacity(len as usize);
        v.extend_from_slice(std::slice::from_raw_parts(token, len as usize));
        qdebug!([format!("{:p}", fd)], "Got resumption token");
        *resumption = Some(v);
        ssl::SECSuccess
    }

    fn ready(&mut self) -> Res<()> {
        let fd = self.fd;
        unsafe {
            ssl::SSL_SetResumptionTokenCallback(
                fd,
                Some(Self::resumption_token_cb),
                as_c_void(&mut self.resumption),
            )
        }
    }

    /// Return the resumption token.
    #[must_use]
    pub fn resumption_token(&self) -> Option<&Vec<u8>> {
        (*self.resumption).as_ref()
    }

    /// Enable resumption, using a token previously provided.
    ///
    /// # Errors
    /// Error returned when the resumption token is invalid or
    /// the socket is not able to use the value.
    pub fn set_resumption_token(&mut self, token: &[u8]) -> Res<()> {
        unsafe {
            ssl::SSL_SetResumptionToken(
                self.agent.fd,
                token.as_ptr(),
                c_uint::try_from(token.len())?,
            )
        }
    }
}

impl Deref for Client {
    type Target = SecretAgent;
    #[must_use]
    fn deref(&self) -> &SecretAgent {
        &self.agent
    }
}

impl DerefMut for Client {
    fn deref_mut(&mut self) -> &mut SecretAgent {
        &mut self.agent
    }
}

/// `ZeroRttCheckResult` encapsulates the options for handling a `ClientHello`.
#[derive(Clone, Debug, PartialEq)]
pub enum ZeroRttCheckResult {
    /// Accept 0-RTT; the default.
    Accept,
    /// Reject 0-RTT, but continue the handshake normally.
    Reject,
    /// Send HelloRetryRequest (probably not needed for QUIC).
    HelloRetryRequest(Vec<u8>),
    /// Fail the handshake.
    Fail,
}

/// A `ZeroRttChecker` is used by the agent to validate the application token (as provided by `send_ticket`)
pub trait ZeroRttChecker: std::fmt::Debug + std::marker::Unpin {
    fn check(&self, token: &[u8]) -> ZeroRttCheckResult;
}

#[derive(Debug)]
struct ZeroRttCheckState {
    fd: *mut ssl::PRFileDesc,
    checker: Pin<Box<dyn ZeroRttChecker>>,
}

impl ZeroRttCheckState {
    pub fn new(fd: *mut ssl::PRFileDesc, checker: Box<dyn ZeroRttChecker>) -> Self {
        Self {
            fd,
            checker: Pin::new(checker),
        }
    }
}

#[derive(Debug)]
pub struct Server {
    agent: SecretAgent,
    /// This holds the HRR callback context.
    zero_rtt_check: Option<Pin<Box<ZeroRttCheckState>>>,
}

impl Server {
    /// Create a new server agent.
    ///
    /// # Errors
    /// Errors returned when NSS fails.
    pub fn new(certificates: &[impl AsRef<str>]) -> Res<Self> {
        let mut agent = SecretAgent::new()?;

        for n in certificates {
            let c = CString::new(n.as_ref())?;
            let cert = match NonNull::new(unsafe {
                p11::PK11_FindCertFromNickname(c.as_ptr(), null_mut())
            }) {
                None => return Err(Error::CertificateLoading),
                Some(ptr) => p11::Certificate::new(ptr),
            };
            let key = match NonNull::new(unsafe {
                p11::PK11_FindKeyByAnyCert(*cert.deref(), null_mut())
            }) {
                None => return Err(Error::CertificateLoading),
                Some(ptr) => p11::PrivateKey::new(ptr),
            };
            secstatus_to_res(unsafe {
                ssl::SSL_ConfigServerCert(agent.fd, *cert.deref(), *key.deref(), null(), 0)
            })?;
        }

        agent.ready(true)?;
        Ok(Self {
            agent,
            zero_rtt_check: None,
        })
    }

    unsafe extern "C" fn hello_retry_cb(
        first_hello: PRBool,
        client_token: *const u8,
        client_token_len: c_uint,
        retry_token: *mut u8,
        retry_token_len: *mut c_uint,
        retry_token_max: c_uint,
        arg: *mut c_void,
    ) -> ssl::SSLHelloRetryRequestAction::Type {
        if first_hello == 0 {
            // On the second ClientHello after HelloRetryRequest, skip checks.
            return ssl::SSLHelloRetryRequestAction::ssl_hello_retry_accept;
        }

        let p = arg as *mut ZeroRttCheckState;
        let check_state = p.as_mut().unwrap();
        let token = if client_token.is_null() {
            &[]
        } else {
            std::slice::from_raw_parts(client_token, client_token_len as usize)
        };
        match check_state.checker.check(token) {
            ZeroRttCheckResult::Accept => ssl::SSLHelloRetryRequestAction::ssl_hello_retry_accept,
            ZeroRttCheckResult::Fail => ssl::SSLHelloRetryRequestAction::ssl_hello_retry_fail,
            ZeroRttCheckResult::Reject => {
                ssl::SSLHelloRetryRequestAction::ssl_hello_retry_reject_0rtt
            }
            ZeroRttCheckResult::HelloRetryRequest(tok) => {
                // Don't bother propagating errors from this, because it should be caught in testing.
                assert!(tok.len() <= usize::try_from(retry_token_max).unwrap());
                let slc = std::slice::from_raw_parts_mut(retry_token, tok.len());
                slc.copy_from_slice(&tok);
                *retry_token_len = c_uint::try_from(tok.len()).expect("token was way too big");
                ssl::SSLHelloRetryRequestAction::ssl_hello_retry_request
            }
        }
    }

    /// Enable 0-RTT.  This shadows the function of the same name that can be accessed
    /// via the Deref implementation on Server.
    ///
    /// # Errors
    /// Returns an error if the underlying NSS functions fail.
    pub fn enable_0rtt(
        &mut self,
        anti_replay: &AntiReplay,
        max_early_data: u32,
        checker: Box<dyn ZeroRttChecker>,
    ) -> Res<()> {
        let mut check_state = Box::pin(ZeroRttCheckState::new(self.agent.fd, checker));
        unsafe {
            ssl::SSL_HelloRetryRequestCallback(
                self.agent.fd,
                Some(Self::hello_retry_cb),
                as_c_void(&mut check_state),
            )
        }?;
        unsafe { ssl::SSL_SetMaxEarlyDataSize(self.agent.fd, max_early_data) }?;
        self.zero_rtt_check = Some(check_state);
        self.agent.enable_0rtt()?;
        anti_replay.config_socket(self.fd)?;
        Ok(())
    }

    /// Send a session ticket to the client.
    /// This adds |extra| application-specific content into that ticket.
    /// The records that are sent are captured and returned.
    ///
    /// # Errors
    /// If NSS is unable to send a ticket, or if this agent is incorrectly configured.
    pub fn send_ticket(&mut self, now: Instant, extra: &[u8]) -> Res<RecordList> {
        self.agent.now.set(now)?;
        let records = self.setup_raw()?;

        unsafe {
            ssl::SSL_SendSessionTicket(self.fd, extra.as_ptr(), c_uint::try_from(extra.len())?)
        }?;

        Ok(*Pin::into_inner(records))
    }
}

impl Deref for Server {
    type Target = SecretAgent;
    #[must_use]
    fn deref(&self) -> &SecretAgent {
        &self.agent
    }
}

impl DerefMut for Server {
    fn deref_mut(&mut self) -> &mut SecretAgent {
        &mut self.agent
    }
}

/// A generic container for Client or Server.
#[derive(Debug)]
pub enum Agent {
    Client(crate::agent::Client),
    Server(crate::agent::Server),
}

impl Deref for Agent {
    type Target = SecretAgent;
    #[must_use]
    fn deref(&self) -> &SecretAgent {
        match self {
            Self::Client(c) => &*c,
            Self::Server(s) => &*s,
        }
    }
}

impl DerefMut for Agent {
    fn deref_mut(&mut self) -> &mut SecretAgent {
        match self {
            Self::Client(c) => c.deref_mut(),
            Self::Server(s) => s.deref_mut(),
        }
    }
}

impl From<Client> for Agent {
    #[must_use]
    fn from(c: Client) -> Self {
        Self::Client(c)
    }
}

impl From<Server> for Agent {
    #[must_use]
    fn from(s: Server) -> Self {
        Self::Server(s)
    }
}
