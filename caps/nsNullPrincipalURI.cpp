/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=2 sts=2 expandtab
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsNullPrincipalURI.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/MemoryReporting.h"

#include "mozilla/ipc/URIParams.h"

#include "nsEscape.h"
#include "nsCRT.h"
#include "nsIUUIDGenerator.h"

////////////////////////////////////////////////////////////////////////////////
//// nsNullPrincipalURI

nsNullPrincipalURI::nsNullPrincipalURI()
  : mPath(mPathBytes, ArrayLength(mPathBytes), ArrayLength(mPathBytes) - 1)
{
}

nsNullPrincipalURI::nsNullPrincipalURI(const nsNullPrincipalURI& aOther)
  : mPath(mPathBytes, ArrayLength(mPathBytes), ArrayLength(mPathBytes) - 1)
{
  mPath.Assign(aOther.mPath);
}

nsresult
nsNullPrincipalURI::Init()
{
  // FIXME: bug 327161 -- make sure the uuid generator is reseeding-resistant.
  nsCOMPtr<nsIUUIDGenerator> uuidgen = services::GetUUIDGenerator();
  NS_ENSURE_TRUE(uuidgen, NS_ERROR_NOT_AVAILABLE);

  nsID id;
  nsresult rv = uuidgen->GenerateUUIDInPlace(&id);
  NS_ENSURE_SUCCESS(rv, rv);

  MOZ_ASSERT(mPathBytes == mPath.BeginWriting());

  id.ToProvidedString(mPathBytes);

  MOZ_ASSERT(mPath.Length() == NSID_LENGTH - 1);
  MOZ_ASSERT(strlen(mPath.get()) == NSID_LENGTH - 1);

  return NS_OK;
}

/* static */
already_AddRefed<nsNullPrincipalURI>
nsNullPrincipalURI::Create()
{
  RefPtr<nsNullPrincipalURI> uri = new nsNullPrincipalURI();
  nsresult rv = uri->Init();
  NS_ENSURE_SUCCESS(rv, nullptr);
  return uri.forget();
}

static NS_DEFINE_CID(kNullPrincipalURIImplementationCID,
                     NS_NULLPRINCIPALURI_IMPLEMENTATION_CID);

NS_IMPL_ADDREF(nsNullPrincipalURI)
NS_IMPL_RELEASE(nsNullPrincipalURI)

NS_INTERFACE_MAP_BEGIN(nsNullPrincipalURI)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIURI)
  if (aIID.Equals(kNullPrincipalURIImplementationCID))
    foundInterface = static_cast<nsIURI *>(this);
  else
  NS_INTERFACE_MAP_ENTRY(nsIURI)
  NS_INTERFACE_MAP_ENTRY(nsISizeOf)
  NS_INTERFACE_MAP_ENTRY(nsIIPCSerializableURI)
NS_INTERFACE_MAP_END

////////////////////////////////////////////////////////////////////////////////
//// nsIURI

