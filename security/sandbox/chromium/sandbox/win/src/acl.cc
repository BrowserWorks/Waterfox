// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "sandbox/win/src/acl.h"

#include <aclapi.h>
#include <sddl.h>

#include "base/logging.h"
#include "base/memory/free_deleter.h"

namespace sandbox {

bool GetDefaultDacl(
    HANDLE token,
    std::unique_ptr<TOKEN_DEFAULT_DACL, base::FreeDeleter>* default_dacl) {
  if (token == NULL)
    return false;

  DCHECK(default_dacl != NULL);

  unsigned long length = 0;
  ::GetTokenInformation(token, TokenDefaultDacl, NULL, 0, &length);
  if (length == 0) {
    NOTREACHED();
    return false;
  }

  TOKEN_DEFAULT_DACL* acl =
      reinterpret_cast<TOKEN_DEFAULT_DACL*>(malloc(length));
  default_dacl->reset(acl);

  if (!::GetTokenInformation(token, TokenDefaultDacl, default_dacl->get(),
                             length, &length))
      return false;

  return true;
}

bool AddSidToDacl(const Sid& sid, ACL* old_dacl, ACCESS_MODE access_mode,
                  ACCESS_MASK access, ACL** new_dacl) {
  EXPLICIT_ACCESS new_access = {0};
  new_access.grfAccessMode = access_mode;
  new_access.grfAccessPermissions = access;
  new_access.grfInheritance = NO_INHERITANCE;

  new_access.Trustee.pMultipleTrustee = NULL;
  new_access.Trustee.MultipleTrusteeOperation = NO_MULTIPLE_TRUSTEE;
  new_access.Trustee.TrusteeForm = TRUSTEE_IS_SID;
  new_access.Trustee.ptstrName = reinterpret_cast<LPWSTR>(
                                    const_cast<SID*>(sid.GetPSID()));

  if (ERROR_SUCCESS != ::SetEntriesInAcl(1, &new_access, old_dacl, new_dacl))
    return false;

  return true;
}

bool AddSidToDefaultDacl(HANDLE token,
                         const Sid& sid,
                         ACCESS_MODE access_mode,
                         ACCESS_MASK access) {
  if (token == NULL)
    return false;

  std::unique_ptr<TOKEN_DEFAULT_DACL, base::FreeDeleter> default_dacl;
  if (!GetDefaultDacl(token, &default_dacl))
    return false;

  ACL* new_dacl = NULL;
  if (!AddSidToDacl(sid, default_dacl->DefaultDacl, access_mode, access,
                    &new_dacl))
    return false;

  TOKEN_DEFAULT_DACL new_token_dacl = {0};
  new_token_dacl.DefaultDacl = new_dacl;

  BOOL ret = ::SetTokenInformation(token, TokenDefaultDacl, &new_token_dacl,
                                   sizeof(new_token_dacl));
  ::LocalFree(new_dacl);
  return (TRUE == ret);
}

bool RevokeLogonSidFromDefaultDacl(HANDLE token) {
  DWORD size = sizeof(TOKEN_GROUPS) + SECURITY_MAX_SID_SIZE;
  TOKEN_GROUPS* logon_sid = reinterpret_cast<TOKEN_GROUPS*>(malloc(size));

  std::unique_ptr<TOKEN_GROUPS, base::FreeDeleter> logon_sid_ptr(logon_sid);

  if (!::GetTokenInformation(token, TokenLogonSid, logon_sid, size, &size)) {
    // If no logon sid, there's nothing to revoke.
    if (::GetLastError() == ERROR_NOT_FOUND)
      return true;
    return false;
  }
  if (logon_sid->GroupCount < 1) {
    ::SetLastError(ERROR_INVALID_TOKEN);
    return false;
  }
  return AddSidToDefaultDacl(token,
                             reinterpret_cast<SID*>(logon_sid->Groups[0].Sid),
                             REVOKE_ACCESS, 0);
}

bool AddUserSidToDefaultDacl(HANDLE token, ACCESS_MASK access) {
  DWORD size = sizeof(TOKEN_USER) + SECURITY_MAX_SID_SIZE;
  TOKEN_USER* token_user = reinterpret_cast<TOKEN_USER*>(malloc(size));

  std::unique_ptr<TOKEN_USER, base::FreeDeleter> token_user_ptr(token_user);

  if (!::GetTokenInformation(token, TokenUser, token_user, size, &size))
    return false;

  return AddSidToDefaultDacl(token,
                             reinterpret_cast<SID*>(token_user->User.Sid),
                             GRANT_ACCESS, access);
}

bool AddKnownSidToObject(HANDLE object, SE_OBJECT_TYPE object_type,
                         const Sid& sid, ACCESS_MODE access_mode,
                         ACCESS_MASK access) {
  PSECURITY_DESCRIPTOR descriptor = NULL;
  PACL old_dacl = NULL;
  PACL new_dacl = NULL;

  if (ERROR_SUCCESS != ::GetSecurityInfo(object, object_type,
                                         DACL_SECURITY_INFORMATION, NULL, NULL,
                                         &old_dacl, NULL, &descriptor))
    return false;

  if (!AddSidToDacl(sid.GetPSID(), old_dacl, access_mode, access, &new_dacl)) {
    ::LocalFree(descriptor);
    return false;
  }

  DWORD result = ::SetSecurityInfo(object, object_type,
                                   DACL_SECURITY_INFORMATION, NULL, NULL,
                                   new_dacl, NULL);

  ::LocalFree(new_dacl);
  ::LocalFree(descriptor);

  if (ERROR_SUCCESS != result)
    return false;

  return true;
}

}  // namespace sandbox
