/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ModuleUtils.h"
#include "mozilla/TransactionManager.h"
#include "nsBaseCommandController.h"
#include "nsCommonBaseCID.h"
#include "nsComponentManagerExtra.h"
#include "nsSyncStreamListener.h"
#include "nsSAXXMLReader.h"  // Sax parser.

using mozilla::TransactionManager;

NS_GENERIC_FACTORY_CONSTRUCTOR(nsComponentManagerExtra)
NS_DEFINE_NAMED_CID(NS_COMPONENTMANAGEREXTRA_CID);

NS_GENERIC_FACTORY_CONSTRUCTOR(nsBaseCommandController)
NS_DEFINE_NAMED_CID(NS_BASECOMMANDCONTROLLER_CID);

NS_GENERIC_FACTORY_CONSTRUCTOR(TransactionManager)
NS_DEFINE_NAMED_CID(NS_TRANSACTIONMANAGER_CID);

NS_DEFINE_NAMED_CID(NS_SYNCSTREAMLISTENER_CID);

NS_GENERIC_FACTORY_CONSTRUCTOR(nsSAXXMLReader)
NS_DEFINE_NAMED_CID(NS_SAXXMLREADER_CID);

static nsresult
CreateNewSyncStreamListener(nsISupports *aOuter, REFNSIID aIID, void **aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = nullptr;

  if (aOuter) {
    return NS_ERROR_NO_AGGREGATION;
  }

  RefPtr<nsISyncStreamListener> inst = nsSyncStreamListener::Create();
  if (!inst)
    return NS_ERROR_NULL_POINTER;

  return inst->QueryInterface(aIID, aResult);
}

const mozilla::Module::CIDEntry kCommonCIDs[] = {
  { &kNS_COMPONENTMANAGEREXTRA_CID, false, nullptr, nsComponentManagerExtraConstructor },
  { &kNS_BASECOMMANDCONTROLLER_CID, false, nullptr, nsBaseCommandControllerConstructor },
  { &kNS_TRANSACTIONMANAGER_CID, false, nullptr, TransactionManagerConstructor },
  { &kNS_SYNCSTREAMLISTENER_CID, false, nullptr, CreateNewSyncStreamListener },
  { &kNS_SAXXMLREADER_CID, false, nullptr, nsSAXXMLReaderConstructor },
  { nullptr }
};

const mozilla::Module::ContractIDEntry kCommonContracts[] = {
  { NS_COMPONENTMANAGEREXTRA_CONTRACTID, &kNS_COMPONENTMANAGEREXTRA_CID },
  { NS_BASECOMMANDCONTROLLER_CONTRACTID, &kNS_BASECOMMANDCONTROLLER_CID },
  { NS_TRANSACTIONMANAGER_CONTRACTID, &kNS_TRANSACTIONMANAGER_CID },
  { NS_SYNCSTREAMLISTENER_CONTRACTID, &kNS_SYNCSTREAMLISTENER_CID },
  { NS_SAXXMLREADER_CONTRACTID, &kNS_SAXXMLREADER_CID },
  { nullptr }
};

static const mozilla::Module kCommonModule = {
  mozilla::Module::kVersion,
  kCommonCIDs,
  kCommonContracts,
  nullptr,
  nullptr,
  nullptr,
  nullptr
};

NSMODULE_DEFN(nsCommonModule) = &kCommonModule;
