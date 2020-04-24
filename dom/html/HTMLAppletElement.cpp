/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/EventStates.h"
#include "mozilla/dom/HTMLAppletElement.h"
#include "mozilla/dom/HTMLEmbedElementBinding.h"
#include "mozilla/dom/HTMLAppletElementBinding.h"
#include "mozilla/dom/ElementInlines.h"

#include "mozilla/dom/Document.h"
#include "nsIPluginDocument.h"
#include "nsThreadUtils.h"
#include "nsIScriptError.h"
#include "nsIWidget.h"
#include "nsContentUtils.h"
#ifdef XP_MACOSX
#include "mozilla/EventDispatcher.h"
#include "mozilla/dom/Event.h"
#endif
#include "mozilla/dom/HTMLObjectElement.h" 


NS_IMPL_NS_NEW_HTML_ELEMENT_CHECK_PARSER(Applet)

namespace mozilla {
namespace dom {

    HTMLAppletElement::HTMLAppletElement(already_AddRefed<mozilla::dom::NodeInfo>&& aNodeInfo,
                                                 FromParser aFromParser)
  : nsGenericHTMLElement(std::move(aNodeInfo)),
    mIsDoneAddingChildren(mNodeInfo->Equals(nsGkAtoms::embed) || !aFromParser)
{
  RegisterActivityObserver();
  SetIsNetworkCreated(aFromParser == FROM_PARSER_NETWORK);

  // By default we're in the loading state
  AddStatesSilently(NS_EVENT_STATE_LOADING);
}

    HTMLAppletElement::~HTMLAppletElement()
{
#ifdef XP_MACOSX
  HTMLObjectElement::OnFocusBlurPlugin(this, false);
#endif
  UnregisterActivityObserver();
  DestroyImageLoadingContent();
}

bool
HTMLAppletElement::IsDoneAddingChildren()
{
  return mIsDoneAddingChildren;
}

void
HTMLAppletElement::DoneAddingChildren(bool aHaveNotified)
{
  if (!mIsDoneAddingChildren) {
    mIsDoneAddingChildren = true;

    // If we're already in a document, we need to trigger the load
    // Otherwise, BindToTree takes care of that.
    if (IsInComposedDoc()) {
      StartObjectLoad(aHaveNotified, false);
    }
  }
}


NS_IMPL_CYCLE_COLLECTION_CLASS(HTMLAppletElement)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(HTMLAppletElement,
    nsGenericHTMLElement)
    nsObjectLoadingContent::Traverse(tmp, cb);
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_ISUPPORTS_CYCLE_COLLECTION_INHERITED(
    HTMLAppletElement, nsGenericHTMLElement, nsIRequestObserver,
    nsIStreamListener, nsFrameLoaderOwner, nsIObjectLoadingContent,
    imgINotificationObserver, nsIImageLoadingContent, nsIChannelEventSink)

