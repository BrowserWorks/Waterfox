/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * nsIContentSerializer implementation that can be used with an
 * nsIDocumentEncoder to convert an HTML (not XHTML!) DOM to an HTML
 * string that could be parsed into more or less the original DOM.
 */

#include "nsHTMLContentSerializer.h"

#include "nsIDOMElement.h"
#include "nsIContent.h"
#include "nsIDocument.h"
#include "nsNameSpaceManager.h"
#include "nsString.h"
#include "nsUnicharUtils.h"
#include "nsXPIDLString.h"
#include "nsIServiceManager.h"
#include "nsIDocumentEncoder.h"
#include "nsGkAtoms.h"
#include "nsIURI.h"
#include "nsNetUtil.h"
#include "nsEscape.h"
#include "nsITextToSubURI.h"
#include "nsCRT.h"
#include "nsIParserService.h"
#include "nsContentUtils.h"
#include "nsLWBrkCIID.h"
#include "nsIScriptElement.h"
#include "nsAttrName.h"
#include "nsIDocShell.h"
#include "nsIEditor.h"
#include "nsIHTMLEditor.h"
#include "mozilla/dom/Element.h"
#include "nsParserConstants.h"

using namespace mozilla::dom;

nsresult
NS_NewHTMLContentSerializer(nsIContentSerializer** aSerializer)
{
  RefPtr<nsHTMLContentSerializer> it = new nsHTMLContentSerializer();
  it.forget(aSerializer);
  return NS_OK;
}

nsHTMLContentSerializer::nsHTMLContentSerializer()
{
    mIsHTMLSerializer = true;
}

nsHTMLContentSerializer::~nsHTMLContentSerializer()
{
}


NS_IMETHODIMP
nsHTMLContentSerializer::AppendDocumentStart(nsIDocument *aDocument,
                                             nsAString& aStr)
{
  return NS_OK;
}

