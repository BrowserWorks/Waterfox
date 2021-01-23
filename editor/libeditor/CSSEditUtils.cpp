/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/CSSEditUtils.h"

#include "mozilla/Assertions.h"
#include "mozilla/ChangeStyleTransaction.h"
#include "mozilla/HTMLEditor.h"
#include "mozilla/Preferences.h"
#include "mozilla/DeclarationBlock.h"
#include "mozilla/dom/Element.h"
#include "mozilla/mozalloc.h"
#include "nsAString.h"
#include "nsCOMPtr.h"
#include "nsCSSProps.h"
#include "nsColor.h"
#include "nsComputedDOMStyle.h"
#include "nsDebug.h"
#include "nsDependentSubstring.h"
#include "nsError.h"
#include "nsGkAtoms.h"
#include "nsAtom.h"
#include "nsIContent.h"
#include "nsICSSDeclaration.h"
#include "mozilla/dom/Document.h"
#include "nsINode.h"
#include "nsISupportsImpl.h"
#include "nsISupportsUtils.h"
#include "nsLiteralString.h"
#include "nsPIDOMWindow.h"
#include "nsReadableUtils.h"
#include "nsString.h"
#include "nsStringFwd.h"
#include "nsStringIterator.h"
#include "nsStyledElement.h"
#include "nsUnicharUtils.h"

