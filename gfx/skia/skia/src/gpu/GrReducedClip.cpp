/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrReducedClip.h"

#include "GrAppliedClip.h"
#include "GrClip.h"
#include "GrColor.h"
#include "GrContextPriv.h"
#include "GrDrawContext.h"
#include "GrDrawContextPriv.h"
#include "GrDrawingManager.h"
#include "GrFixedClip.h"
#include "GrPathRenderer.h"
#include "GrStyle.h"
#include "GrUserStencilSettings.h"

typedef SkClipStack::Element Element;

/**
 * There are plenty of optimizations that could be added here. Maybe flips could be folded into
 * earlier operations. Or would inserting flips and reversing earlier ops ever be a win? Perhaps
 * for the case where the bounds are kInsideOut_BoundsType. We could restrict earlier operations
 * based on later intersect operations, and perhaps remove intersect-rects. We could optionally
 * take a rect in case the caller knows a bound on what is to be drawn through this clip.
 */
GrReducedClip::GrReducedClip(const SkClipStack& stack, const SkRect& queryBounds,
                             int maxWindowRectangles) {
    SkASSERT(!queryBounds.isEmpty());
    fHasIBounds = false;

    if (stack.isWideOpen()) {
        fInitialState = InitialState::kAllIn;
        return;
    }

    SkClipStack::BoundsType stackBoundsType;
    SkRect stackBounds;
    bool iior;
    stack.getBounds(&stackBounds, &stackBoundsType, &iior);

    if (stackBounds.isEmpty() || GrClip::IsOutsideClip(stackBounds, queryBounds)) {
        bool insideOut = SkClipStack::kInsideOut_BoundsType == stackBoundsType;
        fInitialState = insideOut ? InitialState::kAllIn : InitialState::kAllOut;
        return;
    }

    if (iior) {
        // "Is intersection of rects" means the clip is a single rect indicated by the stack bounds.
        // This should only be true if aa/non-aa status matches among all elements.
        SkASSERT(SkClipStack::kNormal_BoundsType == stackBoundsType);
        SkClipStack::Iter iter(stack, SkClipStack::Iter::kTop_IterStart);
        if (!iter.prev()->isAA() || GrClip::IsPixelAligned(stackBounds)) {
            // The clip is a non-aa rect. This is the one spot where we can actually implement the
            // clip (using fIBounds) rather than just telling the caller what it should be.
            stackBounds.round(&fIBounds);
            fHasIBounds = true;
            fInitialState = fIBounds.isEmpty() ? InitialState::kAllOut : InitialState::kAllIn;
            return;
        }
        if (GrClip::IsInsideClip(stackBounds, queryBounds)) {
            fInitialState = InitialState::kAllIn;
            return;
        }

        SkRect tightBounds;
        SkAssertResult(tightBounds.intersect(stackBounds, queryBounds));
        fIBounds = GrClip::GetPixelIBounds(tightBounds);
        SkASSERT(!fIBounds.isEmpty()); // Empty should have been blocked by IsOutsideClip above.
        fHasIBounds = true;

        // Implement the clip with an AA rect element.
        fElements.addToHead(stackBounds, SkCanvas::kReplace_Op, true/*doAA*/);
        fElementsGenID = stack.getTopmostGenID();
        fRequiresAA = true;

        fInitialState = InitialState::kAllOut;
        return;
    }

    SkRect tighterQuery = queryBounds;
    if (SkClipStack::kNormal_BoundsType == stackBoundsType) {
        // Tighten the query by introducing a new clip at the stack's pixel boundaries. (This new
        // clip will be enforced by the scissor through fIBounds.)
        SkAssertResult(tighterQuery.intersect(GrClip::GetPixelBounds(stackBounds)));
    }

    fIBounds = GrClip::GetPixelIBounds(tighterQuery);
    SkASSERT(!fIBounds.isEmpty()); // Empty should have been blocked by IsOutsideClip above.
    fHasIBounds = true;

    // Now that we have determined the bounds to use and filtered out the trivial cases, call the
    // helper that actually walks the stack.
    this->walkStack(stack, tighterQuery, maxWindowRectangles);

    if (fWindowRects.count() < maxWindowRectangles) {
        this->addInteriorWindowRectangles(maxWindowRectangles);
    }
}

