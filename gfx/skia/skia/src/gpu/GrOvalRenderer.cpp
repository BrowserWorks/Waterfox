/*
 * Copyright 2013 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrOvalRenderer.h"

#include "GrBatchFlushState.h"
#include "GrBatchTest.h"
#include "GrGeometryProcessor.h"
#include "GrInvariantOutput.h"
#include "GrProcessor.h"
#include "GrResourceProvider.h"
#include "GrStyle.h"
#include "SkRRect.h"
#include "SkStrokeRec.h"
#include "batches/GrVertexBatch.h"
#include "glsl/GrGLSLFragmentShaderBuilder.h"
#include "glsl/GrGLSLGeometryProcessor.h"
#include "glsl/GrGLSLProgramDataManager.h"
#include "glsl/GrGLSLVarying.h"
#include "glsl/GrGLSLVertexShaderBuilder.h"
#include "glsl/GrGLSLUniformHandler.h"
#include "glsl/GrGLSLUtil.h"

// TODO(joshualitt) - Break this file up during GrBatch post implementation cleanup

namespace {

struct EllipseVertex {
    SkPoint  fPos;
    GrColor  fColor;
    SkPoint  fOffset;
    SkPoint  fOuterRadii;
    SkPoint  fInnerRadii;
};

struct DIEllipseVertex {
    SkPoint  fPos;
    GrColor  fColor;
    SkPoint  fOuterOffset;
    SkPoint  fInnerOffset;
};

inline bool circle_stays_circle(const SkMatrix& m) {
    return m.isSimilarity();
}

}

///////////////////////////////////////////////////////////////////////////////

/**
 * The output of this effect is a modulation of the input color and coverage for a circle. It
 * operates in a space normalized by the circle radius (outer radius in the case of a stroke)
 * with origin at the circle center. Three vertex attributes are used:
 *    vec2f : position in device space of the bounding geometry vertices
 *    vec4ub: color
 *    vec4f : (p.xy, outerRad, innerRad)
 *             p is the position in the normalized space.
 *             outerRad is the outerRadius in device space.
 *             innerRad is the innerRadius in normalized space (ignored if not stroking).
 * If fUsesDistanceVectorField is set in fragment processors in the same program, then
 * an additional vertex attribute is available via args.fFragBuilder->distanceVectorName():
 *    vec4f : (v.xy, outerDistance, innerDistance)
 *             v is a normalized vector pointing to the outer edge
 *             outerDistance is the distance to the outer edge, < 0 if we are outside of the shape
 *             if stroking, innerDistance is the distance to the inner edge, < 0 if outside
 * Additional clip planes are supported for rendering circular arcs. The additional planes are
 * either intersected or unioned together. Up to three planes are supported (an initial plane,
 * a plane intersected with the initial plane, and a plane unioned with the first two). Only two
 * are useful for any given arc, but having all three in one instance allows batching different
 * types of arcs.
 */

class CircleGeometryProcessor : public GrGeometryProcessor {
public:
    CircleGeometryProcessor(bool stroke, bool clipPlane, bool isectPlane, bool unionPlane,
                            const SkMatrix& localMatrix)
            : fLocalMatrix(localMatrix) {
        this->initClassID<CircleGeometryProcessor>();
        fInPosition = &this->addVertexAttrib("inPosition", kVec2f_GrVertexAttribType,
                                             kHigh_GrSLPrecision);
        fInColor = &this->addVertexAttrib("inColor", kVec4ub_GrVertexAttribType);
        fInCircleEdge = &this->addVertexAttrib("inCircleEdge", kVec4f_GrVertexAttribType);
        if (clipPlane) {
            fInClipPlane = &this->addVertexAttrib("inClipPlane", kVec3f_GrVertexAttribType);
        } else {
            fInClipPlane = nullptr;
        }
        if (isectPlane) {
            fInIsectPlane = &this->addVertexAttrib("inIsectPlane", kVec3f_GrVertexAttribType);
        } else {
            fInIsectPlane = nullptr;
        }
        if (unionPlane) {
            fInUnionPlane = &this->addVertexAttrib("inUnionPlane", kVec3f_GrVertexAttribType);
        } else {
            fInUnionPlane = nullptr;
        }
        fStroke = stroke;
    }

    bool implementsDistanceVector() const override { return !fInClipPlane; }

    virtual ~CircleGeometryProcessor() {}

    const char* name() const override { return "CircleEdge"; }

    void getGLSLProcessorKey(const GrGLSLCaps& caps, GrProcessorKeyBuilder* b) const override {
        GLSLProcessor::GenKey(*this, caps, b);
    }

    GrGLSLPrimitiveProcessor* createGLSLInstance(const GrGLSLCaps&) const override {
        return new GLSLProcessor();
    }

private:
    class GLSLProcessor : public GrGLSLGeometryProcessor {
    public:
        GLSLProcessor() {}

        void onEmitCode(EmitArgs& args, GrGPArgs* gpArgs) override{
            const CircleGeometryProcessor& cgp = args.fGP.cast<CircleGeometryProcessor>();
            GrGLSLVertexBuilder* vertBuilder = args.fVertBuilder;
            GrGLSLVaryingHandler* varyingHandler = args.fVaryingHandler;
            GrGLSLUniformHandler* uniformHandler = args.fUniformHandler;
            GrGLSLPPFragmentBuilder* fragBuilder = args.fFragBuilder;

            // emit attributes
            varyingHandler->emitAttributes(cgp);
            fragBuilder->codeAppend("vec4 circleEdge;");
            varyingHandler->addPassThroughAttribute(cgp.fInCircleEdge, "circleEdge");
            if (cgp.fInClipPlane) {
                fragBuilder->codeAppend("vec3 clipPlane;");
                varyingHandler->addPassThroughAttribute(cgp.fInClipPlane, "clipPlane");
            }
            if (cgp.fInIsectPlane) {
                SkASSERT(cgp.fInClipPlane);
                fragBuilder->codeAppend("vec3 isectPlane;");
                varyingHandler->addPassThroughAttribute(cgp.fInIsectPlane, "isectPlane");
            }
            if (cgp.fInUnionPlane) {
                SkASSERT(cgp.fInClipPlane);
                fragBuilder->codeAppend("vec3 unionPlane;");
                varyingHandler->addPassThroughAttribute(cgp.fInUnionPlane, "unionPlane");
            }

            // setup pass through color
            varyingHandler->addPassThroughAttribute(cgp.fInColor, args.fOutputColor);

            // Setup position
            this->setupPosition(vertBuilder, gpArgs, cgp.fInPosition->fName);

            // emit transforms
            this->emitTransforms(vertBuilder,
                                 varyingHandler,
                                 uniformHandler,
                                 gpArgs->fPositionVar,
                                 cgp.fInPosition->fName,
                                 cgp.fLocalMatrix,
                                 args.fFPCoordTransformHandler);

            fragBuilder->codeAppend("float d = length(circleEdge.xy);");
            fragBuilder->codeAppend("float distanceToOuterEdge = circleEdge.z * (1.0 - d);");
            fragBuilder->codeAppend("float edgeAlpha = clamp(distanceToOuterEdge, 0.0, 1.0);");
            if (cgp.fStroke) {
                fragBuilder->codeAppend("float distanceToInnerEdge = circleEdge.z * (d - circleEdge.w);");
                fragBuilder->codeAppend("float innerAlpha = clamp(distanceToInnerEdge, 0.0, 1.0);");
                fragBuilder->codeAppend("edgeAlpha *= innerAlpha;");
            }

            if (args.fDistanceVectorName) {
                const char* innerEdgeDistance = cgp.fStroke ? "distanceToInnerEdge" : "0.0";
                fragBuilder->codeAppend ("if (d == 0.0) {"); // if on the center of the circle
                fragBuilder->codeAppendf("    %s = vec4(1.0, 0.0, distanceToOuterEdge, "
                                         "%s);", // no normalize
                                         args.fDistanceVectorName, innerEdgeDistance);
                fragBuilder->codeAppend ("} else {");
                fragBuilder->codeAppendf("    %s = vec4(normalize(circleEdge.xy), distanceToOuterEdge, %s);",
                                         args.fDistanceVectorName, innerEdgeDistance);
                fragBuilder->codeAppend ("}");
            }
            if (cgp.fInClipPlane) {
                fragBuilder->codeAppend("float clip = clamp(circleEdge.z * dot(circleEdge.xy, clipPlane.xy) + clipPlane.z, 0.0, 1.0);");
                if (cgp.fInIsectPlane) {
                    fragBuilder->codeAppend("clip *= clamp(circleEdge.z * dot(circleEdge.xy, isectPlane.xy) + isectPlane.z, 0.0, 1.0);");
                }
                if (cgp.fInUnionPlane) {
                    fragBuilder->codeAppend("clip += (1.0 - clip)*clamp(circleEdge.z * dot(circleEdge.xy, unionPlane.xy) + unionPlane.z, 0.0, 1.0);");
                }
                fragBuilder->codeAppend("edgeAlpha *= clip;");
            }
            fragBuilder->codeAppendf("%s = vec4(edgeAlpha);", args.fOutputCoverage);
        }

        static void GenKey(const GrGeometryProcessor& gp,
                           const GrGLSLCaps&,
                           GrProcessorKeyBuilder* b) {
            const CircleGeometryProcessor& cgp = gp.cast<CircleGeometryProcessor>();
            uint16_t key;
            key  = cgp.fStroke                       ? 0x01 : 0x0;
            key |= cgp.fLocalMatrix.hasPerspective() ? 0x02 : 0x0;
            key |= cgp.fInClipPlane                  ? 0x04 : 0x0;
            key |= cgp.fInIsectPlane                 ? 0x08 : 0x0;
            key |= cgp.fInUnionPlane                 ? 0x10 : 0x0;
            b->add32(key);
        }

        void setData(const GrGLSLProgramDataManager& pdman, const GrPrimitiveProcessor& primProc,
                     FPCoordTransformIter&& transformIter) override {
            this->setTransformDataHelper(primProc.cast<CircleGeometryProcessor>().fLocalMatrix,
                                         pdman, &transformIter);
        }

    private:
        typedef GrGLSLGeometryProcessor INHERITED;
    };

    SkMatrix         fLocalMatrix;
    const Attribute* fInPosition;
    const Attribute* fInColor;
    const Attribute* fInCircleEdge;
    const Attribute* fInClipPlane;
    const Attribute* fInIsectPlane;
    const Attribute* fInUnionPlane;
    bool             fStroke;

    GR_DECLARE_GEOMETRY_PROCESSOR_TEST;

    typedef GrGeometryProcessor INHERITED;
};

GR_DEFINE_GEOMETRY_PROCESSOR_TEST(CircleGeometryProcessor);

sk_sp<GrGeometryProcessor> CircleGeometryProcessor::TestCreate(GrProcessorTestData* d) {
    return sk_sp<GrGeometryProcessor>(
        new CircleGeometryProcessor(d->fRandom->nextBool(), d->fRandom->nextBool(),
                                    d->fRandom->nextBool(), d->fRandom->nextBool(),
                                    GrTest::TestMatrix(d->fRandom)));
}

///////////////////////////////////////////////////////////////////////////////

/**
 * The output of this effect is a modulation of the input color and coverage for an axis-aligned
 * ellipse, specified as a 2D offset from center, and the reciprocals of the outer and inner radii,
 * in both x and y directions.
 *
 * We are using an implicit function of x^2/a^2 + y^2/b^2 - 1 = 0.
 */

