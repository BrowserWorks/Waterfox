/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_StyleSheet_h
#define mozilla_StyleSheet_h

#include "mozilla/css/SheetParsingMode.h"
#include "mozilla/dom/CSSStyleSheetBinding.h"
#include "mozilla/net/ReferrerPolicy.h"
#include "mozilla/StyleBackendType.h"
#include "mozilla/CORSMode.h"
#include "mozilla/ServoUtils.h"

#include "nsICSSLoaderObserver.h"
#include "nsIDOMCSSStyleSheet.h"
#include "nsWrapperCache.h"

class nsIDocument;
class nsINode;
class nsIPrincipal;
class nsCSSRuleProcessor;

namespace mozilla {

class CSSStyleSheet;
class ServoStyleSheet;
class StyleSetHandle;
struct StyleSheetInfo;
struct CSSStyleSheetInner;

namespace dom {
class CSSImportRule;
class CSSRuleList;
class MediaList;
class SRIMetadata;
} // namespace dom

namespace css {
class GroupRule;
class Rule;
}

/**
 * Superclass for data common to CSSStyleSheet and ServoStyleSheet.
 */
class StyleSheet : public nsIDOMCSSStyleSheet
                 , public nsICSSLoaderObserver
                 , public nsWrapperCache
{
protected:
  StyleSheet(StyleBackendType aType, css::SheetParsingMode aParsingMode);
  StyleSheet(const StyleSheet& aCopy,
             StyleSheet* aParentToUse,
             dom::CSSImportRule* aOwnerRuleToUse,
             nsIDocument* aDocumentToUse,
             nsINode* aOwningNodeToUse);
  virtual ~StyleSheet();

public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS_AMBIGUOUS(StyleSheet,
                                                         nsIDOMCSSStyleSheet)

  /**
   * The different changes that a stylesheet may go through.
   *
   * Used by the StyleSets in order to handle more efficiently some kinds of
   * changes.
   */
  enum class ChangeType {
    Added,
    Removed,
    ApplicableStateChanged,
    RuleAdded,
    RuleRemoved,
    RuleChanged,
  };

  void SetOwningNode(nsINode* aOwningNode)
  {
    mOwningNode = aOwningNode;
  }

  css::SheetParsingMode ParsingMode() { return mParsingMode; }
  mozilla::dom::CSSStyleSheetParsingMode ParsingModeDOM();

  /**
   * Whether the sheet is complete.
   */
  bool IsComplete() const;
  void SetComplete();

  /**
   * Set the stylesheet to be enabled.  This may or may not make it
   * applicable.  Note that this WILL inform the sheet's document of
   * its new applicable state if the state changes but WILL NOT call
   * BeginUpdate() or EndUpdate() on the document -- calling those is
   * the caller's responsibility.  This allows use of SetEnabled when
   * batched updates are desired.  If you want updates handled for
   * you, see nsIDOMStyleSheet::SetDisabled().
   */
  void SetEnabled(bool aEnabled);

  MOZ_DECL_STYLO_METHODS(CSSStyleSheet, ServoStyleSheet)

  // Whether the sheet is for an inline <style> element.
  inline bool IsInline() const;

  inline nsIURI* GetSheetURI() const;
  /* Get the URI this sheet was originally loaded from, if any.  Can
     return null */
  inline nsIURI* GetOriginalURI() const;
  inline nsIURI* GetBaseURI() const;
  /**
   * SetURIs must be called on all sheets before parsing into them.
   * SetURIs may only be called while the sheet is 1) incomplete and 2)
   * has no rules in it
   */
  inline void SetURIs(nsIURI* aSheetURI, nsIURI* aOriginalSheetURI,
                      nsIURI* aBaseURI);

  /**
   * Whether the sheet is applicable.  A sheet that is not applicable
   * should never be inserted into a style set.  A sheet may not be
   * applicable for a variety of reasons including being disabled and
   * being incomplete.
   */
  inline bool IsApplicable() const;
  inline bool HasRules() const;

  virtual already_AddRefed<StyleSheet> Clone(StyleSheet* aCloneParent,
                                             dom::CSSImportRule* aCloneOwnerRule,
                                             nsIDocument* aCloneDocument,
                                             nsINode* aCloneOwningNode) const = 0;

  bool IsModified() const { return mDirty; }

  void EnsureUniqueInner();

  // Append all of this sheet's child sheets to aArray.
  void AppendAllChildSheets(nsTArray<StyleSheet*>& aArray);

  // style sheet owner info
  enum DocumentAssociationMode {
    // OwnedByDocument means mDocument owns us (possibly via a chain of other
    // stylesheets).
    OwnedByDocument,
    // NotOwnedByDocument means we're owned by something that might have a
    // different lifetime than mDocument.
    NotOwnedByDocument
  };
  nsIDocument* GetAssociatedDocument() const { return mDocument; }
  bool IsOwnedByDocument() const {
    return mDocumentAssociationMode == OwnedByDocument;
  }
  // aDocument must not be null.
  void SetAssociatedDocument(nsIDocument* aDocument,
                             DocumentAssociationMode aMode);
  void ClearAssociatedDocument();
  nsINode* GetOwnerNode() const { return mOwningNode; }
  inline StyleSheet* GetParentSheet() const { return mParent; }

  void SetOwnerRule(dom::CSSImportRule* aOwnerRule) {
    mOwnerRule = aOwnerRule; /* Not ref counted */
  }
  dom::CSSImportRule* GetOwnerRule() const { return mOwnerRule; }

  void PrependStyleSheet(StyleSheet* aSheet);

  StyleSheet* GetFirstChild() const;
  StyleSheet* GetMostRecentlyAddedChildSheet() const {
    // New child sheet can only be prepended into the linked list of
    // child sheets, so the most recently added one is always the first.
    return GetFirstChild();
  }

  // Principal() never returns a null pointer.
  inline nsIPrincipal* Principal() const;
  /**
   * SetPrincipal should be called on all sheets before parsing into them.
   * This can only be called once with a non-null principal.  Calling this with
   * a null pointer is allowed and is treated as a no-op.
   */
  inline void SetPrincipal(nsIPrincipal* aPrincipal);

  void SetTitle(const nsAString& aTitle) { mTitle = aTitle; }
  void SetMedia(dom::MediaList* aMedia);

  // Get this style sheet's CORS mode
  inline CORSMode GetCORSMode() const;
  // Get this style sheet's Referrer Policy
  inline net::ReferrerPolicy GetReferrerPolicy() const;
  // Get this style sheet's integrity metadata
  inline void GetIntegrity(dom::SRIMetadata& aResult) const;

  virtual size_t SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const;
#ifdef DEBUG
  virtual void List(FILE* aOut = stdout, int32_t aIndex = 0) const;
#endif

  // WebIDL StyleSheet API
  // The XPCOM GetType is fine for WebIDL.
  // The XPCOM GetHref is fine for WebIDL
  // GetOwnerNode is defined above.
  inline StyleSheet* GetParentStyleSheet() const;
  // The XPCOM GetTitle is fine for WebIDL.
  dom::MediaList* Media();
  bool Disabled() const { return mDisabled; }
  // The XPCOM SetDisabled is fine for WebIDL.

  // WebIDL CSSStyleSheet API
  // Can't be inline because we can't include ImportRule here.  And can't be
  // called GetOwnerRule because that would be ambiguous with the ImportRule
  // version.
  css::Rule* GetDOMOwnerRule() const;
  dom::CSSRuleList* GetCssRules(nsIPrincipal& aSubjectPrincipal,
                                ErrorResult& aRv);
  uint32_t InsertRule(const nsAString& aRule, uint32_t aIndex,
                      nsIPrincipal& aSubjectPrincipal,
                      ErrorResult& aRv);
  void DeleteRule(uint32_t aIndex,
                  nsIPrincipal& aSubjectPrincipal,
                  ErrorResult& aRv);

  // WebIDL miscellaneous bits
  inline dom::ParentObject GetParentObject() const;
  JSObject* WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) final;

