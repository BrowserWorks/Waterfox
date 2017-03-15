/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ServoBindings.h"

#include "ChildIterator.h"
#include "StyleStructContext.h"
#include "gfxFontFamilyList.h"
#include "nsAttrValueInlines.h"
#include "nsCSSRuleProcessor.h"
#include "nsContentUtils.h"
#include "nsDOMTokenList.h"
#include "nsIContentInlines.h"
#include "nsIDOMNode.h"
#include "nsIDocument.h"
#include "nsIFrame.h"
#include "nsINode.h"
#include "nsIPrincipal.h"
#include "nsNameSpaceManager.h"
#include "nsRuleNode.h"
#include "nsString.h"
#include "nsStyleStruct.h"
#include "nsStyleUtil.h"
#include "nsTArray.h"

#include "mozilla/EventStates.h"
#include "mozilla/ServoElementSnapshot.h"
#include "mozilla/ServoRestyleManager.h"
#include "mozilla/StyleAnimationValue.h"
#include "mozilla/DeclarationBlockInlines.h"
#include "mozilla/dom/Element.h"

using namespace mozilla;
using namespace mozilla::dom;

#define IMPL_STRONG_REF_TYPE_FOR(type_) \
  already_AddRefed<type_>               \
  type_##Strong::Consume() {            \
    RefPtr<type_> result;               \
    result.swap(mPtr);                  \
    return result.forget();             \
  }

IMPL_STRONG_REF_TYPE_FOR(ServoComputedValues)
IMPL_STRONG_REF_TYPE_FOR(RawServoStyleSheet)
IMPL_STRONG_REF_TYPE_FOR(RawServoDeclarationBlock)

#undef IMPL_STRONG_REF_TYPE_FOR

uint32_t
Gecko_ChildrenCount(RawGeckoNodeBorrowed aNode)
{
  return aNode->GetChildCount();
}

bool
Gecko_NodeIsElement(RawGeckoNodeBorrowed aNode)
{
  return aNode->IsElement();
}

RawGeckoNodeBorrowedOrNull
Gecko_GetParentNode(RawGeckoNodeBorrowed aNode)
{
  return aNode->GetFlattenedTreeParentNode();
}

RawGeckoNodeBorrowedOrNull
Gecko_GetFirstChild(RawGeckoNodeBorrowed aNode)
{
  return aNode->GetFirstChild();
}

RawGeckoNodeBorrowedOrNull
Gecko_GetLastChild(RawGeckoNodeBorrowed aNode)
{
  return aNode->GetLastChild();
}

RawGeckoNodeBorrowedOrNull
Gecko_GetPrevSibling(RawGeckoNodeBorrowed aNode)
{
  return aNode->GetPreviousSibling();
}

RawGeckoNodeBorrowedOrNull
Gecko_GetNextSibling(RawGeckoNodeBorrowed aNode)
{
  return aNode->GetNextSibling();
}

RawGeckoElementBorrowedOrNull
Gecko_GetParentElement(RawGeckoElementBorrowed aElement)
{
  nsINode* parentNode = aElement->GetFlattenedTreeParentNode();
  return parentNode->IsElement() ? parentNode->AsElement() : nullptr;
}

RawGeckoElementBorrowedOrNull
Gecko_GetFirstChildElement(RawGeckoElementBorrowed aElement)
{
  return aElement->GetFirstElementChild();
}

RawGeckoElementBorrowedOrNull Gecko_GetLastChildElement(RawGeckoElementBorrowed aElement)
{
  return aElement->GetLastElementChild();
}

RawGeckoElementBorrowedOrNull
Gecko_GetPrevSiblingElement(RawGeckoElementBorrowed aElement)
{
  return aElement->GetPreviousElementSibling();
}

RawGeckoElementBorrowedOrNull
Gecko_GetNextSiblingElement(RawGeckoElementBorrowed aElement)
{
  return aElement->GetNextElementSibling();
}

RawGeckoElementBorrowedOrNull
Gecko_GetDocumentElement(RawGeckoDocumentBorrowed aDoc)
{
  return aDoc->GetDocumentElement();
}

StyleChildrenIteratorOwnedOrNull
Gecko_MaybeCreateStyleChildrenIterator(RawGeckoNodeBorrowed aNode)
{
  if (!aNode->IsElement()) {
    return nullptr;
  }

  const Element* el = aNode->AsElement();
  return StyleChildrenIterator::IsNeeded(el) ? new StyleChildrenIterator(el)
                                             : nullptr;
}

void
Gecko_DropStyleChildrenIterator(StyleChildrenIteratorOwned aIterator)
{
  MOZ_ASSERT(aIterator);
  delete aIterator;
}

RawGeckoNodeBorrowed
Gecko_GetNextStyleChild(StyleChildrenIteratorBorrowedMut aIterator)
{
  MOZ_ASSERT(aIterator);
  return aIterator->GetNextChild();
}