namespace mozilla {

using namespace dom;

static void ProcessBValue(const nsAString* aInputString,
                          nsAString& aOutputString,
                          const char* aDefaultValueString,
                          const char* aPrependString,
                          const char* aAppendString) {
  if (aInputString && aInputString->EqualsLiteral("-moz-editor-invert-value")) {
    aOutputString.AssignLiteral("normal");
  } else {
    aOutputString.AssignLiteral("bold");
  }
}

static void ProcessDefaultValue(const nsAString* aInputString,
                                nsAString& aOutputString,
                                const char* aDefaultValueString,
                                const char* aPrependString,
                                const char* aAppendString) {
  CopyASCIItoUTF16(MakeStringSpan(aDefaultValueString), aOutputString);
}

static void ProcessSameValue(const nsAString* aInputString,
                             nsAString& aOutputString,
                             const char* aDefaultValueString,
                             const char* aPrependString,
                             const char* aAppendString) {
  if (aInputString) {
    aOutputString.Assign(*aInputString);
  } else
    aOutputString.Truncate();
}

static void ProcessExtendedValue(const nsAString* aInputString,
                                 nsAString& aOutputString,
                                 const char* aDefaultValueString,
                                 const char* aPrependString,
                                 const char* aAppendString) {
  aOutputString.Truncate();
  if (aInputString) {
    if (aPrependString) {
      AppendASCIItoUTF16(MakeStringSpan(aPrependString), aOutputString);
    }
    aOutputString.Append(*aInputString);
    if (aAppendString) {
      AppendASCIItoUTF16(MakeStringSpan(aAppendString), aOutputString);
    }
  }
}

static void ProcessLengthValue(const nsAString* aInputString,
                               nsAString& aOutputString,
                               const char* aDefaultValueString,
                               const char* aPrependString,
                               const char* aAppendString) {
  aOutputString.Truncate();
  if (aInputString) {
    aOutputString.Append(*aInputString);
    if (-1 == aOutputString.FindChar(char16_t('%'))) {
      aOutputString.AppendLiteral("px");
    }
  }
}

static void ProcessListStyleTypeValue(const nsAString* aInputString,
                                      nsAString& aOutputString,
                                      const char* aDefaultValueString,
                                      const char* aPrependString,
                                      const char* aAppendString) {
  aOutputString.Truncate();
  if (aInputString) {
    if (aInputString->EqualsLiteral("1")) {
      aOutputString.AppendLiteral("decimal");
    } else if (aInputString->EqualsLiteral("a")) {
      aOutputString.AppendLiteral("lower-alpha");
    } else if (aInputString->EqualsLiteral("A")) {
      aOutputString.AppendLiteral("upper-alpha");
    } else if (aInputString->EqualsLiteral("i")) {
      aOutputString.AppendLiteral("lower-roman");
    } else if (aInputString->EqualsLiteral("I")) {
      aOutputString.AppendLiteral("upper-roman");
    } else if (aInputString->EqualsLiteral("square") ||
               aInputString->EqualsLiteral("circle") ||
               aInputString->EqualsLiteral("disc")) {
      aOutputString.Append(*aInputString);
    }
  }
}

static void ProcessMarginLeftValue(const nsAString* aInputString,
                                   nsAString& aOutputString,
                                   const char* aDefaultValueString,
                                   const char* aPrependString,
                                   const char* aAppendString) {
  aOutputString.Truncate();
  if (aInputString) {
    if (aInputString->EqualsLiteral("center") ||
        aInputString->EqualsLiteral("-moz-center")) {
      aOutputString.AppendLiteral("auto");
    } else if (aInputString->EqualsLiteral("right") ||
               aInputString->EqualsLiteral("-moz-right")) {
      aOutputString.AppendLiteral("auto");
    } else {
      aOutputString.AppendLiteral("0px");
    }
  }
}

static void ProcessMarginRightValue(const nsAString* aInputString,
                                    nsAString& aOutputString,
                                    const char* aDefaultValueString,
                                    const char* aPrependString,
                                    const char* aAppendString) {
  aOutputString.Truncate();
  if (aInputString) {
    if (aInputString->EqualsLiteral("center") ||
        aInputString->EqualsLiteral("-moz-center")) {
      aOutputString.AppendLiteral("auto");
    } else if (aInputString->EqualsLiteral("left") ||
               aInputString->EqualsLiteral("-moz-left")) {
      aOutputString.AppendLiteral("auto");
    } else {
      aOutputString.AppendLiteral("0px");
    }
  }
}

const CSSEditUtils::CSSEquivTable boldEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_font_weight, ProcessBValue, nullptr,
     nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable italicEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_font_style, ProcessDefaultValue,
     "italic", nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable underlineEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_text_decoration, ProcessDefaultValue,
     "underline", nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable strikeEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_text_decoration, ProcessDefaultValue,
     "line-through", nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable ttEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_font_family, ProcessDefaultValue,
     "monospace", nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable fontColorEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_color, ProcessSameValue, nullptr,
     nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable fontFaceEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_font_family, ProcessSameValue, nullptr,
     nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable bgcolorEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_background_color, ProcessSameValue,
     nullptr, nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable backgroundImageEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_background_image, ProcessExtendedValue,
     nullptr, "url(", ")", true, true},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable textColorEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_color, ProcessSameValue, nullptr,
     nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable borderEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_border, ProcessExtendedValue, nullptr,
     nullptr, "px solid", true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable textAlignEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_text_align, ProcessSameValue, nullptr,
     nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable captionAlignEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_caption_side, ProcessSameValue, nullptr,
     nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable verticalAlignEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_vertical_align, ProcessSameValue,
     nullptr, nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable nowrapEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_whitespace, ProcessDefaultValue,
     "nowrap", nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable widthEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_width, ProcessLengthValue, nullptr,
     nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable heightEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_height, ProcessLengthValue, nullptr,
     nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable listStyleTypeEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_list_style_type,
     ProcessListStyleTypeValue, nullptr, nullptr, nullptr, true, true},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable tableAlignEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_text_align, ProcessDefaultValue, "left",
     nullptr, nullptr, false, false},
    {CSSEditUtils::eCSSEditableProperty_margin_left, ProcessMarginLeftValue,
     nullptr, nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_margin_right, ProcessMarginRightValue,
     nullptr, nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

const CSSEditUtils::CSSEquivTable hrAlignEquivTable[] = {
    {CSSEditUtils::eCSSEditableProperty_margin_left, ProcessMarginLeftValue,
     nullptr, nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_margin_right, ProcessMarginRightValue,
     nullptr, nullptr, nullptr, true, false},
    {CSSEditUtils::eCSSEditableProperty_NONE, 0}};

CSSEditUtils::CSSEditUtils(HTMLEditor* aHTMLEditor)
    : mHTMLEditor(aHTMLEditor), mIsCSSPrefChecked(true) {
  // let's retrieve the value of the "CSS editing" pref
  mIsCSSPrefChecked = Preferences::GetBool("editor.use_css", mIsCSSPrefChecked);
}

// Answers true if we have some CSS equivalence for the HTML style defined
// by aProperty and/or aAttribute for the node aNode

// static
bool CSSEditUtils::IsCSSEditableProperty(nsINode* aNode, nsAtom* aProperty,
                                         nsAtom* aAttribute) {
  MOZ_ASSERT(aNode);

  Element* element = aNode->GetAsElementOrParentElement();
  if (NS_WARN_IF(!element)) {
    return false;
  }

  // html inline styles B I TT U STRIKE and COLOR/FACE on FONT
  if (nsGkAtoms::b == aProperty || nsGkAtoms::i == aProperty ||
      nsGkAtoms::tt == aProperty || nsGkAtoms::u == aProperty ||
      nsGkAtoms::strike == aProperty ||
      (nsGkAtoms::font == aProperty && aAttribute &&
       (aAttribute == nsGkAtoms::color || aAttribute == nsGkAtoms::face))) {
    return true;
  }

  // ALIGN attribute on elements supporting it
  if (aAttribute == nsGkAtoms::align &&
      element->IsAnyOfHTMLElements(
          nsGkAtoms::div, nsGkAtoms::p, nsGkAtoms::h1, nsGkAtoms::h2,
          nsGkAtoms::h3, nsGkAtoms::h4, nsGkAtoms::h5, nsGkAtoms::h6,
          nsGkAtoms::td, nsGkAtoms::th, nsGkAtoms::table, nsGkAtoms::hr,
          // For the above, why not use
          // HTMLEditUtils::SupportsAlignAttr?
          // It also checks for tbody, tfoot, thead.
          // Let's add the following elements here even
          // if "align" has a different meaning for them
          nsGkAtoms::legend, nsGkAtoms::caption)) {
    return true;
  }

  if (aAttribute == nsGkAtoms::valign &&
      element->IsAnyOfHTMLElements(
          nsGkAtoms::col, nsGkAtoms::colgroup, nsGkAtoms::tbody, nsGkAtoms::td,
          nsGkAtoms::th, nsGkAtoms::tfoot, nsGkAtoms::thead, nsGkAtoms::tr)) {
    return true;
  }

  // attributes TEXT, BACKGROUND and BGCOLOR on BODY
  if (element->IsHTMLElement(nsGkAtoms::body) &&
      (aAttribute == nsGkAtoms::text || aAttribute == nsGkAtoms::background ||
       aAttribute == nsGkAtoms::bgcolor)) {
    return true;
  }

  // attribute BGCOLOR on other elements
  if (aAttribute == nsGkAtoms::bgcolor) {
    return true;
  }

  // attributes HEIGHT, WIDTH and NOWRAP on TD and TH
  if (element->IsAnyOfHTMLElements(nsGkAtoms::td, nsGkAtoms::th) &&
      (aAttribute == nsGkAtoms::height || aAttribute == nsGkAtoms::width ||
       aAttribute == nsGkAtoms::nowrap)) {
    return true;
  }

  // attributes HEIGHT and WIDTH on TABLE
  if (element->IsHTMLElement(nsGkAtoms::table) &&
      (aAttribute == nsGkAtoms::height || aAttribute == nsGkAtoms::width)) {
    return true;
  }

  // attributes SIZE and WIDTH on HR
  if (element->IsHTMLElement(nsGkAtoms::hr) &&
      (aAttribute == nsGkAtoms::size || aAttribute == nsGkAtoms::width)) {
    return true;
  }

  // attribute TYPE on OL UL LI
  if (element->IsAnyOfHTMLElements(nsGkAtoms::ol, nsGkAtoms::ul,
                                   nsGkAtoms::li) &&
      aAttribute == nsGkAtoms::type) {
    return true;
  }

  if (element->IsHTMLElement(nsGkAtoms::img) &&
      (aAttribute == nsGkAtoms::border || aAttribute == nsGkAtoms::width ||
       aAttribute == nsGkAtoms::height)) {
    return true;
  }

  // other elements that we can align using CSS even if they
  // can't carry the html ALIGN attribute
  if (aAttribute == nsGkAtoms::align &&
      element->IsAnyOfHTMLElements(nsGkAtoms::ul, nsGkAtoms::ol, nsGkAtoms::dl,
                                   nsGkAtoms::li, nsGkAtoms::dd, nsGkAtoms::dt,
                                   nsGkAtoms::address, nsGkAtoms::pre)) {
    return true;
  }

  return false;
}

// The lowest level above the transaction; adds the CSS declaration
// "aProperty : aValue" to the inline styles carried by aElement
nsresult CSSEditUtils::SetCSSProperty(Element& aElement, nsAtom& aProperty,
                                      const nsAString& aValue,
                                      bool aSuppressTxn) {
  nsCOMPtr<nsStyledElement> styledElement = do_QueryInterface(&aElement);
  if (NS_WARN_IF(!styledElement)) {
    return NS_ERROR_INVALID_ARG;
  }
  RefPtr<ChangeStyleTransaction> transaction =
      ChangeStyleTransaction::Create(*styledElement, aProperty, aValue);
  if (aSuppressTxn) {
    return transaction->DoTransaction();
  }
  if (NS_WARN_IF(!mHTMLEditor)) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  RefPtr<HTMLEditor> htmlEditor(mHTMLEditor);
  nsresult rv = htmlEditor->DoTransactionInternal(transaction);
  NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                       "EditorBase::DoTransactionInternal() failed");
  return rv;
}

