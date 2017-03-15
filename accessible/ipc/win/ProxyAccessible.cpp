/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "Accessible2.h"
#include "ProxyAccessible.h"
#include "ia2AccessibleValue.h"
#include "mozilla/a11y/DocAccessibleParent.h"
#include "DocAccessible.h"
#include "mozilla/a11y/DocManager.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/TabParent.h"
#include "mozilla/Unused.h"
#include "mozilla/a11y/Platform.h"
#include "RelationType.h"
#include "mozilla/a11y/Role.h"
#include "xpcAccessibleDocument.h"

#include <comutil.h>

static const VARIANT kChildIdSelf = {VT_I4};

namespace mozilla {
namespace a11y {

bool
ProxyAccessible::GetCOMInterface(void** aOutAccessible) const
{
  if (!aOutAccessible) {
    return false;
  }

  if (!mCOMProxy) {
    // See if we can lazily obtain a COM proxy
    AccessibleWrap* wrap = WrapperFor(this);
    bool isDefunct = false;
    ProxyAccessible* thisPtr = const_cast<ProxyAccessible*>(this);
    // NB: Don't pass CHILDID_SELF here, use the absolute MSAA ID. Otherwise
    // GetIAccessibleFor will recurse into this function and we will just
    // overflow the stack.
    VARIANT realId = {VT_I4};
    realId.ulVal = wrap->GetExistingID();
    thisPtr->mCOMProxy = wrap->GetIAccessibleFor(realId, &isDefunct);
  }

  RefPtr<IAccessible> addRefed = mCOMProxy;
  addRefed.forget(aOutAccessible);
  return !!mCOMProxy;
}

/**
 * Specializations of this template map an IAccessible type to its IID
 */
template<typename Interface> struct InterfaceIID {};

template<>
struct InterfaceIID<IAccessibleValue>
{
  static REFIID Value() { return IID_IAccessibleValue; }
};

template<>
struct InterfaceIID<IAccessibleText>
{
  static REFIID Value() { return IID_IAccessibleText; }
};

/**
 * Get the COM proxy for this proxy accessible and QueryInterface it with the
 * correct IID
 */
template<typename Interface>
static already_AddRefed<Interface>
QueryInterface(const ProxyAccessible* aProxy)
{
  RefPtr<IAccessible> acc;
  if (!aProxy->GetCOMInterface((void**)getter_AddRefs(acc))) {
    return nullptr;
  }

  RefPtr<Interface> acc2;
  if (FAILED(acc->QueryInterface(InterfaceIID<Interface>::Value(),
                                 (void**)getter_AddRefs(acc2)))) {
    return nullptr;
  }

  return acc2.forget();
}

void
ProxyAccessible::Name(nsString& aName) const
{
  aName.Truncate();
  RefPtr<IAccessible> acc;
  if (!GetCOMInterface((void**)getter_AddRefs(acc))) {
    return;
  }

  BSTR result;
  HRESULT hr = acc->get_accName(kChildIdSelf, &result);
  _bstr_t resultWrap(result, false);
  if (FAILED(hr)) {
    return;
  }
  aName = (wchar_t*)resultWrap;
}

void
ProxyAccessible::Value(nsString& aValue) const
{
  aValue.Truncate();
  RefPtr<IAccessible> acc;
  if (!GetCOMInterface((void**)getter_AddRefs(acc))) {
    return;
  }

  BSTR result;
  HRESULT hr = acc->get_accValue(kChildIdSelf, &result);
  _bstr_t resultWrap(result, false);
  if (FAILED(hr)) {
    return;
  }
  aValue = (wchar_t*)resultWrap;
}

void
ProxyAccessible::Description(nsString& aDesc) const
{
  aDesc.Truncate();
  RefPtr<IAccessible> acc;
  if (!GetCOMInterface((void**)getter_AddRefs(acc))) {
    return;
  }

  BSTR result;
  HRESULT hr = acc->get_accDescription(kChildIdSelf, &result);
  _bstr_t resultWrap(result, false);
  if (FAILED(hr)) {
    return;
  }
  aDesc = (wchar_t*)resultWrap;
}

uint64_t
ProxyAccessible::State() const
{
  uint64_t state = 0;
  RefPtr<IAccessible> acc;
  if (!GetCOMInterface((void**)getter_AddRefs(acc))) {
    return state;
  }

  VARIANT varState;
  HRESULT hr = acc->get_accState(kChildIdSelf, &varState);
  if (FAILED(hr)) {
    return state;
  }
  return uint64_t(varState.lVal);
}

nsIntRect
ProxyAccessible::Bounds()
{
  nsIntRect rect;

  RefPtr<IAccessible> acc;
  if (!GetCOMInterface((void**)getter_AddRefs(acc))) {
    return rect;
  }

  long left;
  long top;
  long width;
  long height;
  HRESULT hr = acc->accLocation(&left, &top, &width, &height, kChildIdSelf);
  if (FAILED(hr)) {
    return rect;
  }
  rect.x = left;
  rect.y = top;
  rect.width = width;
  rect.height = height;
  return rect;
}

void
ProxyAccessible::Language(nsString& aLocale)
{
  aLocale.Truncate();

  RefPtr<IAccessible> acc;
  if (!GetCOMInterface((void**)getter_AddRefs(acc))) {
    return;
  }

  RefPtr<IAccessible2> acc2;
  if (FAILED(acc->QueryInterface(IID_IAccessible2, (void**)getter_AddRefs(acc2)))) {
    return;
  }

  IA2Locale locale;
  HRESULT hr = acc2->get_locale(&locale);

  _bstr_t langWrap(locale.language, false);
  _bstr_t countryWrap(locale.country, false);
  _bstr_t variantWrap(locale.variant, false);

  if (FAILED(hr)) {
    return;
  }

  // The remaining code should essentially be the inverse of the
  // ia2Accessible::get_locale conversion to IA2Locale.

  if (!!variantWrap) {
    aLocale = (wchar_t*)variantWrap;
    return;
  }

  if (!!langWrap) {
    aLocale = (wchar_t*)langWrap;
    if (!!countryWrap) {
      aLocale += L"-";
      aLocale += (wchar_t*)countryWrap;
    }
  }
}

static bool
IsEscapedChar(const wchar_t c)
{
  return c == L'\\' || c == L':' || c == ',' || c == '=' || c == ';';
}

static bool
ConvertBSTRAttributesToArray(const nsAString& aStr,
                             nsTArray<Attribute>* aAttrs)
{
  if (!aAttrs) {
    return false;
  }

  enum
  {
    eName = 0,
    eValue = 1,
    eNumStates
  } state;
  nsAutoString tokens[eNumStates];
  auto itr = aStr.BeginReading(), end = aStr.EndReading();

  state = eName;
  while (itr != end) {
    switch (*itr) {
      case L'\\':
        // Skip the backslash so that we're looking at the escaped char
        ++itr;
        if (itr == end || !IsEscapedChar(*itr)) {
          // Invalid state
          return false;
        }
        break;
      case L':':
        if (state != eName) {
          // Bad, should be looking at name
          return false;
        }
        state = eValue;
        ++itr;
        continue;
      case L';':
        if (state != eValue) {
          // Bad, should be looking at value
          return false;
        }
        state = eName;
        aAttrs->AppendElement(Attribute(NS_ConvertUTF16toUTF8(tokens[eName]),
                                        tokens[eValue]));
        tokens[eName].Truncate();
        tokens[eValue].Truncate();
        ++itr;
        continue;
      default:
        break;
    }
    tokens[state] += *itr;
  }
  return true;
}

void
ProxyAccessible::Attributes(nsTArray<Attribute>* aAttrs) const
{
  aAttrs->Clear();

  RefPtr<IAccessible> acc;
  if (!GetCOMInterface((void**)getter_AddRefs(acc))) {
    return;
  }

  RefPtr<IAccessible2> acc2;
  if (FAILED(acc->QueryInterface(IID_IAccessible2, (void**)getter_AddRefs(acc2)))) {
    return;
  }

  BSTR attrs;
  HRESULT hr = acc2->get_attributes(&attrs);
  _bstr_t attrsWrap(attrs, false);
  if (FAILED(hr)) {
    return;
  }

  ConvertBSTRAttributesToArray(nsDependentString((wchar_t*)attrs,
                                                 attrsWrap.length()),
                               aAttrs);
}

double
ProxyAccessible::CurValue()
{
  RefPtr<IAccessibleValue> acc = QueryInterface<IAccessibleValue>(this);
  if (!acc) {
    return UnspecifiedNaN<double>();
  }

  VARIANT currentValue;
  HRESULT hr = acc->get_currentValue(&currentValue);
  if (FAILED(hr) || currentValue.vt != VT_R8) {
    return UnspecifiedNaN<double>();
  }

  return currentValue.dblVal;
}

bool
ProxyAccessible::SetCurValue(double aValue)
{
  RefPtr<IAccessibleValue> acc = QueryInterface<IAccessibleValue>(this);
  if (!acc) {
    return false;
  }

  VARIANT currentValue;
  VariantInit(&currentValue);
  currentValue.vt = VT_R8;
  currentValue.dblVal = aValue;
  HRESULT hr = acc->setCurrentValue(currentValue);
  return SUCCEEDED(hr);
}

double
ProxyAccessible::MinValue()
{
  RefPtr<IAccessibleValue> acc = QueryInterface<IAccessibleValue>(this);
  if (!acc) {
    return UnspecifiedNaN<double>();
  }

  VARIANT minimumValue;
  HRESULT hr = acc->get_minimumValue(&minimumValue);
  if (FAILED(hr) || minimumValue.vt != VT_R8) {
    return UnspecifiedNaN<double>();
  }

  return minimumValue.dblVal;
}

double
ProxyAccessible::MaxValue()
{
  RefPtr<IAccessibleValue> acc = QueryInterface<IAccessibleValue>(this);
  if (!acc) {
    return UnspecifiedNaN<double>();
  }

  VARIANT maximumValue;
  HRESULT hr = acc->get_maximumValue(&maximumValue);
  if (FAILED(hr) || maximumValue.vt != VT_R8) {
    return UnspecifiedNaN<double>();
  }

  return maximumValue.dblVal;
}

static IA2TextBoundaryType
GetIA2TextBoundary(AccessibleTextBoundary aGeckoBoundaryType)
{
  switch (aGeckoBoundaryType) {
    case nsIAccessibleText::BOUNDARY_CHAR:
      return IA2_TEXT_BOUNDARY_CHAR;
    case nsIAccessibleText::BOUNDARY_WORD_START:
      return IA2_TEXT_BOUNDARY_WORD;
    case nsIAccessibleText::BOUNDARY_LINE_START:
      return IA2_TEXT_BOUNDARY_LINE;
    default:
      MOZ_RELEASE_ASSERT(false);
  }
}

bool
ProxyAccessible::TextSubstring(int32_t aStartOffset, int32_t aEndOffset,
                               nsString& aText) const
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return false;
  }

