/*
 * Copyright 2011 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrGLSL_DEFINED
#define GrGLSL_DEFINED

#include "GrTypesPriv.h"
#include "SkString.h"

class GrGLSLCaps;

// Limited set of GLSL versions we build shaders for. Caller should round
// down the GLSL version to one of these enums.
enum GrGLSLGeneration {
    /**
     * Desktop GLSL 1.10 and ES2 shading language (based on desktop GLSL 1.20)
     */
    k110_GrGLSLGeneration,
    /**
     * Desktop GLSL 1.30
     */
    k130_GrGLSLGeneration,
    /**
     * Desktop GLSL 1.40
     */
    k140_GrGLSLGeneration,
    /**
     * Desktop GLSL 1.50
     */
    k150_GrGLSLGeneration,
    /**
     * Desktop GLSL 3.30, and ES GLSL 3.00
     */
    k330_GrGLSLGeneration,
    /**
     * Desktop GLSL 4.00
     */
    k400_GrGLSLGeneration,
    /**
     * ES GLSL 3.10 only TODO Make GLSLCap objects to make this more granular
     */
    k310es_GrGLSLGeneration,
    /**
     * ES GLSL 3.20
     */
    k320es_GrGLSLGeneration,
};

bool GrGLSLSupportsNamedFragmentShaderOutputs(GrGLSLGeneration);

/**
 * Gets the name of the function that should be used to sample a 2D texture. Coord type is used
 * to indicate whether the texture is sampled using projective textured (kVec3f) or not (kVec2f).
 */
inline const char* GrGLSLTexture2DFunctionName(GrSLType coordType, GrSLType samplerType,
                                               GrGLSLGeneration glslGen) {
    SkASSERT(GrSLTypeIs2DCombinedSamplerType(samplerType));
    SkASSERT(kVec2f_GrSLType == coordType || kVec3f_GrSLType == coordType);
    // GL_TEXTURE_RECTANGLE_ARB is written against OpenGL 2.0/GLSL 1.10. At that time there were
    // separate texture*() functions. In OpenGL 3.0/GLSL 1.30 the different texture*() functions
    // were deprecated in favor or the unified texture() function. RECTANGLE textures became
    // standard in OpenGL 3.2/GLSL 1.50 and use texture(). It isn't completely clear what function
    // should be used for RECTANGLE textures in GLSL versions >= 1.30 && < 1.50. We're going with
    // using texture().
    if (glslGen >= k130_GrGLSLGeneration) {
        return (kVec2f_GrSLType == coordType) ? "texture" : "textureProj";
    }
    if (kVec2f_GrSLType == coordType) {
        return (samplerType == kTexture2DRectSampler_GrSLType) ? "texture2DRect" : "texture2D";
    } else {
        return (samplerType == kTexture2DRectSampler_GrSLType) ? "texture2DRectProj"
                                                               : "texture2DProj";
    }
}

/**
 * Adds a line of GLSL code to declare the default precision for float types.
 */
void GrGLSLAppendDefaultFloatPrecisionDeclaration(GrSLPrecision,
                                                  const GrGLSLCaps& glslCaps,
                                                  SkString* out);

/**
 * Converts a GrSLPrecision to its corresponding GLSL precision qualifier.
 */
static inline const char* GrGLSLPrecisionString(GrSLPrecision p) {
    switch (p) {
        case kLow_GrSLPrecision:
            return "lowp";
        case kMedium_GrSLPrecision:
            return "mediump";
        case kHigh_GrSLPrecision:
            return "highp";
        default:
            SkFAIL("Unexpected precision type.");
            return "";
    }
}

/**
 * Converts a GrSLType to a string containing the name of the equivalent GLSL type.
 */
static inline const char* GrGLSLTypeString(GrSLType t) {
    switch (t) {
        case kVoid_GrSLType:
            return "void";
        case kFloat_GrSLType:
            return "float";
        case kVec2f_GrSLType:
            return "vec2";
        case kVec3f_GrSLType:
            return "vec3";
        case kVec4f_GrSLType:
            return "vec4";
        case kMat22f_GrSLType:
            return "mat2";
        case kMat33f_GrSLType:
            return "mat3";
        case kMat44f_GrSLType:
            return "mat4";
        case kTexture2DSampler_GrSLType:
            return "sampler2D";
        case kTextureExternalSampler_GrSLType:
            return "samplerExternalOES";
        case kTexture2DRectSampler_GrSLType:
            return "sampler2DRect";
        case kTextureBufferSampler_GrSLType:
            return "samplerBuffer";
        case kBool_GrSLType:
            return "bool";
        case kInt_GrSLType:
            return "int";
        case kUint_GrSLType:
            return "uint";
        case kTexture2D_GrSLType:
            return "texture2D";
        case kSampler_GrSLType:
            return "sampler";
        default:
            SkFAIL("Unknown shader var type.");
            return ""; // suppress warning
    }
}

