/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsTreeContentView_h__
#define nsTreeContentView_h__

#include "nsCycleCollectionParticipant.h"
#include "nsTArray.h"
#include "nsStubDocumentObserver.h"
#include "nsITreeBoxObject.h"
#include "nsITreeView.h"
#include "nsITreeContentView.h"
#include "nsITreeSelection.h"
#include "mozilla/Attributes.h"
#include "mozilla/UniquePtr.h"

class nsIDocument;
class nsSelection;
class nsTreeColumn;
class Row;

namespace mozilla {
namespace dom {
class DataTransfer;
class TreeBoxObject;
} // namespace dom
} // namespace mozilla

nsresult NS_NewTreeContentView(nsITreeView** aResult);

class nsTreeContentView final : public nsINativeTreeView,
                                public nsITreeContentView,
                                public nsStubDocumentObserver,
                                public nsWrapperCache
{
  public:
    nsTreeContentView(void);

    NS_DECL_CYCLE_COLLECTING_ISUPPORTS
    NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS_AMBIGUOUS(nsTreeContentView,
                                                           nsINativeTreeView)

    virtual JSObject* WrapObject(JSContext* aCx,
                                 JS::Handle<JSObject*> aGivenProto) override;
    nsISupports* GetParentObject();

    int32_t RowCount()
    {
        return mRows.Length();
    }
    nsITreeSelection* GetSelection()
    {
        return mSelection;
    }
    void SetSelection(nsITreeSelection* aSelection,
                      mozilla::ErrorResult& aError);
    void GetRowProperties(int32_t aRow, nsAString& aProperties,
                          mozilla::ErrorResult& aError);
    void GetCellProperties(int32_t aRow, nsTreeColumn& aColumn,
                           nsAString& aProperies, mozilla::ErrorResult& aError);
    void GetColumnProperties(nsTreeColumn& aColumn, nsAString& aProperies);
    bool IsContainer(int32_t aRow, mozilla::ErrorResult& aError);
    bool IsContainerOpen(int32_t aRow, mozilla::ErrorResult& aError);
    bool IsContainerEmpty(int32_t aRow, mozilla::ErrorResult& aError);
    bool IsSeparator(int32_t aRow, mozilla::ErrorResult& aError);
    bool IsSorted()
    {
        return false;
    }
    bool CanDrop(int32_t aRow, int32_t aOrientation,
                 mozilla::dom::DataTransfer* aDataTransfer,
                 mozilla::ErrorResult& aError);
    void Drop(int32_t aRow, int32_t aOrientation,
              mozilla::dom::DataTransfer* aDataTransfer,
              mozilla::ErrorResult& aError);
    int32_t GetParentIndex(int32_t aRow, mozilla::ErrorResult& aError);
    bool HasNextSibling(int32_t aRow, int32_t aAfterIndex,
                        mozilla::ErrorResult& aError);
    int32_t GetLevel(int32_t aRow, mozilla::ErrorResult& aError);
    void GetImageSrc(int32_t aRow, nsTreeColumn& aColumn, nsAString& aSrc,
                     mozilla::ErrorResult& aError);
    int32_t GetProgressMode(int32_t aRow, nsTreeColumn& aColumn,
                            mozilla::ErrorResult& aError);
    void GetCellValue(int32_t aRow, nsTreeColumn& aColumn, nsAString& aValue,
                      mozilla::ErrorResult& aError);
    void GetCellText(int32_t aRow, nsTreeColumn& aColumn, nsAString& aText,
                     mozilla::ErrorResult& aError);
    void SetTree(mozilla::dom::TreeBoxObject* aTree,
                 mozilla::ErrorResult& aError);
    void ToggleOpenState(int32_t aRow, mozilla::ErrorResult& aError);
    void CycleHeader(nsTreeColumn& aColumn, mozilla::ErrorResult& aError);
    // XPCOM SelectionChanged() is OK
    void CycleCell(int32_t aRow, nsTreeColumn& aColumn)
    {
    }
    bool IsEditable(int32_t aRow, nsTreeColumn& aColumn,
                    mozilla::ErrorResult& aError);
    bool IsSelectable(int32_t aRow, nsTreeColumn& aColumn,
                      mozilla::ErrorResult& aError);
    void SetCellValue(int32_t aRow, nsTreeColumn& aColumn,
                      const nsAString& aValue, mozilla::ErrorResult& aError);
    void SetCellText(int32_t aRow, nsTreeColumn& aColumn,
                      const nsAString& aText, mozilla::ErrorResult& aError);
    void PerformAction(const nsAString& aAction)
    {
    }
    void PerformActionOnRow(const nsAString& aAction, int32_t aRow)
    {
    }
    void PerformActionOnCell(const nsAString& aAction, int32_t aRow,
                             nsTreeColumn& aColumn)
    {
    }
    mozilla::dom::Element* GetItemAtIndex(int32_t aRow,
                                          mozilla::ErrorResult& aError);
    int32_t GetIndexOfItem(mozilla::dom::Element* aItem);

    NS_DECL_NSITREEVIEW
    // nsINativeTreeView: Untrusted code can use us
    NS_IMETHOD EnsureNative() override { return NS_OK; }

    NS_DECL_NSITREECONTENTVIEW

    // nsIDocumentObserver
    NS_DECL_NSIMUTATIONOBSERVER_ATTRIBUTECHANGED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTAPPENDED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTINSERTED
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTREMOVED
    NS_DECL_NSIMUTATIONOBSERVER_NODEWILLBEDESTROYED

    static bool CanTrustTreeSelection(nsISupports* aValue);

  protected:
    ~nsTreeContentView(void);

    // Recursive methods which deal with serializing of nested content.
    void Serialize(nsIContent* aContent, int32_t aParentIndex, int32_t* aIndex,
                   nsTArray<mozilla::UniquePtr<Row>>& aRows);

    void SerializeItem(Element* aContent, int32_t aParentIndex,
                       int32_t* aIndex, nsTArray<mozilla::UniquePtr<Row>>& aRows);

    void SerializeSeparator(Element* aContent, int32_t aParentIndex,
                            int32_t* aIndex, nsTArray<mozilla::UniquePtr<Row>>& aRows);

    void GetIndexInSubtree(nsIContent* aContainer, nsIContent* aContent, int32_t* aResult);

    // Helper methods which we use to manage our plain array of rows.
    int32_t EnsureSubtree(int32_t aIndex);

    int32_t RemoveSubtree(int32_t aIndex);

    int32_t InsertRow(int32_t aParentIndex, int32_t aIndex, nsIContent* aContent);

    void InsertRowFor(nsIContent* aParent, nsIContent* aChild);

    int32_t RemoveRow(int32_t aIndex);

    void ClearRows();

    void OpenContainer(int32_t aIndex);

    void CloseContainer(int32_t aIndex);

    int32_t FindContent(nsIContent* aContent);

    void UpdateSubtreeSizes(int32_t aIndex, int32_t aCount);

    void UpdateParentIndexes(int32_t aIndex, int32_t aSkip, int32_t aCount);

    // Content helpers.
    nsIContent* GetCell(nsIContent* aContainer, nsTreeColumn& aCol);

  private:
    bool IsValidRowIndex(int32_t aRowIndex);

    nsCOMPtr<nsITreeBoxObject>          mBoxObject;
    nsCOMPtr<nsITreeSelection>          mSelection;
    nsCOMPtr<nsIContent>                mRoot;
    nsCOMPtr<nsIContent>                mBody;
    nsIDocument*                        mDocument;      // WEAK
    nsTArray<mozilla::UniquePtr<Row>>   mRows;
};

#endif // nsTreeContentView_h__
