/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef WSRunScanner_h
#define WSRunScanner_h

#include "EditorBase.h"
#include "EditorForwards.h"
#include "EditorDOMPoint.h"   // for EditorDOMPoint
#include "EditorLineBreak.h"  // for EditorLineBreakBase
#include "HTMLEditor.h"
#include "HTMLEditUtils.h"

#include "mozilla/Assertions.h"
#include "mozilla/Maybe.h"
#include "mozilla/Result.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/HTMLBRElement.h"
#include "mozilla/dom/Text.h"
#include "nsCOMPtr.h"
#include "nsIContent.h"

namespace mozilla {

/**
 * WSScanResult is result of ScanNextVisibleNodeOrBlockBoundaryFrom(),
 * ScanPreviousVisibleNodeOrBlockBoundaryFrom(), and their static wrapper
 * methods.  This will have information of found visible content (and its
 * position) or reached block element or topmost editable content at the
 * start of scanner.
 */
class MOZ_STACK_CLASS WSScanResult final {
 private:
  using Element = dom::Element;
  using HTMLBRElement = dom::HTMLBRElement;
  using Text = dom::Text;

  enum class WSType : uint8_t {
    NotInitialized,
    // Could be the DOM tree is broken as like crash tests.
    UnexpectedError,
    // The scanner cannot work in uncomposed tree, but tried to scan in it.
    InUncomposedDoc,
    // The run is maybe collapsible white-spaces at start of a hard line.
    LeadingWhiteSpaces,
    // The run is maybe collapsible white-spaces at end of a hard line.
    TrailingWhiteSpaces,
    // Collapsible, but visible white-spaces.
    CollapsibleWhiteSpaces,
    // Visible characters except collapsible white-spaces.
    NonCollapsibleCharacters,
    // Empty inline container elemnet such as `<span></span>`.  Note that it may
    // be visible if its border/padding is not 0 for example.
    // NOTE: This won't be used if it's the inline editing host at the scan
    // start point.
    EmptyInlineContainerElement,
    // Special content such as `<img>`, etc.
    SpecialContent,
    // <br> element.
    BRElement,
    // A linefeed which is preformatted.
    PreformattedLineBreak,
    // Other block's boundary (child block of current block, maybe).
    OtherBlockBoundary,
    // Current block's boundary.
    CurrentBlockBoundary,
    // Inline editing host boundary.
    InlineEditingHostBoundary,
  };

  friend std::ostream& operator<<(std::ostream& aStream, const WSType& aType) {
    switch (aType) {
      case WSType::NotInitialized:
        return aStream << "WSType::NotInitialized";
      case WSType::UnexpectedError:
        return aStream << "WSType::UnexpectedError";
      case WSType::InUncomposedDoc:
        return aStream << "WSType::InUncomposedDoc";
      case WSType::LeadingWhiteSpaces:
        return aStream << "WSType::LeadingWhiteSpaces";
      case WSType::TrailingWhiteSpaces:
        return aStream << "WSType::TrailingWhiteSpaces";
      case WSType::CollapsibleWhiteSpaces:
        return aStream << "WSType::CollapsibleWhiteSpaces";
      case WSType::NonCollapsibleCharacters:
        return aStream << "WSType::NonCollapsibleCharacters";
      case WSType::EmptyInlineContainerElement:
        return aStream << "WSType::EmptyInlineContainerElement";
      case WSType::SpecialContent:
        return aStream << "WSType::SpecialContent";
      case WSType::BRElement:
        return aStream << "WSType::BRElement";
      case WSType::PreformattedLineBreak:
        return aStream << "WSType::PreformattedLineBreak";
      case WSType::OtherBlockBoundary:
        return aStream << "WSType::OtherBlockBoundary";
      case WSType::CurrentBlockBoundary:
        return aStream << "WSType::CurrentBlockBoundary";
      case WSType::InlineEditingHostBoundary:
        return aStream << "WSType::InlineEditingHostBoundary";
    }
    return aStream << "<Illegal value>";
  }

  friend class WSRunScanner;  // Because of WSType.

  explicit WSScanResult(WSType aReason) : mReason(aReason) {
    MOZ_ASSERT(mReason == WSType::UnexpectedError ||
               mReason == WSType::NotInitialized);
  }

 public:
  WSScanResult() = delete;
  enum class ScanDirection : bool { Backward, Forward };
  WSScanResult(const WSRunScanner& aScanner, ScanDirection aScanDirection,
               nsIContent& aContent, WSType aReason)
      : mContent(&aContent), mReason(aReason), mDirection(aScanDirection) {
    MOZ_ASSERT(aReason != WSType::CollapsibleWhiteSpaces &&
               aReason != WSType::NonCollapsibleCharacters &&
               aReason != WSType::PreformattedLineBreak);
    AssertIfInvalidData(aScanner);
    MaybeSetEditingHost(aScanner);
  }
  WSScanResult(const WSRunScanner& aScanner, ScanDirection aScanDirection,
               const EditorDOMPoint& aPoint, WSType aReason)
      : mContent(aPoint.GetContainerAs<nsIContent>()),
        mOffset(Some(aPoint.Offset())),
        mReason(aReason),
        mDirection(aScanDirection) {
    AssertIfInvalidData(aScanner);
    MaybeSetEditingHost(aScanner);
  }

  WSScanResult(WSScanResult&& aResult, EditorLineBreak&& aIgnoredLineBreak,
               const Element& aEditingHost)
      : WSScanResult(std::forward<WSScanResult>(aResult)) {
    MOZ_ASSERT(ReachedBlockBoundary());
    mIgnoredLineBreak.emplace(std::forward<EditorLineBreak>(aIgnoredLineBreak));
    // If an editing host is specified and the reached content is outside the
    // editing host, we should store the editing host to make the method
    // returning the reached point to return a point in the editing host.
    Element* const contentEditingHost = mContent->GetEditingHost();
    if (contentEditingHost && contentEditingHost != &aEditingHost) {
      mEditingHost = const_cast<Element*>(&aEditingHost);
    }
  }

  static WSScanResult Error() { return WSScanResult(WSType::UnexpectedError); }

  void AssertIfInvalidData(const WSRunScanner& aScanner) const;

  bool Failed() const {
    return mReason == WSType::NotInitialized ||
           mReason == WSType::UnexpectedError;
  }

  /**
   * GetContent() returns found visible and editable content/element.
   * See MOZ_ASSERT_IF()s in AssertIfInvalidData() for the detail.
   */
  nsIContent* GetContent() const { return mContent; }

  [[nodiscard]] bool ContentIsElement() const {
    return mContent && mContent->IsElement();
  }

  [[nodiscard]] bool ContentIsText() const {
    return mContent && mContent->IsText();
  }

  /**
   * The following accessors makes it easier to understand each callers.
   */
  MOZ_NEVER_INLINE_DEBUG Element* ElementPtr() const {
    MOZ_DIAGNOSTIC_ASSERT(mContent->IsElement());
    return mContent->AsElement();
  }
  MOZ_NEVER_INLINE_DEBUG HTMLBRElement* BRElementPtr() const {
    MOZ_DIAGNOSTIC_ASSERT(mContent->IsHTMLElement(nsGkAtoms::br));
    return static_cast<HTMLBRElement*>(mContent.get());
  }
  MOZ_NEVER_INLINE_DEBUG Text* TextPtr() const {
    MOZ_DIAGNOSTIC_ASSERT(mContent->IsText());
    return mContent->AsText();
  }

  template <typename EditorLineBreakType>
  MOZ_NEVER_INLINE_DEBUG EditorLineBreakType CreateEditorLineBreak() const {
    if (ReachedBRElement()) {
      return EditorLineBreakType(*BRElementPtr());
    }
    if (ReachedPreformattedLineBreak()) {
      MOZ_ASSERT_IF(mDirection == ScanDirection::Backward, *mOffset > 0);
      return EditorLineBreakType(*TextPtr(),
                                 mDirection == ScanDirection::Forward
                                     ? mOffset.valueOr(0)
                                     : std::max(mOffset.valueOr(1), 1u) - 1);
    }
    MOZ_CRASH("Didn't reach a line break");
    return EditorLineBreakType(*BRElementPtr());
  }

  /**
   * Return true if found or reached content is editable.
   */
  [[nodiscard]] bool ContentIsEditable() const {
    return mContent && HTMLEditUtils::IsSimplyEditableNode(*mContent);
  }

  /**
   * Return true if found or reached content is removable node.
   */
  [[nodiscard]] bool ContentIsRemovable() const {
    return mContent && HTMLEditUtils::IsRemovableNode(*mContent);
  }

  [[nodiscard]] bool ContentIsEditableRoot() const {
    return ContentIsElement() &&
           HTMLEditUtils::ElementIsEditableRoot(*ElementPtr());
  }

  [[nodiscard]] bool ReachedOutsideEditingHost() const {
    return !!mEditingHost;
  }

  /**
   * Offset_Deprecated() returns meaningful value only when
   * InVisibleOrCollapsibleCharacters() returns true or the scanner reached to
   * start or end of its scanning range and that is same as start or end
   * container which are specified when the scanner is initialized.  If it's
   * result of scanning backward, this offset means the point of the found
   * point. Otherwise, i.e., scanning forward, this offset means next point
   * of the found point.  E.g., if it reaches a collapsible white-space, this
   * offset is at the first non-collapsible character after it.
   */
  MOZ_NEVER_INLINE_DEBUG uint32_t Offset_Deprecated() const {
    NS_ASSERTION(mOffset.isSome(), "Retrieved non-meaningful offset");
    return mOffset.valueOr(0);
  }