EventStates::ServoType
Gecko_ElementState(RawGeckoElementBorrowed aElement)
{
  return aElement->StyleState().ServoValue();
}

bool
Gecko_IsHTMLElementInHTMLDocument(RawGeckoElementBorrowed aElement)
{
  return aElement->IsHTMLElement() && aElement->OwnerDoc()->IsHTMLDocument();
}

bool
Gecko_IsLink(RawGeckoElementBorrowed aElement)
{
  return nsCSSRuleProcessor::IsLink(aElement);
}

bool
Gecko_IsTextNode(RawGeckoNodeBorrowed aNode)
{
  return aNode->NodeInfo()->NodeType() == nsIDOMNode::TEXT_NODE;
}

bool
Gecko_IsVisitedLink(RawGeckoElementBorrowed aElement)
{
  return aElement->StyleState().HasState(NS_EVENT_STATE_VISITED);
}

bool
Gecko_IsUnvisitedLink(RawGeckoElementBorrowed aElement)
{
  return aElement->StyleState().HasState(NS_EVENT_STATE_UNVISITED);
}

bool
Gecko_IsRootElement(RawGeckoElementBorrowed aElement)
{
  return aElement->OwnerDoc()->GetRootElement() == aElement;
}

nsIAtom*
Gecko_LocalName(RawGeckoElementBorrowed aElement)
{
  return aElement->NodeInfo()->NameAtom();
}

nsIAtom*
Gecko_Namespace(RawGeckoElementBorrowed aElement)
{
  int32_t id = aElement->NodeInfo()->NamespaceID();
  return nsContentUtils::NameSpaceManager()->NameSpaceURIAtomForServo(id);
}

nsIAtom*
Gecko_GetElementId(RawGeckoElementBorrowed aElement)
{
  const nsAttrValue* attr = aElement->GetParsedAttr(nsGkAtoms::id);
  return attr ? attr->GetAtomValue() : nullptr;
}

// Dirtiness tracking.
uint32_t
Gecko_GetNodeFlags(RawGeckoNodeBorrowed aNode)
{
  return aNode->GetFlags();
}

void
Gecko_SetNodeFlags(RawGeckoNodeBorrowed aNode, uint32_t aFlags)
{
  const_cast<nsINode*>(aNode)->SetFlags(aFlags);
}

void
Gecko_UnsetNodeFlags(RawGeckoNodeBorrowed aNode, uint32_t aFlags)
{
  const_cast<nsINode*>(aNode)->UnsetFlags(aFlags);
}

nsStyleContext*
Gecko_GetStyleContext(RawGeckoNodeBorrowed aNode, nsIAtom* aPseudoTagOrNull)
{
  MOZ_ASSERT(aNode->IsContent());
  nsIFrame* relevantFrame =
    ServoRestyleManager::FrameForPseudoElement(aNode->AsContent(),
                                               aPseudoTagOrNull);
  if (!relevantFrame) {
    return nullptr;
  }

  return relevantFrame->StyleContext();
}

nsChangeHint
Gecko_CalcStyleDifference(nsStyleContext* aOldStyleContext,
                          ServoComputedValuesBorrowed aComputedValues)
{
  MOZ_ASSERT(aOldStyleContext);
  MOZ_ASSERT(aComputedValues);

  // Pass the safe thing, which causes us to miss a potential optimization. See
  // bug 1289863.
  nsChangeHint forDescendants = nsChangeHint_Hints_NotHandledForDescendants;

  // Eventually, we should compute things out of these flags like
  // ElementRestyler::RestyleSelf does and pass the result to the caller to
  // potentially halt traversal. See bug 1289868.
  uint32_t equalStructs, samePointerStructs;
  nsChangeHint result =
    aOldStyleContext->CalcStyleDifference(aComputedValues,
                                          forDescendants,
                                          &equalStructs,
                                          &samePointerStructs);

  return result;
}

void
Gecko_StoreStyleDifference(RawGeckoNodeBorrowed aNode, nsChangeHint aChangeHintToStore)
{
#ifdef MOZ_STYLO
  MOZ_ASSERT(aNode->IsElement());
  MOZ_ASSERT(aNode->IsDirtyForServo(),
             "Change hint stored in a not-dirty node");

  const Element* aElement = aNode->AsElement();
  nsIFrame* primaryFrame = aElement->GetPrimaryFrame();
  if (!primaryFrame) {
    // If there's no primary frame, that means that either this content is
    // undisplayed (so we only need to check at the restyling phase for the
    // display value on the element), or is a display: contents element.
    //
    // In this second case, we should store it in the frame constructor display
    // contents map. Note that while this operation looks hairy, this would be
    // thread-safe because the content should be there already (we'd only need
    // to read the map and modify our entry).
    //
    // That being said, we still don't support display: contents anyway, so it's
    // probably not worth it to do all the roundtrip just yet until we have a
    // more concrete plan.
    return;
  }

  if ((aChangeHintToStore & nsChangeHint_ReconstructFrame) &&
      aNode->IsInNativeAnonymousSubtree())
  {
    NS_WARNING("stylo: Removing forbidden frame reconstruction hint on native "
               "anonymous content. Fix this in bug 1297857!");
    aChangeHintToStore &= ~nsChangeHint_ReconstructFrame;
  }

  primaryFrame->StyleContext()->StoreChangeHint(aChangeHintToStore);
#else
  MOZ_CRASH("stylo: Shouldn't call Gecko_StoreStyleDifference in "
            "non-stylo build");
#endif
}

