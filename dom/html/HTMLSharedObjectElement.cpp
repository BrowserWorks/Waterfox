/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/EventStates.h"
#include "mozilla/dom/HTMLSharedObjectElement.h"
#include "mozilla/dom/HTMLEmbedElementBinding.h"
#include "mozilla/dom/HTMLAppletElementBinding.h"
#include "mozilla/dom/ElementInlines.h"

#include "nsIDocument.h"
#include "nsIPluginDocument.h"
#include "nsIDOMDocument.h"
#include "nsThreadUtils.h"
#include "nsIScriptError.h"
#include "nsIWidget.h"
#include "nsContentUtils.h"
#ifdef XP_MACOSX
#include "mozilla/EventDispatcher.h"
#include "mozilla/dom/Event.h"
#endif
#include "mozilla/dom/HTMLObjectElement.h"


NS_IMPL_NS_NEW_HTML_ELEMENT_CHECK_PARSER(SharedObject)

namespace mozilla {
namespace dom {

HTMLSharedObjectElement::HTMLSharedObjectElement(already_AddRefed<mozilla::dom::NodeInfo>& aNodeInfo,
                                                 FromParser aFromParser)
  : nsGenericHTMLElement(aNodeInfo),
    mIsDoneAddingChildren(mNodeInfo->Equals(nsGkAtoms::embed) || !aFromParser)
{
  RegisterActivityObserver();
  SetIsNetworkCreated(aFromParser == FROM_PARSER_NETWORK);

  // By default we're in the loading state
  AddStatesSilently(NS_EVENT_STATE_LOADING);
}

HTMLSharedObjectElement::~HTMLSharedObjectElement()
{
#ifdef XP_MACOSX
  HTMLObjectElement::OnFocusBlurPlugin(this, false);
#endif
  UnregisterActivityObserver();
  DestroyImageLoadingContent();
}

bool
HTMLSharedObjectElement::IsDoneAddingChildren()
{
  return mIsDoneAddingChildren;
}

void
HTMLSharedObjectElement::DoneAddingChildren(bool aHaveNotified)
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

NS_IMPL_CYCLE_COLLECTION_CLASS(HTMLSharedObjectElement)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(HTMLSharedObjectElement,
                                                  nsGenericHTMLElement)
  nsObjectLoadingContent::Traverse(tmp, cb);
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_ADDREF_INHERITED(HTMLSharedObjectElement, Element)
NS_IMPL_RELEASE_INHERITED(HTMLSharedObjectElement, Element)

NS_INTERFACE_TABLE_HEAD_CYCLE_COLLECTION_INHERITED(HTMLSharedObjectElement)
  NS_INTERFACE_TABLE_INHERITED(HTMLSharedObjectElement,
                               nsIRequestObserver,
                               nsIStreamListener,
                               nsIFrameLoaderOwner,
                               nsIObjectLoadingContent,
                               imgINotificationObserver,
                               nsIImageLoadingContent,
                               imgIOnloadBlocker,
                               nsIChannelEventSink)
  NS_INTERFACE_TABLE_TO_MAP_SEGUE
  NS_INTERFACE_MAP_ENTRY_IF_TAG(nsIDOMHTMLAppletElement, applet)
  NS_INTERFACE_MAP_ENTRY_IF_TAG(nsIDOMHTMLEmbedElement, embed)
NS_INTERFACE_MAP_END_INHERITING(nsGenericHTMLElement)

NS_IMPL_ELEMENT_CLONE(HTMLSharedObjectElement)

#ifdef XP_MACOSX

NS_IMETHODIMP
HTMLSharedObjectElement::PostHandleEvent(EventChainPostVisitor& aVisitor)
{
  HTMLObjectElement::HandleFocusBlurPlugin(this, aVisitor.mEvent);
  return NS_OK;
}

#endif // #ifdef XP_MACOSX

void
HTMLSharedObjectElement::AsyncEventRunning(AsyncEventDispatcher* aEvent)
{
  nsImageLoadingContent::AsyncEventRunning(aEvent);
}

nsresult
HTMLSharedObjectElement::BindToTree(nsIDocument *aDocument,
                                    nsIContent *aParent,
                                    nsIContent *aBindingParent,
                                    bool aCompileEventHandlers)
{
  nsresult rv = nsGenericHTMLElement::BindToTree(aDocument, aParent,
                                                 aBindingParent,
                                                 aCompileEventHandlers);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = nsObjectLoadingContent::BindToTree(aDocument, aParent,
                                          aBindingParent,
                                          aCompileEventHandlers);
  NS_ENSURE_SUCCESS(rv, rv);

  // Don't kick off load from being bound to a plugin document - the plugin
  // document will call nsObjectLoadingContent::InitializeFromChannel() for the
  // initial load.
  nsCOMPtr<nsIPluginDocument> pluginDoc = do_QueryInterface(aDocument);

  // If we already have all the children, start the load.
  if (mIsDoneAddingChildren && !pluginDoc) {
    void (HTMLSharedObjectElement::*start)() =
      &HTMLSharedObjectElement::StartObjectLoad;
    nsContentUtils::AddScriptRunner(NewRunnableMethod(this, start));
  }

  return NS_OK;
}

void
HTMLSharedObjectElement::UnbindFromTree(bool aDeep,
                                        bool aNullParent)
{
#ifdef XP_MACOSX
  // When a page is reloaded (when an nsIDocument's content is removed), the
  // focused element isn't necessarily sent an eBlur event. See
  // nsFocusManager::ContentRemoved(). This means that a widget may think it
  // still contains a focused plugin when it doesn't -- which in turn can
  // disable text input in the browser window. See bug 1137229.
  HTMLObjectElement::OnFocusBlurPlugin(this, false);
#endif
  nsObjectLoadingContent::UnbindFromTree(aDeep, aNullParent);
  nsGenericHTMLElement::UnbindFromTree(aDeep, aNullParent);
}

nsresult
HTMLSharedObjectElement::AfterSetAttr(int32_t aNamespaceID, nsIAtom* aName,
                                      const nsAttrValue* aValue,
                                      const nsAttrValue* aOldValue,
                                      bool aNotify)
{
  if (aValue) {
    nsresult rv = AfterMaybeChangeAttr(aNamespaceID, aName, aNotify);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  return nsGenericHTMLElement::AfterSetAttr(aNamespaceID, aName, aValue,
                                            aOldValue, aNotify);
}

nsresult
HTMLSharedObjectElement::OnAttrSetButNotChanged(int32_t aNamespaceID,
                                                nsIAtom* aName,
                                                const nsAttrValueOrString& aValue,
                                                bool aNotify)
{
  nsresult rv = AfterMaybeChangeAttr(aNamespaceID, aName, aNotify);
  NS_ENSURE_SUCCESS(rv, rv);

  return nsGenericHTMLElement::OnAttrSetButNotChanged(aNamespaceID, aName,
                                                      aValue, aNotify);
}

nsresult
HTMLSharedObjectElement::AfterMaybeChangeAttr(int32_t aNamespaceID,
                                              nsIAtom* aName,
                                              bool aNotify)
{
  if (aNamespaceID == kNameSpaceID_None) {
    if (aName == URIAttrName()) {
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
HTMLSharedObjectElement::IsHTMLFocusable(bool aWithMouse,
                                         bool *aIsFocusable,
                                         int32_t *aTabIndex)
{
  if (mNodeInfo->Equals(nsGkAtoms::embed) || Type() == eType_Plugin) {
    // Has plugin content: let the plugin decide what to do in terms of
    // internal focus from mouse clicks
    if (aTabIndex) {
      GetTabIndex(aTabIndex);
    }

    *aIsFocusable = true;

    // Let the plugin decide, so override.
    return true;
  }

  return nsGenericHTMLElement::IsHTMLFocusable(aWithMouse, aIsFocusable, aTabIndex);
}

nsIContent::IMEState
HTMLSharedObjectElement::GetDesiredIMEState()
{
  if (Type() == eType_Plugin) {
    return IMEState(IMEState::PLUGIN);
  }
   
  return nsGenericHTMLElement::GetDesiredIMEState();
}

NS_IMPL_STRING_ATTR(HTMLSharedObjectElement, Align, align)
NS_IMPL_STRING_ATTR(HTMLSharedObjectElement, Alt, alt)
NS_IMPL_STRING_ATTR(HTMLSharedObjectElement, Archive, archive)
NS_IMPL_STRING_ATTR(HTMLSharedObjectElement, Code, code)
NS_IMPL_URI_ATTR(HTMLSharedObjectElement, CodeBase, codebase)
NS_IMPL_STRING_ATTR(HTMLSharedObjectElement, Height, height)
NS_IMPL_INT_ATTR(HTMLSharedObjectElement, Hspace, hspace)
NS_IMPL_STRING_ATTR(HTMLSharedObjectElement, Name, name)
NS_IMPL_URI_ATTR_WITH_BASE(HTMLSharedObjectElement, Object, object, codebase)
NS_IMPL_URI_ATTR(HTMLSharedObjectElement, Src, src)
NS_IMPL_STRING_ATTR(HTMLSharedObjectElement, Type, type)
NS_IMPL_INT_ATTR(HTMLSharedObjectElement, Vspace, vspace)
NS_IMPL_STRING_ATTR(HTMLSharedObjectElement, Width, width)

int32_t
HTMLSharedObjectElement::TabIndexDefault()
{
  return -1;
}

bool
HTMLSharedObjectElement::ParseAttribute(int32_t aNamespaceID,
                                        nsIAtom *aAttribute,
                                        const nsAString &aValue,
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

  return nsGenericHTMLElement::ParseAttribute(aNamespaceID, aAttribute, aValue,
                                              aResult);
}

static void
MapAttributesIntoRuleBase(const nsMappedAttributes *aAttributes,
                          GenericSpecifiedValues* aData)
{
  nsGenericHTMLElement::MapImageBorderAttributeInto(aAttributes, aData);
  nsGenericHTMLElement::MapImageMarginAttributeInto(aAttributes, aData);
  nsGenericHTMLElement::MapImageSizeAttributesInto(aAttributes, aData);
  nsGenericHTMLElement::MapImageAlignAttributeInto(aAttributes, aData);
}

static void
MapAttributesIntoRuleExceptHidden(const nsMappedAttributes *aAttributes,
                                  GenericSpecifiedValues* aData)
{
  MapAttributesIntoRuleBase(aAttributes, aData);
  nsGenericHTMLElement::MapCommonAttributesIntoExceptHidden(aAttributes, aData);
}

void
HTMLSharedObjectElement::MapAttributesIntoRule(const nsMappedAttributes *aAttributes,
                                               GenericSpecifiedValues* aData)
{
  MapAttributesIntoRuleBase(aAttributes, aData);
  nsGenericHTMLElement::MapCommonAttributesInto(aAttributes, aData);
}

NS_IMETHODIMP_(bool)
HTMLSharedObjectElement::IsAttributeMapped(const nsIAtom *aAttribute) const
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
HTMLSharedObjectElement::GetAttributeMappingFunction() const
{
  if (mNodeInfo->Equals(nsGkAtoms::embed)) {
    return &MapAttributesIntoRuleExceptHidden;
  }

  return &MapAttributesIntoRule;
}

void
HTMLSharedObjectElement::StartObjectLoad(bool aNotify, bool aForceLoad)
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
HTMLSharedObjectElement::IntrinsicState() const
{
  return nsGenericHTMLElement::IntrinsicState() | ObjectState();
}

uint32_t
HTMLSharedObjectElement::GetCapabilities() const
{
  uint32_t capabilities = eSupportPlugins | eAllowPluginSkipChannel;
  if (mNodeInfo->Equals(nsGkAtoms::embed)) {
    capabilities |= eSupportImages | eSupportDocuments;
  }

  return capabilities;
}

void
HTMLSharedObjectElement::DestroyContent()
{
  nsObjectLoadingContent::DestroyContent();
  nsGenericHTMLElement::DestroyContent();
}

nsresult
HTMLSharedObjectElement::CopyInnerTo(Element* aDest, bool aPreallocateChildren)
{
  nsresult rv = nsGenericHTMLElement::CopyInnerTo(aDest, aPreallocateChildren);
  NS_ENSURE_SUCCESS(rv, rv);

  if (aDest->OwnerDoc()->IsStaticDocument()) {
    CreateStaticClone(static_cast<HTMLSharedObjectElement*>(aDest));
  }

  return rv;
}

JSObject*
HTMLSharedObjectElement::WrapNode(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  JSObject* obj;
  if (mNodeInfo->Equals(nsGkAtoms::applet)) {
    obj = HTMLAppletElementBinding::Wrap(aCx, this, aGivenProto);
  } else {
    MOZ_ASSERT(mNodeInfo->Equals(nsGkAtoms::embed));
    obj = HTMLEmbedElementBinding::Wrap(aCx, this, aGivenProto);
  }
  if (!obj) {
    return nullptr;
  }
  JS::Rooted<JSObject*> rootedObj(aCx, obj);
  SetupProtoChain(aCx, rootedObj);
  return rootedObj;
}

nsContentPolicyType
HTMLSharedObjectElement::GetContentPolicyType() const
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
