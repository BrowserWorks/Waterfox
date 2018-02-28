/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "XULTreeGridAccessibleWrap.h"

#include "nsAccCache.h"
#include "nsAccessibilityService.h"
#include "nsAccUtils.h"
#include "DocAccessible.h"
#include "nsEventShell.h"
#include "Relation.h"
#include "Role.h"
#include "States.h"
#include "nsQueryObject.h"

#include "nsIBoxObject.h"
#include "nsIMutableArray.h"
#include "nsIPersistentProperties2.h"
#include "nsITreeSelection.h"
#include "nsComponentManagerUtils.h"

using namespace mozilla::a11y;

XULTreeGridAccessible::~XULTreeGridAccessible()
{
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridAccessible: Table

uint32_t
XULTreeGridAccessible::ColCount()
{
  return nsCoreUtils::GetSensibleColumnCount(mTree);
}

uint32_t
XULTreeGridAccessible::RowCount()
{
  if (!mTreeView)
    return 0;

  int32_t rowCount = 0;
  mTreeView->GetRowCount(&rowCount);
  return rowCount >= 0 ? rowCount : 0;
}

uint32_t
XULTreeGridAccessible::SelectedCellCount()
{
  return SelectedRowCount() * ColCount();
}

uint32_t
XULTreeGridAccessible::SelectedColCount()
{
  // If all the row has been selected, then all the columns are selected,
  // because we can't select a column alone.

  uint32_t selectedRowCount = SelectedItemCount();
  return selectedRowCount > 0 && selectedRowCount == RowCount() ? ColCount() : 0;
}

uint32_t
XULTreeGridAccessible::SelectedRowCount()
{
  return SelectedItemCount();
}

void
XULTreeGridAccessible::SelectedCells(nsTArray<Accessible*>* aCells)
{
  uint32_t colCount = ColCount(), rowCount = RowCount();

  for (uint32_t rowIdx = 0; rowIdx < rowCount; rowIdx++) {
    if (IsRowSelected(rowIdx)) {
      for (uint32_t colIdx = 0; colIdx < colCount; colIdx++) {
        Accessible* cell = CellAt(rowIdx, colIdx);
        aCells->AppendElement(cell);
      }
    }
  }
}

void
XULTreeGridAccessible::SelectedCellIndices(nsTArray<uint32_t>* aCells)
{
  uint32_t colCount = ColCount(), rowCount = RowCount();

  for (uint32_t rowIdx = 0; rowIdx < rowCount; rowIdx++)
    if (IsRowSelected(rowIdx))
      for (uint32_t colIdx = 0; colIdx < colCount; colIdx++)
        aCells->AppendElement(rowIdx * colCount + colIdx);
}

void
XULTreeGridAccessible::SelectedColIndices(nsTArray<uint32_t>* aCols)
{
  if (RowCount() != SelectedRowCount())
    return;

  uint32_t colCount = ColCount();
  aCols->SetCapacity(colCount);
  for (uint32_t colIdx = 0; colIdx < colCount; colIdx++)
    aCols->AppendElement(colIdx);
}

void
XULTreeGridAccessible::SelectedRowIndices(nsTArray<uint32_t>* aRows)
{
  uint32_t rowCount = RowCount();
  for (uint32_t rowIdx = 0; rowIdx < rowCount; rowIdx++)
    if (IsRowSelected(rowIdx))
      aRows->AppendElement(rowIdx);
}

Accessible*
XULTreeGridAccessible::CellAt(uint32_t aRowIndex, uint32_t aColumnIndex)
{
  Accessible* row = GetTreeItemAccessible(aRowIndex);
  if (!row)
    return nullptr;

  nsCOMPtr<nsITreeColumn> column =
    nsCoreUtils::GetSensibleColumnAt(mTree, aColumnIndex);
  if (!column)
    return nullptr;

  RefPtr<XULTreeItemAccessibleBase> rowAcc = do_QueryObject(row);
  if (!rowAcc)
    return nullptr;

  return rowAcc->GetCellAccessible(column);
}

void
XULTreeGridAccessible::ColDescription(uint32_t aColIdx, nsString& aDescription)
{
  aDescription.Truncate();

  Accessible* treeColumns = Accessible::GetChildAt(0);
  if (treeColumns) {
    Accessible* treeColumnItem = treeColumns->GetChildAt(aColIdx);
    if (treeColumnItem)
      treeColumnItem->Name(aDescription);
  }
}

bool
XULTreeGridAccessible::IsColSelected(uint32_t aColIdx)
{
  // If all the row has been selected, then all the columns are selected.
  // Because we can't select a column alone.
  return SelectedItemCount() == RowCount();
}

bool
XULTreeGridAccessible::IsRowSelected(uint32_t aRowIdx)
{
  if (!mTreeView)
    return false;

  nsCOMPtr<nsITreeSelection> selection;
  nsresult rv = mTreeView->GetSelection(getter_AddRefs(selection));
  NS_ENSURE_SUCCESS(rv, false);

  bool isSelected = false;
  selection->IsSelected(aRowIdx, &isSelected);
  return isSelected;
}

bool
XULTreeGridAccessible::IsCellSelected(uint32_t aRowIdx, uint32_t aColIdx)
{
  return IsRowSelected(aRowIdx);
}

void
XULTreeGridAccessible::SelectRow(uint32_t aRowIdx)
{
  if (!mTreeView)
    return;

  nsCOMPtr<nsITreeSelection> selection;
  mTreeView->GetSelection(getter_AddRefs(selection));
  NS_ASSERTION(selection, "GetSelection() Shouldn't fail!");

  selection->Select(aRowIdx);
}

void
XULTreeGridAccessible::UnselectRow(uint32_t aRowIdx)
{
  if (!mTreeView)
    return;

  nsCOMPtr<nsITreeSelection> selection;
  mTreeView->GetSelection(getter_AddRefs(selection));

  if (selection)
    selection->ClearRange(aRowIdx, aRowIdx);
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridAccessible: Accessible implementation

role
XULTreeGridAccessible::NativeRole()
{
  nsCOMPtr<nsITreeColumns> treeColumns;
  mTree->GetColumns(getter_AddRefs(treeColumns));
  if (!treeColumns) {
    NS_ERROR("No treecolumns object for tree!");
    return roles::NOTHING;
  }

  nsCOMPtr<nsITreeColumn> primaryColumn;
  treeColumns->GetPrimaryColumn(getter_AddRefs(primaryColumn));

  return primaryColumn ? roles::TREE_TABLE : roles::TABLE;
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridAccessible: XULTreeAccessible implementation

already_AddRefed<Accessible>
XULTreeGridAccessible::CreateTreeItemAccessible(int32_t aRow) const
{
  RefPtr<Accessible> accessible =
    new XULTreeGridRowAccessible(mContent, mDoc,
                                 const_cast<XULTreeGridAccessible*>(this),
                                 mTree, mTreeView, aRow);

  return accessible.forget();
}


////////////////////////////////////////////////////////////////////////////////
// XULTreeGridRowAccessible
////////////////////////////////////////////////////////////////////////////////

XULTreeGridRowAccessible::
  XULTreeGridRowAccessible(nsIContent* aContent, DocAccessible* aDoc,
                           Accessible* aTreeAcc, nsITreeBoxObject* aTree,
                           nsITreeView* aTreeView, int32_t aRow) :
  XULTreeItemAccessibleBase(aContent, aDoc, aTreeAcc, aTree, aTreeView, aRow),
  mAccessibleCache(kDefaultTreeCacheLength)
{
  mGenericTypes |= eTableRow;
  mStateFlags |= eNoKidsFromDOM;
}

XULTreeGridRowAccessible::~XULTreeGridRowAccessible()
{
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridRowAccessible: nsISupports and cycle collection implementation

NS_IMPL_CYCLE_COLLECTION_INHERITED(XULTreeGridRowAccessible,
                                   XULTreeItemAccessibleBase,
                                   mAccessibleCache)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(XULTreeGridRowAccessible)
NS_INTERFACE_MAP_END_INHERITING(XULTreeItemAccessibleBase)

NS_IMPL_ADDREF_INHERITED(XULTreeGridRowAccessible,
                         XULTreeItemAccessibleBase)
NS_IMPL_RELEASE_INHERITED(XULTreeGridRowAccessible,
                          XULTreeItemAccessibleBase)

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridRowAccessible: Accessible implementation

void
XULTreeGridRowAccessible::Shutdown()
{
  if (mDoc && !mDoc->IsDefunct()) {
    UnbindCacheEntriesFromDocument(mAccessibleCache);
  }

  XULTreeItemAccessibleBase::Shutdown();
}

role
XULTreeGridRowAccessible::NativeRole()
{
  return roles::ROW;
}

ENameValueFlag
XULTreeGridRowAccessible::Name(nsString& aName)
{
  aName.Truncate();

  // XXX: the row name sholdn't be a concatenation of cell names (bug 664384).
  nsCOMPtr<nsITreeColumn> column = nsCoreUtils::GetFirstSensibleColumn(mTree);
  while (column) {
    if (!aName.IsEmpty())
      aName.Append(' ');

    nsAutoString cellName;
    GetCellName(column, cellName);
    aName.Append(cellName);

    column = nsCoreUtils::GetNextSensibleColumn(column);
  }

  return eNameOK;
}

Accessible*
XULTreeGridRowAccessible::ChildAtPoint(int32_t aX, int32_t aY,
                                       EWhichChildAtPoint aWhichChild)
{
  nsIFrame *frame = GetFrame();
  if (!frame)
    return nullptr;

  nsPresContext *presContext = frame->PresContext();
  nsIPresShell* presShell = presContext->PresShell();

  nsIFrame *rootFrame = presShell->GetRootFrame();
  NS_ENSURE_TRUE(rootFrame, nullptr);

  CSSIntRect rootRect = rootFrame->GetScreenRect();

  int32_t clientX = presContext->DevPixelsToIntCSSPixels(aX) - rootRect.x;
  int32_t clientY = presContext->DevPixelsToIntCSSPixels(aY) - rootRect.y;

  int32_t row = -1;
  nsCOMPtr<nsITreeColumn> column;
  nsAutoString childEltUnused;
  mTree->GetCellAt(clientX, clientY, &row, getter_AddRefs(column),
                   childEltUnused);

  // Return if we failed to find tree cell in the row for the given point.
  if (row != mRow || !column)
    return nullptr;

  return GetCellAccessible(column);
}

Accessible*
XULTreeGridRowAccessible::GetChildAt(uint32_t aIndex) const
{
  if (IsDefunct())
    return nullptr;

  nsCOMPtr<nsITreeColumn> column =
    nsCoreUtils::GetSensibleColumnAt(mTree, aIndex);
  if (!column)
    return nullptr;

  return GetCellAccessible(column);
}

uint32_t
XULTreeGridRowAccessible::ChildCount() const
{
  return nsCoreUtils::GetSensibleColumnCount(mTree);
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridRowAccessible: XULTreeItemAccessibleBase implementation

XULTreeGridCellAccessible*
XULTreeGridRowAccessible::GetCellAccessible(nsITreeColumn* aColumn) const
{
  NS_PRECONDITION(aColumn, "No tree column!");

  void* key = static_cast<void*>(aColumn);
  XULTreeGridCellAccessible* cachedCell = mAccessibleCache.GetWeak(key);
  if (cachedCell)
    return cachedCell;

  RefPtr<XULTreeGridCellAccessible> cell =
    new XULTreeGridCellAccessibleWrap(mContent, mDoc,
                                      const_cast<XULTreeGridRowAccessible*>(this),
                                      mTree, mTreeView, mRow, aColumn);
  mAccessibleCache.Put(key, cell);
  Document()->BindToDocument(cell, nullptr);
  return cell;
}

void
XULTreeGridRowAccessible::RowInvalidated(int32_t aStartColIdx,
                                         int32_t aEndColIdx)
{
  nsCOMPtr<nsITreeColumns> treeColumns;
  mTree->GetColumns(getter_AddRefs(treeColumns));
  if (!treeColumns)
    return;

  bool nameChanged = false;
  for (int32_t colIdx = aStartColIdx; colIdx <= aEndColIdx; ++colIdx) {
    nsCOMPtr<nsITreeColumn> column;
    treeColumns->GetColumnAt(colIdx, getter_AddRefs(column));
    if (column && !nsCoreUtils::IsColumnHidden(column)) {
      XULTreeGridCellAccessible* cell = GetCellAccessible(column);
      if (cell)
        nameChanged |= cell->CellInvalidated();
    }
  }

  if (nameChanged)
    nsEventShell::FireEvent(nsIAccessibleEvent::EVENT_NAME_CHANGE, this);

}


////////////////////////////////////////////////////////////////////////////////
// XULTreeGridCellAccessible
////////////////////////////////////////////////////////////////////////////////

XULTreeGridCellAccessible::
  XULTreeGridCellAccessible(nsIContent* aContent, DocAccessible* aDoc,
                            XULTreeGridRowAccessible* aRowAcc,
                            nsITreeBoxObject* aTree, nsITreeView* aTreeView,
                            int32_t aRow, nsITreeColumn* aColumn) :
  LeafAccessible(aContent, aDoc), mTree(aTree),
  mTreeView(aTreeView), mRow(aRow), mColumn(aColumn)
{
  mParent = aRowAcc;
  mStateFlags |= eSharedNode;
  mGenericTypes |= eTableCell;

  NS_ASSERTION(mTreeView, "mTreeView is null");

  int16_t type = -1;
  mColumn->GetType(&type);
  if (type == nsITreeColumn::TYPE_CHECKBOX)
    mTreeView->GetCellValue(mRow, mColumn, mCachedTextEquiv);
  else
    mTreeView->GetCellText(mRow, mColumn, mCachedTextEquiv);
}

XULTreeGridCellAccessible::~XULTreeGridCellAccessible()
{
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridCellAccessible: nsISupports implementation

NS_IMPL_CYCLE_COLLECTION_INHERITED(XULTreeGridCellAccessible, LeafAccessible,
                                   mTree, mColumn)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(XULTreeGridCellAccessible)
NS_INTERFACE_MAP_END_INHERITING(LeafAccessible)
NS_IMPL_ADDREF_INHERITED(XULTreeGridCellAccessible, LeafAccessible)
NS_IMPL_RELEASE_INHERITED(XULTreeGridCellAccessible, LeafAccessible)

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridCellAccessible: Accessible

void
XULTreeGridCellAccessible::Shutdown()
{
  mTree = nullptr;
  mTreeView = nullptr;
  mRow = -1;
  mColumn = nullptr;
  mParent = nullptr; // null-out to prevent base class's shutdown ops

  LeafAccessible::Shutdown();
}

Accessible*
XULTreeGridCellAccessible::FocusedChild()
{
  return nullptr;
}

ENameValueFlag
XULTreeGridCellAccessible::Name(nsString& aName)
{
  aName.Truncate();

  if (!mTreeView)
    return eNameOK;

  mTreeView->GetCellText(mRow, mColumn, aName);

  // If there is still no name try the cell value:
  // This is for graphical cells. We need tree/table view implementors to implement
  // FooView::GetCellValue to return a meaningful string for cases where there is
  // something shown in the cell (non-text) such as a star icon; in which case
  // GetCellValue for that cell would return "starred" or "flagged" for example.
  if (aName.IsEmpty())
    mTreeView->GetCellValue(mRow, mColumn, aName);

  return eNameOK;
}

nsIntRect
XULTreeGridCellAccessible::Bounds() const
{
  // Get bounds for tree cell and add x and y of treechildren element to
  // x and y of the cell.
  nsCOMPtr<nsIBoxObject> boxObj = nsCoreUtils::GetTreeBodyBoxObject(mTree);
  if (!boxObj)
    return nsIntRect();

  int32_t x = 0, y = 0, width = 0, height = 0;
  nsresult rv = mTree->GetCoordsForCellItem(mRow, mColumn,
                                            NS_LITERAL_STRING("cell"),
                                            &x, &y, &width, &height);
  if (NS_FAILED(rv))
    return nsIntRect();

  int32_t tcX = 0, tcY = 0;
  boxObj->GetScreenX(&tcX);
  boxObj->GetScreenY(&tcY);
  x += tcX;
  y += tcY;

  nsPresContext* presContext = mDoc->PresContext();
  return nsIntRect(presContext->CSSPixelsToDevPixels(x),
                   presContext->CSSPixelsToDevPixels(y),
                   presContext->CSSPixelsToDevPixels(width),
                   presContext->CSSPixelsToDevPixels(height));
}

uint8_t
XULTreeGridCellAccessible::ActionCount()
{
  bool isCycler = false;
  mColumn->GetCycler(&isCycler);
  if (isCycler)
    return 1;

  int16_t type;
  mColumn->GetType(&type);
  if (type == nsITreeColumn::TYPE_CHECKBOX && IsEditable())
    return 1;

  return 0;
}

void
XULTreeGridCellAccessible::ActionNameAt(uint8_t aIndex, nsAString& aName)
{
  aName.Truncate();

  if (aIndex != eAction_Click || !mTreeView)
    return;

  bool isCycler = false;
  mColumn->GetCycler(&isCycler);
  if (isCycler) {
    aName.AssignLiteral("cycle");
    return;
  }

  int16_t type = 0;
  mColumn->GetType(&type);
  if (type == nsITreeColumn::TYPE_CHECKBOX && IsEditable()) {
    nsAutoString value;
    mTreeView->GetCellValue(mRow, mColumn, value);
    if (value.EqualsLiteral("true"))
      aName.AssignLiteral("uncheck");
    else
      aName.AssignLiteral("check");
  }
}

bool
XULTreeGridCellAccessible::DoAction(uint8_t aIndex)
{
  if (aIndex != eAction_Click)
    return false;

  bool isCycler = false;
  mColumn->GetCycler(&isCycler);
  if (isCycler) {
    DoCommand();
    return true;
  }

  int16_t type;
  mColumn->GetType(&type);
  if (type == nsITreeColumn::TYPE_CHECKBOX && IsEditable()) {
    DoCommand();
    return true;
  }

  return false;
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridCellAccessible: TableCell

TableAccessible*
XULTreeGridCellAccessible::Table() const
{
  Accessible* grandParent = mParent->Parent();
  if (grandParent)
    return grandParent->AsTable();

  return nullptr;
}

uint32_t
XULTreeGridCellAccessible::ColIdx() const
{
  uint32_t colIdx = 0;
  nsCOMPtr<nsITreeColumn> column = mColumn;
  while ((column = nsCoreUtils::GetPreviousSensibleColumn(column)))
    colIdx++;

  return colIdx;
}

uint32_t
XULTreeGridCellAccessible::RowIdx() const
{
  return mRow;
}

void
XULTreeGridCellAccessible::ColHeaderCells(nsTArray<Accessible*>* aHeaderCells)
{
  nsCOMPtr<nsIDOMElement> columnElm;
  mColumn->GetElement(getter_AddRefs(columnElm));

  nsCOMPtr<nsIContent> columnContent(do_QueryInterface(columnElm));
  Accessible* headerCell = mDoc->GetAccessible(columnContent);
  if (headerCell)
    aHeaderCells->AppendElement(headerCell);
}

bool
XULTreeGridCellAccessible::Selected()
{
  nsCOMPtr<nsITreeSelection> selection;
  nsresult rv = mTreeView->GetSelection(getter_AddRefs(selection));
  NS_ENSURE_SUCCESS(rv, false);

  bool selected = false;
  selection->IsSelected(mRow, &selected);
  return selected;
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridCellAccessible: Accessible public implementation

already_AddRefed<nsIPersistentProperties>
XULTreeGridCellAccessible::NativeAttributes()
{
  nsCOMPtr<nsIPersistentProperties> attributes =
    do_CreateInstance(NS_PERSISTENTPROPERTIES_CONTRACTID);

  // "table-cell-index" attribute
  TableAccessible* table = Table();
  if (!table)
    return attributes.forget();

  nsAutoString stringIdx;
  stringIdx.AppendInt(table->CellIndexAt(mRow, ColIdx()));
  nsAccUtils::SetAccAttr(attributes, nsGkAtoms::tableCellIndex, stringIdx);

  // "cycles" attribute
  bool isCycler = false;
  nsresult rv = mColumn->GetCycler(&isCycler);
  if (NS_SUCCEEDED(rv) && isCycler)
    nsAccUtils::SetAccAttr(attributes, nsGkAtoms::cycles,
                           NS_LITERAL_STRING("true"));

  return attributes.forget();
}

role
XULTreeGridCellAccessible::NativeRole()
{
  return roles::GRID_CELL;
}

uint64_t
XULTreeGridCellAccessible::NativeState()
{
  if (!mTreeView)
    return states::DEFUNCT;

  // selectable/selected state
  uint64_t states = states::SELECTABLE; // keep in sync with NativeInteractiveState

  nsCOMPtr<nsITreeSelection> selection;
  mTreeView->GetSelection(getter_AddRefs(selection));
  if (selection) {
    bool isSelected = false;
    selection->IsSelected(mRow, &isSelected);
    if (isSelected)
      states |= states::SELECTED;
  }

  // checked state
  int16_t type;
  mColumn->GetType(&type);
  if (type == nsITreeColumn::TYPE_CHECKBOX) {
    states |= states::CHECKABLE;
    nsAutoString checked;
    mTreeView->GetCellValue(mRow, mColumn, checked);
    if (checked.EqualsIgnoreCase("true"))
      states |= states::CHECKED;
  }

  return states;
}

uint64_t
XULTreeGridCellAccessible::NativeInteractiveState() const
{
  return states::SELECTABLE;
}

int32_t
XULTreeGridCellAccessible::IndexInParent() const
{
  return ColIdx();
}

Relation
XULTreeGridCellAccessible::RelationByType(RelationType aType)
{
  return Relation();
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridCellAccessible: public implementation

bool
XULTreeGridCellAccessible::CellInvalidated()
{

  nsAutoString textEquiv;

  int16_t type;
  mColumn->GetType(&type);
  if (type == nsITreeColumn::TYPE_CHECKBOX) {
    mTreeView->GetCellValue(mRow, mColumn, textEquiv);
    if (mCachedTextEquiv != textEquiv) {
      bool isEnabled = textEquiv.EqualsLiteral("true");
      RefPtr<AccEvent> accEvent =
        new AccStateChangeEvent(this, states::CHECKED, isEnabled);
      nsEventShell::FireEvent(accEvent);

      mCachedTextEquiv = textEquiv;
      return true;
    }

    return false;
  }

  mTreeView->GetCellText(mRow, mColumn, textEquiv);
  if (mCachedTextEquiv != textEquiv) {
    nsEventShell::FireEvent(nsIAccessibleEvent::EVENT_NAME_CHANGE, this);
    mCachedTextEquiv = textEquiv;
    return true;
  }

  return false;
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridCellAccessible: Accessible protected implementation

Accessible*
XULTreeGridCellAccessible::GetSiblingAtOffset(int32_t aOffset,
                                              nsresult* aError) const
{
  if (aError)
    *aError =  NS_OK; // fail peacefully

  nsCOMPtr<nsITreeColumn> columnAtOffset(mColumn), column;
  if (aOffset < 0) {
    for (int32_t index = aOffset; index < 0 && columnAtOffset; index++) {
      column = nsCoreUtils::GetPreviousSensibleColumn(columnAtOffset);
      column.swap(columnAtOffset);
    }
  } else {
    for (int32_t index = aOffset; index > 0 && columnAtOffset; index--) {
      column = nsCoreUtils::GetNextSensibleColumn(columnAtOffset);
      column.swap(columnAtOffset);
    }
  }

  if (!columnAtOffset)
    return nullptr;

  RefPtr<XULTreeItemAccessibleBase> rowAcc = do_QueryObject(Parent());
  return rowAcc->GetCellAccessible(columnAtOffset);
}

void
XULTreeGridCellAccessible::DispatchClickEvent(nsIContent* aContent,
                                              uint32_t aActionIndex)
{
  if (IsDefunct())
    return;

  nsCoreUtils::DispatchClickEvent(mTree, mRow, mColumn);
}

////////////////////////////////////////////////////////////////////////////////
// XULTreeGridCellAccessible: protected implementation

bool
XULTreeGridCellAccessible::IsEditable() const
{

  // XXX: logic corresponds to tree.xml, it's preferable to have interface
  // method to check it.
  bool isEditable = false;
  nsresult rv = mTreeView->IsEditable(mRow, mColumn, &isEditable);
  if (NS_FAILED(rv) || !isEditable)
    return false;

  nsCOMPtr<nsIDOMElement> columnElm;
  mColumn->GetElement(getter_AddRefs(columnElm));
  if (!columnElm)
    return false;

  nsCOMPtr<nsIContent> columnContent(do_QueryInterface(columnElm));
  if (!columnContent->AttrValueIs(kNameSpaceID_None,
                                  nsGkAtoms::editable,
                                  nsGkAtoms::_true,
                                  eCaseMatters))
    return false;

  return mContent->AttrValueIs(kNameSpaceID_None,
                               nsGkAtoms::editable,
                               nsGkAtoms::_true, eCaseMatters);
}
