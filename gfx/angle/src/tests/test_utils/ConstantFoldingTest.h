//
// Copyright (c) 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// ConstantFoldingTest.h:
//   Utilities for constant folding tests.
//

#ifndef TESTS_TEST_UTILS_CONSTANTFOLDINGTEST_H_
#define TESTS_TEST_UTILS_CONSTANTFOLDINGTEST_H_

#include <vector>

#include "common/mathutil.h"
#include "compiler/translator/IntermNode.h"
#include "compiler/translator/PoolAlloc.h"
#include "gtest/gtest.h"

namespace sh
{

class TranslatorESSL;

template <typename T>
class ConstantFinder : public TIntermTraverser
{
  public:
    ConstantFinder(const std::vector<T> &constantVector)
        : TIntermTraverser(true, false, false),
          mConstantVector(constantVector),
          mFaultTolerance(T()),
          mFound(false)
    {
    }

    ConstantFinder(const std::vector<T> &constantVector, const T &faultTolerance)
        : TIntermTraverser(true, false, false),
          mConstantVector(constantVector),
          mFaultTolerance(faultTolerance),
          mFound(false)
    {
    }

    ConstantFinder(const T &value)
        : TIntermTraverser(true, false, false), mFaultTolerance(T()), mFound(false)
    {
        mConstantVector.push_back(value);
    }

    void visitConstantUnion(TIntermConstantUnion *node)
    {
        if (node->getType().getObjectSize() == mConstantVector.size())
        {
            bool found = true;
            for (size_t i = 0; i < mConstantVector.size(); i++)
            {
                if (!isEqual(node->getUnionArrayPointer()[i], mConstantVector[i]))
                {
                    found = false;
                    break;
                }
            }
            if (found)
            {
                mFound = found;
            }
        }
    }

    bool found() const { return mFound; }

  private:
    bool isEqual(const TConstantUnion &node, const float &value) const
    {
        if (node.getType() != EbtFloat)
        {
            return false;
        }
        if (value == std::numeric_limits<float>::infinity())
        {
            return gl::isInf(node.getFConst()) && node.getFConst() > 0;
        }
        else if (value == -std::numeric_limits<float>::infinity())
        {
            return gl::isInf(node.getFConst()) && node.getFConst() < 0;
        }
        else if (gl::isNaN(value))
        {
            // All NaNs are treated as equal.
            return gl::isNaN(node.getFConst());
        }
        return mFaultTolerance >= fabsf(node.getFConst() - value);
    }

    bool isEqual(const TConstantUnion &node, const int &value) const
    {
        if (node.getType() != EbtInt)
        {
            return false;
        }
        ASSERT(mFaultTolerance < std::numeric_limits<int>::max());
        // abs() returns 0 at least on some platforms when the minimum int value is passed in (it
        // doesn't have a positive counterpart).
        return mFaultTolerance >= abs(node.getIConst() - value) &&
               (node.getIConst() - value) != std::numeric_limits<int>::min();
    }

    bool isEqual(const TConstantUnion &node, const unsigned int &value) const
    {
        if (node.getType() != EbtUInt)
        {
            return false;
        }
        ASSERT(mFaultTolerance < static_cast<unsigned int>(std::numeric_limits<int>::max()));
        return static_cast<int>(mFaultTolerance) >=
                   abs(static_cast<int>(node.getUConst() - value)) &&
               static_cast<int>(node.getUConst() - value) != std::numeric_limits<int>::min();
    }

    bool isEqual(const TConstantUnion &node, const bool &value) const
    {
        if (node.getType() != EbtBool)
        {
            return false;
        }
        return node.getBConst() == value;
    }

    std::vector<T> mConstantVector;
    T mFaultTolerance;
    bool mFound;
};

class ConstantFoldingTest : public testing::Test
{
  public:
    ConstantFoldingTest() {}

  protected:
    void SetUp() override;

    void TearDown() override;

    void compile(const std::string &shaderString);

    // Must be called after compile()
    bool hasWarning();

    template <typename T>
    bool constantFoundInAST(T constant)
    {
        ConstantFinder<T> finder(constant);
        mASTRoot->traverse(&finder);
        return finder.found();
    }

    template <typename T>
    bool constantVectorFoundInAST(const std::vector<T> &constantVector)
    {
        ConstantFinder<T> finder(constantVector);
        mASTRoot->traverse(&finder);
        return finder.found();
    }

    template <typename T>
    bool constantColumnMajorMatrixFoundInAST(const std::vector<T> &constantMatrix)
    {
        return constantVectorFoundInAST(constantMatrix);
    }

    template <typename T>
    bool constantVectorNearFoundInAST(const std::vector<T> &constantVector, const T &faultTolerance)
    {
        ConstantFinder<T> finder(constantVector, faultTolerance);
        mASTRoot->traverse(&finder);
        return finder.found();
    }

  private:
    TranslatorESSL *mTranslatorESSL;
    TIntermNode *mASTRoot;

    TPoolAllocator allocator;
};

class ConstantFoldingExpressionTest : public ConstantFoldingTest
{
  public:
    ConstantFoldingExpressionTest() {}

    void evaluateFloat(const std::string &floatExpression);
};

}  // namespace sh

#endif  // TESTS_TEST_UTILS_CONSTANTFOLDINGTEST_H_