void GrReducedClip::walkStack(const SkClipStack& stack, const SkRect& queryBounds,
                              int maxWindowRectangles) {
    // walk backwards until we get to:
    //  a) the beginning
    //  b) an operation that is known to make the bounds all inside/outside
    //  c) a replace operation

    enum class InitialTriState {
        kUnknown = -1,
        kAllIn = (int)GrReducedClip::InitialState::kAllIn,
        kAllOut = (int)GrReducedClip::InitialState::kAllOut
    } initialTriState = InitialTriState::kUnknown;

    // During our backwards walk, track whether we've seen ops that either grow or shrink the clip.
    // TODO: track these per saved clip so that we can consider them on the forward pass.
    bool embiggens = false;
    bool emsmallens = false;

    // We use a slightly relaxed set of query bounds for element containment tests. This is to
    // account for floating point rounding error that may have occurred during coord transforms.
    SkRect relaxedQueryBounds = queryBounds.makeInset(GrClip::kBoundsTolerance,
                                                      GrClip::kBoundsTolerance);

    SkClipStack::Iter iter(stack, SkClipStack::Iter::kTop_IterStart);
    int numAAElements = 0;
    while (InitialTriState::kUnknown == initialTriState) {
        const Element* element = iter.prev();
        if (nullptr == element) {
            initialTriState = InitialTriState::kAllIn;
            break;
        }
        if (SkClipStack::kEmptyGenID == element->getGenID()) {
            initialTriState = InitialTriState::kAllOut;
            break;
        }
        if (SkClipStack::kWideOpenGenID == element->getGenID()) {
            initialTriState = InitialTriState::kAllIn;
            break;
        }

        bool skippable = false;
        bool isFlip = false; // does this op just flip the in/out state of every point in the bounds

        switch (element->getOp()) {
            case SkCanvas::kDifference_Op:
                // check if the shape subtracted either contains the entire bounds (and makes
                // the clip empty) or is outside the bounds and therefore can be skipped.
                if (element->isInverseFilled()) {
                    if (element->contains(relaxedQueryBounds)) {
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        initialTriState = InitialTriState::kAllOut;
                        skippable = true;
                    }
                } else {
                    if (element->contains(relaxedQueryBounds)) {
                        initialTriState = InitialTriState::kAllOut;
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        skippable = true;
                    } else if (fWindowRects.count() < maxWindowRectangles && !embiggens &&
                               !element->isAA() && Element::kRect_Type == element->getType()) {
                        this->addWindowRectangle(element->getRect(), false);
                        skippable = true;
                    }
                }
                if (!skippable) {
                    emsmallens = true;
                }
                break;
            case SkCanvas::kIntersect_Op:
                // check if the shape intersected contains the entire bounds and therefore can
                // be skipped or it is outside the entire bounds and therefore makes the clip
                // empty.
                if (element->isInverseFilled()) {
                    if (element->contains(relaxedQueryBounds)) {
                        initialTriState = InitialTriState::kAllOut;
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        skippable = true;
                    }
                } else {
                    if (element->contains(relaxedQueryBounds)) {
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        initialTriState = InitialTriState::kAllOut;
                        skippable = true;
                    } else if (!embiggens && !element->isAA() &&
                               Element::kRect_Type == element->getType()) {
                        // fIBounds and queryBounds have already acccounted for this element via
                        // clip stack bounds; here we just apply the non-aa rounding effect.
                        SkIRect nonaaRect;
                        element->getRect().round(&nonaaRect);
                        if (!this->intersectIBounds(nonaaRect)) {
                            return;
                        }
                        skippable = true;
                    }
                }
                if (!skippable) {
                    emsmallens = true;
                }
                break;
            case SkCanvas::kUnion_Op:
                // If the union-ed shape contains the entire bounds then after this element
                // the bounds is entirely inside the clip. If the union-ed shape is outside the
                // bounds then this op can be skipped.
                if (element->isInverseFilled()) {
                    if (element->contains(relaxedQueryBounds)) {
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        initialTriState = InitialTriState::kAllIn;
                        skippable = true;
                    }
                } else {
                    if (element->contains(relaxedQueryBounds)) {
                        initialTriState = InitialTriState::kAllIn;
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        skippable = true;
                    }
                }
                if (!skippable) {
                    embiggens = true;
                }
                break;
            case SkCanvas::kXOR_Op:
                // If the bounds is entirely inside the shape being xor-ed then the effect is
                // to flip the inside/outside state of every point in the bounds. We may be
                // able to take advantage of this in the forward pass. If the xor-ed shape
                // doesn't intersect the bounds then it can be skipped.
                if (element->isInverseFilled()) {
                    if (element->contains(relaxedQueryBounds)) {
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        isFlip = true;
                    }
                } else {
                    if (element->contains(relaxedQueryBounds)) {
                        isFlip = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        skippable = true;
                    }
                }
                if (!skippable) {
                    emsmallens = embiggens = true;
                }
                break;
            case SkCanvas::kReverseDifference_Op:
                // When the bounds is entirely within the rev-diff shape then this behaves like xor
                // and reverses every point inside the bounds. If the shape is completely outside
                // the bounds then we know after this element is applied that the bounds will be
                // all outside the current clip.B
                if (element->isInverseFilled()) {
                    if (element->contains(relaxedQueryBounds)) {
                        initialTriState = InitialTriState::kAllOut;
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        isFlip = true;
                    }
                } else {
                    if (element->contains(relaxedQueryBounds)) {
                        isFlip = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        initialTriState = InitialTriState::kAllOut;
                        skippable = true;
                    }
                }
                if (!skippable) {
                    emsmallens = embiggens = true;
                }
                break;

            case SkCanvas::kReplace_Op:
                // Replace will always terminate our walk. We will either begin the forward walk
                // at the replace op or detect here than the shape is either completely inside
                // or completely outside the bounds. In this latter case it can be skipped by
                // setting the correct value for initialTriState.
                if (element->isInverseFilled()) {
                    if (element->contains(relaxedQueryBounds)) {
                        initialTriState = InitialTriState::kAllOut;
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        initialTriState = InitialTriState::kAllIn;
                        skippable = true;
                    }
                } else {
                    if (element->contains(relaxedQueryBounds)) {
                        initialTriState = InitialTriState::kAllIn;
                        skippable = true;
                    } else if (GrClip::IsOutsideClip(element->getBounds(), queryBounds)) {
                        initialTriState = InitialTriState::kAllOut;
                        skippable = true;
                    } else if (!embiggens && !element->isAA() &&
                               Element::kRect_Type == element->getType()) {
                        // fIBounds and queryBounds have already acccounted for this element via
                        // clip stack bounds; here we just apply the non-aa rounding effect.
                        SkIRect nonaaRect;
                        element->getRect().round(&nonaaRect);
                        if (!this->intersectIBounds(nonaaRect)) {
                            return;
                        }
                        initialTriState = InitialTriState::kAllIn;
                        skippable = true;
                    }
                }
                if (!skippable) {
                    initialTriState = InitialTriState::kAllOut;
                    embiggens = emsmallens = true;
                }
                break;
            default:
                SkDEBUGFAIL("Unexpected op.");
                break;
        }
        if (!skippable) {
            if (0 == fElements.count()) {
                // This will be the last element. Record the stricter genID.
                fElementsGenID = element->getGenID();
            }

            // if it is a flip, change it to a bounds-filling rect
            if (isFlip) {
                SkASSERT(SkCanvas::kXOR_Op == element->getOp() ||
                         SkCanvas::kReverseDifference_Op == element->getOp());
                fElements.addToHead(SkRect::Make(fIBounds), SkCanvas::kReverseDifference_Op, false);
            } else {
                Element* newElement = fElements.addToHead(*element);
                if (newElement->isAA()) {
                    ++numAAElements;
                }
                // Intersecting an inverse shape is the same as differencing the non-inverse shape.
                // Replacing with an inverse shape is the same as setting initialState=kAllIn and
                // differencing the non-inverse shape.
                bool isReplace = SkCanvas::kReplace_Op == newElement->getOp();
                if (newElement->isInverseFilled() &&
                    (SkCanvas::kIntersect_Op == newElement->getOp() || isReplace)) {
                    newElement->invertShapeFillType();
                    newElement->setOp(SkCanvas::kDifference_Op);
                    if (isReplace) {
                        SkASSERT(InitialTriState::kAllOut == initialTriState);
                        initialTriState = InitialTriState::kAllIn;
                    }
                }
            }
        }
    }

    if ((InitialTriState::kAllOut == initialTriState && !embiggens) ||
        (InitialTriState::kAllIn == initialTriState && !emsmallens)) {
        fElements.reset();
        numAAElements = 0;
    } else {
        Element* element = fElements.headIter().get();
        while (element) {
            bool skippable = false;
            switch (element->getOp()) {
                case SkCanvas::kDifference_Op:
                    // subtracting from the empty set yields the empty set.
                    skippable = InitialTriState::kAllOut == initialTriState;
                    break;
                case SkCanvas::kIntersect_Op:
                    // intersecting with the empty set yields the empty set
                    if (InitialTriState::kAllOut == initialTriState) {
                        skippable = true;
                    } else {
                        // We can clear to zero and then simply draw the clip element.
                        initialTriState = InitialTriState::kAllOut;
                        element->setOp(SkCanvas::kReplace_Op);
                    }
                    break;
                case SkCanvas::kUnion_Op:
                    if (InitialTriState::kAllIn == initialTriState) {
                        // unioning the infinite plane with anything is a no-op.
                        skippable = true;
                    } else {
                        // unioning the empty set with a shape is the shape.
                        element->setOp(SkCanvas::kReplace_Op);
                    }
                    break;
                case SkCanvas::kXOR_Op:
                    if (InitialTriState::kAllOut == initialTriState) {
                        // xor could be changed to diff in the kAllIn case, not sure it's a win.
                        element->setOp(SkCanvas::kReplace_Op);
                    }
                    break;
                case SkCanvas::kReverseDifference_Op:
                    if (InitialTriState::kAllIn == initialTriState) {
                        // subtracting the whole plane will yield the empty set.
                        skippable = true;
                        initialTriState = InitialTriState::kAllOut;
                    } else {
                        // this picks up flips inserted in the backwards pass.
                        skippable = element->isInverseFilled() ?
                            GrClip::IsOutsideClip(element->getBounds(), queryBounds) :
                            element->contains(relaxedQueryBounds);
                        if (skippable) {
                            initialTriState = InitialTriState::kAllIn;
                        } else {
                            element->setOp(SkCanvas::kReplace_Op);
                        }
                    }
                    break;
                case SkCanvas::kReplace_Op:
                    skippable = false; // we would have skipped it in the backwards walk if we
                                       // could've.
                    break;
                default:
                    SkDEBUGFAIL("Unexpected op.");
                    break;
            }
            if (!skippable) {
                break;
            } else {
                if (element->isAA()) {
                    --numAAElements;
                }
                fElements.popHead();
                element = fElements.headIter().get();
            }
        }
    }
    fRequiresAA = numAAElements > 0;

    SkASSERT(InitialTriState::kUnknown != initialTriState);
    fInitialState = static_cast<GrReducedClip::InitialState>(initialTriState);
}