  // nsIDOMStyleSheet interface
  NS_IMETHOD GetType(nsAString& aType) final;
  NS_IMETHOD GetDisabled(bool* aDisabled) final;
  NS_IMETHOD SetDisabled(bool aDisabled) final;
  NS_IMETHOD GetOwnerNode(nsIDOMNode** aOwnerNode) final;
  NS_IMETHOD GetParentStyleSheet(nsIDOMStyleSheet** aParentStyleSheet) final;
  NS_IMETHOD GetHref(nsAString& aHref) final;
  NS_IMETHOD GetTitle(nsAString& aTitle) final;
  NS_IMETHOD GetMedia(nsIDOMMediaList** aMedia) final;

  // nsIDOMCSSStyleSheet
  NS_IMETHOD GetOwnerRule(nsIDOMCSSRule** aOwnerRule) final;
  NS_IMETHOD GetCssRules(nsIDOMCSSRuleList** aCssRules) final;
  NS_IMETHOD InsertRule(const nsAString& aRule, uint32_t aIndex,
                      uint32_t* aReturn) final;
  NS_IMETHOD DeleteRule(uint32_t aIndex) final;

  // Changes to sheets should be inside of a WillDirty-DidDirty pair.
  // However, the calls do not need to be matched; it's ok to call
  // WillDirty and then make no change and skip the DidDirty call.
  void WillDirty();
  virtual void DidDirty() {}

