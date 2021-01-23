/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_mozInlineSpellChecker_h
#define mozilla_mozInlineSpellChecker_h

#include "nsCycleCollectionParticipant.h"
#include "nsIDOMEventListener.h"
#include "nsIEditorSpellCheck.h"
#include "nsIInlineSpellChecker.h"
#include "mozInlineSpellWordUtil.h"
#include "nsRange.h"
#include "nsWeakReference.h"

class InitEditorSpellCheckCallback;
class mozInlineSpellChecker;
class mozInlineSpellResume;
class UpdateCurrentDictionaryCallback;

namespace mozilla {
class EditorSpellCheck;
class TextEditor;
enum class EditSubAction : int32_t;

namespace dom {
class Event;
}  // namespace dom
}  // namespace mozilla

class mozInlineSpellStatus {
 public:
  explicit mozInlineSpellStatus(mozInlineSpellChecker* aSpellChecker);

  nsresult InitForEditorChange(mozilla::EditSubAction aEditSubAction,
                               nsINode* aAnchorNode, uint32_t aAnchorOffset,
                               nsINode* aPreviousNode, uint32_t aPreviousOffset,
                               nsINode* aStartNode, uint32_t aStartOffset,
                               nsINode* aEndNode, uint32_t aEndOffset);
  nsresult InitForNavigation(bool aForceCheck, int32_t aNewPositionOffset,
                             nsINode* aOldAnchorNode, uint32_t aOldAnchorOffset,
                             nsINode* aNewAnchorNode, uint32_t aNewAnchorOffset,
                             bool* aContinue);
  nsresult InitForSelection();
  nsresult InitForRange(nsRange* aRange);

  nsresult FinishInitOnEvent(mozInlineSpellWordUtil& aWordUtil);

  // Return true if we plan to spell-check everything
  bool IsFullSpellCheck() const { return mOp == eOpChange && !mRange; }

  RefPtr<mozInlineSpellChecker> mSpellChecker;

  // what happened?
  enum Operation {
    eOpChange,        // for SpellCheckAfterEditorChange except
                      // deleteSelection
    eOpChangeDelete,  // for SpellCheckAfterEditorChange with
                      // deleteSelection
    eOpNavigation,    // for HandleNavigationEvent
    eOpSelection,     // re-check all misspelled words
    eOpResume
  };  // for resuming a previously started check
  Operation mOp;

  // Used for events where we have already computed the range to use. It can
  // also be nullptr in these cases where we need to check the entire range.
  RefPtr<nsRange> mRange;

  // If we happen to know something was inserted, this is that range.
  // Can be nullptr (this only allows an optimization, so not setting doesn't
  // hurt)
  RefPtr<nsRange> mCreatedRange;

  // Contains the range computed for the current word. Can be nullptr.
  RefPtr<nsRange> mNoCheckRange;

  // Indicates the position of the cursor for the event (so we can compute
  // mNoCheckRange). It can be nullptr if we don't care about the cursor
  // position (such as for the intial check of everything).
  //
  // For mOp == eOpNavigation, this is the NEW position of the cursor
  RefPtr<nsRange> mAnchorRange;

  // -----
  // The following members are only for navigation events and are only
  // stored for FinishNavigationEvent to initialize the other members.
  // -----

  // this is the OLD position of the cursor
  RefPtr<nsRange> mOldNavigationAnchorRange;

  // Set when we should force checking the current word. See
  // mozInlineSpellChecker::HandleNavigationEvent for a description of why we
  // have this.
  bool mForceNavigationWordCheck;

  // Contains the offset passed in to HandleNavigationEvent
  int32_t mNewNavigationPositionOffset;

 protected:
  nsresult FinishNavigationEvent(mozInlineSpellWordUtil& aWordUtil);

  nsresult FillNoCheckRangeFromAnchor(mozInlineSpellWordUtil& aWordUtil);

  mozilla::dom::Document* GetDocument() const;
  already_AddRefed<nsRange> PositionToCollapsedRange(nsINode* aNode,
                                                     uint32_t aOffset);
};