/** A generic base-class representing a GLSL expression.
 * The instance can be a variable name, expression or vecN(0) or vecN(1). Does simple constant
 * folding with help of 1 and 0.
 *
 * Clients should not use this class, rather the specific instantiations defined
 * later, for example GrGLSLExpr4.
 */
template <typename Self>
class GrGLSLExpr {
public:
    bool isOnes() const { return kOnes_ExprType == fType; }
    bool isZeros() const { return kZeros_ExprType == fType; }

    const char* c_str() const {
        if (kZeros_ExprType == fType) {
            return Self::ZerosStr();
        } else if (kOnes_ExprType == fType) {
            return Self::OnesStr();
        }
        SkASSERT(!fExpr.isEmpty()); // Empty expressions should not be used.
        return fExpr.c_str();
    }

    bool isValid() const {
        return kFullExpr_ExprType != fType || !fExpr.isEmpty();
    }

protected:
    /** Constructs an invalid expression.
     * Useful only as a return value from functions that never actually return
     * this and instances that will be assigned to later. */
    GrGLSLExpr()
        : fType(kFullExpr_ExprType) {
        // The only constructor that is allowed to build an empty expression.
        SkASSERT(!this->isValid());
    }

    /** Constructs an expression with all components as value v */
    explicit GrGLSLExpr(int v) {
        if (v == 0) {
            fType = kZeros_ExprType;
        } else if (v == 1) {
            fType = kOnes_ExprType;
        } else {
            fType = kFullExpr_ExprType;
            fExpr.appendf(Self::CastIntStr(), v);
        }
    }

    /** Constructs an expression from a string.
     * Argument expr is a simple expression or a parenthesized expression. */
    // TODO: make explicit once effects input Exprs.
    GrGLSLExpr(const char expr[]) {
        if (nullptr == expr) {  // TODO: remove this once effects input Exprs.
            fType = kOnes_ExprType;
        } else {
            fType = kFullExpr_ExprType;
            fExpr = expr;
        }
        SkASSERT(this->isValid());
    }

    /** Constructs an expression from a string.
     * Argument expr is a simple expression or a parenthesized expression. */
    // TODO: make explicit once effects input Exprs.
    GrGLSLExpr(const SkString& expr) {
        if (expr.isEmpty()) {  // TODO: remove this once effects input Exprs.
            fType = kOnes_ExprType;
        } else {
            fType = kFullExpr_ExprType;
            fExpr = expr;
        }
        SkASSERT(this->isValid());
    }

    /** Constructs an expression from a string with one substitution. */
    GrGLSLExpr(const char format[], const char in0[])
        : fType(kFullExpr_ExprType) {
        fExpr.appendf(format, in0);
    }

    /** Constructs an expression from a string with two substitutions. */
    GrGLSLExpr(const char format[], const char in0[], const char in1[])
        : fType(kFullExpr_ExprType) {
        fExpr.appendf(format, in0, in1);
    }

    /** Returns expression casted to another type.
     * Generic implementation that is called for non-trivial cases of casts. */
    template <typename T>
    static Self VectorCastImpl(const T& other);

    /** Returns a GLSL multiplication: component-wise or component-by-scalar.
     * The multiplication will be component-wise or multiply each component by a scalar.
     *
     * The returned expression will compute the value of:
     *    vecN(in0.x * in1.x, ...) if dim(T0) == dim(T1) (component-wise)
     *    vecN(in0.x * in1, ...) if dim(T1) == 1 (vector by scalar)
     *    vecN(in0 * in1.x, ...) if dim(T0) == 1 (scalar by vector)
     */
    template <typename T0, typename T1>
    static Self Mul(T0 in0, T1 in1);

    /** Returns a GLSL addition: component-wise or add a scalar to each component.
     * Return value computes:
     *   vecN(in0.x + in1.x, ...) or vecN(in0.x + in1, ...) or vecN(in0 + in1.x, ...).
     */
    template <typename T0, typename T1>
    static Self Add(T0 in0, T1 in1);

    /** Returns a GLSL subtraction: component-wise or subtract compoments by a scalar.
     * Return value computes
     *   vecN(in0.x - in1.x, ...) or vecN(in0.x - in1, ...) or vecN(in0 - in1.x, ...).
     */
    template <typename T0, typename T1>
    static Self Sub(T0 in0, T1 in1);

    /** Returns expression that accesses component(s) of the expression.
     * format should be the form "%s.x" where 'x' is the component(s) to access.
     * Caller is responsible for making sure the amount of components in the
     * format string is equal to dim(T).
     */
    template <typename T>
    T extractComponents(const char format[]) const;

private:
    enum ExprType {
        kZeros_ExprType,
        kOnes_ExprType,
        kFullExpr_ExprType,
    };
    ExprType fType;
    SkString fExpr;
};