  /**
   * Point_Deprecated() returns the position in found visible node or reached
   * block boundary.  So, this returns meaningful point only when
   * Offset_Deprecated() returns meaningful value.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType Point_Deprecated() const {
    NS_ASSERTION(mOffset.isSome(), "Retrieved non-meaningful point");
    return EditorDOMPointType(mContent, mOffset.valueOr(0));
  }

  /**
   * PointAtReachedContent() returns the position of found visible content or
   * reached block element. Note that the returned point may be outside the
   * editing host if WSRunScanner::Option::OnlyEditableNodes is not specified
   * and the ancestor limiter is not specified or specified outside the editing
   * host.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAtReachedContent() const {
    MOZ_ASSERT(mContent);
    switch (mReason) {
      case WSType::CollapsibleWhiteSpaces:
      case WSType::NonCollapsibleCharacters:
      case WSType::PreformattedLineBreak:
        MOZ_DIAGNOSTIC_ASSERT(mOffset.isSome());
        return mDirection == ScanDirection::Forward
                   ? EditorDOMPointType(mContent, mOffset.valueOr(0))
                   : EditorDOMPointType(mContent,
                                        std::max(mOffset.valueOr(1), 1u) - 1);
      default:
        MOZ_ASSERT_IF(mContent == mEditingHost, !ReachedCurrentBlockBoundary());
        MOZ_ASSERT_IF(mContent == mEditingHost,
                      !ReachedInlineEditingHostBoundary());
        return EditorDOMPointType(mContent);
    }
  }

  /**
   * Similar to PointAtReachedContent(), but return a boundary point of the
   * editing host if the reached content is outside of the editing host.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAtReachedContentOrEditingHostBoundary() const {
    if (mEditingHost) {
      MOZ_ASSERT(mContent);
      MOZ_ASSERT_IF(mContent == mEditingHost, !ReachedCurrentBlockBoundary());
      MOZ_ASSERT_IF(mContent == mEditingHost,
                    !ReachedInlineEditingHostBoundary());
      return mDirection == ScanDirection::Forward
                 ? EditorDOMPointType::AtEndOf(*mEditingHost)
                 : EditorDOMPointType(mEditingHost, 0u);
    }
    return PointAtReachedContent<EditorDOMPointType>();
  }

  /**
   * PointAfterReachedContent() returns the next position of found visible
   * content or reached block element. Note that the returned point may be
   * outside the editing host if WSRunScanner::Option::OnlyEditableNodes is not
   * specified and the ancestor limiter is not specified or specified outside
   * the editing host.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAfterReachedContent() const {
    MOZ_ASSERT(mContent);
    MOZ_ASSERT_IF(mContent == mEditingHost, !ReachedCurrentBlockBoundary());
    MOZ_ASSERT_IF(mContent == mEditingHost,
                  !ReachedInlineEditingHostBoundary());
    return PointAtReachedContent<EditorDOMPointType>()
        .template NextPointOrAfterContainer<EditorDOMPointType>();
  }

  /**
   * Similar to PointAfterReachedContent(), but return a boundary point of the
   * editing host if the reached content is outside of the editing host.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAfterReachedContentOrEditingHostBoundary() const {
    if (mEditingHost) {
      MOZ_ASSERT(mContent);
      MOZ_ASSERT_IF(mContent == mEditingHost, !ReachedCurrentBlockBoundary());
      MOZ_ASSERT_IF(mContent == mEditingHost,
                    !ReachedInlineEditingHostBoundary());
      return mDirection == ScanDirection::Forward
                 ? EditorDOMPointType::AtEndOf(*mEditingHost)
                 : EditorDOMPointType(mEditingHost, 0u);
    }
    return PointAfterReachedContent<EditorDOMPointType>();
  }

  /**
   * Return the next position of found visible content node.  So, this should
   * not be used if it reached a visible character middle of a `Text`. Note that
   * the returned point may be outside the editing host if
   * WSRunScanner::Option::OnlyEditableNodes is not specified and the ancestor
   * limiter is not specified or specified outside the editing host.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAfterReachedContentNode() const {
    MOZ_ASSERT(mContent);
    MOZ_ASSERT_IF(mContent == mEditingHost, !ReachedCurrentBlockBoundary());
    MOZ_ASSERT_IF(mContent == mEditingHost,
                  !ReachedInlineEditingHostBoundary());
    return EditorDOMPointType::After(*mContent);
  }

  /**
   * Similar to PointAfterReachedContentNode(), but return a boundary point of
   * the editing host if the reached content is outside of the editing host.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAfterReachedContentNodeOrEditingHostBoundary() const {
    MOZ_ASSERT(mContent);
    if (mEditingHost) {
      MOZ_ASSERT_IF(mContent == mEditingHost, !ReachedCurrentBlockBoundary());
      MOZ_ASSERT_IF(mContent == mEditingHost,
                    !ReachedInlineEditingHostBoundary());
      return mDirection == ScanDirection::Forward
                 ? EditorDOMPointType::AtEndOf(*mEditingHost)
                 : EditorDOMPointType(mEditingHost, 0u);
    }
    return PointAfterReachedContentNode<EditorDOMPointType>();
  }

  /**
   * Return the point of the reached block boundary. If reached current block
   * boundary, return its inner boundary. Otherwise, its outer boundary.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAtReachedBlockBoundary() const {
    MOZ_ASSERT(ReachedBlockBoundary());
    if (mDirection == ScanDirection::Forward) {
      return ReachedCurrentBlockBoundary()
                 ? EditorDOMPointType::AtEndOf(*mContent)
                 : EditorDOMPointType(mContent);
    }
    return ReachedCurrentBlockBoundary() ? EditorDOMPointType(mContent, 0u)
                                         : EditorDOMPointType::After(*mContent);
  }

  /**
   * Similar to PointAtReachedBlockBoundary() but the block is outside the
   * editing host, return the point at the editing host boundary.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAtReachedBlockBoundaryOrEditingHostBoundary() const {
    MOZ_ASSERT(ReachedBlockBoundary());
    if (mEditingHost) {
      return mDirection == ScanDirection::Forward
                 ? EditorDOMPointType::AtEndOf(*mEditingHost)
                 : EditorDOMPointType(mEditingHost, 0u);
    }
    return PointAtReachedBlockBoundary<EditorDOMPointType>();
  }

  /**
   * Return the point of the reached line boundary. I.e., start or end of the
   * line content, i.e., if scanned forward and reached a line break, return the
   * point of the line break, not after the line break.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAtReachedLineBoundary() const {
    MOZ_ASSERT(ReachedLineBoundary());
    if (ReachedBlockBoundary()) {
      return PointAtReachedBlockBoundary<EditorDOMPointType>();
    }
    if (mDirection == ScanDirection::Forward) {
      return PointAtReachedContent<EditorDOMPointType>();
    }
    return PointAfterReachedContent<EditorDOMPointType>();
  }

  /**
   * Similar to PointAtReachedLineBoundary() but if the line boundary is outside
   * the editing host, return the editing host boundary.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType PointAtReachedLineBoundaryOrEditingHostBoundary() const {
    MOZ_ASSERT(ReachedLineBoundary());
    if (ReachedBlockBoundary()) {
      return PointAtReachedBlockBoundaryOrEditingHostBoundary<
          EditorDOMPointType>();
    }
    if (mDirection == ScanDirection::Forward) {
      return PointAtReachedContentOrEditingHostBoundary<EditorDOMPointType>();
    }
    return PointAfterReachedContentOrEditingHostBoundary<EditorDOMPointType>();
  }

  /**
   * The scanner reached an empty inline container element such as
   * <span></span>.  Note that the element may be visible, e.g., may have
   * non-zero border/padding.
   */
  [[nodiscard]] constexpr bool ReachedEmptyInlineContainerElement() const {
    return mReason == WSType::EmptyInlineContainerElement;
  }
  /**
   * The scanner reached an editable empty inline container element such as
   * <span></span>.  Note that the element may be visible, e.g., may have
   * non-zero border/padding.
   */
  [[nodiscard]] bool ReachedEditableEmptyInlineContainerElement() const {
    return ReachedEmptyInlineContainerElement() && ContentIsEditable();
  }
  /**
   * The scanner reached a removable empty inline container element such as
   * <span></span>.  Note that the element may be visible, e.g., may have
   * non-zero border/padding.
   */
  [[nodiscard]] bool ReachedRemovableEmptyInlineContainerElement() const {
    return ReachedEmptyInlineContainerElement() && ContentIsRemovable();
  }

  /**
   * The scanner reached an empty inline container element which is visible.
   */
  [[nodiscard]] bool ReachedVisibleEmptyInlineContainerElement(
      const nsIContent* aAncestorLimiterToCheckDisplayNone = nullptr) const {
    return ReachedEmptyInlineContainerElement() &&
           HTMLEditUtils::IsVisibleElementEvenIfLeafNode(*ElementPtr()) &&
           !HTMLEditUtils::IsInclusiveAncestorCSSDisplayNone(
               *ElementPtr(), aAncestorLimiterToCheckDisplayNone);
  }
  /**
   * The scanner reached an editable empty inline container element which is
   * visible.
   */
  [[nodiscard]] bool ReachedEditableEmptyInlineContainerElement(
      const nsIContent* aAncestorLimiterToCheckDisplayNone = nullptr) const {
    return ReachedVisibleEmptyInlineContainerElement(
               aAncestorLimiterToCheckDisplayNone) &&
           ContentIsEditable();
  }
  /**
   * The scanner reached a removable empty inline container element which is
   * visible.
   */
  [[nodiscard]] bool ReachedRemovableEmptyInlineContainerElement(
      const nsIContent* aAncestorLimiterToCheckDisplayNone = nullptr) const {
    return ReachedVisibleEmptyInlineContainerElement(
               aAncestorLimiterToCheckDisplayNone) &&
           ContentIsRemovable();
  }

