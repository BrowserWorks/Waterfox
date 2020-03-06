// Copyright (c) 2006-2008 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "sandbox/win/src/sid.h"

#include <stdlib.h>

#include "base/logging.h"
#include "base/rand_util.h"

namespace sandbox {

Sid::Sid() : sid_() {}

Sid::Sid(PSID sid) : sid_() {
  ::CopySid(SECURITY_MAX_SID_SIZE, sid_, sid);
}

Sid::Sid(const SID *sid) {
  ::CopySid(SECURITY_MAX_SID_SIZE, sid_, const_cast<SID*>(sid));
};

Sid::Sid(WELL_KNOWN_SID_TYPE type) {
  DWORD size_sid = SECURITY_MAX_SID_SIZE;
  BOOL result = ::CreateWellKnownSid(type, NULL, sid_, &size_sid);
  DCHECK(result);
  (void)result;
}

Sid Sid::FromSubAuthorities(PSID_IDENTIFIER_AUTHORITY identifier_authority,
                            BYTE sub_authority_count,
                            PDWORD sub_authorities) {
  Sid sid;
  if (!::InitializeSid(sid.sid_, identifier_authority, sub_authority_count))
    return Sid();

  for (DWORD index = 0; index < sub_authority_count; ++index) {
    PDWORD sub_authority = GetSidSubAuthority(sid.sid_, index);
    *sub_authority = sub_authorities[index];
  }
  return sid;
}

Sid Sid::GenerateRandomSid() {
  SID_IDENTIFIER_AUTHORITY package_authority = {SECURITY_NULL_SID_AUTHORITY};
  DWORD sub_authorities[4] = {};
  base::RandBytes(&sub_authorities, sizeof(sub_authorities));
  return FromSubAuthorities(&package_authority, _countof(sub_authorities),
                            sub_authorities);
}

PSID Sid::GetPSID() const {
  return reinterpret_cast<SID*>(const_cast<BYTE*>(sid_));
}

}  // namespace sandbox