nsresult CSSEditUtils::SetCSSPropertyPixels(Element& aElement,
                                            nsAtom& aProperty,
                                            int32_t aIntValue) {
  nsAutoString s;
  s.AppendInt(aIntValue);
  nsresult rv = SetCSSProperty(aElement, aProperty, s + NS_LITERAL_STRING("px"),
                               /* suppress txn */ false);
  NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                       "CSSEditUtils::SetCSSProperty() failed");
  return rv;
}

// The lowest level above the transaction; removes the value aValue from the
// list of values specified for the CSS property aProperty, or totally remove
// the declaration if this property accepts only one value
nsresult CSSEditUtils::RemoveCSSProperty(Element& aElement, nsAtom& aProperty,
                                         const nsAString& aValue,
                                         bool aSuppressTxn) {
  nsCOMPtr<nsStyledElement> styledElement = do_QueryInterface(&aElement);
  if (NS_WARN_IF(!styledElement)) {
    return NS_ERROR_INVALID_ARG;
  }
  RefPtr<ChangeStyleTransaction> transaction =
      ChangeStyleTransaction::CreateToRemove(*styledElement, aProperty, aValue);
  if (aSuppressTxn) {
    nsresult rv = transaction->DoTransaction();
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                         "ChangeStyleTransaction::DoTransaction() failed");
    return rv;
  }
  if (NS_WARN_IF(!mHTMLEditor)) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  RefPtr<HTMLEditor> htmlEditor(mHTMLEditor);
  nsresult rv = htmlEditor->DoTransactionInternal(transaction);
  NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                       "EditorBase::DoTransactionInternal() failed");
  return rv;
}

// static
nsresult CSSEditUtils::GetSpecifiedProperty(nsIContent& aContent,
                                            nsAtom& aCSSProperty,
                                            nsAString& aValue) {
  nsresult rv =
      GetSpecifiedCSSInlinePropertyBase(aContent, aCSSProperty, aValue);
  NS_WARNING_ASSERTION(
      NS_SUCCEEDED(rv),
      "CSSEditUtils::GeSpecifiedCSSInlinePropertyBase() failed");
  return rv;
}

// static
nsresult CSSEditUtils::GetComputedProperty(nsIContent& aContent,
                                           nsAtom& aCSSProperty,
                                           nsAString& aValue) {
  nsresult rv =
      GetComputedCSSInlinePropertyBase(aContent, aCSSProperty, aValue);
  NS_WARNING_ASSERTION(
      NS_SUCCEEDED(rv),
      "CSSEditUtils::GetComputedCSSInlinePropertyBase() failed");
  return rv;
}

// static
nsresult CSSEditUtils::GetComputedCSSInlinePropertyBase(nsIContent& aContent,
                                                        nsAtom& aCSSProperty,
                                                        nsAString& aValue) {
  aValue.Truncate();

  RefPtr<Element> element = aContent.GetAsElementOrParentElement();
  if (NS_WARN_IF(!element)) {
    return NS_ERROR_INVALID_ARG;
  }

  // Get the all the computed css styles attached to the element node
  RefPtr<nsComputedDOMStyle> computedDOMStyle = GetComputedStyle(element);
  if (NS_WARN_IF(!computedDOMStyle)) {
    return NS_ERROR_INVALID_ARG;
  }

  // from these declarations, get the one we want and that one only
  //
  // FIXME(bug 1606994): nsAtomCString copies, we should just keep around the
  // property id.
  MOZ_ALWAYS_SUCCEEDS(
      computedDOMStyle->GetPropertyValue(nsAtomCString(&aCSSProperty), aValue));

  return NS_OK;
}

// static
nsresult CSSEditUtils::GetSpecifiedCSSInlinePropertyBase(nsIContent& aContent,
                                                         nsAtom& aCSSProperty,
                                                         nsAString& aValue) {
  aValue.Truncate();

  RefPtr<Element> element = aContent.GetAsElementOrParentElement();
  if (NS_WARN_IF(!element)) {
    return NS_ERROR_INVALID_ARG;
  }

  RefPtr<DeclarationBlock> decl = element->GetInlineStyleDeclaration();
  if (!decl) {
    return NS_OK;
  }

  nsCSSPropertyID prop =
      nsCSSProps::LookupProperty(nsAtomCString(&aCSSProperty));
  MOZ_ASSERT(prop != eCSSProperty_UNKNOWN);

  decl->GetPropertyValueByID(prop, aValue);

  return NS_OK;
}

// static
already_AddRefed<nsComputedDOMStyle> CSSEditUtils::GetComputedStyle(
    Element* aElement) {
  MOZ_ASSERT(aElement);

  Document* document = aElement->GetComposedDoc();
  if (NS_WARN_IF(!document)) {
    return nullptr;
  }

  RefPtr<nsComputedDOMStyle> computedDOMStyle =
      NS_NewComputedDOMStyle(aElement, EmptyString(), document);
  return computedDOMStyle.forget();
}