    NS_IMPL_ELEMENT_CLONE(HTMLAppletElement)


#if 0
NS_IMPL_CYCLE_COLLECTION_CLASS(HTMLAppletElement)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(HTMLAppletElement,
                                                  nsGenericHTMLElement)
  nsObjectLoadingContent::Traverse(tmp, cb);
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_ADDREF_INHERITED(HTMLAppletElement, Element)
NS_IMPL_RELEASE_INHERITED(HTMLAppletElement, Element)

NS_INTERFACE_TABLE_HEAD_CYCLE_COLLECTION_INHERITED(HTMLAppletElement)
  NS_INTERFACE_TABLE_INHERITED(HTMLAppletElement,
                               nsIRequestObserver,
                               nsIStreamListener,
                               nsFrameLoaderOwner,
                               nsIObjectLoadingContent,
                               imgINotificationObserver,
                               nsIImageLoadingContent,
                               nsIChannelEventSink)
  NS_INTERFACE_TABLE_TO_MAP_SEGUE


NS_INTERFACE_MAP_END_INHERITING(nsGenericHTMLElement)

NS_IMPL_ELEMENT_CLONE(HTMLAppletElement)
#endif

#ifdef XP_MACOSX

NS_IMETHODIMP
HTMLAppletElement::PostHandleEvent(EventChainPostVisitor& aVisitor)
{
  HTMLObjectElement::HandleFocusBlurPlugin(this, aVisitor.mEvent);
  return NS_OK;
}

#endif // #ifdef XP_MACOSX

void
HTMLAppletElement::AsyncEventRunning(AsyncEventDispatcher* aEvent)
{
  nsImageLoadingContent::AsyncEventRunning(aEvent);
}

nsresult
HTMLAppletElement::BindToTree(Document *aDocument,
                                    nsIContent *aParent,
                                    nsIContent *aBindingParent)
{
  nsresult rv = nsGenericHTMLElement::BindToTree(aDocument, aParent,
                                                 aBindingParent);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = nsObjectLoadingContent::BindToTree(aDocument, aParent,
                                          aBindingParent);
  NS_ENSURE_SUCCESS(rv, rv);

  // Don't kick off load from being bound to a plugin document - the plugin
  // document will call nsObjectLoadingContent::InitializeFromChannel() for the
  // initial load.
  nsCOMPtr<nsIPluginDocument> pluginDoc = do_QueryInterface(aDocument);

  // If we already have all the children, start the load.
  if (mIsDoneAddingChildren && !pluginDoc) {
    void (HTMLAppletElement::*start)() =
      &HTMLAppletElement::StartObjectLoad;
    nsContentUtils::AddScriptRunner(NewRunnableMethod(
      "dom::HTMLAppletElement::BindToTree", this, start));
  }

  return NS_OK;
}

void
HTMLAppletElement::UnbindFromTree(bool aDeep,
                                        bool aNullParent)
{
#ifdef XP_MACOSX
  // When a page is reloaded (when an Document's content is removed), the
  // focused element isn't necessarily sent an eBlur event. See
  // nsFocusManager::ContentRemoved(). This means that a widget may think it
  // still contains a focused plugin when it doesn't -- which in turn can
  // disable text input in the browser window. See bug 1137229.
  HTMLObjectElement::OnFocusBlurPlugin(this, false);
#endif
  nsObjectLoadingContent::UnbindFromTree(aDeep, aNullParent);
  nsGenericHTMLElement::UnbindFromTree(aDeep, aNullParent);
}

nsresult HTMLAppletElement::AfterSetAttr(int32_t aNamespaceID, nsAtom* aName,
                                         const nsAttrValue* aValue,
                                         const nsAttrValue* aOldValue,
                                         nsIPrincipal* aSubjectPrincipal,
                                         bool aNotify) {

  if (aValue) {
    nsresult rv = AfterMaybeChangeAttr(aNamespaceID, aName, aNotify);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  return nsGenericHTMLElement::AfterSetAttr(
      aNamespaceID, aName, aValue, aOldValue, aSubjectPrincipal, aNotify);
}


nsresult
HTMLAppletElement::OnAttrSetButNotChanged(int32_t aNamespaceID,
                                                nsAtom* aName,
                                                const nsAttrValueOrString& aValue,
                                                bool aNotify)
{
  nsresult rv = AfterMaybeChangeAttr(aNamespaceID, aName, aNotify);
  NS_ENSURE_SUCCESS(rv, rv);

  return nsGenericHTMLElement::OnAttrSetButNotChanged(aNamespaceID, aName,
                                                      aValue, aNotify);
}

nsresult
HTMLAppletElement::AfterMaybeChangeAttr(int32_t aNamespaceID,
                                              nsAtom* aName,
                                              bool aNotify)
{
  if (aNamespaceID == kNameSpaceID_None) {
    if (aName == nsGkAtoms::src) {
      // If aNotify is false, we are coming from the parser or some such place;
      // we'll get bound after all the attributes have been set, so we'll do the
      // object load from BindToTree/DoneAddingChildren.
      // Skip the LoadObject call in that case.
      // We also don't want to start loading the object when we're not yet in
      // a document, just in case that the caller wants to set additional
      // attributes before inserting the node into the document.
      if (aNotify && IsInComposedDoc() && mIsDoneAddingChildren &&
          !BlockEmbedOrObjectContentLoading()) {
        nsresult rv = LoadObject(aNotify, true);
        NS_ENSURE_SUCCESS(rv, rv);
      }
    }
  }

  return NS_OK;
}

bool
HTMLAppletElement::IsHTMLFocusable(bool aWithMouse,
                                         bool *aIsFocusable,
                                         int32_t *aTabIndex)
{
  if (mNodeInfo->Equals(nsGkAtoms::embed) || Type() == eType_Plugin) {
    // Has plugin content: let the plugin decide what to do in terms of
    // internal focus from mouse clicks
    if (aTabIndex) {
      *aTabIndex = TabIndex();
    }

    *aIsFocusable = true;

    // Let the plugin decide, so override.
    return true;
  }

  return nsGenericHTMLElement::IsHTMLFocusable(aWithMouse, aIsFocusable, aTabIndex);
}

nsIContent::IMEState
HTMLAppletElement::GetDesiredIMEState()
{
  if (Type() == eType_Plugin) {
    return IMEState(IMEState::PLUGIN);
  }

  return nsGenericHTMLElement::GetDesiredIMEState();
}


//NS_IMPL_STRING_ATTR(HTMLAppletElement, Align, align)
/*
NS_IMPL_STRING_ATTR(HTMLAppletElement, Alt, alt)
NS_IMPL_STRING_ATTR(HTMLAppletElement, Archive, archive)
NS_IMPL_STRING_ATTR(HTMLAppletElement, Code, code)
NS_IMPL_URI_ATTR(HTMLAppletElement, CodeBase, codebase)
NS_IMPL_STRING_ATTR(HTMLAppletElement, Height, height)
NS_IMPL_INT_ATTR(HTMLAppletElement, Hspace, hspace)
NS_IMPL_STRING_ATTR(HTMLAppletElement, Name, name)
NS_IMPL_URI_ATTR_WITH_BASE(HTMLAppletElement, Object, object, codebase)
NS_IMPL_URI_ATTR(HTMLAppletElement, Src, src)
NS_IMPL_STRING_ATTR(HTMLAppletElement, Type, type)
NS_IMPL_INT_ATTR(HTMLAppletElement, Vspace, vspace)
NS_IMPL_STRING_ATTR(HTMLAppletElement, Width, width)
*/


int32_t
HTMLAppletElement::TabIndexDefault()
{
  return -1;
}

#if 0
bool
HTMLAppletElement::ParseAttribute(int32_t aNamespaceID,
                                        nsAtom *aAttribute,
                                        const nsAString &aValue,
                                        nsIPrincipal* aMaybeScriptedPrincipal,
                                        nsAttrValue &aResult)
{
  if (aNamespaceID == kNameSpaceID_None) {
    if (aAttribute == nsGkAtoms::align) {
      return ParseAlignValue(aValue, aResult);
    }
    if (ParseImageAttribute(aAttribute, aValue, aResult)) {
      return true;
    }
  }

  return nsGenericHTMLElement::ParseAttribute(aNamespaceID, aAttribute, aValue, aMaybeScriptedPrincipal,
                                              aResult);
}

static void
MapAttributesIntoRuleBaseApplet(const nsMappedAttributes *aAttributes,
                          MappedDeclarations& aData)
{
  nsGenericHTMLElement::MapImageBorderAttributeInto(aAttributes, aData);
  nsGenericHTMLElement::MapImageMarginAttributeInto(aAttributes, aData);
  nsGenericHTMLElement::MapImageSizeAttributesInto(aAttributes, aData);
  nsGenericHTMLElement::MapImageAlignAttributeInto(aAttributes, aData);
}

static void
MapAttributesIntoRuleExceptHiddenApplet(const nsMappedAttributes *aAttributes,
                                  MappedDeclarations& aData)
{
  MapAttributesIntoRuleBaseApplet(aAttributes, aData);
  nsGenericHTMLElement::MapCommonAttributesIntoExceptHidden(aAttributes, aData);
}

void
HTMLAppletElement::MapAttributesIntoRule(const nsMappedAttributes *aAttributes,
                                               MappedDeclarations& aData)
{
  MapAttributesIntoRuleBaseApplet(aAttributes, aData);
  nsGenericHTMLElement::MapCommonAttributesInto(aAttributes, aData);
}

NS_IMETHODIMP_(bool)
HTMLAppletElement::IsAttributeMapped(const nsAtom *aAttribute) const
{
  static const MappedAttributeEntry* const map[] = {
    sCommonAttributeMap,
    sImageMarginSizeAttributeMap,
    sImageBorderAttributeMap,
    sImageAlignAttributeMap,
  };

  return FindAttributeDependence(aAttribute, map);
}

nsMapRuleToAttributesFunc
HTMLAppletElement::GetAttributeMappingFunction() const
{
  if (mNodeInfo->Equals(nsGkAtoms::embed)) {
    return &MapAttributesIntoRuleExceptHiddenApplet;
  }

  return &MapAttributesIntoRule;
}
#endif


void
HTMLAppletElement::StartObjectLoad(bool aNotify, bool aForceLoad)
{
  // BindToTree can call us asynchronously, and we may be removed from the tree
  // in the interim
  if (!IsInComposedDoc() || !OwnerDoc()->IsActive() ||
      BlockEmbedOrObjectContentLoading()) {
    return;
  }

  LoadObject(aNotify, aForceLoad);
  SetIsNetworkCreated(false);
}

EventStates
HTMLAppletElement::IntrinsicState() const
{
  return nsGenericHTMLElement::IntrinsicState() | ObjectState();
}

uint32_t
HTMLAppletElement::GetCapabilities() const
{
  uint32_t capabilities = eSupportPlugins | eAllowPluginSkipChannel;
  if (mNodeInfo->Equals(nsGkAtoms::embed)) {
    capabilities |= eSupportImages | eSupportDocuments;
  }

  return capabilities;
}

void
HTMLAppletElement::DestroyContent()
{
  nsObjectLoadingContent::DestroyContent();
  nsGenericHTMLElement::DestroyContent();
}

nsresult
HTMLAppletElement::CopyInnerTo(Element* aDest)
{
  nsresult rv = nsGenericHTMLElement::CopyInnerTo(aDest);
  NS_ENSURE_SUCCESS(rv, rv);

  if (aDest->OwnerDoc()->IsStaticDocument()) {
    CreateStaticClone(static_cast<HTMLAppletElement*>(aDest));
  }

  return rv;
}

JSObject*
HTMLAppletElement::WrapNode(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  JSObject* obj = nullptr;
  if (mNodeInfo->Equals(nsGkAtoms::applet)) {
    obj = HTMLAppletElement_Binding::Wrap(aCx, this, aGivenProto);
  } 
  if (!obj) {
    return nullptr;
  }
  JS::Rooted<JSObject*> rootedObj(aCx, obj);
  SetupProtoChain(aCx, rootedObj);
  return rootedObj;
}



nsContentPolicyType
HTMLAppletElement::GetContentPolicyType() const
{
  if (mNodeInfo->Equals(nsGkAtoms::applet)) {
    // We use TYPE_INTERNAL_OBJECT for applet too, since it is not exposed
    // through RequestContext yet.
    return nsIContentPolicy::TYPE_INTERNAL_OBJECT;
  } else {
    MOZ_ASSERT(mNodeInfo->Equals(nsGkAtoms::embed));
    return nsIContentPolicy::TYPE_INTERNAL_EMBED;
  }
}

} // namespace dom
} // namespace mozilla
