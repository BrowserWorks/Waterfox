/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * This is a light-weight tree iterator for `for` loops when full iterator
 * functionality isn't required.
 */

#ifndef mozilla_dom_SimpleTreeIterator_h
#define mozilla_dom_SimpleTreeIterator_h

#include "nsINode.h"
#include "nsTArray.h"
#include "mozilla/dom/Element.h"

namespace mozilla {
namespace dom {

class SimpleTreeIterator {
public:
  /**
   * Initialize an iterator with aRoot. After that it can be iterated with a
   * range-based for loop. At the moment, that's the only supported form of use
   * for this iterator.
   */
  explicit SimpleTreeIterator(nsINode& aRoot)
    : mCurrent(&aRoot)
  {
    mTree.AppendElement(&aRoot);
  }

  // Basic support for range-based for loops.
  // This will modify the iterator as it goes.
  SimpleTreeIterator& begin() { return *this; }

  SimpleTreeIterator end() { return SimpleTreeIterator(); }

  bool operator!=(const SimpleTreeIterator& aOther) {
    return mCurrent != aOther.mCurrent;
  }

  void operator++() { Next(); }

  nsINode* operator*() { return mCurrent; }

private:
  // Constructor used only for end() to represent a drained iterator.
  SimpleTreeIterator()
    : mCurrent(nullptr)
  {}

  void Next() {
    MOZ_ASSERT(mCurrent, "Don't call Next() when we have no current node");

    mCurrent = mCurrent->GetNextNode(mTree.LastElement());
  }

  // The current node.
  nsINode* mCurrent;

  // The DOM tree that we're inside of right now.
  AutoTArray<nsINode*, 1> mTree;
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_SimpleTreeIterator_h