static bool element_is_pure_subtract(SkCanvas::ClipOp op) {
    SkASSERT(op >= 0);
    return op <= SkCanvas::kIntersect_Op;

    GR_STATIC_ASSERT(0 == SkCanvas::kDifference_Op);
    GR_STATIC_ASSERT(1 == SkCanvas::kIntersect_Op);
}

void GrReducedClip::addInteriorWindowRectangles(int maxWindowRectangles) {
    SkASSERT(fWindowRects.count() < maxWindowRectangles);
    // Walk backwards through the element list and add window rectangles to the interiors of
    // "difference" elements. Quit if we encounter an element that may grow the clip.
    ElementList::Iter iter(fElements, ElementList::Iter::kTail_IterStart);
    for (; iter.get() && element_is_pure_subtract(iter.get()->getOp()); iter.prev()) {
        const Element* element = iter.get();
        if (SkCanvas::kDifference_Op != element->getOp()) {
            continue;
        }

        if (Element::kRect_Type == element->getType()) {
            SkASSERT(element->isAA());
            this->addWindowRectangle(element->getRect(), true);
            if (fWindowRects.count() >= maxWindowRectangles) {
                return;
            }
            continue;
        }

        if (Element::kRRect_Type == element->getType()) {
            // For round rects we add two overlapping windows in the shape of a plus.
            const SkRRect& clipRRect = element->getRRect();
            SkVector insetTL = clipRRect.radii(SkRRect::kUpperLeft_Corner);
            SkVector insetBR = clipRRect.radii(SkRRect::kLowerRight_Corner);
            if (SkRRect::kComplex_Type == clipRRect.getType()) {
                const SkVector& insetTR = clipRRect.radii(SkRRect::kUpperRight_Corner);
                const SkVector& insetBL = clipRRect.radii(SkRRect::kLowerLeft_Corner);
                insetTL.fX = SkTMax(insetTL.x(), insetBL.x());
                insetTL.fY = SkTMax(insetTL.y(), insetTR.y());
                insetBR.fX = SkTMax(insetBR.x(), insetTR.x());
                insetBR.fY = SkTMax(insetBR.y(), insetBL.y());
            }
            const SkRect& bounds = clipRRect.getBounds();
            if (insetTL.x() + insetBR.x() >= bounds.width() ||
                insetTL.y() + insetBR.y() >= bounds.height()) {
                continue; // The interior "plus" is empty.
            }

            SkRect horzRect = SkRect::MakeLTRB(bounds.left(), bounds.top() + insetTL.y(),
                                               bounds.right(), bounds.bottom() - insetBR.y());
            this->addWindowRectangle(horzRect, element->isAA());
            if (fWindowRects.count() >= maxWindowRectangles) {
                return;
            }

            SkRect vertRect = SkRect::MakeLTRB(bounds.left() + insetTL.x(), bounds.top(),
                                               bounds.right() - insetBR.x(), bounds.bottom());
            this->addWindowRectangle(vertRect, element->isAA());
            if (fWindowRects.count() >= maxWindowRectangles) {
                return;
            }
            continue;
        }
    }
}

