/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef JoinNodeTransaction_h
#define JoinNodeTransaction_h

#include "mozilla/EditTransactionBase.h" // for EditTransactionBase, etc.
#include "nsCOMPtr.h"                   // for nsCOMPtr
#include "nsCycleCollectionParticipant.h"
#include "nsID.h"                       // for REFNSIID
#include "nscore.h"                     // for NS_IMETHOD

class nsINode;

namespace mozilla {

class EditorBase;

/**
 * A transaction that joins two nodes E1 (left node) and E2 (right node) into a
 * single node E.  The children of E are the children of E1 followed by the
 * children of E2.  After DoTransaction() and RedoTransaction(), E1 is removed
 * from the content tree and E2 remains.
 */
class JoinNodeTransaction final : public EditTransactionBase
{
public:
  /**
   * @param aEditorBase     The provider of core editing operations.
   * @param aLeftNode       The first of two nodes to join.
   * @param aRightNode      The second of two nodes to join.
   */
  JoinNodeTransaction(EditorBase& aEditorBase,
                      nsINode& aLeftNode, nsINode& aRightNode);

  /**
   * CanDoIt() returns true if there are enough members and can join or
   * restore the nodes.  Otherwise, false.
   */
  bool CanDoIt() const;

  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(JoinNodeTransaction,
                                           EditTransactionBase)
  NS_IMETHOD QueryInterface(REFNSIID aIID, void** aInstancePtr) override;

  NS_DECL_EDITTRANSACTIONBASE

protected:
  RefPtr<EditorBase> mEditorBase;

  // The nodes to operate upon.  After the merge, mRightNode remains and
  // mLeftNode is removed from the content tree.
  nsCOMPtr<nsINode> mLeftNode;
  nsCOMPtr<nsINode> mRightNode;

  // The offset into mNode where the children of mElement are split (for
  // undo). mOffset is the index of the first child in the right node.  -1
  // means the left node had no children.
  uint32_t  mOffset;

  // The parent node containing mLeftNode and mRightNode.
  nsCOMPtr<nsINode> mParent;
};

} // namespace mozilla

#endif // #ifndef JoinNodeTransaction_h
