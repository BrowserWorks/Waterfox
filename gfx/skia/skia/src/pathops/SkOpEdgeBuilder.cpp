/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
#include "SkGeometry.h"
#include "SkOpEdgeBuilder.h"
#include "SkReduceOrder.h"

void SkOpEdgeBuilder::init() {
    fCurrentContour = fContoursHead;
    fOperand = false;
    fXorMask[0] = fXorMask[1] = (fPath->getFillType() & 1) ? kEvenOdd_PathOpsMask
            : kWinding_PathOpsMask;
    fUnparseable = false;
    fSecondHalf = preFetch();
}

// very tiny points cause numerical instability : don't allow them
static void force_small_to_zero(SkPoint* pt) {
    if (SkScalarAbs(pt->fX) < FLT_EPSILON_ORDERABLE_ERR) {
        pt->fX = 0;
    }
    if (SkScalarAbs(pt->fY) < FLT_EPSILON_ORDERABLE_ERR) {
        pt->fY = 0;
    }
}

static bool can_add_curve(SkPath::Verb verb, SkPoint* curve) {
    if (SkPath::kMove_Verb == verb) {
        return false;
    }
    for (int index = 0; index <= SkPathOpsVerbToPoints(verb); ++index) {
        force_small_to_zero(&curve[index]);
    }
    return SkPath::kLine_Verb != verb || !SkDPoint::ApproximatelyEqual(curve[0], curve[1]);
}

void SkOpEdgeBuilder::addOperand(const SkPath& path) {
    SkASSERT(fPathVerbs.count() > 0 && fPathVerbs.end()[-1] == SkPath::kDone_Verb);
    fPathVerbs.pop();
    fPath = &path;
    fXorMask[1] = (fPath->getFillType() & 1) ? kEvenOdd_PathOpsMask
            : kWinding_PathOpsMask;
    preFetch();
}

bool SkOpEdgeBuilder::finish() {
    fOperand = false;
    if (fUnparseable || !walk()) {
        return false;
    }
    complete();
    if (fCurrentContour && !fCurrentContour->count()) {
        fContoursHead->remove(fCurrentContour);
    }
    return true;
}

void SkOpEdgeBuilder::closeContour(const SkPoint& curveEnd, const SkPoint& curveStart) {
    if (!SkDPoint::ApproximatelyEqual(curveEnd, curveStart)) {
        *fPathVerbs.append() = SkPath::kLine_Verb;
        *fPathPts.append() = curveStart;
    } else {
        int verbCount = fPathVerbs.count();
        int ptsCount = fPathPts.count();
        if (SkPath::kLine_Verb == fPathVerbs[verbCount - 1]
                && fPathPts[ptsCount - 2] == curveStart) {
            fPathVerbs.pop();
            fPathPts.pop();
        } else {
            fPathPts[ptsCount - 1] = curveStart;
        }
    }
    *fPathVerbs.append() = SkPath::kClose_Verb;
}