class EllipseGeometryProcessor : public GrGeometryProcessor {
public:
    EllipseGeometryProcessor(bool stroke, const SkMatrix& localMatrix)
        : fLocalMatrix(localMatrix) {
        this->initClassID<EllipseGeometryProcessor>();
        fInPosition = &this->addVertexAttrib("inPosition", kVec2f_GrVertexAttribType);
        fInColor = &this->addVertexAttrib("inColor", kVec4ub_GrVertexAttribType);
        fInEllipseOffset = &this->addVertexAttrib("inEllipseOffset", kVec2f_GrVertexAttribType);
        fInEllipseRadii = &this->addVertexAttrib("inEllipseRadii", kVec4f_GrVertexAttribType);
        fStroke = stroke;
    }

    virtual ~EllipseGeometryProcessor() {}

    const char* name() const override { return "EllipseEdge"; }

    void getGLSLProcessorKey(const GrGLSLCaps& caps, GrProcessorKeyBuilder* b) const override {
        GLSLProcessor::GenKey(*this, caps, b);
    }

    GrGLSLPrimitiveProcessor* createGLSLInstance(const GrGLSLCaps&) const override {
        return new GLSLProcessor();
    }

private:
    class GLSLProcessor : public GrGLSLGeometryProcessor {
    public:
        GLSLProcessor() {}

        void onEmitCode(EmitArgs& args, GrGPArgs* gpArgs) override{
            const EllipseGeometryProcessor& egp = args.fGP.cast<EllipseGeometryProcessor>();
            GrGLSLVertexBuilder* vertBuilder = args.fVertBuilder;
            GrGLSLVaryingHandler* varyingHandler = args.fVaryingHandler;
            GrGLSLUniformHandler* uniformHandler = args.fUniformHandler;

            // emit attributes
            varyingHandler->emitAttributes(egp);

            GrGLSLVertToFrag ellipseOffsets(kVec2f_GrSLType);
            varyingHandler->addVarying("EllipseOffsets", &ellipseOffsets);
            vertBuilder->codeAppendf("%s = %s;", ellipseOffsets.vsOut(),
                                     egp.fInEllipseOffset->fName);

            GrGLSLVertToFrag ellipseRadii(kVec4f_GrSLType);
            varyingHandler->addVarying("EllipseRadii", &ellipseRadii);
            vertBuilder->codeAppendf("%s = %s;", ellipseRadii.vsOut(),
                                     egp.fInEllipseRadii->fName);

            GrGLSLPPFragmentBuilder* fragBuilder = args.fFragBuilder;
            // setup pass through color
            varyingHandler->addPassThroughAttribute(egp.fInColor, args.fOutputColor);

            // Setup position
            this->setupPosition(vertBuilder, gpArgs, egp.fInPosition->fName);

            // emit transforms
            this->emitTransforms(vertBuilder,
                                 varyingHandler,
                                 uniformHandler,
                                 gpArgs->fPositionVar,
                                 egp.fInPosition->fName,
                                 egp.fLocalMatrix,
                                 args.fFPCoordTransformHandler);

            // for outer curve
            fragBuilder->codeAppendf("vec2 scaledOffset = %s*%s.xy;", ellipseOffsets.fsIn(),
                                     ellipseRadii.fsIn());
            fragBuilder->codeAppend("float test = dot(scaledOffset, scaledOffset) - 1.0;");
            fragBuilder->codeAppendf("vec2 grad = 2.0*scaledOffset*%s.xy;", ellipseRadii.fsIn());
            fragBuilder->codeAppend("float grad_dot = dot(grad, grad);");

            // avoid calling inversesqrt on zero.
            fragBuilder->codeAppend("grad_dot = max(grad_dot, 1.0e-4);");
            fragBuilder->codeAppend("float invlen = inversesqrt(grad_dot);");
            fragBuilder->codeAppend("float edgeAlpha = clamp(0.5-test*invlen, 0.0, 1.0);");

            // for inner curve
            if (egp.fStroke) {
                fragBuilder->codeAppendf("scaledOffset = %s*%s.zw;",
                                         ellipseOffsets.fsIn(), ellipseRadii.fsIn());
                fragBuilder->codeAppend("test = dot(scaledOffset, scaledOffset) - 1.0;");
                fragBuilder->codeAppendf("grad = 2.0*scaledOffset*%s.zw;",
                                         ellipseRadii.fsIn());
                fragBuilder->codeAppend("invlen = inversesqrt(dot(grad, grad));");
                fragBuilder->codeAppend("edgeAlpha *= clamp(0.5+test*invlen, 0.0, 1.0);");
            }

            fragBuilder->codeAppendf("%s = vec4(edgeAlpha);", args.fOutputCoverage);
        }

        static void GenKey(const GrGeometryProcessor& gp,
                           const GrGLSLCaps&,
                           GrProcessorKeyBuilder* b) {
            const EllipseGeometryProcessor& egp = gp.cast<EllipseGeometryProcessor>();
            uint16_t key = egp.fStroke ? 0x1 : 0x0;
            key |= egp.fLocalMatrix.hasPerspective() ? 0x2 : 0x0;
            b->add32(key);
        }

        void setData(const GrGLSLProgramDataManager& pdman, const GrPrimitiveProcessor& primProc,
                     FPCoordTransformIter&& transformIter) override {
            const EllipseGeometryProcessor& egp = primProc.cast<EllipseGeometryProcessor>();
            this->setTransformDataHelper(egp.fLocalMatrix, pdman, &transformIter);
        }

    private:
        typedef GrGLSLGeometryProcessor INHERITED;
    };

    const Attribute* fInPosition;
    const Attribute* fInColor;
    const Attribute* fInEllipseOffset;
    const Attribute* fInEllipseRadii;
    SkMatrix fLocalMatrix;
    bool fStroke;

    GR_DECLARE_GEOMETRY_PROCESSOR_TEST;

    typedef GrGeometryProcessor INHERITED;
};

GR_DEFINE_GEOMETRY_PROCESSOR_TEST(EllipseGeometryProcessor);

sk_sp<GrGeometryProcessor> EllipseGeometryProcessor::TestCreate(GrProcessorTestData* d) {
    return sk_sp<GrGeometryProcessor>(
        new EllipseGeometryProcessor(d->fRandom->nextBool(), GrTest::TestMatrix(d->fRandom)));
}

///////////////////////////////////////////////////////////////////////////////

/**
 * The output of this effect is a modulation of the input color and coverage for an ellipse,
 * specified as a 2D offset from center for both the outer and inner paths (if stroked). The
 * implict equation used is for a unit circle (x^2 + y^2 - 1 = 0) and the edge corrected by
 * using differentials.
 *
 * The result is device-independent and can be used with any affine matrix.
 */

enum class DIEllipseStyle { kStroke = 0, kHairline, kFill };

class DIEllipseGeometryProcessor : public GrGeometryProcessor {
public:
    DIEllipseGeometryProcessor(const SkMatrix& viewMatrix, DIEllipseStyle style)
        : fViewMatrix(viewMatrix) {
        this->initClassID<DIEllipseGeometryProcessor>();
        fInPosition = &this->addVertexAttrib("inPosition", kVec2f_GrVertexAttribType,
                                             kHigh_GrSLPrecision);
        fInColor = &this->addVertexAttrib("inColor", kVec4ub_GrVertexAttribType);
        fInEllipseOffsets0 = &this->addVertexAttrib("inEllipseOffsets0", kVec2f_GrVertexAttribType);
        fInEllipseOffsets1 = &this->addVertexAttrib("inEllipseOffsets1", kVec2f_GrVertexAttribType);
        fStyle = style;
    }


    virtual ~DIEllipseGeometryProcessor() {}

    const char* name() const override { return "DIEllipseEdge"; }

    void getGLSLProcessorKey(const GrGLSLCaps& caps, GrProcessorKeyBuilder* b) const override {
        GLSLProcessor::GenKey(*this, caps, b);
    }

    GrGLSLPrimitiveProcessor* createGLSLInstance(const GrGLSLCaps&) const override {
        return new GLSLProcessor();
    }

private:
    class GLSLProcessor : public GrGLSLGeometryProcessor {
    public:
        GLSLProcessor()
            : fViewMatrix(SkMatrix::InvalidMatrix()) {}

        void onEmitCode(EmitArgs& args, GrGPArgs* gpArgs) override {
            const DIEllipseGeometryProcessor& diegp = args.fGP.cast<DIEllipseGeometryProcessor>();
            GrGLSLVertexBuilder* vertBuilder = args.fVertBuilder;
            GrGLSLVaryingHandler* varyingHandler = args.fVaryingHandler;
            GrGLSLUniformHandler* uniformHandler = args.fUniformHandler;

            // emit attributes
            varyingHandler->emitAttributes(diegp);

            GrGLSLVertToFrag offsets0(kVec2f_GrSLType);
            varyingHandler->addVarying("EllipseOffsets0", &offsets0);
            vertBuilder->codeAppendf("%s = %s;", offsets0.vsOut(),
                                     diegp.fInEllipseOffsets0->fName);

            GrGLSLVertToFrag offsets1(kVec2f_GrSLType);
            varyingHandler->addVarying("EllipseOffsets1", &offsets1);
            vertBuilder->codeAppendf("%s = %s;", offsets1.vsOut(),
                                     diegp.fInEllipseOffsets1->fName);

            GrGLSLPPFragmentBuilder* fragBuilder = args.fFragBuilder;
            varyingHandler->addPassThroughAttribute(diegp.fInColor, args.fOutputColor);

            // Setup position
            this->setupPosition(vertBuilder,
                                uniformHandler,
                                gpArgs,
                                diegp.fInPosition->fName,
                                diegp.fViewMatrix,
                                &fViewMatrixUniform);

            // emit transforms
            this->emitTransforms(vertBuilder,
                                 varyingHandler,
                                 uniformHandler,
                                 gpArgs->fPositionVar,
                                 diegp.fInPosition->fName,
                                 args.fFPCoordTransformHandler);

            SkAssertResult(fragBuilder->enableFeature(
                    GrGLSLFragmentShaderBuilder::kStandardDerivatives_GLSLFeature));
            // for outer curve
            fragBuilder->codeAppendf("vec2 scaledOffset = %s.xy;", offsets0.fsIn());
            fragBuilder->codeAppend("float test = dot(scaledOffset, scaledOffset) - 1.0;");
            fragBuilder->codeAppendf("vec2 duvdx = dFdx(%s);", offsets0.fsIn());
            fragBuilder->codeAppendf("vec2 duvdy = dFdy(%s);", offsets0.fsIn());
            fragBuilder->codeAppendf("vec2 grad = vec2(2.0*%s.x*duvdx.x + 2.0*%s.y*duvdx.y,"
                                     "                 2.0*%s.x*duvdy.x + 2.0*%s.y*duvdy.y);",
                                     offsets0.fsIn(), offsets0.fsIn(), offsets0.fsIn(),
                                     offsets0.fsIn());

            fragBuilder->codeAppend("float grad_dot = dot(grad, grad);");
            // avoid calling inversesqrt on zero.
            fragBuilder->codeAppend("grad_dot = max(grad_dot, 1.0e-4);");
            fragBuilder->codeAppend("float invlen = inversesqrt(grad_dot);");
            if (DIEllipseStyle::kHairline == diegp.fStyle) {
                // can probably do this with one step
                fragBuilder->codeAppend("float edgeAlpha = clamp(1.0-test*invlen, 0.0, 1.0);");
                fragBuilder->codeAppend("edgeAlpha *= clamp(1.0+test*invlen, 0.0, 1.0);");
            } else {
                fragBuilder->codeAppend("float edgeAlpha = clamp(0.5-test*invlen, 0.0, 1.0);");
            }

            // for inner curve
            if (DIEllipseStyle::kStroke == diegp.fStyle) {
                fragBuilder->codeAppendf("scaledOffset = %s.xy;", offsets1.fsIn());
                fragBuilder->codeAppend("test = dot(scaledOffset, scaledOffset) - 1.0;");
                fragBuilder->codeAppendf("duvdx = dFdx(%s);", offsets1.fsIn());
                fragBuilder->codeAppendf("duvdy = dFdy(%s);", offsets1.fsIn());
                fragBuilder->codeAppendf("grad = vec2(2.0*%s.x*duvdx.x + 2.0*%s.y*duvdx.y,"
                                         "            2.0*%s.x*duvdy.x + 2.0*%s.y*duvdy.y);",
                                         offsets1.fsIn(), offsets1.fsIn(), offsets1.fsIn(),
                                         offsets1.fsIn());
                fragBuilder->codeAppend("invlen = inversesqrt(dot(grad, grad));");
                fragBuilder->codeAppend("edgeAlpha *= clamp(0.5+test*invlen, 0.0, 1.0);");
            }

            fragBuilder->codeAppendf("%s = vec4(edgeAlpha);", args.fOutputCoverage);
        }

