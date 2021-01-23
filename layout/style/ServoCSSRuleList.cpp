/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* representation of CSSRuleList for stylo */

#include "mozilla/ServoCSSRuleList.h"

#include "mozilla/dom/CSSCounterStyleRule.h"
#include "mozilla/dom/CSSFontFaceRule.h"
#include "mozilla/dom/CSSFontFeatureValuesRule.h"
#include "mozilla/dom/CSSImportRule.h"
#include "mozilla/dom/CSSKeyframesRule.h"
#include "mozilla/dom/CSSMediaRule.h"
#include "mozilla/dom/CSSMozDocumentRule.h"
#include "mozilla/dom/CSSNamespaceRule.h"
#include "mozilla/dom/CSSPageRule.h"
#include "mozilla/dom/CSSStyleRule.h"
#include "mozilla/dom/CSSSupportsRule.h"
#include "mozilla/IntegerRange.h"
#include "mozilla/ServoBindings.h"
#include "mozilla/StyleSheet.h"
#include "mozilla/dom/Document.h"

using namespace mozilla::dom;

namespace mozilla {

ServoCSSRuleList::ServoCSSRuleList(already_AddRefed<ServoCssRules> aRawRules,
                                   StyleSheet* aSheet,
                                   css::GroupRule* aParentRule)
    : mStyleSheet(aSheet), mParentRule(aParentRule), mRawRules(aRawRules) {
  Servo_CssRules_ListTypes(mRawRules, &mRules);
}

// QueryInterface implementation for ServoCSSRuleList
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ServoCSSRuleList)
NS_INTERFACE_MAP_END_INHERITING(dom::CSSRuleList)

NS_IMPL_ADDREF_INHERITED(ServoCSSRuleList, dom::CSSRuleList)
NS_IMPL_RELEASE_INHERITED(ServoCSSRuleList, dom::CSSRuleList)

NS_IMPL_CYCLE_COLLECTION_CLASS(ServoCSSRuleList)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(ServoCSSRuleList)
  tmp->DropAllRules();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END_INHERITED(dom::CSSRuleList)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(ServoCSSRuleList,
                                                  dom::CSSRuleList)
  tmp->EnumerateInstantiatedRules([&](css::Rule* aRule) {
    if (!aRule->IsCCLeaf()) {
      NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "mRules[i]");
      cb.NoteXPCOMChild(aRule);
    }
  });
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

css::Rule* ServoCSSRuleList::GetRule(uint32_t aIndex) {
  uintptr_t rule = mRules[aIndex];
  if (rule <= kMaxRuleType) {
    RefPtr<css::Rule> ruleObj = nullptr;
    switch (rule) {
#define CASE_RULE(const_, name_)                                             \
  case CSSRule_Binding::const_##_RULE: {                                     \
    uint32_t line = 0, column = 0;                                           \
    RefPtr<RawServo##name_##Rule> rule =                                     \
        Servo_CssRules_Get##name_##RuleAt(mRawRules, aIndex, &line, &column) \
            .Consume();                                                      \
    MOZ_ASSERT(rule);                                                        \
    ruleObj = new CSS##name_##Rule(rule.forget(), mStyleSheet, mParentRule,  \
                                   line, column);                            \
    break;                                                                   \
  }
      CASE_RULE(STYLE, Style)
      CASE_RULE(KEYFRAMES, Keyframes)
      CASE_RULE(MEDIA, Media)
      CASE_RULE(NAMESPACE, Namespace)
      CASE_RULE(PAGE, Page)
      CASE_RULE(SUPPORTS, Supports)
      CASE_RULE(DOCUMENT, MozDocument)
      CASE_RULE(IMPORT, Import)
      CASE_RULE(FONT_FEATURE_VALUES, FontFeatureValues)
      CASE_RULE(FONT_FACE, FontFace)
      CASE_RULE(COUNTER_STYLE, CounterStyle)
#undef CASE_RULE
      case CSSRule_Binding::KEYFRAME_RULE:
        MOZ_ASSERT_UNREACHABLE("keyframe rule cannot be here");
        return nullptr;
      default:
        NS_WARNING("stylo: not implemented yet");
        return nullptr;
    }
    rule = CastToUint(ruleObj.forget().take());
    mRules[aIndex] = rule;
  }
  return CastToPtr(rule);
}

css::Rule* ServoCSSRuleList::IndexedGetter(uint32_t aIndex, bool& aFound) {
  if (aIndex >= mRules.Length()) {
    aFound = false;
    return nullptr;
  }
  aFound = true;
  return GetRule(aIndex);
}

