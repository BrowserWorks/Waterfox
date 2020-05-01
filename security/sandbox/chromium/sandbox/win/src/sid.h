// Copyright (c) 2006-2008 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef SANDBOX_SRC_SID_H_
#define SANDBOX_SRC_SID_H_

#include <windows.h>

namespace sandbox {

// This class is used to hold and generate SIDS.
class Sid {
 public:
  // As PSID is just a void* make it explicit.
  explicit Sid(PSID sid);
  // Constructors initializing the object with the SID passed.
  // This is a converting constructor. It is not explicit.
  Sid(const SID *sid);
  Sid(WELL_KNOWN_SID_TYPE type);

  // Create a Sid from a set of sub authorities.
  static Sid FromSubAuthorities(PSID_IDENTIFIER_AUTHORITY identifier_authority,
                                BYTE sub_authority_count,
                                PDWORD sub_authorities);

  // Generate a random SID value.
  static Sid GenerateRandomSid();

  // Returns sid_.
  PSID GetPSID() const;

 private:
  Sid();
  BYTE sid_[SECURITY_MAX_SID_SIZE];
};

}  // namespace sandbox

#endif  // SANDBOX_SRC_SID_H_