// remove the CSS style "aProperty : aPropertyValue" and possibly remove the
// whole node if it is a span and if its only attribute is _moz_dirty
nsresult CSSEditUtils::RemoveCSSInlineStyle(nsINode& aNode, nsAtom* aProperty,
                                            const nsAString& aPropertyValue) {
  OwningNonNull<Element> element(*aNode.AsElement());

  // remove the property from the style attribute
  nsresult rv = RemoveCSSProperty(element, *aProperty, aPropertyValue);
  if (NS_FAILED(rv)) {
    NS_WARNING("CSSEditUtils::RemoveCSSProperty() failed");
    return rv;
  }

  if (!element->IsHTMLElement(nsGkAtoms::span) ||
      HTMLEditor::HasAttributes(element)) {
    return NS_OK;
  }

  OwningNonNull<HTMLEditor> htmlEditor(*mHTMLEditor);
  rv = htmlEditor->RemoveContainerWithTransaction(element);
  NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                       "HTMLEditor::RemoveContainerWithTransaction() failed");
  return rv;
}

// Answers true if the property can be removed by setting a "none" CSS value
// on a node

// static
bool CSSEditUtils::IsCSSInvertible(nsAtom& aProperty, nsAtom* aAttribute) {
  return nsGkAtoms::b == &aProperty;
}

// Get the default browser background color if we need it for
// GetCSSBackgroundColorState

// static
void CSSEditUtils::GetDefaultBackgroundColor(nsAString& aColor) {
  if (Preferences::GetBool("editor.use_custom_colors", false)) {
    nsresult rv = Preferences::GetString("editor.background_color", aColor);
    // XXX Why don't you validate the pref value?
    if (NS_FAILED(rv)) {
      NS_WARNING("failed to get editor.background_color");
      aColor.AssignLiteral("#ffffff");  // Default to white
    }
    return;
  }

  if (Preferences::GetBool("browser.display.use_system_colors", false)) {
    return;
  }

  nsresult rv =
      Preferences::GetString("browser.display.background_color", aColor);
  // XXX Why don't you validate the pref value?
  if (NS_FAILED(rv)) {
    NS_WARNING("failed to get browser.display.background_color");
    aColor.AssignLiteral("#ffffff");  // Default to white
  }
}

// Get the default length unit used for CSS Indent/Outdent

// static
void CSSEditUtils::GetDefaultLengthUnit(nsAString& aLengthUnit) {
  nsresult rv =
      Preferences::GetString("editor.css.default_length_unit", aLengthUnit);
  // XXX Why don't you validate the pref value?
  if (NS_FAILED(rv)) {
    aLengthUnit.AssignLiteral("px");
  }
}

// static
void CSSEditUtils::ParseLength(const nsAString& aString, float* aValue,
                               nsAtom** aUnit) {
  if (aString.IsEmpty()) {
    *aValue = 0;
    *aUnit = NS_Atomize(aString).take();
    return;
  }

  nsAString::const_iterator iter;
  aString.BeginReading(iter);

  float a = 10.0f, b = 1.0f, value = 0;
  int8_t sign = 1;
  int32_t i = 0, j = aString.Length();
  char16_t c;
  bool floatingPointFound = false;
  c = *iter;
  if (char16_t('-') == c) {
    sign = -1;
    iter++;
    i++;
  } else if (char16_t('+') == c) {
    iter++;
    i++;
  }
  while (i < j) {
    c = *iter;
    if ((char16_t('0') == c) || (char16_t('1') == c) || (char16_t('2') == c) ||
        (char16_t('3') == c) || (char16_t('4') == c) || (char16_t('5') == c) ||
        (char16_t('6') == c) || (char16_t('7') == c) || (char16_t('8') == c) ||
        (char16_t('9') == c)) {
      value = (value * a) + (b * (c - char16_t('0')));
      b = b / 10 * a;
    } else if (!floatingPointFound && (char16_t('.') == c)) {
      floatingPointFound = true;
      a = 1.0f;
      b = 0.1f;
    } else
      break;
    iter++;
    i++;
  }
  *aValue = value * sign;
  *aUnit = NS_Atomize(StringTail(aString, j - i)).take();
}

// static
nsStaticAtom* CSSEditUtils::GetCSSPropertyAtom(
    nsCSSEditableProperty aProperty) {
  switch (aProperty) {
    case eCSSEditableProperty_background_color:
      return nsGkAtoms::backgroundColor;
    case eCSSEditableProperty_background_image:
      return nsGkAtoms::background_image;
    case eCSSEditableProperty_border:
      return nsGkAtoms::border;
    case eCSSEditableProperty_caption_side:
      return nsGkAtoms::caption_side;
    case eCSSEditableProperty_color:
      return nsGkAtoms::color;
    case eCSSEditableProperty_float:
      return nsGkAtoms::_float;
    case eCSSEditableProperty_font_family:
      return nsGkAtoms::font_family;
    case eCSSEditableProperty_font_size:
      return nsGkAtoms::font_size;
    case eCSSEditableProperty_font_style:
      return nsGkAtoms::font_style;
    case eCSSEditableProperty_font_weight:
      return nsGkAtoms::fontWeight;
    case eCSSEditableProperty_height:
      return nsGkAtoms::height;
    case eCSSEditableProperty_list_style_type:
      return nsGkAtoms::list_style_type;
    case eCSSEditableProperty_margin_left:
      return nsGkAtoms::marginLeft;
    case eCSSEditableProperty_margin_right:
      return nsGkAtoms::marginRight;
    case eCSSEditableProperty_text_align:
      return nsGkAtoms::textAlign;
    case eCSSEditableProperty_text_decoration:
      return nsGkAtoms::text_decoration;
    case eCSSEditableProperty_vertical_align:
      return nsGkAtoms::vertical_align;
    case eCSSEditableProperty_whitespace:
      return nsGkAtoms::white_space;
    case eCSSEditableProperty_width:
      return nsGkAtoms::width;
    case eCSSEditableProperty_NONE:
      // intentionally empty
      return nullptr;
  }
  MOZ_ASSERT_UNREACHABLE("Got unknown property");
  return nullptr;
}

