/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef NS_SMILTARGETIDENTIFIER_H_
#define NS_SMILTARGETIDENTIFIER_H_

#include "mozilla/dom/Element.h"

/**
 * Struct: nsSMILTargetIdentifier
 *
 * Tuple of: { Animated Element, Attribute Name }
 *
 * Used in nsSMILAnimationController as hash key for mapping an animation
 * target to the nsSMILCompositor for that target.
 *
 * NOTE: Need a nsRefPtr for the element & attribute name, because
 * nsSMILAnimationController retain its hash table for one sample into the
 * future, and we need to make sure their target isn't deleted in that time.
 */

struct nsSMILTargetIdentifier
{
  nsSMILTargetIdentifier()
    : mElement(nullptr), mAttributeName(nullptr),
      mAttributeNamespaceID(kNameSpaceID_Unknown) {}

  inline bool Equals(const nsSMILTargetIdentifier& aOther) const
  {
    return (aOther.mElement              == mElement &&
            aOther.mAttributeName        == mAttributeName &&
            aOther.mAttributeNamespaceID == mAttributeNamespaceID);
  }

  RefPtr<mozilla::dom::Element> mElement;
  RefPtr<nsIAtom>               mAttributeName;
  int32_t                       mAttributeNamespaceID;
};

/**
 * Class: nsSMILWeakTargetIdentifier
 *
 * Version of the above struct that uses non-owning pointers.  These are kept
 * private, to ensure that they aren't ever dereferenced (or used at all,
 * outside of Equals()).
 *
 * This is solely for comparisons to determine if a target has changed
 * from one sample to the next.
 */
class nsSMILWeakTargetIdentifier
{
public:
  // Trivial constructor
  nsSMILWeakTargetIdentifier()
    : mElement(nullptr), mAttributeName(nullptr) {}

  // Allow us to update a weak identifier to match a given non-weak identifier
  nsSMILWeakTargetIdentifier&
    operator=(const nsSMILTargetIdentifier& aOther)
  {
    mElement = aOther.mElement;
    mAttributeName = aOther.mAttributeName;
    return *this;
  }

  // Allow for comparison vs. non-weak identifier
  inline bool Equals(const nsSMILTargetIdentifier& aOther) const
  {
    return (aOther.mElement       == mElement &&
            aOther.mAttributeName == mAttributeName);
  }

private:
  const nsIContent* mElement;
  const nsIAtom*    mAttributeName;
};

#endif // NS_SMILTARGETIDENTIFIER_H_
