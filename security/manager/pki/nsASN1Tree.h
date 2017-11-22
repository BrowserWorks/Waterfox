/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef _NSSASNTREE_H_
#define _NSSASNTREE_H_

#include "nscore.h"
#include "nsIX509Cert.h"
#include "nsIASN1Tree.h"
#include "nsIASN1Object.h"
#include "nsIASN1Sequence.h"
#include "nsITreeView.h"
#include "nsITreeBoxObject.h"
#include "nsITreeSelection.h"
#include "nsCOMPtr.h"

//4bfaa9f0-1dd2-11b2-afae-a82cbaa0b606
#define NS_NSSASN1OUTINER_CID  {             \
   0x4bfaa9f0,                               \
   0x1dd2,                                   \
   0x11b2,                                   \
   {0xaf,0xae,0xa8,0x2c,0xba,0xa0,0xb6,0x06} \
  }


class nsNSSASN1Tree : public nsIASN1Tree
{
public:
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIASN1TREE
  NS_DECL_NSITREEVIEW

  nsNSSASN1Tree();
protected:
  virtual ~nsNSSASN1Tree();

  class myNode
  {
  public:
    nsCOMPtr<nsIASN1Object> obj;
    nsCOMPtr<nsIASN1Sequence> seq;
    myNode *child;
    myNode *next;
    myNode *parent;

    myNode() {
      child = next = parent = nullptr;
    }
  };

  myNode *mTopNode;

  nsCOMPtr<nsIASN1Object> mASN1Object;
  nsCOMPtr<nsITreeSelection> mSelection;
  nsCOMPtr<nsITreeBoxObject> mTree;

  void InitNodes();
  void InitChildsRecursively(myNode *n);

  void ClearNodes();
  void ClearNodesRecursively(myNode *n);

  int32_t CountVisibleNodes(myNode *n);
  myNode *FindNodeFromIndex(myNode *n, int32_t wantedIndex,
                            int32_t &index_counter, int32_t &level_counter,
                            int32_t *optionalOutParentIndex, int32_t *optionalOutLevel);
  myNode *FindNodeFromIndex(int32_t wantedIndex,
                            int32_t *optionalOutParentIndex = nullptr,
                            int32_t *optionalOutLevel = nullptr);

};
#endif //_NSSASNTREE_H_