  /**
   * The scanner reached an empty inline container element which is invisible.
   */
  [[nodiscard]] bool ReachedInvisibleEmptyInlineContainerElement(
      const nsIContent* aAncestorLimiterToCheckDisplayNone = nullptr) const {
    return ReachedEmptyInlineContainerElement() &&
           (!HTMLEditUtils::IsVisibleElementEvenIfLeafNode(*ElementPtr()) ||
            HTMLEditUtils::IsInclusiveAncestorCSSDisplayNone(
                *ElementPtr(), aAncestorLimiterToCheckDisplayNone));
  }
  /**
   * The scanner reached an editable empty inline container element which is
   * invisible.
   */
  [[nodiscard]] bool ReachedEditableInvisibleEmptyInlineContainerElement(
      const nsIContent* aAncestorLimiterToCheckDisplayNone = nullptr) const {
    return ReachedInvisibleEmptyInlineContainerElement(
               aAncestorLimiterToCheckDisplayNone) &&
           ContentIsEditable();
  }
  /**
   * The scanner reached a removable empty inline container element which is
   * invisible.
   */
  [[nodiscard]] bool ReachedRemovableInvisibleEmptyInlineContainerElement(
      const nsIContent* aAncestorLimiterToCheckDisplayNone = nullptr) const {
    return ReachedEditableInvisibleEmptyInlineContainerElement(
               aAncestorLimiterToCheckDisplayNone) &&
           ContentIsRemovable();
  }

  /**
   * The scanner reached <img> or something which is inline and is not a
   * container.
   */
  [[nodiscard]] constexpr bool ReachedSpecialContent() const {
    return mReason == WSType::SpecialContent;
  }

  /**
   * The point is in visible characters or collapsible white-spaces.
   */
  bool InVisibleOrCollapsibleCharacters() const {
    return mReason == WSType::CollapsibleWhiteSpaces ||
           mReason == WSType::NonCollapsibleCharacters;
  }

  /**
   * The point is in collapsible white-spaces.
   */
  bool InCollapsibleWhiteSpaces() const {
    return mReason == WSType::CollapsibleWhiteSpaces;
  }

  /**
   * The point is in visible non-collapsible characters.
   */
  bool InNonCollapsibleCharacters() const {
    return mReason == WSType::NonCollapsibleCharacters;
  }

  /**
   * The scanner reached a <br> element.
   */
  bool ReachedBRElement() const { return mReason == WSType::BRElement; }
  bool ReachedBRElementNotFollowedByBlockBoundary() const {
    return ReachedBRElement() &&
           !HTMLEditUtils::IsBRElementFollowedByBlockBoundary(*BRElementPtr());
  }
  bool ReachedBRElementFollowedByBlockBoundary() const {
    return ReachedBRElement() &&
           HTMLEditUtils::IsBRElementFollowedByBlockBoundary(*BRElementPtr());
  }

  bool ReachedPreformattedLineBreak() const {
    return mReason == WSType::PreformattedLineBreak;
  }

  /**
   * Return true if reached a <br> element or a preformatted line break.
   * Return false when reached a block boundary.  Use ReachedLineBoundary() if
   * you want it to return true in the case too.
   */
  [[nodiscard]] bool ReachedLineBreak() const {
    return ReachedBRElement() || ReachedPreformattedLineBreak();
  }

  /**
   * The scanner reached a <hr> element.
   */
  bool ReachedHRElement() const {
    return mContent && mContent->IsHTMLElement(nsGkAtoms::hr);
  }

  /**
   * The scanner reached current block boundary or other block element.
   */
  bool ReachedBlockBoundary() const {
    return mReason == WSType::CurrentBlockBoundary ||
           mReason == WSType::OtherBlockBoundary;
  }

  /**
   * The scanner reached current block element boundary.
   */
  bool ReachedCurrentBlockBoundary() const {
    return mReason == WSType::CurrentBlockBoundary;
  }

  /**
   * The scanner reached other block element.
   */
  bool ReachedOtherBlockElement() const {
    return mReason == WSType::OtherBlockBoundary;
  }

  /**
   * The scanner reached other block element that isn't editable
   */
  bool ReachedNonEditableOtherBlockElement() const {
    return ReachedOtherBlockElement() && !GetContent()->IsEditable();
  }

  /**
   * The scanner reached inline editing host boundary.
   */
  [[nodiscard]] bool ReachedInlineEditingHostBoundary() const {
    return mReason == WSType::InlineEditingHostBoundary;
  }

  /**
   * The scanner reached something non-text node.
   */
  bool ReachedSomethingNonTextContent() const {
    return !InVisibleOrCollapsibleCharacters();
  }

  [[nodiscard]] bool ReachedLineBoundary() const {
    switch (mReason) {
      case WSType::CurrentBlockBoundary:
      case WSType::OtherBlockBoundary:
      case WSType::BRElement:
      case WSType::PreformattedLineBreak:
        return true;
      default:
        return ReachedHRElement();
    }
  }

  /**
   * Return a reference to editor line break which was ignored at scanning.
   * If there is, it means that the line break is unnecessary. Note that the
   * invisible line break may be outside the editing host.
   */
  [[nodiscard]] const Maybe<EditorLineBreak>& MaybeIgnoredLineBreak() const {
    return mIgnoredLineBreak;
  }

  /**
   * Return true if the ignored line break is required in the plaintext mail
   * composer.
   */
  [[nodiscard]] bool IgnoredLineBreakIsRequiredInPlaintextMailComposer() const {
    if (!mIgnoredLineBreak || !mIgnoredLineBreak->IsHTMLBRElement()) {
      return false;
    }
    // <br> before the mailcite <span> is required by the serializer.
    if (ReachedOtherBlockElement() &&
        HTMLEditUtils::IsMailCiteElement(*ElementPtr()) &&
        HTMLEditUtils::IsInlineContent(*ElementPtr(),
                                       BlockInlineCheck::UseHTMLDefaultStyle)) {
      return true;
    }
    // <br> in the mailcite <span> is required by the serializer too.
    const Element* const blockElement = HTMLEditUtils::GetAncestorElement(
        mIgnoredLineBreak->BRElementRef(),
        HTMLEditUtils::ClosestEditableBlockElement,
        BlockInlineCheck::UseComputedDisplayStyle);
    if (blockElement && HTMLEditUtils::IsMailCiteElement(*blockElement) &&
        HTMLEditUtils::IsInlineContent(*blockElement,
                                       BlockInlineCheck::UseHTMLDefaultStyle)) {
      return true;
    }
    // Otherwise, the <br> is not required even in the plaintext mail composer.
    return false;
  }

  friend std::ostream& operator<<(std::ostream& aStream,
                                  const ScanDirection& aDirection) {
    return aStream << (aDirection == ScanDirection::Backward
                           ? "ScanDirection::Backward"
                           : "ScanDirection::Forward");
  }

  friend std::ostream& operator<<(std::ostream& aStream,
                                  const WSScanResult& aResult) {
    aStream << "{ mReason: " << aResult.mReason;
    if (aResult.mReason == WSType::NotInitialized ||
        aResult.mReason == WSType::InUncomposedDoc) {
      return aStream << " }";
    }
    return aStream << ", mContent: " << aResult.mContent
                   << ", mEditingHost: " << aResult.mEditingHost
                   << ", mIgnoredLineBreak: " << aResult.mIgnoredLineBreak
                   << ", mOffset: " << aResult.mOffset
                   << ", mDirection: " << aResult.mDirection << " }";
  }

 private:
  void MaybeSetEditingHost(const WSRunScanner& aScanner);

  nsCOMPtr<nsIContent> mContent;
  RefPtr<Element> mEditingHost;
  Maybe<EditorLineBreak> mIgnoredLineBreak;
  Maybe<uint32_t> mOffset;
  WSType mReason = WSType::NotInitialized;
  ScanDirection mDirection = ScanDirection::Backward;
};

class MOZ_STACK_CLASS WSRunScanner final {
 private:
  using Element = dom::Element;
  using HTMLBRElement = dom::HTMLBRElement;
  using Text = dom::Text;

 public:
  using WSType = WSScanResult::WSType;

  enum class IgnoreNonEditableNodes : bool { No, Yes };
  enum class StopAtNonEditableNode : bool { No, Yes };
  enum class ReferHTMLDefaultStyle : bool { No, Yes };
  enum class Option {
    // If set, return only editable content or return non-editable content as a
    // special content in the closest editing host if the scan start point is
    // editable.
    OnlyEditableNodes,
    // If set, use the HTML default style to consider whether the found one is a
    // block or an inline.
    ReferHTMLDefaultStyle,
    // If set, stop scanning the DOM when it reaches a `Comment` node.
    StopAtComment,
    // If set, stop at any empty inline containers, even when it's visible.
    StopAtAnyEmptyInlineContainers,
    // If set, stop ignoring visible empty inline containers such as
    // <span style="border:1px solid"></span> or
    // <span style="border:padding 1px"></span>.
    // XXX Currently, this does not work well if the inline container has only
    // `::before` and/or `::after` content and the frame is dirty.
    StopAtVisibleEmptyInlineContainers,
  };
  using Options = EnumSet<Option>;

  [[nodiscard]] constexpr static IgnoreNonEditableNodes
  ShouldIgnoreNonEditableSiblingsOrDescendants(
      Options aOptions  // NOLINT(performance-unnecessary-value-param)
  ) {
    return static_cast<IgnoreNonEditableNodes>(
        aOptions.contains(Option::OnlyEditableNodes));
  }
  [[nodiscard]] constexpr static StopAtNonEditableNode
  ShouldStopAtNonEditableNode(
      Options aOptions  // NOLINT(performance-unnecessary-value-param)
  ) {
    return static_cast<StopAtNonEditableNode>(
        aOptions.contains(Option::OnlyEditableNodes));
  }

  [[nodiscard]] constexpr static ReferHTMLDefaultStyle
  ShouldReferHTMLDefaultStyle(
      Options aOptions  // NOLINT(performance-unnecessary-value-param)
  ) {
    return static_cast<ReferHTMLDefaultStyle>(
        aOptions.contains(Option::ReferHTMLDefaultStyle));
  }

