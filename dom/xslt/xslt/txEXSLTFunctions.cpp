/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ArrayUtils.h"
#include "mozilla/FloatingPoint.h"

#include "nsIAtom.h"
#include "nsGkAtoms.h"
#include "txExecutionState.h"
#include "txExpr.h"
#include "txIXPathContext.h"
#include "txNodeSet.h"
#include "txOutputFormat.h"
#include "txRtfHandler.h"
#include "txXPathTreeWalker.h"
#include "nsPrintfCString.h"
#include "nsComponentManagerUtils.h"
#include "nsContentCID.h"
#include "nsContentCreatorFunctions.h"
#include "nsIContent.h"
#include "nsIDOMDocumentFragment.h"
#include "txMozillaXMLOutput.h"
#include "nsTextNode.h"
#include "mozilla/dom/DocumentFragment.h"
#include "prtime.h"

using namespace mozilla;
using namespace mozilla::dom;

class txStylesheetCompilerState;

// ------------------------------------------------------------------
// Utility functions
// ------------------------------------------------------------------

static nsresult
convertRtfToNode(txIEvalContext *aContext, txResultTreeFragment *aRtf)
{
    txExecutionState* es =
        static_cast<txExecutionState*>(aContext->getPrivateContext());
    if (!es) {
        NS_ERROR("Need txExecutionState!");

        return NS_ERROR_UNEXPECTED;
    }

    const txXPathNode& document = es->getSourceDocument();

    nsIDocument *doc = txXPathNativeNode::getDocument(document);
    nsCOMPtr<nsIDOMDocumentFragment> domFragment =
      new DocumentFragment(doc->NodeInfoManager());

    txOutputFormat format;
    txMozillaXMLOutput mozHandler(&format, domFragment, true);

    nsresult rv = aRtf->flushToHandler(&mozHandler);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = mozHandler.closePrevious(true);
    NS_ENSURE_SUCCESS(rv, rv);

    // The txResultTreeFragment will own this.
    const txXPathNode* node = txXPathNativeNode::createXPathNode(domFragment,
                                                                 true);
    NS_ENSURE_TRUE(node, NS_ERROR_OUT_OF_MEMORY);

    aRtf->setNode(node);

    return NS_OK;
}

static nsresult
createTextNode(txIEvalContext *aContext, nsString& aValue,
               txXPathNode* *aResult)
{
    txExecutionState* es =
        static_cast<txExecutionState*>(aContext->getPrivateContext());
    if (!es) {
        NS_ERROR("Need txExecutionState!");

        return NS_ERROR_UNEXPECTED;
    }

    const txXPathNode& document = es->getSourceDocument();

    nsIDocument *doc = txXPathNativeNode::getDocument(document);
    nsCOMPtr<nsIContent> text = new nsTextNode(doc->NodeInfoManager());

    nsresult rv = text->SetText(aValue, false);
    NS_ENSURE_SUCCESS(rv, rv);

    *aResult = txXPathNativeNode::createXPathNode(text, true);
    NS_ENSURE_TRUE(*aResult, NS_ERROR_OUT_OF_MEMORY);

    return NS_OK;
}

static already_AddRefed<DocumentFragment>
createDocFragment(txIEvalContext *aContext)
{
    txExecutionState* es =
        static_cast<txExecutionState*>(aContext->getPrivateContext());
    if (!es) {
        NS_ERROR("Need txExecutionState!");

        return nullptr;
    }

    const txXPathNode& document = es->getSourceDocument();
    nsIDocument *doc = txXPathNativeNode::getDocument(document);
    RefPtr<DocumentFragment> fragment =
      new DocumentFragment(doc->NodeInfoManager());

    return fragment.forget();
}