inline void GrReducedClip::addWindowRectangle(const SkRect& elementInteriorRect, bool elementIsAA) {
    SkIRect window;
    if (!elementIsAA) {
        elementInteriorRect.round(&window);
    } else {
        elementInteriorRect.roundIn(&window);
    }
    if (!window.isEmpty()) { // Skip very thin windows that round to zero or negative dimensions.
        fWindowRects.addWindow(window);
    }
}

inline bool GrReducedClip::intersectIBounds(const SkIRect& irect) {
    SkASSERT(fHasIBounds);
    if (!fIBounds.intersect(irect)) {
        fHasIBounds = false;
        fWindowRects.reset();
        fElements.reset();
        fRequiresAA = false;
        fInitialState = InitialState::kAllOut;
        return false;
    }
    return true;
}

////////////////////////////////////////////////////////////////////////////////
// Create a 8-bit clip mask in alpha

static bool stencil_element(GrDrawContext* dc,
                            const GrFixedClip& clip,
                            const GrUserStencilSettings* ss,
                            const SkMatrix& viewMatrix,
                            const SkClipStack::Element* element) {

    // TODO: Draw rrects directly here.
    switch (element->getType()) {
        case Element::kEmpty_Type:
            SkDEBUGFAIL("Should never get here with an empty element.");
            break;
        case Element::kRect_Type:
            return dc->drawContextPriv().drawAndStencilRect(clip, ss,
                                                            (SkRegion::Op)element->getOp(),
                                                            element->isInverseFilled(),
                                                            element->isAA(),
                                                            viewMatrix, element->getRect());
            break;
        default: {
            SkPath path;
            element->asPath(&path);
            if (path.isInverseFillType()) {
                path.toggleInverseFillType();
            }

            return dc->drawContextPriv().drawAndStencilPath(clip, ss,
                                                            (SkRegion::Op)element->getOp(),
                                                            element->isInverseFilled(),
                                                            element->isAA(), viewMatrix, path);
            break;
        }
    }

    return false;
}

