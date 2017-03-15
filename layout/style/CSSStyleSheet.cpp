/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
// vim:cindent:tabstop=2:expandtab:shiftwidth=2:
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* representation of a CSS style sheet */

#include "mozilla/CSSStyleSheet.h"

#include "nsIAtom.h"
#include "nsCSSRuleProcessor.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/MediaListBinding.h"
#include "mozilla/css/NameSpaceRule.h"
#include "mozilla/css/GroupRule.h"
#include "mozilla/css/ImportRule.h"
#include "nsCSSRules.h"
#include "nsIMediaList.h"
#include "nsIDocument.h"
#include "nsPresContext.h"
#include "nsGkAtoms.h"
#include "nsQueryObject.h"
#include "nsString.h"
#include "nsTArray.h"
#include "nsIDOMCSSStyleSheet.h"
#include "mozilla/dom/CSSRuleList.h"
#include "nsIDOMMediaList.h"
#include "nsIDOMNode.h"
#include "nsError.h"
#include "nsCSSParser.h"
#include "mozilla/css/Loader.h"
#include "nsICSSLoaderObserver.h"
#include "nsNameSpaceManager.h"
#include "nsXMLNameSpaceMap.h"
#include "nsCOMPtr.h"
#include "nsContentUtils.h"
#include "nsIScriptSecurityManager.h"
#include "mozAutoDocUpdate.h"
#include "nsRuleNode.h"
#include "nsMediaFeatures.h"
#include "nsDOMClassInfoID.h"
#include "mozilla/Likely.h"
#include "nsComponentManagerUtils.h"
#include "nsNullPrincipal.h"
#include "mozilla/RuleProcessorCache.h"
#include "nsIStyleSheetLinkingElement.h"
#include "nsDOMWindowUtils.h"

using namespace mozilla;
using namespace mozilla::dom;

// -------------------------------
// Style Rule List for the DOM
//
class CSSRuleListImpl final : public CSSRuleList
{
public:
  explicit CSSRuleListImpl(CSSStyleSheet *aStyleSheet);

  virtual CSSStyleSheet* GetParentObject() override;

  virtual nsIDOMCSSRule*
  IndexedGetter(uint32_t aIndex, bool& aFound) override;
  virtual uint32_t
  Length() override;

  void DropReference() { mStyleSheet = nullptr; }

protected:
  virtual ~CSSRuleListImpl();

  CSSStyleSheet*  mStyleSheet;
};

CSSRuleListImpl::CSSRuleListImpl(CSSStyleSheet *aStyleSheet)
{
  // Not reference counted to avoid circular references.
  // The style sheet will tell us when its going away.
  mStyleSheet = aStyleSheet;
}

CSSRuleListImpl::~CSSRuleListImpl()
{
}

CSSStyleSheet*
CSSRuleListImpl::GetParentObject()
{
  return mStyleSheet;
}

uint32_t
CSSRuleListImpl::Length()
{
  if (!mStyleSheet) {
    return 0;
  }

  return AssertedCast<uint32_t>(mStyleSheet->StyleRuleCount());
}

nsIDOMCSSRule*    
CSSRuleListImpl::IndexedGetter(uint32_t aIndex, bool& aFound)
{
  aFound = false;

  if (mStyleSheet) {
    // ensure rules have correct parent
    mStyleSheet->EnsureUniqueInner();
    css::Rule* rule = mStyleSheet->GetStyleRuleAt(aIndex);
    if (rule) {
      aFound = true;
      return rule->GetDOMRule();
    }
  }

  // Per spec: "Return Value ... null if ... not a valid index."
  return nullptr;
}

template <class Numeric>
int32_t DoCompare(Numeric a, Numeric b)
{
  if (a == b)
    return 0;
  if (a < b)
    return -1;
  return 1;
}

bool
nsMediaExpression::Matches(nsPresContext *aPresContext,
                           const nsCSSValue& aActualValue) const
{
  const nsCSSValue& actual = aActualValue;
  const nsCSSValue& required = mValue;

  // If we don't have the feature, the match fails.
  if (actual.GetUnit() == eCSSUnit_Null) {
    return false;
  }

  // If the expression had no value to match, the match succeeds,
  // unless the value is an integer 0 or a zero length.
  if (required.GetUnit() == eCSSUnit_Null) {
    if (actual.GetUnit() == eCSSUnit_Integer)
      return actual.GetIntValue() != 0;
    if (actual.IsLengthUnit())
      return actual.GetFloatValue() != 0;
    return true;
  }

  NS_ASSERTION(mFeature->mRangeType == nsMediaFeature::eMinMaxAllowed ||
               mRange == nsMediaExpression::eEqual, "yikes");
  int32_t cmp; // -1 (actual < required)
               //  0 (actual == required)
               //  1 (actual > required)
  switch (mFeature->mValueType) {
    case nsMediaFeature::eLength:
      {
        NS_ASSERTION(actual.IsLengthUnit(), "bad actual value");
        NS_ASSERTION(required.IsLengthUnit(), "bad required value");
        nscoord actualCoord = nsRuleNode::CalcLengthWithInitialFont(
                                aPresContext, actual);
        nscoord requiredCoord = nsRuleNode::CalcLengthWithInitialFont(
                                  aPresContext, required);
        cmp = DoCompare(actualCoord, requiredCoord);
      }
      break;
    case nsMediaFeature::eInteger:
    case nsMediaFeature::eBoolInteger:
      {
        NS_ASSERTION(actual.GetUnit() == eCSSUnit_Integer,
                     "bad actual value");
        NS_ASSERTION(required.GetUnit() == eCSSUnit_Integer,
                     "bad required value");
        NS_ASSERTION(mFeature->mValueType != nsMediaFeature::eBoolInteger ||
                     actual.GetIntValue() == 0 || actual.GetIntValue() == 1,
                     "bad actual bool integer value");
        NS_ASSERTION(mFeature->mValueType != nsMediaFeature::eBoolInteger ||
                     required.GetIntValue() == 0 || required.GetIntValue() == 1,
                     "bad required bool integer value");
        cmp = DoCompare(actual.GetIntValue(), required.GetIntValue());
      }
      break;
    case nsMediaFeature::eFloat:
      {
        NS_ASSERTION(actual.GetUnit() == eCSSUnit_Number,
                     "bad actual value");
        NS_ASSERTION(required.GetUnit() == eCSSUnit_Number,
                     "bad required value");
        cmp = DoCompare(actual.GetFloatValue(), required.GetFloatValue());
      }
      break;
    case nsMediaFeature::eIntRatio:
      {
        NS_ASSERTION(actual.GetUnit() == eCSSUnit_Array &&
                     actual.GetArrayValue()->Count() == 2 &&
                     actual.GetArrayValue()->Item(0).GetUnit() ==
                       eCSSUnit_Integer &&
                     actual.GetArrayValue()->Item(1).GetUnit() ==
                       eCSSUnit_Integer,
                     "bad actual value");
        NS_ASSERTION(required.GetUnit() == eCSSUnit_Array &&
                     required.GetArrayValue()->Count() == 2 &&
                     required.GetArrayValue()->Item(0).GetUnit() ==
                       eCSSUnit_Integer &&
                     required.GetArrayValue()->Item(1).GetUnit() ==
                       eCSSUnit_Integer,
                     "bad required value");
        // Convert to int64_t so we can multiply without worry.  Note
        // that while the spec requires that both halves of |required|
        // be positive, the numerator or denominator of |actual| might
        // be zero (e.g., when testing 'aspect-ratio' on a 0-width or
        // 0-height iframe).
        int64_t actualNum = actual.GetArrayValue()->Item(0).GetIntValue(),
                actualDen = actual.GetArrayValue()->Item(1).GetIntValue(),
                requiredNum = required.GetArrayValue()->Item(0).GetIntValue(),
                requiredDen = required.GetArrayValue()->Item(1).GetIntValue();
        cmp = DoCompare(actualNum * requiredDen, requiredNum * actualDen);
      }
      break;
    case nsMediaFeature::eResolution:
      {
        NS_ASSERTION(actual.GetUnit() == eCSSUnit_Inch ||
                     actual.GetUnit() == eCSSUnit_Pixel ||
                     actual.GetUnit() == eCSSUnit_Centimeter,
                     "bad actual value");
        NS_ASSERTION(required.GetUnit() == eCSSUnit_Inch ||
                     required.GetUnit() == eCSSUnit_Pixel ||
                     required.GetUnit() == eCSSUnit_Centimeter,
                     "bad required value");
        float actualDPI = actual.GetFloatValue();
        float overrideDPPX = aPresContext->GetOverrideDPPX();

        if (overrideDPPX > 0) {
          actualDPI = overrideDPPX * 96.0f;
        } else if (actual.GetUnit() == eCSSUnit_Centimeter) {
          actualDPI = actualDPI * 2.54f;
        } else if (actual.GetUnit() == eCSSUnit_Pixel) {
          actualDPI = actualDPI * 96.0f;
        }
        float requiredDPI = required.GetFloatValue();
        if (required.GetUnit() == eCSSUnit_Centimeter) {
          requiredDPI = requiredDPI * 2.54f;
        } else if (required.GetUnit() == eCSSUnit_Pixel) {
          requiredDPI = requiredDPI * 96.0f;
        }
        cmp = DoCompare(actualDPI, requiredDPI);
      }
      break;
    case nsMediaFeature::eEnumerated:
      {
        NS_ASSERTION(actual.GetUnit() == eCSSUnit_Enumerated,
                     "bad actual value");
        NS_ASSERTION(required.GetUnit() == eCSSUnit_Enumerated,
                     "bad required value");
        NS_ASSERTION(mFeature->mRangeType == nsMediaFeature::eMinMaxNotAllowed,
                     "bad range"); // we asserted above about mRange
        // We don't really need DoCompare, but it doesn't hurt (and
        // maybe the compiler will condense this case with eInteger).
        cmp = DoCompare(actual.GetIntValue(), required.GetIntValue());
      }
      break;
    case nsMediaFeature::eIdent:
      {
        NS_ASSERTION(actual.GetUnit() == eCSSUnit_Ident,
                     "bad actual value");
        NS_ASSERTION(required.GetUnit() == eCSSUnit_Ident,
                     "bad required value");
        NS_ASSERTION(mFeature->mRangeType == nsMediaFeature::eMinMaxNotAllowed,
                     "bad range"); 
        cmp = !(actual == required); // string comparison
      }
      break;
  }
  switch (mRange) {
    case nsMediaExpression::eMin:
      return cmp != -1;
    case nsMediaExpression::eMax:
      return cmp != 1;
    case nsMediaExpression::eEqual:
      return cmp == 0;
  }
  NS_NOTREACHED("unexpected mRange");
  return false;
}

