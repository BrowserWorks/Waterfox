/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrClipStackClip.h"

#include "GrAppliedClip.h"
#include "GrContextPriv.h"
#include "GrDrawingManager.h"
#include "GrDrawContextPriv.h"
#include "GrFixedClip.h"
#include "GrGpuResourcePriv.h"
#include "GrRenderTargetPriv.h"
#include "GrStencilAttachment.h"
#include "GrSWMaskHelper.h"
#include "effects/GrConvexPolyEffect.h"
#include "effects/GrRRectEffect.h"
#include "effects/GrTextureDomain.h"

typedef SkClipStack::Element Element;
typedef GrReducedClip::InitialState InitialState;
typedef GrReducedClip::ElementList ElementList;

static const int kMaxAnalyticElements = 4;

bool GrClipStackClip::quickContains(const SkRect& rect) const {
    if (!fStack || fStack->isWideOpen()) {
        return true;
    }
    return fStack->quickContains(rect.makeOffset(SkIntToScalar(fOrigin.x()),
                                                 SkIntToScalar(fOrigin.y())));
}

bool GrClipStackClip::quickContains(const SkRRect& rrect) const {
    if (!fStack || fStack->isWideOpen()) {
        return true;
    }
    return fStack->quickContains(rrect.makeOffset(SkIntToScalar(fOrigin.fX),
                                                  SkIntToScalar(fOrigin.fY)));
}

bool GrClipStackClip::isRRect(const SkRect& origRTBounds, SkRRect* rr, bool* aa) const {
    if (!fStack) {
        return false;
    }
    const SkRect* rtBounds = &origRTBounds;
    SkRect tempRTBounds;
    bool origin = fOrigin.fX || fOrigin.fY;
    if (origin) {
        tempRTBounds = origRTBounds;
        tempRTBounds.offset(SkIntToScalar(fOrigin.fX), SkIntToScalar(fOrigin.fY));
        rtBounds = &tempRTBounds;
    }
    if (fStack->isRRect(*rtBounds, rr, aa)) {
        if (origin) {
            rr->offset(-SkIntToScalar(fOrigin.fX), -SkIntToScalar(fOrigin.fY));
        }
        return true;
    }
    return false;
}

void GrClipStackClip::getConservativeBounds(int width, int height, SkIRect* devResult,
                                            bool* isIntersectionOfRects) const {
    if (!fStack) {
        devResult->setXYWH(0, 0, width, height);
        if (isIntersectionOfRects) {
            *isIntersectionOfRects = true;
        }
        return;
    }
    SkRect devBounds;
    fStack->getConservativeBounds(-fOrigin.x(), -fOrigin.y(), width, height, &devBounds,
                                  isIntersectionOfRects);
    devBounds.roundOut(devResult);
}

////////////////////////////////////////////////////////////////////////////////
// set up the draw state to enable the aa clipping mask.
static sk_sp<GrFragmentProcessor> create_fp_for_mask(GrTexture* result,
                                                     const SkIRect &devBound) {
    SkIRect domainTexels = SkIRect::MakeWH(devBound.width(), devBound.height());
    return GrDeviceSpaceTextureDecalFragmentProcessor::Make(result, domainTexels,
                                                            {devBound.fLeft, devBound.fTop});
}

