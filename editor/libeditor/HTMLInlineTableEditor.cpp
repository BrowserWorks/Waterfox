/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/HTMLEditor.h"

#include "HTMLEditUtils.h"
#include "mozilla/dom/Element.h"
#include "nsAString.h"
#include "nsCOMPtr.h"
#include "nsDebug.h"
#include "nsError.h"
#include "nsIContent.h"
#include "nsIDOMElement.h"
#include "nsIDOMEventTarget.h"
#include "nsIDOMHTMLElement.h"
#include "nsIDOMNode.h"
#include "nsIHTMLObjectResizer.h"
#include "nsIPresShell.h"
#include "nsLiteralString.h"
#include "nsReadableUtils.h"
#include "nsString.h"
#include "nscore.h"

namespace mozilla {

// Uncomment the following line if you want to disable
// table deletion when the only column/row is removed
// #define DISABLE_TABLE_DELETION 1

NS_IMETHODIMP
HTMLEditor::SetInlineTableEditingEnabled(bool aIsEnabled)
{
  mIsInlineTableEditingEnabled = aIsEnabled;
  return NS_OK;
}

NS_IMETHODIMP
HTMLEditor::GetInlineTableEditingEnabled(bool* aIsEnabled)
{
  *aIsEnabled = mIsInlineTableEditingEnabled;
  return NS_OK;
}

NS_IMETHODIMP
HTMLEditor::ShowInlineTableEditingUI(nsIDOMElement* aCell)
{
  NS_ENSURE_ARG_POINTER(aCell);

  // do nothing if aCell is not a table cell...
  if (!HTMLEditUtils::IsTableCell(aCell)) {
    return NS_OK;
  }

  if (mInlineEditedCell) {
    NS_ERROR("call HideInlineTableEditingUI first");
    return NS_ERROR_UNEXPECTED;
  }

  // the resizers and the shadow will be anonymous children of the body
  nsCOMPtr<nsIDOMElement> bodyElement = do_QueryInterface(GetRoot());
  NS_ENSURE_TRUE(bodyElement, NS_ERROR_NULL_POINTER);

  CreateAnonymousElement(NS_LITERAL_STRING("a"), bodyElement,
                         NS_LITERAL_STRING("mozTableAddColumnBefore"),
                         false, getter_AddRefs(mAddColumnBeforeButton));
  CreateAnonymousElement(NS_LITERAL_STRING("a"), bodyElement,
                         NS_LITERAL_STRING("mozTableRemoveColumn"),
                         false, getter_AddRefs(mRemoveColumnButton));
  CreateAnonymousElement(NS_LITERAL_STRING("a"), bodyElement,
                         NS_LITERAL_STRING("mozTableAddColumnAfter"),
                         false, getter_AddRefs(mAddColumnAfterButton));

  CreateAnonymousElement(NS_LITERAL_STRING("a"), bodyElement,
                         NS_LITERAL_STRING("mozTableAddRowBefore"),
                         false, getter_AddRefs(mAddRowBeforeButton));
  CreateAnonymousElement(NS_LITERAL_STRING("a"), bodyElement,
                         NS_LITERAL_STRING("mozTableRemoveRow"),
                         false, getter_AddRefs(mRemoveRowButton));
  CreateAnonymousElement(NS_LITERAL_STRING("a"), bodyElement,
                         NS_LITERAL_STRING("mozTableAddRowAfter"),
                         false, getter_AddRefs(mAddRowAfterButton));

  AddMouseClickListener(mAddColumnBeforeButton);
  AddMouseClickListener(mRemoveColumnButton);
  AddMouseClickListener(mAddColumnAfterButton);
  AddMouseClickListener(mAddRowBeforeButton);
  AddMouseClickListener(mRemoveRowButton);
  AddMouseClickListener(mAddRowAfterButton);

  mInlineEditedCell = aCell;
  return RefreshInlineTableEditingUI();
}

NS_IMETHODIMP
HTMLEditor::HideInlineTableEditingUI()
{
  mInlineEditedCell = nullptr;

  RemoveMouseClickListener(mAddColumnBeforeButton);
  RemoveMouseClickListener(mRemoveColumnButton);
  RemoveMouseClickListener(mAddColumnAfterButton);
  RemoveMouseClickListener(mAddRowBeforeButton);
  RemoveMouseClickListener(mRemoveRowButton);
  RemoveMouseClickListener(mAddRowAfterButton);

  // get the presshell's document observer interface.
  nsCOMPtr<nsIPresShell> ps = GetPresShell();
  // We allow the pres shell to be null; when it is, we presume there
  // are no document observers to notify, but we still want to
  // UnbindFromTree.

  // get the root content node.
  nsCOMPtr<nsIContent> bodyContent = GetRoot();

  DeleteRefToAnonymousNode(mAddColumnBeforeButton, bodyContent, ps);
  mAddColumnBeforeButton = nullptr;
  DeleteRefToAnonymousNode(mRemoveColumnButton, bodyContent, ps);
  mRemoveColumnButton = nullptr;
  DeleteRefToAnonymousNode(mAddColumnAfterButton, bodyContent, ps);
  mAddColumnAfterButton = nullptr;
  DeleteRefToAnonymousNode(mAddRowBeforeButton, bodyContent, ps);
  mAddRowBeforeButton = nullptr;
  DeleteRefToAnonymousNode(mRemoveRowButton, bodyContent, ps);
  mRemoveRowButton = nullptr;
  DeleteRefToAnonymousNode(mAddRowAfterButton, bodyContent, ps);
  mAddRowAfterButton = nullptr;

  return NS_OK;
}

NS_IMETHODIMP
HTMLEditor::DoInlineTableEditingAction(nsIDOMElement* aElement)
{
  NS_ENSURE_ARG_POINTER(aElement);
  bool anonElement = false;
  if (aElement &&
      NS_SUCCEEDED(aElement->HasAttribute(NS_LITERAL_STRING("_moz_anonclass"), &anonElement)) &&
      anonElement) {
    nsAutoString anonclass;
    nsresult rv =
      aElement->GetAttribute(NS_LITERAL_STRING("_moz_anonclass"), anonclass);
    NS_ENSURE_SUCCESS(rv, rv);

    if (!StringBeginsWith(anonclass, NS_LITERAL_STRING("mozTable")))
      return NS_OK;

    nsCOMPtr<nsIDOMNode> tableNode = GetEnclosingTable(mInlineEditedCell);
    nsCOMPtr<nsIDOMElement> tableElement = do_QueryInterface(tableNode);
    int32_t rowCount, colCount;
    rv = GetTableSize(tableElement, &rowCount, &colCount);
    NS_ENSURE_SUCCESS(rv, rv);

    bool hideUI = false;
    bool hideResizersWithInlineTableUI = (GetAsDOMNode(mResizedObject) == tableElement);

    if (anonclass.EqualsLiteral("mozTableAddColumnBefore"))
      InsertTableColumn(1, false);
    else if (anonclass.EqualsLiteral("mozTableAddColumnAfter"))
      InsertTableColumn(1, true);
    else if (anonclass.EqualsLiteral("mozTableAddRowBefore"))
      InsertTableRow(1, false);
    else if (anonclass.EqualsLiteral("mozTableAddRowAfter"))
      InsertTableRow(1, true);
    else if (anonclass.EqualsLiteral("mozTableRemoveColumn")) {
      DeleteTableColumn(1);
#ifndef DISABLE_TABLE_DELETION
      hideUI = (colCount == 1);
#endif
    }
    else if (anonclass.EqualsLiteral("mozTableRemoveRow")) {
      DeleteTableRow(1);
#ifndef DISABLE_TABLE_DELETION
      hideUI = (rowCount == 1);
#endif
    }
    else
      return NS_OK;

    if (hideUI) {
      HideInlineTableEditingUI();
      if (hideResizersWithInlineTableUI)
        HideResizers();
    }
  }

  return NS_OK;
}

void
HTMLEditor::AddMouseClickListener(nsIDOMElement* aElement)
{
  nsCOMPtr<nsIDOMEventTarget> evtTarget(do_QueryInterface(aElement));
  if (evtTarget) {
    evtTarget->AddEventListener(NS_LITERAL_STRING("click"),
                                mEventListener, true);
  }
}

void
HTMLEditor::RemoveMouseClickListener(nsIDOMElement* aElement)
{
  nsCOMPtr<nsIDOMEventTarget> evtTarget(do_QueryInterface(aElement));
  if (evtTarget) {
    evtTarget->RemoveEventListener(NS_LITERAL_STRING("click"),
                                   mEventListener, true);
  }
}

NS_IMETHODIMP
HTMLEditor::RefreshInlineTableEditingUI()
{
  nsCOMPtr<nsIDOMHTMLElement> htmlElement = do_QueryInterface(mInlineEditedCell);
  if (!htmlElement) {
    return NS_ERROR_NULL_POINTER;
  }

  int32_t xCell, yCell, wCell, hCell;
  GetElementOrigin(mInlineEditedCell, xCell, yCell);

  nsresult rv = htmlElement->GetOffsetWidth(&wCell);
  NS_ENSURE_SUCCESS(rv, rv);
  rv = htmlElement->GetOffsetHeight(&hCell);
  NS_ENSURE_SUCCESS(rv, rv);

  int32_t xHoriz = xCell + wCell/2;
  int32_t yVert  = yCell + hCell/2;

  nsCOMPtr<nsIDOMNode> tableNode = GetEnclosingTable(mInlineEditedCell);
  nsCOMPtr<nsIDOMElement> tableElement = do_QueryInterface(tableNode);
  int32_t rowCount, colCount;
  rv = GetTableSize(tableElement, &rowCount, &colCount);
  NS_ENSURE_SUCCESS(rv, rv);

  SetAnonymousElementPosition(xHoriz-10, yCell-7,  mAddColumnBeforeButton);
#ifdef DISABLE_TABLE_DELETION
  NS_NAMED_LITERAL_STRING(classStr, "class");

  if (colCount== 1) {
    mRemoveColumnButton->SetAttribute(classStr,
                                      NS_LITERAL_STRING("hidden"));
  }
  else {
    bool hasClass = false;
    rv = mRemoveColumnButton->HasAttribute(classStr, &hasClass);
    if (NS_SUCCEEDED(rv) && hasClass) {
      mRemoveColumnButton->RemoveAttribute(classStr);
    }
#endif
    SetAnonymousElementPosition(xHoriz-4, yCell-7,  mRemoveColumnButton);
#ifdef DISABLE_TABLE_DELETION
  }
#endif
  SetAnonymousElementPosition(xHoriz+6, yCell-7,  mAddColumnAfterButton);

  SetAnonymousElementPosition(xCell-7, yVert-10,  mAddRowBeforeButton);
#ifdef DISABLE_TABLE_DELETION
  if (rowCount== 1) {
    mRemoveRowButton->SetAttribute(classStr,
                                   NS_LITERAL_STRING("hidden"));
  }
  else {
    bool hasClass = false;
    rv = mRemoveRowButton->HasAttribute(classStr, &hasClass);
    if (NS_SUCCEEDED(rv) && hasClass) {
      mRemoveRowButton->RemoveAttribute(classStr);
    }
#endif
    SetAnonymousElementPosition(xCell-7, yVert-4,  mRemoveRowButton);
#ifdef DISABLE_TABLE_DELETION
  }
#endif
  SetAnonymousElementPosition(xCell-7, yVert+6,  mAddRowAfterButton);

  return NS_OK;
}

} // namespace mozilla