 private:
  [[nodiscard]] static HTMLEditUtils::LeafNodeOptions ToLeafNodeOptions(
      const Options& aOptions) {
    using LeafNodeOption = HTMLEditUtils::LeafNodeOption;
    using LeafNodeOptions = HTMLEditUtils::LeafNodeOptions;
    auto types =
        aOptions.contains(Option::OnlyEditableNodes)
            ? LeafNodeOptions{LeafNodeOption::TreatNonEditableNodeAsLeafNode}
            : LeafNodeOptions{};
    if (aOptions.contains(Option::StopAtComment)) {
      types += LeafNodeOption::TreatCommentAsLeafNode;
    }
    if (aOptions.contains(Option::StopAtVisibleEmptyInlineContainers)) {
      MOZ_ASSERT(!aOptions.contains(Option::StopAtAnyEmptyInlineContainers));
      types +=
          LeafNodeOptions{LeafNodeOption::IgnoreInvisibleEmptyInlineContainers,
                          LeafNodeOption::IgnoreInvisibleInlineVoidElements,
                          LeafNodeOption::IgnoreInvisibleText};
    } else if (!aOptions.contains(Option::StopAtAnyEmptyInlineContainers)) {
      types += LeafNodeOptions{LeafNodeOption::IgnoreAnyEmptyInlineContainers,
                               LeafNodeOption::IgnoreEmptyText};
    }
    return types;
  }

 public:
  template <typename EditorDOMPointType>
  WSRunScanner(Options aOptions,  // NOLINT(performance-unnecessary-value-param)
               const EditorDOMPointType& aScanStartPoint,
               const Element* aAncestorLimiter = nullptr)
      : mScanStartPoint(aScanStartPoint.template To<EditorDOMPoint>()),
        mTextFragmentDataAtStart(aOptions, mScanStartPoint, aAncestorLimiter) {}

  // ScanInclusiveNextVisibleNodeOrBlockBoundaryFrom() returns the first visible
  // node at or after aPoint.  If there is no visible nodes after aPoint,
  // returns topmost editable inline ancestor at end of current block.  See
  // comments around WSScanResult for the detail.  When you reach a character,
  // this returns WSScanResult both whose Point_Deprecated() and
  // PointAtReachedContent() return the found character position.
  template <typename PT, typename CT>
  WSScanResult ScanInclusiveNextVisibleNodeOrBlockBoundaryFrom(
      const EditorDOMPointBase<PT, CT>& aPoint) const;
  template <typename PT, typename CT>
  static WSScanResult ScanInclusiveNextVisibleNodeOrBlockBoundary(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const EditorDOMPointBase<PT, CT>& aPoint,
      const Element* aAncestorLimiter = nullptr) {
    return WSRunScanner(aOptions, aPoint, aAncestorLimiter)
        .ScanInclusiveNextVisibleNodeOrBlockBoundaryFrom(aPoint);
  }

  // ScanPreviousVisibleNodeOrBlockBoundaryFrom() returns the first visible node
  // before aPoint. If there is no visible nodes before aPoint, returns topmost
  // editable inline ancestor at start of current block.  See comments around
  // WSScanResult for the detail.  When you reach a character, this returns
  // WSScanResult whose Point_Deprecated() returns next point of the found
  // character and PointAtReachedContent() returns the point at found character.
  template <typename PT, typename CT>
  WSScanResult ScanPreviousVisibleNodeOrBlockBoundaryFrom(
      const EditorDOMPointBase<PT, CT>& aPoint) const;
  template <typename PT, typename CT>
  static WSScanResult ScanPreviousVisibleNodeOrBlockBoundary(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const EditorDOMPointBase<PT, CT>& aPoint,
      const Element* aAncestorLimiter = nullptr) {
    return WSRunScanner(aOptions, aPoint, aAncestorLimiter)
        .ScanPreviousVisibleNodeOrBlockBoundaryFrom(aPoint);
  }

  /**
   * Return a point in a `Text` node which is at current character or next
   * character if aPoint does not points a character or end of a `Text` node.
   */
  template <typename EditorDOMPointType, typename PT, typename CT>
  static EditorDOMPointType GetInclusiveNextCharPoint(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const EditorDOMPointBase<PT, CT>& aPoint,
      const Element* aAncestorLimiter = nullptr) {
    if (aPoint.IsInTextNode() && !aPoint.IsEndOfContainer() &&
        (!aOptions.contains(Option::OnlyEditableNodes) ||
         HTMLEditUtils::IsSimplyEditableNode(
             *aPoint.template ContainerAs<Text>()))) {
      return EditorDOMPointType(aPoint.template ContainerAs<Text>(),
                                aPoint.Offset());
    }
    return WSRunScanner(aOptions, aPoint, aAncestorLimiter)
        .GetInclusiveNextCharPoint<EditorDOMPointType>(aPoint);
  }

  /**
   * Return a point in a `Text` node which is before aPoint.
   */
  template <typename EditorDOMPointType, typename PT, typename CT>
  static EditorDOMPointType GetPreviousCharPoint(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const EditorDOMPointBase<PT, CT>& aPoint,
      const Element* aAncestorLimiter = nullptr) {
    if (aPoint.IsInTextNode() && !aPoint.IsStartOfContainer() &&
        (!aOptions.contains(Option::OnlyEditableNodes) ||
         HTMLEditUtils::IsSimplyEditableNode(
             *aPoint.template ContainerAs<Text>()))) {
      return EditorDOMPointType(aPoint.template ContainerAs<Text>(),
                                aPoint.Offset() - 1);
    }
    return WSRunScanner(aOptions, aPoint, aAncestorLimiter)
        .GetPreviousCharPoint<EditorDOMPointType>(aPoint);
  }

  /**
   * Scan aTextNode from end or start to find last or first visible things.
   * I.e., this returns a point immediately before or after invisible
   * white-spaces of aTextNode if aTextNode ends or begins with some invisible
   * white-spaces.
   * Note that the result may not be in different text node if aTextNode has
   * only invisible white-spaces and there is previous or next text node.
   */
  template <typename EditorDOMPointType>
  static EditorDOMPointType GetAfterLastVisiblePoint(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      Text& aTextNode, const Element* aAncestorLimiter = nullptr);
  template <typename EditorDOMPointType>
  static EditorDOMPointType GetFirstVisiblePoint(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      Text& aTextNode, const Element* aAncestorLimiter = nullptr);

  /**
   * GetRangeInTextNodesToForwardDeleteFrom() returns the range to remove
   * text when caret is at aPoint.
   */
  static Result<EditorDOMRangeInTexts, nsresult>
  GetRangeInTextNodesToForwardDeleteFrom(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const EditorDOMPoint& aPoint, const Element* aAncestorLimiter = nullptr);

  /**
   * GetRangeInTextNodesToBackspaceFrom() returns the range to remove text
   * when caret is at aPoint.
   */
  static Result<EditorDOMRangeInTexts, nsresult>
  GetRangeInTextNodesToBackspaceFrom(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const EditorDOMPoint& aPoint, const Element* aAncestorLimiter = nullptr);

  /**
   * GetRangesForDeletingAtomicContent() returns the range to delete
   * aAtomicContent.  If it's followed by invisible white-spaces, they will
   * be included into the range.
   */
  static EditorDOMRange GetRangesForDeletingAtomicContent(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const nsIContent& aAtomicContent,
      const Element* aAncestorLimiter = nullptr);

  /**
   * GetRangeForDeleteBlockElementBoundaries() returns a range starting from end
   * of aLeftBlockElement to start of aRightBlockElement and extend invisible
   * white-spaces around them.
   *
   * @param aLeftBlockElement   The block element which will be joined with
   *                            aRightBlockElement.
   * @param aRightBlockElement  The block element which will be joined with
   *                            aLeftBlockElement.  This must be an element
   *                            after aLeftBlockElement.
   * @param aPointContainingTheOtherBlock
   *                            When aRightBlockElement is an ancestor of
   *                            aLeftBlockElement, this must be set and the
   *                            container must be aRightBlockElement.
   *                            When aLeftBlockElement is an ancestor of
   *                            aRightBlockElement, this must be set and the
   *                            container must be aLeftBlockElement.
   *                            Otherwise, must not be set.
   */
  static EditorDOMRange GetRangeForDeletingBlockElementBoundaries(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const Element& aLeftBlockElement, const Element& aRightBlockElement,
      const EditorDOMPoint& aPointContainingTheOtherBlock,
      const Element* aAncestorLimiter = nullptr);

  /**
   * ShrinkRangeIfStartsFromOrEndsAfterAtomicContent() may shrink aRange if it
   * starts and/or ends with an atomic content, but the range boundary
   * is in adjacent text nodes.  Returns true if this modifies the range.
   */
  static Result<bool, nsresult> ShrinkRangeIfStartsFromOrEndsAfterAtomicContent(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      nsRange& aRange, const Element* aAncestorLimiter = nullptr);

  /**
   * GetRangeContainingInvisibleWhiteSpacesAtRangeBoundaries() returns
   * extended range if range boundaries of aRange are in invisible white-spaces.
   */
  static EditorDOMRange GetRangeContainingInvisibleWhiteSpacesAtRangeBoundaries(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const EditorDOMRange& aRange, const Element* aAncestorLimiter = nullptr);

  /**
   * GetPrecedingBRElementUnlessVisibleContentFound() scans a `<br>` element
   * backward, but stops scanning it if the scanner finds visible character
   * or something.  In other words, this method ignores only invisible
   * white-spaces between `<br>` element and aPoint.
   */
  template <typename EditorDOMPointType>
  MOZ_NEVER_INLINE_DEBUG static HTMLBRElement*
  GetPrecedingBRElementUnlessVisibleContentFound(
      Options aOptions,  // NOLINT(performance-unnecessary-value-param)
      const EditorDOMPointType& aPoint,
      const Element* aAncestorLimiter = nullptr) {
    MOZ_ASSERT(aPoint.IsSetAndValid());
    // XXX This method behaves differently even in similar point.
    //     If aPoint is in a text node following `<br>` element, reaches the
    //     `<br>` element when all characters between the `<br>` and
    //     aPoint are ASCII whitespaces.
    //     But if aPoint is not in a text node, e.g., at start of an inline
    //     element which is immediately after a `<br>` element, returns the
    //     `<br>` element even if there is no invisible white-spaces.
    if (aPoint.IsStartOfContainer()) {
      return nullptr;
    }
    // TODO: Scan for end boundary is redundant in this case, we should optimize
    //       it.
    TextFragmentData textFragmentData(aOptions, aPoint, aAncestorLimiter);
    return textFragmentData.StartsFromBRElement()
               ? textFragmentData.StartReasonBRElementPtr()
               : nullptr;
  }

