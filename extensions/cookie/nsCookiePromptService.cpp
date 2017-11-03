/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#include "nsCookiePromptService.h"
#include "nsICookie.h"
#include "nsICookieAcceptDialog.h"
#include "nsIDOMWindow.h"
#include "nsPIDOMWindow.h"
#include "nsIWindowWatcher.h"
#include "nsIServiceManager.h"
#include "nsString.h"
#include "nsIDialogParamBlock.h"
#include "nsIMutableArray.h"
#include "mozilla/dom/ScriptSettings.h"

/****************************************************************
 ************************ nsCookiePromptService *****************
 ****************************************************************/

NS_IMPL_ISUPPORTS(nsCookiePromptService, nsICookiePromptService)

nsCookiePromptService::nsCookiePromptService() {
}

nsCookiePromptService::~nsCookiePromptService() {
}

NS_IMETHODIMP
nsCookiePromptService::CookieDialog(mozIDOMWindowProxy *aParent,
                                    nsICookie *aCookie,
                                    const nsACString &aHostname,
                                    int32_t aCookiesFromHost,
                                    bool aChangingCookie,
                                    bool *aRememberDecision,
                                    int32_t *aAccept)
{
  nsresult rv;

  nsCOMPtr<nsIDialogParamBlock> block = do_CreateInstance(NS_DIALOGPARAMBLOCK_CONTRACTID,&rv);
  if (NS_FAILED(rv)) return rv;

  block->SetInt(nsICookieAcceptDialog::ACCEPT_COOKIE, 1);
  block->SetString(nsICookieAcceptDialog::HOSTNAME, NS_ConvertUTF8toUTF16(aHostname).get());
  block->SetInt(nsICookieAcceptDialog::COOKIESFROMHOST, aCookiesFromHost);
  block->SetInt(nsICookieAcceptDialog::CHANGINGCOOKIE, aChangingCookie ? 1 : 0);
  
  nsCOMPtr<nsIMutableArray> objects =
    do_CreateInstance(NS_ARRAY_CONTRACTID, &rv);
  if (NS_FAILED(rv)) return rv;

  rv = objects->AppendElement(aCookie, false);
  if (NS_FAILED(rv)) return rv;

  block->SetObjects(objects);

  nsCOMPtr<nsIWindowWatcher> wwatcher = do_GetService(NS_WINDOWWATCHER_CONTRACTID, &rv);
  if (NS_FAILED(rv)) return rv;

  nsCOMPtr<nsISupports> arguments = do_QueryInterface(block);

  nsCOMPtr<mozIDOMWindowProxy> parent(aParent);
  if (!parent) // if no parent provided, consult the window watcher:
    wwatcher->GetActiveWindow(getter_AddRefs(parent));

  if (parent) {
    auto* privateParent = nsPIDOMWindowOuter::From(parent);
    if (privateParent)
      privateParent = privateParent->GetPrivateRoot();
    parent = privateParent;
  }

  // We're opening a chrome window and passing in a nsIDialogParamBlock. Setting
  // the nsIDialogParamBlock as the .arguments property on the chrome window
  // requires system principals on the stack, so we use an AutoNoJSAPI for that.
  mozilla::dom::AutoNoJSAPI nojsapi;

  // The cookie dialog will be modal for the root chrome window rather than the
  // tab containing the permission-requesting page.  This removes confusion
  // about which monitor is displaying the dialog (see bug 470356), but also
  // avoids unwanted tab switches (see bug 405239).
  nsCOMPtr<mozIDOMWindowProxy> dialog;
  rv = wwatcher->OpenWindow(parent, "chrome://cookie/content/cookieAcceptDialog.xul", "_blank",
                            "centerscreen,chrome,modal,titlebar", arguments,
                            getter_AddRefs(dialog));

  if (NS_FAILED(rv)) return rv;

  // get back output parameters
  int32_t tempValue;
  block->GetInt(nsICookieAcceptDialog::ACCEPT_COOKIE, &tempValue);
  *aAccept = tempValue;
  
  // GetInt returns a int32_t; we need to sanitize it into bool
  block->GetInt(nsICookieAcceptDialog::REMEMBER_DECISION, &tempValue);
  *aRememberDecision = (tempValue == 1);

  return rv;
}