void
nsMediaQueryResultCacheKey::AddExpression(const nsMediaExpression* aExpression,
                                          bool aExpressionMatches)
{
  const nsMediaFeature *feature = aExpression->mFeature;
  FeatureEntry *entry = nullptr;
  for (uint32_t i = 0; i < mFeatureCache.Length(); ++i) {
    if (mFeatureCache[i].mFeature == feature) {
      entry = &mFeatureCache[i];
      break;
    }
  }
  if (!entry) {
    entry = mFeatureCache.AppendElement();
    if (!entry) {
      return; /* out of memory */
    }
    entry->mFeature = feature;
  }

  ExpressionEntry eentry = { *aExpression, aExpressionMatches };
  entry->mExpressions.AppendElement(eentry);
}

bool
nsMediaQueryResultCacheKey::Matches(nsPresContext* aPresContext) const
{
  if (aPresContext->Medium() != mMedium) {
    return false;
  }

  for (uint32_t i = 0; i < mFeatureCache.Length(); ++i) {
    const FeatureEntry *entry = &mFeatureCache[i];
    nsCSSValue actual;
    nsresult rv =
      (entry->mFeature->mGetter)(aPresContext, entry->mFeature, actual);
    NS_ENSURE_SUCCESS(rv, false); // any better ideas?

    for (uint32_t j = 0; j < entry->mExpressions.Length(); ++j) {
      const ExpressionEntry &eentry = entry->mExpressions[j];
      if (eentry.mExpression.Matches(aPresContext, actual) !=
          eentry.mExpressionMatches) {
        return false;
      }
    }
  }

  return true;
}

bool
nsDocumentRuleResultCacheKey::AddMatchingRule(css::DocumentRule* aRule)
{
  MOZ_ASSERT(!mFinalized);
  return mMatchingRules.AppendElement(aRule);
}

void
nsDocumentRuleResultCacheKey::Finalize()
{
  mMatchingRules.Sort();
#ifdef DEBUG
  mFinalized = true;
#endif
}

#ifdef DEBUG
static bool
ArrayIsSorted(const nsTArray<css::DocumentRule*>& aRules)
{
  for (size_t i = 1; i < aRules.Length(); i++) {
    if (aRules[i - 1] > aRules[i]) {
      return false;
    }
  }
  return true;
}
#endif

bool
nsDocumentRuleResultCacheKey::Matches(
                       nsPresContext* aPresContext,
                       const nsTArray<css::DocumentRule*>& aRules) const
{
  MOZ_ASSERT(mFinalized);
  MOZ_ASSERT(ArrayIsSorted(mMatchingRules));
  MOZ_ASSERT(ArrayIsSorted(aRules));

#ifdef DEBUG
  for (css::DocumentRule* rule : mMatchingRules) {
    MOZ_ASSERT(aRules.BinaryIndexOf(rule) != aRules.NoIndex,
               "aRules must contain all rules in mMatchingRules");
  }
#endif

  // First check that aPresContext matches all the rules listed in
  // mMatchingRules.
  for (css::DocumentRule* rule : mMatchingRules) {
    if (!rule->UseForPresentation(aPresContext)) {
      return false;
    }
  }

  // Then check that all the rules in aRules that aren't also in
  // mMatchingRules do not match.

  // pointer to matching rules
  auto pm     = mMatchingRules.begin();
  auto pm_end = mMatchingRules.end();

  // pointer to all rules
  auto pr     = aRules.begin();
  auto pr_end = aRules.end();

  // mMatchingRules and aRules are both sorted by their pointer values,
  // so we can iterate over the two lists simultaneously.
  while (pr < pr_end) {
    while (pm < pm_end && *pm < *pr) {
      ++pm;
    }
    if (pm >= pm_end || *pm != *pr) {
      if ((*pr)->UseForPresentation(aPresContext)) {
        return false;
      }
    }
    ++pr;
  }
  return true;
}

#ifdef DEBUG
void
nsDocumentRuleResultCacheKey::List(FILE* aOut, int32_t aIndent) const
{
  for (css::DocumentRule* rule : mMatchingRules) {
    nsCString str;

    for (int32_t i = 0; i < aIndent; i++) {
      str.AppendLiteral("  ");
    }
    str.AppendLiteral("{ ");

    nsString condition;
    rule->GetConditionText(condition);
    AppendUTF16toUTF8(condition, str);

    str.AppendLiteral(" }\n");
    fprintf_stderr(aOut, "%s", str.get());
  }
}
#endif

size_t
nsDocumentRuleResultCacheKey::SizeOfExcludingThis(MallocSizeOf aMallocSizeOf) const
{
  size_t n = 0;
  n += mMatchingRules.ShallowSizeOfExcludingThis(aMallocSizeOf);
  return n;
}