        static void GenKey(const GrGeometryProcessor& gp,
                           const GrGLSLCaps&,
                           GrProcessorKeyBuilder* b) {
            const DIEllipseGeometryProcessor& diegp = gp.cast<DIEllipseGeometryProcessor>();
            uint16_t key = static_cast<uint16_t>(diegp.fStyle);
            key |= ComputePosKey(diegp.fViewMatrix) << 10;
            b->add32(key);
        }

        void setData(const GrGLSLProgramDataManager& pdman, const GrPrimitiveProcessor& gp,
                     FPCoordTransformIter&& transformIter) override {
            const DIEllipseGeometryProcessor& diegp = gp.cast<DIEllipseGeometryProcessor>();

            if (!diegp.fViewMatrix.isIdentity() && !fViewMatrix.cheapEqualTo(diegp.fViewMatrix)) {
                fViewMatrix = diegp.fViewMatrix;
                float viewMatrix[3 * 3];
                GrGLSLGetMatrix<3>(viewMatrix, fViewMatrix);
                pdman.setMatrix3f(fViewMatrixUniform, viewMatrix);
            }
            this->setTransformDataHelper(SkMatrix::I(), pdman, &transformIter);
        }

    private:
        SkMatrix fViewMatrix;
        UniformHandle fViewMatrixUniform;

        typedef GrGLSLGeometryProcessor INHERITED;
    };

    const Attribute* fInPosition;
    const Attribute* fInColor;
    const Attribute* fInEllipseOffsets0;
    const Attribute* fInEllipseOffsets1;
    SkMatrix         fViewMatrix;
    DIEllipseStyle   fStyle;

    GR_DECLARE_GEOMETRY_PROCESSOR_TEST;

    typedef GrGeometryProcessor INHERITED;
};

GR_DEFINE_GEOMETRY_PROCESSOR_TEST(DIEllipseGeometryProcessor);

sk_sp<GrGeometryProcessor> DIEllipseGeometryProcessor::TestCreate(GrProcessorTestData* d) {
    return sk_sp<GrGeometryProcessor>(
        new DIEllipseGeometryProcessor(GrTest::TestMatrix(d->fRandom),
                                       (DIEllipseStyle)(d->fRandom->nextRangeU(0,2))));
}

///////////////////////////////////////////////////////////////////////////////

class CircleBatch : public GrVertexBatch {
public:
    DEFINE_BATCH_CLASS_ID

    /** Optional extra params to render a partial arc rather than a full circle. */
    struct ArcParams {
        SkScalar fStartAngleRadians;
        SkScalar fSweepAngleRadians;
        bool fUseCenter;
    };
    static GrDrawBatch* Create(GrColor color, const SkMatrix& viewMatrix, SkPoint center,
                               SkScalar radius, const GrStyle& style,
                               const ArcParams* arcParams = nullptr) {
        SkASSERT(circle_stays_circle(viewMatrix));
        const SkStrokeRec& stroke = style.strokeRec();
        if (style.hasPathEffect()) {
            return nullptr;
        }
        SkStrokeRec::Style recStyle = stroke.getStyle();
        if (arcParams) {
            // Arc support depends on the style.
            switch (recStyle) {
                case SkStrokeRec::kStrokeAndFill_Style:
                    // This produces a strange result that this batch doesn't implement.
                    return nullptr;
                case SkStrokeRec::kFill_Style:
                    // This supports all fills.
                    break;
                case SkStrokeRec::kStroke_Style: // fall through
                case SkStrokeRec::kHairline_Style:
                    // Strokes that don't use the center point are supported with butt cap.
                    if (arcParams->fUseCenter || stroke.getCap() != SkPaint::kButt_Cap) {
                        return nullptr;
                    }
                    break;
            }
        }

        viewMatrix.mapPoints(&center, 1);
        radius = viewMatrix.mapRadius(radius);
        SkScalar strokeWidth = viewMatrix.mapRadius(stroke.getWidth());

        bool isStrokeOnly = SkStrokeRec::kStroke_Style == recStyle ||
                            SkStrokeRec::kHairline_Style == recStyle;
        bool hasStroke = isStrokeOnly || SkStrokeRec::kStrokeAndFill_Style == recStyle;

        SkScalar innerRadius = 0.0f;
        SkScalar outerRadius = radius;
        SkScalar halfWidth = 0;
        if (hasStroke) {
            if (SkScalarNearlyZero(strokeWidth)) {
                halfWidth = SK_ScalarHalf;
            } else {
                halfWidth = SkScalarHalf(strokeWidth);
            }

            outerRadius += halfWidth;
            if (isStrokeOnly) {
                innerRadius = radius - halfWidth;
            }
        }

        // The radii are outset for two reasons. First, it allows the shader to simply perform
        // simpler computation because the computed alpha is zero, rather than 50%, at the radius.
        // Second, the outer radius is used to compute the verts of the bounding box that is
        // rendered and the outset ensures the box will cover all partially covered by the circle.
        outerRadius += SK_ScalarHalf;
        innerRadius -= SK_ScalarHalf;
        CircleBatch* batch = new CircleBatch();
        batch->fViewMatrixIfUsingLocalCoords = viewMatrix;

        // This makes every point fully inside the intersection plane.
        static constexpr SkScalar kUnusedIsectPlane[] = {0.f, 0.f, 1.f};
        // This makes every point fully outside the union plane.
        static constexpr SkScalar kUnusedUnionPlane[] = {0.f, 0.f, 0.f};
        SkRect devBounds = SkRect::MakeLTRB(center.fX - outerRadius, center.fY - outerRadius,
                                            center.fX + outerRadius, center.fY + outerRadius);

        if (arcParams) {
            // The shader operates in a space where the circle is translated to be centered at the
            // origin. Here we compute points on the unit circle at the starting and ending angles.
            SkPoint startPoint, stopPoint;
            startPoint.fY = SkScalarSinCos(arcParams->fStartAngleRadians, &startPoint.fX);
            SkScalar endAngle = arcParams->fStartAngleRadians + arcParams->fSweepAngleRadians;
            stopPoint.fY = SkScalarSinCos(endAngle, &stopPoint.fX);
            // Like a fill without useCenter, butt-cap stroke can be implemented by clipping against
            // radial lines. However, in both cases we have to be careful about the half-circle.
            // case. In that case the two radial lines are equal and so that edge gets clipped
            // twice. Since the shared edge goes through the center we fall back on the useCenter
            // case.
            bool useCenter = (arcParams->fUseCenter || isStrokeOnly) &&
                             !SkScalarNearlyEqual(SkScalarAbs(arcParams->fSweepAngleRadians),
                                                  SK_ScalarPI);
            if (useCenter) {
                SkVector norm0 = {startPoint.fY, -startPoint.fX};
                SkVector norm1 = {stopPoint.fY, -stopPoint.fX};
                if (arcParams->fSweepAngleRadians > 0) {
                    norm0.negate();
                } else {
                    norm1.negate();
                }
                batch->fClipPlane = true;
                if (SkScalarAbs(arcParams->fSweepAngleRadians) > SK_ScalarPI) {
                    batch->fGeoData.emplace_back(Geometry {
                            color,
                            innerRadius,
                            outerRadius,
                            {norm0.fX, norm0.fY, 0.5f},
                            {kUnusedIsectPlane[0], kUnusedIsectPlane[1], kUnusedIsectPlane[2]},
                            {norm1.fX, norm1.fY, 0.5f},
                            devBounds
                    });
                    batch->fClipPlaneIsect = false;
                    batch->fClipPlaneUnion = true;
                } else {
                    batch->fGeoData.emplace_back(Geometry {
                            color,
                            innerRadius,
                            outerRadius,
                            {norm0.fX, norm0.fY, 0.5f},
                            {norm1.fX, norm1.fY, 0.5f},
                            {kUnusedUnionPlane[0], kUnusedUnionPlane[1], kUnusedUnionPlane[2]},
                            devBounds
                    });
                    batch->fClipPlaneIsect = true;
                    batch->fClipPlaneUnion = false;
                }
            } else {
                // We clip to a secant of the original circle.
                startPoint.scale(radius);
                stopPoint.scale(radius);
                SkVector norm = {startPoint.fY - stopPoint.fY, stopPoint.fX - startPoint.fX};
                norm.normalize();
                if (arcParams->fSweepAngleRadians > 0) {
                    norm.negate();
                }
                SkScalar d = -norm.dot(startPoint) + 0.5f;

                batch->fGeoData.emplace_back(Geometry {
                        color,
                        innerRadius,
                        outerRadius,
                        {norm.fX, norm.fY, d},
                        {kUnusedIsectPlane[0], kUnusedIsectPlane[1], kUnusedIsectPlane[2]},
                        {kUnusedUnionPlane[0], kUnusedUnionPlane[1], kUnusedUnionPlane[2]},
                        devBounds
                });
                batch->fClipPlane = true;
                batch->fClipPlaneIsect = false;
                batch->fClipPlaneUnion = false;
            }
        } else {
            batch->fGeoData.emplace_back(Geometry {
                color,
                innerRadius,
                outerRadius,
                {kUnusedIsectPlane[0], kUnusedIsectPlane[1], kUnusedIsectPlane[2]},
                {kUnusedIsectPlane[0], kUnusedIsectPlane[1], kUnusedIsectPlane[2]},
                {kUnusedUnionPlane[0], kUnusedUnionPlane[1], kUnusedUnionPlane[2]},
                devBounds
            });
            batch->fClipPlane = false;
            batch->fClipPlaneIsect = false;
            batch->fClipPlaneUnion = false;
        }
        // Use the original radius and stroke radius for the bounds so that it does not include the
        // AA bloat.
        radius += halfWidth;
        batch->setBounds({center.fX - radius, center.fY - radius,
                          center.fX + radius, center.fY + radius},
                          HasAABloat::kYes, IsZeroArea::kNo);
        batch->fStroked = isStrokeOnly && innerRadius > 0;
        return batch;
    }

    const char* name() const override { return "CircleBatch"; }

    SkString dumpInfo() const override {
        SkString string;
        for (int i = 0; i < fGeoData.count(); ++i) {
            string.appendf("Color: 0x%08x Rect [L: %.2f, T: %.2f, R: %.2f, B: %.2f],"
                           "InnerRad: %.2f, OuterRad: %.2f\n",
                           fGeoData[i].fColor,
                           fGeoData[i].fDevBounds.fLeft, fGeoData[i].fDevBounds.fTop,
                           fGeoData[i].fDevBounds.fRight, fGeoData[i].fDevBounds.fBottom,
                           fGeoData[i].fInnerRadius,
                           fGeoData[i].fOuterRadius);
        }
        string.append(INHERITED::dumpInfo());
        return string;
    }

    void computePipelineOptimizations(GrInitInvariantOutput* color,
                                      GrInitInvariantOutput* coverage,
                                      GrBatchToXPOverrides* overrides) const override {
        // When this is called on a batch, there is only one geometry bundle
        color->setKnownFourComponents(fGeoData[0].fColor);
        coverage->setUnknownSingleComponent();
    }

private:
    CircleBatch() : INHERITED(ClassID()) {}
    void initBatchTracker(const GrXPOverridesForBatch& overrides) override {
        // Handle any overrides that affect our GP.
        overrides.getOverrideColorIfSet(&fGeoData[0].fColor);
        if (!overrides.readsLocalCoords()) {
            fViewMatrixIfUsingLocalCoords.reset();
        }
    }

