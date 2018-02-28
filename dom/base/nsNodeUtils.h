/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsNodeUtils_h___
#define nsNodeUtils_h___

#include "mozilla/Maybe.h"
#include "nsIContent.h"          // for use in inline function (ParentChainChanged)
#include "nsIMutationObserver.h" // for use in inline function (ParentChainChanged)
#include "js/TypeDecls.h"
#include "nsCOMArray.h"

struct CharacterDataChangeInfo;
template<class E> class nsCOMArray;
class nsCycleCollectionTraversalCallback;
namespace mozilla {
struct NonOwningAnimationTarget;
namespace dom {
class Animation;
} // namespace dom
} // namespace mozilla

class nsNodeUtils
{
public:
  /**
   * Send CharacterDataWillChange notifications to nsIMutationObservers.
   * @param aContent  Node whose data changed
   * @param aInfo     Struct with information details about the change
   * @see nsIMutationObserver::CharacterDataWillChange
   */
  static void CharacterDataWillChange(nsIContent* aContent,
                                      CharacterDataChangeInfo* aInfo);

  /**
   * Send CharacterDataChanged notifications to nsIMutationObservers.
   * @param aContent  Node whose data changed
   * @param aInfo     Struct with information details about the change
   * @see nsIMutationObserver::CharacterDataChanged
   */
  static void CharacterDataChanged(nsIContent* aContent,
                                   CharacterDataChangeInfo* aInfo);

  /**
   * Send AttributeWillChange notifications to nsIMutationObservers.
   * @param aElement      Element whose data will change
   * @param aNameSpaceID  Namespace of changing attribute
   * @param aAttribute    Local-name of changing attribute
   * @param aModType      Type of change (add/change/removal)
   * @param aNewValue     The parsed new value, but only if BeforeSetAttr
   *                      preparsed it!!!
   * @see nsIMutationObserver::AttributeWillChange
   */
  static void AttributeWillChange(mozilla::dom::Element* aElement,
                                  int32_t aNameSpaceID,
                                  nsIAtom* aAttribute,
                                  int32_t aModType,
                                  const nsAttrValue* aNewValue);

  /**
   * Send AttributeChanged notifications to nsIMutationObservers.
   * @param aElement      Element whose data changed
   * @param aNameSpaceID  Namespace of changed attribute
   * @param aAttribute    Local-name of changed attribute
   * @param aModType      Type of change (add/change/removal)
   * @param aOldValue     If the old value was StoresOwnData() (or absent),
   *                      that value, otherwise null
   * @see nsIMutationObserver::AttributeChanged
   */
  static void AttributeChanged(mozilla::dom::Element* aElement,
                               int32_t aNameSpaceID,
                               nsIAtom* aAttribute,
                               int32_t aModType,
                               const nsAttrValue* aOldValue);

  /**
   * Send AttributeSetToCurrentValue notifications to nsIMutationObservers.
   * @param aElement      Element whose data changed
   * @param aNameSpaceID  Namespace of the attribute
   * @param aAttribute    Local-name of the attribute
   * @see nsIMutationObserver::AttributeSetToCurrentValue
   */
  static void AttributeSetToCurrentValue(mozilla::dom::Element* aElement,
                                         int32_t aNameSpaceID,
                                         nsIAtom* aAttribute);

  /**
   * Send ContentAppended notifications to nsIMutationObservers
   * @param aContainer           Node into which new child/children were added
   * @param aFirstNewContent     First new child
   * @param aNewIndexInContainer Index of first new child
   * @see nsIMutationObserver::ContentAppended
   */
  static void ContentAppended(nsIContent* aContainer,
                              nsIContent* aFirstNewContent,
                              int32_t aNewIndexInContainer);

  /**
   * Send NativeAnonymousChildList notifications to nsIMutationObservers
   * @param aContent             Anonymous node that's been added or removed
   * @param aIsRemove            True if it's a removal, false if an addition
   * @see nsIMutationObserver::NativeAnonymousChildListChange
   */
  static void NativeAnonymousChildListChange(nsIContent* aContent,
                                             bool aIsRemove);