void
nsMediaQuery::AppendToString(nsAString& aString) const
{
  if (mHadUnknownExpression) {
    aString.AppendLiteral("not all");
    return;
  }

  NS_ASSERTION(!mNegated || !mHasOnly, "can't have not and only");
  NS_ASSERTION(!mTypeOmitted || (!mNegated && !mHasOnly),
               "can't have not or only when type is omitted");
  if (!mTypeOmitted) {
    if (mNegated) {
      aString.AppendLiteral("not ");
    } else if (mHasOnly) {
      aString.AppendLiteral("only ");
    }
    aString.Append(nsDependentAtomString(mMediaType));
  }

  for (uint32_t i = 0, i_end = mExpressions.Length(); i < i_end; ++i) {
    if (i > 0 || !mTypeOmitted)
      aString.AppendLiteral(" and ");
    aString.Append('(');

    const nsMediaExpression &expr = mExpressions[i];
    const nsMediaFeature *feature = expr.mFeature;
    if (feature->mReqFlags & nsMediaFeature::eHasWebkitPrefix) {
      aString.AppendLiteral("-webkit-");
    }
    if (expr.mRange == nsMediaExpression::eMin) {
      aString.AppendLiteral("min-");
    } else if (expr.mRange == nsMediaExpression::eMax) {
      aString.AppendLiteral("max-");
    }

    aString.Append(nsDependentAtomString(*feature->mName));

    if (expr.mValue.GetUnit() != eCSSUnit_Null) {
      aString.AppendLiteral(": ");
      switch (feature->mValueType) {
        case nsMediaFeature::eLength:
          NS_ASSERTION(expr.mValue.IsLengthUnit(), "bad unit");
          // Use 'width' as a property that takes length values
          // written in the normal way.
          expr.mValue.AppendToString(eCSSProperty_width, aString,
                                     nsCSSValue::eNormalized);
          break;
        case nsMediaFeature::eInteger:
        case nsMediaFeature::eBoolInteger:
          NS_ASSERTION(expr.mValue.GetUnit() == eCSSUnit_Integer,
                       "bad unit");
          // Use 'z-index' as a property that takes integer values
          // written without anything extra.
          expr.mValue.AppendToString(eCSSProperty_z_index, aString,
                                     nsCSSValue::eNormalized);
          break;
        case nsMediaFeature::eFloat:
          {
            NS_ASSERTION(expr.mValue.GetUnit() == eCSSUnit_Number,
                         "bad unit");
            // Use 'line-height' as a property that takes float values
            // written in the normal way.
            expr.mValue.AppendToString(eCSSProperty_line_height, aString,
                                       nsCSSValue::eNormalized);
          }
          break;
        case nsMediaFeature::eIntRatio:
          {
            NS_ASSERTION(expr.mValue.GetUnit() == eCSSUnit_Array,
                         "bad unit");
            nsCSSValue::Array *array = expr.mValue.GetArrayValue();
            NS_ASSERTION(array->Count() == 2, "unexpected length");
            NS_ASSERTION(array->Item(0).GetUnit() == eCSSUnit_Integer,
                         "bad unit");
            NS_ASSERTION(array->Item(1).GetUnit() == eCSSUnit_Integer,
                         "bad unit");
            array->Item(0).AppendToString(eCSSProperty_z_index, aString,
                                          nsCSSValue::eNormalized);
            aString.Append('/');
            array->Item(1).AppendToString(eCSSProperty_z_index, aString,
                                          nsCSSValue::eNormalized);
          }
          break;
        case nsMediaFeature::eResolution:
          {
            aString.AppendFloat(expr.mValue.GetFloatValue());
            if (expr.mValue.GetUnit() == eCSSUnit_Inch) {
              aString.AppendLiteral("dpi");
            } else if (expr.mValue.GetUnit() == eCSSUnit_Pixel) {
              aString.AppendLiteral("dppx");
            } else {
              NS_ASSERTION(expr.mValue.GetUnit() == eCSSUnit_Centimeter,
                           "bad unit");
              aString.AppendLiteral("dpcm");
            }
          }
          break;
        case nsMediaFeature::eEnumerated:
          NS_ASSERTION(expr.mValue.GetUnit() == eCSSUnit_Enumerated,
                       "bad unit");
          AppendASCIItoUTF16(
              nsCSSProps::ValueToKeyword(expr.mValue.GetIntValue(),
                                         feature->mData.mKeywordTable),
              aString);
          break;
        case nsMediaFeature::eIdent:
          NS_ASSERTION(expr.mValue.GetUnit() == eCSSUnit_Ident,
                       "bad unit");
          aString.Append(expr.mValue.GetStringBufferValue());
          break;
      }
    }

    aString.Append(')');
  }
}

nsMediaQuery*
nsMediaQuery::Clone() const
{
  return new nsMediaQuery(*this);
}

bool
nsMediaQuery::Matches(nsPresContext* aPresContext,
                      nsMediaQueryResultCacheKey* aKey) const
{
  if (mHadUnknownExpression)
    return false;

  bool match =
    mMediaType == aPresContext->Medium() || mMediaType == nsGkAtoms::all;
  for (uint32_t i = 0, i_end = mExpressions.Length(); match && i < i_end; ++i) {
    const nsMediaExpression &expr = mExpressions[i];
    nsCSSValue actual;
    nsresult rv =
      (expr.mFeature->mGetter)(aPresContext, expr.mFeature, actual);
    NS_ENSURE_SUCCESS(rv, false); // any better ideas?

    match = expr.Matches(aPresContext, actual);
    if (aKey) {
      aKey->AddExpression(&expr, match);
    }
  }

  return match == !mNegated;
}

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(nsMediaList)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsIDOMMediaList)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(nsMediaList)
NS_IMPL_CYCLE_COLLECTING_RELEASE(nsMediaList)

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE_0(nsMediaList)

nsMediaList::nsMediaList()
  : mStyleSheet(nullptr)
{
}

nsMediaList::~nsMediaList()
{
}

/* virtual */ JSObject*
nsMediaList::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return MediaListBinding::Wrap(aCx, this, aGivenProto);
}

void
nsMediaList::GetText(nsAString& aMediaText)
{
  aMediaText.Truncate();

  for (int32_t i = 0, i_end = mArray.Length(); i < i_end; ++i) {
    nsMediaQuery* query = mArray[i];

    query->AppendToString(aMediaText);

    if (i + 1 < i_end) {
      aMediaText.AppendLiteral(", ");
    }
  }
}

// XXXbz this is so ill-defined in the spec, it's not clear quite what
// it should be doing....
void
nsMediaList::SetText(const nsAString& aMediaText)
{
  nsCSSParser parser;

  bool htmlMode = mStyleSheet && mStyleSheet->GetOwnerNode();

  parser.ParseMediaList(aMediaText, nullptr, 0, this, htmlMode);
}

bool
nsMediaList::Matches(nsPresContext* aPresContext,
                     nsMediaQueryResultCacheKey* aKey)
{
  for (int32_t i = 0, i_end = mArray.Length(); i < i_end; ++i) {
    if (mArray[i]->Matches(aPresContext, aKey)) {
      return true;
    }
  }
  return mArray.IsEmpty();
}

void
nsMediaList::SetStyleSheet(CSSStyleSheet* aSheet)
{
  NS_ASSERTION(aSheet == mStyleSheet || !aSheet || !mStyleSheet,
               "multiple style sheets competing for one media list");
  mStyleSheet = aSheet;
}

already_AddRefed<nsMediaList>
nsMediaList::Clone()
{
  RefPtr<nsMediaList> result = new nsMediaList();
  result->mArray.AppendElements(mArray.Length());
  for (uint32_t i = 0, i_end = mArray.Length(); i < i_end; ++i) {
    result->mArray[i] = mArray[i]->Clone();
    MOZ_ASSERT(result->mArray[i]);
  }
  return result.forget();
}

NS_IMETHODIMP
nsMediaList::GetMediaText(nsAString& aMediaText)
{
  GetText(aMediaText);
  return NS_OK;
}

// "sheet" should be a CSSStyleSheet and "doc" should be an
// nsCOMPtr<nsIDocument>
#define BEGIN_MEDIA_CHANGE(sheet, doc)                         \
  if (sheet) {                                                 \
    doc = sheet->GetOwningDocument();                          \
  }                                                            \
  mozAutoDocUpdate updateBatch(doc, UPDATE_STYLE, true);       \
  if (sheet) {                                                 \
    sheet->WillDirty();                                        \
  }

#define END_MEDIA_CHANGE(sheet, doc)                           \
  if (sheet) {                                                 \
    sheet->DidDirty();                                         \
  }                                                            \
  /* XXXldb Pass something meaningful? */                      \
  if (doc) {                                                   \
    doc->StyleRuleChanged(sheet, nullptr);                     \
  }


NS_IMETHODIMP
nsMediaList::SetMediaText(const nsAString& aMediaText)
{
  nsCOMPtr<nsIDocument> doc;

  BEGIN_MEDIA_CHANGE(mStyleSheet, doc)

  SetText(aMediaText);
  
  END_MEDIA_CHANGE(mStyleSheet, doc)

  return NS_OK;
}
                               
NS_IMETHODIMP
nsMediaList::GetLength(uint32_t* aLength)
{
  NS_ENSURE_ARG_POINTER(aLength);

  *aLength = Length();
  return NS_OK;
}

NS_IMETHODIMP
nsMediaList::Item(uint32_t aIndex, nsAString& aReturn)
{
  bool dummy;
  IndexedGetter(aIndex, dummy, aReturn);
  return NS_OK;
}

void
nsMediaList::IndexedGetter(uint32_t aIndex, bool& aFound, nsAString& aReturn)
{
  if (aIndex < Length()) {
    aFound = true;
    aReturn.Truncate();
    mArray[aIndex]->AppendToString(aReturn);
  } else {
    aFound = false;
    SetDOMStringToNull(aReturn);
  }
}

NS_IMETHODIMP
nsMediaList::DeleteMedium(const nsAString& aOldMedium)
{
  nsresult rv = NS_OK;
  nsCOMPtr<nsIDocument> doc;

  BEGIN_MEDIA_CHANGE(mStyleSheet, doc)
  
  rv = Delete(aOldMedium);
  if (NS_FAILED(rv))
    return rv;

  END_MEDIA_CHANGE(mStyleSheet, doc)
  
  return rv;
}

