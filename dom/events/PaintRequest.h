/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_PaintRequest_h_
#define mozilla_dom_PaintRequest_h_

#include "nsIDOMPaintRequest.h"
#include "nsPresContext.h"
#include "nsIDOMEvent.h"
#include "mozilla/Attributes.h"
#include "nsWrapperCache.h"

namespace mozilla {
namespace dom {

class DOMRect;

class PaintRequest final : public nsIDOMPaintRequest
                         , public nsWrapperCache
{
public:
  explicit PaintRequest(nsIDOMEvent* aParent)
    : mParent(aParent)
  {
  }

  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(PaintRequest)
  NS_DECL_NSIDOMPAINTREQUEST

  virtual JSObject* WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;

  nsIDOMEvent* GetParentObject() const
  {
    return mParent;
  }

  already_AddRefed<DOMRect> ClientRect();
  void GetReason(nsAString& aResult) const
  {
    aResult.AssignLiteral("repaint");
  }

  void SetRequest(const nsRect& aRequest)
  { mRequest = aRequest; }

private:
  ~PaintRequest() {}

  nsCOMPtr<nsIDOMEvent> mParent;
  nsRect mRequest;
};

class PaintRequestList final : public nsISupports,
                               public nsWrapperCache
{
public:
  explicit PaintRequestList(nsIDOMEvent *aParent) : mParent(aParent)
  {
  }

  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(PaintRequestList)

  virtual JSObject* WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;
  nsISupports* GetParentObject()
  {
    return mParent;
  }

  void Append(PaintRequest* aElement)
  {
    mArray.AppendElement(aElement);
  }

  uint32_t Length()
  {
    return mArray.Length();
  }

  PaintRequest* Item(uint32_t aIndex)
  {
    return mArray.SafeElementAt(aIndex);
  }
  PaintRequest* IndexedGetter(uint32_t aIndex, bool& aFound)
  {
    aFound = aIndex < mArray.Length();
    if (!aFound) {
      return nullptr;
    }
    return mArray.ElementAt(aIndex);
  }

private:
  ~PaintRequestList() {}

  nsTArray< RefPtr<PaintRequest> > mArray;
  nsCOMPtr<nsIDOMEvent> mParent;
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_PaintRequest_h_
