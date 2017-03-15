/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ModuleUtils.h"
#include "nsASN1Tree.h"
#include "nsNSSDialogs.h"

NS_GENERIC_FACTORY_CONSTRUCTOR_INIT(nsNSSDialogs, Init)
NS_GENERIC_FACTORY_CONSTRUCTOR(nsNSSASN1Tree)

NS_DEFINE_NAMED_CID(NS_NSSDIALOGS_CID);
NS_DEFINE_NAMED_CID(NS_NSSASN1OUTINER_CID);


static const mozilla::Module::CIDEntry kPKICIDs[] = {
  { &kNS_NSSDIALOGS_CID, false, nullptr, nsNSSDialogsConstructor },
  { &kNS_NSSASN1OUTINER_CID, false, nullptr, nsNSSASN1TreeConstructor },
  { nullptr }
};

static const mozilla::Module::ContractIDEntry kPKIContracts[] = {
  { NS_TOKENPASSWORDSDIALOG_CONTRACTID, &kNS_NSSDIALOGS_CID },
  { NS_CERTIFICATEDIALOGS_CONTRACTID, &kNS_NSSDIALOGS_CID },
  { NS_CLIENTAUTHDIALOGS_CONTRACTID, &kNS_NSSDIALOGS_CID },
  { NS_TOKENDIALOGS_CONTRACTID, &kNS_NSSDIALOGS_CID },
  { NS_GENERATINGKEYPAIRINFODIALOGS_CONTRACTID, &kNS_NSSDIALOGS_CID },
  { NS_ASN1TREE_CONTRACTID, &kNS_NSSASN1OUTINER_CID },
  { nullptr }
};

static const mozilla::Module kPKIModule = {
  mozilla::Module::kVersion,
  kPKICIDs,
  kPKIContracts
};

NSMODULE_DEFN(PKI) = &kPKIModule;
