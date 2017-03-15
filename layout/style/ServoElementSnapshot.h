/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_ServoElementSnapshot_h
#define mozilla_ServoElementSnapshot_h

#include "mozilla/EventStates.h"
#include "mozilla/TypedEnumBits.h"
#include "mozilla/dom/BorrowedAttrInfo.h"
#include "nsAttrName.h"
#include "nsAttrValue.h"
#include "nsChangeHint.h"
#include "nsIAtom.h"

namespace mozilla {

namespace dom {
class Element;
} // namespace dom

/**
 * A structure representing a single attribute name and value.
 *
 * This is pretty similar to the private nsAttrAndChildArray::InternalAttr.
 */
struct ServoAttrSnapshot
{
  nsAttrName mName;
  nsAttrValue mValue;

  ServoAttrSnapshot(const nsAttrName& aName, const nsAttrValue& aValue)
    : mName(aName)
    , mValue(aValue)
  {
  }
};

/**
 * A bitflags enum class used to determine what data does a ServoElementSnapshot
 * contains.
 */
enum class ServoElementSnapshotFlags : uint8_t
{
  State = 1 << 0,
  Attributes = 1 << 1,
  All = State | Attributes
};

MOZ_MAKE_ENUM_CLASS_BITWISE_OPERATORS(ServoElementSnapshotFlags)

/**
 * This class holds all non-tree-structural state of an element that might be
 * used for selector matching eventually.
 *
 * This means the attributes, and the element state, such as :hover, :active,
 * etc...
 */
class ServoElementSnapshot
{
  typedef dom::BorrowedAttrInfo BorrowedAttrInfo;
  typedef dom::Element Element;
  typedef EventStates::ServoType ServoStateType;

public:
  typedef ServoElementSnapshotFlags Flags;

  explicit ServoElementSnapshot(Element* aElement);

  bool HasAttrs() { return HasAny(Flags::Attributes); }

  bool HasState() { return HasAny(Flags::State); }

  /**
   * Captures the given state (if not previously captured).
   */
  void AddState(EventStates aState)
  {
    if (!HasAny(Flags::State)) {
      mState = aState.ServoValue();
      mContains |= Flags::State;
    }
  }

  /**
   * Captures the given element attributes (if not previously captured).
   */
  void AddAttrs(Element* aElement);

  void AddExplicitChangeHint(nsChangeHint aMinChangeHint)
  {
    mExplicitChangeHint |= aMinChangeHint;
  }

  void AddExplicitRestyleHint(nsRestyleHint aRestyleHint)
  {
    mExplicitRestyleHint |= aRestyleHint;
  }

  nsRestyleHint ExplicitRestyleHint() { return mExplicitRestyleHint; }

  nsChangeHint ExplicitChangeHint() { return mExplicitChangeHint; }

  /**
   * Needed methods for attribute matching.
   */
  BorrowedAttrInfo GetAttrInfoAt(uint32_t aIndex) const
  {
    if (aIndex >= mAttrs.Length()) {
      return BorrowedAttrInfo(nullptr, nullptr);
    }
    return BorrowedAttrInfo(&mAttrs[aIndex].mName, &mAttrs[aIndex].mValue);
  }

  const nsAttrValue* GetParsedAttr(nsIAtom* aLocalName) const
  {
    return GetParsedAttr(aLocalName, kNameSpaceID_None);
  }

  const nsAttrValue* GetParsedAttr(nsIAtom* aLocalName,
                                   int32_t aNamespaceID) const
  {
    uint32_t i, len = mAttrs.Length();
    if (aNamespaceID == kNameSpaceID_None) {
      // This should be the common case so lets make an optimized loop
      for (i = 0; i < len; ++i) {
        if (mAttrs[i].mName.Equals(aLocalName)) {
          return &mAttrs[i].mValue;
        }
      }

      return nullptr;
    }

    for (i = 0; i < len; ++i) {
      if (mAttrs[i].mName.Equals(aLocalName, aNamespaceID)) {
        return &mAttrs[i].mValue;
      }
    }

    return nullptr;
  }

  bool IsInChromeDocument() const
  {
    return mIsInChromeDocument;
  }

  bool HasAny(Flags aFlags) { return bool(mContains & aFlags); }

private:
  // TODO: Profile, a 1 or 2 element AutoTArray could be worth it, given we know
  // we're dealing with attribute changes when we take snapshots of attributes,
  // though it can be wasted space if we deal with a lot of state-only
  // snapshots.
  Flags mContains;
  nsTArray<ServoAttrSnapshot> mAttrs;
  ServoStateType mState;
  nsRestyleHint mExplicitRestyleHint;
  nsChangeHint mExplicitChangeHint;
  bool mIsHTMLElementInHTMLDocument;
  bool mIsInChromeDocument;
};

} // namespace mozilla

#endif
