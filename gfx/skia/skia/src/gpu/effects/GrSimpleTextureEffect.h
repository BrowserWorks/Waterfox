/*
 * Copyright 2013 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrSimpleTextureEffect_DEFINED
#define GrSimpleTextureEffect_DEFINED

#include "GrSingleTextureEffect.h"

class GrInvariantOutput;

/**
 * The output color of this effect is a modulation of the input color and a sample from a texture.
 * It allows explicit specification of the filtering and wrap modes (GrTextureParams) and accepts
 * a matrix that is used to compute texture coordinates from local coordinates.
 */
class GrSimpleTextureEffect : public GrSingleTextureEffect {
public:
    /* unfiltered, clamp mode */
    static sk_sp<GrFragmentProcessor> Make(GrTexture* tex,
                                           sk_sp<GrColorSpaceXform> colorSpaceXform,
                                           const SkMatrix& matrix) {
        return sk_sp<GrFragmentProcessor>(
            new GrSimpleTextureEffect(tex, std::move(colorSpaceXform), matrix,
                                      GrTextureParams::kNone_FilterMode));
    }

    /* clamp mode */
    static sk_sp<GrFragmentProcessor> Make(GrTexture* tex,
                                           sk_sp<GrColorSpaceXform> colorSpaceXform,
                                            const SkMatrix& matrix,
                                            GrTextureParams::FilterMode filterMode) {
        return sk_sp<GrFragmentProcessor>(
            new GrSimpleTextureEffect(tex, std::move(colorSpaceXform), matrix, filterMode));
    }

    static sk_sp<GrFragmentProcessor> Make(GrTexture* tex,
                                           sk_sp<GrColorSpaceXform> colorSpaceXform,
                                           const SkMatrix& matrix,
                                           const GrTextureParams& p) {
        return sk_sp<GrFragmentProcessor>(new GrSimpleTextureEffect(tex, std::move(colorSpaceXform),
                                                                    matrix, p));
    }

    virtual ~GrSimpleTextureEffect() {}

    const char* name() const override { return "SimpleTexture"; }

private:
    GrSimpleTextureEffect(GrTexture* texture,
                          sk_sp<GrColorSpaceXform> colorSpaceXform,
                          const SkMatrix& matrix,
                          GrTextureParams::FilterMode filterMode)
        : GrSingleTextureEffect(texture, std::move(colorSpaceXform), matrix, filterMode) {
        this->initClassID<GrSimpleTextureEffect>();
    }

    GrSimpleTextureEffect(GrTexture* texture,
                          sk_sp<GrColorSpaceXform> colorSpaceXform,
                          const SkMatrix& matrix,
                          const GrTextureParams& params)
        : GrSingleTextureEffect(texture, std::move(colorSpaceXform), matrix, params) {
        this->initClassID<GrSimpleTextureEffect>();
    }

    GrGLSLFragmentProcessor* onCreateGLSLInstance() const override;

    void onGetGLSLProcessorKey(const GrGLSLCaps&, GrProcessorKeyBuilder*) const override;

    bool onIsEqual(const GrFragmentProcessor& other) const override { return true; }

    void onComputeInvariantOutput(GrInvariantOutput* inout) const override;

    GR_DECLARE_FRAGMENT_PROCESSOR_TEST;

    typedef GrSingleTextureEffect INHERITED;
};

#endif
