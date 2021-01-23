// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

use crate::constants::*;
use crate::err::{secstatus_to_res, Error, Res};
use crate::p11::{
    PK11SymKey, PK11_Encrypt, PK11_GetBlockSize, PK11_GetMechanism, SECItem, SECItemType, SymKey,
    CKM_AES_ECB, CKM_NSS_CHACHA20_CTR, CK_MECHANISM_TYPE,
};

use std::convert::TryFrom;
use std::fmt::{self, Debug};
use std::os::raw::{c_char, c_uint};
use std::ptr::{null, null_mut, NonNull};

experimental_api!(SSL_HkdfExpandLabelWithMech(
    version: Version,
    cipher: Cipher,
    prk: *mut PK11SymKey,
    handshake_hash: *const u8,
    handshake_hash_len: c_uint,
    label: *const c_char,
    label_len: c_uint,
    mech: CK_MECHANISM_TYPE,
    key_size: c_uint,
    secret: *mut *mut PK11SymKey,
));

#[derive(Clone)]
pub struct HpKey(SymKey);

impl Debug for HpKey {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "HP-{:?}", self.0)
    }
}

impl HpKey {
    /// QUIC-specific API for extracting a header-protection key.
    ///
    /// # Errors
    /// Errors if HKDF fails or if the label is too long to fit in a `c_uint`.
    pub fn extract(version: Version, cipher: Cipher, prk: &SymKey, label: &str) -> Res<Self> {
        let l = label.as_bytes();
        let mut secret: *mut PK11SymKey = null_mut();

        let (mech, key_size) = match cipher {
            TLS_AES_128_GCM_SHA256 => (CK_MECHANISM_TYPE::from(CKM_AES_ECB), 16),
            TLS_AES_256_GCM_SHA384 => (CK_MECHANISM_TYPE::from(CKM_AES_ECB), 32),
            TLS_CHACHA20_POLY1305_SHA256 => (CK_MECHANISM_TYPE::from(CKM_NSS_CHACHA20_CTR), 32),
            _ => unreachable!(),
        };

        // Note that this doesn't allow for passing null() for the handshake hash.
        // A zero-length slice produces an identical result.
        unsafe {
            SSL_HkdfExpandLabelWithMech(
                version,
                cipher,
                **prk,
                null(),
                0,
                l.as_ptr() as *const c_char,
                c_uint::try_from(l.len())?,
                mech,
                key_size,
                &mut secret,
            )
        }?;
        match NonNull::new(secret) {
            None => Err(Error::HkdfError),
            Some(p) => Ok(Self(SymKey::new(p))),
        }
    }

    /// Generate a header protection mask for QUIC.
    ///
    /// # Errors
    /// An error is returned if the NSS functions fail; a sample of the
    /// wrong size is the obvious cause.
    #[allow(clippy::cast_sign_loss)]
    pub fn mask(&self, sample: &[u8]) -> Res<Vec<u8>> {
        let k: *mut PK11SymKey = *self.0;
        let mech = unsafe { PK11_GetMechanism(k) };
        // Cast is safe because block size is always greater than or equal to 0
        let block_size = unsafe { PK11_GetBlockSize(mech, null_mut()) } as usize;

        let mut output = vec![0_u8; block_size];
        let output_slice = &mut output[..];
        let mut output_len: c_uint = 0;

        let mut item = SECItem {
            type_: SECItemType::siBuffer,
            data: sample.as_ptr() as *mut u8,
            len: c_uint::try_from(sample.len())?,
        };
        let zero = vec![0_u8; block_size];
        let (iv, inbuf) = match () {
            _ if mech == CK_MECHANISM_TYPE::from(CKM_AES_ECB) => (null_mut(), sample),
            _ if mech == CK_MECHANISM_TYPE::from(CKM_NSS_CHACHA20_CTR) => {
                (&mut item as *mut SECItem, &zero[..])
            }
            _ => unreachable!(),
        };
        secstatus_to_res(unsafe {
            PK11_Encrypt(
                k,
                mech,
                iv,
                output_slice.as_mut_ptr(),
                &mut output_len,
                c_uint::try_from(output.len())?,
                inbuf.as_ptr() as *const u8,
                c_uint::try_from(inbuf.len())?,
            )
        })?;
        assert_eq!(output_len as usize, block_size);
        Ok(output)
    }
}