    void onPrepareDraws(Target* target) const override {
        SkMatrix localMatrix;
        if (!fViewMatrixIfUsingLocalCoords.invert(&localMatrix)) {
            return;
        }

        // Setup geometry processor
        SkAutoTUnref<GrGeometryProcessor> gp(new CircleGeometryProcessor(fStroked, fClipPlane,
                                                                         fClipPlaneIsect,
                                                                         fClipPlaneUnion,
                                                                         localMatrix));

        struct CircleVertex {
            SkPoint  fPos;
            GrColor  fColor;
            SkPoint  fOffset;
            SkScalar fOuterRadius;
            SkScalar fInnerRadius;
            // These planes may or may not be present in the vertex buffer.
            SkScalar fHalfPlanes[3][3];
        };

        int instanceCount = fGeoData.count();
        size_t vertexStride = gp->getVertexStride();
        SkASSERT(vertexStride == sizeof(CircleVertex) - (fClipPlane ? 0 : 3 * sizeof(SkScalar))
                                                      - (fClipPlaneIsect? 0 : 3 * sizeof(SkScalar))
                                                      - (fClipPlaneUnion? 0 : 3 * sizeof(SkScalar)));
        QuadHelper helper;
        char* vertices = reinterpret_cast<char*>(helper.init(target, vertexStride, instanceCount));
        if (!vertices) {
            return;
        }

        for (int i = 0; i < instanceCount; i++) {
            const Geometry& geom = fGeoData[i];

            GrColor color = geom.fColor;
            SkScalar innerRadius = geom.fInnerRadius;
            SkScalar outerRadius = geom.fOuterRadius;

            const SkRect& bounds = geom.fDevBounds;
            CircleVertex* v0 = reinterpret_cast<CircleVertex*>(vertices + (4 * i + 0)*vertexStride);
            CircleVertex* v1 = reinterpret_cast<CircleVertex*>(vertices + (4 * i + 1)*vertexStride);
            CircleVertex* v2 = reinterpret_cast<CircleVertex*>(vertices + (4 * i + 2)*vertexStride);
            CircleVertex* v3 = reinterpret_cast<CircleVertex*>(vertices + (4 * i + 3)*vertexStride);

            // The inner radius in the vertex data must be specified in normalized space.
            innerRadius = innerRadius / outerRadius;
            v0->fPos = SkPoint::Make(bounds.fLeft,  bounds.fTop);
            v0->fColor = color;
            v0->fOffset = SkPoint::Make(-1, -1);
            v0->fOuterRadius = outerRadius;
            v0->fInnerRadius = innerRadius;

            v1->fPos = SkPoint::Make(bounds.fLeft,  bounds.fBottom);
            v1->fColor = color;
            v1->fOffset = SkPoint::Make(-1, 1);
            v1->fOuterRadius = outerRadius;
            v1->fInnerRadius = innerRadius;

            v2->fPos = SkPoint::Make(bounds.fRight, bounds.fBottom);
            v2->fColor = color;
            v2->fOffset = SkPoint::Make(1, 1);
            v2->fOuterRadius = outerRadius;
            v2->fInnerRadius = innerRadius;

            v3->fPos = SkPoint::Make(bounds.fRight, bounds.fTop);
            v3->fColor = color;
            v3->fOffset = SkPoint::Make(1, -1);
            v3->fOuterRadius = outerRadius;
            v3->fInnerRadius = innerRadius;

            if (fClipPlane) {
                memcpy(v0->fHalfPlanes[0], geom.fClipPlane, 3 * sizeof(SkScalar));
                memcpy(v1->fHalfPlanes[0], geom.fClipPlane, 3 * sizeof(SkScalar));
                memcpy(v2->fHalfPlanes[0], geom.fClipPlane, 3 * sizeof(SkScalar));
                memcpy(v3->fHalfPlanes[0], geom.fClipPlane, 3 * sizeof(SkScalar));
            }
            int unionIdx = 1;
            if (fClipPlaneIsect) {
                memcpy(v0->fHalfPlanes[1], geom.fIsectPlane, 3 * sizeof(SkScalar));
                memcpy(v1->fHalfPlanes[1], geom.fIsectPlane, 3 * sizeof(SkScalar));
                memcpy(v2->fHalfPlanes[1], geom.fIsectPlane, 3 * sizeof(SkScalar));
                memcpy(v3->fHalfPlanes[1], geom.fIsectPlane, 3 * sizeof(SkScalar));
                unionIdx = 2;
            }
            if (fClipPlaneUnion) {
                memcpy(v0->fHalfPlanes[unionIdx], geom.fUnionPlane, 3 * sizeof(SkScalar));
                memcpy(v1->fHalfPlanes[unionIdx], geom.fUnionPlane, 3 * sizeof(SkScalar));
                memcpy(v2->fHalfPlanes[unionIdx], geom.fUnionPlane, 3 * sizeof(SkScalar));
                memcpy(v3->fHalfPlanes[unionIdx], geom.fUnionPlane, 3 * sizeof(SkScalar));
            }
        }
        helper.recordDraw(target, gp);
    }

    bool onCombineIfPossible(GrBatch* t, const GrCaps& caps) override {
        CircleBatch* that = t->cast<CircleBatch>();
        if (!GrPipeline::CanCombine(*this->pipeline(), this->bounds(), *that->pipeline(),
                                    that->bounds(), caps)) {
            return false;
        }

        if (this->fStroked != that->fStroked) {
            return false;
        }

        // Because we've set up the batches that don't use the planes with noop values
        // we can just accumulate used planes by later batches.
        fClipPlane |= that->fClipPlane;
        fClipPlaneIsect |= that->fClipPlaneIsect;
        fClipPlaneUnion |= that->fClipPlaneUnion;

        if (!fViewMatrixIfUsingLocalCoords.cheapEqualTo(that->fViewMatrixIfUsingLocalCoords)) {
            return false;
        }

        fGeoData.push_back_n(that->fGeoData.count(), that->fGeoData.begin());
        this->joinBounds(*that);
        return true;
    }

    struct Geometry {
        GrColor  fColor;
        SkScalar fInnerRadius;
        SkScalar fOuterRadius;
        SkScalar fClipPlane[3];
        SkScalar fIsectPlane[3];
        SkScalar fUnionPlane[3];
        SkRect   fDevBounds;
    };

    bool                         fStroked;
    bool                         fClipPlane;
    bool                         fClipPlaneIsect;
    bool                         fClipPlaneUnion;
    SkMatrix                     fViewMatrixIfUsingLocalCoords;
    SkSTArray<1, Geometry, true> fGeoData;

    typedef GrVertexBatch INHERITED;
};

///////////////////////////////////////////////////////////////////////////////

class EllipseBatch : public GrVertexBatch {
public:
    DEFINE_BATCH_CLASS_ID
    static GrDrawBatch* Create(GrColor color, const SkMatrix& viewMatrix, const SkRect& ellipse,
                               const SkStrokeRec& stroke) {
        SkASSERT(viewMatrix.rectStaysRect());

        // do any matrix crunching before we reset the draw state for device coords
        SkPoint center = SkPoint::Make(ellipse.centerX(), ellipse.centerY());
        viewMatrix.mapPoints(&center, 1);
        SkScalar ellipseXRadius = SkScalarHalf(ellipse.width());
        SkScalar ellipseYRadius = SkScalarHalf(ellipse.height());
        SkScalar xRadius = SkScalarAbs(viewMatrix[SkMatrix::kMScaleX]*ellipseXRadius +
                                       viewMatrix[SkMatrix::kMSkewY]*ellipseYRadius);
        SkScalar yRadius = SkScalarAbs(viewMatrix[SkMatrix::kMSkewX]*ellipseXRadius +
                                       viewMatrix[SkMatrix::kMScaleY]*ellipseYRadius);

        // do (potentially) anisotropic mapping of stroke
        SkVector scaledStroke;
        SkScalar strokeWidth = stroke.getWidth();
        scaledStroke.fX = SkScalarAbs(strokeWidth*(viewMatrix[SkMatrix::kMScaleX] +
                                                   viewMatrix[SkMatrix::kMSkewY]));
        scaledStroke.fY = SkScalarAbs(strokeWidth*(viewMatrix[SkMatrix::kMSkewX] +
                                                   viewMatrix[SkMatrix::kMScaleY]));

        SkStrokeRec::Style style = stroke.getStyle();
        bool isStrokeOnly = SkStrokeRec::kStroke_Style == style ||
                            SkStrokeRec::kHairline_Style == style;
        bool hasStroke = isStrokeOnly || SkStrokeRec::kStrokeAndFill_Style == style;

        SkScalar innerXRadius = 0;
        SkScalar innerYRadius = 0;
        if (hasStroke) {
            if (SkScalarNearlyZero(scaledStroke.length())) {
                scaledStroke.set(SK_ScalarHalf, SK_ScalarHalf);
            } else {
                scaledStroke.scale(SK_ScalarHalf);
            }

            // we only handle thick strokes for near-circular ellipses
            if (scaledStroke.length() > SK_ScalarHalf &&
                (SK_ScalarHalf*xRadius > yRadius || SK_ScalarHalf*yRadius > xRadius)) {
                return nullptr;
            }

            // we don't handle it if curvature of the stroke is less than curvature of the ellipse
            if (scaledStroke.fX*(yRadius*yRadius) < (scaledStroke.fY*scaledStroke.fY)*xRadius ||
                scaledStroke.fY*(xRadius*xRadius) < (scaledStroke.fX*scaledStroke.fX)*yRadius) {
                return nullptr;
            }

            // this is legit only if scale & translation (which should be the case at the moment)
            if (isStrokeOnly) {
                innerXRadius = xRadius - scaledStroke.fX;
                innerYRadius = yRadius - scaledStroke.fY;
            }

            xRadius += scaledStroke.fX;
            yRadius += scaledStroke.fY;
        }

        EllipseBatch* batch = new EllipseBatch();
        batch->fGeoData.emplace_back(Geometry {
            color,
            xRadius,
            yRadius,
            innerXRadius,
            innerYRadius,
            SkRect::MakeLTRB(center.fX - xRadius, center.fY - yRadius,
                             center.fX + xRadius, center.fY + yRadius)
        });

        batch->setBounds(batch->fGeoData.back().fDevBounds, HasAABloat::kYes, IsZeroArea::kNo);

        // Outset bounds to include half-pixel width antialiasing.
        batch->fGeoData[0].fDevBounds.outset(SK_ScalarHalf, SK_ScalarHalf);

        batch->fStroked = isStrokeOnly && innerXRadius > 0 && innerYRadius > 0;
        batch->fViewMatrixIfUsingLocalCoords = viewMatrix;
        return batch;
    }

    const char* name() const override { return "EllipseBatch"; }

    void computePipelineOptimizations(GrInitInvariantOutput* color,
                                      GrInitInvariantOutput* coverage,
                                      GrBatchToXPOverrides* overrides) const override {
        // When this is called on a batch, there is only one geometry bundle
        color->setKnownFourComponents(fGeoData[0].fColor);
        coverage->setUnknownSingleComponent();
    }

private:
    EllipseBatch() : INHERITED(ClassID()) {}

    void initBatchTracker(const GrXPOverridesForBatch& overrides) override {
        // Handle any overrides that affect our GP.
        if (!overrides.readsCoverage()) {
            fGeoData[0].fColor = GrColor_ILLEGAL;
        }
        if (!overrides.readsLocalCoords()) {
            fViewMatrixIfUsingLocalCoords.reset();
        }
    }