RawServoDeclarationBlockStrongBorrowedOrNull
Gecko_GetServoDeclarationBlock(RawGeckoElementBorrowed aElement)
{
  const nsAttrValue* attr = aElement->GetParsedAttr(nsGkAtoms::style);
  if (!attr || attr->Type() != nsAttrValue::eCSSDeclaration) {
    return nullptr;
  }
  DeclarationBlock* decl = attr->GetCSSDeclarationValue();
  if (!decl) {
    return nullptr;
  }
  if (decl->IsGecko()) {
    // XXX This can happen at least when script sets style attribute
    //     since we haven't implemented Element.style for stylo. But
    //     we may want to turn it into an assertion after that's done.
    NS_WARNING("stylo: requesting a Gecko declaration block?");
    return nullptr;
  }
  return reinterpret_cast<const RawServoDeclarationBlockStrong*>
    (decl->AsServo()->RefRaw());
}

void
Gecko_FillAllBackgroundLists(nsStyleImageLayers* aLayers, uint32_t aMaxLen)
{
  nsRuleNode::FillAllBackgroundLists(*aLayers, aMaxLen);
}

void
Gecko_FillAllMaskLists(nsStyleImageLayers* aLayers, uint32_t aMaxLen)
{
  nsRuleNode::FillAllMaskLists(*aLayers, aMaxLen);
}

template <typename Implementor>
static nsIAtom*
AtomAttrValue(Implementor* aElement, nsIAtom* aName)
{
  const nsAttrValue* attr = aElement->GetParsedAttr(aName);
  return attr ? attr->GetAtomValue() : nullptr;
}

template <typename Implementor, typename MatchFn>
static bool
DoMatch(Implementor* aElement, nsIAtom* aNS, nsIAtom* aName, MatchFn aMatch)
{
  if (aNS) {
    int32_t ns = nsContentUtils::NameSpaceManager()->GetNameSpaceID(aNS,
                                                                    aElement->IsInChromeDocument());
    NS_ENSURE_TRUE(ns != kNameSpaceID_Unknown, false);
    const nsAttrValue* value = aElement->GetParsedAttr(aName, ns);
    return value && aMatch(value);
  }
  // No namespace means any namespace - we have to check them all. :-(
  BorrowedAttrInfo attrInfo;
  for (uint32_t i = 0; (attrInfo = aElement->GetAttrInfoAt(i)); ++i) {
    if (attrInfo.mName->LocalName() != aName) {
      continue;
    }
    if (aMatch(attrInfo.mValue)) {
      return true;
    }
  }
  return false;
}

template <typename Implementor>
static bool
HasAttr(Implementor* aElement, nsIAtom* aNS, nsIAtom* aName)
{
  auto match = [](const nsAttrValue* aValue) { return true; };
  return DoMatch(aElement, aNS, aName, match);
}

template <typename Implementor>
static bool
AttrEquals(Implementor* aElement, nsIAtom* aNS, nsIAtom* aName, nsIAtom* aStr,
           bool aIgnoreCase)
{
  auto match = [aStr, aIgnoreCase](const nsAttrValue* aValue) {
    return aValue->Equals(aStr, aIgnoreCase ? eIgnoreCase : eCaseMatters);
  };
  return DoMatch(aElement, aNS, aName, match);
}

template <typename Implementor>
static bool
AttrDashEquals(Implementor* aElement, nsIAtom* aNS, nsIAtom* aName,
               nsIAtom* aStr)
{
  auto match = [aStr](const nsAttrValue* aValue) {
    nsAutoString str;
    aValue->ToString(str);
    const nsDefaultStringComparator c;
    return nsStyleUtil::DashMatchCompare(str, nsDependentAtomString(aStr), c);
  };
  return DoMatch(aElement, aNS, aName, match);
}

template <typename Implementor>
static bool
AttrIncludes(Implementor* aElement, nsIAtom* aNS, nsIAtom* aName,
             nsIAtom* aStr)
{
  auto match = [aStr](const nsAttrValue* aValue) {
    nsAutoString str;
    aValue->ToString(str);
    const nsDefaultStringComparator c;
    return nsStyleUtil::ValueIncludes(str, nsDependentAtomString(aStr), c);
  };
  return DoMatch(aElement, aNS, aName, match);
}

