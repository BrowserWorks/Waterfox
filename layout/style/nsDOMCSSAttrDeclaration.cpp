/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* DOM object for element.style */

#include "nsDOMCSSAttrDeclaration.h"

#include "ActiveLayerTracker.h"
#include "mozAutoDocUpdate.h"
#include "mozilla/SMILCSSValueType.h"
#include "mozilla/SMILValue.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/SVGElement.h"
#include "mozilla/layers/ScrollLinkedEffectDetector.h"
#include "nsIFrame.h"
#include "nsWrapperCacheInlines.h"

using namespace mozilla;
using namespace mozilla::dom;

nsDOMCSSAttributeDeclaration::nsDOMCSSAttributeDeclaration(Element* aElement,
                                                           bool aIsSMILOverride)
    : mElement(aElement), mIsSMILOverride(aIsSMILOverride) {
  NS_ASSERTION(aElement, "Inline style for a NULL element?");
}

nsDOMCSSAttributeDeclaration::~nsDOMCSSAttributeDeclaration() = default;

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(nsDOMCSSAttributeDeclaration, mElement)

// mElement holds a strong ref to us, so if it's going to be
// skipped, the attribute declaration can't be part of a garbage
// cycle.
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_BEGIN(nsDOMCSSAttributeDeclaration)
  if (tmp->mElement && Element::CanSkip(tmp->mElement, true)) {
    if (tmp->PreservingWrapper()) {
      tmp->MarkWrapperLive();
    }
    return true;
  }
  return tmp->HasKnownLiveWrapper();
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_END

NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_IN_CC_BEGIN(nsDOMCSSAttributeDeclaration)
  return tmp->HasKnownLiveWrapper() ||
         (tmp->mElement && Element::CanSkipInCC(tmp->mElement) &&
          tmp->HasNothingToTrace(tmp));
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_IN_CC_END

NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_THIS_BEGIN(nsDOMCSSAttributeDeclaration)
  return tmp->HasKnownLiveWrapper() ||
         (tmp->mElement && Element::CanSkipThis(tmp->mElement));
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_THIS_END

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(nsDOMCSSAttributeDeclaration)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
NS_INTERFACE_MAP_END_INHERITING(nsDOMCSSDeclaration)

NS_IMPL_CYCLE_COLLECTING_ADDREF(nsDOMCSSAttributeDeclaration)
NS_IMPL_CYCLE_COLLECTING_RELEASE(nsDOMCSSAttributeDeclaration)

nsresult nsDOMCSSAttributeDeclaration::SetCSSDeclaration(
    Block* aDecl, MutationClosureData* aClosureData) {
  NS_ASSERTION(mElement, "Must have Element to set the declaration!");

  // Whenever changing element.style values, aClosureData must be non-null.
  // SMIL doesn't update Element's attribute values, so closure data isn't
  // needed.
  MOZ_ASSERT_IF(!mIsSMILOverride, aClosureData);

  // The closure needs to have been called by now, otherwise we shouldn't be
  // getting here when the attribute hasn't changed.
  MOZ_ASSERT_IF(aClosureData && aClosureData->mShouldBeCalled,
                aClosureData->mWasCalled);
  if (mIsSMILOverride) {
    mElement->SetSMILOverrideStyleDeclaration(*aDecl);
    return NS_OK;
  }
  return mElement->SetInlineStyleDeclaration(*aDecl, *aClosureData);
}

Document* nsDOMCSSAttributeDeclaration::DocToUpdate() {
  // We need OwnerDoc() rather than GetUncomposedDoc() because it might
  // be the BeginUpdate call that inserts mElement into the document.
  return mElement->OwnerDoc();
}

StyleLockedDeclarationBlock*
nsDOMCSSAttributeDeclaration::GetOrCreateCSSDeclaration(Operation aOperation,
                                                        Block** aCreated) {
  MOZ_ASSERT(aOperation != Operation::Modify || aCreated);

  if (!mElement) {
    return nullptr;
  }

  StyleLockedDeclarationBlock* declaration;
  if (mIsSMILOverride) {
    declaration = mElement->GetSMILOverrideStyleDeclaration();
  } else {
    declaration = mElement->GetInlineStyleDeclaration();
  }

  if (declaration) {
    return declaration;
  }

  if (aOperation != Operation::Modify) {
    return nullptr;
  }

  // cannot fail
  RefPtr decl = Servo_DeclarationBlock_CreateEmpty().Consume();
  decl.swap(*aCreated);
  return *aCreated;
}

nsDOMCSSDeclaration::ParsingEnvironment
nsDOMCSSAttributeDeclaration::GetParsingEnvironment(
    nsIPrincipal* aSubjectPrincipal) const {
  return {
      mElement->GetURLDataForStyleAttr(aSubjectPrincipal),
      mElement->OwnerDoc()->GetCompatibilityMode(),
      mElement->OwnerDoc()->GetExistingCSSLoader(),  // For error reporting only
  };
}

template <typename SetterFunc>
nsresult nsDOMCSSAttributeDeclaration::SetSMILValueHelper(SetterFunc aFunc) {
  MOZ_ASSERT(mIsSMILOverride);

  // No need to do the ActiveLayerTracker / ScrollLinkedEffectDetector bits,
  // since we're in a SMIL animation anyway, no need to try to detect we're a
  // scripted animation.
  RefPtr<Block> created;
  Block* olddecl =
      GetOrCreateCSSDeclaration(Operation::Modify, getter_AddRefs(created));
  if (!olddecl) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  mozAutoDocUpdate autoUpdate(DocToUpdate(), true);
  RefPtr<Block> decl = EnsureBlockMutable(olddecl);

  bool changed = aFunc(*decl);

  if (changed) {
    // We can pass nullptr as the latter param, since this is
    // mIsSMILOverride == true case.
    SetCSSDeclaration(decl, nullptr);
  }
  return NS_OK;
}