NS_IMETHODIMP
nsMediaList::AppendMedium(const nsAString& aNewMedium)
{
  nsresult rv = NS_OK;
  nsCOMPtr<nsIDocument> doc;

  BEGIN_MEDIA_CHANGE(mStyleSheet, doc)
  
  rv = Append(aNewMedium);
  if (NS_FAILED(rv))
    return rv;

  END_MEDIA_CHANGE(mStyleSheet, doc)
  
  return rv;
}

nsresult
nsMediaList::Delete(const nsAString& aOldMedium)
{
  if (aOldMedium.IsEmpty())
    return NS_ERROR_DOM_NOT_FOUND_ERR;

  for (int32_t i = 0, i_end = mArray.Length(); i < i_end; ++i) {
    nsMediaQuery* query = mArray[i];

    nsAutoString buf;
    query->AppendToString(buf);
    if (buf == aOldMedium) {
      mArray.RemoveElementAt(i);
      return NS_OK;
    }
  }

  return NS_ERROR_DOM_NOT_FOUND_ERR;
}

nsresult
nsMediaList::Append(const nsAString& aNewMedium)
{
  if (aNewMedium.IsEmpty())
    return NS_ERROR_DOM_NOT_FOUND_ERR;

  Delete(aNewMedium);

  nsresult rv = NS_OK;
  nsTArray<nsAutoPtr<nsMediaQuery> > buf;
  mArray.SwapElements(buf);
  SetText(aNewMedium);
  if (mArray.Length() == 1) {
    nsMediaQuery *query = mArray[0].forget();
    if (!buf.AppendElement(query)) {
      delete query;
      rv = NS_ERROR_OUT_OF_MEMORY;
    }
  }

  mArray.SwapElements(buf);
  return rv;
}

namespace mozilla {

// -------------------------------
// CSS Style Sheet Inner Data Container
//


CSSStyleSheetInner::CSSStyleSheetInner(CSSStyleSheet* aPrimarySheet,
                                       CORSMode aCORSMode,
                                       ReferrerPolicy aReferrerPolicy,
                                       const SRIMetadata& aIntegrity)
  : StyleSheetInfo(aCORSMode, aReferrerPolicy, aIntegrity)
{
  MOZ_COUNT_CTOR(CSSStyleSheetInner);
  mSheets.AppendElement(aPrimarySheet);
}

static bool SetStyleSheetReference(css::Rule* aRule, void* aSheet)
{
  if (aRule) {
    aRule->SetStyleSheet(static_cast<CSSStyleSheet*>(aSheet));
  }
  return true;
}

struct ChildSheetListBuilder {
  RefPtr<CSSStyleSheet>* sheetSlot;
  CSSStyleSheet* parent;

  void SetParentLinks(CSSStyleSheet* aSheet) {
    aSheet->mParent = parent;
    aSheet->SetOwningDocument(parent->mDocument);
  }