static void draw_element(GrDrawContext* dc,
                         const GrClip& clip, // TODO: can this just always be WideOpen?
                         const GrPaint &paint,
                         const SkMatrix& viewMatrix,
                         const SkClipStack::Element* element) {

    // TODO: Draw rrects directly here.
    switch (element->getType()) {
        case Element::kEmpty_Type:
            SkDEBUGFAIL("Should never get here with an empty element.");
            break;
        case Element::kRect_Type:
            dc->drawRect(clip, paint, viewMatrix, element->getRect());
            break;
        default: {
            SkPath path;
            element->asPath(&path);
            if (path.isInverseFillType()) {
                path.toggleInverseFillType();
            }

            dc->drawPath(clip, paint, viewMatrix, path, GrStyle::SimpleFill());
            break;
        }
    }
}

bool GrReducedClip::drawAlphaClipMask(GrDrawContext* dc) const {
    // The texture may be larger than necessary, this rect represents the part of the texture
    // we populate with a rasterization of the clip.
    GrFixedClip clip(SkIRect::MakeWH(fIBounds.width(), fIBounds.height()));

    if (!fWindowRects.empty()) {
        clip.setWindowRectangles(fWindowRects, {fIBounds.left(), fIBounds.top()},
                                 GrWindowRectsState::Mode::kExclusive);
    }

    // The scratch texture that we are drawing into can be substantially larger than the mask. Only
    // clear the part that we care about.
    GrColor initialCoverage = InitialState::kAllIn == this->initialState() ? -1 : 0;
    dc->drawContextPriv().clear(clip, initialCoverage, true);

    // Set the matrix so that rendered clip elements are transformed to mask space from clip space.
    SkMatrix translate;
    translate.setTranslate(SkIntToScalar(-fIBounds.left()), SkIntToScalar(-fIBounds.top()));

    // walk through each clip element and perform its set op
    for (ElementList::Iter iter(fElements); iter.get(); iter.next()) {
        const Element* element = iter.get();
        SkRegion::Op op = (SkRegion::Op)element->getOp();
        bool invert = element->isInverseFilled();
        if (invert || SkRegion::kIntersect_Op == op || SkRegion::kReverseDifference_Op == op) {
            // draw directly into the result with the stencil set to make the pixels affected
            // by the clip shape be non-zero.
            static constexpr GrUserStencilSettings kStencilInElement(
                 GrUserStencilSettings::StaticInit<
                     0xffff,
                     GrUserStencilTest::kAlways,
                     0xffff,
                     GrUserStencilOp::kReplace,
                     GrUserStencilOp::kReplace,
                     0xffff>()
            );
            if (!stencil_element(dc, clip, &kStencilInElement, translate, element)) {
                return false;
            }

            // Draw to the exterior pixels (those with a zero stencil value).
            static constexpr GrUserStencilSettings kDrawOutsideElement(
                 GrUserStencilSettings::StaticInit<
                     0x0000,
                     GrUserStencilTest::kEqual,
                     0xffff,
                     GrUserStencilOp::kZero,
                     GrUserStencilOp::kZero,
                     0xffff>()
            );
            if (!dc->drawContextPriv().drawAndStencilRect(clip, &kDrawOutsideElement,
                                                          op, !invert, false,
                                                          translate,
                                                          SkRect::Make(fIBounds))) {
                return false;
            }
        } else {
            // all the remaining ops can just be directly draw into the accumulation buffer
            GrPaint paint;
            paint.setAntiAlias(element->isAA());
            paint.setCoverageSetOpXPFactory(op, false);

            draw_element(dc, clip, paint, translate, element);
        }
    }

    return true;
}

