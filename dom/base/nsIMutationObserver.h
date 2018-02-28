/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsIMutationObserver_h
#define nsIMutationObserver_h

#include "nsISupports.h"

class nsAttrValue;
class nsIAtom;
class nsIContent;
class nsIDocument;
class nsINode;

namespace mozilla {
namespace dom {
class Element;
} // namespace dom
} // namespace mozilla

#define NS_IMUTATION_OBSERVER_IID \
{ 0x6d674c17, 0x0fbc, 0x4633, \
  { 0x8f, 0x46, 0x73, 0x4e, 0x87, 0xeb, 0xf0, 0xc7 } }

/**
 * Information details about a characterdata change.  Basically, we
 * view all changes as replacements of a length of text at some offset
 * with some other text (of possibly some other length).
 */
struct CharacterDataChangeInfo
{
  /**
   * True if this character data change is just an append.
   */
  bool mAppend;

  /**
   * The offset in the text where the change occurred.
   */
  uint32_t mChangeStart;

  /**
   * The offset such that mChangeEnd - mChangeStart is equal to the length of
   * the text we removed. If this was a pure insert or append, this is equal to
   * mChangeStart.
   */
  uint32_t mChangeEnd;

  /**
   * The length of the text that was inserted in place of the removed text.  If
   * this was a pure text removal, this is 0.
   */
  uint32_t mReplaceLength;

  /**
   * The net result is that mChangeStart characters at the beginning of the
   * text remained as they were.  The next mChangeEnd - mChangeStart characters
   * were removed, and mReplaceLength characters were inserted in their place.
   * The text that used to begin at mChangeEnd now begins at
   * mChangeStart + mReplaceLength.
   */

  struct MOZ_STACK_CLASS Details {
    enum {
      eMerge,  // two text nodes are merged as a result of normalize()
      eSplit   // a text node is split as a result of splitText()
    } mType;
    /**
     * For eMerge it's the text node that will be removed, for eSplit it's the
     * new text node.
     */
    nsIContent* MOZ_NON_OWNING_REF mNextSibling;
  };

  /**
   * Used for splitText() and normalize(), otherwise null.
   */
  Details* mDetails;
};

/**
 * Mutation observer interface
 *
 * See nsINode::AddMutationObserver, nsINode::RemoveMutationObserver for how to
 * attach or remove your observers.
 *
 * WARNING: During these notifications, you are not allowed to perform
 * any mutations to the current or any other document, or start a
 * network load.  If you need to perform such operations do that
 * during the _last_ nsIDocumentObserver::EndUpdate notification.  The
 * expection for this is ParentChainChanged, where mutations should be
 * done from an async event, as the notification might not be
 * surrounded by BeginUpdate/EndUpdate calls.
 */
