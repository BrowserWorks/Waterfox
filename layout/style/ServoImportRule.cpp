/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* representation of CSSImportRule for stylo */

#include "mozilla/ServoImportRule.h"

#include "mozilla/ServoBindings.h"
#include "mozilla/ServoStyleSheet.h"

namespace mozilla {

ServoImportRule::ServoImportRule(RefPtr<RawServoImportRule> aRawRule,
                                 uint32_t aLine, uint32_t aColumn)
  : CSSImportRule(aLine, aColumn)
  , mRawRule(Move(aRawRule))
{
  const auto* sheet = Servo_ImportRule_GetSheet(mRawRule.get());
  MOZ_ASSERT(sheet);
  mChildSheet = const_cast<ServoStyleSheet*>(sheet);
  mChildSheet->SetOwnerRule(this);
}

ServoImportRule::~ServoImportRule()
{
  if (mChildSheet) {
    mChildSheet->SetOwnerRule(nullptr);
  }
}

// QueryInterface implementation for ServoImportRule
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(ServoImportRule)
NS_INTERFACE_MAP_END_INHERITING(dom::CSSImportRule)

NS_IMPL_CYCLE_COLLECTION_CLASS(ServoImportRule)

NS_IMPL_ADDREF_INHERITED(ServoImportRule, dom::CSSImportRule)
NS_IMPL_RELEASE_INHERITED(ServoImportRule, dom::CSSImportRule)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(ServoImportRule,
                                                  dom::CSSImportRule)
  // Note the child sheet twice, since the Servo rule also holds a strong
  // reference to it.
  NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "mChildSheet");
  cb.NoteXPCOMChild(static_cast<nsIDOMCSSStyleSheet*>(tmp->mChildSheet));
  MOZ_ASSERT_IF(tmp->mRawRule,
                Servo_ImportRule_GetSheet(tmp->mRawRule) == tmp->mChildSheet);
  cb.NoteXPCOMChild(static_cast<nsIDOMCSSStyleSheet*>(tmp->mChildSheet));
  NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "mRawRule.stylesheet");
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(ServoImportRule)
  if (tmp->mChildSheet) {
    tmp->mChildSheet->SetOwnerRule(nullptr);
    tmp->mChildSheet = nullptr;
  }
  tmp->mRawRule = nullptr;
NS_IMPL_CYCLE_COLLECTION_UNLINK_END_INHERITED(dom::CSSImportRule)

/* virtual */ already_AddRefed<css::Rule>
ServoImportRule::Clone() const
{
  // Rule::Clone is only used when CSSStyleSheetInner is cloned in
  // preparation of being mutated. However, ServoStyleSheet never clones
  // anything, so this method should never be called.
  MOZ_ASSERT_UNREACHABLE("Shouldn't be cloning ServoImportRule");
  return nullptr;
}

#ifdef DEBUG
/* virtual */ void
ServoImportRule::List(FILE* out, int32_t aIndent) const
{
  nsAutoCString str;
  for (int32_t i = 0; i < aIndent; i++) {
    str.AppendLiteral("  ");
  }
  Servo_ImportRule_Debug(mRawRule, &str);
  fprintf_stderr(out, "%s\n", str.get());
}
#endif

dom::MediaList*
ServoImportRule::GetMedia() const
{
  // When Bug 1326509 is fixed, we can assert mChildSheet instead.
  return mChildSheet ? mChildSheet->Media() : nullptr;
}

StyleSheet*
ServoImportRule::GetStyleSheet() const
{
  return mChildSheet;
}

NS_IMETHODIMP
ServoImportRule::GetHref(nsAString& aHref)
{
  Servo_ImportRule_GetHref(mRawRule, &aHref);
  return NS_OK;
}

/* virtual */ void
ServoImportRule::GetCssTextImpl(nsAString& aCssText) const
{
  Servo_ImportRule_GetCssText(mRawRule, &aCssText);
}

/* virtual */ size_t
ServoImportRule::SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf) const
{
  // TODO Implement this!
  return aMallocSizeOf(this);
}

} // namespace mozilla
