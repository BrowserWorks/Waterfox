/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef NS_SMILCOMPOSITOR_H_
#define NS_SMILCOMPOSITOR_H_

#include "mozilla/Move.h"
#include "mozilla/UniquePtr.h"
#include "nsTHashtable.h"
#include "nsString.h"
#include "nsSMILAnimationFunction.h"
#include "nsSMILTargetIdentifier.h"
#include "nsSMILCompositorTable.h"
#include "PLDHashTable.h"

//----------------------------------------------------------------------
// nsSMILCompositor
//
// Performs the composition of the animation sandwich by combining the results
// of a series animation functions according to the rules of SMIL composition
// including prioritising animations.

class nsSMILCompositor : public PLDHashEntryHdr
{
public:
  typedef nsSMILTargetIdentifier KeyType;
  typedef const KeyType& KeyTypeRef;
  typedef const KeyType* KeyTypePointer;

  explicit nsSMILCompositor(KeyTypePointer aKey)
   : mKey(*aKey),
     mForceCompositing(false)
  { }
  nsSMILCompositor(const nsSMILCompositor& toCopy)
    : mKey(toCopy.mKey),
      mAnimationFunctions(toCopy.mAnimationFunctions),
      mForceCompositing(false)
  { }
  ~nsSMILCompositor() { }

  // PLDHashEntryHdr methods
  KeyTypeRef GetKey() const { return mKey; }
  bool KeyEquals(KeyTypePointer aKey) const;
  static KeyTypePointer KeyToPointer(KeyTypeRef aKey) { return &aKey; }
  static PLDHashNumber HashKey(KeyTypePointer aKey);
  enum { ALLOW_MEMMOVE = false };

  // Adds the given animation function to this Compositor's list of functions
  void AddAnimationFunction(nsSMILAnimationFunction* aFunc);

  // Composes the attribute's current value with the list of animation
  // functions, and assigns the resulting value to this compositor's target
  // attribute. If a change is made that might produce style updates,
  // aMightHavePendingStyleUpdates is set to true. Otherwise it is not modified.
  void ComposeAttribute(bool& aMightHavePendingStyleUpdates);

  // Clears animation effects on my target attribute
  void ClearAnimationEffects();

  // Cycle-collection support
  void Traverse(nsCycleCollectionTraversalCallback* aCallback);

  // Toggles a bit that will force us to composite (bypassing early-return
  // optimizations) when we hit ComposeAttribute.
  void ToggleForceCompositing() { mForceCompositing = true; }

  // Transfers |aOther|'s mCachedBaseValue to |this|
  void StealCachedBaseValue(nsSMILCompositor* aOther) {
    mCachedBaseValue = mozilla::Move(aOther->mCachedBaseValue);
  }

 private:
  // Create a nsISMILAttr for my target, on the heap.
  //
  // @param aBaseStyleContext  An optional style context which, if set, will be
  //                           used when fetching the base style.
  mozilla::UniquePtr<nsISMILAttr>
  CreateSMILAttr(nsStyleContext* aBaseStyleContext);

  // Returns the CSS property this compositor should animate, or
  // eCSSProperty_UNKNOWN if this compositor does not animate a CSS property.
  nsCSSPropertyID GetCSSPropertyToAnimate() const;

  // Returns true if we might need to refer to base styles (i.e. we are
  // targeting a CSS property and have one or more animation functions that
  // don't just replace the underlying value).
  //
  // This might return true in some cases where we don't actually need the base
  // style since it doesn't build up the animation sandwich to check if the
  // functions that appear to need the base style are actually replaced by
  // a function further up the stack.
  bool MightNeedBaseStyle() const;

  // Finds the index of the first function that will affect our animation
  // sandwich. Also toggles the 'mForceCompositing' flag if it finds that any
  // (used) functions have changed.
  uint32_t GetFirstFuncToAffectSandwich();

  // If the passed-in base value differs from our cached base value, this
  // method updates the cached value (and toggles the 'mForceCompositing' flag)
  void UpdateCachedBaseValue(const nsSMILValue& aBaseValue);

  // The hash key (tuple of element and attributeName)
  KeyType mKey;

  // Hash Value: List of animation functions that animate the specified attr
  nsTArray<nsSMILAnimationFunction*> mAnimationFunctions;

  // Member data for detecting when we need to force-recompose
  // ---------------------------------------------------------
  // Flag for tracking whether we need to compose. Initialized to false, but
  // gets flipped to true if we detect that something has changed.
  bool mForceCompositing;

  // Cached base value, so we can detect & force-recompose when it changes
  // from one sample to the next. (nsSMILAnimationController moves this
  // forward from the previous sample's compositor by calling
  // StealCachedBaseValue.)
  nsSMILValue mCachedBaseValue;
};

#endif // NS_SMILCOMPOSITOR_H_