int SkOpEdgeBuilder::preFetch() {
    if (!fPath->isFinite()) {
        fUnparseable = true;
        return 0;
    }
    SkPath::RawIter iter(*fPath);
    SkPoint curveStart;
    SkPoint curve[4];
    SkPoint pts[4];
    SkPath::Verb verb;
    bool lastCurve = false;
    do {
        verb = iter.next(pts);
        switch (verb) {
            case SkPath::kMove_Verb:
                if (!fAllowOpenContours && lastCurve) {
                    closeContour(curve[0], curveStart);
                }
                *fPathVerbs.append() = verb;
                force_small_to_zero(&pts[0]);
                *fPathPts.append() = pts[0];
                curveStart = curve[0] = pts[0];
                lastCurve = false;
                continue;
            case SkPath::kLine_Verb:
                force_small_to_zero(&pts[1]);
                if (SkDPoint::ApproximatelyEqual(curve[0], pts[1])) {
                    uint8_t lastVerb = fPathVerbs.top();
                    if (lastVerb != SkPath::kLine_Verb && lastVerb != SkPath::kMove_Verb) {
                        fPathPts.top() = pts[1];
                    }
                    continue;  // skip degenerate points
                }
                break;
            case SkPath::kQuad_Verb:
                force_small_to_zero(&pts[1]);
                force_small_to_zero(&pts[2]);
                curve[1] = pts[1];
                curve[2] = pts[2];
                verb = SkReduceOrder::Quad(curve, pts);
                if (verb == SkPath::kMove_Verb) {
                    continue;  // skip degenerate points
                }
                break;
            case SkPath::kConic_Verb:
                force_small_to_zero(&pts[1]);
                force_small_to_zero(&pts[2]);
                curve[1] = pts[1];
                curve[2] = pts[2];
                verb = SkReduceOrder::Quad(curve, pts);
                if (SkPath::kQuad_Verb == verb && 1 != iter.conicWeight()) {
                  verb = SkPath::kConic_Verb;
                } else if (verb == SkPath::kMove_Verb) {
                    continue;  // skip degenerate points
                }
                break;
            case SkPath::kCubic_Verb:
                force_small_to_zero(&pts[1]);
                force_small_to_zero(&pts[2]);
                force_small_to_zero(&pts[3]);
                curve[1] = pts[1];
                curve[2] = pts[2];
                curve[3] = pts[3];
                verb = SkReduceOrder::Cubic(curve, pts);
                if (verb == SkPath::kMove_Verb) {
                    continue;  // skip degenerate points
                }
                break;
            case SkPath::kClose_Verb:
                closeContour(curve[0], curveStart);
                lastCurve = false;
                continue;
            case SkPath::kDone_Verb:
                continue;
        }
        *fPathVerbs.append() = verb;
        int ptCount = SkPathOpsVerbToPoints(verb);
        fPathPts.append(ptCount, &pts[1]);
        if (verb == SkPath::kConic_Verb) {
            *fWeights.append() = iter.conicWeight();
        }
        curve[0] = pts[ptCount];
        lastCurve = true;
    } while (verb != SkPath::kDone_Verb);
    if (!fAllowOpenContours && lastCurve) {
        closeContour(curve[0], curveStart);
    }
    *fPathVerbs.append() = SkPath::kDone_Verb;
    return fPathVerbs.count() - 1;
}

bool SkOpEdgeBuilder::close() {
    complete();
    return true;
}