    void onPrepareDraws(Target* target) const override {
        SkMatrix localMatrix;
        if (!fViewMatrixIfUsingLocalCoords.invert(&localMatrix)) {
            return;
        }

        // Setup geometry processor
        SkAutoTUnref<GrGeometryProcessor> gp(new EllipseGeometryProcessor(fStroked, localMatrix));

        int instanceCount = fGeoData.count();
        QuadHelper helper;
        size_t vertexStride = gp->getVertexStride();
        SkASSERT(vertexStride == sizeof(EllipseVertex));
        EllipseVertex* verts = reinterpret_cast<EllipseVertex*>(
            helper.init(target, vertexStride, instanceCount));
        if (!verts) {
            return;
        }

        for (int i = 0; i < instanceCount; i++) {
            const Geometry& geom = fGeoData[i];

            GrColor color = geom.fColor;
            SkScalar xRadius = geom.fXRadius;
            SkScalar yRadius = geom.fYRadius;

            // Compute the reciprocals of the radii here to save time in the shader
            SkScalar xRadRecip = SkScalarInvert(xRadius);
            SkScalar yRadRecip = SkScalarInvert(yRadius);
            SkScalar xInnerRadRecip = SkScalarInvert(geom.fInnerXRadius);
            SkScalar yInnerRadRecip = SkScalarInvert(geom.fInnerYRadius);

            const SkRect& bounds = geom.fDevBounds;

            // fOffsets are expanded from xyRadii to include the half-pixel antialiasing width.
            SkScalar xMaxOffset = xRadius + SK_ScalarHalf;
            SkScalar yMaxOffset = yRadius + SK_ScalarHalf;

            // The inner radius in the vertex data must be specified in normalized space.
            verts[0].fPos = SkPoint::Make(bounds.fLeft,  bounds.fTop);
            verts[0].fColor = color;
            verts[0].fOffset = SkPoint::Make(-xMaxOffset, -yMaxOffset);
            verts[0].fOuterRadii = SkPoint::Make(xRadRecip, yRadRecip);
            verts[0].fInnerRadii = SkPoint::Make(xInnerRadRecip, yInnerRadRecip);

            verts[1].fPos = SkPoint::Make(bounds.fLeft,  bounds.fBottom);
            verts[1].fColor = color;
            verts[1].fOffset = SkPoint::Make(-xMaxOffset, yMaxOffset);
            verts[1].fOuterRadii = SkPoint::Make(xRadRecip, yRadRecip);
            verts[1].fInnerRadii = SkPoint::Make(xInnerRadRecip, yInnerRadRecip);

            verts[2].fPos = SkPoint::Make(bounds.fRight, bounds.fBottom);
            verts[2].fColor = color;
            verts[2].fOffset = SkPoint::Make(xMaxOffset, yMaxOffset);
            verts[2].fOuterRadii = SkPoint::Make(xRadRecip, yRadRecip);
            verts[2].fInnerRadii = SkPoint::Make(xInnerRadRecip, yInnerRadRecip);

            verts[3].fPos = SkPoint::Make(bounds.fRight, bounds.fTop);
            verts[3].fColor = color;
            verts[3].fOffset = SkPoint::Make(xMaxOffset, -yMaxOffset);
            verts[3].fOuterRadii = SkPoint::Make(xRadRecip, yRadRecip);
            verts[3].fInnerRadii = SkPoint::Make(xInnerRadRecip, yInnerRadRecip);

            verts += kVerticesPerQuad;
        }
        helper.recordDraw(target, gp);
    }

    bool onCombineIfPossible(GrBatch* t, const GrCaps& caps) override {
        EllipseBatch* that = t->cast<EllipseBatch>();

        if (!GrPipeline::CanCombine(*this->pipeline(), this->bounds(), *that->pipeline(),
                                    that->bounds(), caps)) {
            return false;
        }

        if (fStroked != that->fStroked) {
            return false;
        }

        if (!fViewMatrixIfUsingLocalCoords.cheapEqualTo(that->fViewMatrixIfUsingLocalCoords)) {
            return false;
        }

        fGeoData.push_back_n(that->fGeoData.count(), that->fGeoData.begin());
        this->joinBounds(*that);
        return true;
    }

    struct Geometry {
        GrColor fColor;
        SkScalar fXRadius;
        SkScalar fYRadius;
        SkScalar fInnerXRadius;
        SkScalar fInnerYRadius;
        SkRect fDevBounds;
    };

    bool                         fStroked;
    SkMatrix                     fViewMatrixIfUsingLocalCoords;
    SkSTArray<1, Geometry, true> fGeoData;

    typedef GrVertexBatch INHERITED;
};

/////////////////////////////////////////////////////////////////////////////////////////////////

class DIEllipseBatch : public GrVertexBatch {
public:
    DEFINE_BATCH_CLASS_ID

    static GrDrawBatch* Create(GrColor color,
                               const SkMatrix& viewMatrix,
                               const SkRect& ellipse,
                               const SkStrokeRec& stroke) {
        SkPoint center = SkPoint::Make(ellipse.centerX(), ellipse.centerY());
        SkScalar xRadius = SkScalarHalf(ellipse.width());
        SkScalar yRadius = SkScalarHalf(ellipse.height());

        SkStrokeRec::Style style = stroke.getStyle();
        DIEllipseStyle dieStyle = (SkStrokeRec::kStroke_Style == style) ?
                                  DIEllipseStyle::kStroke :
                                  (SkStrokeRec::kHairline_Style == style) ?
                                  DIEllipseStyle::kHairline : DIEllipseStyle::kFill;

        SkScalar innerXRadius = 0;
        SkScalar innerYRadius = 0;
        if (SkStrokeRec::kFill_Style != style && SkStrokeRec::kHairline_Style != style) {
            SkScalar strokeWidth = stroke.getWidth();

            if (SkScalarNearlyZero(strokeWidth)) {
                strokeWidth = SK_ScalarHalf;
            } else {
                strokeWidth *= SK_ScalarHalf;
            }

            // we only handle thick strokes for near-circular ellipses
            if (strokeWidth > SK_ScalarHalf &&
                (SK_ScalarHalf*xRadius > yRadius || SK_ScalarHalf*yRadius > xRadius)) {
                return nullptr;
            }

            // we don't handle it if curvature of the stroke is less than curvature of the ellipse
            if (strokeWidth*(yRadius*yRadius) < (strokeWidth*strokeWidth)*xRadius ||
                strokeWidth*(xRadius*xRadius) < (strokeWidth*strokeWidth)*yRadius) {
                return nullptr;
            }

            // set inner radius (if needed)
            if (SkStrokeRec::kStroke_Style == style) {
                innerXRadius = xRadius - strokeWidth;
                innerYRadius = yRadius - strokeWidth;
            }

            xRadius += strokeWidth;
            yRadius += strokeWidth;
        }
        if (DIEllipseStyle::kStroke == dieStyle) {
            dieStyle = (innerXRadius > 0 && innerYRadius > 0) ? DIEllipseStyle ::kStroke :
                       DIEllipseStyle ::kFill;
        }

        // This expands the outer rect so that after CTM we end up with a half-pixel border
        SkScalar a = viewMatrix[SkMatrix::kMScaleX];
        SkScalar b = viewMatrix[SkMatrix::kMSkewX];
        SkScalar c = viewMatrix[SkMatrix::kMSkewY];
        SkScalar d = viewMatrix[SkMatrix::kMScaleY];
        SkScalar geoDx = SK_ScalarHalf / SkScalarSqrt(a*a + c*c);
        SkScalar geoDy = SK_ScalarHalf / SkScalarSqrt(b*b + d*d);

        DIEllipseBatch* batch = new DIEllipseBatch();
        batch->fGeoData.emplace_back(Geometry {
            viewMatrix,
            color,
            xRadius,
            yRadius,
            innerXRadius,
            innerYRadius,
            geoDx,
            geoDy,
            dieStyle,
            SkRect::MakeLTRB(center.fX - xRadius - geoDx, center.fY - yRadius - geoDy,
                             center.fX + xRadius + geoDx, center.fY + yRadius + geoDy)
        });
        batch->setTransformedBounds(batch->fGeoData[0].fBounds, viewMatrix, HasAABloat::kYes,
                                    IsZeroArea::kNo);
        return batch;
    }

    const char* name() const override { return "DIEllipseBatch"; }

    void computePipelineOptimizations(GrInitInvariantOutput* color,
                                      GrInitInvariantOutput* coverage,
                                      GrBatchToXPOverrides* overrides) const override {
        // When this is called on a batch, there is only one geometry bundle
        color->setKnownFourComponents(fGeoData[0].fColor);
        coverage->setUnknownSingleComponent();
    }

private:

    DIEllipseBatch() : INHERITED(ClassID()) {}

    void initBatchTracker(const GrXPOverridesForBatch& overrides) override {
        // Handle any overrides that affect our GP.
        overrides.getOverrideColorIfSet(&fGeoData[0].fColor);
        fUsesLocalCoords = overrides.readsLocalCoords();
    }

    void onPrepareDraws(Target* target) const override {
        // Setup geometry processor
        SkAutoTUnref<GrGeometryProcessor> gp(new DIEllipseGeometryProcessor(this->viewMatrix(),
                                                                            this->style()));

        int instanceCount = fGeoData.count();
        size_t vertexStride = gp->getVertexStride();
        SkASSERT(vertexStride == sizeof(DIEllipseVertex));
        QuadHelper helper;
        DIEllipseVertex* verts = reinterpret_cast<DIEllipseVertex*>(
            helper.init(target, vertexStride, instanceCount));
        if (!verts) {
            return;
        }

        for (int i = 0; i < instanceCount; i++) {
            const Geometry& geom = fGeoData[i];

            GrColor color = geom.fColor;
            SkScalar xRadius = geom.fXRadius;
            SkScalar yRadius = geom.fYRadius;

            const SkRect& bounds = geom.fBounds;

            // This adjusts the "radius" to include the half-pixel border
            SkScalar offsetDx = geom.fGeoDx / xRadius;
            SkScalar offsetDy = geom.fGeoDy / yRadius;

            SkScalar innerRatioX = xRadius / geom.fInnerXRadius;
            SkScalar innerRatioY = yRadius / geom.fInnerYRadius;

            verts[0].fPos = SkPoint::Make(bounds.fLeft, bounds.fTop);
            verts[0].fColor = color;
            verts[0].fOuterOffset = SkPoint::Make(-1.0f - offsetDx, -1.0f - offsetDy);
            verts[0].fInnerOffset = SkPoint::Make(-innerRatioX - offsetDx, -innerRatioY - offsetDy);

            verts[1].fPos = SkPoint::Make(bounds.fLeft,  bounds.fBottom);
            verts[1].fColor = color;
            verts[1].fOuterOffset = SkPoint::Make(-1.0f - offsetDx, 1.0f + offsetDy);
            verts[1].fInnerOffset = SkPoint::Make(-innerRatioX - offsetDx, innerRatioY + offsetDy);

            verts[2].fPos = SkPoint::Make(bounds.fRight, bounds.fBottom);
            verts[2].fColor = color;
            verts[2].fOuterOffset = SkPoint::Make(1.0f + offsetDx, 1.0f + offsetDy);
            verts[2].fInnerOffset = SkPoint::Make(innerRatioX + offsetDx, innerRatioY + offsetDy);

            verts[3].fPos = SkPoint::Make(bounds.fRight, bounds.fTop);
            verts[3].fColor = color;
            verts[3].fOuterOffset = SkPoint::Make(1.0f + offsetDx, -1.0f - offsetDy);
            verts[3].fInnerOffset = SkPoint::Make(innerRatioX + offsetDx, -innerRatioY - offsetDy);

            verts += kVerticesPerQuad;
        }
        helper.recordDraw(target, gp);
    }