// Does the path in 'element' require SW rendering? If so, return true (and,
// optionally, set 'prOut' to NULL. If not, return false (and, optionally, set
// 'prOut' to the non-SW path renderer that will do the job).
bool GrClipStackClip::PathNeedsSWRenderer(GrContext* context,
                                          bool hasUserStencilSettings,
                                          const GrDrawContext* drawContext,
                                          const SkMatrix& viewMatrix,
                                          const Element* element,
                                          GrPathRenderer** prOut,
                                          bool needsStencil) {
    if (Element::kRect_Type == element->getType()) {
        // rects can always be drawn directly w/o using the software path
        // TODO: skip rrects once we're drawing them directly.
        if (prOut) {
            *prOut = nullptr;
        }
        return false;
    } else {
        // We shouldn't get here with an empty clip element.
        SkASSERT(Element::kEmpty_Type != element->getType());

        // the gpu alpha mask will draw the inverse paths as non-inverse to a temp buffer
        SkPath path;
        element->asPath(&path);
        if (path.isInverseFillType()) {
            path.toggleInverseFillType();
        }

        GrPathRendererChain::DrawType type;

        if (needsStencil) {
            type = element->isAA()
                            ? GrPathRendererChain::kStencilAndColorAntiAlias_DrawType
                            : GrPathRendererChain::kStencilAndColor_DrawType;
        } else {
            type = element->isAA()
                            ? GrPathRendererChain::kColorAntiAlias_DrawType
                            : GrPathRendererChain::kColor_DrawType;
        }

        GrShape shape(path, GrStyle::SimpleFill());
        GrPathRenderer::CanDrawPathArgs canDrawArgs;
        canDrawArgs.fShaderCaps = context->caps()->shaderCaps();
        canDrawArgs.fViewMatrix = &viewMatrix;
        canDrawArgs.fShape = &shape;
        canDrawArgs.fAntiAlias = element->isAA();
        canDrawArgs.fHasUserStencilSettings = hasUserStencilSettings;
        canDrawArgs.fIsStencilBufferMSAA = drawContext->isStencilBufferMultisampled();

        // the 'false' parameter disallows use of the SW path renderer
        GrPathRenderer* pr =
            context->contextPriv().drawingManager()->getPathRenderer(canDrawArgs, false, type);
        if (prOut) {
            *prOut = pr;
        }
        return SkToBool(!pr);
    }
}

/*
 * This method traverses the clip stack to see if the GrSoftwarePathRenderer
 * will be used on any element. If so, it returns true to indicate that the
 * entire clip should be rendered in SW and then uploaded en masse to the gpu.
 */
bool GrClipStackClip::UseSWOnlyPath(GrContext* context,
                                    bool hasUserStencilSettings,
                                    const GrDrawContext* drawContext,
                                    const GrReducedClip& reducedClip) {
    // TODO: generalize this function so that when
    // a clip gets complex enough it can just be done in SW regardless
    // of whether it would invoke the GrSoftwarePathRenderer.

    // Set the matrix so that rendered clip elements are transformed to mask space from clip
    // space.
    SkMatrix translate;
    translate.setTranslate(SkIntToScalar(-reducedClip.left()), SkIntToScalar(-reducedClip.top()));

    for (ElementList::Iter iter(reducedClip.elements()); iter.get(); iter.next()) {
        const Element* element = iter.get();

        SkCanvas::ClipOp op = element->getOp();
        bool invert = element->isInverseFilled();
        bool needsStencil = invert ||
                            SkCanvas::kIntersect_Op == op || SkCanvas::kReverseDifference_Op == op;

        if (PathNeedsSWRenderer(context, hasUserStencilSettings,
                                drawContext, translate, element, nullptr, needsStencil)) {
            return true;
        }
    }
    return false;
}