static nsresult
createAndAddToResult(nsIAtom* aName, const nsAString& aValue,
                     txNodeSet* aResultSet, nsIContent* aResultHolder)
{
    NS_ASSERTION(aResultHolder->IsNodeOfType(nsINode::eDOCUMENT_FRAGMENT) &&
                 aResultHolder->OwnerDoc(),
                 "invalid result-holder");

    nsIDocument* doc = aResultHolder->OwnerDoc();
    nsCOMPtr<Element> elem = doc->CreateElem(nsDependentAtomString(aName),
                                             nullptr, kNameSpaceID_None);
    NS_ENSURE_TRUE(elem, NS_ERROR_NULL_POINTER);

    RefPtr<nsTextNode> text = new nsTextNode(doc->NodeInfoManager());

    nsresult rv = text->SetText(aValue, false);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = elem->AppendChildTo(text, false);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = aResultHolder->AppendChildTo(elem, false);
    NS_ENSURE_SUCCESS(rv, rv);

    nsAutoPtr<txXPathNode> xpathNode(
          txXPathNativeNode::createXPathNode(elem, true));
    NS_ENSURE_TRUE(xpathNode, NS_ERROR_OUT_OF_MEMORY);

    aResultSet->append(*xpathNode);

    return NS_OK;
}

// Need to update this array if types are added to the ResultType enum in
// txAExprResult.
static const char * const sTypes[] = {
  "node-set",
  "boolean",
  "number",
  "string",
  "RTF"
};

// ------------------------------------------------------------------
// Function implementations
// ------------------------------------------------------------------

struct txEXSLTFunctionDescriptor
{
    int8_t mMinParams;
    int8_t mMaxParams;
    Expr::ResultType mReturnType;
    int32_t mNamespaceID;
    nsIAtom** mName;
    const char* mNamespaceURI;
};

static const char kEXSLTCommonNS[] = "http://exslt.org/common";
static const char kEXSLTSetsNS[] = "http://exslt.org/sets";
static const char kEXSLTStringsNS[] = "http://exslt.org/strings";
static const char kEXSLTMathNS[] = "http://exslt.org/math";
static const char kEXSLTDatesAndTimesNS[] = "http://exslt.org/dates-and-times";

// The order of this table must be the same as the
// txEXSLTFunctionCall::eType enum
static txEXSLTFunctionDescriptor descriptTable[] =
{
    { 1, 1, Expr::NODESET_RESULT, 0, &nsGkAtoms::nodeSet, kEXSLTCommonNS }, // NODE_SET
    { 1, 1, Expr::STRING_RESULT, 0, &nsGkAtoms::objectType, kEXSLTCommonNS }, // OBJECT_TYPE
    { 2, 2, Expr::NODESET_RESULT, 0, &nsGkAtoms::difference, kEXSLTSetsNS }, // DIFFERENCE
    { 1, 1, Expr::NODESET_RESULT, 0, &nsGkAtoms::distinct, kEXSLTSetsNS }, // DISTINCT
    { 2, 2, Expr::BOOLEAN_RESULT, 0, &nsGkAtoms::hasSameNode, kEXSLTSetsNS }, // HAS_SAME_NODE
    { 2, 2, Expr::NODESET_RESULT, 0, &nsGkAtoms::intersection, kEXSLTSetsNS }, // INTERSECTION
    { 2, 2, Expr::NODESET_RESULT, 0, &nsGkAtoms::leading, kEXSLTSetsNS }, // LEADING
    { 2, 2, Expr::NODESET_RESULT, 0, &nsGkAtoms::trailing, kEXSLTSetsNS }, // TRAILING
    { 1, 1, Expr::STRING_RESULT, 0, &nsGkAtoms::concat, kEXSLTStringsNS }, // CONCAT
    { 1, 2, Expr::STRING_RESULT, 0, &nsGkAtoms::split, kEXSLTStringsNS }, // SPLIT
    { 1, 2, Expr::STRING_RESULT, 0, &nsGkAtoms::tokenize, kEXSLTStringsNS }, // TOKENIZE
    { 1, 1, Expr::NUMBER_RESULT, 0, &nsGkAtoms::max, kEXSLTMathNS }, // MAX
    { 1, 1, Expr::NUMBER_RESULT, 0, &nsGkAtoms::min, kEXSLTMathNS }, // MIN
    { 1, 1, Expr::NODESET_RESULT, 0, &nsGkAtoms::highest, kEXSLTMathNS }, // HIGHEST
    { 1, 1, Expr::NODESET_RESULT, 0, &nsGkAtoms::lowest, kEXSLTMathNS }, // LOWEST
    { 0, 0, Expr::STRING_RESULT, 0, &nsGkAtoms::dateTime, kEXSLTDatesAndTimesNS }, // DATE_TIME

};