template <typename Implementor>
static bool
AttrHasSubstring(Implementor* aElement, nsIAtom* aNS, nsIAtom* aName,
                 nsIAtom* aStr)
{
  auto match = [aStr](const nsAttrValue* aValue) {
    nsAutoString str;
    aValue->ToString(str);
    return FindInReadable(str, nsDependentAtomString(aStr));
  };
  return DoMatch(aElement, aNS, aName, match);
}

template <typename Implementor>
static bool
AttrHasPrefix(Implementor* aElement, nsIAtom* aNS, nsIAtom* aName,
              nsIAtom* aStr)
{
  auto match = [aStr](const nsAttrValue* aValue) {
    nsAutoString str;
    aValue->ToString(str);
    return StringBeginsWith(str, nsDependentAtomString(aStr));
  };
  return DoMatch(aElement, aNS, aName, match);
}

template <typename Implementor>
static bool
AttrHasSuffix(Implementor* aElement, nsIAtom* aNS, nsIAtom* aName,
              nsIAtom* aStr)
{
  auto match = [aStr](const nsAttrValue* aValue) {
    nsAutoString str;
    aValue->ToString(str);
    return StringEndsWith(str, nsDependentAtomString(aStr));
  };
  return DoMatch(aElement, aNS, aName, match);
}

/**
 * Gets the class or class list (if any) of the implementor. The calling
 * convention here is rather hairy, and is optimized for getting Servo the
 * information it needs for hot calls.
 *
 * The return value indicates the number of classes. If zero, neither outparam
 * is valid. If one, the class_ outparam is filled with the atom of the class.
 * If two or more, the classList outparam is set to point to an array of atoms
 * representing the class list.
 *
 * The array is borrowed and the atoms are not addrefed. These values can be
 * invalidated by any DOM mutation. Use them in a tight scope.
 */
template <typename Implementor>
static uint32_t
ClassOrClassList(Implementor* aElement, nsIAtom** aClass, nsIAtom*** aClassList)
{
  const nsAttrValue* attr = aElement->GetParsedAttr(nsGkAtoms::_class);
  if (!attr) {
    return 0;
  }

  // For class values with only whitespace, Gecko just stores a string. For the
  // purposes of the style system, there is no class in this case.
  if (attr->Type() == nsAttrValue::eString) {
    MOZ_ASSERT(nsContentUtils::TrimWhitespace<nsContentUtils::IsHTMLWhitespace>(
                 attr->GetStringValue()).IsEmpty());
    return 0;
  }

  // Single tokens are generally stored as an atom. Check that case.
  if (attr->Type() == nsAttrValue::eAtom) {
    *aClass = attr->GetAtomValue();
    return 1;
  }

  // At this point we should have an atom array. It is likely, but not
  // guaranteed, that we have two or more elements in the array.
  MOZ_ASSERT(attr->Type() == nsAttrValue::eAtomArray);
  nsTArray<nsCOMPtr<nsIAtom>>* atomArray = attr->GetAtomArrayValue();
  uint32_t length = atomArray->Length();

  // Special case: zero elements.
  if (length == 0) {
    return 0;
  }

  // Special case: one element.
  if (length == 1) {
    *aClass = atomArray->ElementAt(0);
    return 1;
  }

  // General case: Two or more elements.
  //
  // Note: We could also expose this array as an array of nsCOMPtrs, since
  // bindgen knows what those look like, and eliminate the reinterpret_cast.
  // But it's not obvious that that would be preferable.
  static_assert(sizeof(nsCOMPtr<nsIAtom>) == sizeof(nsIAtom*), "Bad simplification");
  static_assert(alignof(nsCOMPtr<nsIAtom>) == alignof(nsIAtom*), "Bad simplification");

  nsCOMPtr<nsIAtom>* elements = atomArray->Elements();
  nsIAtom** rawElements = reinterpret_cast<nsIAtom**>(elements);
  *aClassList = rawElements;
  return atomArray->Length();
}