  [[nodiscard]] constexpr Options ScanOptions() const {
    return mTextFragmentDataAtStart.ScanOptions();
  }
  [[nodiscard]] bool ReferredHTMLDefaultStyle() const {
    return mTextFragmentDataAtStart.ReferredHTMLDefaultStyle();
  }

  const EditorDOMPoint& ScanStartRef() const { return mScanStartPoint; }

 protected:
  using EditorType = EditorBase::EditorType;

  class TextFragmentData;

  // VisibleWhiteSpacesData represents 0 or more visible white-spaces.
  class MOZ_STACK_CLASS VisibleWhiteSpacesData final {
   public:
    bool IsInitialized() const {
      return mLeftWSType != WSType::NotInitialized ||
             mRightWSType != WSType::NotInitialized;
    }

    EditorDOMPoint StartRef() const { return mStartPoint; }
    EditorDOMPoint EndRef() const { return mEndPoint; }

    /**
     * Information why the white-spaces start from (i.e., this indicates the
     * previous content type of the fragment).
     */
    bool StartsFromNonCollapsibleCharacters() const {
      return mLeftWSType == WSType::NonCollapsibleCharacters;
    }
    [[nodiscard]] constexpr bool StartsFromSpecialContent() const {
      return mLeftWSType == WSType::SpecialContent;
    }
    [[nodiscard]] constexpr bool StartsFromEmptyInlineContainerElement() const {
      return mLeftWSType == WSType::EmptyInlineContainerElement;
    }
    bool StartsFromPreformattedLineBreak() const {
      return mLeftWSType == WSType::PreformattedLineBreak;
    }

    /**
     * Information why the white-spaces end by (i.e., this indicates the
     * next content type of the fragment).
     */
    bool EndsByNonCollapsibleCharacters() const {
      return mRightWSType == WSType::NonCollapsibleCharacters;
    }
    bool EndsByTrailingWhiteSpaces() const {
      return mRightWSType == WSType::TrailingWhiteSpaces;
    }
    [[nodiscard]] constexpr bool EndsBySpecialContent() const {
      return mRightWSType == WSType::SpecialContent;
    }
    [[nodiscard]] constexpr bool EndsByEmptyInlineContainerElement() const {
      return mRightWSType == WSType::EmptyInlineContainerElement;
    }
    bool EndsByBRElement() const { return mRightWSType == WSType::BRElement; }
    bool EndsByPreformattedLineBreak() const {
      return mRightWSType == WSType::PreformattedLineBreak;
    }
    bool EndsByBlockBoundary() const {
      return mRightWSType == WSType::CurrentBlockBoundary ||
             mRightWSType == WSType::OtherBlockBoundary;
    }
    bool EndsByInlineEditingHostBoundary() const {
      return mRightWSType == WSType::InlineEditingHostBoundary;
    }

    /**
     * ComparePoint() compares aPoint with the white-spaces.
     */
    enum class PointPosition {
      BeforeStartOfFragment,
      StartOfFragment,
      MiddleOfFragment,
      EndOfFragment,
      AfterEndOfFragment,
      NotInSameDOMTree,
    };
    template <typename EditorDOMPointType>
    PointPosition ComparePoint(const EditorDOMPointType& aPoint) const {
      MOZ_ASSERT(aPoint.IsSetAndValid());
      if (StartRef() == aPoint) {
        return PointPosition::StartOfFragment;
      }
      if (EndRef() == aPoint) {
        return PointPosition::EndOfFragment;
      }
      const bool startIsBeforePoint = StartRef().IsBefore(aPoint);
      const bool pointIsBeforeEnd = aPoint.IsBefore(EndRef());
      if (startIsBeforePoint && pointIsBeforeEnd) {
        return PointPosition::MiddleOfFragment;
      }
      if (startIsBeforePoint) {
        return PointPosition::AfterEndOfFragment;
      }
      if (pointIsBeforeEnd) {
        return PointPosition::BeforeStartOfFragment;
      }
      return PointPosition::NotInSameDOMTree;
    }

   private:
    // Initializers should be accessible only from `TextFragmentData`.
    friend class WSRunScanner::TextFragmentData;
    VisibleWhiteSpacesData()
        : mLeftWSType(WSType::NotInitialized),
          mRightWSType(WSType::NotInitialized) {}

    template <typename EditorDOMPointType>
    void SetStartPoint(const EditorDOMPointType& aStartPoint) {
      mStartPoint = aStartPoint;
    }
    template <typename EditorDOMPointType>
    void SetEndPoint(const EditorDOMPointType& aEndPoint) {
      mEndPoint = aEndPoint;
    }
    void SetStartFrom(WSType aLeftWSType) { mLeftWSType = aLeftWSType; }
    void SetStartFromLeadingWhiteSpaces() {
      mLeftWSType = WSType::LeadingWhiteSpaces;
    }
    void SetEndBy(WSType aRightWSType) { mRightWSType = aRightWSType; }
    void SetEndByTrailingWhiteSpaces() {
      mRightWSType = WSType::TrailingWhiteSpaces;
    }

    EditorDOMPoint mStartPoint;
    EditorDOMPoint mEndPoint;
    WSType mLeftWSType, mRightWSType;
  };

  using PointPosition = VisibleWhiteSpacesData::PointPosition;

  /**
   * Return aPoint if it points a character in a `Text` node, or start of next
   * `Text` node otherwise.
   * FYI: For the performance, this does not check whether given container is
   * not after mStart.mReasonContent or not.
   */
  template <typename EditorDOMPointType, typename PT, typename CT>
  EditorDOMPointType GetInclusiveNextCharPoint(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return TextFragmentDataAtStartRef()
        .GetInclusiveNextCharPoint<EditorDOMPointType>(
            aPoint, ShouldIgnoreNonEditableSiblingsOrDescendants(
                        mTextFragmentDataAtStart.ScanOptions()));
  }

  /**
   * Return the previous editable point in a `Text` node.  Note that this
   * returns the last character point when it meets non-empty text node,
   * otherwise, returns a point in an empty text node.
   * FYI: For the performance, this does not check whether given container is
   * not before mEnd.mReasonContent or not.
   */
  template <typename EditorDOMPointType, typename PT, typename CT>
  EditorDOMPointType GetPreviousCharPoint(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return TextFragmentDataAtStartRef()
        .GetPreviousCharPoint<EditorDOMPointType>(
            aPoint, ShouldIgnoreNonEditableSiblingsOrDescendants(
                        mTextFragmentDataAtStart.ScanOptions()));
  }

  /**
   * GetEndOfCollapsibleASCIIWhiteSpaces() returns the next visible char
   * (meaning a character except ASCII white-spaces) point or end of last text
   * node scanning from aPointAtASCIIWhiteSpace.
   * Note that this may return different text node from the container of
   * aPointAtASCIIWhiteSpace.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType GetEndOfCollapsibleASCIIWhiteSpaces(
      const EditorDOMPointInText& aPointAtASCIIWhiteSpace,
      nsIEditor::EDirection aDirectionToDelete) const {
    MOZ_ASSERT(aDirectionToDelete == nsIEditor::eNone ||
               aDirectionToDelete == nsIEditor::eNext ||
               aDirectionToDelete == nsIEditor::ePrevious);
    return TextFragmentDataAtStartRef()
        .GetEndOfCollapsibleASCIIWhiteSpaces<EditorDOMPointType>(
            aPointAtASCIIWhiteSpace, aDirectionToDelete);
  }

  /**
   * GetFirstASCIIWhiteSpacePointCollapsedTo() returns the first ASCII
   * white-space which aPointAtASCIIWhiteSpace belongs to.  In other words,
   * the white-space at aPointAtASCIIWhiteSpace should be collapsed into
   * the result.
   * Note that this may return different text node from the container of
   * aPointAtASCIIWhiteSpace.
   */
  template <typename EditorDOMPointType>
  EditorDOMPointType GetFirstASCIIWhiteSpacePointCollapsedTo(
      const EditorDOMPointInText& aPointAtASCIIWhiteSpace,
      nsIEditor::EDirection aDirectionToDelete) const {
    MOZ_ASSERT(aDirectionToDelete == nsIEditor::eNone ||
               aDirectionToDelete == nsIEditor::eNext ||
               aDirectionToDelete == nsIEditor::ePrevious);
    return TextFragmentDataAtStartRef()
        .GetFirstASCIIWhiteSpacePointCollapsedTo<EditorDOMPointType>(
            aPointAtASCIIWhiteSpace, aDirectionToDelete);
  }

  /**
   * TextFragmentData stores the information of white-space sequence which
   * contains `aPoint` of the constructor.
   */
  class MOZ_STACK_CLASS TextFragmentData final {
   private:
    class NoBreakingSpaceData;
    class MOZ_STACK_CLASS BoundaryData final {
     public:
      using NoBreakingSpaceData =
          WSRunScanner::TextFragmentData::NoBreakingSpaceData;

      /**
       * ScanCollapsibleWhiteSpaceStartFrom() returns start boundary data of
       * white-spaces containing aPoint.  When aPoint is in a text node and
       * points a non-white-space character or the text node is preformatted,
       * this returns the data at aPoint.
       *
       * @param aPoint            Scan start point.
       * @param aNBSPData         Optional.  If set, this recodes first and last
       *                          NBSP positions.
       */
      template <typename EditorDOMPointType>
      static BoundaryData ScanCollapsibleWhiteSpaceStartFrom(
          Options aOptions,  // NOLINT(performance-unnecessary-value-param)
          const EditorDOMPointType& aPoint, NoBreakingSpaceData* aNBSPData,
          const Element& aAncestorLimiter);

