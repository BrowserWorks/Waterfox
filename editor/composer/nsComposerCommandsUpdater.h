/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */




#ifndef nsComposerCommandsUpdater_h__
#define nsComposerCommandsUpdater_h__

#include "nsCOMPtr.h"                   // for already_AddRefed, nsCOMPtr
#include "nsIDocumentStateListener.h"
#include "nsINamed.h"
#include "nsISelectionListener.h"
#include "nsISupportsImpl.h"            // for NS_DECL_ISUPPORTS
#include "nsITimer.h"                   // for NS_DECL_NSITIMERCALLBACK, etc
#include "nsITransactionListener.h"     // for nsITransactionListener
#include "nsIWeakReferenceUtils.h"      // for nsWeakPtr
#include "nscore.h"                     // for NS_IMETHOD, nsresult, etc

class nsPIDOMWindowOuter;
class nsITransaction;
class nsITransactionManager;
class nsPICommandUpdater;

class nsComposerCommandsUpdater : public nsISelectionListener,
                                  public nsIDocumentStateListener,
                                  public nsITransactionListener,
                                  public nsITimerCallback,
                                  public nsINamed
{
public:

                                  nsComposerCommandsUpdater();

  // nsISupports
  NS_DECL_ISUPPORTS

  // nsISelectionListener
  NS_DECL_NSISELECTIONLISTENER

  // nsIDocumentStateListener
  NS_DECL_NSIDOCUMENTSTATELISTENER

  // nsITimerCallback interfaces
  NS_DECL_NSITIMERCALLBACK

  // nsINamed
  NS_DECL_NSINAMED

  /** nsITransactionListener interfaces
    */
  NS_IMETHOD WillDo(nsITransactionManager *aManager, nsITransaction *aTransaction, bool *aInterrupt) override;
  NS_IMETHOD DidDo(nsITransactionManager *aManager, nsITransaction *aTransaction, nsresult aDoResult) override;
  NS_IMETHOD WillUndo(nsITransactionManager *aManager, nsITransaction *aTransaction, bool *aInterrupt) override;
  NS_IMETHOD DidUndo(nsITransactionManager *aManager, nsITransaction *aTransaction, nsresult aUndoResult) override;
  NS_IMETHOD WillRedo(nsITransactionManager *aManager, nsITransaction *aTransaction, bool *aInterrupt) override;
  NS_IMETHOD DidRedo(nsITransactionManager *aManager, nsITransaction *aTransaction, nsresult aRedoResult) override;
  NS_IMETHOD WillBeginBatch(nsITransactionManager *aManager, bool *aInterrupt) override;
  NS_IMETHOD DidBeginBatch(nsITransactionManager *aManager, nsresult aResult) override;
  NS_IMETHOD WillEndBatch(nsITransactionManager *aManager, bool *aInterrupt) override;
  NS_IMETHOD DidEndBatch(nsITransactionManager *aManager, nsresult aResult) override;
  NS_IMETHOD WillMerge(nsITransactionManager *aManager, nsITransaction *aTopTransaction,
                       nsITransaction *aTransactionToMerge, bool *aInterrupt) override;
  NS_IMETHOD DidMerge(nsITransactionManager *aManager, nsITransaction *aTopTransaction,
                      nsITransaction *aTransactionToMerge,
                      bool aDidMerge, nsresult aMergeResult) override;


  nsresult   Init(nsPIDOMWindowOuter* aDOMWindow);

protected:

  virtual ~nsComposerCommandsUpdater();

  enum {
    eStateUninitialized   = -1,
    eStateOff             = false,
    eStateOn              = true
  };

  bool          SelectionIsCollapsed();
  nsresult      UpdateDirtyState(bool aNowDirty);
  nsresult      UpdateOneCommand(const char* aCommand);
  nsresult      UpdateCommandGroup(const nsAString& aCommandGroup);

  already_AddRefed<nsPICommandUpdater> GetCommandUpdater();

  nsresult      PrimeUpdateTimer();
  void          TimerCallback();
  nsCOMPtr<nsITimer>  mUpdateTimer;

  nsWeakPtr     mDOMWindow;
  nsWeakPtr     mDocShell;
  int8_t        mDirtyState;
  int8_t        mSelectionCollapsed;
  bool          mFirstDoOfFirstUndo;


};

extern "C" nsresult NS_NewComposerCommandsUpdater(nsISelectionListener** aInstancePtrResult);


#endif // nsComposerCommandsUpdater_h__