template <typename Func>
void ServoCSSRuleList::EnumerateInstantiatedRules(Func aCallback) {
  for (uintptr_t rule : mRules) {
    if (rule > kMaxRuleType) {
      aCallback(CastToPtr(rule));
    }
  }
}

static void DropRule(already_AddRefed<css::Rule> aRule) {
  RefPtr<css::Rule> rule = aRule;
  rule->DropReferences();
}

void ServoCSSRuleList::DropAllRules() {
  mStyleSheet = nullptr;
  mParentRule = nullptr;
  mRawRules = nullptr;
  // DropRule could reenter here via the cycle collector.
  auto rules = std::move(mRules);
  for (uintptr_t rule : rules) {
    if (rule > kMaxRuleType) {
      DropRule(already_AddRefed<css::Rule>(CastToPtr(rule)));
    }
  }
  MOZ_ASSERT(mRules.IsEmpty());
}

void ServoCSSRuleList::DropSheetReference() {
  // If mStyleSheet is not set on this rule list, then it is not set on any of
  // its instantiated rules either.  To avoid O(N^2) beavhior in the depth of
  // group rule nesting, which can happen if we are unlinked starting from the
  // deepest nested group rule, skip recursing into the rule list if we know we
  // don't need to.
  if (!mStyleSheet) {
    return;
  }
  mStyleSheet = nullptr;
  EnumerateInstantiatedRules(
      [](css::Rule* rule) { rule->DropSheetReference(); });
}

void ServoCSSRuleList::DropParentRuleReference() {
  mParentRule = nullptr;
  EnumerateInstantiatedRules(
      [](css::Rule* rule) { rule->DropParentRuleReference(); });
}

nsresult ServoCSSRuleList::InsertRule(const nsAString& aRule, uint32_t aIndex) {
  MOZ_ASSERT(mStyleSheet,
             "Caller must ensure that "
             "the list is not unlinked from stylesheet");

  if (IsReadOnly()) {
    return NS_OK;
  }

  NS_ConvertUTF16toUTF8 rule(aRule);
  bool nested = !!mParentRule;
  css::Loader* loader = nullptr;
  auto allowImportRules = mStyleSheet->SelfOrAncestorIsConstructed()
                              ? StyleAllowImportRules::No
                              : StyleAllowImportRules::Yes;

  // TODO(emilio, bug 1535456): Should probably always be able to get a handle
  // to some loader if we're parsing an @import rule, but which one?
  //
  // StyleSheet::ReparseSheet just mints a new loader, but that'd be wrong in
  // this case I think, since such a load will bypass CSP checks.
  if (Document* doc = mStyleSheet->GetAssociatedDocument()) {
    loader = doc->CSSLoader();
  }
  uint16_t type;
  nsresult rv = Servo_CssRules_InsertRule(mRawRules, mStyleSheet->RawContents(),
                                          &rule, aIndex, nested, loader,
                                          allowImportRules, mStyleSheet, &type);
  if (NS_FAILED(rv)) {
    return rv;
  }
  mRules.InsertElementAt(aIndex, type);
  return rv;
}

nsresult ServoCSSRuleList::DeleteRule(uint32_t aIndex) {
  if (IsReadOnly()) {
    return NS_OK;
  }

  nsresult rv = Servo_CssRules_DeleteRule(mRawRules, aIndex);
  if (!NS_FAILED(rv)) {
    uintptr_t rule = mRules[aIndex];
    mRules.RemoveElementAt(aIndex);
    if (rule > kMaxRuleType) {
      DropRule(already_AddRefed<css::Rule>(CastToPtr(rule)));
    }
  }
  return rv;
}

uint16_t ServoCSSRuleList::GetDOMCSSRuleType(uint32_t aIndex) const {
  uintptr_t rule = mRules[aIndex];
  if (rule <= kMaxRuleType) {
    return rule;
  }
  return CastToPtr(rule)->Type();
}

ServoCSSRuleList::~ServoCSSRuleList() {
  MOZ_ASSERT(!mStyleSheet, "Backpointer should have been cleared");
  MOZ_ASSERT(!mParentRule, "Backpointer should have been cleared");
  DropAllRules();
}

bool ServoCSSRuleList::IsReadOnly() const {
  MOZ_ASSERT(!mStyleSheet || !mParentRule ||
                 mStyleSheet->IsReadOnly() == mParentRule->IsReadOnly(),
             "a parent rule should be read only iff the owning sheet is "
             "read only");
  return mStyleSheet && mStyleSheet->IsReadOnly();
}

}  // namespace mozilla