  BSTR result;
  HRESULT hr = acc->get_text(static_cast<long>(aStartOffset),
                             static_cast<long>(aEndOffset), &result);
  if (FAILED(hr)) {
    return false;
  }

  _bstr_t resultWrap(result, false);
  aText = (wchar_t*)result;

  return true;
}

void
ProxyAccessible::GetTextBeforeOffset(int32_t aOffset,
                                    AccessibleTextBoundary aBoundaryType,
                                    nsString& aText, int32_t* aStartOffset,
                                    int32_t* aEndOffset)
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return;
  }

  BSTR result;
  long start, end;
  HRESULT hr = acc->get_textBeforeOffset(aOffset,
                                         GetIA2TextBoundary(aBoundaryType),
                                         &start, &end, &result);
  if (FAILED(hr)) {
    return;
  }

  _bstr_t resultWrap(result, false);
  *aStartOffset = start;
  *aEndOffset = end;
  aText = (wchar_t*)result;
}

void
ProxyAccessible::GetTextAfterOffset(int32_t aOffset,
                                    AccessibleTextBoundary aBoundaryType,
                                    nsString& aText, int32_t* aStartOffset,
                                    int32_t* aEndOffset)
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return;
  }

  BSTR result;
  long start, end;
  HRESULT hr = acc->get_textAfterOffset(aOffset,
                                        GetIA2TextBoundary(aBoundaryType),
                                        &start, &end, &result);
  if (FAILED(hr)) {
    return;
  }

  _bstr_t resultWrap(result, false);
  aText = (wchar_t*)result;
  *aStartOffset = start;
  *aEndOffset = end;
}