// Populate aOutArrayOfCSSProperty and aOutArrayOfCSSValue with the CSS
// declarations equivalent to the value aValue according to the equivalence
// table aEquivTable

// static
void CSSEditUtils::BuildCSSDeclarations(
    nsTArray<nsStaticAtom*>& aOutArrayOfCSSProperty,
    nsTArray<nsString>& aOutArrayOfCSSValue, const CSSEquivTable* aEquivTable,
    const nsAString* aValue, bool aGetOrRemoveRequest) {
  // clear arrays
  aOutArrayOfCSSProperty.Clear();
  aOutArrayOfCSSValue.Clear();

  // if we have an input value, let's use it
  nsAutoString value, lowerCasedValue;
  if (aValue) {
    value.Assign(*aValue);
    lowerCasedValue.Assign(*aValue);
    ToLowerCase(lowerCasedValue);
  }

  int8_t index = 0;
  nsCSSEditableProperty cssProperty = aEquivTable[index].cssProperty;
  while (cssProperty) {
    if (!aGetOrRemoveRequest || aEquivTable[index].gettable) {
      nsAutoString cssValue, cssPropertyString;
      // find the equivalent css value for the index-th property in
      // the equivalence table
      (*aEquivTable[index].processValueFunctor)(
          (!aGetOrRemoveRequest || aEquivTable[index].caseSensitiveValue)
              ? &value
              : &lowerCasedValue,
          cssValue, aEquivTable[index].defaultValue,
          aEquivTable[index].prependValue, aEquivTable[index].appendValue);
      aOutArrayOfCSSProperty.AppendElement(GetCSSPropertyAtom(cssProperty));
      aOutArrayOfCSSValue.AppendElement(cssValue);
    }
    index++;
    cssProperty = aEquivTable[index].cssProperty;
  }
}

// Populate aOutArrayOfCSSProperty and aOutArrayOfCSSValue with the declarations
// equivalent to aHTMLProperty/aAttribute/aValue for the node aNode

// static
void CSSEditUtils::GenerateCSSDeclarationsFromHTMLStyle(
    Element& aElement, nsAtom* aHTMLProperty, nsAtom* aAttribute,
    const nsAString* aValue, nsTArray<nsStaticAtom*>& aOutArrayOfCSSProperty,
    nsTArray<nsString>& aOutArrayOfCSSValue, bool aGetOrRemoveRequest) {
  const CSSEditUtils::CSSEquivTable* equivTable = nullptr;

  if (nsGkAtoms::b == aHTMLProperty) {
    equivTable = boldEquivTable;
  } else if (nsGkAtoms::i == aHTMLProperty) {
    equivTable = italicEquivTable;
  } else if (nsGkAtoms::u == aHTMLProperty) {
    equivTable = underlineEquivTable;
  } else if (nsGkAtoms::strike == aHTMLProperty) {
    equivTable = strikeEquivTable;
  } else if (nsGkAtoms::tt == aHTMLProperty) {
    equivTable = ttEquivTable;
  } else if (aAttribute) {
    if (nsGkAtoms::font == aHTMLProperty && aAttribute == nsGkAtoms::color) {
      equivTable = fontColorEquivTable;
    } else if (nsGkAtoms::font == aHTMLProperty &&
               aAttribute == nsGkAtoms::face) {
      equivTable = fontFaceEquivTable;
    } else if (aAttribute == nsGkAtoms::bgcolor) {
      equivTable = bgcolorEquivTable;
    } else if (aAttribute == nsGkAtoms::background) {
      equivTable = backgroundImageEquivTable;
    } else if (aAttribute == nsGkAtoms::text) {
      equivTable = textColorEquivTable;
    } else if (aAttribute == nsGkAtoms::border) {
      equivTable = borderEquivTable;
    } else if (aAttribute == nsGkAtoms::align) {
      if (aElement.IsHTMLElement(nsGkAtoms::table)) {
        equivTable = tableAlignEquivTable;
      } else if (aElement.IsHTMLElement(nsGkAtoms::hr)) {
        equivTable = hrAlignEquivTable;
      } else if (aElement.IsAnyOfHTMLElements(nsGkAtoms::legend,
                                              nsGkAtoms::caption)) {
        equivTable = captionAlignEquivTable;
      } else {
        equivTable = textAlignEquivTable;
      }
    } else if (aAttribute == nsGkAtoms::valign) {
      equivTable = verticalAlignEquivTable;
    } else if (aAttribute == nsGkAtoms::nowrap) {
      equivTable = nowrapEquivTable;
    } else if (aAttribute == nsGkAtoms::width) {
      equivTable = widthEquivTable;
    } else if (aAttribute == nsGkAtoms::height ||
               (aElement.IsHTMLElement(nsGkAtoms::hr) &&
                aAttribute == nsGkAtoms::size)) {
      equivTable = heightEquivTable;
    } else if (aAttribute == nsGkAtoms::type &&
               aElement.IsAnyOfHTMLElements(nsGkAtoms::ol, nsGkAtoms::ul,
                                            nsGkAtoms::li)) {
      equivTable = listStyleTypeEquivTable;
    }
  }
  if (equivTable) {
    BuildCSSDeclarations(aOutArrayOfCSSProperty, aOutArrayOfCSSValue,
                         equivTable, aValue, aGetOrRemoveRequest);
  }
}

