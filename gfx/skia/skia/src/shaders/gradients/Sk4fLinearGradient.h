/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef Sk4fLinearGradient_DEFINED
#define Sk4fLinearGradient_DEFINED

#include "Sk4fGradientBase.h"
#include "SkLinearGradient.h"

class SkLinearGradient::
LinearGradient4fContext final : public GradientShaderBase4fContext {
public:
    LinearGradient4fContext(const SkLinearGradient&, const ContextRec&);

    void shadeSpan(int x, int y, SkPMColor dst[], int count) override;
    void shadeSpan4f(int x, int y, SkPM4f dst[], int count) override;

private:
    using INHERITED = GradientShaderBase4fContext;

    template<typename dstType, ApplyPremul, TileMode>
    class LinearIntervalProcessor;

    template <typename dstType, ApplyPremul premul>
    void shadePremulSpan(int x, int y, dstType dst[], int count, float bias0, float bias1) const;

    template <typename dstType, ApplyPremul premul, SkShader::TileMode tileMode>
    void shadeSpanInternal(int x, int y, dstType dst[], int count, float bias0, float bias1) const;

    const Sk4fGradientInterval* findInterval(SkScalar fx) const;

    mutable const Sk4fGradientInterval* fCachedInterval;
};

#endif // Sk4fLinearGradient_DEFINED