////////////////////////////////////////////////////////////////////////////////
// Create a 1-bit clip mask in the stencil buffer.

class StencilClip final : public GrClip {
public:
    StencilClip(const SkIRect& scissorRect) : fFixedClip(scissorRect) {}
    const GrFixedClip& fixedClip() const { return fFixedClip; }

    void setWindowRectangles(const GrWindowRectangles& windows, const SkIPoint& origin,
                             GrWindowRectsState::Mode mode) {
        fFixedClip.setWindowRectangles(windows, origin, mode);
    }

private:
    bool quickContains(const SkRect&) const override {
        return false;
    }
    void getConservativeBounds(int width, int height, SkIRect* bounds, bool* iior) const override {
        fFixedClip.getConservativeBounds(width, height, bounds, iior);
    }
    bool isRRect(const SkRect& rtBounds, SkRRect* rr, bool* aa) const override {
        return false;
    }
    bool apply(GrContext* context, GrDrawContext* drawContext, bool useHWAA,
               bool hasUserStencilSettings, GrAppliedClip* out) const override {
        if (!fFixedClip.apply(context, drawContext, useHWAA, hasUserStencilSettings, out)) {
            return false;
        }
        out->addStencilClip();
        return true;
    }

    GrFixedClip fFixedClip;

    typedef GrClip INHERITED;
};