  void AddStyleSet(const StyleSetHandle& aStyleSet);
  void DropStyleSet(const StyleSetHandle& aStyleSet);

  nsresult DeleteRuleFromGroup(css::GroupRule* aGroup, uint32_t aIndex);
  nsresult InsertRuleIntoGroup(const nsAString& aRule,
                               css::GroupRule* aGroup, uint32_t aIndex);

  template<typename Func>
  void EnumerateChildSheets(Func aCallback) {
    for (StyleSheet* child = GetFirstChild(); child; child = child->mNext) {
      aCallback(child);
    }
  }

private:
  // Get a handle to the various stylesheet bits which live on the 'inner' for
  // gecko stylesheets and live on the StyleSheet for Servo stylesheets.
  inline StyleSheetInfo& SheetInfo();
  inline const StyleSheetInfo& SheetInfo() const;

  // Check if the rules are available for read and write.
  // It does the security check as well as whether the rules have been
  // completely loaded. aRv will have an exception set if this function
  // returns false.
  bool AreRulesAvailable(nsIPrincipal& aSubjectPrincipal,
                         ErrorResult& aRv);

protected:
  struct ChildSheetListBuilder {
    RefPtr<StyleSheet>* sheetSlot;
    StyleSheet* parent;

    void SetParentLinks(StyleSheet* aSheet);

    static void ReparentChildList(StyleSheet* aPrimarySheet,
                                  StyleSheet* aFirstChild);
  };

  void UnparentChildren();

  // Return success if the subject principal subsumes the principal of our
  // inner, error otherwise.  This will also succeed if the subject has
  // UniversalXPConnect or if access is allowed by CORS.  In the latter case,
  // it will set the principal of the inner to the subject principal.
  void SubjectSubsumesInnerPrincipal(nsIPrincipal& aSubjectPrincipal,
                                     ErrorResult& aRv);

  // Drop our reference to mMedia
  void DropMedia();

  // Called from SetEnabled when the enabled state changed.
  void EnabledStateChanged();

  // Unlink our inner, if needed, for cycle collection
  virtual void UnlinkInner();
  // Traverse our inner, if needed, for cycle collection
  virtual void TraverseInner(nsCycleCollectionTraversalCallback &);

  // Return whether the given @import rule has pending child sheet.
  static bool RuleHasPendingChildSheet(css::Rule* aRule);

  StyleSheet*           mParent;    // weak ref

  nsString              mTitle;
  nsIDocument*          mDocument; // weak ref; parents maintain this for their children
  nsINode*              mOwningNode; // weak ref
  dom::CSSImportRule*   mOwnerRule; // weak ref

  RefPtr<dom::MediaList> mMedia;

  RefPtr<StyleSheet> mNext;

  // mParsingMode controls access to nonstandard style constructs that
  // are not safe for use on the public Web but necessary in UA sheets
  // and/or useful in user sheets.
  css::SheetParsingMode mParsingMode;

  const StyleBackendType mType;
  bool                  mDisabled;

  // mDocumentAssociationMode determines whether mDocument directly owns us (in
  // the sense that if it's known-live then we're known-live).  Always
  // NotOwnedByDocument when mDocument is null.
  DocumentAssociationMode mDocumentAssociationMode;

  // Core information we get from parsed sheets, which are shared amongst
  // StyleSheet clones.
  StyleSheetInfo* mInner;

  bool mDirty; // has been modified

  nsTArray<StyleSetHandle> mStyleSets;

  friend class ::nsCSSRuleProcessor;

  // Make CSSStyleSheet and ServoStyleSheet friends so they can access
  // protected members of other StyleSheet objects (useful for iterating
  // through children).
  friend class mozilla::CSSStyleSheet;
  friend class mozilla::ServoStyleSheet;

  // Make StyleSheetInfo and subclasses into friends so they can use
  // ChildSheetListBuilder.
  friend struct mozilla::StyleSheetInfo;
  friend struct mozilla::CSSStyleSheetInner;
};

} // namespace mozilla

#endif // mozilla_StyleSheet_h