static bool get_analytic_clip_processor(const ElementList& elements,
                                        bool abortIfAA,
                                        const SkVector& clipToRTOffset,
                                        const SkRect& drawBounds,
                                        sk_sp<GrFragmentProcessor>* resultFP) {
    SkRect boundsInClipSpace;
    boundsInClipSpace = drawBounds.makeOffset(-clipToRTOffset.fX, -clipToRTOffset.fY);
    SkASSERT(elements.count() <= kMaxAnalyticElements);
    SkSTArray<kMaxAnalyticElements, sk_sp<GrFragmentProcessor>> fps;
    ElementList::Iter iter(elements);
    while (iter.get()) {
        SkCanvas::ClipOp op = iter.get()->getOp();
        bool invert;
        bool skip = false;
        switch (op) {
            case SkRegion::kReplace_Op:
                SkASSERT(iter.get() == elements.head());
                // Fallthrough, handled same as intersect.
            case SkRegion::kIntersect_Op:
                invert = false;
                if (iter.get()->contains(boundsInClipSpace)) {
                    skip = true;
                }
                break;
            case SkRegion::kDifference_Op:
                invert = true;
                // We don't currently have a cheap test for whether a rect is fully outside an
                // element's primitive, so don't attempt to set skip.
                break;
            default:
                return false;
        }
        if (!skip) {
            GrPrimitiveEdgeType edgeType;
            if (iter.get()->isAA()) {
                if (abortIfAA) {
                    return false;
                }
                edgeType =
                    invert ? kInverseFillAA_GrProcessorEdgeType : kFillAA_GrProcessorEdgeType;
            } else {
                edgeType =
                    invert ? kInverseFillBW_GrProcessorEdgeType : kFillBW_GrProcessorEdgeType;
            }

            switch (iter.get()->getType()) {
                case SkClipStack::Element::kPath_Type:
                    fps.emplace_back(GrConvexPolyEffect::Make(edgeType, iter.get()->getPath(),
                                                              &clipToRTOffset));
                    break;
                case SkClipStack::Element::kRRect_Type: {
                    SkRRect rrect = iter.get()->getRRect();
                    rrect.offset(clipToRTOffset.fX, clipToRTOffset.fY);
                    fps.emplace_back(GrRRectEffect::Make(edgeType, rrect));
                    break;
                }
                case SkClipStack::Element::kRect_Type: {
                    SkRect rect = iter.get()->getRect();
                    rect.offset(clipToRTOffset.fX, clipToRTOffset.fY);
                    fps.emplace_back(GrConvexPolyEffect::Make(edgeType, rect));
                    break;
                }
                default:
                    break;
            }
            if (!fps.back()) {
                return false;
            }
        }
        iter.next();
    }

    *resultFP = nullptr;
    if (fps.count()) {
        *resultFP = GrFragmentProcessor::RunInSeries(fps.begin(), fps.count());
    }
    return true;
}