class txEXSLTFunctionCall : public FunctionCall
{
public:
    // The order of this enum must be the same as the descriptTable
    // table above
    enum eType {
        // Set functions
        NODE_SET,
        OBJECT_TYPE,
        DIFFERENCE,
        DISTINCT,
        HAS_SAME_NODE,
        INTERSECTION,
        LEADING,
        TRAILING,
        CONCAT,
        SPLIT,
        TOKENIZE,
        MAX,
        MIN,
        HIGHEST,
        LOWEST,
        DATE_TIME
    };

    explicit txEXSLTFunctionCall(eType aType)
      : mType(aType)
    {
    }

    TX_DECL_FUNCTION

private:
    eType mType;
};

nsresult
txEXSLTFunctionCall::evaluate(txIEvalContext *aContext,
                              txAExprResult **aResult)
{
    *aResult = nullptr;
    if (!requireParams(descriptTable[mType].mMinParams,
                       descriptTable[mType].mMaxParams,
                       aContext)) {
        return NS_ERROR_XPATH_BAD_ARGUMENT_COUNT;
    }

    nsresult rv = NS_OK;
    switch (mType) {
        case NODE_SET:
        {
            RefPtr<txAExprResult> exprResult;
            rv = mParams[0]->evaluate(aContext, getter_AddRefs(exprResult));
            NS_ENSURE_SUCCESS(rv, rv);

            if (exprResult->getResultType() == txAExprResult::NODESET) {
                exprResult.forget(aResult);
            }
            else {
                RefPtr<txNodeSet> resultSet;
                rv = aContext->recycler()->
                    getNodeSet(getter_AddRefs(resultSet));
                NS_ENSURE_SUCCESS(rv, rv);

                if (exprResult->getResultType() ==
                    txAExprResult::RESULT_TREE_FRAGMENT) {
                    txResultTreeFragment *rtf =
                        static_cast<txResultTreeFragment*>
                                   (exprResult.get());

                    const txXPathNode *node = rtf->getNode();
                    if (!node) {
                        rv = convertRtfToNode(aContext, rtf);
                        NS_ENSURE_SUCCESS(rv, rv);

                        node = rtf->getNode();
                    }

                    resultSet->append(*node);
                }
                else {
                    nsAutoString value;
                    exprResult->stringValue(value);

                    nsAutoPtr<txXPathNode> node;
                    rv = createTextNode(aContext, value,
                                        getter_Transfers(node));
                    NS_ENSURE_SUCCESS(rv, rv);

                    resultSet->append(*node);
                }

                NS_ADDREF(*aResult = resultSet);
            }

            return NS_OK;
        }
        case OBJECT_TYPE:
        {
            RefPtr<txAExprResult> exprResult;
            nsresult rv = mParams[0]->evaluate(aContext,
                                               getter_AddRefs(exprResult));
            NS_ENSURE_SUCCESS(rv, rv);

            RefPtr<StringResult> strRes;
            rv = aContext->recycler()->getStringResult(getter_AddRefs(strRes));
            NS_ENSURE_SUCCESS(rv, rv);

            AppendASCIItoUTF16(sTypes[exprResult->getResultType()],
                               strRes->mValue);

            NS_ADDREF(*aResult = strRes);

            return NS_OK;
        }
        case DIFFERENCE:
        case INTERSECTION:
        {
            RefPtr<txNodeSet> nodes1;
            rv = evaluateToNodeSet(mParams[0], aContext,
                                   getter_AddRefs(nodes1));
            NS_ENSURE_SUCCESS(rv, rv);

            RefPtr<txNodeSet> nodes2;
            rv = evaluateToNodeSet(mParams[1], aContext,
                                   getter_AddRefs(nodes2));
            NS_ENSURE_SUCCESS(rv, rv);

            RefPtr<txNodeSet> resultSet;
            rv = aContext->recycler()->getNodeSet(getter_AddRefs(resultSet));
            NS_ENSURE_SUCCESS(rv, rv);

            bool insertOnFound = mType == INTERSECTION;

            int32_t searchPos = 0;
            int32_t i, len = nodes1->size();
            for (i = 0; i < len; ++i) {
                const txXPathNode& node = nodes1->get(i);
                int32_t foundPos = nodes2->indexOf(node, searchPos);
                if (foundPos >= 0) {
                    searchPos = foundPos + 1;
                }

                if ((foundPos >= 0) == insertOnFound) {
                    rv = resultSet->append(node);
                    NS_ENSURE_SUCCESS(rv, rv);
                }
            }

            NS_ADDREF(*aResult = resultSet);

            return NS_OK;
        }
        case DISTINCT:
        {
            RefPtr<txNodeSet> nodes;
            rv = evaluateToNodeSet(mParams[0], aContext,
                                   getter_AddRefs(nodes));
            NS_ENSURE_SUCCESS(rv, rv);

            RefPtr<txNodeSet> resultSet;
            rv = aContext->recycler()->getNodeSet(getter_AddRefs(resultSet));
            NS_ENSURE_SUCCESS(rv, rv);

            nsTHashtable<nsStringHashKey> hash;

            int32_t i, len = nodes->size();
            for (i = 0; i < len; ++i) {
                nsAutoString str;
                const txXPathNode& node = nodes->get(i);
                txXPathNodeUtils::appendNodeValue(node, str);
                if (!hash.GetEntry(str)) {
                    hash.PutEntry(str);
                    rv = resultSet->append(node);
                    NS_ENSURE_SUCCESS(rv, rv);
                }
            }

            NS_ADDREF(*aResult = resultSet);

            return NS_OK;
        }
        case HAS_SAME_NODE:
        {
            RefPtr<txNodeSet> nodes1;
            rv = evaluateToNodeSet(mParams[0], aContext,
                                   getter_AddRefs(nodes1));
            NS_ENSURE_SUCCESS(rv, rv);

            RefPtr<txNodeSet> nodes2;
            rv = evaluateToNodeSet(mParams[1], aContext,
                                   getter_AddRefs(nodes2));
            NS_ENSURE_SUCCESS(rv, rv);

            bool found = false;
            int32_t i, len = nodes1->size();
            for (i = 0; i < len; ++i) {
                if (nodes2->contains(nodes1->get(i))) {
                    found = true;
                    break;
                }
            }

            aContext->recycler()->getBoolResult(found, aResult);

            return NS_OK;
        }
        case LEADING:
        case TRAILING:
        {
            RefPtr<txNodeSet> nodes1;
            rv = evaluateToNodeSet(mParams[0], aContext,
                                   getter_AddRefs(nodes1));
            NS_ENSURE_SUCCESS(rv, rv);

            RefPtr<txNodeSet> nodes2;
            rv = evaluateToNodeSet(mParams[1], aContext,
                                   getter_AddRefs(nodes2));
            NS_ENSURE_SUCCESS(rv, rv);

            if (nodes2->isEmpty()) {
                *aResult = nodes1;
                NS_ADDREF(*aResult);

                return NS_OK;
            }

            RefPtr<txNodeSet> resultSet;
            rv = aContext->recycler()->getNodeSet(getter_AddRefs(resultSet));
            NS_ENSURE_SUCCESS(rv, rv);

            int32_t end = nodes1->indexOf(nodes2->get(0));
            if (end >= 0) {
                int32_t i = 0;
                if (mType == TRAILING) {
                    i = end + 1;
                    end = nodes1->size();
                }
                for (; i < end; ++i) {
                    rv = resultSet->append(nodes1->get(i));
                    NS_ENSURE_SUCCESS(rv, rv);
                }
            }

            NS_ADDREF(*aResult = resultSet);

            return NS_OK;
        }
        case CONCAT:
        {
            RefPtr<txNodeSet> nodes;
            rv = evaluateToNodeSet(mParams[0], aContext,
                                   getter_AddRefs(nodes));
            NS_ENSURE_SUCCESS(rv, rv);

            nsAutoString str;
            int32_t i, len = nodes->size();
            for (i = 0; i < len; ++i) {
                txXPathNodeUtils::appendNodeValue(nodes->get(i), str);
            }

            return aContext->recycler()->getStringResult(str, aResult);
        }
        case SPLIT:
        case TOKENIZE:
        {
            // Evaluate parameters
            nsAutoString string;
            rv = mParams[0]->evaluateToString(aContext, string);
            NS_ENSURE_SUCCESS(rv, rv);

            nsAutoString pattern;
            if (mParams.Length() == 2) {
                rv = mParams[1]->evaluateToString(aContext, pattern);
                NS_ENSURE_SUCCESS(rv, rv);
            }
            else if (mType == SPLIT) {
                pattern.Assign(' ');
            }
            else {
                pattern.AssignLiteral("\t\r\n ");
            }

            // Set up holders for the result
            RefPtr<DocumentFragment> docFrag = createDocFragment(aContext);
            NS_ENSURE_STATE(docFrag);

            RefPtr<txNodeSet> resultSet;
            rv = aContext->recycler()->getNodeSet(getter_AddRefs(resultSet));
            NS_ENSURE_SUCCESS(rv, rv);

            uint32_t tailIndex;

            // Start splitting
            if (pattern.IsEmpty()) {
                nsString::const_char_iterator start = string.BeginReading();
                nsString::const_char_iterator end = string.EndReading();
                for (; start < end; ++start) {
                    rv = createAndAddToResult(nsGkAtoms::token,
                                              Substring(start, start + 1),
                                              resultSet, docFrag);
                    NS_ENSURE_SUCCESS(rv, rv);
                }

                tailIndex = string.Length();
            }
            else if (mType == SPLIT) {
                nsAString::const_iterator strStart, strEnd;
                string.BeginReading(strStart);
                string.EndReading(strEnd);
                nsAString::const_iterator start = strStart, end = strEnd;

                while (FindInReadable(pattern, start, end)) {
                    if (start != strStart) {
                        rv = createAndAddToResult(nsGkAtoms::token,
                                                  Substring(strStart, start),
                                                  resultSet, docFrag);
                        NS_ENSURE_SUCCESS(rv, rv);
                    }
                    strStart = start = end;
                    end = strEnd;
                }

                tailIndex = strStart.get() - string.get();
            }
            else {
                int32_t found, start = 0;
                while ((found = string.FindCharInSet(pattern, start)) !=
                       kNotFound) {
                    if (found != start) {
                        rv = createAndAddToResult(nsGkAtoms::token,
                                                  Substring(string, start,
                                                            found - start),
                                                  resultSet, docFrag);
                        NS_ENSURE_SUCCESS(rv, rv);
                    }
                    start = found + 1;
                }

                tailIndex = start;
            }

            // Add tail if needed
            if (tailIndex != (uint32_t)string.Length()) {
                rv = createAndAddToResult(nsGkAtoms::token,
                                          Substring(string, tailIndex),
                                          resultSet, docFrag);
                NS_ENSURE_SUCCESS(rv, rv);
            }

            NS_ADDREF(*aResult = resultSet);

            return NS_OK;
        }
        case MAX:
        case MIN:
        {
            RefPtr<txNodeSet> nodes;
            rv = evaluateToNodeSet(mParams[0], aContext,
                                   getter_AddRefs(nodes));
            NS_ENSURE_SUCCESS(rv, rv);

            if (nodes->isEmpty()) {
                return aContext->recycler()->
                    getNumberResult(UnspecifiedNaN<double>(), aResult);
            }

            bool findMax = mType == MAX;

            double res = findMax ? mozilla::NegativeInfinity<double>() :
                                   mozilla::PositiveInfinity<double>();
            int32_t i, len = nodes->size();
            for (i = 0; i < len; ++i) {
                nsAutoString str;
                txXPathNodeUtils::appendNodeValue(nodes->get(i), str);
                double val = txDouble::toDouble(str);
                if (mozilla::IsNaN(val)) {
                    res = UnspecifiedNaN<double>();
                    break;
                }

                if (findMax ? (val > res) : (val < res)) {
                    res = val;
                }
            }

            return aContext->recycler()->getNumberResult(res, aResult);
        }
        case HIGHEST:
        case LOWEST:
        {
            RefPtr<txNodeSet> nodes;
            rv = evaluateToNodeSet(mParams[0], aContext,
                                   getter_AddRefs(nodes));
            NS_ENSURE_SUCCESS(rv, rv);

            if (nodes->isEmpty()) {
                NS_ADDREF(*aResult = nodes);

                return NS_OK;
            }

            RefPtr<txNodeSet> resultSet;
            rv = aContext->recycler()->getNodeSet(getter_AddRefs(resultSet));
            NS_ENSURE_SUCCESS(rv, rv);

            bool findMax = mType == HIGHEST;
            double res = findMax ? mozilla::NegativeInfinity<double>() :
                                   mozilla::PositiveInfinity<double>();
            int32_t i, len = nodes->size();
            for (i = 0; i < len; ++i) {
                nsAutoString str;
                const txXPathNode& node = nodes->get(i);
                txXPathNodeUtils::appendNodeValue(node, str);
                double val = txDouble::toDouble(str);
                if (mozilla::IsNaN(val)) {
                    resultSet->clear();
                    break;
                }
                if (findMax ? (val > res) : (val < res)) {
                    resultSet->clear();
                    res = val;
                }

                if (res == val) {
                    rv = resultSet->append(node);
                    NS_ENSURE_SUCCESS(rv, rv);
                }
            }

            NS_ADDREF(*aResult = resultSet);

            return NS_OK;
        }
        case DATE_TIME:
        {
            // http://exslt.org/date/functions/date-time/

            PRExplodedTime prtime;
            PR_ExplodeTime(PR_Now(), PR_LocalTimeParameters, &prtime);

            int32_t offset = (prtime.tm_params.tp_gmt_offset +
              prtime.tm_params.tp_dst_offset) / 60;

            bool isneg = offset < 0;
            if (isneg) offset = -offset;

            StringResult* strRes;
            rv = aContext->recycler()->getStringResult(&strRes);
            NS_ENSURE_SUCCESS(rv, rv);

            // format: YYYY-MM-DDTTHH:MM:SS.sss+00:00
            CopyASCIItoUTF16(nsPrintfCString("%04hd-%02" PRId32 "-%02" PRId32
                                             "T%02" PRId32 ":%02" PRId32 ":%02" PRId32
                                             ".%03" PRId32 "%c%02" PRId32 ":%02" PRId32,
              prtime.tm_year, prtime.tm_month + 1, prtime.tm_mday,
              prtime.tm_hour, prtime.tm_min, prtime.tm_sec,
              prtime.tm_usec / 10000,
              isneg ? '-' : '+', offset / 60, offset % 60), strRes->mValue);

            *aResult = strRes;

            return NS_OK;
        }
    }

    aContext->receiveError(NS_LITERAL_STRING("Internal error"),
                           NS_ERROR_UNEXPECTED);
    return NS_ERROR_UNEXPECTED;
}

