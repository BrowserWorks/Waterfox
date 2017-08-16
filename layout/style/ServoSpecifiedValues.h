/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * Servo-backed specified value store, to be used when mapping presentation
 * attributes
 */

#ifndef mozilla_ServoSpecifiedValues_h
#define mozilla_ServoSpecifiedValues_h

#include "mozilla/GenericSpecifiedValues.h"
#include "mozilla/ServoBindings.h"

namespace mozilla {

class ServoSpecifiedValues final: public GenericSpecifiedValues
{
public:

  ServoSpecifiedValues(nsPresContext* aContext, RawServoDeclarationBlock* aDecl);

  // GenericSpecifiedValues overrides
  bool PropertyIsSet(nsCSSPropertyID aId);

  void SetIdentStringValue(nsCSSPropertyID aId,
                           const nsString& aValue);

  void SetIdentStringValueIfUnset(nsCSSPropertyID aId,
                                  const nsString& aValue) {
    if (!PropertyIsSet(aId)) {
      SetIdentStringValue(aId, aValue);
    }
  }

  void SetKeywordValue(nsCSSPropertyID aId,
                       int32_t aValue);

  void SetKeywordValueIfUnset(nsCSSPropertyID aId,
                              int32_t aValue) {
    if (!PropertyIsSet(aId)) {
      SetKeywordValue(aId, aValue);
    }
  }


  void SetIntValue(nsCSSPropertyID aId,
                   int32_t aValue);

  void SetPixelValue(nsCSSPropertyID aId,
                     float aValue);

  void SetPixelValueIfUnset(nsCSSPropertyID aId,
                            float aValue) {
    if (!PropertyIsSet(aId)) {
      SetPixelValue(aId, aValue);
    }
  }

  void SetLengthValue(nsCSSPropertyID aId,
                      nsCSSValue aValue);

  void SetNumberValue(nsCSSPropertyID aId,
                     float aValue);

  void SetPercentValue(nsCSSPropertyID aId,
                       float aValue);

  void SetAutoValue(nsCSSPropertyID aId);

  void SetAutoValueIfUnset(nsCSSPropertyID aId) {
    if (!PropertyIsSet(aId)) {
      SetAutoValue(aId);
    }
  }

  void SetPercentValueIfUnset(nsCSSPropertyID aId,
                              float aValue) {
    if (!PropertyIsSet(aId)) {
      SetPercentValue(aId, aValue);
    }
  }

  void SetCurrentColor(nsCSSPropertyID aId);

  void SetCurrentColorIfUnset(nsCSSPropertyID aId) {
    if (!PropertyIsSet(aId)) {
      SetCurrentColor(aId);
    }
  }

  void SetColorValue(nsCSSPropertyID aId,
                     nscolor aValue);

  void SetColorValueIfUnset(nsCSSPropertyID aId,
                            nscolor aValue) {
    if (!PropertyIsSet(aId)) {
      SetColorValue(aId, aValue);
    }
  }

  void SetFontFamily(const nsString& aValue);
  void SetTextDecorationColorOverride();
  void SetBackgroundImage(nsAttrValue& aValue);

private:
  RefPtr<RawServoDeclarationBlock> mDecl;
};

} // namespace mozilla

#endif // mozilla_ServoSpecifiedValues_h