////////////////////////////////////////////////////////////////////////////////
// sort out what kind of clip mask needs to be created: alpha, stencil,
// scissor, or entirely software
bool GrClipStackClip::apply(GrContext* context, GrDrawContext* drawContext, bool useHWAA,
                            bool hasUserStencilSettings, GrAppliedClip* out) const {
    if (!fStack || fStack->isWideOpen()) {
        return true;
    }

    SkRect devBounds = SkRect::MakeIWH(drawContext->width(), drawContext->height());
    if (!devBounds.intersect(out->clippedDrawBounds()) ||
        GrClip::GetPixelIBounds(devBounds).isEmpty()) {
        return false;
    }

    GrRenderTarget* rt = drawContext->accessRenderTarget();

    const SkScalar clipX = SkIntToScalar(fOrigin.x()),
                   clipY = SkIntToScalar(fOrigin.y());

    SkRect clipSpaceDevBounds = devBounds.makeOffset(clipX, clipY);
    const GrReducedClip reducedClip(*fStack, clipSpaceDevBounds,
                                    rt->renderTargetPriv().maxWindowRectangles());

    if (reducedClip.hasIBounds() &&
        !GrClip::IsInsideClip(reducedClip.ibounds(), clipSpaceDevBounds)) {
        SkIRect scissorSpaceIBounds(reducedClip.ibounds());
        scissorSpaceIBounds.offset(-fOrigin);
        out->addScissor(scissorSpaceIBounds);
    }

    if (!reducedClip.windowRectangles().empty()) {
        out->addWindowRectangles(reducedClip.windowRectangles(), fOrigin,
                                 GrWindowRectsState::Mode::kExclusive);
    }

    if (reducedClip.elements().isEmpty()) {
        return InitialState::kAllIn == reducedClip.initialState();
    }

    SkASSERT(reducedClip.hasIBounds());

    // An element count of 4 was chosen because of the common pattern in Blink of:
    //   isect RR
    //   diff  RR
    //   isect convex_poly
    //   isect convex_poly
    // when drawing rounded div borders. This could probably be tuned based on a
    // configuration's relative costs of switching RTs to generate a mask vs
    // longer shaders.
    if (reducedClip.elements().count() <= kMaxAnalyticElements) {
        // When there are multiple samples we want to do per-sample clipping, not compute a
        // fractional pixel coverage.
        bool disallowAnalyticAA = drawContext->isStencilBufferMultisampled();
        if (disallowAnalyticAA && !drawContext->numColorSamples()) {
            // With a single color sample, any coverage info is lost from color once it hits the
            // color buffer anyway, so we may as well use coverage AA if nothing else in the pipe
            // is multisampled.
            disallowAnalyticAA = useHWAA || hasUserStencilSettings;
        }
        sk_sp<GrFragmentProcessor> clipFP;
        if (reducedClip.requiresAA() &&
            get_analytic_clip_processor(reducedClip.elements(), disallowAnalyticAA,
                                        {-clipX, -clipY}, devBounds, &clipFP)) {
            out->addCoverageFP(std::move(clipFP));
            return true;
        }
    }

    // If the stencil buffer is multisampled we can use it to do everything.
    if (!drawContext->isStencilBufferMultisampled() && reducedClip.requiresAA()) {
        sk_sp<GrTexture> result;
        if (UseSWOnlyPath(context, hasUserStencilSettings, drawContext, reducedClip)) {
            // The clip geometry is complex enough that it will be more efficient to create it
            // entirely in software
            result = CreateSoftwareClipMask(context->textureProvider(), reducedClip);
        } else {
            result = CreateAlphaClipMask(context, reducedClip);
            // If createAlphaClipMask fails it means UseSWOnlyPath has a bug
            SkASSERT(result);
        }

        if (result) {
            // The mask's top left coord should be pinned to the rounded-out top left corner of
            // clipSpace bounds. We determine the mask's position WRT to the render target here.
            SkIRect rtSpaceMaskBounds = reducedClip.ibounds();
            rtSpaceMaskBounds.offset(-fOrigin);
            out->addCoverageFP(create_fp_for_mask(result.get(), rtSpaceMaskBounds));
            return true;
        }
        // if alpha clip mask creation fails fall through to the non-AA code paths
    }

    // use the stencil clip if we can't represent the clip as a rectangle.
    // TODO: these need to be swapped over to using a StencilAttachmentProxy
    GrStencilAttachment* stencilAttachment =
        context->resourceProvider()->attachStencilAttachment(rt);
    if (nullptr == stencilAttachment) {
        SkDebugf("WARNING: failed to attach stencil buffer for clip mask. Clip will be ignored.\n");
        return true;
    }

    // This relies on the property that a reduced sub-rect of the last clip will contain all the
    // relevant window rectangles that were in the last clip. This subtle requirement will go away
    // after clipping is overhauled.
    if (stencilAttachment->mustRenderClip(reducedClip.elementsGenID(), reducedClip.ibounds(),
                                          fOrigin)) {
        reducedClip.drawStencilClipMask(context, drawContext, fOrigin);
        stencilAttachment->setLastClip(reducedClip.elementsGenID(), reducedClip.ibounds(),
                                       fOrigin);
    }
    out->addStencilClip();
    return true;
}

////////////////////////////////////////////////////////////////////////////////
// Create a 8-bit clip mask in alpha

static void GetClipMaskKey(int32_t clipGenID, const SkIRect& bounds, GrUniqueKey* key) {
    static const GrUniqueKey::Domain kDomain = GrUniqueKey::GenerateDomain();
    GrUniqueKey::Builder builder(key, kDomain, 3);
    builder[0] = clipGenID;
    builder[1] = SkToU16(bounds.fLeft) | (SkToU16(bounds.fRight) << 16);
    builder[2] = SkToU16(bounds.fTop) | (SkToU16(bounds.fBottom) << 16);
}