bool SkOpEdgeBuilder::walk() {
    uint8_t* verbPtr = fPathVerbs.begin();
    uint8_t* endOfFirstHalf = &verbPtr[fSecondHalf];
    SkPoint* pointsPtr = fPathPts.begin() - 1;
    SkScalar* weightPtr = fWeights.begin();
    SkPath::Verb verb;
    while ((verb = (SkPath::Verb) *verbPtr) != SkPath::kDone_Verb) {
        if (verbPtr == endOfFirstHalf) {
            fOperand = true;
        }
        verbPtr++;
        switch (verb) {
            case SkPath::kMove_Verb:
                if (fCurrentContour && fCurrentContour->count()) {
                    if (fAllowOpenContours) {
                        complete();
                    } else if (!close()) {
                        return false;
                    }
                }
                if (!fCurrentContour) {
                    fCurrentContour = fContoursHead->appendContour();
                }
                fCurrentContour->init(fGlobalState, fOperand,
                    fXorMask[fOperand] == kEvenOdd_PathOpsMask);
                pointsPtr += 1;
                continue;
            case SkPath::kLine_Verb:
                fCurrentContour->addLine(pointsPtr);
                break;
            case SkPath::kQuad_Verb:
                {
                    SkVector v1 = pointsPtr[1] - pointsPtr[0];
                    SkVector v2 = pointsPtr[2] - pointsPtr[1];
                    if (v1.dot(v2) < 0) {
                        SkPoint pair[5];
                        if (SkChopQuadAtMaxCurvature(pointsPtr, pair) == 1) {
                            goto addOneQuad;
                        }
                        if (!SkScalarsAreFinite(&pair[0].fX, SK_ARRAY_COUNT(pair) * 2)) {
                            return false;
                        }
                        SkPoint cStorage[2][2];
                        SkPath::Verb v1 = SkReduceOrder::Quad(&pair[0], cStorage[0]);
                        SkPath::Verb v2 = SkReduceOrder::Quad(&pair[2], cStorage[1]);
                        SkPoint* curve1 = v1 != SkPath::kLine_Verb ? &pair[0] : cStorage[0];
                        SkPoint* curve2 = v2 != SkPath::kLine_Verb ? &pair[2] : cStorage[1];
                        if (can_add_curve(v1, curve1) && can_add_curve(v2, curve2)) {
                            fCurrentContour->addCurve(v1, curve1);
                            fCurrentContour->addCurve(v2, curve2);
                            break;
                        }
                    }
                }
            addOneQuad:
                fCurrentContour->addQuad(pointsPtr);
                break;
            case SkPath::kConic_Verb: {
                SkVector v1 = pointsPtr[1] - pointsPtr[0];
                SkVector v2 = pointsPtr[2] - pointsPtr[1];
                SkScalar weight = *weightPtr++;
                if (v1.dot(v2) < 0) {
                    // FIXME: max curvature for conics hasn't been implemented; use placeholder
                    SkScalar maxCurvature = SkFindQuadMaxCurvature(pointsPtr);
                    if (maxCurvature > 0) {
                        SkConic conic(pointsPtr, weight);
                        SkConic pair[2];
                        if (!conic.chopAt(maxCurvature, pair)) {
                            // if result can't be computed, use original
                            fCurrentContour->addConic(pointsPtr, weight);
                            break;
                        }
                        SkPoint cStorage[2][3];
                        SkPath::Verb v1 = SkReduceOrder::Conic(pair[0], cStorage[0]);
                        SkPath::Verb v2 = SkReduceOrder::Conic(pair[1], cStorage[1]);
                        SkPoint* curve1 = v1 != SkPath::kLine_Verb ? pair[0].fPts : cStorage[0];
                        SkPoint* curve2 = v2 != SkPath::kLine_Verb ? pair[1].fPts : cStorage[1];
                        if (can_add_curve(v1, curve1) && can_add_curve(v2, curve2)) {
                            fCurrentContour->addCurve(v1, curve1, pair[0].fW);
                            fCurrentContour->addCurve(v2, curve2, pair[1].fW);
                            break;
                        }
                    }
                }
                fCurrentContour->addConic(pointsPtr, weight);
                } break;
            case SkPath::kCubic_Verb:
                {
                    // Split complex cubics (such as self-intersecting curves or
                    // ones with difficult curvature) in two before proceeding.
                    // This can be required for intersection to succeed.
                    SkScalar splitT;
                    if (SkDCubic::ComplexBreak(pointsPtr, &splitT)) {
                        SkPoint pair[7];
                        SkChopCubicAt(pointsPtr, pair, splitT);
                        if (!SkScalarsAreFinite(&pair[0].fX, SK_ARRAY_COUNT(pair) * 2)) {
                            return false;
                        }
                        SkPoint cStorage[2][4];
                        SkPath::Verb v1 = SkReduceOrder::Cubic(&pair[0], cStorage[0]);
                        SkPath::Verb v2 = SkReduceOrder::Cubic(&pair[3], cStorage[1]);
                        SkPoint* curve1 = v1 == SkPath::kCubic_Verb ? &pair[0] : cStorage[0];
                        SkPoint* curve2 = v2 == SkPath::kCubic_Verb ? &pair[3] : cStorage[1];
                        if (can_add_curve(v1, curve1) && can_add_curve(v2, curve2)) {
                            fCurrentContour->addCurve(v1, curve1);
                            fCurrentContour->addCurve(v2, curve2);
                            break;
                        } 
                    }
                }
                fCurrentContour->addCubic(pointsPtr);
                break;
            case SkPath::kClose_Verb:
                SkASSERT(fCurrentContour);
                if (!close()) {
                    return false;
                }
                continue;
            default:
                SkDEBUGFAIL("bad verb");
                return false;
        }
        SkASSERT(fCurrentContour);
        fCurrentContour->debugValidate();
        pointsPtr += SkPathOpsVerbToPoints(verb);
    }
   if (fCurrentContour && fCurrentContour->count() &&!fAllowOpenContours && !close()) {
       return false;
   }
   return true;
}
