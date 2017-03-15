/*
 * Copyright 2013 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrGLSLPrimitiveProcessor_DEFINED
#define GrGLSLPrimitiveProcessor_DEFINED

#include "GrFragmentProcessor.h"
#include "GrPrimitiveProcessor.h"
#include "glsl/GrGLSLProgramDataManager.h"
#include "glsl/GrGLSLSampler.h"

class GrBatchTracker;
class GrPrimitiveProcessor;
class GrGLSLCaps;
class GrGLSLPPFragmentBuilder;
class GrGLSLGPBuilder;
class GrGLSLUniformHandler;
class GrGLSLVaryingHandler;
class GrGLSLVertexBuilder;

class GrGLSLPrimitiveProcessor {
public:
    using FPCoordTransformIter = GrFragmentProcessor::CoordTransformIter;

    virtual ~GrGLSLPrimitiveProcessor() {}

    typedef GrGLSLProgramDataManager::UniformHandle UniformHandle;
    typedef GrGLSLProgramDataManager::UniformHandle SamplerHandle;

    /**
     * This class provides access to the GrCoordTransforms across all GrFragmentProcessors in a
     * GrPipeline. It is also used by the primitive processor to specify the fragment shader
     * variable that will hold the transformed coords for each GrCoordTransform. It is required that
     * the primitive processor iterate over each coord transform and insert a shader var result for
     * each. The GrGLSLFragmentProcessors will reference these variables in their fragment code.
     */
    class FPCoordTransformHandler : public SkNoncopyable {
    public:
        FPCoordTransformHandler(const GrPipeline& pipeline,
                                SkTArray<GrShaderVar>* transformedCoordVars)
                : fIter(pipeline)
                , fTransformedCoordVars(transformedCoordVars) {}

        ~FPCoordTransformHandler() { SkASSERT(!this->nextCoordTransform());}

        const GrCoordTransform* nextCoordTransform();

        // 'args' are constructor params to GrShaderVar.
        template<typename... Args>
        void specifyCoordsForCurrCoordTransform(Args&&... args) {
            SkASSERT(!fAddedCoord);
            fTransformedCoordVars->emplace_back(std::forward<Args>(args)...);
            SkDEBUGCODE(fAddedCoord = true;)
        }

    private:
        GrFragmentProcessor::CoordTransformIter fIter;
        SkDEBUGCODE(bool                        fAddedCoord = false;)
        SkDEBUGCODE(const GrCoordTransform*     fCurr = nullptr;)
        SkTArray<GrShaderVar>*                  fTransformedCoordVars;
    };

    struct EmitArgs {
        EmitArgs(GrGLSLVertexBuilder* vertBuilder,
                 GrGLSLPPFragmentBuilder* fragBuilder,
                 GrGLSLVaryingHandler* varyingHandler,
                 GrGLSLUniformHandler* uniformHandler,
                 const GrGLSLCaps* caps,
                 const GrPrimitiveProcessor& gp,
                 const char* outputColor,
                 const char* outputCoverage,
                 const char* distanceVectorName,
                 const SamplerHandle* texSamplers,
                 const SamplerHandle* bufferSamplers,
                 FPCoordTransformHandler* transformHandler)
            : fVertBuilder(vertBuilder)
            , fFragBuilder(fragBuilder)
            , fVaryingHandler(varyingHandler)
            , fUniformHandler(uniformHandler)
            , fGLSLCaps(caps)
            , fGP(gp)
            , fOutputColor(outputColor)
            , fOutputCoverage(outputCoverage)
            , fDistanceVectorName(distanceVectorName)
            , fTexSamplers(texSamplers)
            , fBufferSamplers(bufferSamplers)
            , fFPCoordTransformHandler(transformHandler) {}
        GrGLSLVertexBuilder* fVertBuilder;
        GrGLSLPPFragmentBuilder* fFragBuilder;
        GrGLSLVaryingHandler* fVaryingHandler;
        GrGLSLUniformHandler* fUniformHandler;
        const GrGLSLCaps* fGLSLCaps;
        const GrPrimitiveProcessor& fGP;
        const char* fOutputColor;
        const char* fOutputCoverage;
        const char* fDistanceVectorName;
        const SamplerHandle* fTexSamplers;
        const SamplerHandle* fBufferSamplers;
        FPCoordTransformHandler* fFPCoordTransformHandler;
    };

    /**
     * This is similar to emitCode() in the base class, except it takes a full shader builder.
     * This allows the effect subclass to emit vertex code.
     */
    virtual void emitCode(EmitArgs&) = 0;

    /**
     * A GrGLSLPrimitiveProcessor instance can be reused with any GrGLSLPrimitiveProcessor that
     * produces the same stage key; this function reads data from a GrGLSLPrimitiveProcessor and
     * uploads any uniform variables required  by the shaders created in emitCode(). The
     * GrPrimitiveProcessor parameter is guaranteed to be of the same type and to have an
     * identical processor key as the GrPrimitiveProcessor that created this
     * GrGLSLPrimitiveProcessor.
     * The subclass may use the transform iterator to perform any setup required for the particular
     * set of fp transform matrices, such as uploading via uniforms. The iterator will iterate over
     * the transforms in the same order as the TransformHandler passed to emitCode.
     */
    virtual void setData(const GrGLSLProgramDataManager&, const GrPrimitiveProcessor&,
                         FPCoordTransformIter&&) = 0;

    static SkMatrix GetTransformMatrix(const SkMatrix& localMatrix, const GrCoordTransform&);

protected:
    void setupUniformColor(GrGLSLPPFragmentBuilder* fragBuilder,
                           GrGLSLUniformHandler* uniformHandler,
                           const char* outputName,
                           UniformHandle* colorUniform);
};

#endif