nsresult nsDOMCSSAttributeDeclaration::SetSMILValue(
    const NonCustomCSSPropertyId aPropId, const SMILValue& aValue) {
  MOZ_ASSERT(aValue.mType == &SMILCSSValueType::sSingleton,
             "We should only try setting a CSS value type");
  return SetSMILValueHelper([&](StyleLockedDeclarationBlock& aDecl) {
    return SMILCSSValueType::SetPropertyValues(aPropId, aValue, aDecl);
  });
}

nsresult nsDOMCSSAttributeDeclaration::SetSMILValue(
    const NonCustomCSSPropertyId aPropId, const SVGAnimatedLength& aLength) {
  return SetSMILValueHelper(
      [aPropId, &aLength](StyleLockedDeclarationBlock& aDecl) {
        return SVGElement::UpdateDeclarationBlockFromLength(
            aDecl, aPropId, aLength, SVGElement::ValToUse::Anim);
      });
}

nsresult nsDOMCSSAttributeDeclaration::SetSMILValue(
    const NonCustomCSSPropertyId aPropId, const SVGAnimatedPathSegList& aPath) {
  MOZ_ASSERT(aPropId == eCSSProperty_d);
  return SetSMILValueHelper([&aPath](StyleLockedDeclarationBlock& aDecl) {
    return SVGElement::UpdateDeclarationBlockFromPath(
        aDecl, aPath, SVGElement::ValToUse::Anim);
  });
}

nsresult nsDOMCSSAttributeDeclaration::SetSMILValue(
    const NonCustomCSSPropertyId aPropId,
    const SVGAnimatedTransformList* aTransform,
    const gfx::Matrix* aAnimateMotionTransform) {
  MOZ_ASSERT(aPropId == eCSSProperty_transform);
  return SetSMILValueHelper([aTransform, aAnimateMotionTransform](
                                StyleLockedDeclarationBlock& aDecl) {
    return SVGElement::UpdateDeclarationBlockFromTransform(
        aDecl, aTransform, aAnimateMotionTransform, SVGElement::ValToUse::Anim);
  });
}

// Scripted modifications to style.opacity or style.transform (or other
// transform-like properties, e.g. style.translate, style.rotate, style.scale)
// could immediately force us into the animated state if heuristics suggest
// this is a scripted animation.
//
// FIXME: This is missing the margin shorthand and the logical versions of
// the margin properties, see bug 1266287.
static bool IsActiveLayerProperty(NonCustomCSSPropertyId aPropId) {
  switch (aPropId) {
    case eCSSProperty_opacity:
    case eCSSProperty_transform:
    case eCSSProperty_translate:
    case eCSSProperty_rotate:
    case eCSSProperty_scale:
    case eCSSProperty_offset_path:
    case eCSSProperty_offset_distance:
    case eCSSProperty_offset_rotate:
    case eCSSProperty_offset_anchor:
    case eCSSProperty_offset_position:
      return true;
    default:
      return false;
  }
}

void nsDOMCSSAttributeDeclaration::SetPropertyValue(
    const NonCustomCSSPropertyId aPropId, const nsACString& aValue,
    nsIPrincipal* aSubjectPrincipal, ErrorResult& aRv) {
  nsDOMCSSDeclaration::SetPropertyValue(aPropId, aValue, aSubjectPrincipal,
                                        aRv);
}

static bool IsScrollLinkedEffectiveProperty(
    const NonCustomCSSPropertyId aPropId) {
  switch (aPropId) {
    case eCSSProperty_background_position:
    case eCSSProperty_background_position_x:
    case eCSSProperty_background_position_y:
    case eCSSProperty_transform:
    case eCSSProperty_translate:
    case eCSSProperty_rotate:
    case eCSSProperty_scale:
    case eCSSProperty_offset_path:
    case eCSSProperty_offset_distance:
    case eCSSProperty_offset_rotate:
    case eCSSProperty_offset_anchor:
    case eCSSProperty_offset_position:
    case eCSSProperty_top:
    case eCSSProperty_left:
    case eCSSProperty_bottom:
    case eCSSProperty_right:
    case eCSSProperty_margin:
    case eCSSProperty_margin_top:
    case eCSSProperty_margin_left:
    case eCSSProperty_margin_bottom:
    case eCSSProperty_margin_right:
    case eCSSProperty_margin_inline_start:
    case eCSSProperty_margin_inline_end:
    case eCSSProperty_margin_block_start:
    case eCSSProperty_margin_block_end:
      return true;
    default:
      return false;
  }
}

void nsDOMCSSAttributeDeclaration::MutationClosureFunction(
    void* aData, NonCustomCSSPropertyId aPropId) {
  auto* data = static_cast<MutationClosureData*>(aData);
  MOZ_ASSERT(
      data->mShouldBeCalled,
      "Did we pass a non-null closure to the style system unnecessarily?");
  if (data->mWasCalled) {
    return;
  }
  if (IsScrollLinkedEffectiveProperty(aPropId)) {
    mozilla::layers::ScrollLinkedEffectDetector::PositioningPropertyMutated();
  }
  if (IsActiveLayerProperty(aPropId)) {
    if (nsIFrame* frame = data->mElement->GetPrimaryFrame()) {
      ActiveLayerTracker::NotifyInlineStyleRuleModified(frame, aPropId);
    }
  }

  data->mWasCalled = true;
  data->mElement->InlineStyleDeclarationWillChange(*data);
}