#define SERVO_IMPL_ELEMENT_ATTR_MATCHING_FUNCTIONS(prefix_, implementor_)      \
  nsIAtom* prefix_##AtomAttrValue(implementor_ aElement, nsIAtom* aName)       \
  {                                                                            \
    return AtomAttrValue(aElement, aName);                                     \
  }                                                                            \
  bool prefix_##HasAttr(implementor_ aElement, nsIAtom* aNS, nsIAtom* aName)   \
  {                                                                            \
    return HasAttr(aElement, aNS, aName);                                      \
  }                                                                            \
  bool prefix_##AttrEquals(implementor_ aElement, nsIAtom* aNS,                \
                           nsIAtom* aName, nsIAtom* aStr, bool aIgnoreCase)    \
  {                                                                            \
    return AttrEquals(aElement, aNS, aName, aStr, aIgnoreCase);                \
  }                                                                            \
  bool prefix_##AttrDashEquals(implementor_ aElement, nsIAtom* aNS,            \
                               nsIAtom* aName, nsIAtom* aStr)                  \
  {                                                                            \
    return AttrDashEquals(aElement, aNS, aName, aStr);                         \
  }                                                                            \
  bool prefix_##AttrIncludes(implementor_ aElement, nsIAtom* aNS,              \
                             nsIAtom* aName, nsIAtom* aStr)                    \
  {                                                                            \
    return AttrIncludes(aElement, aNS, aName, aStr);                           \
  }                                                                            \
  bool prefix_##AttrHasSubstring(implementor_ aElement, nsIAtom* aNS,          \
                                 nsIAtom* aName, nsIAtom* aStr)                \
  {                                                                            \
    return AttrHasSubstring(aElement, aNS, aName, aStr);                       \
  }                                                                            \
  bool prefix_##AttrHasPrefix(implementor_ aElement, nsIAtom* aNS,             \
                              nsIAtom* aName, nsIAtom* aStr)                   \
  {                                                                            \
    return AttrHasPrefix(aElement, aNS, aName, aStr);                          \
  }                                                                            \
  bool prefix_##AttrHasSuffix(implementor_ aElement, nsIAtom* aNS,             \
                              nsIAtom* aName, nsIAtom* aStr)                   \
  {                                                                            \
    return AttrHasSuffix(aElement, aNS, aName, aStr);                          \
  }                                                                            \
  uint32_t prefix_##ClassOrClassList(implementor_ aElement, nsIAtom** aClass,  \
                                     nsIAtom*** aClassList)                    \
  {                                                                            \
    return ClassOrClassList(aElement, aClass, aClassList);                     \
  }

SERVO_IMPL_ELEMENT_ATTR_MATCHING_FUNCTIONS(Gecko_, RawGeckoElementBorrowed)
SERVO_IMPL_ELEMENT_ATTR_MATCHING_FUNCTIONS(Gecko_Snapshot, ServoElementSnapshot*)

#undef SERVO_IMPL_ELEMENT_ATTR_MATCHING_FUNCTIONS

nsIAtom*
Gecko_Atomize(const char* aString, uint32_t aLength)
{
  return NS_Atomize(nsDependentCSubstring(aString, aLength)).take();
}

void
Gecko_AddRefAtom(nsIAtom* aAtom)
{
  NS_ADDREF(aAtom);
}

void
Gecko_ReleaseAtom(nsIAtom* aAtom)
{
  NS_RELEASE(aAtom);
}

const uint16_t*
Gecko_GetAtomAsUTF16(nsIAtom* aAtom, uint32_t* aLength)
{
  static_assert(sizeof(char16_t) == sizeof(uint16_t), "Servo doesn't know what a char16_t is");
  MOZ_ASSERT(aAtom);
  *aLength = aAtom->GetLength();

  // We need to manually cast from char16ptr_t to const char16_t* to handle the
  // MOZ_USE_CHAR16_WRAPPER we use on WIndows.
  return reinterpret_cast<const uint16_t*>(static_cast<const char16_t*>(aAtom->GetUTF16String()));
}

bool
Gecko_AtomEqualsUTF8(nsIAtom* aAtom, const char* aString, uint32_t aLength)
{
  // XXXbholley: We should be able to do this without converting, I just can't
  // find the right thing to call.
  nsDependentAtomString atomStr(aAtom);
  NS_ConvertUTF8toUTF16 inStr(nsDependentCSubstring(aString, aLength));
  return atomStr.Equals(inStr);
}

bool
Gecko_AtomEqualsUTF8IgnoreCase(nsIAtom* aAtom, const char* aString, uint32_t aLength)
{
  // XXXbholley: We should be able to do this without converting, I just can't
  // find the right thing to call.
  nsDependentAtomString atomStr(aAtom);
  NS_ConvertUTF8toUTF16 inStr(nsDependentCSubstring(aString, aLength));
  return nsContentUtils::EqualsIgnoreASCIICase(atomStr, inStr);
}

void
Gecko_Utf8SliceToString(nsString* aString,
                        const uint8_t* aBuffer,
                        size_t aBufferLen)
{
  MOZ_ASSERT(aString);
  MOZ_ASSERT(aBuffer);

  aString->Truncate();
  AppendUTF8toUTF16(Substring(reinterpret_cast<const char*>(aBuffer),
                              aBufferLen), *aString);
}

void
Gecko_FontFamilyList_Clear(FontFamilyList* aList) {
  aList->Clear();
}

void
Gecko_FontFamilyList_AppendNamed(FontFamilyList* aList, nsIAtom* aName)
{
  // Servo doesn't record whether the name was quoted or unquoted, so just
  // assume unquoted for now.
  FontFamilyName family;
  aName->ToString(family.mName);
  aList->Append(family);
}

void
Gecko_FontFamilyList_AppendGeneric(FontFamilyList* aList, FontFamilyType aType)
{
  aList->Append(FontFamilyName(aType));
}

void
Gecko_CopyFontFamilyFrom(nsFont* dst, const nsFont* src)
{
  dst->fontlist = src->fontlist;
}