  static void ReparentChildList(CSSStyleSheet* aPrimarySheet,
                                CSSStyleSheet* aFirstChild)
  {
    for (CSSStyleSheet *child = aFirstChild; child; child = child->mNext) {
      child->mParent = aPrimarySheet;
      child->SetOwningDocument(aPrimarySheet->mDocument);
    }
  }
};
  
bool
CSSStyleSheet::RebuildChildList(css::Rule* aRule, void* aBuilder)
{
  int32_t type = aRule->GetType();
  if (type < css::Rule::IMPORT_RULE) {
    // Keep going till we get to the import rules.
    return true;
  }

  if (type != css::Rule::IMPORT_RULE) {
    // We're past all the import rules; stop the enumeration.
    return false;
  }

  ChildSheetListBuilder* builder =
    static_cast<ChildSheetListBuilder*>(aBuilder);

  // XXXbz We really need to decomtaminate all this stuff.  Is there a reason
  // that I can't just QI to ImportRule and get a CSSStyleSheet
  // directly from it?
  nsCOMPtr<nsIDOMCSSImportRule> importRule(do_QueryInterface(aRule));
  NS_ASSERTION(importRule, "GetType lied");

  nsCOMPtr<nsIDOMCSSStyleSheet> childSheet;
  importRule->GetStyleSheet(getter_AddRefs(childSheet));

  // Have to do this QI to be safe, since XPConnect can fake
  // nsIDOMCSSStyleSheets
  RefPtr<CSSStyleSheet> cssSheet = do_QueryObject(childSheet);
  if (!cssSheet) {
    return true;
  }

  (*builder->sheetSlot) = cssSheet;
  builder->SetParentLinks(*builder->sheetSlot);
  builder->sheetSlot = &(*builder->sheetSlot)->mNext;
  return true;
}

size_t
CSSStyleSheet::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const
{
  size_t n = 0;
  const CSSStyleSheet* s = this;
  while (s) {
    n += aMallocSizeOf(s);

    // Each inner can be shared by multiple sheets.  So we only count the inner
    // if this sheet is the last one in the list of those sharing it.  As a
    // result, the last such sheet takes all the blame for the memory
    // consumption of the inner, which isn't ideal but it's better than
    // double-counting the inner.  We use last instead of first since the first
    // sheet may be held in the nsXULPrototypeCache and not used in a window at
    // all.
    if (s->mInner->mSheets.LastElement() == s) {
      n += s->mInner->SizeOfIncludingThis(aMallocSizeOf);
    }

    // Measurement of the following members may be added later if DMD finds it
    // is worthwhile:
    // - s->mTitle
    // - s->mMedia
    // - s->mRuleCollection
    // - s->mRuleProcessors
    //
    // The following members are not measured:
    // - s->mOwnerRule, because it's non-owning

    s = s->mNext;
  }
  return n;
}

CSSStyleSheetInner::CSSStyleSheetInner(CSSStyleSheetInner& aCopy,
                                       CSSStyleSheet* aPrimarySheet)
  : StyleSheetInfo(aCopy)
{
  MOZ_COUNT_CTOR(CSSStyleSheetInner);
  AddSheet(aPrimarySheet);
  aCopy.mOrderedRules.EnumerateForwards(css::GroupRule::CloneRuleInto, &mOrderedRules);
  mOrderedRules.EnumerateForwards(SetStyleSheetReference, aPrimarySheet);

  ChildSheetListBuilder builder = { &mFirstChild, aPrimarySheet };
  mOrderedRules.EnumerateForwards(CSSStyleSheet::RebuildChildList, &builder);

  RebuildNameSpaces();
}

CSSStyleSheetInner::~CSSStyleSheetInner()
{
  MOZ_COUNT_DTOR(CSSStyleSheetInner);
  mOrderedRules.EnumerateForwards(SetStyleSheetReference, nullptr);
}

CSSStyleSheetInner*
CSSStyleSheetInner::CloneFor(CSSStyleSheet* aPrimarySheet)
{
  return new CSSStyleSheetInner(*this, aPrimarySheet);
}

void
CSSStyleSheetInner::AddSheet(CSSStyleSheet* aSheet)
{
  mSheets.AppendElement(aSheet);
}

void
CSSStyleSheetInner::RemoveSheet(CSSStyleSheet* aSheet)
{
  if (1 == mSheets.Length()) {
    NS_ASSERTION(aSheet == mSheets.ElementAt(0), "bad parent");
    delete this;
    return;
  }
  if (aSheet == mSheets.ElementAt(0)) {
    mSheets.RemoveElementAt(0);
    NS_ASSERTION(mSheets.Length(), "no parents");
    mOrderedRules.EnumerateForwards(SetStyleSheetReference,
                                    mSheets.ElementAt(0));

    ChildSheetListBuilder::ReparentChildList(mSheets[0], mFirstChild);
  }
  else {
    mSheets.RemoveElement(aSheet);
  }
}

static void
AddNamespaceRuleToMap(css::Rule* aRule, nsXMLNameSpaceMap* aMap)
{
  NS_ASSERTION(aRule->GetType() == css::Rule::NAMESPACE_RULE, "Bogus rule type");

  RefPtr<css::NameSpaceRule> nameSpaceRule = do_QueryObject(aRule);

  nsAutoString  urlSpec;
  nameSpaceRule->GetURLSpec(urlSpec);

  aMap->AddPrefix(nameSpaceRule->GetPrefix(), urlSpec);
}

static bool
CreateNameSpace(css::Rule* aRule, void* aNameSpacePtr)
{
  int32_t type = aRule->GetType();
  if (css::Rule::NAMESPACE_RULE == type) {
    AddNamespaceRuleToMap(aRule,
                          static_cast<nsXMLNameSpaceMap*>(aNameSpacePtr));
    return true;
  }
  // stop if not namespace, import or charset because namespace can't follow
  // anything else
  return (css::Rule::CHARSET_RULE == type || css::Rule::IMPORT_RULE == type);
}

void 
CSSStyleSheetInner::RebuildNameSpaces()
{
  // Just nuke our existing namespace map, if any
  if (NS_SUCCEEDED(CreateNamespaceMap())) {
    mOrderedRules.EnumerateForwards(CreateNameSpace, mNameSpaceMap);
  }
}

nsresult
CSSStyleSheetInner::CreateNamespaceMap()
{
  mNameSpaceMap = nsXMLNameSpaceMap::Create(false);
  NS_ENSURE_TRUE(mNameSpaceMap, NS_ERROR_OUT_OF_MEMORY);
  // Override the default namespace map behavior for the null prefix to
  // return the wildcard namespace instead of the null namespace.
  mNameSpaceMap->AddPrefix(nullptr, kNameSpaceID_Unknown);
  return NS_OK;
}

size_t
CSSStyleSheetInner::SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const
{
  size_t n = aMallocSizeOf(this);
  n += mOrderedRules.ShallowSizeOfExcludingThis(aMallocSizeOf);
  for (size_t i = 0; i < mOrderedRules.Length(); i++) {
    n += mOrderedRules[i]->SizeOfIncludingThis(aMallocSizeOf);
  }
  n += mFirstChild ? mFirstChild->SizeOfIncludingThis(aMallocSizeOf) : 0;

  // Measurement of the following members may be added later if DMD finds it is
  // worthwhile:
  // - mSheetURI
  // - mOriginalSheetURI
  // - mBaseURI
  // - mPrincipal
  // - mNameSpaceMap
  //
  // The following members are not measured:
  // - mSheets, because it's non-owning

  return n;
}

// -------------------------------
// CSS Style Sheet
//

CSSStyleSheet::CSSStyleSheet(css::SheetParsingMode aParsingMode,
                             CORSMode aCORSMode, ReferrerPolicy aReferrerPolicy)
  : StyleSheet(StyleBackendType::Gecko, aParsingMode),
    mParent(nullptr),
    mOwnerRule(nullptr),
    mDirty(false),
    mInRuleProcessorCache(false),
    mScopeElement(nullptr),
    mRuleProcessors(nullptr)
{
  mInner = new CSSStyleSheetInner(this, aCORSMode, aReferrerPolicy,
                                  SRIMetadata());
}

CSSStyleSheet::CSSStyleSheet(css::SheetParsingMode aParsingMode,
                             CORSMode aCORSMode,
                             ReferrerPolicy aReferrerPolicy,
                             const SRIMetadata& aIntegrity)
  : StyleSheet(StyleBackendType::Gecko, aParsingMode),
    mParent(nullptr),
    mOwnerRule(nullptr),
    mDirty(false),
    mInRuleProcessorCache(false),
    mScopeElement(nullptr),
    mRuleProcessors(nullptr)
{
  mInner = new CSSStyleSheetInner(this, aCORSMode, aReferrerPolicy,
                                  aIntegrity);
}

CSSStyleSheet::CSSStyleSheet(const CSSStyleSheet& aCopy,
                             CSSStyleSheet* aParentToUse,
                             css::ImportRule* aOwnerRuleToUse,
                             nsIDocument* aDocumentToUse,
                             nsINode* aOwningNodeToUse)
  : StyleSheet(aCopy, aDocumentToUse, aOwningNodeToUse),
    mParent(aParentToUse),
    mOwnerRule(aOwnerRuleToUse),
    mDirty(aCopy.mDirty),
    mInRuleProcessorCache(false),
    mScopeElement(nullptr),
    mInner(aCopy.mInner),
    mRuleProcessors(nullptr)
{

  mInner->AddSheet(this);

  if (mDirty) { // CSSOM's been there, force full copy now
    NS_ASSERTION(mInner->mComplete, "Why have rules been accessed on an incomplete sheet?");
    // FIXME: handle failure?
    EnsureUniqueInner();
  }

  if (aCopy.mMedia) {
    // XXX This is wrong; we should be keeping @import rules and
    // sheets in sync!
    mMedia = aCopy.mMedia->Clone();
  }
}

CSSStyleSheet::~CSSStyleSheet()
{
  for (CSSStyleSheet* child = mInner->mFirstChild;
       child;
       child = child->mNext) {
    // XXXbz this is a little bogus; see the XXX comment where we
    // declare mFirstChild.
    if (child->mParent == this) {
      child->mParent = nullptr;
      child->mDocument = nullptr;
    }
  }
  DropRuleCollection();
  DropMedia();
  mInner->RemoveSheet(this);
  // XXX The document reference is not reference counted and should
  // not be released. The document will let us know when it is going
  // away.
  if (mRuleProcessors) {
    NS_ASSERTION(mRuleProcessors->Length() == 0, "destructing sheet with rule processor reference");
    delete mRuleProcessors; // weak refs, should be empty here anyway
  }
  if (mInRuleProcessorCache) {
    RuleProcessorCache::RemoveSheet(this);
  }
}

void
CSSStyleSheet::DropRuleCollection()
{
  if (mRuleCollection) {
    mRuleCollection->DropReference();
    mRuleCollection = nullptr;
  }
}

void
CSSStyleSheet::DropMedia()
{
  if (mMedia) {
    mMedia->SetStyleSheet(nullptr);
    mMedia = nullptr;
  }
}

void
CSSStyleSheet::UnlinkInner()
{
  // We can only have a cycle through our inner if we have a unique inner,
  // because otherwise there are no JS wrappers for anything in the inner.
  if (mInner->mSheets.Length() != 1) {
    return;
  }

  mInner->mOrderedRules.EnumerateForwards(SetStyleSheetReference, nullptr);
  mInner->mOrderedRules.Clear();

  // Have to be a bit careful with child sheets, because we want to
  // drop their mNext pointers and null out their mParent and
  // mDocument, but don't want to work with deleted objects.  And we
  // don't want to do any addrefing in the process, just to make sure
  // we don't confuse the cycle collector (though on the face of it,
  // addref/release pairs during unlink should probably be ok).
  RefPtr<CSSStyleSheet> child;
  child.swap(mInner->mFirstChild);
  while (child) {
    MOZ_ASSERT(child->mParent == this, "We have a unique inner!");
    child->mParent = nullptr;
    child->mDocument = nullptr;
    RefPtr<CSSStyleSheet> next;
    // Null out child->mNext, but don't let it die yet
    next.swap(child->mNext);
    // Switch to looking at the old value of child->mNext next iteration
    child.swap(next);
    // "next" is now our previous value of child; it'll get released
    // as we loop around.
  }
}

void
CSSStyleSheet::TraverseInner(nsCycleCollectionTraversalCallback &cb)
{
  // We can only have a cycle through our inner if we have a unique inner,
  // because otherwise there are no JS wrappers for anything in the inner.
  if (mInner->mSheets.Length() != 1) {
    return;
  }

  RefPtr<CSSStyleSheet>* childSheetSlot = &mInner->mFirstChild;
  while (*childSheetSlot) {
    NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "child sheet");
    cb.NoteXPCOMChild(NS_ISUPPORTS_CAST(nsIDOMCSSStyleSheet*, childSheetSlot->get()));
    childSheetSlot = &(*childSheetSlot)->mNext;
  }

  const nsCOMArray<css::Rule>& rules = mInner->mOrderedRules;
  for (int32_t i = 0, count = rules.Count(); i < count; ++i) {
    NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "mOrderedRules[i]");
    cb.NoteXPCOMChild(rules[i]->GetExistingDOMRule());
  }
}

// QueryInterface implementation for CSSStyleSheet
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(CSSStyleSheet)
  NS_INTERFACE_MAP_ENTRY(nsICSSLoaderObserver)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, StyleSheet)
  if (aIID.Equals(NS_GET_IID(CSSStyleSheet)))
    foundInterface = reinterpret_cast<nsISupports*>(this);
  else
NS_INTERFACE_MAP_END_INHERITING(StyleSheet)

NS_IMPL_ADDREF_INHERITED(CSSStyleSheet, StyleSheet)
NS_IMPL_RELEASE_INHERITED(CSSStyleSheet, StyleSheet)