bool GrReducedClip::drawStencilClipMask(GrContext* context,
                                        GrDrawContext* drawContext,
                                        const SkIPoint& clipOrigin) const {
    // We set the current clip to the bounds so that our recursive draws are scissored to them.
    StencilClip stencilClip(fIBounds.makeOffset(-clipOrigin.x(), -clipOrigin.y()));

    if (!fWindowRects.empty()) {
        stencilClip.setWindowRectangles(fWindowRects, clipOrigin,
                                        GrWindowRectsState::Mode::kExclusive);
    }

    bool initialState = InitialState::kAllIn == this->initialState();
    drawContext->drawContextPriv().clearStencilClip(stencilClip.fixedClip(), initialState);

    // Set the matrix so that rendered clip elements are transformed from clip to stencil space.
    SkMatrix viewMatrix;
    viewMatrix.setTranslate(SkIntToScalar(-clipOrigin.x()), SkIntToScalar(-clipOrigin.y()));

    // walk through each clip element and perform its set op
    // with the existing clip.
    for (ElementList::Iter iter(fElements); iter.get(); iter.next()) {
        const Element* element = iter.get();
        bool useHWAA = element->isAA() && drawContext->isStencilBufferMultisampled();

        bool fillInverted = false;

        // This will be used to determine whether the clip shape can be rendered into the
        // stencil with arbitrary stencil settings.
        GrPathRenderer::StencilSupport stencilSupport;

        SkRegion::Op op = (SkRegion::Op)element->getOp();

        GrPathRenderer* pr = nullptr;
        SkPath clipPath;
        if (Element::kRect_Type == element->getType()) {
            stencilSupport = GrPathRenderer::kNoRestriction_StencilSupport;
            fillInverted = false;
        } else {
            element->asPath(&clipPath);
            fillInverted = clipPath.isInverseFillType();
            if (fillInverted) {
                clipPath.toggleInverseFillType();
            }

            GrShape shape(clipPath, GrStyle::SimpleFill());
            GrPathRenderer::CanDrawPathArgs canDrawArgs;
            canDrawArgs.fShaderCaps = context->caps()->shaderCaps();
            canDrawArgs.fViewMatrix = &viewMatrix;
            canDrawArgs.fShape = &shape;
            canDrawArgs.fAntiAlias = false;
            canDrawArgs.fHasUserStencilSettings = false;
            canDrawArgs.fIsStencilBufferMSAA = drawContext->isStencilBufferMultisampled();

            GrDrawingManager* dm = context->contextPriv().drawingManager();
            pr = dm->getPathRenderer(canDrawArgs, false,
                                     GrPathRendererChain::kStencilOnly_DrawType,
                                     &stencilSupport);
            if (!pr) {
                return false;
            }
        }

        bool canRenderDirectToStencil =
            GrPathRenderer::kNoRestriction_StencilSupport == stencilSupport;
        bool drawDirectToClip; // Given the renderer, the element,
                               // fill rule, and set operation should
                               // we render the element directly to
                               // stencil bit used for clipping.
        GrUserStencilSettings const* const* stencilPasses =
            GrStencilSettings::GetClipPasses(op, canRenderDirectToStencil, fillInverted,
                                             &drawDirectToClip);

        // draw the element to the client stencil bits if necessary
        if (!drawDirectToClip) {
            static constexpr GrUserStencilSettings kDrawToStencil(
                 GrUserStencilSettings::StaticInit<
                     0x0000,
                     GrUserStencilTest::kAlways,
                     0xffff,
                     GrUserStencilOp::kIncMaybeClamp,
                     GrUserStencilOp::kIncMaybeClamp,
                     0xffff>()
            );
            if (Element::kRect_Type == element->getType()) {
                drawContext->drawContextPriv().stencilRect(stencilClip.fixedClip(),
                                                           &kDrawToStencil, useHWAA,
                                                           viewMatrix, element->getRect());
            } else {
                if (!clipPath.isEmpty()) {
                    GrShape shape(clipPath, GrStyle::SimpleFill());
                    if (canRenderDirectToStencil) {
                        GrPaint paint;
                        paint.setXPFactory(GrDisableColorXPFactory::Make());
                        paint.setAntiAlias(element->isAA());

                        GrPathRenderer::DrawPathArgs args;
                        args.fResourceProvider = context->resourceProvider();
                        args.fPaint = &paint;
                        args.fUserStencilSettings = &kDrawToStencil;
                        args.fDrawContext = drawContext;
                        args.fClip = &stencilClip.fixedClip();
                        args.fViewMatrix = &viewMatrix;
                        args.fShape = &shape;
                        args.fAntiAlias = false;
                        args.fGammaCorrect = false;
                        pr->drawPath(args);
                    } else {
                        GrPathRenderer::StencilPathArgs args;
                        args.fResourceProvider = context->resourceProvider();
                        args.fDrawContext = drawContext;
                        args.fClip = &stencilClip.fixedClip();
                        args.fViewMatrix = &viewMatrix;
                        args.fIsAA = element->isAA();
                        args.fShape = &shape;
                        pr->stencilPath(args);
                    }
                }
            }
        }

        // now we modify the clip bit by rendering either the clip
        // element directly or a bounding rect of the entire clip.
        for (GrUserStencilSettings const* const* pass = stencilPasses; *pass; ++pass) {
            if (drawDirectToClip) {
                if (Element::kRect_Type == element->getType()) {
                    drawContext->drawContextPriv().stencilRect(stencilClip, *pass, useHWAA,
                                                               viewMatrix, element->getRect());
                } else {
                    GrShape shape(clipPath, GrStyle::SimpleFill());
                    GrPaint paint;
                    paint.setXPFactory(GrDisableColorXPFactory::Make());
                    paint.setAntiAlias(element->isAA());
                    GrPathRenderer::DrawPathArgs args;
                    args.fResourceProvider = context->resourceProvider();
                    args.fPaint = &paint;
                    args.fUserStencilSettings = *pass;
                    args.fDrawContext = drawContext;
                    args.fClip = &stencilClip;
                    args.fViewMatrix = &viewMatrix;
                    args.fShape = &shape;
                    args.fAntiAlias = false;
                    args.fGammaCorrect = false;
                    pr->drawPath(args);
                }
            } else {
                // The view matrix is setup to do clip space -> stencil space translation, so
                // draw rect in clip space.
                drawContext->drawContextPriv().stencilRect(stencilClip, *pass,
                                                           false, viewMatrix,
                                                           SkRect::Make(fIBounds));
            }
        }
    }
    return true;
}