NS_IMETHODIMP
nsNullPrincipalURI::GetAsciiHost(nsACString &_host)
{
  _host.Truncate();
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetAsciiHostPort(nsACString &_hostport)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetAsciiSpec(nsACString &_spec)
{
  nsAutoCString buffer;
  // Ignore the return value -- nsNullPrincipalURI::GetSpec() is infallible.
  Unused << GetSpec(buffer);
  // This uses the infallible version of |NS_EscapeURL| as |GetSpec| is
  // already infallible.
  NS_EscapeURL(buffer, esc_OnlyNonASCII | esc_AlwaysCopy, _spec);
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetHost(nsACString &_host)
{
  _host.Truncate();
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetHost(const nsACString &aHost)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetHostPort(nsACString &_host)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetHostPort(const nsACString &aHost)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetHostAndPort(const nsACString &aHost)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetOriginCharset(nsACString &_charset)
{
  _charset.Truncate();
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetPassword(nsACString &_password)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetPassword(const nsACString &aPassword)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetPath(nsACString &_path)
{
  _path = mPath;
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetPath(const nsACString &aPath)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetRef(nsACString &_ref)
{
  _ref.Truncate();
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetRef(const nsACString &aRef)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetPrePath(nsACString &_prePath)
{
  _prePath = NS_LITERAL_CSTRING(NS_NULLPRINCIPAL_SCHEME ":");
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetPort(int32_t *_port)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetPort(int32_t aPort)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetScheme(nsACString &_scheme)
{
  _scheme = NS_LITERAL_CSTRING(NS_NULLPRINCIPAL_SCHEME);
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetScheme(const nsACString &aScheme)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetSpec(nsACString &_spec)
{
  _spec = NS_LITERAL_CSTRING(NS_NULLPRINCIPAL_SCHEME ":") + mPath;
  return NS_OK;
}

// result may contain unescaped UTF-8 characters
NS_IMETHODIMP
nsNullPrincipalURI::GetSpecIgnoringRef(nsACString &result)
{
  return GetSpec(result);
}

NS_IMETHODIMP
nsNullPrincipalURI::GetHasRef(bool *result)
{
  *result = false;
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetSpec(const nsACString &aSpec)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetUsername(nsACString &_username)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetUsername(const nsACString &aUsername)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::GetUserPass(nsACString &_userPass)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::SetUserPass(const nsACString &aUserPass)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsNullPrincipalURI::Clone(nsIURI **_newURI)
{
  nsCOMPtr<nsIURI> uri = new nsNullPrincipalURI(*this);
  uri.forget(_newURI);
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::CloneIgnoringRef(nsIURI **_newURI)
{
  // GetRef/SetRef not supported by nsNullPrincipalURI, so
  // CloneIgnoringRef() is the same as Clone().
  return Clone(_newURI);
}

NS_IMETHODIMP
nsNullPrincipalURI::CloneWithNewRef(const nsACString& newRef, nsIURI **_newURI)
{
  // GetRef/SetRef not supported by nsNullPrincipalURI, so
  // CloneWithNewRef() is the same as Clone().
  return Clone(_newURI);
}

NS_IMETHODIMP
nsNullPrincipalURI::Equals(nsIURI *aOther, bool *_equals)
{
  *_equals = false;
  RefPtr<nsNullPrincipalURI> otherURI;
  nsresult rv = aOther->QueryInterface(kNullPrincipalURIImplementationCID,
                                       getter_AddRefs(otherURI));
  if (NS_SUCCEEDED(rv)) {
    *_equals = mPath == otherURI->mPath;
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::EqualsExceptRef(nsIURI *aOther, bool *_equals)
{
  // GetRef/SetRef not supported by nsNullPrincipalURI, so
  // EqualsExceptRef() is the same as Equals().
  return Equals(aOther, _equals);
}

NS_IMETHODIMP
nsNullPrincipalURI::Resolve(const nsACString &aRelativePath,
                            nsACString &_resolvedURI)
{
  _resolvedURI = aRelativePath;
  return NS_OK;
}

NS_IMETHODIMP
nsNullPrincipalURI::SchemeIs(const char *aScheme, bool *_schemeIs)
{
  *_schemeIs = (0 == nsCRT::strcasecmp(NS_NULLPRINCIPAL_SCHEME, aScheme));
  return NS_OK;
}

////////////////////////////////////////////////////////////////////////////////
//// nsIIPCSerializableURI

void
nsNullPrincipalURI::Serialize(mozilla::ipc::URIParams &aParams)
{
  aParams = mozilla::ipc::NullPrincipalURIParams();
}

bool
nsNullPrincipalURI::Deserialize(const mozilla::ipc::URIParams &aParams)
{
  if (aParams.type() != mozilla::ipc::URIParams::TNullPrincipalURIParams) {
    MOZ_ASSERT_UNREACHABLE("unexpected URIParams type");
    return false;
  }

  nsresult rv = Init();
  NS_ENSURE_SUCCESS(rv, false);

  return true;
}

////////////////////////////////////////////////////////////////////////////////
//// nsISizeOf

size_t
nsNullPrincipalURI::SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf) const
{
  return mPath.SizeOfExcludingThisIfUnshared(aMallocSizeOf);
}

size_t
nsNullPrincipalURI::SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf) const {
  return aMallocSizeOf(this) + SizeOfExcludingThis(aMallocSizeOf);
}