NS_IMPL_CYCLE_COLLECTION_CLASS(CSSStyleSheet)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(CSSStyleSheet)
  tmp->DropMedia();
  // We do not unlink mNext; our parent will handle that.  If we
  // unlinked it here, our parent would not be able to walk its list
  // of child sheets and null out the back-references to it, if we got
  // unlinked before it does.
  tmp->DropRuleCollection();
  tmp->UnlinkInner();
  tmp->mScopeElement = nullptr;
NS_IMPL_CYCLE_COLLECTION_UNLINK_END_INHERITED(StyleSheet)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(CSSStyleSheet, StyleSheet)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mMedia)
  // We do not traverse mNext; our parent will handle that.  See
  // comments in Unlink for why.
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mRuleCollection)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mScopeElement)
  tmp->TraverseInner(cb);
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

nsresult
CSSStyleSheet::AddRuleProcessor(nsCSSRuleProcessor* aProcessor)
{
  if (! mRuleProcessors) {
    mRuleProcessors = new AutoTArray<nsCSSRuleProcessor*, 8>();
    if (!mRuleProcessors)
      return NS_ERROR_OUT_OF_MEMORY;
  }
  NS_ASSERTION(mRuleProcessors->NoIndex == mRuleProcessors->IndexOf(aProcessor),
               "processor already registered");
  mRuleProcessors->AppendElement(aProcessor); // weak ref
  return NS_OK;
}

nsresult
CSSStyleSheet::DropRuleProcessor(nsCSSRuleProcessor* aProcessor)
{
  if (!mRuleProcessors)
    return NS_ERROR_FAILURE;
  return mRuleProcessors->RemoveElement(aProcessor)
           ? NS_OK
           : NS_ERROR_FAILURE;
}

void
CSSStyleSheet::AddStyleSet(nsStyleSet* aStyleSet)
{
  NS_ASSERTION(!mStyleSets.Contains(aStyleSet),
               "style set already registered");
  mStyleSets.AppendElement(aStyleSet);
}

void
CSSStyleSheet::DropStyleSet(nsStyleSet* aStyleSet)
{
  DebugOnly<bool> found = mStyleSets.RemoveElement(aStyleSet);
  NS_ASSERTION(found, "didn't find style set");
}

bool
CSSStyleSheet::UseForPresentation(nsPresContext* aPresContext,
                                  nsMediaQueryResultCacheKey& aKey) const
{
  if (mMedia) {
    return mMedia->Matches(aPresContext, &aKey);
  }
  return true;
}


void
CSSStyleSheet::SetMedia(nsMediaList* aMedia)
{
  mMedia = aMedia;
}

bool
CSSStyleSheet::HasRules() const
{
  return StyleRuleCount() != 0;
}

void
CSSStyleSheet::SetEnabled(bool aEnabled)
{
  // Internal method, so callers must handle BeginUpdate/EndUpdate
  bool oldDisabled = mDisabled;
  mDisabled = !aEnabled;

  if (mInner->mComplete && oldDisabled != mDisabled) {
    ClearRuleCascades();

    if (mDocument) {
      mDocument->SetStyleSheetApplicableState(this, !mDisabled);
    }
  }
}

CSSStyleSheet*
CSSStyleSheet::GetParentSheet() const
{
  return mParent;
}

void
CSSStyleSheet::SetOwningDocument(nsIDocument* aDocument)
{ // not ref counted
  mDocument = aDocument;
  // Now set the same document on all our child sheets....
  // XXXbz this is a little bogus; see the XXX comment where we
  // declare mFirstChild.
  for (CSSStyleSheet* child = mInner->mFirstChild;
       child; child = child->mNext) {
    if (child->mParent == this) {
      child->SetOwningDocument(aDocument);
    }
  }
}

uint64_t
CSSStyleSheet::FindOwningWindowInnerID() const
{
  uint64_t windowID = 0;
  if (mDocument) {
    windowID = mDocument->InnerWindowID();
  }

  if (windowID == 0 && mOwningNode) {
    windowID = mOwningNode->OwnerDoc()->InnerWindowID();
  }

  if (windowID == 0 && mOwnerRule) {
    RefPtr<CSSStyleSheet> sheet = static_cast<css::Rule*>(mOwnerRule)->GetStyleSheet();
    if (sheet) {
      windowID = sheet->FindOwningWindowInnerID();
    }
  }

  if (windowID == 0 && mParent) {
    windowID = mParent->FindOwningWindowInnerID();
  }

  return windowID;
}

void
CSSStyleSheet::AppendStyleSheet(CSSStyleSheet* aSheet)
{
  NS_PRECONDITION(nullptr != aSheet, "null arg");

  WillDirty();
  RefPtr<CSSStyleSheet>* tail = &mInner->mFirstChild;
  while (*tail) {
    tail = &(*tail)->mNext;
  }
  *tail = aSheet;

  // This is not reference counted. Our parent tells us when
  // it's going away.
  aSheet->mParent = this;
  aSheet->mDocument = mDocument;
  DidDirty();
}

void
CSSStyleSheet::AppendStyleRule(css::Rule* aRule)
{
  NS_PRECONDITION(nullptr != aRule, "null arg");

  WillDirty();
  mInner->mOrderedRules.AppendObject(aRule);
  aRule->SetStyleSheet(this);
  DidDirty();

  if (css::Rule::NAMESPACE_RULE == aRule->GetType()) {
#ifdef DEBUG
    nsresult rv =
#endif
      RegisterNamespaceRule(aRule);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                         "RegisterNamespaceRule returned error");
  }
}

int32_t
CSSStyleSheet::StyleRuleCount() const
{
  return mInner->mOrderedRules.Count();
}

css::Rule*
CSSStyleSheet::GetStyleRuleAt(int32_t aIndex) const
{
  // Important: If this function is ever made scriptable, we must add
  // a security check here. See GetCssRules below for an example.
  return mInner->mOrderedRules.SafeObjectAt(aIndex);
}

void
CSSStyleSheet::EnsureUniqueInner()
{
  mDirty = true;

  MOZ_ASSERT(mInner->mSheets.Length() != 0,
             "unexpected number of outers");
  if (mInner->mSheets.Length() == 1) {
    // already unique
    return;
  }
  CSSStyleSheetInner* clone = mInner->CloneFor(this);
  MOZ_ASSERT(clone);
  mInner->RemoveSheet(this);
  mInner = clone;

  // otherwise the rule processor has pointers to the old rules
  ClearRuleCascades();

  // let our containing style sets know that if we call
  // nsPresContext::EnsureSafeToHandOutCSSRules we will need to restyle the
  // document
  for (nsStyleSet* styleSet : mStyleSets) {
    styleSet->SetNeedsRestyleAfterEnsureUniqueInner();
  }
}

void
CSSStyleSheet::AppendAllChildSheets(nsTArray<CSSStyleSheet*>& aArray)
{
  for (CSSStyleSheet* child = mInner->mFirstChild; child;
       child = child->mNext) {
    aArray.AppendElement(child);
  }
}

already_AddRefed<CSSStyleSheet>
CSSStyleSheet::Clone(CSSStyleSheet* aCloneParent,
                     css::ImportRule* aCloneOwnerRule,
                     nsIDocument* aCloneDocument,
                     nsINode* aCloneOwningNode) const
{
  RefPtr<CSSStyleSheet> clone = new CSSStyleSheet(*this,
                                                    aCloneParent,
                                                    aCloneOwnerRule,
                                                    aCloneDocument,
                                                    aCloneOwningNode);
  return clone.forget();
}

#ifdef DEBUG
static void
ListRules(const nsCOMArray<css::Rule>& aRules, FILE* aOut, int32_t aIndent)
{
  for (int32_t index = aRules.Count() - 1; index >= 0; --index) {
    aRules.ObjectAt(index)->List(aOut, aIndent);
  }
}

struct ListEnumData {
  ListEnumData(FILE* aOut, int32_t aIndent)
    : mOut(aOut),
      mIndent(aIndent)
  {
  }
  FILE*   mOut;
  int32_t mIndent;
};

void
CSSStyleSheet::List(FILE* out, int32_t aIndent) const
{

  int32_t index;

  // Indent
  nsAutoCString str;
  for (index = aIndent; --index >= 0; ) {
    str.AppendLiteral("  ");
  }

  str.AppendLiteral("CSS Style Sheet: ");
  nsAutoCString urlSpec;
  nsresult rv = mInner->mSheetURI->GetSpec(urlSpec);
  if (NS_SUCCEEDED(rv) && !urlSpec.IsEmpty()) {
    str.Append(urlSpec);
  }

  if (mMedia) {
    str.AppendLiteral(" media: ");
    nsAutoString  buffer;
    mMedia->GetText(buffer);
    AppendUTF16toUTF8(buffer, str);
  }
  str.Append('\n');
  fprintf_stderr(out, "%s", str.get());

  for (const CSSStyleSheet* child = mInner->mFirstChild;
       child;
       child = child->mNext) {
    child->List(out, aIndent + 1);
  }

  fprintf_stderr(out, "%s", "Rules in source order:\n");
  ListRules(mInner->mOrderedRules, out, aIndent);
}
#endif

