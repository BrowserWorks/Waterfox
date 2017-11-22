/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsXBLWindowKeyHandler_h__
#define nsXBLWindowKeyHandler_h__

#include "mozilla/EventForwards.h"
#include "mozilla/layers/KeyboardMap.h"
#include "nsWeakPtr.h"
#include "nsIDOMEventListener.h"

class nsIAtom;
class nsIDOMElement;
class nsIDOMKeyEvent;
class nsXBLPrototypeHandler;

namespace mozilla {
class EventListenerManager;
struct IgnoreModifierState;
namespace dom {
class Element;
class EventTarget;
} // namespace dom
} // namespace mozilla

class nsXBLWindowKeyHandler : public nsIDOMEventListener
{
  typedef mozilla::EventListenerManager EventListenerManager;
  typedef mozilla::IgnoreModifierState IgnoreModifierState;
  typedef mozilla::layers::KeyboardMap KeyboardMap;

public:
  nsXBLWindowKeyHandler(nsIDOMElement* aElement, mozilla::dom::EventTarget* aTarget);

  void InstallKeyboardEventListenersTo(
         EventListenerManager* aEventListenerManager);
  void RemoveKeyboardEventListenersFrom(
         EventListenerManager* aEventListenerManager);

  static KeyboardMap CollectKeyboardShortcuts();

  NS_DECL_ISUPPORTS
  NS_DECL_NSIDOMEVENTLISTENER

protected:
  virtual ~nsXBLWindowKeyHandler();

  nsresult WalkHandlers(nsIDOMKeyEvent* aKeyEvent, nsIAtom* aEventType);

  // walk the handlers, looking for one to handle the event
  bool WalkHandlersInternal(nsIDOMKeyEvent* aKeyEvent,
                            nsIAtom* aEventType,
                            nsXBLPrototypeHandler* aHandler,
                            bool aExecute,
                            bool* aOutReservedForChrome = nullptr);

  // walk the handlers for aEvent, aCharCode and aIgnoreModifierState. Execute
  // it if aExecute = true.
  bool WalkHandlersAndExecute(nsIDOMKeyEvent* aKeyEvent, nsIAtom* aEventType,
                              nsXBLPrototypeHandler* aHandler,
                              uint32_t aCharCode,
                              const IgnoreModifierState& aIgnoreModifierState,
                              bool aExecute,
                              bool* aOutReservedForChrome = nullptr);

  // HandleEvent function for the capturing phase in the default event group.
  void HandleEventOnCaptureInDefaultEventGroup(nsIDOMKeyEvent* aEvent);
  // HandleEvent function for the capturing phase in the system event group.
  void HandleEventOnCaptureInSystemEventGroup(nsIDOMKeyEvent* aEvent);

  // Check if any handler would handle the given event. Optionally returns
  // whether the command handler for the event is marked with the "reserved"
  // attribute.
  bool HasHandlerForEvent(nsIDOMKeyEvent* aEvent,
                          bool* aOutReservedForChrome = nullptr);

  // Returns event type for matching between aWidgetKeyboardEvent and
  // shortcut key handlers.  This is used for calling WalkHandlers(),
  // WalkHandlersInternal() and WalkHandlersAndExecute().
  nsIAtom* ConvertEventToDOMEventType(
             const mozilla::WidgetKeyboardEvent& aWidgetKeyboardEvent) const;

  // lazily load the special doc info for loading handlers
  static void EnsureSpecialDocInfo();

  // lazily load the handlers. Overridden to handle being attached
  // to a particular element rather than the document
  nsresult EnsureHandlers();

  // Is an HTML editable element focused
  bool IsHTMLEditableFieldFocused();

  // Returns the element which was passed as a parameter to the constructor,
  // unless the element has been removed from the document. Optionally returns
  // whether the disabled attribute is set on the element (assuming the element
  // is non-null).
  already_AddRefed<mozilla::dom::Element> GetElement(bool* aIsDisabled = nullptr);

  /**
   * GetElementForHandler() retrieves an element for the handler.  The element
   * may be a command element or a key element.
   *
   * @param aHandler           The handler.
   * @param aElementForHandler Must not be nullptr.  The element is returned to
   *                           this.
   * @return                   true if the handler is valid.  Otherwise, false.
   */
  bool GetElementForHandler(nsXBLPrototypeHandler* aHandler,
                            mozilla::dom::Element** aElementForHandler);

  /**
   * IsExecutableElement() returns true if aElement is executable.
   * Otherwise, false. aElement should be a command element or a key element.
   */
  bool IsExecutableElement(mozilla::dom::Element* aElement) const;

  // Using weak pointer to the DOM Element.
  nsWeakPtr              mWeakPtrForElement;
  mozilla::dom::EventTarget* mTarget; // weak ref

  // these are not owning references; the prototype handlers are owned
  // by the prototype bindings which are owned by the docinfo.
  nsXBLPrototypeHandler* mHandler;     // platform bindings
  nsXBLPrototypeHandler* mUserHandler; // user-specific bindings

  // holds reference count to document info about bindings
  static uint32_t sRefCnt;
};

already_AddRefed<nsXBLWindowKeyHandler>
NS_NewXBLWindowKeyHandler(nsIDOMElement* aElement,
                          mozilla::dom::EventTarget* aTarget);

#endif