sk_sp<GrTexture> GrClipStackClip::CreateAlphaClipMask(GrContext* context,
                                                      const GrReducedClip& reducedClip) {
    GrResourceProvider* resourceProvider = context->resourceProvider();
    GrUniqueKey key;
    GetClipMaskKey(reducedClip.elementsGenID(), reducedClip.ibounds(), &key);
    if (GrTexture* texture = resourceProvider->findAndRefTextureByUniqueKey(key)) {
        return sk_sp<GrTexture>(texture);
    }

    sk_sp<GrDrawContext> dc(context->makeDrawContextWithFallback(SkBackingFit::kApprox,
                                                                 reducedClip.width(),
                                                                 reducedClip.height(),
                                                                 kAlpha_8_GrPixelConfig,
                                                                 nullptr));
    if (!dc) {
        return nullptr;
    }

    if (!reducedClip.drawAlphaClipMask(dc.get())) {
        return nullptr;
    }

    sk_sp<GrTexture> texture(dc->asTexture());
    SkASSERT(texture);
    texture->resourcePriv().setUniqueKey(key);
    return texture;
}

sk_sp<GrTexture> GrClipStackClip::CreateSoftwareClipMask(GrTextureProvider* texProvider,
                                                         const GrReducedClip& reducedClip) {
    GrUniqueKey key;
    GetClipMaskKey(reducedClip.elementsGenID(), reducedClip.ibounds(), &key);
    if (GrTexture* texture = texProvider->findAndRefTextureByUniqueKey(key)) {
        return sk_sp<GrTexture>(texture);
    }

    // The mask texture may be larger than necessary. We round out the clip space bounds and pin
    // the top left corner of the resulting rect to the top left of the texture.
    SkIRect maskSpaceIBounds = SkIRect::MakeWH(reducedClip.width(), reducedClip.height());

    GrSWMaskHelper helper(texProvider);

    // Set the matrix so that rendered clip elements are transformed to mask space from clip
    // space.
    SkMatrix translate;
    translate.setTranslate(SkIntToScalar(-reducedClip.left()), SkIntToScalar(-reducedClip.top()));

    helper.init(maskSpaceIBounds, &translate);
    helper.clear(InitialState::kAllIn == reducedClip.initialState() ? 0xFF : 0x00);

    for (ElementList::Iter iter(reducedClip.elements()); iter.get(); iter.next()) {
        const Element* element = iter.get();
        SkCanvas::ClipOp op = element->getOp();

        if (SkCanvas::kIntersect_Op == op || SkCanvas::kReverseDifference_Op == op) {
            // Intersect and reverse difference require modifying pixels outside of the geometry
            // that is being "drawn". In both cases we erase all the pixels outside of the geometry
            // but leave the pixels inside the geometry alone. For reverse difference we invert all
            // the pixels before clearing the ones outside the geometry.
            if (SkCanvas::kReverseDifference_Op == op) {
                SkRect temp = SkRect::Make(reducedClip.ibounds());
                // invert the entire scene
                helper.drawRect(temp, SkRegion::kXOR_Op, false, 0xFF);
            }
            SkPath clipPath;
            element->asPath(&clipPath);
            clipPath.toggleInverseFillType();
            GrShape shape(clipPath, GrStyle::SimpleFill());
            helper.drawShape(shape, SkRegion::kReplace_Op, element->isAA(), 0x00);
            continue;
        }

        // The other ops (union, xor, diff) only affect pixels inside
        // the geometry so they can just be drawn normally
        if (Element::kRect_Type == element->getType()) {
            helper.drawRect(element->getRect(), (SkRegion::Op)op, element->isAA(), 0xFF);
        } else {
            SkPath path;
            element->asPath(&path);
            GrShape shape(path, GrStyle::SimpleFill());
            helper.drawShape(shape, (SkRegion::Op)op, element->isAA(), 0xFF);
        }
    }

    // Allocate clip mask texture
    GrSurfaceDesc desc;
    desc.fWidth = reducedClip.width();
    desc.fHeight = reducedClip.height();
    desc.fConfig = kAlpha_8_GrPixelConfig;

    sk_sp<GrTexture> result(texProvider->createApproxTexture(desc));
    if (!result) {
        return nullptr;
    }
    result->resourcePriv().setUniqueKey(key);

    helper.toTexture(result.get());

    return result;
}