void 
CSSStyleSheet::ClearRuleCascades()
{
  // We might be in ClearRuleCascades because we had a modification
  // to the sheet that resulted in an nsCSSSelector being destroyed.
  // Tell the RestyleManager for each document we're used in
  // so that they can drop any nsCSSSelector pointers (used for
  // eRestyle_SomeDescendants) in their mPendingRestyles.
  for (nsStyleSet* styleSet : mStyleSets) {
    styleSet->ClearSelectors();
  }

  bool removedSheetFromRuleProcessorCache = false;
  if (mRuleProcessors) {
    nsCSSRuleProcessor **iter = mRuleProcessors->Elements(),
                       **end = iter + mRuleProcessors->Length();
    for(; iter != end; ++iter) {
      if (!removedSheetFromRuleProcessorCache && (*iter)->IsShared()) {
        // Since the sheet has been modified, we need to remove all
        // RuleProcessorCache entries that contain this sheet, as the
        // list of @-moz-document rules might have changed.
        RuleProcessorCache::RemoveSheet(this);
        removedSheetFromRuleProcessorCache = true;
      }
      (*iter)->ClearRuleCascades();
    }
  }
  if (mParent) {
    CSSStyleSheet* parent = (CSSStyleSheet*)mParent;
    parent->ClearRuleCascades();
  }
}

void
CSSStyleSheet::WillDirty()
{
  if (mInner->mComplete) {
    EnsureUniqueInner();
  }
}

void
CSSStyleSheet::DidDirty()
{
  MOZ_ASSERT(!mInner->mComplete || mDirty,
             "caller must have called WillDirty()");
  ClearRuleCascades();
}

nsresult
CSSStyleSheet::RegisterNamespaceRule(css::Rule* aRule)
{
  if (!mInner->mNameSpaceMap) {
    nsresult rv = mInner->CreateNamespaceMap();
    NS_ENSURE_SUCCESS(rv, rv);
  }

  AddNamespaceRuleToMap(aRule, mInner->mNameSpaceMap);
  return NS_OK;
}

nsMediaList*
CSSStyleSheet::Media()
{
  if (!mMedia) {
    mMedia = new nsMediaList();
    mMedia->SetStyleSheet(this);
  }

  return mMedia;
}

nsIDOMCSSRule*
CSSStyleSheet::GetDOMOwnerRule() const
{
  return mOwnerRule ? mOwnerRule->GetDOMRule() : nullptr;
}

CSSRuleList*
CSSStyleSheet::GetCssRulesInternal(ErrorResult& aRv)
{
  if (!mRuleCollection) {
    mRuleCollection = new CSSRuleListImpl(this);
  }
  return mRuleCollection;
}

static bool
RuleHasPendingChildSheet(css::Rule *cssRule)
{
  nsCOMPtr<nsIDOMCSSImportRule> importRule(do_QueryInterface(cssRule));
  NS_ASSERTION(importRule, "Rule which has type IMPORT_RULE and does not implement nsIDOMCSSImportRule!");
  nsCOMPtr<nsIDOMCSSStyleSheet> childSheet;
  importRule->GetStyleSheet(getter_AddRefs(childSheet));
  RefPtr<CSSStyleSheet> cssSheet = do_QueryObject(childSheet);
  return cssSheet != nullptr && !cssSheet->IsComplete();
}

uint32_t
CSSStyleSheet::InsertRuleInternal(const nsAString& aRule,
                                  uint32_t aIndex,
                                  ErrorResult& aRv)
{
  MOZ_ASSERT(mInner->mComplete);

  WillDirty();
  
  if (aIndex > uint32_t(mInner->mOrderedRules.Count())) {
    aRv.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    return 0;
  }
  
  NS_ASSERTION(uint32_t(mInner->mOrderedRules.Count()) <= INT32_MAX,
               "Too many style rules!");

  // Hold strong ref to the CSSLoader in case the document update
  // kills the document
  RefPtr<css::Loader> loader;
  if (mDocument) {
    loader = mDocument->CSSLoader();
    NS_ASSERTION(loader, "Document with no CSS loader!");
  }

  nsCSSParser css(loader, this);

  mozAutoDocUpdate updateBatch(mDocument, UPDATE_STYLE, true);

  RefPtr<css::Rule> rule;
  aRv = css.ParseRule(aRule, mInner->mSheetURI, mInner->mBaseURI,
                      mInner->mPrincipal, getter_AddRefs(rule));
  if (NS_WARN_IF(aRv.Failed())) {
    return 0;
  }

  // Hierarchy checking.
  int32_t newType = rule->GetType();

  // check that we're not inserting before a charset rule
  css::Rule* nextRule = mInner->mOrderedRules.SafeObjectAt(aIndex);
  if (nextRule) {
    int32_t nextType = nextRule->GetType();
    if (nextType == css::Rule::CHARSET_RULE) {
      aRv.Throw(NS_ERROR_DOM_HIERARCHY_REQUEST_ERR);
      return 0;
    }

    if (nextType == css::Rule::IMPORT_RULE &&
        newType != css::Rule::CHARSET_RULE &&
        newType != css::Rule::IMPORT_RULE) {
      aRv.Throw(NS_ERROR_DOM_HIERARCHY_REQUEST_ERR);
      return 0;
    }

    if (nextType == css::Rule::NAMESPACE_RULE &&
        newType != css::Rule::CHARSET_RULE &&
        newType != css::Rule::IMPORT_RULE &&
        newType != css::Rule::NAMESPACE_RULE) {
      aRv.Throw(NS_ERROR_DOM_HIERARCHY_REQUEST_ERR);
      return 0;
    }
  }

  if (aIndex != 0) {
    // no inserting charset at nonzero position
    if (newType == css::Rule::CHARSET_RULE) {
      aRv.Throw(NS_ERROR_DOM_HIERARCHY_REQUEST_ERR);
      return 0;
    }

    css::Rule* prevRule = mInner->mOrderedRules.SafeObjectAt(aIndex - 1);
    int32_t prevType = prevRule->GetType();

    if (newType == css::Rule::IMPORT_RULE &&
        prevType != css::Rule::CHARSET_RULE &&
        prevType != css::Rule::IMPORT_RULE) {
      aRv.Throw(NS_ERROR_DOM_HIERARCHY_REQUEST_ERR);
      return 0;
    }

    if (newType == css::Rule::NAMESPACE_RULE &&
        prevType != css::Rule::CHARSET_RULE &&
        prevType != css::Rule::IMPORT_RULE &&
        prevType != css::Rule::NAMESPACE_RULE) {
      aRv.Throw(NS_ERROR_DOM_HIERARCHY_REQUEST_ERR);
      return 0;
    }
  }

  if (!mInner->mOrderedRules.InsertObjectAt(rule, aIndex)) {
    aRv.Throw(NS_ERROR_OUT_OF_MEMORY);
    return 0;
  }

  DidDirty();

  rule->SetStyleSheet(this);

  int32_t type = rule->GetType();
  if (type == css::Rule::NAMESPACE_RULE) {
    // XXXbz does this screw up when inserting a namespace rule before
    // another namespace rule that binds the same prefix to a different
    // namespace?
    aRv = RegisterNamespaceRule(rule);
    if (NS_WARN_IF(aRv.Failed())) {
      return 0;
    }
  }

  // We don't notify immediately for @import rules, but rather when
  // the sheet the rule is importing is loaded (see StyleSheetLoaded)
  if ((type != css::Rule::IMPORT_RULE || !RuleHasPendingChildSheet(rule)) &&
      mDocument) {
    mDocument->StyleRuleAdded(this, rule);
  }

  return aIndex;
}

