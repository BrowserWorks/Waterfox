# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S
#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] 메시지 보안 표시 (⌘ ⌥ { message-header-show-security-info-key })
           *[other] 메시지 보안 표시 (Ctrl+Alt+{ message-header-show-security-info-key })
        }
openpgp-view-signer-key =
    .label = 서명자 키보기
openpgp-view-your-encryption-key =
    .label = 복호화 키보기
openpgp-openpgp = OpenPGP
openpgp-no-sig = 디지털 서명 없음
openpgp-uncertain-sig = 불확실한 디지털 서명
openpgp-invalid-sig = 잘못된 디지털 서명
openpgp-good-sig = 올바른 디지털 서명
openpgp-sig-uncertain-no-key = 이 메시지에는 디지털 서명이 포함되어 있지만 정확한지 확실하지 않습니다. 서명을 확인하려면 보낸 사람의 공개 키 사본을 얻어야합니다.
openpgp-sig-uncertain-uid-mismatch = 이 메시지에는 디지털 서명이 포함되어 있지만 불일치가 감지되었습니다. 서명자의 공개 키와 일치하지 않는 이메일 주소에서 메시지를 보냈습니다.
openpgp-sig-uncertain-not-accepted = 이 메시지에는 디지털 서명이 포함되어 있지만 서명자의 키가 허용되는지 아직 결정하지 않았습니다.
openpgp-sig-invalid-rejected = 이 메시지에는 디지털 서명이 포함되어 있지만 이전에 서명자 키를 거부하기로 결정했습니다.
openpgp-sig-invalid-technical-problem = 이 메시지에는 디지털 서명이 포함되어 있지만 기술 오류가 발견되었습니다. 메시지가 손상되었거나 다른 사람이 메시지를 수정했습니다.
openpgp-sig-valid-unverified = 이 메시지에는 이미 수락 한 키의 유효한 디지털 서명이 포함되어 있습니다. 그러나 키가 실제로 보낸 사람이 소유하고 있는지 아직 확인하지 않았습니다.
openpgp-sig-valid-verified = 이 메시지에는 확인 된 키의 유효한 디지털 서명이 포함되어 있습니다.
openpgp-sig-valid-own-key = 이 메시지에는 개인 키의 유효한 디지털 서명이 포함되어 있습니다.
openpgp-sig-key-id = 서명자 키 ID : { $key }
openpgp-sig-key-id-with-subkey-id = 서명자 키 ID : { $key } (하위 키 ID : { $subkey })
openpgp-enc-key-id = 복호화 키 ID: { $key }
openpgp-enc-key-with-subkey-id = 복호화 키 ID: { $key } (하위 키 ID: { $subkey })
openpgp-unknown-key-id = 알 수없는 키
openpgp-other-enc-additional-key-ids = 또한 메시지는 다음 키의 소유자로 암호화되었습니다:
openpgp-other-enc-all-key-ids = 메시지는 다음 키의 소유자에게 암호화되었습니다:
