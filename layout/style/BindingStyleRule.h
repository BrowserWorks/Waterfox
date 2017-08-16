/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_BindingStyleRule_h__
#define mozilla_BindingStyleRule_h__

#include "nscore.h"
#include "nsStringGlue.h"
#include "mozilla/css/Rule.h"

/**
 * Shared superclass for mozilla::css::StyleRule and mozilla::ServoStyleRule,
 * for use from bindings code.
 */

class nsICSSDeclaration;

namespace mozilla {

class BindingStyleRule : public css::Rule
{
protected:
  BindingStyleRule(uint32_t aLineNumber, uint32_t aColumnNumber)
    : css::Rule(aLineNumber, aColumnNumber)
  {
  }
  BindingStyleRule(const BindingStyleRule& aCopy)
    : css::Rule(aCopy)
  {
  }
  virtual ~BindingStyleRule() {}

public:
  // This is pure virtual because we have no members, and are an abstract class
  // to start with.  The fact that we have to have this declaration at all is
  // kinda dumb.  :(
  virtual size_t SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf)
    const override MOZ_MUST_OVERRIDE = 0;

  // Likewise for this one.  We have to override our superclass, but don't
  // really need to do anything in this method.
  virtual bool IsCCLeaf() const override MOZ_MUST_OVERRIDE = 0;

  virtual uint32_t GetSelectorCount() = 0;
  virtual nsresult GetSelectorText(uint32_t aSelectorIndex, nsAString& aText) = 0;
  virtual nsresult GetSpecificity(uint32_t aSelectorIndex,
                                  uint64_t* aSpecificity) = 0;
  virtual nsresult SelectorMatchesElement(dom::Element* aElement,
                                          uint32_t aSelectorIndex,
                                          const nsAString& aPseudo,
                                          bool* aMatches) = 0;

  // WebIDL API
  // For GetSelectorText/SetSelectorText, we purposefully use a signature that
  // matches the nsIDOMCSSStyleRule one for now, so subclasses can just
  // implement both at once.  The actual implementations must never return
  // anything other than NS_OK;
  NS_IMETHOD GetSelectorText(nsAString& aSelectorText) = 0;
  NS_IMETHOD SetSelectorText(const nsAString& aSelectorText) = 0;
  virtual nsICSSDeclaration* Style() = 0;

  virtual JSObject* WrapObject(JSContext* aCx,
                               JS::Handle<JSObject*> aGivenProto) override;
};

} // namespace mozilla

#endif // mozilla_BindingStyleRule_h__