    bool onCombineIfPossible(GrBatch* t, const GrCaps& caps) override {
        DIEllipseBatch* that = t->cast<DIEllipseBatch>();
        if (!GrPipeline::CanCombine(*this->pipeline(), this->bounds(), *that->pipeline(),
                                    that->bounds(), caps)) {
            return false;
        }

        if (this->style() != that->style()) {
            return false;
        }

        // TODO rewrite to allow positioning on CPU
        if (!this->viewMatrix().cheapEqualTo(that->viewMatrix())) {
            return false;
        }

        fGeoData.push_back_n(that->fGeoData.count(), that->fGeoData.begin());
        this->joinBounds(*that);
        return true;
    }

    const SkMatrix& viewMatrix() const { return fGeoData[0].fViewMatrix; }
    DIEllipseStyle style() const { return fGeoData[0].fStyle; }

    struct Geometry {
        SkMatrix fViewMatrix;
        GrColor fColor;
        SkScalar fXRadius;
        SkScalar fYRadius;
        SkScalar fInnerXRadius;
        SkScalar fInnerYRadius;
        SkScalar fGeoDx;
        SkScalar fGeoDy;
        DIEllipseStyle fStyle;
        SkRect fBounds;
    };

    bool                         fUsesLocalCoords;
    SkSTArray<1, Geometry, true> fGeoData;

    typedef GrVertexBatch INHERITED;
};

///////////////////////////////////////////////////////////////////////////////

// We have three possible cases for geometry for a roundrect.
//
// In the case of a normal fill or a stroke, we draw the roundrect as a 9-patch:
//    ____________
//   |_|________|_|
//   | |        | |
//   | |        | |
//   | |        | |
//   |_|________|_|
//   |_|________|_|
//
// For strokes, we don't draw the center quad.
//
// For circular roundrects, in the case where the stroke width is greater than twice
// the corner radius (overstroke), we add additional geometry to mark out the rectangle
// in the center. The shared vertices are duplicated so we can set a different outer radius
// for the fill calculation.
//    ____________
//   |_|________|_|
//   | |\ ____ /| |
//   | | |    | | |
//   | | |____| | |
//   |_|/______\|_|
//   |_|________|_|
//
// We don't draw the center quad from the fill rect in this case.

static const uint16_t gOverstrokeRRectIndices[] = {
    // overstroke quads
    // we place this at the beginning so that we can skip these indices when rendering normally
    16, 17, 19, 16, 19, 18,
    19, 17, 23, 19, 23, 21,
    21, 23, 22, 21, 22, 20,
    22, 16, 18, 22, 18, 20,

    // corners
    0, 1, 5, 0, 5, 4,
    2, 3, 7, 2, 7, 6,
    8, 9, 13, 8, 13, 12,
    10, 11, 15, 10, 15, 14,

    // edges
    1, 2, 6, 1, 6, 5,
    4, 5, 9, 4, 9, 8,
    6, 7, 11, 6, 11, 10,
    9, 10, 14, 9, 14, 13,

    // center
    // we place this at the end so that we can ignore these indices when not rendering as filled
    5, 6, 10, 5, 10, 9,
};
// fill and standard stroke indices skip the overstroke "ring"
static const uint16_t* gStandardRRectIndices = gOverstrokeRRectIndices + 6*4;

// overstroke count is arraysize minus the center indices
static const int kIndicesPerOverstrokeRRect = SK_ARRAY_COUNT(gOverstrokeRRectIndices) - 6;
// fill count skips overstroke indices and includes center
static const int kIndicesPerFillRRect = kIndicesPerOverstrokeRRect - 6*4 + 6;
// stroke count is fill count minus center indices
static const int kIndicesPerStrokeRRect = kIndicesPerFillRRect - 6;
static const int kVertsPerStandardRRect = 16;
static const int kVertsPerOverstrokeRRect = 24;

enum RRectType {
    kFill_RRectType,
    kStroke_RRectType,
    kOverstroke_RRectType,
};

static int rrect_type_to_vert_count(RRectType type) {
    static const int kTypeToVertCount[] = {
        kVertsPerStandardRRect,
        kVertsPerStandardRRect,
        kVertsPerOverstrokeRRect,
    };

    return kTypeToVertCount[type];
}

static int rrect_type_to_index_count(RRectType type) {
    static const int kTypeToIndexCount[] = {
        kIndicesPerFillRRect,
        kIndicesPerStrokeRRect,
        kIndicesPerOverstrokeRRect,
    };

    return kTypeToIndexCount[type];
}

static const uint16_t* rrect_type_to_indices(RRectType type) {
    static const uint16_t* kTypeToIndices[] = {
        gStandardRRectIndices,
        gStandardRRectIndices,
        gOverstrokeRRectIndices,
    };

    return kTypeToIndices[type];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class RRectCircleRendererBatch : public GrVertexBatch {
public:
    DEFINE_BATCH_CLASS_ID

    // A devStrokeWidth <= 0 indicates a fill only. If devStrokeWidth > 0 then strokeOnly indicates
    // whether the rrect is only stroked or stroked and filled.
    RRectCircleRendererBatch(GrColor color, const SkMatrix& viewMatrix, const SkRect& devRect,
                             float devRadius, float devStrokeWidth, bool strokeOnly)
            : INHERITED(ClassID())
            , fViewMatrixIfUsingLocalCoords(viewMatrix) {
        SkRect bounds = devRect;
        SkASSERT(!(devStrokeWidth <= 0 && strokeOnly));
        SkScalar innerRadius = 0.0f;
        SkScalar outerRadius = devRadius;
        SkScalar halfWidth = 0;
        RRectType type = kFill_RRectType;
        if (devStrokeWidth > 0) {
            if (SkScalarNearlyZero(devStrokeWidth)) {
                halfWidth = SK_ScalarHalf;
            } else {
                halfWidth = SkScalarHalf(devStrokeWidth);
            }

            if (strokeOnly) {
                // Outset stroke by 1/4 pixel
                devStrokeWidth += 0.25f;
                // If stroke is greater than width or height, this is still a fill
                // Otherwise we compute stroke params
                if (devStrokeWidth <= devRect.width() &&
                    devStrokeWidth <= devRect.height()) {
                    innerRadius = devRadius - halfWidth;
                    type = (innerRadius >= 0) ? kStroke_RRectType : kOverstroke_RRectType;
                }
            }
            outerRadius += halfWidth;
            bounds.outset(halfWidth, halfWidth);
        }

        // The radii are outset for two reasons. First, it allows the shader to simply perform
        // simpler computation because the computed alpha is zero, rather than 50%, at the radius.
        // Second, the outer radius is used to compute the verts of the bounding box that is
        // rendered and the outset ensures the box will cover all partially covered by the rrect
        // corners.
        outerRadius += SK_ScalarHalf;
        innerRadius -= SK_ScalarHalf;

        this->setBounds(bounds, HasAABloat::kYes, IsZeroArea::kNo);

        // Expand the rect for aa to generate correct vertices.
        bounds.outset(SK_ScalarHalf, SK_ScalarHalf);

        fGeoData.emplace_back(Geometry{ color, innerRadius, outerRadius, bounds, type });
        fVertCount = rrect_type_to_vert_count(type);
        fIndexCount = rrect_type_to_index_count(type);
        fAllFill = (kFill_RRectType == type);
    }

    const char* name() const override { return "RRectCircleBatch"; }

    SkString dumpInfo() const override {
        SkString string;
        for (int i = 0; i < fGeoData.count(); ++i) {
            string.appendf("Color: 0x%08x Rect [L: %.2f, T: %.2f, R: %.2f, B: %.2f],"
                           "InnerRad: %.2f, OuterRad: %.2f\n",
                           fGeoData[i].fColor,
                           fGeoData[i].fDevBounds.fLeft, fGeoData[i].fDevBounds.fTop,
                           fGeoData[i].fDevBounds.fRight, fGeoData[i].fDevBounds.fBottom,
                           fGeoData[i].fInnerRadius,
                           fGeoData[i].fOuterRadius);
        }
        string.append(INHERITED::dumpInfo());
        return string;
    }

    void computePipelineOptimizations(GrInitInvariantOutput* color,
                                      GrInitInvariantOutput* coverage,
                                      GrBatchToXPOverrides* overrides) const override {
        // When this is called on a batch, there is only one geometry bundle
        color->setKnownFourComponents(fGeoData[0].fColor);
        coverage->setUnknownSingleComponent();
    }

private:
    void initBatchTracker(const GrXPOverridesForBatch& overrides) override {
        // Handle any overrides that affect our GP.
        overrides.getOverrideColorIfSet(&fGeoData[0].fColor);
        if (!overrides.readsLocalCoords()) {
            fViewMatrixIfUsingLocalCoords.reset();
        }
    }

    void onPrepareDraws(Target* target) const override {
        // Invert the view matrix as a local matrix (if any other processors require coords).
        SkMatrix localMatrix;
        if (!fViewMatrixIfUsingLocalCoords.invert(&localMatrix)) {
            return;
        }

        // Setup geometry processor
        SkAutoTUnref<GrGeometryProcessor> gp(new CircleGeometryProcessor(!fAllFill,
                                                                         false, false,
                                                                         false, localMatrix));
        struct CircleVertex {
            SkPoint  fPos;
            GrColor  fColor;
            SkPoint  fOffset;
            SkScalar fOuterRadius;
            SkScalar fInnerRadius;
            // No half plane, we don't use it here.
        };

        int instanceCount = fGeoData.count();
        size_t vertexStride = gp->getVertexStride();
        SkASSERT(sizeof(CircleVertex) == vertexStride);

        const GrBuffer* vertexBuffer;
        int firstVertex;

        CircleVertex* verts = (CircleVertex*) target->makeVertexSpace(vertexStride, fVertCount,
                                                                      &vertexBuffer, &firstVertex);
        if (!verts) {
            SkDebugf("Could not allocate vertices\n");
            return;
        }

        const GrBuffer* indexBuffer = nullptr;
        int firstIndex = 0;
        uint16_t* indices = target->makeIndexSpace(fIndexCount, &indexBuffer, &firstIndex);
        if (!indices) {
            SkDebugf("Could not allocate indices\n");
            return;
        }

        int currStartVertex = 0;
        for (int i = 0; i < instanceCount; i++) {
            const Geometry& args = fGeoData[i];

            GrColor color = args.fColor;
            SkScalar outerRadius = args.fOuterRadius;

            const SkRect& bounds = args.fDevBounds;

            SkScalar yCoords[4] = {
                bounds.fTop,
                bounds.fTop + outerRadius,
                bounds.fBottom - outerRadius,
                bounds.fBottom
            };

            SkScalar yOuterRadii[4] = {-1, 0, 0, 1 };
            // The inner radius in the vertex data must be specified in normalized space.
            // For fills, specifying -1/outerRadius guarantees an alpha of 1.0 at the inner radius.
            SkScalar innerRadius = args.fType != kFill_RRectType
                                   ? args.fInnerRadius / args.fOuterRadius
                                   : -1.0f / args.fOuterRadius;
            for (int i = 0; i < 4; ++i) {
                verts->fPos = SkPoint::Make(bounds.fLeft, yCoords[i]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(-1, yOuterRadii[i]);
                verts->fOuterRadius = outerRadius;
                verts->fInnerRadius = innerRadius;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fLeft + outerRadius, yCoords[i]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(0, yOuterRadii[i]);
                verts->fOuterRadius = outerRadius;
                verts->fInnerRadius = innerRadius;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fRight - outerRadius, yCoords[i]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(0, yOuterRadii[i]);
                verts->fOuterRadius = outerRadius;
                verts->fInnerRadius = innerRadius;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fRight, yCoords[i]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(1, yOuterRadii[i]);
                verts->fOuterRadius = outerRadius;
                verts->fInnerRadius = innerRadius;
                verts++;
            }
            // Add the additional vertices for overstroked rrects.
            // Effectively this is an additional stroked rrect, with its
            // outer radius = outerRadius - innerRadius, and inner radius = 0.
            // This will give us correct AA in the center and the correct
            // distance to the outer edge.
            //
            // Also, the outer offset is a constant vector pointing to the right, which
            // guarantees that the distance value along the outer rectangle is constant.
            if (kOverstroke_RRectType == args.fType) {
                SkScalar overstrokeOuterRadius = outerRadius - args.fInnerRadius;
                // this is the normalized distance from the outer rectangle of this
                // geometry to the outer edge
                SkScalar maxOffset = -args.fInnerRadius / overstrokeOuterRadius;

                verts->fPos = SkPoint::Make(bounds.fLeft + outerRadius, yCoords[1]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(maxOffset, 0);
                verts->fOuterRadius = overstrokeOuterRadius;
                verts->fInnerRadius = 0;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fRight - outerRadius, yCoords[1]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(maxOffset, 0);
                verts->fOuterRadius = overstrokeOuterRadius;
                verts->fInnerRadius = 0;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fLeft + overstrokeOuterRadius,
                                            bounds.fTop + overstrokeOuterRadius);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(0, 0);
                verts->fOuterRadius = overstrokeOuterRadius;
                verts->fInnerRadius = 0;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fRight - overstrokeOuterRadius,
                                            bounds.fTop + overstrokeOuterRadius);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(0, 0);
                verts->fOuterRadius = overstrokeOuterRadius;
                verts->fInnerRadius = 0;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fLeft + overstrokeOuterRadius,
                                            bounds.fBottom - overstrokeOuterRadius);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(0, 0);
                verts->fOuterRadius = overstrokeOuterRadius;
                verts->fInnerRadius = 0;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fRight - overstrokeOuterRadius,
                                            bounds.fBottom - overstrokeOuterRadius);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(0, 0);
                verts->fOuterRadius = overstrokeOuterRadius;
                verts->fInnerRadius = 0;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fLeft + outerRadius, yCoords[2]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(maxOffset, 0);
                verts->fOuterRadius = overstrokeOuterRadius;
                verts->fInnerRadius = 0;
                verts++;

                verts->fPos = SkPoint::Make(bounds.fRight - outerRadius, yCoords[2]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(maxOffset, 0);
                verts->fOuterRadius = overstrokeOuterRadius;
                verts->fInnerRadius = 0;
                verts++;
            }

            const uint16_t* primIndices = rrect_type_to_indices(args.fType);
            const int primIndexCount = rrect_type_to_index_count(args.fType);
            for (int i = 0; i < primIndexCount; ++i) {
                *indices++ = primIndices[i] + currStartVertex;
            }

            currStartVertex += rrect_type_to_vert_count(args.fType);
        }

        GrMesh mesh;
        mesh.initIndexed(kTriangles_GrPrimitiveType, vertexBuffer, indexBuffer, firstVertex,
                         firstIndex, fVertCount, fIndexCount);
        target->draw(gp.get(), mesh);
    }

    bool onCombineIfPossible(GrBatch* t, const GrCaps& caps) override {
        RRectCircleRendererBatch* that = t->cast<RRectCircleRendererBatch>();
        if (!GrPipeline::CanCombine(*this->pipeline(), this->bounds(), *that->pipeline(),
                                    that->bounds(), caps)) {
            return false;
        }

        if (!fViewMatrixIfUsingLocalCoords.cheapEqualTo(that->fViewMatrixIfUsingLocalCoords)) {
            return false;
        }

        fGeoData.push_back_n(that->fGeoData.count(), that->fGeoData.begin());
        this->joinBounds(*that);
        fVertCount += that->fVertCount;
        fIndexCount += that->fIndexCount;
        fAllFill = fAllFill && that->fAllFill;
        return true;
    }

    struct Geometry {
        GrColor  fColor;
        SkScalar fInnerRadius;
        SkScalar fOuterRadius;
        SkRect fDevBounds;
        RRectType fType;
    };

    SkSTArray<1, Geometry, true> fGeoData;
    SkMatrix                     fViewMatrixIfUsingLocalCoords;
    int                          fVertCount;
    int                          fIndexCount;
    bool                         fAllFill;

    typedef GrVertexBatch INHERITED;
};