class nsIMutationObserver : public nsISupports
{
public:
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_IMUTATION_OBSERVER_IID)

  /**
   * Notification that the node value of a data node (text, cdata, pi, comment)
   * will be changed.
   *
   * This notification is not sent when a piece of content is
   * added/removed from the document (the other notifications are used
   * for that).
   *
   * @param aDocument The owner-document of aContent. Can be null.
   * @param aContent  The piece of content that changed. Is never null.
   * @param aInfo     The structure with information details about the change.
   *
   * @note Callers of this method might not hold a strong reference to the
   *       observer.  The observer is responsible for making sure it stays
   *       alive for the duration of the call as needed.  The observer may
   *       assume that this call will happen when there are script blockers on
   *       the stack.
   */
  virtual void CharacterDataWillChange(nsIDocument *aDocument,
                                       nsIContent* aContent,
                                       CharacterDataChangeInfo* aInfo) = 0;

  /**
   * Notification that the node value of a data node (text, cdata, pi, comment)
   * has changed.
   *
   * This notification is not sent when a piece of content is
   * added/removed from the document (the other notifications are used
   * for that).
   *
   * @param aDocument The owner-document of aContent. Can be null.
   * @param aContent  The piece of content that changed. Is never null.
   * @param aInfo     The structure with information details about the change.
   *
   * @note Callers of this method might not hold a strong reference to the
   *       observer.  The observer is responsible for making sure it stays
   *       alive for the duration of the call as needed.  The observer may
   *       assume that this call will happen when there are script blockers on
   *       the stack.
   */
  virtual void CharacterDataChanged(nsIDocument *aDocument,
                                    nsIContent* aContent,
                                    CharacterDataChangeInfo* aInfo) = 0;

  /**
   * Notification that an attribute of an element will change.  This
   * can happen before the BeginUpdate for the change and may not
   * always be followed by an AttributeChanged (in particular, if the
   * attribute doesn't actually change there will be no corresponding
   * AttributeChanged).
   *
   * @param aDocument    The owner-document of aContent. Can be null.
   * @param aContent     The element whose attribute will change
   * @param aNameSpaceID The namespace id of the changing attribute
   * @param aAttribute   The name of the changing attribute
   * @param aModType     Whether or not the attribute will be added, changed, or
   *                     removed. The constants are defined in
   *                     nsIDOMMutationEvent.h.
   * @param aNewValue    The new value, IF it has been preparsed by
   *                     BeforeSetAttr, otherwise null.
   *
   * @note Callers of this method might not hold a strong reference to the
   *       observer.  The observer is responsible for making sure it stays
   *       alive for the duration of the call as needed.  The observer may
   *       assume that this call will happen when there are script blockers on
   *       the stack.
   */
  virtual void AttributeWillChange(nsIDocument* aDocument,
                                   mozilla::dom::Element* aElement,
                                   int32_t      aNameSpaceID,
                                   nsIAtom*     aAttribute,
                                   int32_t      aModType,
                                   const nsAttrValue* aNewValue) = 0;

  /**
   * Notification that an attribute of an element has changed.
   *
   * @param aDocument    The owner-document of aContent. Can be null.
   * @param aElement     The element whose attribute changed
   * @param aNameSpaceID The namespace id of the changed attribute
   * @param aAttribute   The name of the changed attribute
   * @param aModType     Whether or not the attribute was added, changed, or
   *                     removed. The constants are defined in
   *                     nsIDOMMutationEvent.h.
   * @param aOldValue    The old value, if either the old value or the new
   *                     value are StoresOwnData() (or absent); null otherwise.
   *
   * @note Callers of this method might not hold a strong reference to the
   *       observer.  The observer is responsible for making sure it stays
   *       alive for the duration of the call as needed.  The observer may
   *       assume that this call will happen when there are script blockers on
   *       the stack.
   */
  virtual void AttributeChanged(nsIDocument* aDocument,
                                mozilla::dom::Element* aElement,
                                int32_t      aNameSpaceID,
                                nsIAtom*     aAttribute,
                                int32_t      aModType,
                                const nsAttrValue* aOldValue) = 0;

  /**
   * Notification that the root of a native anonymous has been added
   * or removed.
   *
   * @param aDocument    Owner doc of aContent
   * @param aContent     Anonymous node that's been added or removed
   * @param aIsRemove    True if it's a removal, false if an addition
   */
  virtual void NativeAnonymousChildListChange(nsIDocument* aDocument,
                                              nsIContent* aContent,
                                              bool aIsRemove) {}

  /**
   * Notification that an attribute of an element has been
   * set to the value it already had.
   *
   * @param aDocument    The owner-document of aContent.
   * @param aElement     The element whose attribute changed
   * @param aNameSpaceID The namespace id of the changed attribute
   * @param aAttribute   The name of the changed attribute
   */
  virtual void AttributeSetToCurrentValue(nsIDocument* aDocument,
                                          mozilla::dom::Element* aElement,
                                          int32_t aNameSpaceID,
                                          nsIAtom* aAttribute) {}

  /**
   * Notification that one or more content nodes have been appended to the
   * child list of another node in the tree.
   *
   * @param aDocument  The owner-document of aContent. Can be null.
   * @param aContainer The container that had new children appended. Is never
   *                   null.
   * @param aFirstNewContent the node at aIndexInContainer in aContainer.
   * @param aNewIndexInContainer the index in the container of the first
   *                   new child
   *
   * @note Callers of this method might not hold a strong reference to the
   *       observer.  The observer is responsible for making sure it stays
   *       alive for the duration of the call as needed.  The observer may
   *       assume that this call will happen when there are script blockers on
   *       the stack.
   */
  virtual void ContentAppended(nsIDocument *aDocument,
                               nsIContent* aContainer,
                               nsIContent* aFirstNewContent,
                               int32_t     aNewIndexInContainer) = 0;

  /**
   * Notification that a content node has been inserted as child to another
   * node in the tree.
   *
   * @param aDocument  The owner-document of aContent, or, when aContainer
   *                   is null, the container that had the child inserted.
   *                   Can be null.
   * @param aContainer The container that had new a child inserted. Can be
   *                   null to indicate that the child was inserted into
   *                   aDocument
   * @param aChild     The newly inserted child.
   * @param aIndexInContainer The index in the container of the new child.
   *
   * @note Callers of this method might not hold a strong reference to the
   *       observer.  The observer is responsible for making sure it stays
   *       alive for the duration of the call as needed.  The observer may
   *       assume that this call will happen when there are script blockers on
   *       the stack.
   */
  virtual void ContentInserted(nsIDocument *aDocument,
                               nsIContent* aContainer,
                               nsIContent* aChild,
                               int32_t aIndexInContainer) = 0;

  /**
   * Notification that a content node has been removed from the child list of
   * another node in the tree.
   *
   * @param aDocument  The owner-document of aContent, or, when aContainer
   *                   is null, the container that had the child removed.
   *                   Can be null.
   * @param aContainer The container that had new a child removed. Can be
   *                   null to indicate that the child was removed from
   *                   aDocument.
   * @param aChild     The child that was removed.
   * @param aIndexInContainer The index in the container which the child used
   *                          to have.
   * @param aPreviousSibling The previous sibling to the child that was removed.
   *                         Can be null if there was no previous sibling.
   *
   * @note Callers of this method might not hold a strong reference to the
   *       observer.  The observer is responsible for making sure it stays
   *       alive for the duration of the call as needed.  The observer may
   *       assume that this call will happen when there are script blockers on
   *       the stack.
   */
  virtual void ContentRemoved(nsIDocument *aDocument,
                              nsIContent* aContainer,
                              nsIContent* aChild,
                              int32_t aIndexInContainer,
                              nsIContent* aPreviousSibling) = 0;

 /**
   * The node is in the process of being destroyed. Calling QI on the node is
   * not supported, however it is possible to get children and flags through
   * nsINode as well as calling IsNodeOfType(eCONTENT) and casting to
   * nsIContent to get attributes.
   *
   * NOTE: This notification is only called on observers registered directly
   * on the node. This is because when the node is destroyed it can not have
   * any ancestors. If you want to know when a descendant node is being
   * removed from the observed node, use the ContentRemoved notification.
   *
   * @param aNode The node being destroyed.
   *
   * @note Callers of this method might not hold a strong reference to
   *       the observer.  The observer is responsible for making sure it
   *       stays alive for the duration of the call as needed.
   */
  virtual void NodeWillBeDestroyed(const nsINode *aNode) = 0;

  /**
   * Notification that the node's parent chain has changed. This
   * happens when either the node or one of its ancestors is inserted
   * or removed as a child of another node.
   *
   * Note that when a node is inserted this notification is sent to
   * all descendants of that node, since all such nodes have their
   * parent chain changed.
   *
   * @param aContent  The piece of content that had its parent changed.
   *
   * @note Callers of this method might not hold a strong reference to
   *       the observer.  The observer is responsible for making sure it
   *       stays alive for the duration of the call as needed.
   */

  virtual void ParentChainChanged(nsIContent *aContent) = 0;
};