      /**
       * ScanCollapsibleWhiteSpaceEndFrom() returns end boundary data of
       * white-spaces containing aPoint.  When aPoint is in a text node and
       * points a non-white-space character or the text node is preformatted,
       * this returns the data at aPoint.
       *
       * @param aPoint            Scan start point.
       * @param aNBSPData         Optional.  If set, this recodes first and last
       *                          NBSP positions.
       */
      template <typename EditorDOMPointType>
      static BoundaryData ScanCollapsibleWhiteSpaceEndFrom(
          Options aOptions,  // NOLINT(performance-unnecessary-value-param)
          const EditorDOMPointType& aPoint, NoBreakingSpaceData* aNBSPData,
          const Element& aAncestorLimiter);

      BoundaryData() = default;
      template <typename EditorDOMPointType>
      BoundaryData(const EditorDOMPointType& aPoint, nsIContent& aReasonContent,
                   WSType aReason)
          : mReasonContent(&aReasonContent),
            mPoint(aPoint.template To<EditorDOMPoint>()),
            mReason(aReason) {}
      bool Initialized() const { return mReasonContent && mPoint.IsSet(); }

      nsIContent* GetReasonContent() const { return mReasonContent; }
      const EditorDOMPoint& PointRef() const { return mPoint; }
      WSType RawReason() const { return mReason; }

      bool IsNonCollapsibleCharacters() const {
        return mReason == WSType::NonCollapsibleCharacters;
      }
      [[nodiscard]] constexpr bool IsSpecialContent() const {
        return mReason == WSType::SpecialContent;
      }
      [[nodiscard]] constexpr bool IsEmptyInlineContainerElement() const {
        return mReason == WSType::EmptyInlineContainerElement;
      }
      bool IsBRElement() const { return mReason == WSType::BRElement; }
      bool IsPreformattedLineBreak() const {
        return mReason == WSType::PreformattedLineBreak;
      }
      bool IsCurrentBlockBoundary() const {
        return mReason == WSType::CurrentBlockBoundary;
      }
      bool IsOtherBlockBoundary() const {
        return mReason == WSType::OtherBlockBoundary;
      }
      bool IsBlockBoundary() const {
        return mReason == WSType::CurrentBlockBoundary ||
               mReason == WSType::OtherBlockBoundary;
      }
      bool IsInlineEditingHostBoundary() const {
        return mReason == WSType::InlineEditingHostBoundary;
      }
      bool IsHardLineBreak() const {
        return mReason == WSType::CurrentBlockBoundary ||
               mReason == WSType::OtherBlockBoundary ||
               mReason == WSType::BRElement ||
               mReason == WSType::PreformattedLineBreak;
      }
      MOZ_NEVER_INLINE_DEBUG Element* OtherBlockElementPtr() const {
        MOZ_DIAGNOSTIC_ASSERT(mReasonContent->IsElement());
        return mReasonContent->AsElement();
      }
      MOZ_NEVER_INLINE_DEBUG HTMLBRElement* BRElementPtr() const {
        MOZ_DIAGNOSTIC_ASSERT(mReasonContent->IsHTMLElement(nsGkAtoms::br));
        return static_cast<HTMLBRElement*>(mReasonContent.get());
      }

     private:
      /**
       * Helper methods of ScanCollapsibleWhiteSpaceStartFrom() and
       * ScanCollapsibleWhiteSpaceEndFrom() when they need to scan in a text
       * node.
       */
      template <typename EditorDOMPointType>
      static Maybe<BoundaryData> ScanCollapsibleWhiteSpaceStartInTextNode(
          const EditorDOMPointType& aPoint, NoBreakingSpaceData* aNBSPData);
      template <typename EditorDOMPointType>
      static Maybe<BoundaryData> ScanCollapsibleWhiteSpaceEndInTextNode(
          const EditorDOMPointType& aPoint, NoBreakingSpaceData* aNBSPData);

      nsCOMPtr<nsIContent> mReasonContent;
      EditorDOMPoint mPoint;
      // Must be one of WSType::NotInitialized,
      // WSType::NonCollapsibleCharacters, WSType::SpecialContent,
      // WSType::EmptyInlineContainerElement, WSType::BRElement,
      // WSType::CurrentBlockBoundary, WSType::OtherBlockBoundary or
      // WSType::InlineEditingHostBoundary.
      WSType mReason = WSType::NotInitialized;
    };

    class MOZ_STACK_CLASS NoBreakingSpaceData final {
     public:
      enum class Scanning { Forward, Backward };
      void NotifyNBSP(const EditorDOMPointInText& aPoint,
                      Scanning aScanningDirection) {
        MOZ_ASSERT(aPoint.IsSetAndValid());
        MOZ_ASSERT(aPoint.IsCharNBSP());
        if (!mFirst.IsSet() || aScanningDirection == Scanning::Backward) {
          mFirst = aPoint;
        }
        if (!mLast.IsSet() || aScanningDirection == Scanning::Forward) {
          mLast = aPoint;
        }
      }

      const EditorDOMPointInText& FirstPointRef() const { return mFirst; }
      const EditorDOMPointInText& LastPointRef() const { return mLast; }

      bool FoundNBSP() const {
        MOZ_ASSERT(mFirst.IsSet() == mLast.IsSet());
        return mFirst.IsSet();
      }

     private:
      EditorDOMPointInText mFirst;
      EditorDOMPointInText mLast;
    };

   public:
    TextFragmentData() = delete;

    /**
     * If aScanMode is Scan::EditableNodes and aPoint is in an editable node,
     * this scans only in the editing host.  Therefore, it's same as that
     * aAncestorLimiter is specified to the editing host.
     */
    template <typename EditorDOMPointType>
    TextFragmentData(
        Options aOptions,  // NOLINT(performance-unnecessary-value-param)
        const EditorDOMPointType& aPoint,
        const Element* aAncestorLimiter = nullptr);

    bool IsInitialized() const {
      return mStart.Initialized() && mEnd.Initialized();
    }

    [[nodiscard]] constexpr Options ScanOptions() const { return mOptions; }
    [[nodiscard]] bool ReferredHTMLDefaultStyle() const {
      return mOptions.contains(Option::ReferHTMLDefaultStyle);
    }

    const Element* GetAncestorLimiter() const { return mAncestorLimiter; }

    nsIContent* GetStartReasonContent() const {
      return mStart.GetReasonContent();
    }
    nsIContent* GetEndReasonContent() const { return mEnd.GetReasonContent(); }

    bool StartsFromNonCollapsibleCharacters() const {
      return mStart.IsNonCollapsibleCharacters();
    }
    [[nodiscard]] bool StartsFromSpecialContent() const {
      return mStart.IsSpecialContent();
    }
    [[nodiscard]] bool StartsFromEmptyInlineContainerElement() const {
      return mStart.IsEmptyInlineContainerElement();
    }
    bool StartsFromBRElement() const { return mStart.IsBRElement(); }
    bool StartsFromBRElementNotFollowedByBlockBoundary() const {
      return StartsFromBRElement() &&
             !HTMLEditUtils::IsBRElementFollowedByBlockBoundary(
                 static_cast<HTMLBRElement&>(*GetStartReasonContent()));
    }
    bool StartsFromBRElementFollowedByBlockBoundary() const {
      return StartsFromBRElement() &&
             HTMLEditUtils::IsBRElementFollowedByBlockBoundary(
                 static_cast<HTMLBRElement&>(*GetStartReasonContent()));
    }
    bool StartsFromPreformattedLineBreak() const {
      return mStart.IsPreformattedLineBreak();
    }
    bool StartsFromCurrentBlockBoundary() const {
      return mStart.IsCurrentBlockBoundary();
    }
    bool StartsFromOtherBlockElement() const {
      return mStart.IsOtherBlockBoundary();
    }
    bool StartsFromBlockBoundary() const { return mStart.IsBlockBoundary(); }
    bool StartsFromInlineEditingHostBoundary() const {
      return mStart.IsInlineEditingHostBoundary();
    }
    bool StartsFromHardLineBreak() const { return mStart.IsHardLineBreak(); }
    bool EndsByNonCollapsibleCharacters() const {
      return mEnd.IsNonCollapsibleCharacters();
    }
    [[nodiscard]] bool EndsBySpecialContent() const {
      return mEnd.IsSpecialContent();
    }
    [[nodiscard]] bool EndsByEmptyInlineContainerElement() const {
      return mEnd.IsEmptyInlineContainerElement();
    }
    bool EndsByBRElement() const { return mEnd.IsBRElement(); }
    bool EndsByBRElementNotFollowedByBlockBoundary() const {
      return EndsByBRElement() &&
             !HTMLEditUtils::IsBRElementFollowedByBlockBoundary(
                 static_cast<HTMLBRElement&>(*GetEndReasonContent()));
    }
    bool EndsByBRElementFollowedByBlockBoundary() const {
      return EndsByBRElement() &&
             HTMLEditUtils::IsBRElementFollowedByBlockBoundary(
                 static_cast<HTMLBRElement&>(*GetEndReasonContent()));
    }
    bool EndsByPreformattedLineBreak() const {
      return mEnd.IsPreformattedLineBreak();
    }
    bool EndsByPreformattedLineBreakFollowedByBlockBoundary() const {
      return mEnd.IsPreformattedLineBreak() &&
             HTMLEditUtils::IsPreformattedLineBreakFollowedByBlockBoundary(
                 mEnd.PointRef(), HTMLEditUtils::SkipWhiteSpaceStyleCheck::Yes);
    }
    bool EndsByCurrentBlockBoundary() const {
      return mEnd.IsCurrentBlockBoundary();
    }
    bool EndsByOtherBlockElement() const { return mEnd.IsOtherBlockBoundary(); }
    bool EndsByBlockBoundary() const { return mEnd.IsBlockBoundary(); }
    bool EndsByInlineEditingHostBoundary() const {
      return mEnd.IsInlineEditingHostBoundary();
    }

    WSType StartRawReason() const { return mStart.RawReason(); }
    WSType EndRawReason() const { return mEnd.RawReason(); }