bool
nsHTMLContentSerializer::SerializeHTMLAttributes(nsIContent* aContent,
                                                 nsIContent *aOriginalElement,
                                                 nsAString& aTagPrefix,
                                                 const nsAString& aTagNamespaceURI,
                                                 nsIAtom* aTagName,
                                                 int32_t aNamespace,
                                                 nsAString& aStr)
{
  int32_t count = aContent->GetAttrCount();
  if (!count)
    return true;

  nsresult rv;
  nsAutoString valueStr;
  NS_NAMED_LITERAL_STRING(_mozStr, "_moz");

  for (int32_t index = 0; index < count; index++) {
    const nsAttrName* name = aContent->GetAttrNameAt(index);
    int32_t namespaceID = name->NamespaceID();
    nsIAtom* attrName = name->LocalName();

    // Filter out any attribute starting with [-|_]moz
    nsDependentAtomString attrNameStr(attrName);
    if (StringBeginsWith(attrNameStr, NS_LITERAL_STRING("_moz")) ||
        StringBeginsWith(attrNameStr, NS_LITERAL_STRING("-moz"))) {
      continue;
    }
    aContent->GetAttr(namespaceID, attrName, valueStr);

    // 
    // Filter out special case of <br type="_moz"> or <br _moz*>,
    // used by the editor.  Bug 16988.  Yuck.
    //
    if (aTagName == nsGkAtoms::br && aNamespace == kNameSpaceID_XHTML &&
        attrName == nsGkAtoms::type && namespaceID == kNameSpaceID_None &&
        StringBeginsWith(valueStr, _mozStr)) {
      continue;
    }

    if (mIsCopying && mIsFirstChildOfOL &&
        aTagName == nsGkAtoms::li && aNamespace == kNameSpaceID_XHTML &&
        attrName == nsGkAtoms::value && namespaceID == kNameSpaceID_None){
      // This is handled separately in SerializeLIValueAttribute()
      continue;
    }
    bool isJS = IsJavaScript(aContent, attrName, namespaceID, valueStr);
    
    if (((attrName == nsGkAtoms::href &&
          (namespaceID == kNameSpaceID_None ||
           namespaceID == kNameSpaceID_XLink)) ||
         (attrName == nsGkAtoms::src && namespaceID == kNameSpaceID_None))) {
      // Make all links absolute when converting only the selection:
      if (mFlags & nsIDocumentEncoder::OutputAbsoluteLinks) {
        // Would be nice to handle OBJECT and APPLET tags,
        // but that gets more complicated since we have to
        // search the tag list for CODEBASE as well.
        // For now, just leave them relative.
        nsCOMPtr<nsIURI> uri = aContent->GetBaseURI();
        if (uri) {
          nsAutoString absURI;
          rv = NS_MakeAbsoluteURI(absURI, valueStr, uri);
          if (NS_SUCCEEDED(rv)) {
            valueStr = absURI;
          }
        }
      }
      // Need to escape URI.
      nsAutoString tempURI(valueStr);
      if (!isJS && NS_FAILED(EscapeURI(aContent, tempURI, valueStr)))
        valueStr = tempURI;
    }

    if (mRewriteEncodingDeclaration && aTagName == nsGkAtoms::meta &&
        aNamespace == kNameSpaceID_XHTML && attrName == nsGkAtoms::content
        && namespaceID == kNameSpaceID_None) {
      // If we're serializing a <meta http-equiv="content-type">,
      // use the proper value, rather than what's in the document.
      nsAutoString header;
      aContent->GetAttr(kNameSpaceID_None, nsGkAtoms::httpEquiv, header);
      if (header.LowerCaseEqualsLiteral("content-type")) {
        valueStr = NS_LITERAL_STRING("text/html; charset=") +
          NS_ConvertASCIItoUTF16(mCharset);
      }
    }

    nsDependentAtomString nameStr(attrName);
    nsAutoString prefix;
    if (namespaceID == kNameSpaceID_XML) {
      prefix.AssignLiteral(u"xml");
    } else if (namespaceID == kNameSpaceID_XLink) {
      prefix.AssignLiteral(u"xlink");
    }

    // Expand shorthand attribute.
    if (aNamespace == kNameSpaceID_XHTML &&
        namespaceID == kNameSpaceID_None &&
        IsShorthandAttr(attrName, aTagName) &&
        valueStr.IsEmpty()) {
      valueStr = nameStr;
    }
    NS_ENSURE_TRUE(SerializeAttr(prefix, nameStr, valueStr,
                                 aStr, !isJS), false);
  }

  return true;
}

