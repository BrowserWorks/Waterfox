/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsNSSCertificate.h"

#include "CertVerifier.h"
#include "ExtendedValidation.h"
#include "NSSCertDBTrustDomain.h"
#include "certdb.h"
#include "mozilla/Assertions.h"
#include "mozilla/Base64.h"
#include "mozilla/Casting.h"
#include "mozilla/NotNull.h"
#include "mozilla/Unused.h"
#include "nsArray.h"
#include "nsCOMPtr.h"
#include "nsICertificateDialogs.h"
#include "nsIClassInfoImpl.h"
#include "nsIObjectInputStream.h"
#include "nsIObjectOutputStream.h"
#include "nsISupportsPrimitives.h"
#include "nsIURI.h"
#include "nsIX509Cert.h"
#include "nsNSSASN1Object.h"
#include "nsNSSCertHelper.h"
#include "nsNSSCertValidity.h"
#include "nsNSSComponent.h" // for PIPNSS string bundle calls.
#include "nsPK11TokenDB.h"
#include "nsPKCS12Blob.h"
#include "nsProxyRelease.h"
#include "nsReadableUtils.h"
#include "nsString.h"
#include "nsThreadUtils.h"
#include "nsUnicharUtils.h"
#include "nspr.h"
#include "pkix/pkixnss.h"
#include "pkix/pkixtypes.h"
#include "pkix/Result.h"
#include "prerror.h"
#include "prmem.h"
#include "secasn1.h"
#include "secder.h"
#include "secerr.h"
#include "ssl.h"

#ifdef XP_WIN
#include <winsock.h> // for htonl
#endif

using namespace mozilla;
using namespace mozilla::psm;

extern LazyLogModule gPIPNSSLog;

// This is being stored in an uint32_t that can otherwise
// only take values from nsIX509Cert's list of cert types.
// As nsIX509Cert is frozen, we choose a value not contained
// in the list to mean not yet initialized.
#define CERT_TYPE_NOT_YET_INITIALIZED (1 << 30)

NS_IMPL_ISUPPORTS(nsNSSCertificate,
                  nsIX509Cert,
                  nsISerializable,
                  nsIClassInfo)

static NS_DEFINE_CID(kNSSComponentCID, NS_NSSCOMPONENT_CID);

/*static*/ nsNSSCertificate*
nsNSSCertificate::Create(CERTCertificate* cert)
{
  if (cert)
    return new nsNSSCertificate(cert);
  else
    return new nsNSSCertificate();
}

nsNSSCertificate*
nsNSSCertificate::ConstructFromDER(char* certDER, int derLen)
{
  nsNSSCertificate* newObject = nsNSSCertificate::Create();
  if (newObject && !newObject->InitFromDER(certDER, derLen)) {
    delete newObject;
    newObject = nullptr;
  }

  return newObject;
}

bool
nsNSSCertificate::InitFromDER(char* certDER, int derLen)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return false;

  if (!certDER || !derLen)
    return false;

  CERTCertificate* aCert = CERT_DecodeCertFromPackage(certDER, derLen);

  if (!aCert)
    return false;

  if (!aCert->dbhandle)
  {
    aCert->dbhandle = CERT_GetDefaultCertDB();
  }

  mCert.reset(aCert);
  return true;
}

nsNSSCertificate::nsNSSCertificate(CERTCertificate* cert)
  : mCert(nullptr)
  , mPermDelete(false)
  , mCertType(CERT_TYPE_NOT_YET_INITIALIZED)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return;

  if (cert) {
    mCert.reset(CERT_DupCertificate(cert));
  }
}

nsNSSCertificate::nsNSSCertificate()
  : mCert(nullptr)
  , mPermDelete(false)
  , mCertType(CERT_TYPE_NOT_YET_INITIALIZED)
{
}

nsNSSCertificate::~nsNSSCertificate()
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return;
  }
  destructorSafeDestroyNSSReference();
  shutdown(ShutdownCalledFrom::Object);
}

void nsNSSCertificate::virtualDestroyNSSReference()
{
  destructorSafeDestroyNSSReference();
}

void nsNSSCertificate::destructorSafeDestroyNSSReference()
{
  if (mPermDelete) {
    if (mCertType == nsNSSCertificate::USER_CERT) {
      nsCOMPtr<nsIInterfaceRequestor> cxt = new PipUIContext();
      PK11_DeleteTokenCertAndKey(mCert.get(), cxt);
    } else if (mCert->slot && !PK11_IsReadOnly(mCert->slot)) {
      // If the list of built-ins does contain a non-removable
      // copy of this certificate, our call will not remove
      // the certificate permanently, but rather remove all trust.
      SEC_DeletePermCertificate(mCert.get());
    }
  }

  mCert = nullptr;
}

nsresult
nsNSSCertificate::GetCertType(uint32_t* aCertType)
{
  if (mCertType == CERT_TYPE_NOT_YET_INITIALIZED) {
     // only determine cert type once and cache it
     mCertType = getCertType(mCert.get());
  }
  *aCertType = mCertType;
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetIsSelfSigned(bool* aIsSelfSigned)
{
  NS_ENSURE_ARG(aIsSelfSigned);

  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  *aIsSelfSigned = mCert->isRoot;
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetIsBuiltInRoot(bool* aIsBuiltInRoot)
{
  NS_ENSURE_ARG(aIsBuiltInRoot);

  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  pkix::Result rv = IsCertBuiltInRoot(mCert.get(), *aIsBuiltInRoot);
  if (rv != pkix::Result::Success) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

nsresult
nsNSSCertificate::MarkForPermDeletion()
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  // make sure user is logged in to the token
  nsCOMPtr<nsIInterfaceRequestor> ctx = new PipUIContext();

  if (mCert->slot && PK11_NeedLogin(mCert->slot) &&
      !PK11_NeedUserInit(mCert->slot) && !PK11_IsInternal(mCert->slot)) {
    if (SECSuccess != PK11_Authenticate(mCert->slot, true, ctx)) {
      return NS_ERROR_FAILURE;
    }
  }

  mPermDelete = true;
  return NS_OK;
}

/**
 * Appends a pipnss bundle string to the given string.
 *
 * @param nssComponent For accessing the string bundle.
 * @param bundleKey Key for the string to append.
 * @param currentText The text to append to, using commas as separators.
 */
template<size_t N>
void
AppendBundleString(const NotNull<nsCOMPtr<nsINSSComponent>>& nssComponent,
                   const char (&bundleKey)[N],
        /*in/out*/ nsAString& currentText)
{
  nsAutoString bundleString;
  nsresult rv = nssComponent->GetPIPNSSBundleString(bundleKey, bundleString);
  if (NS_FAILED(rv)) {
    return;
  }

  if (!currentText.IsEmpty()) {
    currentText.Append(',');
  }
  currentText.Append(bundleString);
}

NS_IMETHODIMP
nsNSSCertificate::GetKeyUsages(nsAString& text)
{
  text.Truncate();

  nsCOMPtr<nsINSSComponent> nssComponent = do_GetService(kNSSComponentCID);
  if (!nssComponent) {
    return NS_ERROR_FAILURE;
  }

  if (!mCert) {
    return NS_ERROR_FAILURE;
  }

  if (!mCert->extensions) {
    return NS_OK;
  }

  ScopedAutoSECItem keyUsageItem;
  if (CERT_FindKeyUsageExtension(mCert.get(), &keyUsageItem) != SECSuccess) {
    return PORT_GetError() == SEC_ERROR_EXTENSION_NOT_FOUND ? NS_OK
                                                            : NS_ERROR_FAILURE;
  }

  unsigned char keyUsage = 0;
  if (keyUsageItem.len) {
    keyUsage = keyUsageItem.data[0];
  }

  NotNull<nsCOMPtr<nsINSSComponent>> wrappedNSSComponent =
    WrapNotNull(nssComponent);
  if (keyUsage & KU_DIGITAL_SIGNATURE) {
    AppendBundleString(wrappedNSSComponent, "CertDumpKUSign", text);
  }
  if (keyUsage & KU_NON_REPUDIATION) {
    AppendBundleString(wrappedNSSComponent, "CertDumpKUNonRep", text);
  }
  if (keyUsage & KU_KEY_ENCIPHERMENT) {
    AppendBundleString(wrappedNSSComponent, "CertDumpKUEnc", text);
  }
  if (keyUsage & KU_DATA_ENCIPHERMENT) {
    AppendBundleString(wrappedNSSComponent, "CertDumpKUDEnc", text);
  }
  if (keyUsage & KU_KEY_AGREEMENT) {
    AppendBundleString(wrappedNSSComponent, "CertDumpKUKA", text);
  }
  if (keyUsage & KU_KEY_CERT_SIGN) {
    AppendBundleString(wrappedNSSComponent, "CertDumpKUCertSign", text);
  }
  if (keyUsage & KU_CRL_SIGN) {
    AppendBundleString(wrappedNSSComponent, "CertDumpKUCRLSign", text);
  }

  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetDbKey(nsACString& aDbKey)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  return GetDbKey(mCert, aDbKey);
}

nsresult
nsNSSCertificate::GetDbKey(const UniqueCERTCertificate& cert, nsACString& aDbKey)
{
  static_assert(sizeof(uint64_t) == 8, "type size sanity check");
  static_assert(sizeof(uint32_t) == 4, "type size sanity check");
  // The format of the key is the base64 encoding of the following:
  // 4 bytes: {0, 0, 0, 0} (this was intended to be the module ID, but it was
  //                        never implemented)
  // 4 bytes: {0, 0, 0, 0} (this was intended to be the slot ID, but it was
  //                        never implemented)
  // 4 bytes: <serial number length in big-endian order>
  // 4 bytes: <DER-encoded issuer distinguished name length in big-endian order>
  // n bytes: <bytes of serial number>
  // m bytes: <DER-encoded issuer distinguished name>
  nsAutoCString buf;
  const char leadingZeroes[] = {0, 0, 0, 0, 0, 0, 0, 0};
  buf.Append(leadingZeroes, sizeof(leadingZeroes));
  uint32_t serialNumberLen = htonl(cert->serialNumber.len);
  buf.Append(BitwiseCast<const char*, const uint32_t*>(&serialNumberLen),
             sizeof(uint32_t));
  uint32_t issuerLen = htonl(cert->derIssuer.len);
  buf.Append(BitwiseCast<const char*, const uint32_t*>(&issuerLen),
             sizeof(uint32_t));
  buf.Append(BitwiseCast<char*, unsigned char*>(cert->serialNumber.data),
             cert->serialNumber.len);
  buf.Append(BitwiseCast<char*, unsigned char*>(cert->derIssuer.data),
             cert->derIssuer.len);

  return Base64Encode(buf, aDbKey);
}

NS_IMETHODIMP
nsNSSCertificate::GetDisplayName(nsAString& aDisplayName)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  aDisplayName.Truncate();

  MOZ_ASSERT(mCert, "mCert should not be null in GetDisplayName");
  if (!mCert) {
    return NS_ERROR_FAILURE;
  }

  UniquePORTString commonName(CERT_GetCommonName(&mCert->subject));
  UniquePORTString organizationalUnitName(CERT_GetOrgUnitName(&mCert->subject));
  UniquePORTString organizationName(CERT_GetOrgName(&mCert->subject));

  bool isBuiltInRoot;
  nsresult rv = GetIsBuiltInRoot(&isBuiltInRoot);
  if (NS_FAILED(rv)) {
    return rv;
  }

  // Only use the nickname for built-in roots where we already have a hard-coded
  // reasonable display name (unfortunately we have to strip off the leading
  // slot identifier followed by a ':'). Otherwise, attempt to use the following
  // in order:
  //  - the common name, if present
  //  - an organizational unit name, if present
  //  - an organization name, if present
  //  - the entire subject distinguished name, if non-empty
  //  - an email address, if one can be found
  // In the unlikely event that none of these fields are present and non-empty
  // (the subject really shouldn't be empty), an empty string is returned.
  nsAutoCString builtInRootNickname;
  if (isBuiltInRoot) {
    nsAutoCString fullNickname(mCert->nickname);
    int32_t index = fullNickname.Find(":");
    if (index != kNotFound) {
      // Substring will gracefully handle the case where index is the last
      // character in the string (that is, if the nickname is just
      // "Builtin Object Token:"). In that case, we'll get an empty string.
      builtInRootNickname = Substring(fullNickname,
                                      AssertedCast<uint32_t>(index + 1));
    }
  }
  const char* nameOptions[] = {
    builtInRootNickname.get(),
    commonName.get(),
    organizationalUnitName.get(),
    organizationName.get(),
    mCert->subjectName,
    mCert->emailAddr
  };

  nsAutoCString nameOption;
  for (auto nameOptionPtr : nameOptions) {
    nameOption.Assign(nameOptionPtr);
    if (nameOption.Length() > 0 && IsUTF8(nameOption)) {
      CopyUTF8toUTF16(nameOption, aDisplayName);
      return NS_OK;
    }
  }

  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetEmailAddress(nsAString& aEmailAddress)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  if (mCert->emailAddr) {
    CopyUTF8toUTF16(mCert->emailAddr, aEmailAddress);
  } else {
    nsresult rv;
    nsCOMPtr<nsINSSComponent> nssComponent(do_GetService(kNSSComponentCID, &rv));
    if (NS_FAILED(rv) || !nssComponent) {
      return NS_ERROR_FAILURE;
    }
    nssComponent->GetPIPNSSBundleString("CertNoEmailAddress", aEmailAddress);
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetEmailAddresses(uint32_t* aLength, char16_t*** aAddresses)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  NS_ENSURE_ARG(aLength);
  NS_ENSURE_ARG(aAddresses);

  *aLength = 0;

  const char* aAddr;
  for (aAddr = CERT_GetFirstEmailAddress(mCert.get())
       ;
       aAddr
       ;
       aAddr = CERT_GetNextEmailAddress(mCert.get(), aAddr))
  {
    ++(*aLength);
  }

  *aAddresses = (char16_t**) moz_xmalloc(sizeof(char16_t*) * (*aLength));
  if (!*aAddresses)
    return NS_ERROR_OUT_OF_MEMORY;

  uint32_t iAddr;
  for (aAddr = CERT_GetFirstEmailAddress(mCert.get()), iAddr = 0
       ;
       aAddr
       ;
       aAddr = CERT_GetNextEmailAddress(mCert.get(), aAddr), ++iAddr)
  {
    (*aAddresses)[iAddr] = ToNewUnicode(NS_ConvertUTF8toUTF16(aAddr));
  }

  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::ContainsEmailAddress(const nsAString& aEmailAddress,
                                       bool* result)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  NS_ENSURE_ARG(result);
  *result = false;

  const char* aAddr = nullptr;
  for (aAddr = CERT_GetFirstEmailAddress(mCert.get())
       ;
       aAddr
       ;
       aAddr = CERT_GetNextEmailAddress(mCert.get(), aAddr))
  {
    NS_ConvertUTF8toUTF16 certAddr(aAddr);
    ToLowerCase(certAddr);

    nsAutoString testAddr(aEmailAddress);
    ToLowerCase(testAddr);

    if (certAddr == testAddr)
    {
      *result = true;
      break;
    }

  }

  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetCommonName(nsAString& aCommonName)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  aCommonName.Truncate();
  if (mCert) {
    UniquePORTString commonName(CERT_GetCommonName(&mCert->subject));
    if (commonName) {
      aCommonName = NS_ConvertUTF8toUTF16(commonName.get());
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetOrganization(nsAString& aOrganization)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  aOrganization.Truncate();
  if (mCert) {
    UniquePORTString organization(CERT_GetOrgName(&mCert->subject));
    if (organization) {
      aOrganization = NS_ConvertUTF8toUTF16(organization.get());
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetIssuerCommonName(nsAString& aCommonName)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  aCommonName.Truncate();
  if (mCert) {
    UniquePORTString commonName(CERT_GetCommonName(&mCert->issuer));
    if (commonName) {
      aCommonName = NS_ConvertUTF8toUTF16(commonName.get());
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetIssuerOrganization(nsAString& aOrganization)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  aOrganization.Truncate();
  if (mCert) {
    UniquePORTString organization(CERT_GetOrgName(&mCert->issuer));
    if (organization) {
      aOrganization = NS_ConvertUTF8toUTF16(organization.get());
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetIssuerOrganizationUnit(nsAString& aOrganizationUnit)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  aOrganizationUnit.Truncate();
  if (mCert) {
    UniquePORTString organizationUnit(CERT_GetOrgUnitName(&mCert->issuer));
    if (organizationUnit) {
      aOrganizationUnit = NS_ConvertUTF8toUTF16(organizationUnit.get());
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetIssuer(nsIX509Cert** aIssuer)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  NS_ENSURE_ARG(aIssuer);
  *aIssuer = nullptr;

  nsCOMPtr<nsIArray> chain;
  nsresult rv;
  rv = GetChain(getter_AddRefs(chain));
  NS_ENSURE_SUCCESS(rv, rv);
  uint32_t length;
  if (!chain || NS_FAILED(chain->GetLength(&length)) || length == 0) {
    return NS_ERROR_UNEXPECTED;
  }
  if (length == 1) { // No known issuer
    return NS_OK;
  }
  nsCOMPtr<nsIX509Cert> cert;
  chain->QueryElementAt(1, NS_GET_IID(nsIX509Cert), getter_AddRefs(cert));
  if (!cert) {
    return NS_ERROR_UNEXPECTED;
  }
  cert.forget(aIssuer);
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetOrganizationalUnit(nsAString& aOrganizationalUnit)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  aOrganizationalUnit.Truncate();
  if (mCert) {
    UniquePORTString orgunit(CERT_GetOrgUnitName(&mCert->subject));
    if (orgunit) {
      aOrganizationalUnit = NS_ConvertUTF8toUTF16(orgunit.get());
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetChain(nsIArray** _rvChain)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  NS_ENSURE_ARG(_rvChain);

  mozilla::pkix::Time now(mozilla::pkix::Now());

  RefPtr<SharedCertVerifier> certVerifier(GetDefaultCertVerifier());
  NS_ENSURE_TRUE(certVerifier, NS_ERROR_UNEXPECTED);

  UniqueCERTCertList nssChain;
  // We want to test all usages, but we start with server because most of the
  // time Firefox users care about server certs.
  if (certVerifier->VerifyCert(mCert.get(), certificateUsageSSLServer, now,
                               nullptr, /*XXX fixme*/
                               nullptr, /* hostname */
                               nssChain,
                               nullptr, // no peerCertChain
                               CertVerifier::FLAG_LOCAL_ONLY)
        != mozilla::pkix::Success) {
    nssChain = nullptr;
    // keep going
  }

  // This is the whitelist of all non-SSLServer usages that are supported by
  // verifycert.
  const int otherUsagesToTest = certificateUsageSSLClient |
                                certificateUsageSSLCA |
                                certificateUsageEmailSigner |
                                certificateUsageEmailRecipient |
                                certificateUsageObjectSigner |
                                certificateUsageStatusResponder;
  for (int usage = certificateUsageSSLClient;
       usage < certificateUsageAnyCA && !nssChain;
       usage = usage << 1) {
    if ((usage & otherUsagesToTest) == 0) {
      continue;
    }
    if (certVerifier->VerifyCert(mCert.get(), usage, now,
                                 nullptr, /*XXX fixme*/
                                 nullptr, /*hostname*/
                                 nssChain,
                                 nullptr, // no peerCertChain
                                 CertVerifier::FLAG_LOCAL_ONLY)
          != mozilla::pkix::Success) {
      nssChain = nullptr;
      // keep going
    }
  }

  if (!nssChain) {
    // There is not verified path for the chain, however we still want to
    // present to the user as much of a possible chain as possible, in the case
    // where there was a problem with the cert or the issuers.
    nssChain = UniqueCERTCertList(
      CERT_GetCertChainFromCert(mCert.get(), PR_Now(), certUsageSSLClient));
  }
  if (!nssChain) {
    return NS_ERROR_FAILURE;
  }

  // enumerate the chain for scripting purposes
  nsCOMPtr<nsIMutableArray> array = nsArrayBase::Create();
  if (!array) {
    return NS_ERROR_FAILURE;
  }
  CERTCertListNode* node;
  for (node = CERT_LIST_HEAD(nssChain.get());
       !CERT_LIST_END(node, nssChain.get());
       node = CERT_LIST_NEXT(node)) {
    nsCOMPtr<nsIX509Cert> cert = nsNSSCertificate::Create(node->cert);
    array->AppendElement(cert, false);
  }
  *_rvChain = array;
  NS_IF_ADDREF(*_rvChain);
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetSubjectName(nsAString& _subjectName)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  _subjectName.Truncate();
  if (mCert->subjectName) {
    _subjectName = NS_ConvertUTF8toUTF16(mCert->subjectName);
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetIssuerName(nsAString& _issuerName)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  _issuerName.Truncate();
  if (mCert->issuerName) {
    _issuerName = NS_ConvertUTF8toUTF16(mCert->issuerName);
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetSerialNumber(nsAString& _serialNumber)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  _serialNumber.Truncate();
  UniquePORTString tmpstr(CERT_Hexify(&mCert->serialNumber, 1));
  if (tmpstr) {
    _serialNumber = NS_ConvertASCIItoUTF16(tmpstr.get());
    return NS_OK;
  }
  return NS_ERROR_FAILURE;
}

nsresult
nsNSSCertificate::GetCertificateHash(nsAString& aFingerprint, SECOidTag aHashAlg)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  aFingerprint.Truncate();
  Digest digest;
  nsresult rv = digest.DigestBuf(aHashAlg, mCert->derCert.data,
                                 mCert->derCert.len);
  if (NS_FAILED(rv)) {
    return rv;
  }

  // CERT_Hexify's second argument is an int that is interpreted as a boolean
  UniquePORTString fpStr(CERT_Hexify(const_cast<SECItem*>(&digest.get()), 1));
  if (!fpStr) {
    return NS_ERROR_FAILURE;
  }

  aFingerprint.AssignASCII(fpStr.get());
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetSha256Fingerprint(nsAString& aSha256Fingerprint)
{
  return GetCertificateHash(aSha256Fingerprint, SEC_OID_SHA256);
}

NS_IMETHODIMP
nsNSSCertificate::GetSha1Fingerprint(nsAString& _sha1Fingerprint)
{
  return GetCertificateHash(_sha1Fingerprint, SEC_OID_SHA1);
}

NS_IMETHODIMP
nsNSSCertificate::GetTokenName(nsAString& aTokenName)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  aTokenName.Truncate();
  if (mCert) {
    // HACK alert
    // When the trust of a builtin cert is modified, NSS copies it into the
    // cert db.  At this point, it is now "managed" by the user, and should
    // not be listed with the builtins.  However, in the collection code
    // used by PK11_ListCerts, the cert is found in the temp db, where it
    // has been loaded from the token.  Though the trust is correct (grabbed
    // from the cert db), the source is wrong.  I believe this is a safe
    // way to work around this.
    if (mCert->slot) {
      char* token = PK11_GetTokenName(mCert->slot);
      if (token) {
        aTokenName = NS_ConvertUTF8toUTF16(token);
      }
    } else {
      nsresult rv;
      nsAutoString tok;
      nsCOMPtr<nsINSSComponent> nssComponent(do_GetService(kNSSComponentCID, &rv));
      if (NS_FAILED(rv)) return rv;
      rv = nssComponent->GetPIPNSSBundleString("InternalToken", tok);
      if (NS_SUCCEEDED(rv))
        aTokenName = tok;
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetSha256SubjectPublicKeyInfoDigest(nsACString& aSha256SPKIDigest)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  aSha256SPKIDigest.Truncate();
  Digest digest;
  nsresult rv = digest.DigestBuf(SEC_OID_SHA256, mCert->derPublicKey.data,
                                 mCert->derPublicKey.len);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  rv = Base64Encode(nsDependentCSubstring(
                      BitwiseCast<char*, unsigned char*>(digest.get().data),
                      digest.get().len),
                    aSha256SPKIDigest);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetRawDER(uint32_t* aLength, uint8_t** aArray)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  if (mCert) {
    *aArray = (uint8_t*)moz_xmalloc(mCert->derCert.len);
    if (*aArray) {
      memcpy(*aArray, mCert->derCert.data, mCert->derCert.len);
      *aLength = mCert->derCert.len;
      return NS_OK;
    }
  }
  *aLength = 0;
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
nsNSSCertificate::ExportAsCMS(uint32_t chainMode,
                              uint32_t* aLength, uint8_t** aArray)
{
  NS_ENSURE_ARG(aLength);
  NS_ENSURE_ARG(aArray);

  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  if (!mCert)
    return NS_ERROR_FAILURE;

  switch (chainMode) {
    case nsIX509Cert::CMS_CHAIN_MODE_CertOnly:
    case nsIX509Cert::CMS_CHAIN_MODE_CertChain:
    case nsIX509Cert::CMS_CHAIN_MODE_CertChainWithRoot:
      break;
    default:
      return NS_ERROR_INVALID_ARG;
  }

  UniqueNSSCMSMessage cmsg(NSS_CMSMessage_Create(nullptr));
  if (!cmsg) {
    MOZ_LOG(gPIPNSSLog, LogLevel::Debug,
           ("nsNSSCertificate::ExportAsCMS - can't create CMS message\n"));
    return NS_ERROR_OUT_OF_MEMORY;
  }

  // first, create SignedData with the certificate only (no chain)
  UniqueNSSCMSSignedData sigd(
    NSS_CMSSignedData_CreateCertsOnly(cmsg.get(), mCert.get(), false));
  if (!sigd) {
    MOZ_LOG(gPIPNSSLog, LogLevel::Debug,
           ("nsNSSCertificate::ExportAsCMS - can't create SignedData\n"));
    return NS_ERROR_FAILURE;
  }

  // Calling NSS_CMSSignedData_CreateCertsOnly() will not allow us
  // to specify the inclusion of the root, but CERT_CertChainFromCert() does.
  // Since CERT_CertChainFromCert() also includes the certificate itself,
  // we have to start at the issuing cert (to avoid duplicate certs
  // in the SignedData).
  if (chainMode == nsIX509Cert::CMS_CHAIN_MODE_CertChain ||
      chainMode == nsIX509Cert::CMS_CHAIN_MODE_CertChainWithRoot) {
    UniqueCERTCertificate issuerCert(
      CERT_FindCertIssuer(mCert.get(), PR_Now(), certUsageAnyCA));
    // the issuerCert of a self signed root is the cert itself,
    // so make sure we're not adding duplicates, again
    if (issuerCert && issuerCert != mCert) {
      bool includeRoot =
        (chainMode == nsIX509Cert::CMS_CHAIN_MODE_CertChainWithRoot);
      UniqueCERTCertificateList certChain(
        CERT_CertChainFromCert(issuerCert.get(), certUsageAnyCA, includeRoot));
      if (certChain) {
        if (NSS_CMSSignedData_AddCertList(sigd.get(), certChain.get())
              == SECSuccess) {
          Unused << certChain.release();
        }
        else {
          MOZ_LOG(gPIPNSSLog, LogLevel::Debug,
                 ("nsNSSCertificate::ExportAsCMS - can't add chain\n"));
          return NS_ERROR_FAILURE;
        }
      }
      else {
        // try to add the issuerCert, at least
        if (NSS_CMSSignedData_AddCertificate(sigd.get(), issuerCert.get())
              == SECSuccess) {
          Unused << issuerCert.release();
        }
        else {
          MOZ_LOG(gPIPNSSLog, LogLevel::Debug,
                 ("nsNSSCertificate::ExportAsCMS - can't add issuer cert\n"));
          return NS_ERROR_FAILURE;
        }
      }
    }
  }

  NSSCMSContentInfo* cinfo = NSS_CMSMessage_GetContentInfo(cmsg.get());
  if (NSS_CMSContentInfo_SetContent_SignedData(cmsg.get(), cinfo, sigd.get())
       == SECSuccess) {
    Unused << sigd.release();
  }
  else {
    MOZ_LOG(gPIPNSSLog, LogLevel::Debug,
           ("nsNSSCertificate::ExportAsCMS - can't attach SignedData\n"));
    return NS_ERROR_FAILURE;
  }

  UniquePLArenaPool arena(PORT_NewArena(1024));
  if (!arena) {
    MOZ_LOG(gPIPNSSLog, LogLevel::Debug,
           ("nsNSSCertificate::ExportAsCMS - out of memory\n"));
    return NS_ERROR_OUT_OF_MEMORY;
  }

  SECItem certP7 = { siBuffer, nullptr, 0 };
  NSSCMSEncoderContext* ecx = NSS_CMSEncoder_Start(cmsg.get(), nullptr, nullptr,
                                                   &certP7, arena.get(), nullptr,
                                                   nullptr, nullptr, nullptr,
                                                   nullptr, nullptr);
  if (!ecx) {
    MOZ_LOG(gPIPNSSLog, LogLevel::Debug,
           ("nsNSSCertificate::ExportAsCMS - can't create encoder context\n"));
    return NS_ERROR_FAILURE;
  }

  if (NSS_CMSEncoder_Finish(ecx) != SECSuccess) {
    MOZ_LOG(gPIPNSSLog, LogLevel::Debug,
           ("nsNSSCertificate::ExportAsCMS - failed to add encoded data\n"));
    return NS_ERROR_FAILURE;
  }

  *aArray = (uint8_t*)moz_xmalloc(certP7.len);
  if (!*aArray)
    return NS_ERROR_OUT_OF_MEMORY;

  memcpy(*aArray, certP7.data, certP7.len);
  *aLength = certP7.len;
  return NS_OK;
}

CERTCertificate*
nsNSSCertificate::GetCert()
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return nullptr;

  return (mCert) ? CERT_DupCertificate(mCert.get()) : nullptr;
}

NS_IMETHODIMP
nsNSSCertificate::GetValidity(nsIX509CertValidity** aValidity)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  NS_ENSURE_ARG(aValidity);

  if (!mCert) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIX509CertValidity> validity = new nsX509CertValidity(mCert);
  validity.forget(aValidity);
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetASN1Structure(nsIASN1Object** aASN1Structure)
{
  NS_ENSURE_ARG_POINTER(aASN1Structure);
  if (!NS_IsMainThread()) {
    return NS_ERROR_NOT_SAME_THREAD;
  }
  return CreateASN1Struct(aASN1Structure);
}

NS_IMETHODIMP
nsNSSCertificate::Equals(nsIX509Cert* other, bool* result)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown())
    return NS_ERROR_NOT_AVAILABLE;

  NS_ENSURE_ARG(other);
  NS_ENSURE_ARG(result);

  UniqueCERTCertificate cert(other->GetCert());
  *result = (mCert.get() == cert.get());
  return NS_OK;
}

namespace mozilla {

// TODO(bug 1036065): It seems like we only construct CERTCertLists for the
// purpose of constructing nsNSSCertLists, so maybe we should change this
// function to output an nsNSSCertList instead.
SECStatus
ConstructCERTCertListFromReversedDERArray(
  const mozilla::pkix::DERArray& certArray,
  /*out*/ UniqueCERTCertList& certList)
{
  certList = UniqueCERTCertList(CERT_NewCertList());
  if (!certList) {
    return SECFailure;
  }

  CERTCertDBHandle* certDB(CERT_GetDefaultCertDB()); // non-owning

  size_t numCerts = certArray.GetLength();
  for (size_t i = 0; i < numCerts; ++i) {
    SECItem certDER(UnsafeMapInputToSECItem(*certArray.GetDER(i)));
    UniqueCERTCertificate cert(CERT_NewTempCertificate(certDB, &certDER,
                                                       nullptr, false, true));
    if (!cert) {
      return SECFailure;
    }
    // certArray is ordered with the root first, but we want the resulting
    // certList to have the root last.
    if (CERT_AddCertToListHead(certList.get(), cert.get()) != SECSuccess) {
      return SECFailure;
    }
    Unused << cert.release(); // cert is now owned by certList.
  }

  return SECSuccess;
}

} // namespace mozilla

NS_IMPL_CLASSINFO(nsNSSCertList,
                  nullptr,
                  // inferred from nsIX509Cert
                  nsIClassInfo::THREADSAFE,
                  NS_X509CERTLIST_CID)

NS_IMPL_ISUPPORTS_CI(nsNSSCertList,
                     nsIX509CertList,
                     nsISerializable)

nsNSSCertList::nsNSSCertList(UniqueCERTCertList certList,
                             const nsNSSShutDownPreventionLock& proofOfLock)
{
  if (certList) {
    mCertList = Move(certList);
  } else {
    mCertList = UniqueCERTCertList(CERT_NewCertList());
  }
}

nsNSSCertList::nsNSSCertList()
{
  mCertList = UniqueCERTCertList(CERT_NewCertList());
}

nsNSSCertList::~nsNSSCertList()
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return;
  }
  destructorSafeDestroyNSSReference();
  shutdown(ShutdownCalledFrom::Object);
}

void nsNSSCertList::virtualDestroyNSSReference()
{
  destructorSafeDestroyNSSReference();
}

void nsNSSCertList::destructorSafeDestroyNSSReference()
{
  mCertList = nullptr;
}

NS_IMETHODIMP
nsNSSCertList::AddCert(nsIX509Cert* aCert)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  CERTCertificate* cert = aCert->GetCert();
  if (!cert) {
    NS_ERROR("Somehow got nullptr for mCertificate in nsNSSCertificate.");
    return NS_ERROR_FAILURE;
  }

  if (!mCertList) {
    NS_ERROR("Somehow got nullptr for mCertList in nsNSSCertList.");
    return NS_ERROR_FAILURE;
  }
  // XXX: check return value!
  CERT_AddCertToListTail(mCertList.get(), cert);
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertList::DeleteCert(nsIX509Cert* aCert)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  CERTCertificate* cert = aCert->GetCert();
  CERTCertListNode* node;

  if (!cert) {
    NS_ERROR("Somehow got nullptr for mCertificate in nsNSSCertificate.");
    return NS_ERROR_FAILURE;
  }

  if (!mCertList) {
    NS_ERROR("Somehow got nullptr for mCertList in nsNSSCertList.");
    return NS_ERROR_FAILURE;
  }

  for (node = CERT_LIST_HEAD(mCertList.get());
       !CERT_LIST_END(node, mCertList.get()); node = CERT_LIST_NEXT(node)) {
    if (node->cert == cert) {
	CERT_RemoveCertListNode(node);
        return NS_OK;
    }
  }
  return NS_OK; // XXX Should we fail if we couldn't find it?
}

UniqueCERTCertList
nsNSSCertList::DupCertList(const UniqueCERTCertList& certList,
                           const nsNSSShutDownPreventionLock& /*proofOfLock*/)
{
  if (!certList) {
    return nullptr;
  }

  UniqueCERTCertList newList(CERT_NewCertList());
  if (!newList) {
    return nullptr;
  }

  for (CERTCertListNode* node = CERT_LIST_HEAD(certList);
       !CERT_LIST_END(node, certList);
       node = CERT_LIST_NEXT(node)) {
    UniqueCERTCertificate cert(CERT_DupCertificate(node->cert));
    if (!cert) {
      return nullptr;
    }

    if (CERT_AddCertToListTail(newList.get(), cert.get()) != SECSuccess) {
      return nullptr;
    }

    Unused << cert.release(); // Ownership transferred to the cert list.
  }
  return newList;
}

CERTCertList*
nsNSSCertList::GetRawCertList()
{
  // This function should only be called after acquiring a
  // nsNSSShutDownPreventionLock. It's difficult to enforce this in code since
  // this is an implementation of an XPCOM interface function (albeit a
  // C++-only one), so we acquire the (reentrant) lock and check for shutdown
  // ourselves here. At the moment it appears that only nsCertTree uses this
  // function. When that gets removed and replaced by a more reasonable
  // implementation of the certificate manager, this function can be removed.
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return nullptr;
  }
  return mCertList.get();
}

NS_IMETHODIMP
nsNSSCertList::Write(nsIObjectOutputStream* aStream)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_ENSURE_STATE(mCertList);
  nsresult rv = NS_OK;

  // First, enumerate the certs to get the length of the list
  uint32_t certListLen = 0;
  CERTCertListNode* node = nullptr;
  for (node = CERT_LIST_HEAD(mCertList);
       !CERT_LIST_END(node, mCertList);
       node = CERT_LIST_NEXT(node), ++certListLen) {
  }

  // Write the length of the list
  rv = aStream->Write32(certListLen);

  // Repeat the loop, and serialize each certificate
  node = nullptr;
  for (node = CERT_LIST_HEAD(mCertList);
       !CERT_LIST_END(node, mCertList);
       node = CERT_LIST_NEXT(node))
  {
    nsCOMPtr<nsIX509Cert> cert = nsNSSCertificate::Create(node->cert);
    if (!cert) {
      rv = NS_ERROR_OUT_OF_MEMORY;
      break;
    }

    nsCOMPtr<nsISerializable> serializableCert = do_QueryInterface(cert);
    rv = aStream->WriteCompoundObject(serializableCert, NS_GET_IID(nsIX509Cert), true);
    if (NS_FAILED(rv)) {
      break;
    }
  }

  return rv;
}

NS_IMETHODIMP
nsNSSCertList::Read(nsIObjectInputStream* aStream)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_ENSURE_STATE(mCertList);
  nsresult rv = NS_OK;

  uint32_t certListLen;
  rv = aStream->Read32(&certListLen);
  if (NS_FAILED(rv)) {
    return rv;
  }

  for(uint32_t i = 0; i < certListLen; ++i) {
    nsCOMPtr<nsISupports> certSupports;
    rv = aStream->ReadObject(true, getter_AddRefs(certSupports));
    if (NS_FAILED(rv)) {
      break;
    }

    nsCOMPtr<nsIX509Cert> cert = do_QueryInterface(certSupports);
    rv = AddCert(cert);
    if (NS_FAILED(rv)) {
      break;
    }
  }

  return rv;
}

NS_IMETHODIMP
nsNSSCertList::GetEnumerator(nsISimpleEnumerator** _retval)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  if (!mCertList) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsISimpleEnumerator> enumerator =
    new nsNSSCertListEnumerator(mCertList, locker);

  enumerator.forget(_retval);
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertList::Equals(nsIX509CertList* other, bool* result)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_ENSURE_ARG(result);
  *result = true;

  nsresult rv;

  nsCOMPtr<nsISimpleEnumerator> selfEnumerator;
  rv = GetEnumerator(getter_AddRefs(selfEnumerator));
  if (NS_FAILED(rv)) {
    return rv;
  }

  nsCOMPtr<nsISimpleEnumerator> otherEnumerator;
  rv = other->GetEnumerator(getter_AddRefs(otherEnumerator));
  if (NS_FAILED(rv)) {
    return rv;
  }

  nsCOMPtr<nsISupports> selfSupports;
  nsCOMPtr<nsISupports> otherSupports;
  while (NS_SUCCEEDED(selfEnumerator->GetNext(getter_AddRefs(selfSupports)))) {
    if (NS_SUCCEEDED(otherEnumerator->GetNext(getter_AddRefs(otherSupports)))) {
      nsCOMPtr<nsIX509Cert> selfCert = do_QueryInterface(selfSupports);
      nsCOMPtr<nsIX509Cert> otherCert = do_QueryInterface(otherSupports);

      bool certsEqual = false;
      rv = selfCert->Equals(otherCert, &certsEqual);
      if (NS_FAILED(rv)) {
        return rv;
      }
      if (!certsEqual) {
        *result = false;
        break;
      }
    } else {
      // other is shorter than self
      *result = false;
      break;
    }
  }

  // Make sure self is the same length as other
  bool otherHasMore = false;
  rv = otherEnumerator->HasMoreElements(&otherHasMore);
  if (NS_FAILED(rv)) {
    return rv;
  }
  if (otherHasMore) {
    *result = false;
  }

  return NS_OK;
}

NS_IMPL_ISUPPORTS(nsNSSCertListEnumerator, nsISimpleEnumerator)

nsNSSCertListEnumerator::nsNSSCertListEnumerator(
  const UniqueCERTCertList& certList,
  const nsNSSShutDownPreventionLock& proofOfLock)
{
  MOZ_ASSERT(certList);
  mCertList = nsNSSCertList::DupCertList(certList, proofOfLock);
}

nsNSSCertListEnumerator::~nsNSSCertListEnumerator()
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return;
  }
  destructorSafeDestroyNSSReference();
  shutdown(ShutdownCalledFrom::Object);
}

void nsNSSCertListEnumerator::virtualDestroyNSSReference()
{
  destructorSafeDestroyNSSReference();
}

void nsNSSCertListEnumerator::destructorSafeDestroyNSSReference()
{
  mCertList = nullptr;
}

NS_IMETHODIMP
nsNSSCertListEnumerator::HasMoreElements(bool* _retval)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_ENSURE_TRUE(mCertList, NS_ERROR_FAILURE);

  *_retval = !CERT_LIST_EMPTY(mCertList);
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertListEnumerator::GetNext(nsISupports** _retval)
{
  nsNSSShutDownPreventionLock locker;
  if (isAlreadyShutDown()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  NS_ENSURE_TRUE(mCertList, NS_ERROR_FAILURE);

  CERTCertListNode* node = CERT_LIST_HEAD(mCertList);
  if (CERT_LIST_END(node, mCertList)) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIX509Cert> nssCert = nsNSSCertificate::Create(node->cert);
  if (!nssCert) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  nssCert.forget(_retval);

  CERT_RemoveCertListNode(node);
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::Write(nsIObjectOutputStream* aStream)
{
  NS_ENSURE_STATE(mCert);
  // This field used to be the cached EV status, but it is no longer necessary.
  nsresult rv = aStream->Write32(0);
  if (NS_FAILED(rv)) {
    return rv;
  }
  rv = aStream->Write32(mCert->derCert.len);
  if (NS_FAILED(rv)) {
    return rv;
  }
  return aStream->WriteByteArray(mCert->derCert.data, mCert->derCert.len);
}

NS_IMETHODIMP
nsNSSCertificate::Read(nsIObjectInputStream* aStream)
{
  NS_ENSURE_STATE(!mCert);

  // This field is no longer used.
  uint32_t unusedCachedEVStatus;
  nsresult rv = aStream->Read32(&unusedCachedEVStatus);
  if (NS_FAILED(rv)) {
    return rv;
  }

  uint32_t len;
  rv = aStream->Read32(&len);
  if (NS_FAILED(rv)) {
    return rv;
  }

  nsXPIDLCString str;
  rv = aStream->ReadBytes(len, getter_Copies(str));
  if (NS_FAILED(rv)) {
    return rv;
  }

  if (!InitFromDER(const_cast<char*>(str.get()), len)) {
    return NS_ERROR_UNEXPECTED;
  }

  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetInterfaces(uint32_t* count, nsIID*** array)
{
  *count = 0;
  *array = nullptr;
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetScriptableHelper(nsIXPCScriptable** _retval)
{
  *_retval = nullptr;
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetContractID(char** aContractID)
{
  *aContractID = nullptr;
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetClassDescription(char** aClassDescription)
{
  *aClassDescription = nullptr;
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetClassID(nsCID** aClassID)
{
  *aClassID = (nsCID*) moz_xmalloc(sizeof(nsCID));
  if (!*aClassID)
    return NS_ERROR_OUT_OF_MEMORY;
  return GetClassIDNoAlloc(*aClassID);
}

NS_IMETHODIMP
nsNSSCertificate::GetFlags(uint32_t* aFlags)
{
  *aFlags = nsIClassInfo::THREADSAFE;
  return NS_OK;
}

NS_IMETHODIMP
nsNSSCertificate::GetClassIDNoAlloc(nsCID* aClassIDNoAlloc)
{
  static NS_DEFINE_CID(kNSSCertificateCID, NS_X509CERT_CID);

  *aClassIDNoAlloc = kNSSCertificateCID;
  return NS_OK;
}