void
Gecko_SetListStyleType(nsStyleList* style_struct, uint32_t type)
{
  // Builtin counter styles are static and use no-op refcounting, and thus are
  // safe to use off-main-thread.
  style_struct->SetCounterStyle(CounterStyleManager::GetBuiltinStyle(type));
}

void
Gecko_CopyListStyleTypeFrom(nsStyleList* dst, const nsStyleList* src)
{
  dst->SetCounterStyle(src->GetCounterStyle());
}

NS_IMPL_HOLDER_FFI_REFCOUNTING(nsIPrincipal, Principal)
NS_IMPL_HOLDER_FFI_REFCOUNTING(nsIURI, URI)

void
Gecko_SetMozBinding(nsStyleDisplay* aDisplay,
                    const uint8_t* aURLString, uint32_t aURLStringLength,
                    ThreadSafeURIHolder* aBaseURI,
                    ThreadSafeURIHolder* aReferrer,
                    ThreadSafePrincipalHolder* aPrincipal)
{
  MOZ_ASSERT(aDisplay);
  MOZ_ASSERT(aURLString);
  MOZ_ASSERT(aBaseURI);
  MOZ_ASSERT(aReferrer);
  MOZ_ASSERT(aPrincipal);

  nsString url;
  nsDependentCSubstring urlString(reinterpret_cast<const char*>(aURLString),
                                  aURLStringLength);
  AppendUTF8toUTF16(urlString, url);
  RefPtr<nsStringBuffer> urlBuffer = nsCSSValue::BufferFromString(url);

  aDisplay->mBinding =
    new css::URLValue(urlBuffer, do_AddRef(aBaseURI),
                      do_AddRef(aReferrer), do_AddRef(aPrincipal));
}

void
Gecko_CopyMozBindingFrom(nsStyleDisplay* aDest, const nsStyleDisplay* aSrc)
{
  aDest->mBinding = aSrc->mBinding;
}


void
Gecko_SetNullImageValue(nsStyleImage* aImage)
{
  MOZ_ASSERT(aImage);
  aImage->SetNull();
}

void
Gecko_SetGradientImageValue(nsStyleImage* aImage, nsStyleGradient* aGradient)
{
  MOZ_ASSERT(aImage);
  aImage->SetGradientData(aGradient);
}

static already_AddRefed<nsStyleImageRequest>
CreateStyleImageRequest(nsStyleImageRequest::Mode aModeFlags,
                        const uint8_t* aURLString, uint32_t aURLStringLength,
                        ThreadSafeURIHolder* aBaseURI,
                        ThreadSafeURIHolder* aReferrer,
                        ThreadSafePrincipalHolder* aPrincipal)
{
  MOZ_ASSERT(aURLString);
  MOZ_ASSERT(aBaseURI);
  MOZ_ASSERT(aReferrer);
  MOZ_ASSERT(aPrincipal);

  nsString url;
  nsDependentCSubstring urlString(reinterpret_cast<const char*>(aURLString),
                                  aURLStringLength);
  AppendUTF8toUTF16(urlString, url);
  RefPtr<nsStringBuffer> urlBuffer = nsCSSValue::BufferFromString(url);

  RefPtr<nsStyleImageRequest> req =
    new nsStyleImageRequest(aModeFlags, urlBuffer, do_AddRef(aBaseURI),
                            do_AddRef(aReferrer), do_AddRef(aPrincipal));
  return req.forget();
}

void
Gecko_SetUrlImageValue(nsStyleImage* aImage,
                       const uint8_t* aURLString, uint32_t aURLStringLength,
                       ThreadSafeURIHolder* aBaseURI,
                       ThreadSafeURIHolder* aReferrer,
                       ThreadSafePrincipalHolder* aPrincipal)
{
  RefPtr<nsStyleImageRequest> req =
    CreateStyleImageRequest(nsStyleImageRequest::Mode::Track,
                            aURLString, aURLStringLength,
                            aBaseURI, aReferrer, aPrincipal);
  aImage->SetImageRequest(req.forget());
}

void
Gecko_CopyImageValueFrom(nsStyleImage* aImage, const nsStyleImage* aOther)
{
  MOZ_ASSERT(aImage);
  MOZ_ASSERT(aOther);

  *aImage = *aOther;
}

nsStyleGradient*
Gecko_CreateGradient(uint8_t aShape,
                     uint8_t aSize,
                     bool aRepeating,
                     bool aLegacySyntax,
                     uint32_t aStopCount)
{
  nsStyleGradient* result = new nsStyleGradient();

  result->mShape = aShape;
  result->mSize = aSize;
  result->mRepeating = aRepeating;
  result->mLegacySyntax = aLegacySyntax;

  result->mAngle.SetNoneValue();
  result->mBgPosX.SetNoneValue();
  result->mBgPosY.SetNoneValue();
  result->mRadiusX.SetNoneValue();
  result->mRadiusY.SetNoneValue();

  nsStyleGradientStop dummyStop;
  dummyStop.mLocation.SetNoneValue();
  dummyStop.mColor = NS_RGB(0, 0, 0);
  dummyStop.mIsInterpolationHint = 0;

  for (uint32_t i = 0; i < aStopCount; i++) {
    result->mStops.AppendElement(dummyStop);
  }

  return result;
}