static const int kNumRRectsInIndexBuffer = 256;

GR_DECLARE_STATIC_UNIQUE_KEY(gStrokeRRectOnlyIndexBufferKey);
GR_DECLARE_STATIC_UNIQUE_KEY(gRRectOnlyIndexBufferKey);
static const GrBuffer* ref_rrect_index_buffer(RRectType type,
                                              GrResourceProvider* resourceProvider) {
    GR_DEFINE_STATIC_UNIQUE_KEY(gStrokeRRectOnlyIndexBufferKey);
    GR_DEFINE_STATIC_UNIQUE_KEY(gRRectOnlyIndexBufferKey);
    switch (type) {
        case kFill_RRectType:
            return resourceProvider->findOrCreateInstancedIndexBuffer(
                gStandardRRectIndices, kIndicesPerFillRRect, kNumRRectsInIndexBuffer,
                kVertsPerStandardRRect, gRRectOnlyIndexBufferKey);
        case kStroke_RRectType:
            return resourceProvider->findOrCreateInstancedIndexBuffer(
                gStandardRRectIndices, kIndicesPerStrokeRRect, kNumRRectsInIndexBuffer,
                kVertsPerStandardRRect, gStrokeRRectOnlyIndexBufferKey);
        default:
            SkASSERT(false);
            return nullptr;
    };
}

class RRectEllipseRendererBatch : public GrVertexBatch {
public:
    DEFINE_BATCH_CLASS_ID

    // If devStrokeWidths values are <= 0 indicates then fill only. Otherwise, strokeOnly indicates
    // whether the rrect is only stroked or stroked and filled.
    static GrDrawBatch* Create(GrColor color, const SkMatrix& viewMatrix, const SkRect& devRect,
                               float devXRadius, float devYRadius, SkVector devStrokeWidths,
                               bool strokeOnly) {
        SkASSERT(devXRadius > 0.5);
        SkASSERT(devYRadius > 0.5);
        SkASSERT((devStrokeWidths.fX > 0) == (devStrokeWidths.fY > 0));
        SkASSERT(!(strokeOnly && devStrokeWidths.fX <= 0));
        SkScalar innerXRadius = 0.0f;
        SkScalar innerYRadius = 0.0f;
        SkRect bounds = devRect;
        bool stroked = false;
        if (devStrokeWidths.fX > 0) {
            if (SkScalarNearlyZero(devStrokeWidths.length())) {
                devStrokeWidths.set(SK_ScalarHalf, SK_ScalarHalf);
            } else {
                devStrokeWidths.scale(SK_ScalarHalf);
            }

            // we only handle thick strokes for near-circular ellipses
            if (devStrokeWidths.length() > SK_ScalarHalf &&
                (SK_ScalarHalf*devXRadius > devYRadius || SK_ScalarHalf*devYRadius > devXRadius)) {
                return nullptr;
            }

            // we don't handle it if curvature of the stroke is less than curvature of the ellipse
            if (devStrokeWidths.fX*(devYRadius*devYRadius) <
                (devStrokeWidths.fY*devStrokeWidths.fY)*devXRadius) {
                return nullptr;
            }
            if (devStrokeWidths.fY*(devXRadius*devXRadius) <
                (devStrokeWidths.fX*devStrokeWidths.fX)*devYRadius) {
                return nullptr;
            }

            // this is legit only if scale & translation (which should be the case at the moment)
            if (strokeOnly) {
                innerXRadius = devXRadius - devStrokeWidths.fX;
                innerYRadius = devYRadius - devStrokeWidths.fY;
                stroked = (innerXRadius >= 0 && innerYRadius >= 0);
            }

            devXRadius += devStrokeWidths.fX;
            devYRadius += devStrokeWidths.fY;
            bounds.outset(devStrokeWidths.fX, devStrokeWidths.fY);
        }

        RRectEllipseRendererBatch* batch = new RRectEllipseRendererBatch();
        batch->fStroked = stroked;
        batch->fViewMatrixIfUsingLocalCoords = viewMatrix;
        batch->setBounds(bounds, HasAABloat::kYes, IsZeroArea::kNo);
        // Expand the rect for aa in order to generate the correct vertices.
        bounds.outset(SK_ScalarHalf, SK_ScalarHalf);
        batch->fGeoData.emplace_back(
            Geometry {color, devXRadius, devYRadius, innerXRadius, innerYRadius, bounds});
        return batch;
    }

    const char* name() const override { return "RRectEllipseRendererBatch"; }

    void computePipelineOptimizations(GrInitInvariantOutput* color,
                                      GrInitInvariantOutput* coverage,
                                      GrBatchToXPOverrides* overrides) const override {
        // When this is called on a batch, there is only one geometry bundle
        color->setKnownFourComponents(fGeoData[0].fColor);
        coverage->setUnknownSingleComponent();
    }

private:
    RRectEllipseRendererBatch() : INHERITED(ClassID()) {}

    void initBatchTracker(const GrXPOverridesForBatch& overrides) override {
        // Handle overrides that affect our GP.
        overrides.getOverrideColorIfSet(&fGeoData[0].fColor);
        if (!overrides.readsLocalCoords()) {
            fViewMatrixIfUsingLocalCoords.reset();
        }
    }

