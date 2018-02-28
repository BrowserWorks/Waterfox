/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**

  Author:
  Eric D Vaughan

**/

#ifndef nsBoxLayoutState_h___
#define nsBoxLayoutState_h___

#include "nsCOMPtr.h"
#include "nsPresContext.h"
#include "nsIPresShell.h"

class gfxContext;
namespace mozilla {
struct ReflowInput;
} // namespace mozilla


class MOZ_STACK_CLASS nsBoxLayoutState
{
  using ReflowInput = mozilla::ReflowInput;

public:
  explicit nsBoxLayoutState(nsPresContext* aPresContext,
                            gfxContext* aRenderingContext = nullptr,
                            // see OuterReflowInput() below
                            const ReflowInput* aOuterReflowInput = nullptr,
                            uint16_t aReflowDepth = 0);
  nsBoxLayoutState(const nsBoxLayoutState& aState);

  nsPresContext* PresContext() const { return mPresContext; }
  nsIPresShell* PresShell() const { return mPresContext->PresShell(); }

  uint32_t LayoutFlags() const { return mLayoutFlags; }
  void SetLayoutFlags(uint32_t aFlags) { mLayoutFlags = aFlags; }

  // if true no one under us will paint during reflow.
  void SetPaintingDisabled(bool aDisable) { mPaintingDisabled = aDisable; }
  bool PaintingDisabled() const { return mPaintingDisabled; }

  // The rendering context may be null for specialized uses of
  // nsBoxLayoutState and should be null-checked before it is used.
  // However, passing a null rendering context to the constructor when
  // doing box layout or intrinsic size calculation will cause bugs.
  gfxContext* GetRenderingContext() const { return mRenderingContext; }

  struct AutoReflowDepth {
    explicit AutoReflowDepth(nsBoxLayoutState& aState)
      : mState(aState) { ++mState.mReflowDepth; }
    ~AutoReflowDepth() { --mState.mReflowDepth; }
    nsBoxLayoutState& mState;
  };

  // The HTML reflow state that lives outside the box-block boundary.
  // May not be set reliably yet.
  const ReflowInput* OuterReflowInput() { return mOuterReflowInput; }

  uint16_t GetReflowDepth() { return mReflowDepth; }

private:
  RefPtr<nsPresContext> mPresContext;
  gfxContext *mRenderingContext;
  const ReflowInput *mOuterReflowInput;
  uint32_t mLayoutFlags;
  uint16_t mReflowDepth;
  bool mPaintingDisabled;
};

#endif