NS_IMETHODIMP
nsHTMLContentSerializer::AppendElementStart(Element* aElement,
                                            Element* aOriginalElement,
                                            nsAString& aStr)
{
  NS_ENSURE_ARG(aElement);

  nsIContent* content = aElement;

  bool forceFormat = false;
  nsresult rv = NS_OK;
  if (!CheckElementStart(content, forceFormat, aStr, rv)) {
    // When we go to AppendElementEnd for this element, we're going to
    // MaybeLeaveFromPreContent().  So make sure to MaybeEnterInPreContent()
    // now, so our PreLevel() doesn't get confused.
    MaybeEnterInPreContent(content);
    return rv;
  }

  NS_ENSURE_SUCCESS(rv, rv);

  nsIAtom *name = content->NodeInfo()->NameAtom();
  int32_t ns = content->GetNameSpaceID();

  bool lineBreakBeforeOpen = LineBreakBeforeOpen(ns, name);

  if ((mDoFormat || forceFormat) && !mDoRaw && !PreLevel()) {
    if (mColPos && lineBreakBeforeOpen) {
      NS_ENSURE_TRUE(AppendNewLineToString(aStr), NS_ERROR_OUT_OF_MEMORY);
    }
    else {
      NS_ENSURE_TRUE(MaybeAddNewlineForRootNode(aStr), NS_ERROR_OUT_OF_MEMORY);
    }
    if (!mColPos) {
      NS_ENSURE_TRUE(AppendIndentation(aStr), NS_ERROR_OUT_OF_MEMORY);
    }
    else if (mAddSpace) {
      bool result = AppendToString(char16_t(' '), aStr);
      mAddSpace = false;
      NS_ENSURE_TRUE(result, NS_ERROR_OUT_OF_MEMORY);
    }
  }
  else if (mAddSpace) {
    bool result = AppendToString(char16_t(' '), aStr);
    mAddSpace = false;
    NS_ENSURE_TRUE(result, NS_ERROR_OUT_OF_MEMORY);
  }
  else {
    NS_ENSURE_TRUE(MaybeAddNewlineForRootNode(aStr), NS_ERROR_OUT_OF_MEMORY);
  }
  // Always reset to avoid false newlines in case MaybeAddNewlineForRootNode wasn't
  // called
  mAddNewlineForRootNode = false;

  NS_ENSURE_TRUE(AppendToString(kLessThan, aStr), NS_ERROR_OUT_OF_MEMORY);

  NS_ENSURE_TRUE(AppendToString(nsDependentAtomString(name), aStr), NS_ERROR_OUT_OF_MEMORY);

  MaybeEnterInPreContent(content);

  // for block elements, we increase the indentation
  if ((mDoFormat || forceFormat) && !mDoRaw && !PreLevel())
    NS_ENSURE_TRUE(IncrIndentation(name), NS_ERROR_OUT_OF_MEMORY);

  // Need to keep track of OL and LI elements in order to get ordinal number 
  // for the LI.
  if (mIsCopying && name == nsGkAtoms::ol && ns == kNameSpaceID_XHTML){
    // We are copying and current node is an OL;
    // Store its start attribute value in olState->startVal.
    nsAutoString start;
    int32_t startAttrVal = 0;

    aElement->GetAttr(kNameSpaceID_None, nsGkAtoms::start, start);
    if (!start.IsEmpty()){
      nsresult rv = NS_OK;
      startAttrVal = start.ToInteger(&rv);
      //If OL has "start" attribute, first LI element has to start with that value
      //Therefore subtracting 1 as all the LI elements are incrementing it before using it;
      //In failure of ToInteger(), default StartAttrValue to 0.
      if (NS_SUCCEEDED(rv))
        startAttrVal--; 
      else
        startAttrVal = 0;
    }
    mOLStateStack.AppendElement(olState(startAttrVal, true));
  }

  if (mIsCopying && name == nsGkAtoms::li && ns == kNameSpaceID_XHTML) {
    mIsFirstChildOfOL = IsFirstChildOfOL(aOriginalElement);
    if (mIsFirstChildOfOL){
      // If OL is parent of this LI, serialize attributes in different manner.
      NS_ENSURE_TRUE(SerializeLIValueAttribute(aElement, aStr), NS_ERROR_OUT_OF_MEMORY);
    }
  }

  // Even LI passed above have to go through this 
  // for serializing attributes other than "value".
  nsAutoString dummyPrefix;
  NS_ENSURE_TRUE(SerializeHTMLAttributes(content,
                                         aOriginalElement,
                                         dummyPrefix,
                                         EmptyString(),
                                         name,
                                         ns,
                                         aStr), NS_ERROR_OUT_OF_MEMORY);

  NS_ENSURE_TRUE(AppendToString(kGreaterThan, aStr), NS_ERROR_OUT_OF_MEMORY);

  if (ns == kNameSpaceID_XHTML &&
      (name == nsGkAtoms::script ||
       name == nsGkAtoms::style ||
       name == nsGkAtoms::noscript ||
       name == nsGkAtoms::noframes)) {
    ++mDisableEntityEncoding;
  }

  if ((mDoFormat || forceFormat) && !mDoRaw && !PreLevel() &&
    LineBreakAfterOpen(ns, name)) {
    NS_ENSURE_TRUE(AppendNewLineToString(aStr), NS_ERROR_OUT_OF_MEMORY);
  }

  NS_ENSURE_TRUE(AfterElementStart(content, aOriginalElement, aStr), NS_ERROR_OUT_OF_MEMORY);

  return NS_OK;
}
  