void
ProxyAccessible::GetTextAtOffset(int32_t aOffset,
                                    AccessibleTextBoundary aBoundaryType,
                                    nsString& aText, int32_t* aStartOffset,
                                    int32_t* aEndOffset)
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return;
  }

  BSTR result;
  long start, end;
  HRESULT hr = acc->get_textAtOffset(aOffset, GetIA2TextBoundary(aBoundaryType),
                                     &start, &end, &result);
  if (FAILED(hr)) {
    return;
  }

  _bstr_t resultWrap(result, false);
  aText = (wchar_t*)result;
  *aStartOffset = start;
  *aEndOffset = end;
}

bool
ProxyAccessible::AddToSelection(int32_t aStartOffset, int32_t aEndOffset)
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return false;
  }

  return SUCCEEDED(acc->addSelection(static_cast<long>(aStartOffset),
                                     static_cast<long>(aEndOffset)));
}

bool
ProxyAccessible::RemoveFromSelection(int32_t aSelectionNum)
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return false;
  }

  return SUCCEEDED(acc->removeSelection(static_cast<long>(aSelectionNum)));
}

int32_t
ProxyAccessible::CaretOffset()
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return -1;
  }

  long offset;
  HRESULT hr = acc->get_caretOffset(&offset);
  if (FAILED(hr)) {
    return -1;
  }

  return static_cast<int32_t>(offset);
}