void
CSSStyleSheet::DeleteRuleInternal(uint32_t aIndex, ErrorResult& aRv)
{
  // XXX TBI: handle @rule types
  mozAutoDocUpdate updateBatch(mDocument, UPDATE_STYLE, true);
    
  WillDirty();

  if (aIndex >= uint32_t(mInner->mOrderedRules.Count())) {
    aRv.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    return;
  }

  NS_ASSERTION(uint32_t(mInner->mOrderedRules.Count()) <= INT32_MAX,
               "Too many style rules!");

  // Hold a strong ref to the rule so it doesn't die when we RemoveObjectAt
  RefPtr<css::Rule> rule = mInner->mOrderedRules.ObjectAt(aIndex);
  if (rule) {
    mInner->mOrderedRules.RemoveObjectAt(aIndex);
    if (mDocument && mDocument->StyleSheetChangeEventsEnabled()) {
      // Force creation of the DOM rule, so that it can be put on the
      // StyleRuleRemoved event object.
      rule->GetDOMRule();
    }
    rule->SetStyleSheet(nullptr);
    DidDirty();

    if (mDocument) {
      mDocument->StyleRuleRemoved(this, rule);
    }
  }
}

nsresult
CSSStyleSheet::DeleteRuleFromGroup(css::GroupRule* aGroup, uint32_t aIndex)
{
  NS_ENSURE_ARG_POINTER(aGroup);
  NS_ASSERTION(mInner->mComplete, "No deleting from an incomplete sheet!");
  RefPtr<css::Rule> rule = aGroup->GetStyleRuleAt(aIndex);
  NS_ENSURE_TRUE(rule, NS_ERROR_ILLEGAL_VALUE);

  // check that the rule actually belongs to this sheet!
  if (this != rule->GetStyleSheet()) {
    return NS_ERROR_INVALID_ARG;
  }

  mozAutoDocUpdate updateBatch(mDocument, UPDATE_STYLE, true);
  
  WillDirty();

  nsresult result = aGroup->DeleteStyleRuleAt(aIndex);
  NS_ENSURE_SUCCESS(result, result);
  
  rule->SetStyleSheet(nullptr);
  
  DidDirty();

  if (mDocument) {
    mDocument->StyleRuleRemoved(this, rule);
  }

  return NS_OK;
}

nsresult
CSSStyleSheet::InsertRuleIntoGroup(const nsAString & aRule,
                                   css::GroupRule* aGroup,
                                   uint32_t aIndex,
                                   uint32_t* _retval)
{
  NS_ASSERTION(mInner->mComplete, "No inserting into an incomplete sheet!");
  // check that the group actually belongs to this sheet!
  if (this != aGroup->GetStyleSheet()) {
    return NS_ERROR_INVALID_ARG;
  }

  // Hold strong ref to the CSSLoader in case the document update
  // kills the document
  RefPtr<css::Loader> loader;
  if (mDocument) {
    loader = mDocument->CSSLoader();
    NS_ASSERTION(loader, "Document with no CSS loader!");
  }

  nsCSSParser css(loader, this);

  // parse and grab the rule
  mozAutoDocUpdate updateBatch(mDocument, UPDATE_STYLE, true);

  WillDirty();

  RefPtr<css::Rule> rule;
  nsresult result = css.ParseRule(aRule, mInner->mSheetURI, mInner->mBaseURI,
                                  mInner->mPrincipal, getter_AddRefs(rule));
  if (NS_FAILED(result))
    return result;

  switch (rule->GetType()) {
    case css::Rule::STYLE_RULE:
    case css::Rule::MEDIA_RULE:
    case css::Rule::FONT_FACE_RULE:
    case css::Rule::PAGE_RULE:
    case css::Rule::KEYFRAMES_RULE:
    case css::Rule::COUNTER_STYLE_RULE:
    case css::Rule::DOCUMENT_RULE:
    case css::Rule::SUPPORTS_RULE:
      // these types are OK to insert into a group
      break;
    case css::Rule::CHARSET_RULE:
    case css::Rule::IMPORT_RULE:
    case css::Rule::NAMESPACE_RULE:
      // these aren't
      return NS_ERROR_DOM_HIERARCHY_REQUEST_ERR;
    default:
      NS_NOTREACHED("unexpected rule type");
      return NS_ERROR_DOM_HIERARCHY_REQUEST_ERR;
  }

  result = aGroup->InsertStyleRuleAt(aIndex, rule);
  NS_ENSURE_SUCCESS(result, result);
  DidDirty();

  if (mDocument) {
    mDocument->StyleRuleAdded(this, rule);
  }

  *_retval = aIndex;
  return NS_OK;
}

// nsICSSLoaderObserver implementation
NS_IMETHODIMP
CSSStyleSheet::StyleSheetLoaded(StyleSheet* aSheet,
                                bool aWasAlternate,
                                nsresult aStatus)
{
  MOZ_ASSERT(aSheet->IsGecko(),
             "why we were called back with a ServoStyleSheet?");

  CSSStyleSheet* sheet = aSheet->AsGecko();

  if (sheet->GetParentSheet() == nullptr) {
    return NS_OK; // ignore if sheet has been detached already (see parseSheet)
  }
  NS_ASSERTION(this == sheet->GetParentSheet(),
               "We are being notified of a sheet load for a sheet that is not our child!");

  if (mDocument && NS_SUCCEEDED(aStatus)) {
    mozAutoDocUpdate updateBatch(mDocument, UPDATE_STYLE, true);

    // XXXldb @import rules shouldn't even implement nsIStyleRule (but
    // they do)!
    mDocument->StyleRuleAdded(this, sheet->GetOwnerRule());
  }

  return NS_OK;
}

nsresult
CSSStyleSheet::ReparseSheet(const nsAString& aInput)
{
  // Not doing this if the sheet is not complete!
  if (!mInner->mComplete) {
    return NS_ERROR_DOM_INVALID_ACCESS_ERR;
  }

  // Hold strong ref to the CSSLoader in case the document update
  // kills the document
  RefPtr<css::Loader> loader;
  if (mDocument) {
    loader = mDocument->CSSLoader();
    NS_ASSERTION(loader, "Document with no CSS loader!");
  } else {
    loader = new css::Loader(StyleBackendType::Gecko);
  }

  mozAutoDocUpdate updateBatch(mDocument, UPDATE_STYLE, true);

  WillDirty();

  // detach existing rules (including child sheets via import rules)
  css::LoaderReusableStyleSheets reusableSheets;
  int ruleCount;
  while ((ruleCount = mInner->mOrderedRules.Count()) != 0) {
    RefPtr<css::Rule> rule = mInner->mOrderedRules.ObjectAt(ruleCount - 1);
    mInner->mOrderedRules.RemoveObjectAt(ruleCount - 1);
    rule->SetStyleSheet(nullptr);
    if (rule->GetType() == css::Rule::IMPORT_RULE) {
      nsCOMPtr<nsIDOMCSSImportRule> importRule(do_QueryInterface(rule));
      NS_ASSERTION(importRule, "GetType lied");

      nsCOMPtr<nsIDOMCSSStyleSheet> childSheet;
      importRule->GetStyleSheet(getter_AddRefs(childSheet));

      RefPtr<CSSStyleSheet> cssSheet = do_QueryObject(childSheet);
      if (cssSheet && cssSheet->GetOriginalURI()) {
        reusableSheets.AddReusableSheet(cssSheet);
      }
    }
    if (mDocument) {
      mDocument->StyleRuleRemoved(this, rule);
    }
  }

  // nuke child sheets list and current namespace map
  for (CSSStyleSheet* child = mInner->mFirstChild; child; ) {
    NS_ASSERTION(child->mParent == this, "Child sheet is not parented to this!");
    CSSStyleSheet* next = child->mNext;
    child->mParent = nullptr;
    child->mDocument = nullptr;
    child->mNext = nullptr;
    child = next;
  }
  mInner->mFirstChild = nullptr;
  mInner->mNameSpaceMap = nullptr;

  uint32_t lineNumber = 1;
  if (mOwningNode) {
    nsCOMPtr<nsIStyleSheetLinkingElement> link = do_QueryInterface(mOwningNode);
    if (link) {
      lineNumber = link->GetLineNumber();
    }
  }

  nsCSSParser parser(loader, this);
  nsresult rv = parser.ParseSheet(aInput, mInner->mSheetURI, mInner->mBaseURI,
                                  mInner->mPrincipal, lineNumber, &reusableSheets);
  DidDirty(); // we are always 'dirty' here since we always remove rules first
  NS_ENSURE_SUCCESS(rv, rv);

  // notify document of all new rules
  if (mDocument) {
    for (int32_t index = 0; index < mInner->mOrderedRules.Count(); ++index) {
      RefPtr<css::Rule> rule = mInner->mOrderedRules.ObjectAt(index);
      if (rule->GetType() == css::Rule::IMPORT_RULE &&
          RuleHasPendingChildSheet(rule)) {
        continue; // notify when loaded (see StyleSheetLoaded)
      }
      mDocument->StyleRuleAdded(this, rule);
    }
  }
  return NS_OK;
}

} // namespace mozilla
