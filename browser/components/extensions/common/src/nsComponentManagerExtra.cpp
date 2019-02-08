/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsIServiceManager.h"
#include "nsCommonBaseCID.h"
#include "nsComponentManagerExtra.h"
#include "mozilla/Services.h"
#include "nsXULAppAPI.h"

static already_AddRefed<nsIFile>
CloneAndAppend(nsIFile* aBase, const nsACString& aAppend)
{
  nsCOMPtr<nsIFile> f;
  aBase->Clone(getter_AddRefs(f));
  if (!f) {
    return nullptr;
  }

  f->AppendNative(aAppend);
  return f.forget();
}

NS_IMPL_ISUPPORTS(nsComponentManagerExtra,
                  nsIComponentManagerExtra)

NS_IMETHODIMP nsComponentManagerExtra::AddLegacyExtensionManifestLocation(nsIFile *aLocation)
{
  nsString path;
  nsresult rv = aLocation->GetPath(path);
  if (NS_FAILED(rv)) {
    return rv;
  }

  if (Substring(path, path.Length() - 4).EqualsLiteral(".xpi")) {
    return XRE_AddJarManifestLocation(NS_EXTENSION_LOCATION, aLocation);
  }

  nsCOMPtr<nsIFile> manifest =
    CloneAndAppend(aLocation, NS_LITERAL_CSTRING("chrome.manifest"));
  return XRE_AddManifestLocation(NS_EXTENSION_LOCATION, manifest);
}

nsComponentManagerExtra::~nsComponentManagerExtra()
{
}