Expr::ResultType
txEXSLTFunctionCall::getReturnType()
{
    return descriptTable[mType].mReturnType;
}

bool
txEXSLTFunctionCall::isSensitiveTo(ContextSensitivity aContext)
{
    if (mType == NODE_SET || mType == SPLIT || mType == TOKENIZE) {
        return (aContext & PRIVATE_CONTEXT) || argsSensitiveTo(aContext);
    }
    return argsSensitiveTo(aContext);
}

#ifdef TX_TO_STRING
nsresult
txEXSLTFunctionCall::getNameAtom(nsIAtom **aAtom)
{
    NS_ADDREF(*aAtom = *descriptTable[mType].mName);
    return NS_OK;
}
#endif

extern nsresult
TX_ConstructEXSLTFunction(nsIAtom *aName,
                          int32_t aNamespaceID,
                          txStylesheetCompilerState* aState,
                          FunctionCall **aResult)
{
    uint32_t i;
    for (i = 0; i < ArrayLength(descriptTable); ++i) {
        txEXSLTFunctionDescriptor& desc = descriptTable[i];
        if (aName == *desc.mName && aNamespaceID == desc.mNamespaceID) {
            *aResult = new txEXSLTFunctionCall(
                static_cast<txEXSLTFunctionCall::eType>(i));
            return NS_OK;
        }
    }

    return NS_ERROR_XPATH_UNKNOWN_FUNCTION;
}

extern bool
TX_InitEXSLTFunction()
{
    uint32_t i;
    for (i = 0; i < ArrayLength(descriptTable); ++i) {
        txEXSLTFunctionDescriptor& desc = descriptTable[i];
        NS_ConvertASCIItoUTF16 namespaceURI(desc.mNamespaceURI);
        desc.mNamespaceID =
            txNamespaceManager::getNamespaceID(namespaceURI);

        if (desc.mNamespaceID == kNameSpaceID_Unknown) {
            return false;
        }
    }

    return true;
}
