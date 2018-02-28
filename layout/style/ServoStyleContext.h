/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_ServoStyleContext_h
#define mozilla_ServoStyleContext_h

#include "nsStyleContext.h"

namespace mozilla {

namespace dom {
class Element;
} // namespace dom

class ServoStyleContext final : public nsStyleContext
{
public:
  ServoStyleContext(nsStyleContext* aParent,
                    nsPresContext* aPresContext,
                    nsIAtom* aPseudoTag,
                    CSSPseudoElementType aPseudoType,
                    ServoComputedDataForgotten aComputedValues);

  nsPresContext* PresContext() const { return mPresContext; }
  const ServoComputedData* ComputedData() const { return &mSource; }

  void AddRef() { Servo_StyleContext_AddRef(this); }
  void Release() { Servo_StyleContext_Release(this); }

  ServoStyleContext* GetStyleIfVisited() const
  {
    return ComputedData()->visited_style.mPtr;
  }

  /**
   * Makes this context match |aOther| in terms of which style structs have
   * been resolved.
   */
  inline void ResolveSameStructsAs(const ServoStyleContext* aOther);

private:
  nsPresContext* mPresContext;
  ServoComputedData mSource;
};

} // namespace mozilla

#endif // mozilla_ServoStyleContext_h