class GrGLSLExpr1;
class GrGLSLExpr4;

/** Class representing a float GLSL expression. */
class GrGLSLExpr1 : public GrGLSLExpr<GrGLSLExpr1> {
public:
    GrGLSLExpr1()
        : INHERITED() {
    }
    explicit GrGLSLExpr1(int v)
        : INHERITED(v) {
    }
    GrGLSLExpr1(const char* expr)
        : INHERITED(expr) {
    }
    GrGLSLExpr1(const SkString& expr)
        : INHERITED(expr) {
    }

    static GrGLSLExpr1 VectorCast(const GrGLSLExpr1& expr);

private:
    GrGLSLExpr1(const char format[], const char in0[])
        : INHERITED(format, in0) {
    }
    GrGLSLExpr1(const char format[], const char in0[], const char in1[])
        : INHERITED(format, in0, in1) {
    }

    static const char* ZerosStr();
    static const char* OnesStr();
    static const char* CastStr();
    static const char* CastIntStr();

    friend GrGLSLExpr1 operator*(const GrGLSLExpr1& in0, const GrGLSLExpr1&in1);
    friend GrGLSLExpr1 operator+(const GrGLSLExpr1& in0, const GrGLSLExpr1&in1);
    friend GrGLSLExpr1 operator-(const GrGLSLExpr1& in0, const GrGLSLExpr1&in1);

    friend class GrGLSLExpr<GrGLSLExpr1>;
    friend class GrGLSLExpr<GrGLSLExpr4>;

    typedef GrGLSLExpr<GrGLSLExpr1> INHERITED;
};

/** Class representing a float vector (vec4) GLSL expression. */
class GrGLSLExpr4 : public GrGLSLExpr<GrGLSLExpr4> {
public:
    GrGLSLExpr4()
        : INHERITED() {
    }
    explicit GrGLSLExpr4(int v)
        : INHERITED(v) {
    }
    GrGLSLExpr4(const char* expr)
        : INHERITED(expr) {
    }
    GrGLSLExpr4(const SkString& expr)
        : INHERITED(expr) {
    }

    typedef GrGLSLExpr1 AExpr;
    AExpr a() const;

    /** GLSL vec4 cast / constructor, eg vec4(floatv) -> vec4(floatv, floatv, floatv, floatv) */
    static GrGLSLExpr4 VectorCast(const GrGLSLExpr1& expr);
    static GrGLSLExpr4 VectorCast(const GrGLSLExpr4& expr);

private:
    GrGLSLExpr4(const char format[], const char in0[])
        : INHERITED(format, in0) {
    }
    GrGLSLExpr4(const char format[], const char in0[], const char in1[])
        : INHERITED(format, in0, in1) {
    }

    static const char* ZerosStr();
    static const char* OnesStr();
    static const char* CastStr();
    static const char* CastIntStr();

    // The vector-by-scalar and scalar-by-vector binary operations.
    friend GrGLSLExpr4 operator*(const GrGLSLExpr1& in0, const GrGLSLExpr4&in1);
    friend GrGLSLExpr4 operator+(const GrGLSLExpr1& in0, const GrGLSLExpr4&in1);
    friend GrGLSLExpr4 operator-(const GrGLSLExpr1& in0, const GrGLSLExpr4&in1);
    friend GrGLSLExpr4 operator*(const GrGLSLExpr4& in0, const GrGLSLExpr1&in1);
    friend GrGLSLExpr4 operator+(const GrGLSLExpr4& in0, const GrGLSLExpr1&in1);
    friend GrGLSLExpr4 operator-(const GrGLSLExpr4& in0, const GrGLSLExpr1&in1);

    // The vector-by-vector, i.e. component-wise, binary operations.
    friend GrGLSLExpr4 operator*(const GrGLSLExpr4& in0, const GrGLSLExpr4&in1);
    friend GrGLSLExpr4 operator+(const GrGLSLExpr4& in0, const GrGLSLExpr4&in1);
    friend GrGLSLExpr4 operator-(const GrGLSLExpr4& in0, const GrGLSLExpr4&in1);

    friend class GrGLSLExpr<GrGLSLExpr4>;

    typedef GrGLSLExpr<GrGLSLExpr4> INHERITED;
};

/**
 * Does an inplace mul, *=, of vec4VarName by mulFactor.
 * A semicolon is added after the assignment.
 */
void GrGLSLMulVarBy4f(SkString* outAppend, const char* vec4VarName, const GrGLSLExpr4& mulFactor);

#include "GrGLSL_impl.h"

#endif
