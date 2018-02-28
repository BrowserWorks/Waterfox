# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
{
  'includes': [
    '../../coreconf/config.gypi',
    '../common/gtest.gypi',
  ],
  'targets': [
    {
      'target_name': 'pk11_gtest',
      'type': 'executable',
      'sources': [
        'pk11_aeskeywrap_unittest.cc',
        'pk11_aes_gcm_unittest.cc',
        'pk11_chacha20poly1305_unittest.cc',
        'pk11_curve25519_unittest.cc',
        'pk11_ecdsa_unittest.cc',
        'pk11_pbkdf2_unittest.cc',
        'pk11_prf_unittest.cc',
        'pk11_prng_unittest.cc',
        'pk11_rsapss_unittest.cc',
        'pk11_der_private_key_import_unittest.cc',
        '<(DEPTH)/gtests/common/gtests.cc'
      ],
      'dependencies': [
        '<(DEPTH)/exports.gyp:nss_exports',
        '<(DEPTH)/lib/util/util.gyp:nssutil3',
        '<(DEPTH)/gtests/google_test/google_test.gyp:gtest',
      ],
      'conditions': [
        [ 'test_build==1', {
          'dependencies': [
            '<(DEPTH)/lib/nss/nss.gyp:nss_static',
            '<(DEPTH)/lib/pk11wrap/pk11wrap.gyp:pk11wrap_static',
            '<(DEPTH)/lib/cryptohi/cryptohi.gyp:cryptohi',
            '<(DEPTH)/lib/certhigh/certhigh.gyp:certhi',
            '<(DEPTH)/lib/certdb/certdb.gyp:certdb',
            '<(DEPTH)/lib/base/base.gyp:nssb',
            '<(DEPTH)/lib/dev/dev.gyp:nssdev',
            '<(DEPTH)/lib/pki/pki.gyp:nsspki',
            '<(DEPTH)/lib/ssl/ssl.gyp:ssl',
          ],
        }, {
          'dependencies': [
            '<(DEPTH)/lib/nss/nss.gyp:nss3',
            '<(DEPTH)/lib/ssl/ssl.gyp:ssl3',
          ],
        }],
      ],
    }
  ],
  'variables': {
    'module': 'nss'
  }
}
