/*
 * Copyright 2007 The Android Open Source Project
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkColorShader_DEFINED
#define SkColorShader_DEFINED

#include "SkShader.h"
#include "SkPM4f.h"

/** \class SkColorShader
    A Shader that represents a single color. In general, this effect can be
    accomplished by just using the color field on the paint, but if an
    actual shader object is needed, this provides that feature.
*/
class SK_API SkColorShader : public SkShader {
public:
    /** Create a ColorShader that ignores the color in the paint, and uses the
        specified color. Note: like all shaders, at draw time the paint's alpha
        will be respected, and is applied to the specified color.
    */
    explicit SkColorShader(SkColor c);

    bool isOpaque() const override;

    class ColorShaderContext : public SkShader::Context {
    public:
        ColorShaderContext(const SkColorShader& shader, const ContextRec&);

        uint32_t getFlags() const override;
        void shadeSpan(int x, int y, SkPMColor span[], int count) override;
        void shadeSpanAlpha(int x, int y, uint8_t alpha[], int count) override;
        void shadeSpan4f(int x, int y, SkPM4f[], int count) override;

    protected:
        bool onChooseBlitProcs(const SkImageInfo&, BlitState*) override;

    private:
        SkPM4f      fPM4f;
        SkPMColor   fPMColor;
        uint32_t    fFlags;

        typedef SkShader::Context INHERITED;
    };

    GradientType asAGradient(GradientInfo* info) const override;

#if SK_SUPPORT_GPU
    sk_sp<GrFragmentProcessor> asFragmentProcessor(const AsFPArgs&) const override;
#endif

    SK_TO_STRING_OVERRIDE()
    SK_DECLARE_PUBLIC_FLATTENABLE_DESERIALIZATION_PROCS(SkColorShader)

protected:
    SkColorShader(SkReadBuffer&);
    void flatten(SkWriteBuffer&) const override;
    Context* onCreateContext(const ContextRec&, void* storage) const override;
    size_t onContextSize(const ContextRec&) const override { return sizeof(ColorShaderContext); }
    bool onAsLuminanceColor(SkColor* lum) const override {
        *lum = fColor;
        return true;
    }

private:
    SkColor fColor;

    typedef SkShader INHERITED;
};

class SkColor4Shader : public SkShader {
public:
    SkColor4Shader(const SkColor4f&, sk_sp<SkColorSpace>);

    bool isOpaque() const override {
        return SkColorGetA(fCachedByteColor) == 255;
    }

    class Color4Context : public SkShader::Context {
    public:
        Color4Context(const SkColor4Shader& shader, const ContextRec&);

        uint32_t getFlags() const override;
        void shadeSpan(int x, int y, SkPMColor span[], int count) override;
        void shadeSpanAlpha(int x, int y, uint8_t alpha[], int count) override;
        void shadeSpan4f(int x, int y, SkPM4f[], int count) override;

    protected:
        bool onChooseBlitProcs(const SkImageInfo&, BlitState*) override;

    private:
        SkPM4f      fPM4f;
        SkPMColor   fPMColor;
        uint32_t    fFlags;

        typedef SkShader::Context INHERITED;
    };

    GradientType asAGradient(GradientInfo* info) const override;

#if SK_SUPPORT_GPU
    sk_sp<GrFragmentProcessor> asFragmentProcessor(const AsFPArgs&) const override;
#endif

    SK_TO_STRING_OVERRIDE()
    SK_DECLARE_PUBLIC_FLATTENABLE_DESERIALIZATION_PROCS(SkColorShader)

protected:
    SkColor4Shader(SkReadBuffer&);
    void flatten(SkWriteBuffer&) const override;
    Context* onCreateContext(const ContextRec&, void* storage) const override;
    size_t onContextSize(const ContextRec&) const override { return sizeof(Color4Context); }
    bool onAsLuminanceColor(SkColor* lum) const override {
        *lum = fCachedByteColor;
        return true;
    }

private:
    sk_sp<SkColorSpace> fColorSpace;
    const SkColor4f     fColor4;
    const SkColor       fCachedByteColor;
    
    typedef SkShader INHERITED;
};

#endif
