/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:expandtab:shiftwidth=2:tabstop=2:
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ia2AccessibleTableCell.h"

#include "AccessibleTable2_i.c"
#include "AccessibleTableCell_i.c"

#include "AccessibleWrap.h"
#include "TableAccessible.h"
#include "TableCellAccessible.h"
#include "IUnknownImpl.h"

#include "nsCOMPtr.h"
#include "nsString.h"

using namespace mozilla::a11y;

// IUnknown

STDMETHODIMP
ia2AccessibleTableCell::QueryInterface(REFIID iid, void** ppv) {
  if (!ppv) return E_INVALIDARG;

  *ppv = nullptr;

  if (IID_IAccessibleTableCell == iid) {
    *ppv = static_cast<IAccessibleTableCell*>(this);
    (reinterpret_cast<IUnknown*>(*ppv))->AddRef();
    return S_OK;
  }

  return E_NOINTERFACE;
}

////////////////////////////////////////////////////////////////////////////////
// IAccessibleTableCell

STDMETHODIMP
ia2AccessibleTableCell::get_table(IUnknown** aTable) {
  if (!aTable) return E_INVALIDARG;

  *aTable = nullptr;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  TableAccessible* table = mTableCell->Table();
  if (!table) return E_FAIL;

  AccessibleWrap* wrap = static_cast<AccessibleWrap*>(table->AsAccessible());
  *aTable = static_cast<IAccessible*>(wrap);
  (*aTable)->AddRef();
  return S_OK;
}

STDMETHODIMP
ia2AccessibleTableCell::get_columnExtent(long* aSpan) {
  if (!aSpan) return E_INVALIDARG;

  *aSpan = 0;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  *aSpan = mTableCell->ColExtent();

  return S_OK;
}

STDMETHODIMP
ia2AccessibleTableCell::get_columnHeaderCells(IUnknown*** aCellAccessibles,
                                              long* aNColumnHeaderCells) {
  if (!aCellAccessibles || !aNColumnHeaderCells) return E_INVALIDARG;

  *aCellAccessibles = nullptr;
  *aNColumnHeaderCells = 0;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  AutoTArray<Accessible*, 10> cells;
  mTableCell->ColHeaderCells(&cells);

  *aNColumnHeaderCells = cells.Length();
  *aCellAccessibles = static_cast<IUnknown**>(
      ::CoTaskMemAlloc(sizeof(IUnknown*) * cells.Length()));

  if (!*aCellAccessibles) return E_OUTOFMEMORY;

  for (uint32_t i = 0; i < cells.Length(); i++) {
    AccessibleWrap* cell = static_cast<AccessibleWrap*>(cells[i]);
    (*aCellAccessibles)[i] = static_cast<IAccessible*>(cell);
    (*aCellAccessibles)[i]->AddRef();
  }

  return S_OK;
}

STDMETHODIMP
ia2AccessibleTableCell::get_columnIndex(long* aColIdx) {
  if (!aColIdx) return E_INVALIDARG;

  *aColIdx = -1;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  *aColIdx = mTableCell->ColIdx();
  return S_OK;
}

STDMETHODIMP
ia2AccessibleTableCell::get_rowExtent(long* aSpan) {
  if (!aSpan) return E_INVALIDARG;

  *aSpan = 0;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  *aSpan = mTableCell->RowExtent();
  return S_OK;
}

STDMETHODIMP
ia2AccessibleTableCell::get_rowHeaderCells(IUnknown*** aCellAccessibles,
                                           long* aNRowHeaderCells) {
  if (!aCellAccessibles || !aNRowHeaderCells) return E_INVALIDARG;

  *aCellAccessibles = nullptr;
  *aNRowHeaderCells = 0;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  AutoTArray<Accessible*, 10> cells;
  mTableCell->RowHeaderCells(&cells);

  *aNRowHeaderCells = cells.Length();
  *aCellAccessibles = static_cast<IUnknown**>(
      ::CoTaskMemAlloc(sizeof(IUnknown*) * cells.Length()));
  if (!*aCellAccessibles) return E_OUTOFMEMORY;

  for (uint32_t i = 0; i < cells.Length(); i++) {
    AccessibleWrap* cell = static_cast<AccessibleWrap*>(cells[i]);
    (*aCellAccessibles)[i] = static_cast<IAccessible*>(cell);
    (*aCellAccessibles)[i]->AddRef();
  }

  return S_OK;
}

STDMETHODIMP
ia2AccessibleTableCell::get_rowIndex(long* aRowIdx) {
  if (!aRowIdx) return E_INVALIDARG;

  *aRowIdx = -1;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  *aRowIdx = mTableCell->RowIdx();
  return S_OK;
}

STDMETHODIMP
ia2AccessibleTableCell::get_rowColumnExtents(long* aRowIdx, long* aColIdx,
                                             long* aRowExtents,
                                             long* aColExtents,
                                             boolean* aIsSelected) {
  if (!aRowIdx || !aColIdx || !aRowExtents || !aColExtents || !aIsSelected)
    return E_INVALIDARG;

  *aRowIdx = *aColIdx = *aRowExtents = *aColExtents = 0;
  *aIsSelected = false;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  *aRowIdx = mTableCell->RowIdx();
  *aColIdx = mTableCell->ColIdx();
  *aRowExtents = mTableCell->RowExtent();
  *aColExtents = mTableCell->ColExtent();
  *aIsSelected = mTableCell->Selected();

  return S_OK;
}

STDMETHODIMP
ia2AccessibleTableCell::get_isSelected(boolean* aIsSelected) {
  if (!aIsSelected) return E_INVALIDARG;

  *aIsSelected = false;
  if (!mTableCell) return CO_E_OBJNOTCONNECTED;

  *aIsSelected = mTableCell->Selected();
  return S_OK;
}
