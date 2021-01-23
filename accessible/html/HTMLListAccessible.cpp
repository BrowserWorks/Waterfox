/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "HTMLListAccessible.h"

#include "DocAccessible.h"
#include "EventTree.h"
#include "nsAccUtils.h"
#include "Role.h"
#include "States.h"

#include "nsBulletFrame.h"
#include "nsLayoutUtils.h"

using namespace mozilla;
using namespace mozilla::a11y;

////////////////////////////////////////////////////////////////////////////////
// HTMLListAccessible
////////////////////////////////////////////////////////////////////////////////

role HTMLListAccessible::NativeRole() const {
  a11y::role r = GetAccService()->MarkupRole(mContent);
  return r != roles::NOTHING ? r : roles::LIST;
}

uint64_t HTMLListAccessible::NativeState() const {
  return HyperTextAccessibleWrap::NativeState() | states::READONLY;
}

////////////////////////////////////////////////////////////////////////////////
// HTMLLIAccessible
////////////////////////////////////////////////////////////////////////////////

HTMLLIAccessible::HTMLLIAccessible(nsIContent* aContent, DocAccessible* aDoc)
    : HyperTextAccessibleWrap(aContent, aDoc), mBullet(nullptr) {
  mType = eHTMLLiType;

  if (nsBulletFrame* bulletFrame =
          do_QueryFrame(nsLayoutUtils::GetMarkerFrame(aContent))) {
    const nsStyleList* styleList = bulletFrame->StyleList();
    if (styleList->GetListStyleImage() || !styleList->mCounterStyle.IsNone()) {
      mBullet = new HTMLListBulletAccessible(mContent, mDoc);
      Document()->BindToDocument(mBullet, nullptr);
      AppendChild(mBullet);
    }
  }
}

void HTMLLIAccessible::Shutdown() {
  mBullet = nullptr;

  HyperTextAccessibleWrap::Shutdown();
}

role HTMLLIAccessible::NativeRole() const {
  a11y::role r = GetAccService()->MarkupRole(mContent);
  return r != roles::NOTHING ? r : roles::LISTITEM;
}

uint64_t HTMLLIAccessible::NativeState() const {
  return HyperTextAccessibleWrap::NativeState() | states::READONLY;
}

nsRect HTMLLIAccessible::BoundsInAppUnits() const {
  nsRect rect = AccessibleWrap::BoundsInAppUnits();
  if (rect.IsEmpty() || !mBullet || mBullet->IsInside()) {
    return rect;
  }

  nsRect bulletRect = mBullet->BoundsInAppUnits();
  // Move x coordinate of list item over to cover bullet as well
  rect.SetLeftEdge(bulletRect.X());
  return rect;
}

bool HTMLLIAccessible::InsertChildAt(uint32_t aIndex, Accessible* aChild) {
  // Adjust index if there's a bullet.
  if (mBullet && aIndex == 0 && aChild != mBullet) {
    return HyperTextAccessible::InsertChildAt(aIndex + 1, aChild);
  }

  return HyperTextAccessible::InsertChildAt(aIndex, aChild);
}

void HTMLLIAccessible::RelocateChild(uint32_t aNewIndex, Accessible* aChild) {
  // Don't allow moving a child in front of the bullet.
  if (mBullet && aChild != mBullet && aNewIndex != 0) {
    HyperTextAccessible::RelocateChild(aNewIndex, aChild);
  }
}

////////////////////////////////////////////////////////////////////////////////
// HTMLLIAccessible: public

void HTMLLIAccessible::UpdateBullet(bool aHasBullet) {
  if (aHasBullet == !!mBullet) {
    MOZ_ASSERT_UNREACHABLE("Bullet and accessible are in sync already!");
    return;
  }

  TreeMutation mt(this);
  if (aHasBullet) {
    mBullet = new HTMLListBulletAccessible(mContent, mDoc);
    mDoc->BindToDocument(mBullet, nullptr);
    InsertChildAt(0, mBullet);
    mt.AfterInsertion(mBullet);
  } else {
    mt.BeforeRemoval(mBullet);
    RemoveChild(mBullet);
    mBullet = nullptr;
  }
  mt.Done();
}

////////////////////////////////////////////////////////////////////////////////
// HTMLListBulletAccessible
////////////////////////////////////////////////////////////////////////////////
HTMLListBulletAccessible::HTMLListBulletAccessible(nsIContent* aContent,
                                                   DocAccessible* aDoc)
    : LeafAccessible(aContent, aDoc) {
  mGenericTypes |= eText;
  mStateFlags |= eSharedNode;
}

////////////////////////////////////////////////////////////////////////////////
// HTMLListBulletAccessible: Accessible

nsIFrame* HTMLListBulletAccessible::GetFrame() const {
  return nsLayoutUtils::GetMarkerFrame(mContent);
}

ENameValueFlag HTMLListBulletAccessible::Name(nsString& aName) const {
  aName.Truncate();

  // Native anonymous content, ARIA can't be used. Get list bullet text.
  nsBulletFrame* frame = do_QueryFrame(GetFrame());
  if (!frame) {
    return eNameOK;
  }

  if (frame->StyleList()->GetListStyleImage()) {
    // Bullet is an image, so use default bullet character.
    const char16_t kDiscCharacter = 0x2022;
    aName.Assign(kDiscCharacter);
    aName.Append(' ');
    return eNameOK;
  }

  frame->GetSpokenText(aName);
  return eNameOK;
}

role HTMLListBulletAccessible::NativeRole() const { return roles::STATICTEXT; }

uint64_t HTMLListBulletAccessible::NativeState() const {
  return LeafAccessible::NativeState() | states::READONLY;
}

void HTMLListBulletAccessible::AppendTextTo(nsAString& aText,
                                            uint32_t aStartOffset,
                                            uint32_t aLength) {
  nsAutoString bulletText;
  Name(bulletText);
  aText.Append(Substring(bulletText, aStartOffset, aLength));
}

////////////////////////////////////////////////////////////////////////////////
// HTMLListBulletAccessible: public

bool HTMLListBulletAccessible::IsInside() const {
  if (nsIFrame* frame = mContent->GetPrimaryFrame()) {
    return frame->StyleList()->mListStylePosition ==
           NS_STYLE_LIST_STYLE_POSITION_INSIDE;
  }
  return false;
}