class mozInlineSpellChecker final : public nsIInlineSpellChecker,
                                    public nsIDOMEventListener,
                                    public nsSupportsWeakReference {
 private:
  friend class mozInlineSpellStatus;
  friend class InitEditorSpellCheckCallback;
  friend class UpdateCurrentDictionaryCallback;
  friend class AutoChangeNumPendingSpellChecks;
  friend class mozInlineSpellResume;

  // Access with CanEnableInlineSpellChecking
  enum SpellCheckingState {
    SpellCheck_Uninitialized = -1,
    SpellCheck_NotAvailable = 0,
    SpellCheck_Available = 1
  };
  static SpellCheckingState gCanEnableSpellChecking;

  RefPtr<mozilla::TextEditor> mTextEditor;
  RefPtr<mozilla::EditorSpellCheck> mSpellCheck;
  RefPtr<mozilla::EditorSpellCheck> mPendingSpellCheck;

  int32_t mNumWordsInSpellSelection;
  int32_t mMaxNumWordsInSpellSelection;

  // we need to keep track of the current text position in the document
  // so we can spell check the old word when the user clicks around the
  // document.
  nsCOMPtr<nsINode> mCurrentSelectionAnchorNode;
  uint32_t mCurrentSelectionOffset;

  // Tracks the number of pending spell checks *and* async operations that may
  // lead to spell checks, like updating the current dictionary.  This is
  // necessary so that observers can know when to wait for spell check to
  // complete.
  int32_t mNumPendingSpellChecks;

  // The number of calls to UpdateCurrentDictionary that haven't finished yet.
  int32_t mNumPendingUpdateCurrentDictionary;

  // This number is incremented each time the spell checker is disabled so that
  // pending scheduled spell checks and UpdateCurrentDictionary calls can be
  // ignored when they finish.
  uint32_t mDisabledAsyncToken;

  // When mPendingSpellCheck is non-null, this is the callback passed when
  // it was initialized.
  RefPtr<InitEditorSpellCheckCallback> mPendingInitEditorSpellCheckCallback;

  // Set when we have spellchecked after the last edit operation. See the
  // commment at the top of the .cpp file for more info.
  bool mNeedsCheckAfterNavigation;

  // Set when we have a pending mozInlineSpellResume which will check
  // the whole document.
  bool mFullSpellCheckScheduled;

  // Set to true when this instance needs to listen to edit actions of
  // the editor.
  bool mIsListeningToEditSubActions;

 public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_NSIINLINESPELLCHECKER
  NS_DECL_NSIDOMEVENTLISTENER
  NS_DECL_CYCLE_COLLECTION_CLASS_AMBIGUOUS(mozInlineSpellChecker,
                                           nsIDOMEventListener)

  mozilla::EditorSpellCheck* GetEditorSpellCheck();

  // returns true if there are any spell checking dictionaries available
  static bool CanEnableInlineSpellChecking();
  // update the cached value whenever the list of available dictionaries changes
  static void UpdateCanEnableInlineSpellChecking();

  nsresult OnBlur(mozilla::dom::Event* aEvent);
  nsresult OnMouseClick(mozilla::dom::Event* aMouseEvent);
  nsresult OnKeyPress(mozilla::dom::Event* aKeyEvent);

  mozInlineSpellChecker();

  // spell checks all of the words between two nodes
  nsresult SpellCheckBetweenNodes(nsINode* aStartNode, int32_t aStartOffset,
                                  nsINode* aEndNode, int32_t aEndOffset);

  // examines the dom node in question and returns true if the inline spell
  // checker should skip the node (i.e. the text is inside of a block quote
  // or an e-mail signature...)
  bool ShouldSpellCheckNode(mozilla::TextEditor* aTextEditor, nsINode* aNode);

  // spell check the text contained within aRange, potentially scheduling
  // another check in the future if the time threshold is reached
  nsresult ScheduleSpellCheck(
      mozilla::UniquePtr<mozInlineSpellStatus>&& aStatus);

  nsresult DoSpellCheckSelection(mozInlineSpellWordUtil& aWordUtil,
                                 mozilla::dom::Selection* aSpellCheckSelection);
  nsresult DoSpellCheck(mozInlineSpellWordUtil& aWordUtil,
                        mozilla::dom::Selection* aSpellCheckSelection,
                        const mozilla::UniquePtr<mozInlineSpellStatus>& aStatus,
                        bool* aDoneChecking);

  // helper routine to determine if a point is inside of the passed in
  // selection.
  nsresult IsPointInSelection(mozilla::dom::Selection& aSelection,
                              nsINode* aNode, int32_t aOffset,
                              nsRange** aRange);

  nsresult CleanupRangesInSelection(mozilla::dom::Selection* aSelection);

  /**
   * @param aRange needs to be kept alive by the caller.
   */
  // TODO: annotate with `MOZ_CAN_RUN_SCRIPT` instead
  // (https://bugzilla.mozilla.org/show_bug.cgi?id=1620540).
  MOZ_CAN_RUN_SCRIPT_BOUNDARY nsresult
  RemoveRange(mozilla::dom::Selection* aSpellCheckSelection, nsRange* aRange);
  MOZ_CAN_RUN_SCRIPT_BOUNDARY nsresult
  AddRange(mozilla::dom::Selection* aSpellCheckSelection, nsRange* aRange);
  bool SpellCheckSelectionIsFull() {
    return mNumWordsInSpellSelection >= mMaxNumWordsInSpellSelection;
  }

  nsresult MakeSpellCheckRange(nsINode* aStartNode, int32_t aStartOffset,
                               nsINode* aEndNode, int32_t aEndOffset,
                               nsRange** aRange);

  // DOM and editor event registration helper routines
  nsresult RegisterEventListeners();
  nsresult UnregisterEventListeners();
  nsresult HandleNavigationEvent(bool aForceWordSpellCheck,
                                 int32_t aNewPositionOffset = 0);

  already_AddRefed<mozilla::dom::Selection> GetSpellCheckSelection();
  nsresult SaveCurrentSelectionPosition();

  nsresult ResumeCheck(mozilla::UniquePtr<mozInlineSpellStatus>&& aStatus);

  // Those methods are called when mTextEditor splits a node or joins the
  // given nodes.
  void DidSplitNode(nsINode* aExistingRightNode, nsINode* aNewLeftNode);
  void DidJoinNodes(nsINode& aRightNode, nsINode& aLeftNode);

  nsresult SpellCheckAfterEditorChange(mozilla::EditSubAction aEditSubAction,
                                       mozilla::dom::Selection& aSelection,
                                       nsINode* aPreviousSelectedNode,
                                       uint32_t aPreviousSelectedOffset,
                                       nsINode* aStartNode,
                                       uint32_t aStartOffset, nsINode* aEndNode,
                                       uint32_t aEndOffset);

 protected:
  virtual ~mozInlineSpellChecker();

  // called when async nsIEditorSpellCheck methods complete
  nsresult EditorSpellCheckInited();
  nsresult CurrentDictionaryUpdated();

  // track the number of pending spell checks and async operations that may lead
  // to spell checks, notifying observers accordingly
  void ChangeNumPendingSpellChecks(int32_t aDelta,
                                   mozilla::TextEditor* aTextEditor = nullptr);
  void NotifyObservers(const char* aTopic, mozilla::TextEditor* aTextEditor);

  void StartToListenToEditSubActions() { mIsListeningToEditSubActions = true; }
  void EndListeningToEditSubActions() { mIsListeningToEditSubActions = false; }

  void CheckCurrentWordsNoSuggest(mozilla::dom::Selection* aSpellCheckSelection,
                                  nsTArray<nsString>&& aWords,
                                  nsTArray<NodeOffsetRange>&& aRanges);
};

#endif  // #ifndef mozilla_mozInlineSpellChecker_h