  /**
   * Send ContentInserted notifications to nsIMutationObservers
   * @param aContainer        Node into which new child was inserted
   * @param aChild            Newly inserted child
   * @param aIndexInContainer Index of new child
   * @see nsIMutationObserver::ContentInserted
   */
  static void ContentInserted(nsINode* aContainer,
                              nsIContent* aChild,
                              int32_t aIndexInContainer);
  /**
   * Send ContentRemoved notifications to nsIMutationObservers
   * @param aContainer        Node from which child was removed
   * @param aChild            Removed child
   * @param aIndexInContainer Index of removed child
   * @see nsIMutationObserver::ContentRemoved
   */
  static void ContentRemoved(nsINode* aContainer,
                             nsIContent* aChild,
                             int32_t aIndexInContainer,
                             nsIContent* aPreviousSibling);
  /**
   * Send ParentChainChanged notifications to nsIMutationObservers
   * @param aContent  The piece of content that had its parent changed.
   * @see nsIMutationObserver::ParentChainChanged
   */
  static inline void ParentChainChanged(nsIContent *aContent)
  {
    nsINode::nsSlots* slots = aContent->GetExistingSlots();
    if (slots && !slots->mMutationObservers.IsEmpty()) {
      NS_OBSERVER_AUTO_ARRAY_NOTIFY_OBSERVERS(slots->mMutationObservers,
                                              nsIMutationObserver, 1,
                                              ParentChainChanged,
                                              (aContent));
    }
  }

  /**
   * Utility function to get the target (pseudo-)element associated with an
   * animation.
   * @param aAnimation The animation whose target is what we want.
   */
  static mozilla::Maybe<mozilla::NonOwningAnimationTarget>
    GetTargetForAnimation(const mozilla::dom::Animation* aAnimation);

  /**
   * Notify that an animation is added/changed/removed.
   * @param aAnimation The animation we added/changed/removed.
   */
  static void AnimationAdded(mozilla::dom::Animation* aAnimation);
  static void AnimationChanged(mozilla::dom::Animation* aAnimation);
  static void AnimationRemoved(mozilla::dom::Animation* aAnimation);

  /**
   * To be called when reference count of aNode drops to zero.
   * @param aNode The node which is going to be deleted.
   */
  static void LastRelease(nsINode* aNode);

  /**
   * Clones aNode, its attributes and, if aDeep is true, its descendant nodes
   * If aNewNodeInfoManager is not null, it is used to create new nodeinfos for
   * the clones. aNodesWithProperties will be filled with all the nodes that
   * have properties, and every node in it will be followed by its clone.
   *
   * @param aNode Node to clone.
   * @param aDeep If true the function will be called recursively on
   *              descendants of the node
   * @param aNewNodeInfoManager The nodeinfo manager to use to create new
   *                            nodeinfos for aNode and its attributes and
   *                            descendants. May be null if the nodeinfos
   *                            shouldn't be changed.
   * @param aNodesWithProperties All nodes (from amongst aNode and its
   *                             descendants) with properties. Every node will
   *                             be followed by its clone. Null can be passed to
   *                             prevent this from being used.
   * @param aResult *aResult will contain the cloned node.
   */
  static nsresult Clone(nsINode *aNode, bool aDeep,
                        nsNodeInfoManager *aNewNodeInfoManager,
                        nsCOMArray<nsINode> *aNodesWithProperties,
                        nsINode **aResult)
  {
    return CloneAndAdopt(aNode, true, aDeep, aNewNodeInfoManager,
                         nullptr, aNodesWithProperties, nullptr, aResult);
  }

  /**
   * Clones aNode, its attributes and, if aDeep is true, its descendant nodes
   */
  static nsresult Clone(nsINode *aNode, bool aDeep, nsINode **aResult)
  {
    return CloneAndAdopt(aNode, true, aDeep, nullptr, nullptr, nullptr,
                         aNode->GetParent(), aResult);
  }

