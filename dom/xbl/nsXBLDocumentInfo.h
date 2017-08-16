/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsXBLDocumentInfo_h__
#define nsXBLDocumentInfo_h__

#include "mozilla/Attributes.h"
#include "nsCOMPtr.h"
#include "nsAutoPtr.h"
#include "nsWeakReference.h"
#include "nsIDocument.h"
#include "nsCycleCollectionParticipant.h"

class nsXBLPrototypeBinding;

class nsXBLDocumentInfo final : public nsSupportsWeakReference
{
public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS

  explicit nsXBLDocumentInfo(nsIDocument* aDocument);

  nsIDocument* GetDocument() const { return mDocument; }

  bool GetScriptAccess() const { return mScriptAccess; }

  nsIURI* DocumentURI() { return mDocument->GetDocumentURI(); }

  nsXBLPrototypeBinding* GetPrototypeBinding(const nsACString& aRef);
  nsresult SetPrototypeBinding(const nsACString& aRef,
                               nsXBLPrototypeBinding* aBinding);

  // This removes the binding without deleting it
  void RemovePrototypeBinding(const nsACString& aRef);

  nsresult WritePrototypeBindings();

  void SetFirstPrototypeBinding(nsXBLPrototypeBinding* aBinding);

  void FlushSkinStylesheets();

  bool IsChrome() { return mIsChrome; }

  void MarkInCCGeneration(uint32_t aGeneration);

  static nsresult ReadPrototypeBindings(nsIURI* aURI, nsXBLDocumentInfo** aDocInfo,
                                        nsIDocument* aBoundDocument);

  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(nsXBLDocumentInfo)

private:
  virtual ~nsXBLDocumentInfo();

  nsCOMPtr<nsIDocument> mDocument;
  bool mScriptAccess;
  bool mIsChrome;
  // the binding table owns each nsXBLPrototypeBinding
  nsAutoPtr<nsClassHashtable<nsCStringHashKey, nsXBLPrototypeBinding>> mBindingTable;

  // non-owning pointer to the first binding in the table
  nsXBLPrototypeBinding* mFirstBinding;
};

#ifdef DEBUG
void AssertInCompilationScope();
#else
inline void AssertInCompilationScope() {}
#endif

#endif