// Add to aNode the CSS inline style equivalent to HTMLProperty/aAttribute/
// aValue for the node, and return in aCount the number of CSS properties set
// by the call.  The Element version returns aCount instead.
int32_t CSSEditUtils::SetCSSEquivalentToHTMLStyle(Element* aElement,
                                                  nsAtom* aHTMLProperty,
                                                  nsAtom* aAttribute,
                                                  const nsAString* aValue,
                                                  bool aSuppressTransaction) {
  MOZ_ASSERT(aElement);

  if (!IsCSSEditableProperty(aElement, aHTMLProperty, aAttribute)) {
    return 0;
  }

  // we can apply the styles only if the node is an element and if we have
  // an equivalence for the requested HTML style in this implementation

  // Find the CSS equivalence to the HTML style
  nsTArray<nsStaticAtom*> cssPropertyArray;
  nsTArray<nsString> cssValueArray;
  GenerateCSSDeclarationsFromHTMLStyle(*aElement, aHTMLProperty, aAttribute,
                                       aValue, cssPropertyArray, cssValueArray,
                                       false);

  // set the individual CSS inline styles
  size_t count = cssPropertyArray.Length();
  for (size_t index = 0; index < count; index++) {
    nsresult rv =
        SetCSSProperty(*aElement, MOZ_KnownLive(*cssPropertyArray[index]),
                       cssValueArray[index], aSuppressTransaction);
    if (NS_FAILED(rv)) {
      NS_WARNING("CSSEditUtils::SetCSSProperty() failed");
      return 0;
    }
  }
  return count;
}

// Remove from aNode the CSS inline style equivalent to
// HTMLProperty/aAttribute/aValue for the node
nsresult CSSEditUtils::RemoveCSSEquivalentToHTMLStyle(
    Element* aElement, nsAtom* aHTMLProperty, nsAtom* aAttribute,
    const nsAString* aValue, bool aSuppressTransaction) {
  if (NS_WARN_IF(!aElement)) {
    return NS_OK;
  }

  if (!IsCSSEditableProperty(aElement, aHTMLProperty, aAttribute)) {
    return NS_OK;
  }

  // we can apply the styles only if the node is an element and if we have
  // an equivalence for the requested HTML style in this implementation

  // Find the CSS equivalence to the HTML style
  nsTArray<nsStaticAtom*> cssPropertyArray;
  nsTArray<nsString> cssValueArray;
  GenerateCSSDeclarationsFromHTMLStyle(*aElement, aHTMLProperty, aAttribute,
                                       aValue, cssPropertyArray, cssValueArray,
                                       true);

  // remove the individual CSS inline styles
  int32_t count = cssPropertyArray.Length();
  for (int32_t index = 0; index < count; index++) {
    nsresult rv =
        RemoveCSSProperty(*aElement, MOZ_KnownLive(*cssPropertyArray[index]),
                          cssValueArray[index], aSuppressTransaction);
    if (NS_FAILED(rv)) {
      NS_WARNING("CSSEditUtils::RemoveCSSProperty() failed");
      return rv;
    }
  }
  return NS_OK;
}

// returns in aValue the list of values for the CSS equivalences to
// the HTML style aHTMLProperty/aAttribute/aValue for the node aNode;
// the value of aStyleType controls the styles we retrieve : specified or
// computed.

// static
nsresult CSSEditUtils::GetCSSEquivalentToHTMLInlineStyleSetInternal(
    nsIContent& aContent, nsAtom* aHTMLProperty, nsAtom* aAttribute,
    nsAString& aValue, StyleType aStyleType) {
  MOZ_ASSERT(aHTMLProperty || aAttribute);

  aValue.Truncate();
  RefPtr<Element> theElement = aContent.GetAsElementOrParentElement();
  if (NS_WARN_IF(!theElement)) {
    return NS_ERROR_INVALID_ARG;
  }

  if (!theElement ||
      !IsCSSEditableProperty(theElement, aHTMLProperty, aAttribute)) {
    return NS_OK;
  }

  // Yes, the requested HTML style has a CSS equivalence in this implementation
  nsTArray<nsStaticAtom*> cssPropertyArray;
  nsTArray<nsString> cssValueArray;
  // get the CSS equivalence with last param true indicating we want only the
  // "gettable" properties
  GenerateCSSDeclarationsFromHTMLStyle(*theElement, aHTMLProperty, aAttribute,
                                       nullptr, cssPropertyArray, cssValueArray,
                                       true);
  int32_t count = cssPropertyArray.Length();
  for (int32_t index = 0; index < count; index++) {
    nsAutoString valueString;
    // retrieve the specified/computed value of the property
    if (aStyleType == StyleType::Computed) {
      nsresult rv = GetComputedCSSInlinePropertyBase(
          *theElement, MOZ_KnownLive(*cssPropertyArray[index]), valueString);
      if (NS_FAILED(rv)) {
        NS_WARNING("CSSEditUtils::GetComputedCSSInlinePropertyBase() failed");
        return rv;
      }
    } else {
      nsresult rv = GetSpecifiedCSSInlinePropertyBase(
          *theElement, *cssPropertyArray[index], valueString);
      if (NS_FAILED(rv)) {
        NS_WARNING("CSSEditUtils::GetSpecifiedCSSInlinePropertyBase() failed");
        return rv;
      }
    }
    // append the value to aValue (possibly with a leading whitespace)
    if (index) {
      aValue.Append(char16_t(' '));
    }
    aValue.Append(valueString);
  }
  return NS_OK;
}

// Does the node aContent (or its parent, if it's not an element node) have a
// CSS style equivalent to the HTML style
// aHTMLProperty/aAttribute/valueString? The value of aStyleType controls
// the styles we retrieve: specified or computed. The return value aIsSet is
// true if the CSS styles are set.
//
// The nsIContent variant returns aIsSet instead of using an out parameter, and
// does not modify aValue.