NS_IMETHODIMP 
nsHTMLContentSerializer::AppendElementEnd(Element* aElement,
                                          nsAString& aStr)
{
  NS_ENSURE_ARG(aElement);

  nsIContent* content = aElement;

  nsIAtom *name = content->NodeInfo()->NameAtom();
  int32_t ns = content->GetNameSpaceID();

  if (ns == kNameSpaceID_XHTML &&
      (name == nsGkAtoms::script ||
       name == nsGkAtoms::style ||
       name == nsGkAtoms::noscript ||
       name == nsGkAtoms::noframes)) {
    --mDisableEntityEncoding;
  }

  bool forceFormat = !(mFlags & nsIDocumentEncoder::OutputIgnoreMozDirty) &&
                     content->HasAttr(kNameSpaceID_None, nsGkAtoms::mozdirty);

  if ((mDoFormat || forceFormat) && !mDoRaw && !PreLevel()) {
    DecrIndentation(name);
  }

  if (name == nsGkAtoms::script) {
    nsCOMPtr<nsIScriptElement> script = do_QueryInterface(aElement);

    if (ShouldMaintainPreLevel() && script && script->IsMalformed()) {
      // We're looking at a malformed script tag. This means that the end tag
      // was missing in the source. Imitate that here by not serializing the end
      // tag.
      --PreLevel();
      return NS_OK;
    }
  }
  else if (mIsCopying && name == nsGkAtoms::ol && ns == kNameSpaceID_XHTML) {
    NS_ASSERTION((!mOLStateStack.IsEmpty()), "Cannot have an empty OL Stack");
    /* Though at this point we must always have an state to be deleted as all 
    the OL opening tags are supposed to push an olState object to the stack*/
    if (!mOLStateStack.IsEmpty()) {
      mOLStateStack.RemoveElementAt(mOLStateStack.Length() -1);
    }
  }
  
  if (ns == kNameSpaceID_XHTML) {
    nsIParserService* parserService = nsContentUtils::GetParserService();

    if (parserService) {
      bool isContainer;

      parserService->
        IsContainer(parserService->HTMLCaseSensitiveAtomTagToId(name),
                    isContainer);
      if (!isContainer) {
        // Keep this in sync with the cleanup at the end of this method.
        MOZ_ASSERT(name != nsGkAtoms::body);
        MaybeLeaveFromPreContent(content);
        return NS_OK;
      }
    }
  }

  if ((mDoFormat || forceFormat) && !mDoRaw && !PreLevel()) {

    bool lineBreakBeforeClose = LineBreakBeforeClose(ns, name);

    if (mColPos && lineBreakBeforeClose) {
      NS_ENSURE_TRUE(AppendNewLineToString(aStr), NS_ERROR_OUT_OF_MEMORY);
    }
    if (!mColPos) {
      NS_ENSURE_TRUE(AppendIndentation(aStr), NS_ERROR_OUT_OF_MEMORY);
    }
    else if (mAddSpace) {
      bool result = AppendToString(char16_t(' '), aStr);
      mAddSpace = false;
      NS_ENSURE_TRUE(result, NS_ERROR_OUT_OF_MEMORY);
    }
  }
  else if (mAddSpace) {
    bool result = AppendToString(char16_t(' '), aStr);
    mAddSpace = false;
    NS_ENSURE_TRUE(result, NS_ERROR_OUT_OF_MEMORY);
  }

  NS_ENSURE_TRUE(AppendToString(kEndTag, aStr), NS_ERROR_OUT_OF_MEMORY);
  NS_ENSURE_TRUE(AppendToString(nsDependentAtomString(name), aStr), NS_ERROR_OUT_OF_MEMORY);
  NS_ENSURE_TRUE(AppendToString(kGreaterThan, aStr), NS_ERROR_OUT_OF_MEMORY);

  // Keep this cleanup in sync with the IsContainer() early return above.
  MaybeLeaveFromPreContent(content);

  if ((mDoFormat || forceFormat)&& !mDoRaw  && !PreLevel()
      && LineBreakAfterClose(ns, name)) {
    NS_ENSURE_TRUE(AppendNewLineToString(aStr), NS_ERROR_OUT_OF_MEMORY);
  }
  else {
    MaybeFlagNewlineForRootNode(aElement);
  }

  if (name == nsGkAtoms::body && ns == kNameSpaceID_XHTML) {
    --mInBody;
  }

  return NS_OK;
}

