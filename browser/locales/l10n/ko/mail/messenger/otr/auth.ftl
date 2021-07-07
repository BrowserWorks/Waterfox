# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = 연락처의 신원 확인
    .buttonlabelaccept = 확인

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = { $name }의 신원 확인

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = 내 지문, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = { $their_name }의 지문:

auth-help = 연락처의 신원을 확인하면 대화가 비공개로 유지되므로 제 3자가 대화를 도청하거나 조작하기가 매우 어렵습니다.
auth-helpTitle = 확인 도움말

auth-questionReceived = 상대방이 묻는 질문입니다:

auth-yes =
    .label = 네

auth-no =
    .label = 아니오

auth-verified = 이것이 올바른 지문임을 확인했습니다.

auth-manualVerification = 수동 지문 확인
auth-questionAndAnswer = 질문과 답변
auth-sharedSecret = 같이 알고 있는 비밀

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = OpenPGP 서명 이메일 또는 전화와 같은 인증 된 다른 채널을 통해 대화 상대에게 연락 하십시오. 지문을 서로에게 알려야합니다. (지문은 암호화 키를 식별하는 체크섬입니다.) 지문이 일치하면 아래 대화 상자에서 지문을 확인했음을 표시해야 합니다.

auth-how = 연락처의 신원을 어떻게 확인 하시겠습니까?

auth-qaInstruction = 나와 내 연락처 사람만이 알 수 있는 질문을 생각해 보십시오. 질문과 답변을 입력 한 다음 상대방이 답변을 입력 할 때까지 기다립니다. 답변이 일치하지 않으면 사용중인 통신 채널이 감시중인 것일 수 있습니다.

auth-secretInstruction = 나와 내 연락처 사람만이 알 수 있는 비밀을 생각해 보십시오. 비밀을 교환하기 위해 동일한 인터넷 연결을 사용하지 마십시오. 비밀을 입력 한 다음 상대방이 입력 할 때까지 기다립니다. 비밀이 일치하지 않으면 사용중인 통신 채널이 감시중인 것일 수 있습니다.

auth-question = 질문 입력:

auth-answer = 답변 입력(대소문자 구분):

auth-secret = 비밀 입력:
