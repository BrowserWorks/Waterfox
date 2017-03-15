/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/* $Id: nsPKCS12Blob.h,v 1.16 2006/04/12 15:43:32 benjamin%smedbergs.us Exp $ */

#ifndef _NS_PKCS12BLOB_H_
#define _NS_PKCS12BLOB_H_

#include "nsCOMPtr.h"
#include "nsString.h"
#include "nsIFile.h"
#include "nsIPK11TokenDB.h"
#include "nsNSSHelper.h"
#include "nsIPK11Token.h"
#include "nsIMutableArray.h"

#include "nss.h"

#include "pkcs12.h"
#include "p12plcy.h"

class nsIX509Cert;

//
// nsPKCS12Blob
//
// Class for importing/exporting PKCS#12 blobs
//
class nsPKCS12Blob : public nsNSSShutDownObject
{
public:
  nsPKCS12Blob();
  virtual ~nsPKCS12Blob();

  // Nothing to release.
  virtual void virtualDestroyNSSReference() override {}

  // Set the token to use (default is internal)
  nsresult SetToken(nsIPK11Token *token);

  // PKCS#12 Import
  nsresult ImportFromFile(nsIFile *file);

  // PKCS#12 Export
  nsresult ExportToFile(nsIFile *file, nsIX509Cert **certs, int numCerts);

private:

  nsCOMPtr<nsIPK11Token>          mToken;
  nsCOMPtr<nsIMutableArray>       mCertArray;
  nsCOMPtr<nsIInterfaceRequestor> mUIContext;

  // local helper functions
  nsresult getPKCS12FilePassword(SECItem *);
  nsresult newPKCS12FilePassword(SECItem *);
  nsresult inputToDecoder(SEC_PKCS12DecoderContext *, nsIFile *);
  nsresult unicodeToItem(const char16_t *, SECItem *);
  void handleError(int myerr = 0);

  // RetryReason and ImportMode are used when importing a PKCS12 file.
  // There are two reasons that cause us to retry:
  // - When the password entered by the user is incorrect.
  //   The user will be prompted to try again.
  // - When the user entered a zero length password.
  //   An empty password should be represented as an empty
  //   string (a SECItem that contains a single terminating
  //   null UTF16 character), but some applications use a
  //   zero length SECItem.
  //   We try both variations, zero length item and empty string,
  //   without giving a user prompt when trying the different empty password flavors.
  
  enum RetryReason { rr_do_not_retry, rr_bad_password, rr_auto_retry_empty_password_flavors };
  enum ImportMode { im_standard_prompt, im_try_zero_length_secitem };
  
  nsresult ImportFromFileHelper(nsIFile *file, ImportMode aImportMode, RetryReason &aWantRetry);

  // NSPR file I/O for export file
  PRFileDesc *mTmpFile;

  bool        mTokenSet;

  static SECItem * nickname_collision(SECItem *, PRBool *, void *);
  static void write_export_file(void *arg, const char *buf, unsigned long len);

};

#endif /* _NS_PKCS12BLOB_H_ */