static const uint16_t kValNBSP = 160;

#define _ 0

// This table indexes into kEntityStrings[].
static const uint8_t kEntities[] = {
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, 2, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  3, _, 4, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  5
};

// This table indexes into kEntityStrings[].
static const uint8_t kAttrEntities[] = {
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, 1, _, _, _, 2, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  3, _, 4, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  _, _, _, _, _, _, _, _, _, _,
  5
};

#undef _

static const char* const kEntityStrings[] = {
  /* 0 */ nullptr,
  /* 1 */ "&quot;",
  /* 2 */ "&amp;",
  /* 3 */ "&lt;",
  /* 4 */ "&gt;",
  /* 5 */ "&nbsp;"
};

uint32_t FindNextBasicEntity(const nsAString& aStr,
                             const uint32_t aLen,
                             uint32_t aIndex,
                             const uint8_t* aEntityTable,
                             const char** aEntity)
{
  for (; aIndex < aLen; ++aIndex) {
    // for each character in this chunk, check if it
    // needs to be replaced
    char16_t val = aStr[aIndex];
    if (val <= kValNBSP && aEntityTable[val]) {
      *aEntity = kEntityStrings[aEntityTable[val]];
      return aIndex;
    }
  }
  return aIndex;
}

bool
nsHTMLContentSerializer::AppendAndTranslateEntities(const nsAString& aStr,
                                                     nsAString& aOutputStr)
{
  if (mBodyOnly && !mInBody) {
    return true;
  }

  if (mDisableEntityEncoding) {
    return aOutputStr.Append(aStr, mozilla::fallible);
  }

  bool nonBasicEntities =
    !!(mFlags & (nsIDocumentEncoder::OutputEncodeLatin1Entities |
                 nsIDocumentEncoder::OutputEncodeHTMLEntities   |
                 nsIDocumentEncoder::OutputEncodeW3CEntities));

  if (!nonBasicEntities &&
      (mFlags & (nsIDocumentEncoder::OutputEncodeBasicEntities))) {
    const uint8_t* entityTable = mInAttribute ? kAttrEntities : kEntities;
    uint32_t start = 0;
    const uint32_t len = aStr.Length();
    for (uint32_t i = 0; i < len; ++i) {
      const char* entity = nullptr;
      i = FindNextBasicEntity(aStr, len, i, entityTable, &entity);
      uint32_t normalTextLen = i - start; 
      if (normalTextLen) {
        NS_ENSURE_TRUE(aOutputStr.Append(Substring(aStr, start, normalTextLen),
                                         mozilla::fallible), false);
      }
      if (entity) {
        NS_ENSURE_TRUE(aOutputStr.AppendASCII(entity, mozilla::fallible), false);
        start = i + 1;
      }
    }
    return true;
  } else if (nonBasicEntities) {
    nsIParserService* parserService = nsContentUtils::GetParserService();

    if (!parserService) {
      NS_ERROR("Can't get parser service");
      return true;
    }

    nsReadingIterator<char16_t> done_reading;
    aStr.EndReading(done_reading);

    // for each chunk of |aString|...
    uint32_t advanceLength = 0;
    nsReadingIterator<char16_t> iter;

    const uint8_t* entityTable = mInAttribute ? kAttrEntities : kEntities;
    nsAutoCString entityReplacement;

    for (aStr.BeginReading(iter);
         iter != done_reading;
         iter.advance(int32_t(advanceLength))) {
      uint32_t fragmentLength = done_reading - iter;
      uint32_t lengthReplaced = 0; // the number of UTF-16 codepoints
                                    //  replaced by a particular entity
      const char16_t* c = iter.get();
      const char16_t* fragmentStart = c;
      const char16_t* fragmentEnd = c + fragmentLength;
      const char* entityText = nullptr;
      const char* fullConstEntityText = nullptr;
      char* fullEntityText = nullptr;

      advanceLength = 0;
      // for each character in this chunk, check if it
      // needs to be replaced
      for (; c < fragmentEnd; c++, advanceLength++) {
        char16_t val = *c;
        if (val <= kValNBSP && entityTable[val]) {
          fullConstEntityText = kEntityStrings[entityTable[val]];
          break;
        } else if (val > 127 &&
                  ((val < 256 &&
                    mFlags & nsIDocumentEncoder::OutputEncodeLatin1Entities) ||
                    mFlags & nsIDocumentEncoder::OutputEncodeHTMLEntities)) {
          entityReplacement.Truncate();
          parserService->HTMLConvertUnicodeToEntity(val, entityReplacement);

          if (!entityReplacement.IsEmpty()) {
            entityText = entityReplacement.get();
            break;
          }
        }
        else if (val > 127 &&
                  mFlags & nsIDocumentEncoder::OutputEncodeW3CEntities &&
                  mEntityConverter) {
          if (NS_IS_HIGH_SURROGATE(val) &&
              c + 1 < fragmentEnd &&
              NS_IS_LOW_SURROGATE(*(c + 1))) {
            uint32_t valUTF32 = SURROGATE_TO_UCS4(val, *(++c));
            if (NS_SUCCEEDED(mEntityConverter->ConvertUTF32ToEntity(valUTF32,
                              nsIEntityConverter::entityW3C, &fullEntityText))) {
              lengthReplaced = 2;
              break;
            }
            else {
              advanceLength++;
            }
          }
          else if (NS_SUCCEEDED(mEntityConverter->ConvertToEntity(val,
                                nsIEntityConverter::entityW3C, 
                                &fullEntityText))) {
            lengthReplaced = 1;
            break;
          }
        }
      }

      bool result = aOutputStr.Append(fragmentStart, advanceLength, mozilla::fallible);
      if (entityText) {
        NS_ENSURE_TRUE(aOutputStr.Append(char16_t('&'), mozilla::fallible), false);
        NS_ENSURE_TRUE(AppendASCIItoUTF16(entityText, aOutputStr, mozilla::fallible), false);
        NS_ENSURE_TRUE(aOutputStr.Append(char16_t(';'), mozilla::fallible), false);
        advanceLength++;
      }
      else if (fullConstEntityText) {
        NS_ENSURE_TRUE(aOutputStr.AppendASCII(fullConstEntityText, mozilla::fallible), false);
        ++advanceLength;
      }
      // if it comes from nsIEntityConverter, it already has '&' and ';'
      else if (fullEntityText) {
        bool ok = AppendASCIItoUTF16(fullEntityText, aOutputStr, mozilla::fallible);
        free(fullEntityText);
        advanceLength += lengthReplaced;
        NS_ENSURE_TRUE(ok, false);
      }
      NS_ENSURE_TRUE(result, false);
    }
  } else {
    NS_ENSURE_TRUE(nsXMLContentSerializer::AppendAndTranslateEntities(aStr, aOutputStr), false);
  }

  return true;
}
