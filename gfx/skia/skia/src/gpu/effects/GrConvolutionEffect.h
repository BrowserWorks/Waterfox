/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrConvolutionEffect_DEFINED
#define GrConvolutionEffect_DEFINED

#include "Gr1DKernelEffect.h"
#include "GrInvariantOutput.h"

/**
 * A convolution effect. The kernel is specified as an array of 2 * half-width
 * + 1 weights. Each texel is multiplied by it's weight and summed to determine
 * the output color. The output color is modulated by the input color.
 */
class GrConvolutionEffect : public Gr1DKernelEffect {

public:

    /// Convolve with an arbitrary user-specified kernel
    static sk_sp<GrFragmentProcessor> Make(GrTexture* tex,
                                           Direction dir,
                                           int halfWidth,
                                           const float* kernel,
                                           bool useBounds,
                                           float bounds[2]) {
        return sk_sp<GrFragmentProcessor>(
            new GrConvolutionEffect(tex, dir, halfWidth, kernel, useBounds, bounds));
    }

    /// Convolve with a Gaussian kernel
    static sk_sp<GrFragmentProcessor> MakeGaussian(GrTexture* tex,
                                                   Direction dir,
                                                   int halfWidth,
                                                   float gaussianSigma,
                                                   bool useBounds,
                                                   float bounds[2]) {
        return sk_sp<GrFragmentProcessor>(
            new GrConvolutionEffect(tex, dir, halfWidth, gaussianSigma, useBounds, bounds));
    }

    virtual ~GrConvolutionEffect();

    const float* kernel() const { return fKernel; }

    const float* bounds() const { return fBounds; }
    bool useBounds() const { return fUseBounds; }

    const char* name() const override { return "Convolution"; }

    enum {
        // This was decided based on the min allowed value for the max texture
        // samples per fragment program run in DX9SM2 (32). A sigma param of 4.0
        // on a blur filter gives a kernel width of 25 while a sigma of 5.0
        // would exceed a 32 wide kernel.
        kMaxKernelRadius = 12,
        // With a C++11 we could have a constexpr version of WidthFromRadius()
        // and not have to duplicate this calculation.
        kMaxKernelWidth = 2 * kMaxKernelRadius + 1,
    };

protected:

    float fKernel[kMaxKernelWidth];
    bool fUseBounds;
    float fBounds[2];

private:
    GrConvolutionEffect(GrTexture*, Direction,
                        int halfWidth,
                        const float* kernel,
                        bool useBounds,
                        float bounds[2]);

    /// Convolve with a Gaussian kernel
    GrConvolutionEffect(GrTexture*, Direction,
                        int halfWidth,
                        float gaussianSigma,
                        bool useBounds,
                        float bounds[2]);

    GrGLSLFragmentProcessor* onCreateGLSLInstance() const override;

    void onGetGLSLProcessorKey(const GrGLSLCaps&, GrProcessorKeyBuilder*) const override;

    bool onIsEqual(const GrFragmentProcessor&) const override;

    void onComputeInvariantOutput(GrInvariantOutput* inout) const override {
        // If the texture was opaque we could know that the output color if we knew the sum of the
        // kernel values.
        inout->mulByUnknownFourComponents();
    }

    GR_DECLARE_FRAGMENT_PROCESSOR_TEST;

    typedef Gr1DKernelEffect INHERITED;
};

#endif
