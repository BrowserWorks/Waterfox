/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ScriptElement.h"
#include "ScriptLoader.h"
#include "mozilla/BasicEvents.h"
#include "mozilla/EventDispatcher.h"
#include "mozilla/dom/Element.h"
#include "nsContentUtils.h"
#include "nsPresContext.h"
#include "nsIParser.h"
#include "nsGkAtoms.h"
#include "nsContentSink.h"

using namespace mozilla;
using namespace mozilla::dom;

NS_IMETHODIMP
ScriptElement::ScriptAvailable(nsresult aResult,
                               nsIScriptElement* aElement,
                               bool aIsInline,
                               nsIURI* aURI,
                               int32_t aLineNo)
{
  if (!aIsInline && NS_FAILED(aResult)) {
    nsCOMPtr<nsIParser> parser = do_QueryReferent(mCreatorParser);
    if (parser) {
      parser->PushDefinedInsertionPoint();
    }
    nsresult rv = FireErrorEvent();
    if (parser) {
      parser->PopDefinedInsertionPoint();
    }
    return rv;
  }
  return NS_OK;
}

/* virtual */ nsresult
ScriptElement::FireErrorEvent()
{
  nsCOMPtr<nsIContent> cont =
    do_QueryInterface((nsIScriptElement*) this);

  return nsContentUtils::DispatchTrustedEvent(cont->OwnerDoc(),
                                              cont,
                                              NS_LITERAL_STRING("error"),
                                              false /* bubbles */,
                                              false /* cancelable */);
}

NS_IMETHODIMP
ScriptElement::ScriptEvaluated(nsresult aResult,
                               nsIScriptElement* aElement,
                               bool aIsInline)
{
  nsresult rv = NS_OK;
  if (!aIsInline) {
    nsCOMPtr<nsIContent> cont =
      do_QueryInterface((nsIScriptElement*) this);

    RefPtr<nsPresContext> presContext =
      nsContentUtils::GetContextForContent(cont);

    nsEventStatus status = nsEventStatus_eIgnore;
    EventMessage message = NS_SUCCEEDED(aResult) ? eLoad : eLoadError;
    WidgetEvent event(true, message);
    // Load event doesn't bubble.
    event.mFlags.mBubbles = (message != eLoad);

    EventDispatcher::Dispatch(cont, presContext, &event, nullptr, &status);
  }

  return rv;
}

void
ScriptElement::CharacterDataChanged(nsIDocument* aDocument,
                                    nsIContent* aContent,
                                    CharacterDataChangeInfo* aInfo)
{
  MaybeProcessScript();
}

void
ScriptElement::AttributeChanged(nsIDocument* aDocument,
                                Element* aElement,
                                int32_t aNameSpaceID,
                                nsIAtom* aAttribute,
                                int32_t aModType,
                                const nsAttrValue* aOldValue)
{
  MaybeProcessScript();
}

void
ScriptElement::ContentAppended(nsIDocument* aDocument,
                               nsIContent* aContainer,
                               nsIContent* aFirstNewContent,
                               int32_t aNewIndexInContainer)
{
  MaybeProcessScript();
}

void
ScriptElement::ContentInserted(nsIDocument* aDocument,
                               nsIContent* aContainer,
                               nsIContent* aChild,
                               int32_t aIndexInContainer)
{
  MaybeProcessScript();
}

bool
ScriptElement::MaybeProcessScript()
{
  nsCOMPtr<nsIContent> cont =
    do_QueryInterface((nsIScriptElement*) this);

  NS_ASSERTION(cont->DebugGetSlots()->mMutationObservers.Contains(this),
               "You forgot to add self as observer");

  if (mAlreadyStarted || !mDoneAddingChildren ||
      !cont->GetComposedDoc() || mMalformed || !HasScriptContent()) {
    return false;
  }

  FreezeUriAsyncDefer();

  mAlreadyStarted = true;

  nsIDocument* ownerDoc = cont->OwnerDoc();
  nsCOMPtr<nsIParser> parser = ((nsIScriptElement*) this)->GetCreatorParser();
  if (parser) {
    nsCOMPtr<nsIContentSink> sink = parser->GetContentSink();
    if (sink) {
      nsCOMPtr<nsIDocument> parserDoc = do_QueryInterface(sink->GetTarget());
      if (ownerDoc != parserDoc) {
        // Willful violation of HTML5 as of 2010-12-01
        return false;
      }
    }
  }

  RefPtr<ScriptLoader> loader = ownerDoc->ScriptLoader();
  return loader->ProcessScriptElement(this);
}