// static
bool CSSEditUtils::IsCSSEquivalentToHTMLInlineStyleSetInternal(
    nsIContent& aContent, nsAtom* aHTMLProperty, nsAtom* aAttribute,
    nsAString& aValue, StyleType aStyleType) {
  MOZ_ASSERT(aHTMLProperty || aAttribute);

  nsAutoString htmlValueString(aValue);
  bool isSet = false;
  // FYI: Cannot use InclusiveAncestorsOfType here because
  //      GetCSSEquivalentToHTMLInlineStyleSetInternal() may flush pending
  //      notifications.
  for (nsCOMPtr<nsIContent> content = &aContent; content;
       content = content->GetParentElement()) {
    nsCOMPtr<nsINode> parentNode = content->GetParentNode();
    aValue.Assign(htmlValueString);
    // get the value of the CSS equivalent styles
    nsresult rv = GetCSSEquivalentToHTMLInlineStyleSetInternal(
        *content, aHTMLProperty, aAttribute, aValue, aStyleType);
    if (NS_FAILED(rv)) {
      NS_WARNING(
          "CSSEditUtils::GetCSSEquivalentToHTMLInlineStyleSetInternal() "
          "failed");
      return false;
    }
    if (NS_WARN_IF(parentNode != content->GetParentNode())) {
      return false;
    }

    // early way out if we can
    if (aValue.IsEmpty()) {
      return isSet;
    }

    if (nsGkAtoms::b == aHTMLProperty) {
      if (aValue.EqualsLiteral("bold")) {
        isSet = true;
      } else if (aValue.EqualsLiteral("normal")) {
        isSet = false;
      } else if (aValue.EqualsLiteral("bolder")) {
        isSet = true;
        aValue.AssignLiteral("bold");
      } else {
        int32_t weight = 0;
        nsresult rvIgnored;
        nsAutoString value(aValue);
        weight = value.ToInteger(&rvIgnored);
        NS_WARNING_ASSERTION(NS_SUCCEEDED(rvIgnored),
                             "nsAString::ToInteger() failed, but ignored");
        if (400 < weight) {
          isSet = true;
          aValue.AssignLiteral("bold");
        } else {
          isSet = false;
          aValue.AssignLiteral("normal");
        }
      }
    } else if (nsGkAtoms::i == aHTMLProperty) {
      if (aValue.EqualsLiteral("italic") || aValue.EqualsLiteral("oblique")) {
        isSet = true;
      }
    } else if (nsGkAtoms::u == aHTMLProperty) {
      nsAutoString val;
      val.AssignLiteral("underline");
      isSet = ChangeStyleTransaction::ValueIncludes(aValue, val);
    } else if (nsGkAtoms::strike == aHTMLProperty) {
      nsAutoString val;
      val.AssignLiteral("line-through");
      isSet = ChangeStyleTransaction::ValueIncludes(aValue, val);
    } else if ((nsGkAtoms::font == aHTMLProperty &&
                aAttribute == nsGkAtoms::color) ||
               aAttribute == nsGkAtoms::bgcolor) {
      if (htmlValueString.IsEmpty()) {
        isSet = true;
      } else {
        nscolor rgba;
        nsAutoString subStr;
        htmlValueString.Right(subStr, htmlValueString.Length() - 1);
        if (NS_ColorNameToRGB(htmlValueString, &rgba) ||
            NS_HexToRGBA(subStr, nsHexColorType::NoAlpha, &rgba)) {
          nsAutoString htmlColor, tmpStr;

          if (NS_GET_A(rgba) != 255) {
            // This should only be hit by the "transparent" keyword, which
            // currently serializes to "transparent" (not "rgba(0, 0, 0, 0)").
            MOZ_ASSERT(NS_GET_R(rgba) == 0 && NS_GET_G(rgba) == 0 &&
                       NS_GET_B(rgba) == 0 && NS_GET_A(rgba) == 0);
            htmlColor.AppendLiteral("transparent");
          } else {
            htmlColor.AppendLiteral("rgb(");

            NS_NAMED_LITERAL_STRING(comma, ", ");

            tmpStr.AppendInt(NS_GET_R(rgba), 10);
            htmlColor.Append(tmpStr + comma);

            tmpStr.Truncate();
            tmpStr.AppendInt(NS_GET_G(rgba), 10);
            htmlColor.Append(tmpStr + comma);

            tmpStr.Truncate();
            tmpStr.AppendInt(NS_GET_B(rgba), 10);
            htmlColor.Append(tmpStr);

            htmlColor.Append(char16_t(')'));
          }

          isSet = htmlColor.Equals(aValue, nsCaseInsensitiveStringComparator);
        } else {
          isSet =
              htmlValueString.Equals(aValue, nsCaseInsensitiveStringComparator);
        }
      }
    } else if (nsGkAtoms::tt == aHTMLProperty) {
      isSet = StringBeginsWith(aValue, NS_LITERAL_STRING("monospace"));
    } else if (nsGkAtoms::font == aHTMLProperty && aAttribute &&
               aAttribute == nsGkAtoms::face) {
      if (!htmlValueString.IsEmpty()) {
        const char16_t commaSpace[] = {char16_t(','), char16_t(' '), 0};
        const char16_t comma[] = {char16_t(','), 0};
        htmlValueString.ReplaceSubstring(commaSpace, comma);
        nsAutoString valueStringNorm(aValue);
        valueStringNorm.ReplaceSubstring(commaSpace, comma);
        isSet = htmlValueString.Equals(valueStringNorm,
                                       nsCaseInsensitiveStringComparator);
      } else {
        isSet = true;
      }
      return isSet;
    } else if (aAttribute == nsGkAtoms::align) {
      isSet = true;
    } else {
      return false;
    }

    if (!htmlValueString.IsEmpty() &&
        htmlValueString.Equals(aValue, nsCaseInsensitiveStringComparator)) {
      isSet = true;
    }

    if (htmlValueString.EqualsLiteral("-moz-editor-invert-value")) {
      isSet = !isSet;
    }

    if (isSet) {
      return true;
    }

    if (nsGkAtoms::u != aHTMLProperty && nsGkAtoms::strike != aHTMLProperty) {
      return isSet;
    }

    // Unfortunately, the value of the text-decoration property is not
    // inherited. that means that we have to look at ancestors of node to see
    // if they are underlined.
  }
  return isSet;
}