NS_DEFINE_STATIC_IID_ACCESSOR(nsIMutationObserver, NS_IMUTATION_OBSERVER_IID)

#define NS_DECL_NSIMUTATIONOBSERVER_CHARACTERDATAWILLCHANGE                  \
    virtual void CharacterDataWillChange(nsIDocument* aDocument,             \
                                         nsIContent* aContent,               \
                                         CharacterDataChangeInfo* aInfo) override;

#define NS_DECL_NSIMUTATIONOBSERVER_CHARACTERDATACHANGED                     \
    virtual void CharacterDataChanged(nsIDocument* aDocument,                \
                                      nsIContent* aContent,                  \
                                      CharacterDataChangeInfo* aInfo) override;

#define NS_DECL_NSIMUTATIONOBSERVER_ATTRIBUTEWILLCHANGE                      \
    virtual void AttributeWillChange(nsIDocument* aDocument,                 \
                                     mozilla::dom::Element* aElement,        \
                                     int32_t aNameSpaceID,                   \
                                     nsIAtom* aAttribute,                    \
                                     int32_t aModType,                       \
                                     const nsAttrValue* aNewValue) override;

#define NS_DECL_NSIMUTATIONOBSERVER_NATIVEANONYMOUSCHILDLISTCHANGE           \
    virtual void NativeAnonymousChildListChange(nsIDocument* aDocument,      \
                                                nsIContent* aContent,        \
                                                bool aIsRemove) override;

#define NS_DECL_NSIMUTATIONOBSERVER_ATTRIBUTECHANGED                         \
    virtual void AttributeChanged(nsIDocument* aDocument,                    \
                                  mozilla::dom::Element* aElement,           \
                                  int32_t aNameSpaceID,                      \
                                  nsIAtom* aAttribute,                       \
                                  int32_t aModType,                          \
                                  const nsAttrValue* aOldValue) override;

#define NS_DECL_NSIMUTATIONOBSERVER_CONTENTAPPENDED                          \
    virtual void ContentAppended(nsIDocument* aDocument,                     \
                                 nsIContent* aContainer,                     \
                                 nsIContent* aFirstNewContent,               \
                                 int32_t aNewIndexInContainer) override;