    void onPrepareDraws(Target* target) const override {
        SkMatrix localMatrix;
        if (!fViewMatrixIfUsingLocalCoords.invert(&localMatrix)) {
            return;
        }

        // Setup geometry processor
        SkAutoTUnref<GrGeometryProcessor> gp(new EllipseGeometryProcessor(fStroked, localMatrix));

        int instanceCount = fGeoData.count();
        size_t vertexStride = gp->getVertexStride();
        SkASSERT(vertexStride == sizeof(EllipseVertex));

        // drop out the middle quad if we're stroked
        int indicesPerInstance = fStroked ? kIndicesPerStrokeRRect : kIndicesPerFillRRect;
        SkAutoTUnref<const GrBuffer> indexBuffer(
            ref_rrect_index_buffer(fStroked ? kStroke_RRectType : kFill_RRectType,
                                   target->resourceProvider()));

        InstancedHelper helper;
        EllipseVertex* verts = reinterpret_cast<EllipseVertex*>(
            helper.init(target, kTriangles_GrPrimitiveType, vertexStride, indexBuffer,
                        kVertsPerStandardRRect, indicesPerInstance, instanceCount));
        if (!verts || !indexBuffer) {
            SkDebugf("Could not allocate vertices\n");
            return;
        }

        for (int i = 0; i < instanceCount; i++) {
            const Geometry& args = fGeoData[i];

            GrColor color = args.fColor;

            // Compute the reciprocals of the radii here to save time in the shader
            SkScalar xRadRecip = SkScalarInvert(args.fXRadius);
            SkScalar yRadRecip = SkScalarInvert(args.fYRadius);
            SkScalar xInnerRadRecip = SkScalarInvert(args.fInnerXRadius);
            SkScalar yInnerRadRecip = SkScalarInvert(args.fInnerYRadius);

            // Extend the radii out half a pixel to antialias.
            SkScalar xOuterRadius = args.fXRadius + SK_ScalarHalf;
            SkScalar yOuterRadius = args.fYRadius + SK_ScalarHalf;

            const SkRect& bounds = args.fDevBounds;

            SkScalar yCoords[4] = {
                bounds.fTop,
                bounds.fTop + yOuterRadius,
                bounds.fBottom - yOuterRadius,
                bounds.fBottom
            };
            SkScalar yOuterOffsets[4] = {
                yOuterRadius,
                SK_ScalarNearlyZero, // we're using inversesqrt() in shader, so can't be exactly 0
                SK_ScalarNearlyZero,
                yOuterRadius
            };

            for (int i = 0; i < 4; ++i) {
                verts->fPos = SkPoint::Make(bounds.fLeft, yCoords[i]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(xOuterRadius, yOuterOffsets[i]);
                verts->fOuterRadii = SkPoint::Make(xRadRecip, yRadRecip);
                verts->fInnerRadii = SkPoint::Make(xInnerRadRecip, yInnerRadRecip);
                verts++;

                verts->fPos = SkPoint::Make(bounds.fLeft + xOuterRadius, yCoords[i]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(SK_ScalarNearlyZero, yOuterOffsets[i]);
                verts->fOuterRadii = SkPoint::Make(xRadRecip, yRadRecip);
                verts->fInnerRadii = SkPoint::Make(xInnerRadRecip, yInnerRadRecip);
                verts++;

                verts->fPos = SkPoint::Make(bounds.fRight - xOuterRadius, yCoords[i]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(SK_ScalarNearlyZero, yOuterOffsets[i]);
                verts->fOuterRadii = SkPoint::Make(xRadRecip, yRadRecip);
                verts->fInnerRadii = SkPoint::Make(xInnerRadRecip, yInnerRadRecip);
                verts++;

                verts->fPos = SkPoint::Make(bounds.fRight, yCoords[i]);
                verts->fColor = color;
                verts->fOffset = SkPoint::Make(xOuterRadius, yOuterOffsets[i]);
                verts->fOuterRadii = SkPoint::Make(xRadRecip, yRadRecip);
                verts->fInnerRadii = SkPoint::Make(xInnerRadRecip, yInnerRadRecip);
                verts++;
            }
        }
        helper.recordDraw(target, gp);
    }

    bool onCombineIfPossible(GrBatch* t, const GrCaps& caps) override {
        RRectEllipseRendererBatch* that = t->cast<RRectEllipseRendererBatch>();

        if (!GrPipeline::CanCombine(*this->pipeline(), this->bounds(), *that->pipeline(),
                                    that->bounds(), caps)) {
            return false;
        }

        if (fStroked != that->fStroked) {
            return false;
        }

        if (!fViewMatrixIfUsingLocalCoords.cheapEqualTo(that->fViewMatrixIfUsingLocalCoords)) {
            return false;
        }

        fGeoData.push_back_n(that->fGeoData.count(), that->fGeoData.begin());
        this->joinBounds(*that);
        return true;
    }

    struct Geometry {
        GrColor fColor;
        SkScalar fXRadius;
        SkScalar fYRadius;
        SkScalar fInnerXRadius;
        SkScalar fInnerYRadius;
        SkRect fDevBounds;
    };

    bool                            fStroked;
    SkMatrix                        fViewMatrixIfUsingLocalCoords;
    SkSTArray<1, Geometry, true>    fGeoData;

    typedef GrVertexBatch INHERITED;
};

static GrDrawBatch* create_rrect_batch(GrColor color,
                                       const SkMatrix& viewMatrix,
                                       const SkRRect& rrect,
                                       const SkStrokeRec& stroke) {
    SkASSERT(viewMatrix.rectStaysRect());
    SkASSERT(rrect.isSimple());
    SkASSERT(!rrect.isOval());

    // RRect batchs only handle simple, but not too simple, rrects
    // do any matrix crunching before we reset the draw state for device coords
    const SkRect& rrectBounds = rrect.getBounds();
    SkRect bounds;
    viewMatrix.mapRect(&bounds, rrectBounds);

    SkVector radii = rrect.getSimpleRadii();
    SkScalar xRadius = SkScalarAbs(viewMatrix[SkMatrix::kMScaleX]*radii.fX +
                                   viewMatrix[SkMatrix::kMSkewY]*radii.fY);
    SkScalar yRadius = SkScalarAbs(viewMatrix[SkMatrix::kMSkewX]*radii.fX +
                                   viewMatrix[SkMatrix::kMScaleY]*radii.fY);

    SkStrokeRec::Style style = stroke.getStyle();

    // Do (potentially) anisotropic mapping of stroke. Use -1s to indicate fill-only draws.
    SkVector scaledStroke = {-1, -1};
    SkScalar strokeWidth = stroke.getWidth();

    bool isStrokeOnly = SkStrokeRec::kStroke_Style == style ||
                        SkStrokeRec::kHairline_Style == style;
    bool hasStroke = isStrokeOnly || SkStrokeRec::kStrokeAndFill_Style == style;

    bool isCircular = (xRadius == yRadius);
    if (hasStroke) {
        if (SkStrokeRec::kHairline_Style == style) {
            scaledStroke.set(1, 1);
        } else {
            scaledStroke.fX = SkScalarAbs(strokeWidth*(viewMatrix[SkMatrix::kMScaleX] +
                                                       viewMatrix[SkMatrix::kMSkewY]));
            scaledStroke.fY = SkScalarAbs(strokeWidth*(viewMatrix[SkMatrix::kMSkewX] +
                                                       viewMatrix[SkMatrix::kMScaleY]));
        }

        isCircular = isCircular && scaledStroke.fX == scaledStroke.fY;
        // for non-circular rrects, if half of strokewidth is greater than radius,
        // we don't handle that right now
        if (!isCircular &&
            (SK_ScalarHalf*scaledStroke.fX > xRadius || SK_ScalarHalf*scaledStroke.fY > yRadius)) {
            return nullptr;
        }
    }

    // The way the effect interpolates the offset-to-ellipse/circle-center attribute only works on
    // the interior of the rrect if the radii are >= 0.5. Otherwise, the inner rect of the nine-
    // patch will have fractional coverage. This only matters when the interior is actually filled.
    // We could consider falling back to rect rendering here, since a tiny radius is
    // indistinguishable from a square corner.
    if (!isStrokeOnly && (SK_ScalarHalf > xRadius || SK_ScalarHalf > yRadius)) {
        return nullptr;
    }

    // if the corners are circles, use the circle renderer
    if (isCircular) {
        return new RRectCircleRendererBatch(color, viewMatrix, bounds, xRadius, scaledStroke.fX,
                                            isStrokeOnly);
    // otherwise we use the ellipse renderer
    } else {
        return RRectEllipseRendererBatch::Create(color, viewMatrix, bounds, xRadius, yRadius,
                                                 scaledStroke, isStrokeOnly);

    }
}

GrDrawBatch* GrOvalRenderer::CreateRRectBatch(GrColor color,
                                              const SkMatrix& viewMatrix,
                                              const SkRRect& rrect,
                                              const SkStrokeRec& stroke,
                                              const GrShaderCaps* shaderCaps) {
    if (rrect.isOval()) {
        return CreateOvalBatch(color, viewMatrix, rrect.getBounds(), stroke, shaderCaps);
    }

    if (!viewMatrix.rectStaysRect() || !rrect.isSimple()) {
        return nullptr;
    }

    return create_rrect_batch(color, viewMatrix, rrect, stroke);
}

///////////////////////////////////////////////////////////////////////////////

GrDrawBatch* GrOvalRenderer::CreateOvalBatch(GrColor color,
                                             const SkMatrix& viewMatrix,
                                             const SkRect& oval,
                                             const SkStrokeRec& stroke,
                                             const GrShaderCaps* shaderCaps) {
    // we can draw circles
    SkScalar width = oval.width();
    if (SkScalarNearlyEqual(width, oval.height()) && circle_stays_circle(viewMatrix)) {
        SkPoint center = {oval.centerX(), oval.centerY()};
        return CircleBatch::Create(color, viewMatrix, center, width / 2.f,
                                   GrStyle(stroke, nullptr));
    }

    // if we have shader derivative support, render as device-independent
    if (shaderCaps->shaderDerivativeSupport()) {
        return DIEllipseBatch::Create(color, viewMatrix, oval, stroke);
    }

    // otherwise axis-aligned ellipses only
    if (viewMatrix.rectStaysRect()) {
        return EllipseBatch::Create(color, viewMatrix, oval, stroke);
    }

    return nullptr;
}

///////////////////////////////////////////////////////////////////////////////

GrDrawBatch* GrOvalRenderer::CreateArcBatch(GrColor color,
                                            const SkMatrix& viewMatrix,
                                            const SkRect& oval,
                                            SkScalar startAngle, SkScalar sweepAngle,
                                            bool useCenter,
                                            const GrStyle& style,
                                            const GrShaderCaps* shaderCaps) {
    SkASSERT(!oval.isEmpty());
    SkASSERT(sweepAngle);
    SkScalar width = oval.width();
    if (SkScalarAbs(sweepAngle) >= 360.f) {
        return nullptr;
    }
    if (!SkScalarNearlyEqual(width, oval.height()) || !circle_stays_circle(viewMatrix)) {
        return nullptr;
    }
    SkPoint center = {oval.centerX(), oval.centerY()};
    CircleBatch::ArcParams arcParams = {
        SkDegreesToRadians(startAngle),
        SkDegreesToRadians(sweepAngle),
        useCenter
    };
    return CircleBatch::Create(color, viewMatrix, center, width/2.f, style, &arcParams);
}

///////////////////////////////////////////////////////////////////////////////

#ifdef GR_TEST_UTILS

DRAW_BATCH_TEST_DEFINE(CircleBatch) {
    do {
        SkScalar rotate = random->nextSScalar1() * 360.f;
        SkScalar translateX = random->nextSScalar1() * 1000.f;
        SkScalar translateY = random->nextSScalar1() * 1000.f;
        SkScalar scale = random->nextSScalar1() * 100.f;
        SkMatrix viewMatrix;
        viewMatrix.setRotate(rotate);
        viewMatrix.postTranslate(translateX, translateY);
        viewMatrix.postScale(scale, scale);
        GrColor color = GrRandomColor(random);
        SkRect circle = GrTest::TestSquare(random);
        SkPoint center = {circle.centerX(), circle.centerY()};
        SkScalar radius = circle.width() / 2.f;
        SkStrokeRec stroke = GrTest::TestStrokeRec(random);
        CircleBatch::ArcParams arcParamsTmp;
        const CircleBatch::ArcParams* arcParams = nullptr;
        if (random->nextBool()) {
            arcParamsTmp.fStartAngleRadians = random->nextSScalar1() * SK_ScalarPI * 2;
            arcParamsTmp.fSweepAngleRadians = random->nextSScalar1() * SK_ScalarPI * 2 - .01f;
            arcParamsTmp.fUseCenter = random->nextBool();
            arcParams = &arcParamsTmp;
        }
        GrDrawBatch* batch = CircleBatch::Create(color, viewMatrix, center, radius,
                                                 GrStyle(stroke, nullptr), arcParams);
        if (batch) {
            return batch;
        }
    } while (true);
}

DRAW_BATCH_TEST_DEFINE(EllipseBatch) {
    SkMatrix viewMatrix = GrTest::TestMatrixRectStaysRect(random);
    GrColor color = GrRandomColor(random);
    SkRect ellipse = GrTest::TestSquare(random);
    return EllipseBatch::Create(color, viewMatrix, ellipse, GrTest::TestStrokeRec(random));
}

DRAW_BATCH_TEST_DEFINE(DIEllipseBatch) {
    SkMatrix viewMatrix = GrTest::TestMatrix(random);
    GrColor color = GrRandomColor(random);
    SkRect ellipse = GrTest::TestSquare(random);
    return DIEllipseBatch::Create(color, viewMatrix, ellipse, GrTest::TestStrokeRec(random));
}

DRAW_BATCH_TEST_DEFINE(RRectBatch) {
    SkMatrix viewMatrix = GrTest::TestMatrixRectStaysRect(random);
    GrColor color = GrRandomColor(random);
    const SkRRect& rrect = GrTest::TestRRectSimple(random);
    return create_rrect_batch(color, viewMatrix, rrect, GrTest::TestStrokeRec(random));
}

#endif