void
ProxyAccessible::SetCaretOffset(int32_t aOffset)
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return;
  }

  acc->setCaretOffset(static_cast<long>(aOffset));
}

/**
 * aScrollType should be one of the nsIAccessiblescrollType constants.
 */
void
ProxyAccessible::ScrollSubstringTo(int32_t aStartOffset, int32_t aEndOffset,
                                   uint32_t aScrollType)
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return;
  }

  acc->scrollSubstringTo(static_cast<long>(aStartOffset),
                         static_cast<long>(aEndOffset),
                         static_cast<IA2ScrollType>(aScrollType));
}

/**
 * aCoordinateType is one of the nsIAccessibleCoordinateType constants.
 */
void
ProxyAccessible::ScrollSubstringToPoint(int32_t aStartOffset, int32_t aEndOffset,
                                        uint32_t aCoordinateType, int32_t aX,
                                        int32_t aY)
{
  RefPtr<IAccessibleText> acc = QueryInterface<IAccessibleText>(this);
  if (!acc) {
    return;
  }

  IA2CoordinateType coordType;
  if (aCoordinateType == nsIAccessibleCoordinateType::COORDTYPE_SCREEN_RELATIVE) {
    coordType = IA2_COORDTYPE_SCREEN_RELATIVE;
  } else if (aCoordinateType == nsIAccessibleCoordinateType::COORDTYPE_PARENT_RELATIVE) {
    coordType = IA2_COORDTYPE_PARENT_RELATIVE;
  } else {
    MOZ_RELEASE_ASSERT(false, "unsupported coord type");
  }

  acc->scrollSubstringToPoint(static_cast<long>(aStartOffset),
                              static_cast<long>(aEndOffset),
                              coordType,
                              static_cast<long>(aX),
                              static_cast<long>(aY));
}

} // namespace a11y
} // namespace mozilla