void
Gecko_SetListStyleImageNone(nsStyleList* aList)
{
  aList->mListStyleImage = nullptr;
}

void
Gecko_SetListStyleImage(nsStyleList* aList,
                        const uint8_t* aURLString, uint32_t aURLStringLength,
                        ThreadSafeURIHolder* aBaseURI,
                        ThreadSafeURIHolder* aReferrer,
                        ThreadSafePrincipalHolder* aPrincipal)
{
  aList->mListStyleImage =
    CreateStyleImageRequest(nsStyleImageRequest::Mode(0),
                            aURLString, aURLStringLength,
                            aBaseURI, aReferrer, aPrincipal);
}

void
Gecko_CopyListStyleImageFrom(nsStyleList* aList, const nsStyleList* aSource)
{
  aList->mListStyleImage = aSource->mListStyleImage;
}

void
Gecko_EnsureTArrayCapacity(void* aArray, size_t aCapacity, size_t aElemSize)
{
  auto base =
    reinterpret_cast<nsTArray_base<nsTArrayInfallibleAllocator,
                                   nsTArray_CopyWithMemutils>*>(aArray);

  base->EnsureCapacity<nsTArrayInfallibleAllocator>(aCapacity, aElemSize);
}

void
Gecko_ClearPODTArray(void* aArray, size_t aElementSize, size_t aElementAlign)
{
  auto base =
    reinterpret_cast<nsTArray_base<nsTArrayInfallibleAllocator,
                                   nsTArray_CopyWithMemutils>*>(aArray);

  base->template ShiftData<nsTArrayInfallibleAllocator>(0, base->Length(), 0,
                                                        aElementSize, aElementAlign);
}

void
Gecko_ClearStyleContents(nsStyleContent* aContent)
{
  aContent->AllocateContents(0);
}

void
Gecko_CopyStyleContentsFrom(nsStyleContent* aContent, const nsStyleContent* aOther)
{
  uint32_t count = aOther->ContentCount();

  aContent->AllocateContents(count);

  for (uint32_t i = 0; i < count; ++i) {
    aContent->ContentAt(i) = aOther->ContentAt(i);
  }
}

void
Gecko_EnsureImageLayersLength(nsStyleImageLayers* aLayers, size_t aLen,
                              nsStyleImageLayers::LayerType aLayerType)
{
  size_t oldLength = aLayers->mLayers.Length();

  aLayers->mLayers.EnsureLengthAtLeast(aLen);

  for (size_t i = oldLength; i < aLen; ++i) {
    aLayers->mLayers[i].Initialize(aLayerType);
  }
}

void
Gecko_ResetStyleCoord(nsStyleUnit* aUnit, nsStyleUnion* aValue)
{
  nsStyleCoord::Reset(*aUnit, *aValue);
}

void
Gecko_SetStyleCoordCalcValue(nsStyleUnit* aUnit, nsStyleUnion* aValue, nsStyleCoord::CalcValue aCalc)
{
  // Calc units should be cleaned up first
  MOZ_ASSERT(*aUnit != nsStyleUnit::eStyleUnit_Calc);
  nsStyleCoord::Calc* calcRef = new nsStyleCoord::Calc();
  calcRef->mLength = aCalc.mLength;
  calcRef->mPercent = aCalc.mPercent;
  calcRef->mHasPercent = aCalc.mHasPercent;
  *aUnit = nsStyleUnit::eStyleUnit_Calc;
  aValue->mPointer = calcRef;
  calcRef->AddRef();
}

void
Gecko_CopyClipPathValueFrom(mozilla::StyleClipPath* aDst, const mozilla::StyleClipPath* aSrc)
{
  MOZ_ASSERT(aDst);
  MOZ_ASSERT(aSrc);

  *aDst = *aSrc;
}

void
Gecko_DestroyClipPath(mozilla::StyleClipPath* aClip)
{
  aClip->~StyleClipPath();
}

mozilla::StyleBasicShape*
Gecko_NewBasicShape(mozilla::StyleBasicShapeType aType)
{
  RefPtr<StyleBasicShape> ptr = new mozilla::StyleBasicShape(aType);
  return ptr.forget().take();
}

void
Gecko_ResetFilters(nsStyleEffects* effects, size_t new_len)
{
  effects->mFilters.Clear();
  effects->mFilters.SetLength(new_len);
}

void
Gecko_CopyFiltersFrom(nsStyleEffects* aSrc, nsStyleEffects* aDest)
{
  aDest->mFilters = aSrc->mFilters;
}

NS_IMPL_THREADSAFE_FFI_REFCOUNTING(nsStyleCoord::Calc, Calc);