    MOZ_NEVER_INLINE_DEBUG Element* StartReasonOtherBlockElementPtr() const {
      return mStart.OtherBlockElementPtr();
    }
    MOZ_NEVER_INLINE_DEBUG HTMLBRElement* StartReasonBRElementPtr() const {
      return mStart.BRElementPtr();
    }
    MOZ_NEVER_INLINE_DEBUG Element* EndReasonOtherBlockElementPtr() const {
      return mEnd.OtherBlockElementPtr();
    }
    MOZ_NEVER_INLINE_DEBUG HTMLBRElement* EndReasonBRElementPtr() const {
      return mEnd.BRElementPtr();
    }

    const EditorDOMPoint& StartRef() const { return mStart.PointRef(); }
    const EditorDOMPoint& EndRef() const { return mEnd.PointRef(); }

    const EditorDOMPoint& ScanStartRef() const { return mScanStartPoint; }

    bool FoundNoBreakingWhiteSpaces() const { return mNBSPData.FoundNBSP(); }
    const EditorDOMPointInText& FirstNBSPPointRef() const {
      return mNBSPData.FirstPointRef();
    }
    const EditorDOMPointInText& LastNBSPPointRef() const {
      return mNBSPData.LastPointRef();
    }

    /**
     * Return inclusive next point in inclusive next `Text` node from aPoint.
     * So, it may be in a collapsed white-space or invisible white-spaces.
     * NOTE: Option::OnlyEditableNodes is ignored because it's treated as "stop
     * at non-editable content" in the other places, but this "ignores" them.
     */
    template <typename EditorDOMPointType, typename PT, typename CT>
    [[nodiscard]] static EditorDOMPointType GetInclusiveNextCharPoint(
        const EditorDOMPointBase<PT, CT>& aPoint,
        Options aOptions,  // NOLINT(performance-unnecessary-value-param)
        IgnoreNonEditableNodes aIgnoreNonEditableNodes,
        const nsIContent* aFollowingLimiterContent = nullptr);

    template <typename EditorDOMPointType, typename PT, typename CT>
    [[nodiscard]] EditorDOMPointType GetInclusiveNextCharPoint(
        const EditorDOMPointBase<PT, CT>& aPoint,
        IgnoreNonEditableNodes aIgnoreNonEditableNodes) const {
      return GetInclusiveNextCharPoint<EditorDOMPointType>(
          aPoint, mOptions, aIgnoreNonEditableNodes, GetEndReasonContent());
    }

    /**
     * Return previous point in inclusive previous `Text` node from aPoint.
     * So, it may be in a collapsed white-space or invisible white-spaces.
     * NOTE: Option::OnlyEditableNodes is ignored because it's treated as "stop
     * at non-editable content" in the other places, but this "ignores" them.
     */
    template <typename EditorDOMPointType, typename PT, typename CT>
    [[nodiscard]] static EditorDOMPointType GetPreviousCharPoint(
        const EditorDOMPointBase<PT, CT>& aPoint,
        Options aOptions,  // NOLINT(performance-unnecessary-value-param)
        IgnoreNonEditableNodes aIgnoreNonEditableNodes,
        const nsIContent* aPrecedingLimiterContent = nullptr);

    template <typename EditorDOMPointType, typename PT, typename CT>
    [[nodiscard]] EditorDOMPointType GetPreviousCharPoint(
        const EditorDOMPointBase<PT, CT>& aPoint,
        IgnoreNonEditableNodes aIgnoreNonEditableNodes) const {
      return GetPreviousCharPoint<EditorDOMPointType>(
          aPoint, mOptions, aIgnoreNonEditableNodes, GetStartReasonContent());
    }

    /**
     * Return end of current collapsible ASCII white-spaces.
     * NOTE: Option::OnlyEditableNodes is ignored because it's treated as "stop
     * at non-editable content" in the other places, but this "ignores" them.
     *
     * @param aPointAtASCIIWhiteSpace   Must be in a sequence of collapsible
     *                                  ASCII white-spaces.
     * @param aDirectionToDelete        The direction to delete.
     */
    template <typename EditorDOMPointType>
    [[nodiscard]] static EditorDOMPointType GetEndOfCollapsibleASCIIWhiteSpaces(
        const EditorDOMPointInText& aPointAtASCIIWhiteSpace,
        nsIEditor::EDirection aDirectionToDelete,
        Options aOptions,  // NOLINT(performance-unnecessary-value-param)
        IgnoreNonEditableNodes aIgnoreNonEditableNodes,
        const nsIContent* aFollowingLimiterContent = nullptr);

    template <typename EditorDOMPointType>
    [[nodiscard]] EditorDOMPointType GetEndOfCollapsibleASCIIWhiteSpaces(
        const EditorDOMPointInText& aPointAtASCIIWhiteSpace,
        nsIEditor::EDirection aDirectionToDelete,
        IgnoreNonEditableNodes aIgnoreNonEditableNodes) const {
      return GetEndOfCollapsibleASCIIWhiteSpaces<EditorDOMPointType>(
          aPointAtASCIIWhiteSpace, aDirectionToDelete, mOptions,
          aIgnoreNonEditableNodes, GetEndReasonContent());
    }

    /**
     * Return start of current collapsible ASCII white-spaces.
     * NOTE: Option::OnlyEditableNodes is ignored because it's treated as "stop
     * at non-editable content" in the other places, but this "ignores" them.
     *
     * @param aPointAtASCIIWhiteSpace   Must be in a sequence of collapsible
     *                                  ASCII white-spaces.
     * @param aDirectionToDelete        The direction to delete.
     */
    template <typename EditorDOMPointType>
    [[nodiscard]] static EditorDOMPointType
    GetFirstASCIIWhiteSpacePointCollapsedTo(
        const EditorDOMPointInText& aPointAtASCIIWhiteSpace,
        nsIEditor::EDirection aDirectionToDelete,
        Options aOptions,  // NOLINT(performance-unnecessary-value-param)
        IgnoreNonEditableNodes aIgnoreNonEditableNodes,
        const nsIContent* aPrecedingLimiterContent = nullptr);

    template <typename EditorDOMPointType>
    [[nodiscard]] EditorDOMPointType GetFirstASCIIWhiteSpacePointCollapsedTo(
        const EditorDOMPointInText& aPointAtASCIIWhiteSpace,
        nsIEditor::EDirection aDirectionToDelete,
        IgnoreNonEditableNodes aIgnoreNonEditableNodes) const {
      return GetFirstASCIIWhiteSpacePointCollapsedTo<EditorDOMPointType>(
          aPointAtASCIIWhiteSpace, aDirectionToDelete, mOptions,
          aIgnoreNonEditableNodes, GetStartReasonContent());
    }

    /**
     * GetNonCollapsedRangeInTexts() returns non-empty range in texts which
     * is the largest range in aRange if there is some text nodes.
     */
    EditorDOMRangeInTexts GetNonCollapsedRangeInTexts(
        const EditorDOMRange& aRange) const;

    /**
     * InvisibleLeadingWhiteSpaceRangeRef() retruns reference to two DOM points,
     * start of the line and first visible point or end of the hard line.  When
     * this returns non-positioned range or positioned but collapsed range,
     * there is no invisible leading white-spaces.
     * Note that if there are only invisible white-spaces in a hard line,
     * this returns all of the white-spaces.
     */
    const EditorDOMRange& InvisibleLeadingWhiteSpaceRangeRef() const;

    /**
     * InvisibleTrailingWhiteSpaceRangeRef() returns reference to two DOM
     * points, first invisible white-space and end of the hard line.  When this
     * returns non-positioned range or positioned but collapsed range,
     * there is no invisible trailing white-spaces.
     * Note that if there are only invisible white-spaces in a hard line,
     * this returns all of the white-spaces.
     */
    const EditorDOMRange& InvisibleTrailingWhiteSpaceRangeRef() const;

    /**
     * GetNewInvisibleLeadingWhiteSpaceRangeIfSplittingAt() returns new
     * invisible leading white-space range which should be removed if
     * splitting invisible white-space sequence at aPointToSplit creates
     * new invisible leading white-spaces in the new line.
     * Note that the result may be collapsed range if the point is around
     * invisible white-spaces.
     */
    template <typename EditorDOMPointType>
    EditorDOMRange GetNewInvisibleLeadingWhiteSpaceRangeIfSplittingAt(
        const EditorDOMPointType& aPointToSplit) const {
      // If there are invisible trailing white-spaces and some or all of them
      // become invisible leading white-spaces in the new line, although we
      // don't need to delete them, but for aesthetically and backward
      // compatibility, we should remove them.
      const EditorDOMRange& trailingWhiteSpaceRange =
          InvisibleTrailingWhiteSpaceRangeRef();
      // XXX Why don't we check leading white-spaces too?
      if (!trailingWhiteSpaceRange.IsPositioned()) {
        return trailingWhiteSpaceRange;
      }
      // If the point is before the trailing white-spaces, the new line won't
      // start with leading white-spaces.
      if (aPointToSplit.IsBefore(trailingWhiteSpaceRange.StartRef())) {
        return EditorDOMRange();
      }
      // If the point is in the trailing white-spaces, the new line may
      // start with some leading white-spaces.  Returning collapsed range
      // is intentional because the caller may want to know whether the
      // point is in trailing white-spaces or not.
      if (aPointToSplit.EqualsOrIsBefore(trailingWhiteSpaceRange.EndRef())) {
        return EditorDOMRange(trailingWhiteSpaceRange.StartRef(),
                              aPointToSplit);
      }
      // Otherwise, if the point is after the trailing white-spaces, it may
      // be just outside of the text node.  E.g., end of parent element.
      // This is possible case but the validation cost is not worthwhile
      // due to the runtime cost in the worst case.  Therefore, we should just
      // return collapsed range at the end of trailing white-spaces.  Then,
      // callers can know the point is immediately after the trailing
      // white-spaces.
      return EditorDOMRange(trailingWhiteSpaceRange.EndRef());
    }

