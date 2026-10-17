/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_TextInputListener_h
#define mozilla_TextInputListener_h

#include "mozilla/WeakPtr.h"
#include "nsCycleCollectionParticipant.h"
#include "nsIDOMEventListener.h"
#include "nsStringFwd.h"
#include "nsWeakReference.h"

class nsIFrame;
class nsTextControlFrame;

namespace mozilla {
class TextControlElement;
class TextControlState;
class TextEditor;

namespace dom {
class Selection;
}  // namespace dom

class TextInputListener final : public nsIDOMEventListener,
                                public nsSupportsWeakReference {
 public:
  explicit TextInputListener(TextControlElement*);

  void SettingValue(bool aValue) { mSettingValue = aValue; }
  void SetValueChanged(bool aSetValueChanged) {
    mSetValueChanged = aSetValueChanged;
  }

  void HandleValueChanged(TextEditor&);

  /**
   * OnEditActionHandled() is called when the editor handles each edit action.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult OnEditActionHandled(TextEditor&);

  /**
   * OnSelectionChange() is called when selection is changed in the editor.
   */
  MOZ_CAN_RUN_SCRIPT
  void OnSelectionChange(dom::Selection& aSelection, int16_t aReason);

  /**
   * Start to listen or end listening to selection change in the editor.
   */
  void StartToListenToSelectionChange() { mListeningToSelectionChange = true; }
  void EndListeningToSelectionChange() { mListeningToSelectionChange = false; }

  void StartToHandleShortcutKeys();
  void EndHandlingShortcutKeys();

  NS_DECL_CYCLE_COLLECTING_ISUPPORTS_FINAL
  NS_DECL_CYCLE_COLLECTION_CLASS_AMBIGUOUS(TextInputListener,
                                           nsIDOMEventListener)
  NS_DECL_NSIDOMEVENTLISTENER

 protected:
  virtual ~TextInputListener() = default;

  MOZ_CAN_RUN_SCRIPT nsresult
  UpdateTextInputCommands(const nsAString& aCommandsToUpdate);

 protected:
  TextControlElement* const mTxtCtrlElement;
  WeakPtr<TextControlState> const mTextControlState;

  bool mSelectionWasCollapsed : 1 = true;

  /**
   * Whether we had undo items or not the last time we got EditAction()
   * notification (when this state changes we update undo and redo menus)
   */
  bool mHadUndoItems : 1 = false;
  /**
   * Whether we had redo items or not the last time we got EditAction()
   * notification (when this state changes we update undo and redo menus)
   */
  bool mHadRedoItems : 1 = false;
  /**
   * Whether we're in the process of a SetValue call, and should therefore
   * refrain from calling OnValueChanged.
   */
  bool mSettingValue : 1 = false;
  /**
   * Whether we are in the process of a SetValue call that doesn't want
   * |SetValueChanged| to be called.
   */
  bool mSetValueChanged : 1 = true;
  /**
   * Whether we're listening to selection change in the editor.
   */
  bool mListeningToSelectionChange : 1 = false;
  /**
   * Whether we're listening to keyboard events of the text control element.
   */
  bool mListeningToKeyboardEvents : 1 = false;
};

}  // namespace mozilla

#endif  // #ifndef mozilla_TextInputListener_h