bool CSSEditUtils::HaveCSSEquivalentStylesInternal(nsIContent& aContent,
                                                   nsAtom* aHTMLProperty,
                                                   nsAtom* aAttribute,
                                                   StyleType aStyleType) {
  MOZ_ASSERT(aHTMLProperty || aAttribute);

  // FYI: Unfortunately, we cannot use InclusiveAncestorsOfType here
  //      because GetCSSEquivalentToHTMLInlineStyleSetInternal() may flush
  //      pending notifications.
  nsAutoString valueString;
  for (nsCOMPtr<nsIContent> content = &aContent; content;
       content = content->GetParentElement()) {
    nsCOMPtr<nsINode> parentNode = content->GetParentNode();
    // get the value of the CSS equivalent styles
    nsresult rv = GetCSSEquivalentToHTMLInlineStyleSetInternal(
        *content, aHTMLProperty, aAttribute, valueString, aStyleType);
    if (NS_FAILED(rv)) {
      NS_WARNING(
          "CSSEditUtils::GetCSSEquivalentToHTMLInlineStyleSetInternal() "
          "failed");
      return false;
    }
    if (NS_WARN_IF(parentNode != content->GetParentNode())) {
      return false;
    }

    if (!valueString.IsEmpty()) {
      return true;
    }

    if (nsGkAtoms::u != aHTMLProperty && nsGkAtoms::strike != aHTMLProperty) {
      return false;
    }

    // 'nfortunately, the value of the text-decoration property is not
    // inherited.
    // that means that we have to look at ancestors of node to see if they
    // are underlined.
  }

  return false;
}

void CSSEditUtils::SetCSSEnabled(bool aIsCSSPrefChecked) {
  mIsCSSPrefChecked = aIsCSSPrefChecked;
}

bool CSSEditUtils::IsCSSPrefChecked() const { return mIsCSSPrefChecked; }

// ElementsSameStyle compares two elements and checks if they have the same
// specified CSS declarations in the STYLE attribute
// The answer is always negative if at least one of them carries an ID or a
// class

// static
bool CSSEditUtils::DoElementsHaveSameStyle(const Element& aElement,
                                           const Element& aOtherElement) {
  if (aElement.HasAttr(kNameSpaceID_None, nsGkAtoms::id) ||
      aOtherElement.HasAttr(kNameSpaceID_None, nsGkAtoms::id)) {
    // at least one of the spans carries an ID ; suspect a CSS rule applies to
    // it and refuse to merge the nodes
    return false;
  }

  nsAutoString firstClass, otherClass;
  bool isElementClassSet =
      aElement.GetAttr(kNameSpaceID_None, nsGkAtoms::_class, firstClass);
  bool isOtherElementClassSet =
      aOtherElement.GetAttr(kNameSpaceID_None, nsGkAtoms::_class, otherClass);
  if (isElementClassSet && isOtherElementClassSet) {
    // both spans carry a class, let's compare them
    if (!firstClass.Equals(otherClass)) {
      // WARNING : technically, the comparison just above is questionable :
      // from a pure HTML/CSS point of view class="a b" is NOT the same than
      // class="b a" because a CSS rule could test the exact value of the class
      // attribute to be "a b" for instance ; from a user's point of view, a
      // wysiwyg editor should probably NOT make any difference. CSS people
      // need to discuss this issue before any modification.
      return false;
    }
  } else if (isElementClassSet || isOtherElementClassSet) {
    // one span only carries a class, early way out
    return false;
  }

  nsCOMPtr<nsICSSDeclaration> firstCSSDecl, otherCSSDecl;
  uint32_t firstLength, otherLength;
  nsresult rv =
      GetInlineStyles(aElement, getter_AddRefs(firstCSSDecl), &firstLength);
  if (NS_FAILED(rv) || !firstCSSDecl) {
    NS_WARNING("CSSEditUtils::GetInlineStyles() failed");
    return false;
  }
  rv = GetInlineStyles(aOtherElement, getter_AddRefs(otherCSSDecl),
                       &otherLength);
  if (NS_FAILED(rv) || !otherCSSDecl) {
    NS_WARNING("CSSEditUtils::GetInlineStyles() failed");
    return false;
  }

  if (firstLength != otherLength) {
    // early way out if we can
    return false;
  }

  if (!firstLength) {
    // no inline style !
    return true;
  }

  nsAutoCString propertyNameString;
  nsAutoString firstValue, otherValue;
  for (uint32_t i = 0; i < firstLength; i++) {
    firstCSSDecl->Item(i, propertyNameString);
    DebugOnly<nsresult> rvIgnored =
        firstCSSDecl->GetPropertyValue(propertyNameString, firstValue);
    NS_WARNING_ASSERTION(
        NS_SUCCEEDED(rvIgnored),
        "nsICSSDeclaration::GetPropertyValue() failed, but ignored");
    rvIgnored = otherCSSDecl->GetPropertyValue(propertyNameString, otherValue);
    NS_WARNING_ASSERTION(
        NS_SUCCEEDED(rvIgnored),
        "nsICSSDeclaration::GetPropertyValue() failed, but ignored");
    if (!firstValue.Equals(otherValue)) {
      return false;
    }
  }
  for (uint32_t i = 0; i < otherLength; i++) {
    otherCSSDecl->Item(i, propertyNameString);
    DebugOnly<nsresult> rvIgnored =
        otherCSSDecl->GetPropertyValue(propertyNameString, otherValue);
    NS_WARNING_ASSERTION(
        NS_SUCCEEDED(rvIgnored),
        "nsICSSDeclaration::GetPropertyValue() failed, but ignored");
    rvIgnored = firstCSSDecl->GetPropertyValue(propertyNameString, firstValue);
    NS_WARNING_ASSERTION(
        NS_SUCCEEDED(rvIgnored),
        "nsICSSDeclaration::GetPropertyValue() failed, but ignored");
    if (!firstValue.Equals(otherValue)) {
      return false;
    }
  }

  return true;
}

// static
nsresult CSSEditUtils::GetInlineStyles(const Element& aElement,
                                       nsICSSDeclaration** aCssDecl,
                                       uint32_t* aLength) {
  if (NS_WARN_IF(!aLength)) {
    return NS_ERROR_INVALID_ARG;
  }
  *aLength = 0;
  // TODO: Perhaps, this method should take nsStyledElement& instead.
  nsCOMPtr<nsStyledElement> styledElement =
      do_QueryInterface(const_cast<Element*>(&aElement));
  if (NS_WARN_IF(!styledElement)) {
    return NS_ERROR_INVALID_ARG;
  }

  nsCOMPtr<nsICSSDeclaration> cssDecl = styledElement->Style();
  MOZ_ASSERT(cssDecl);

  cssDecl.forget(aCssDecl);
  *aLength = (*aCssDecl)->Length();
  return NS_OK;
}

}  // namespace mozilla