    /**
     * GetNewInvisibleTrailingWhiteSpaceRangeIfSplittingAt() returns new
     * invisible trailing white-space range which should be removed if
     * splitting invisible white-space sequence at aPointToSplit creates
     * new invisible trailing white-spaces in the new line.
     * Note that the result may be collapsed range if the point is around
     * invisible white-spaces.
     */
    template <typename EditorDOMPointType>
    EditorDOMRange GetNewInvisibleTrailingWhiteSpaceRangeIfSplittingAt(
        const EditorDOMPointType& aPointToSplit) const {
      // If there are invisible leading white-spaces and some or all of them
      // become end of current line, they will become visible.  Therefore, we
      // need to delete the invisible leading white-spaces before insertion
      // point.
      const EditorDOMRange& leadingWhiteSpaceRange =
          InvisibleLeadingWhiteSpaceRangeRef();
      if (!leadingWhiteSpaceRange.IsPositioned()) {
        return leadingWhiteSpaceRange;
      }
      // If the point equals or is after the leading white-spaces, the line
      // will end without trailing white-spaces.
      if (leadingWhiteSpaceRange.EndRef().IsBefore(aPointToSplit)) {
        return EditorDOMRange();
      }
      // If the point is in the leading white-spaces, the line may
      // end with some trailing white-spaces.  Returning collapsed range
      // is intentional because the caller may want to know whether the
      // point is in leading white-spaces or not.
      if (leadingWhiteSpaceRange.StartRef().EqualsOrIsBefore(aPointToSplit)) {
        return EditorDOMRange(aPointToSplit, leadingWhiteSpaceRange.EndRef());
      }
      // Otherwise, if the point is before the leading white-spaces, it may
      // be just outside of the text node.  E.g., start of parent element.
      // This is possible case but the validation cost is not worthwhile
      // due to the runtime cost in the worst case.  Therefore, we should
      // just return collapsed range at start of the leading white-spaces.
      // Then, callers can know the point is immediately before the leading
      // white-spaces.
      return EditorDOMRange(leadingWhiteSpaceRange.StartRef());
    }

    /**
     * FollowingContentMayBecomeFirstVisibleContent() returns true if some
     * content may be first visible content after removing content after aPoint.
     * Note that it's completely broken what this does.  Don't use this method
     * with new code.
     */
    template <typename EditorDOMPointType>
    bool FollowingContentMayBecomeFirstVisibleContent(
        const EditorDOMPointType& aPoint) const {
      MOZ_ASSERT(aPoint.IsSetAndValid());
      if (!mStart.IsHardLineBreak() && !mStart.IsInlineEditingHostBoundary()) {
        return false;
      }
      // If the point is before start of text fragment, that means that the
      // point may be at the block boundary or inline element boundary.
      if (aPoint.EqualsOrIsBefore(mStart.PointRef())) {
        return true;
      }
      // VisibleWhiteSpacesData is marked as start of line only when it
      // represents leading white-spaces.
      const EditorDOMRange& leadingWhiteSpaceRange =
          InvisibleLeadingWhiteSpaceRangeRef();
      if (!leadingWhiteSpaceRange.StartRef().IsSet()) {
        return false;
      }
      if (aPoint.EqualsOrIsBefore(leadingWhiteSpaceRange.StartRef())) {
        return true;
      }
      if (!leadingWhiteSpaceRange.EndRef().IsSet()) {
        return false;
      }
      return aPoint.EqualsOrIsBefore(leadingWhiteSpaceRange.EndRef());
    }

    /**
     * PrecedingContentMayBecomeInvisible() returns true if end of preceding
     * content is collapsed (when ends with an ASCII white-space).
     * Note that it's completely broken what this does.  Don't use this method
     * with new code.
     */
    template <typename EditorDOMPointType>
    bool PrecedingContentMayBecomeInvisible(
        const EditorDOMPointType& aPoint) const {
      MOZ_ASSERT(aPoint.IsSetAndValid());
      // If this fragment is ends by block boundary, always the caller needs
      // additional check.
      if (mEnd.IsBlockBoundary() || mEnd.IsInlineEditingHostBoundary()) {
        return true;
      }

      // If the point is in visible white-spaces and ends with an ASCII
      // white-space, it may be collapsed even if it won't be end of line.
      const VisibleWhiteSpacesData& visibleWhiteSpaces =
          VisibleWhiteSpacesDataRef();
      if (!visibleWhiteSpaces.IsInitialized()) {
        return false;
      }
      // XXX Odd case, but keep traditional behavior of `FindNearestRun()`.
      if (!visibleWhiteSpaces.StartRef().IsSet()) {
        return true;
      }
      if (!visibleWhiteSpaces.StartRef().EqualsOrIsBefore(aPoint)) {
        return false;
      }
      // XXX Odd case, but keep traditional behavior of `FindNearestRun()`.
      if (visibleWhiteSpaces.EndsByTrailingWhiteSpaces()) {
        return true;
      }
      // XXX Must be a bug.  This claims that the caller needs additional
      // check even when there is no white-spaces.
      if (visibleWhiteSpaces.StartRef() == visibleWhiteSpaces.EndRef()) {
        return true;
      }
      return aPoint.IsBefore(visibleWhiteSpaces.EndRef());
    }

    /**
     * GetPreviousNBSPPointIfNeedToReplaceWithASCIIWhiteSpace() may return an
     * NBSP point which should be replaced with an ASCII white-space when we're
     * inserting text into aPointToInsert. Note that this is a helper method for
     * the traditional white-space normalizer.  Don't use this with the new
     * white-space normalizer.
     * Must be called only when VisibleWhiteSpacesDataRef() returns initialized
     * instance and previous character of aPointToInsert is in the range.
     */
    EditorDOMPointInText GetPreviousNBSPPointIfNeedToReplaceWithASCIIWhiteSpace(
        const EditorDOMPoint& aPointToInsert) const;

    /**
     * GetInclusiveNextNBSPPointIfNeedToReplaceWithASCIIWhiteSpace() may return
     * an NBSP point which should be replaced with an ASCII white-space when
     * the caller inserts text into aPointToInsert.
     * Note that this is a helper method for the traditional white-space
     * normalizer.  Don't use this with the new white-space normalizer.
     * Must be called only when VisibleWhiteSpacesDataRef() returns initialized
     * instance, and inclusive next char of aPointToInsert is in the range.
     */
    EditorDOMPointInText
    GetInclusiveNextNBSPPointIfNeedToReplaceWithASCIIWhiteSpace(
        const EditorDOMPoint& aPointToInsert) const;

    /**
     * GetReplaceRangeDataAtEndOfDeletionRange() and
     * GetReplaceRangeDataAtStartOfDeletionRange() return delete range if
     * end or start of deleting range splits invisible trailing/leading
     * white-spaces and it may become visible, or return replace range if
     * end or start of deleting range splits visible white-spaces and it
     * causes some ASCII white-spaces become invisible unless replacing
     * with an NBSP.
     */
    ReplaceRangeData GetReplaceRangeDataAtEndOfDeletionRange(
        const TextFragmentData& aTextFragmentDataAtStartToDelete) const;
    ReplaceRangeData GetReplaceRangeDataAtStartOfDeletionRange(
        const TextFragmentData& aTextFragmentDataAtEndToDelete) const;

    /**
     * VisibleWhiteSpacesDataRef() returns reference to visible white-spaces
     * data. That is zero or more white-spaces which are visible.
     * Note that when there is no visible content, it's not initialized.
     * Otherwise, even if there is no white-spaces, it's initialized and
     * the range is collapsed in such case.
     */
    const VisibleWhiteSpacesData& VisibleWhiteSpacesDataRef() const;

   private:
    EditorDOMPoint mScanStartPoint;
    RefPtr<const Element> mAncestorLimiter;
    BoundaryData mStart;
    BoundaryData mEnd;
    NoBreakingSpaceData mNBSPData;
    mutable Maybe<EditorDOMRange> mLeadingWhiteSpaceRange;
    mutable Maybe<EditorDOMRange> mTrailingWhiteSpaceRange;
    mutable Maybe<VisibleWhiteSpacesData> mVisibleWhiteSpacesData;
    const Options mOptions;
  };

  const TextFragmentData& TextFragmentDataAtStartRef() const {
    return mTextFragmentDataAtStart;
  }

  // The node passed to our constructor.
  EditorDOMPoint mScanStartPoint;
  // Together, the above represent the point at which we are building up ws
  // info.

 private:
  /**
   * ComputeRangeInTextNodesContainingInvisibleWhiteSpaces() returns range
   * containing invisible white-spaces if deleting between aStart and aEnd
   * causes them become visible.
   *
   * @param aStart      TextFragmentData at start of deleting range.
   *                    This must be initialized with DOM point in a text node.
   * @param aEnd        TextFragmentData at end of deleting range.
   *                    This must be initialized with DOM point in a text node.
   */
  static EditorDOMRangeInTexts
  ComputeRangeInTextNodesContainingInvisibleWhiteSpaces(
      const TextFragmentData& aStart, const TextFragmentData& aEnd);

  TextFragmentData mTextFragmentDataAtStart;

  friend class WhiteSpaceVisibilityKeeper;
  friend class WSScanResult;
};

inline void WSScanResult::MaybeSetEditingHost(const WSRunScanner& aScanner) {
  if (!mContent ||
      aScanner.ScanOptions().contains(
          WSRunScanner::Option::OnlyEditableNodes) ||
      MOZ_UNLIKELY(!aScanner.mScanStartPoint.IsInContentNode()) ||
      !HTMLEditUtils::IsSimplyEditableNode(
          *aScanner.mScanStartPoint.GetContainer())) {
    return;
  }
  Element* const editingHost =
      aScanner.mScanStartPoint.ContainerAs<nsIContent>()->GetEditingHost();
  if (editingHost) {
    Element* const contentEditingHost = mContent->GetEditingHost();
    if (editingHost != contentEditingHost) {
      mEditingHost = editingHost;
    }
  }
}

}  // namespace mozilla

#endif  // #ifndef WSRunScanner_h