nsCSSShadowArray*
Gecko_NewCSSShadowArray(uint32_t aLen)
{
  RefPtr<nsCSSShadowArray> arr = new(aLen) nsCSSShadowArray(aLen);
  return arr.forget().take();
}

NS_IMPL_THREADSAFE_FFI_REFCOUNTING(nsCSSShadowArray, CSSShadowArray);

nsStyleQuoteValues*
Gecko_NewStyleQuoteValues(uint32_t aLen)
{
  RefPtr<nsStyleQuoteValues> values = new nsStyleQuoteValues;
  values->mQuotePairs.SetLength(aLen);
  return values.forget().take();
}

NS_IMPL_THREADSAFE_FFI_REFCOUNTING(nsStyleQuoteValues, QuoteValues);

nsCSSValueSharedList*
Gecko_NewCSSValueSharedList(uint32_t aLen)
{
  RefPtr<nsCSSValueSharedList> list = new nsCSSValueSharedList;
  if (aLen == 0) {
    return list.forget().take();
  }

  list->mHead = new nsCSSValueList;
  nsCSSValueList* cur = list->mHead;
  for (uint32_t i = 0; i < aLen - 1; i++) {
    cur->mNext = new nsCSSValueList;
    cur = cur->mNext;
  }

  return list.forget().take();
}

void
Gecko_CSSValue_SetAbsoluteLength(nsCSSValueBorrowedMut aCSSValue, nscoord aLen)
{
  aCSSValue->SetIntegerCoordValue(aLen);
}

void
Gecko_CSSValue_SetNumber(nsCSSValueBorrowedMut aCSSValue, float aNumber)
{
  aCSSValue->SetFloatValue(aNumber, eCSSUnit_Number);
}

void
Gecko_CSSValue_SetKeyword(nsCSSValueBorrowedMut aCSSValue, nsCSSKeyword aKeyword)
{
  aCSSValue->SetIntValue(aKeyword, eCSSUnit_Enumerated);
}

void
Gecko_CSSValue_SetPercentage(nsCSSValueBorrowedMut aCSSValue, float aPercent)
{
  aCSSValue->SetFloatValue(aPercent, eCSSUnit_Number);
}

void
Gecko_CSSValue_SetAngle(nsCSSValueBorrowedMut aCSSValue, float aRadians)
{
  aCSSValue->SetFloatValue(aRadians, eCSSUnit_Radian);
}

void
Gecko_CSSValue_SetCalc(nsCSSValueBorrowedMut aCSSValue, nsStyleCoord::CalcValue aCalc)
{
  aCSSValue->SetCalcValue(&aCalc);
}

void
Gecko_CSSValue_SetFunction(nsCSSValueBorrowedMut aCSSValue, int32_t aLen)
{
  nsCSSValue::Array* arr = nsCSSValue::Array::Create(aLen);
  aCSSValue->SetArrayValue(arr, eCSSUnit_Function);
}

nsCSSValueBorrowedMut
Gecko_CSSValue_GetArrayItem(nsCSSValueBorrowedMut aCSSValue, int32_t aIndex)
{
  return &aCSSValue->GetArrayValue()->Item(aIndex);
}

NS_IMPL_THREADSAFE_FFI_REFCOUNTING(nsCSSValueSharedList, CSSValueSharedList);

#define STYLE_STRUCT(name, checkdata_cb)                                      \
                                                                              \
void                                                                          \
Gecko_Construct_nsStyle##name(nsStyle##name* ptr)                             \
{                                                                             \
  new (ptr) nsStyle##name(StyleStructContext::ServoContext());                \
}                                                                             \
                                                                              \
void                                                                          \
Gecko_CopyConstruct_nsStyle##name(nsStyle##name* ptr,                         \
                                  const nsStyle##name* other)                 \
{                                                                             \
  new (ptr) nsStyle##name(*other);                                            \
}                                                                             \
                                                                              \
void                                                                          \
Gecko_Destroy_nsStyle##name(nsStyle##name* ptr)                               \
{                                                                             \
  ptr->~nsStyle##name();                                                      \
}

#include "nsStyleStructList.h"

#undef STYLE_STRUCT

#ifndef MOZ_STYLO
#define SERVO_BINDING_FUNC(name_, return_, ...)                               \
  return_ name_(__VA_ARGS__) {                                                \
    MOZ_CRASH("stylo: shouldn't be calling " #name_ "in a non-stylo build");  \
  }
#include "ServoBindingList.h"
#undef SERVO_BINDING_FUNC
#endif

#ifdef MOZ_STYLO
const nsStyleVariables*
Servo_GetStyleVariables(ServoComputedValuesBorrowed aComputedValues)
{
  // Servo can't provide us with Variables structs yet, so instead of linking
  // to a Servo_GetStyleVariables defined in Servo we define one here that
  // always returns the same, empty struct.
  static nsStyleVariables variables(StyleStructContext::ServoContext());
  return &variables;
}
#endif