  /**
   * Walks aNode, its attributes and descendant nodes. If aNewNodeInfoManager is
   * not null, it is used to create new nodeinfos for the nodes. Also reparents
   * the XPConnect wrappers for the nodes into aReparentScope if non-null.
   * aNodesWithProperties will be filled with all the nodes that have
   * properties.
   *
   * @param aNode Node to adopt.
   * @param aNewNodeInfoManager The nodeinfo manager to use to create new
   *                            nodeinfos for aNode and its attributes and
   *                            descendants. May be null if the nodeinfos
   *                            shouldn't be changed.
   * @param aReparentScope New scope for the wrappers, or null if no reparenting
   *                       should be done.
   * @param aNodesWithProperties All nodes (from amongst aNode and its
   *                             descendants) with properties.
   */
  static nsresult Adopt(nsINode *aNode, nsNodeInfoManager *aNewNodeInfoManager,
                        JS::Handle<JSObject*> aReparentScope,
                        nsCOMArray<nsINode> &aNodesWithProperties)
  {
    nsCOMPtr<nsINode> node;
    nsresult rv = CloneAndAdopt(aNode, false, true, aNewNodeInfoManager,
                                aReparentScope, &aNodesWithProperties,
                                nullptr, getter_AddRefs(node));

    nsMutationGuard::DidMutate();

    return rv;
  }

  /**
   * Helper for the cycle collector to traverse the DOM UserData for aNode.
   *
   * @param aNode the node to traverse UserData for
   * @param aCb the cycle collection callback
   */
  static void TraverseUserData(nsINode* aNode,
                               nsCycleCollectionTraversalCallback &aCb);

  /**
   * A basic implementation of the DOM cloneNode method. Calls nsINode::Clone to
   * do the actual cloning of the node.
   *
   * @param aNode the node to clone
   * @param aDeep if true all descendants will be cloned too
   * @param aResult the clone
   */
  static nsresult CloneNodeImpl(nsINode *aNode, bool aDeep, nsINode **aResult);

  /**
   * Release the UserData for aNode.
   *
   * @param aNode the node to release the UserData for
   */
  static void UnlinkUserData(nsINode *aNode);

  /**
   * Returns a true if the node is a HTMLTemplate element.
   *
   * @param aNode a node to test for HTMLTemplate elementness.
   */
  static bool IsTemplateElement(const nsINode *aNode);

  /**
   * Returns the first child of a node or the first child of
   * a template element's content if the provided node is a
   * template element.
   *
   * @param aNode A node from which to retrieve the first child.
   */
  static nsIContent* GetFirstChildOfTemplateOrNode(nsINode* aNode);

private:
  /**
   * Walks aNode, its attributes and, if aDeep is true, its descendant nodes.
   * If aClone is true the nodes will be cloned. If aNewNodeInfoManager is
   * not null, it is used to create new nodeinfos for the nodes. Also reparents
   * the XPConnect wrappers for the nodes into aReparentScope if non-null.
   * aNodesWithProperties will be filled with all the nodes that have
   * properties.
   *
   * @param aNode Node to adopt/clone.
   * @param aClone If true the node will be cloned and the cloned node will
   *               be in aResult.
   * @param aDeep If true the function will be called recursively on
   *              descendants of the node
   * @param aNewNodeInfoManager The nodeinfo manager to use to create new
   *                            nodeinfos for aNode and its attributes and
   *                            descendants. May be null if the nodeinfos
   *                            shouldn't be changed.
   * @param aReparentScope Scope into which wrappers should be reparented, or
   *                             null if no reparenting should be done.
   * @param aNodesWithProperties All nodes (from amongst aNode and its
   *                             descendants) with properties. If aClone is
   *                             true every node will be followed by its
   *                             clone. Null can be passed to prevent this from
   *                             being populated.
   * @param aParent If aClone is true the cloned node will be appended to
   *                aParent's children. May be null. If not null then aNode
   *                must be an nsIContent.
   * @param aResult If aClone is true then *aResult will contain the cloned
   *                node.
   */
  static nsresult CloneAndAdopt(nsINode *aNode, bool aClone, bool aDeep,
                                nsNodeInfoManager *aNewNodeInfoManager,
                                JS::Handle<JSObject*> aReparentScope,
                                nsCOMArray<nsINode> *aNodesWithProperties,
                                nsINode *aParent, nsINode **aResult);

  enum class AnimationMutationType
  {
    Added,
    Changed,
    Removed
  };
  /**
   * Notify the observers of the target of an animation
   * @param aAnimation The mutated animation.
   * @param aMutationType The mutation type of this animation. It could be
   *                      Added, Changed, or Removed.
   */
  static void AnimationMutated(mozilla::dom::Animation* aAnimation,
                               AnimationMutationType aMutatedType);

};

#endif // nsNodeUtils_h___