#define NS_DECL_NSIMUTATIONOBSERVER_CONTENTINSERTED                          \
    virtual void ContentInserted(nsIDocument* aDocument,                     \
                                 nsIContent* aContainer,                     \
                                 nsIContent* aChild,                         \
                                 int32_t aIndexInContainer) override;

#define NS_DECL_NSIMUTATIONOBSERVER_CONTENTREMOVED                           \
    virtual void ContentRemoved(nsIDocument* aDocument,                      \
                                nsIContent* aContainer,                      \
                                nsIContent* aChild,                          \
                                int32_t aIndexInContainer,                   \
                                nsIContent* aPreviousSibling) override;

#define NS_DECL_NSIMUTATIONOBSERVER_NODEWILLBEDESTROYED                      \
    virtual void NodeWillBeDestroyed(const nsINode* aNode) override;

#define NS_DECL_NSIMUTATIONOBSERVER_PARENTCHAINCHANGED                       \
    virtual void ParentChainChanged(nsIContent *aContent) override;

#define NS_DECL_NSIMUTATIONOBSERVER                                          \
    NS_DECL_NSIMUTATIONOBSERVER_CHARACTERDATAWILLCHANGE                      \
    NS_DECL_NSIMUTATIONOBSERVER_CHARACTERDATACHANGED                         \
    NS_DECL_NSIMUTATIONOBSERVER_ATTRIBUTEWILLCHANGE                          \
    NS_DECL_NSIMUTATIONOBSERVER_NATIVEANONYMOUSCHILDLISTCHANGE               \
    NS_DECL_NSIMUTATIONOBSERVER_ATTRIBUTECHANGED                             \
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTAPPENDED                              \
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTINSERTED                              \
    NS_DECL_NSIMUTATIONOBSERVER_CONTENTREMOVED                               \
    NS_DECL_NSIMUTATIONOBSERVER_NODEWILLBEDESTROYED                          \
    NS_DECL_NSIMUTATIONOBSERVER_PARENTCHAINCHANGED

#define NS_IMPL_NSIMUTATIONOBSERVER_CORE_STUB(_class)                     \
void                                                                      \
_class::NodeWillBeDestroyed(const nsINode* aNode)                               \
{                                                                         \
}

#define NS_IMPL_NSIMUTATIONOBSERVER_CONTENT(_class)                       \
void                                                                      \
_class::CharacterDataWillChange(nsIDocument* aDocument,                   \
                                nsIContent* aContent,                     \
                                CharacterDataChangeInfo* aInfo)           \
{                                                                         \
}                                                                         \
void                                                                      \
_class::CharacterDataChanged(nsIDocument* aDocument,                      \
                             nsIContent* aContent,                        \
                             CharacterDataChangeInfo* aInfo)              \
{                                                                         \
}                                                                         \
void                                                                      \
_class::AttributeWillChange(nsIDocument* aDocument,                       \
                            mozilla::dom::Element* aElement,              \
                            int32_t aNameSpaceID,                         \
                            nsIAtom* aAttribute,                          \
                            int32_t aModType,                             \
                            const nsAttrValue* aNewValue)                 \
{                                                                         \
}                                                                         \
void                                                                      \
_class::NativeAnonymousChildListChange(nsIDocument* aDocument,            \
                                       nsIContent* aContent,              \
                                       bool aIsRemove)                    \
{                                                                         \
}                                                                         \
void                                                                      \
_class::AttributeChanged(nsIDocument* aDocument,                          \
                         mozilla::dom::Element* aElement,                 \
                         int32_t aNameSpaceID,                            \
                         nsIAtom* aAttribute,                             \
                         int32_t aModType,                                \
                         const nsAttrValue* aOldValue)                    \
{                                                                         \
}                                                                         \
void                                                                      \
_class::ContentAppended(nsIDocument* aDocument,                           \
                        nsIContent* aContainer,                           \
                        nsIContent* aFirstNewContent,                     \
                        int32_t aNewIndexInContainer)                     \
{                                                                         \
}                                                                         \
void                                                                      \
_class::ContentInserted(nsIDocument* aDocument,                           \
                        nsIContent* aContainer,                           \
                        nsIContent* aChild,                               \
                        int32_t aIndexInContainer)                        \
{                                                                         \
}                                                                         \
void                                                                      \
_class::ContentRemoved(nsIDocument* aDocument,                            \
                       nsIContent* aContainer,                            \
                       nsIContent* aChild,                                \
                       int32_t aIndexInContainer,                         \
                       nsIContent* aPreviousSibling)                      \
{                                                                         \
}                                                                         \
void                                                                      \
_class::ParentChainChanged(nsIContent *aContent)                          \
{                                                                         \
}


#endif /* nsIMutationObserver_h */
