//
// Copyright (c) 2002-2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

#ifndef COMPILER_TRANSLATOR_SYMBOLTABLE_H_
#define COMPILER_TRANSLATOR_SYMBOLTABLE_H_

//
// Symbol table for parsing.  Has these design characteristics:
//
// * Same symbol table can be used to compile many shaders, to preserve
//   effort of creating and loading with the large numbers of built-in
//   symbols.
//
// * Name mangling will be used to give each function a unique name
//   so that symbol table lookups are never ambiguous.  This allows
//   a simpler symbol table structure.
//
// * Pushing and popping of scope, so symbol table will really be a stack 
//   of symbol tables.  Searched from the top, with new inserts going into
//   the top.
//
// * Constants:  Compile time constant symbols will keep their values
//   in the symbol table.  The parser can substitute constants at parse
//   time, including doing constant folding and constant propagation.
//
// * No temporaries:  Temporaries made from operations (+, --, .xy, etc.)
//   are tracked in the intermediate representation, not the symbol table.
//

#include <array>
#include <assert.h>
#include <set>

#include "common/angleutils.h"
#include "compiler/translator/InfoSink.h"
#include "compiler/translator/IntermNode.h"

namespace sh
{

// Symbol base class. (Can build functions or variables out of these...)
class TSymbol : angle::NonCopyable
{
  public:
    POOL_ALLOCATOR_NEW_DELETE();
    TSymbol(const TString *n);

    virtual ~TSymbol()
    {
        // don't delete name, it's from the pool
    }

    const TString &getName() const
    {
        return *name;
    }
    virtual const TString &getMangledName() const
    {
        return getName();
    }
    virtual bool isFunction() const
    {
        return false;
    }
    virtual bool isVariable() const
    {
        return false;
    }
    int getUniqueId() const
    {
        return uniqueId;
    }
    void relateToExtension(const TString &ext)
    {
        extension = ext;
    }
    const TString &getExtension() const
    {
        return extension;
    }

  private:
    const int uniqueId;
    const TString *name;
    TString extension;
};

// Variable class, meaning a symbol that's not a function.
// 
// There could be a separate class heirarchy for Constant variables;
// Only one of int, bool, or float, (or none) is correct for
// any particular use, but it's easy to do this way, and doesn't
// seem worth having separate classes, and "getConst" can't simply return
// different values for different types polymorphically, so this is 
// just simple and pragmatic.
class TVariable : public TSymbol
{
  public:
    TVariable(const TString *name, const TType &t, bool uT = false)
        : TSymbol(name),
          type(t),
          userType(uT),
          unionArray(0)
    {
    }
    ~TVariable() override {}
    bool isVariable() const override { return true; }
    TType &getType()
    {
        return type;
    }
    const TType &getType() const
    {
        return type;
    }
    bool isUserType() const
    {
        return userType;
    }
    void setQualifier(TQualifier qualifier)
    {
        type.setQualifier(qualifier);
    }

    const TConstantUnion *getConstPointer() const { return unionArray; }

    void shareConstPointer(const TConstantUnion *constArray) { unionArray = constArray; }

  private:
    TType type;
    bool userType;
    // we are assuming that Pool Allocator will free the memory
    // allocated to unionArray when this object is destroyed.
    const TConstantUnion *unionArray;
};

// Immutable version of TParameter.
struct TConstParameter
{
    TConstParameter()
        : name(nullptr),
          type(nullptr)
    {
    }
    explicit TConstParameter(const TString *n)
        : name(n),
          type(nullptr)
    {
    }
    explicit TConstParameter(const TType *t)
        : name(nullptr),
          type(t)
    {
    }
    TConstParameter(const TString *n, const TType *t)
        : name(n),
          type(t)
    {
    }

    // Both constructor arguments must be const.
    TConstParameter(TString *n, TType *t) = delete;
    TConstParameter(const TString *n, TType *t) = delete;
    TConstParameter(TString *n, const TType *t) = delete;

    const TString *name;
    const TType *type;
};

// The function sub-class of symbols and the parser will need to
// share this definition of a function parameter.
struct TParameter
{
    // Destructively converts to TConstParameter.
    // This method resets name and type to nullptrs to make sure
    // their content cannot be modified after the call.
    TConstParameter turnToConst()
    {
        const TString *constName = name;
        const TType *constType = type;
        name = nullptr;
        type = nullptr;
        return TConstParameter(constName, constType);
    }

    TString *name;
    TType *type;
};

// The function sub-class of a symbol.  
class TFunction : public TSymbol
{
  public:
    TFunction(const TString *name,
              const TType *retType,
              TOperator tOp   = EOpNull,
              const char *ext = "")
        : TSymbol(name),
          returnType(retType),
          mangledName(nullptr),
          op(tOp),
          defined(false),
          mHasPrototypeDeclaration(false)
    {
        relateToExtension(ext);
    }
    ~TFunction() override;
    bool isFunction() const override { return true; }

    static TString mangleName(const TString &name)
    {
        return name + '(';
    }
    static TString unmangleName(const TString &mangledName)
    {
        return TString(mangledName.c_str(), mangledName.find_first_of('('));
    }

    void addParameter(const TConstParameter &p)
    {
        parameters.push_back(p);
        mangledName = nullptr;
    }

    void swapParameters(const TFunction &parametersSource);

    const TString &getMangledName() const override
    {
        if (mangledName == nullptr)
        {
            mangledName = buildMangledName();
        }
        return *mangledName;
    }
    const TType &getReturnType() const
    {
        return *returnType;
    }

    TOperator getBuiltInOp() const
    {
        return op;
    }

    void setDefined() { defined = true; }
    bool isDefined() { return defined; }
    void setHasPrototypeDeclaration() { mHasPrototypeDeclaration = true; }
    bool hasPrototypeDeclaration() const { return mHasPrototypeDeclaration; }

    size_t getParamCount() const
    {
        return parameters.size();
    }
    const TConstParameter &getParam(size_t i) const
    {
        return parameters[i];
    }

  private:
    void clearParameters();

    const TString *buildMangledName() const;

    typedef TVector<TConstParameter> TParamList;
    TParamList parameters;
    const TType *returnType;
    mutable const TString *mangledName;
    TOperator op;
    bool defined;
    bool mHasPrototypeDeclaration;
};

// Interface block name sub-symbol
class TInterfaceBlockName : public TSymbol
{
  public:
    TInterfaceBlockName(const TString *name)
        : TSymbol(name)
    {
    }

    virtual ~TInterfaceBlockName()
    {
    }
};

class TSymbolTableLevel
{
  public:
    typedef TMap<TString, TSymbol *> tLevel;
    typedef tLevel::const_iterator const_iterator;
    typedef const tLevel::value_type tLevelPair;
    typedef std::pair<tLevel::iterator, bool> tInsertResult;

    TSymbolTableLevel()
        : mGlobalInvariant(false)
    {
    }
    ~TSymbolTableLevel();

    bool insert(TSymbol *symbol);

    // Insert a function using its unmangled name as the key.
    bool insertUnmangled(TFunction *function);

    TSymbol *find(const TString &name) const;

    void addInvariantVarying(const std::string &name)
    {
        mInvariantVaryings.insert(name);
    }

    bool isVaryingInvariant(const std::string &name)
    {
        return (mGlobalInvariant || mInvariantVaryings.count(name) > 0);
    }

    void setGlobalInvariant(bool invariant) { mGlobalInvariant = invariant; }

  protected:
    tLevel level;
    std::set<std::string> mInvariantVaryings;
    bool mGlobalInvariant;
};

// Define ESymbolLevel as int rather than an enum since level can go
// above GLOBAL_LEVEL and cause atBuiltInLevel() to fail if the
// compiler optimizes the >= of the last element to ==.
typedef int ESymbolLevel;
const int COMMON_BUILTINS = 0;
const int ESSL1_BUILTINS = 1;
const int ESSL3_BUILTINS = 2;
const int ESSL3_1_BUILTINS   = 3;
const int LAST_BUILTIN_LEVEL = ESSL3_1_BUILTINS;
const int GLOBAL_LEVEL       = 4;

class TSymbolTable : angle::NonCopyable
{
  public:
    TSymbolTable()
    {
        // The symbol table cannot be used until push() is called, but
        // the lack of an initial call to push() can be used to detect
        // that the symbol table has not been preloaded with built-ins.
    }

    ~TSymbolTable();

    // When the symbol table is initialized with the built-ins, there should
    // 'push' calls, so that built-ins are at level 0 and the shader
    // globals are at level 1.
    bool isEmpty() const
    {
        return table.empty();
    }
    bool atBuiltInLevel() const
    {
        return currentLevel() <= LAST_BUILTIN_LEVEL;
    }
    bool atGlobalLevel() const
    {
        return currentLevel() == GLOBAL_LEVEL;
    }
    void push()
    {
        table.push_back(new TSymbolTableLevel);
        precisionStack.push_back(new PrecisionStackLevel);
    }

    void pop()
    {
        delete table.back();
        table.pop_back();

        delete precisionStack.back();
        precisionStack.pop_back();
    }

    bool declare(TSymbol *symbol)
    {
        return insert(currentLevel(), symbol);
    }

    bool insert(ESymbolLevel level, TSymbol *symbol)
    {
        return table[level]->insert(symbol);
    }

    bool insert(ESymbolLevel level, const char *ext, TSymbol *symbol)
    {
        symbol->relateToExtension(ext);
        return table[level]->insert(symbol);
    }

    bool insertConstInt(ESymbolLevel level, const char *name, int value, TPrecision precision)
    {
        TVariable *constant =
            new TVariable(NewPoolTString(name), TType(EbtInt, precision, EvqConst, 1));
        TConstantUnion *unionArray = new TConstantUnion[1];
        unionArray[0].setIConst(value);
        constant->shareConstPointer(unionArray);
        return insert(level, constant);
    }

    bool insertConstIntExt(ESymbolLevel level, const char *ext, const char *name, int value)
    {
        TVariable *constant =
            new TVariable(NewPoolTString(name), TType(EbtInt, EbpUndefined, EvqConst, 1));
        TConstantUnion *unionArray = new TConstantUnion[1];
        unionArray[0].setIConst(value);
        constant->shareConstPointer(unionArray);
        return insert(level, ext, constant);
    }

    bool insertConstIvec3(ESymbolLevel level,
                          const char *name,
                          const std::array<int, 3> &values,
                          TPrecision precision)
    {
        TVariable *constantIvec3 =
            new TVariable(NewPoolTString(name), TType(EbtInt, precision, EvqConst, 3));

        TConstantUnion *unionArray = new TConstantUnion[3];
        for (size_t index = 0u; index < 3u; ++index)
        {
            unionArray[index].setIConst(values[index]);
        }
        constantIvec3->shareConstPointer(unionArray);

        return insert(level, constantIvec3);
    }

    void insertBuiltIn(ESymbolLevel level, TOperator op, const char *ext, const TType *rvalue, const char *name,
                       const TType *ptype1, const TType *ptype2 = 0, const TType *ptype3 = 0, const TType *ptype4 = 0, const TType *ptype5 = 0);

    void insertBuiltIn(ESymbolLevel level, const TType *rvalue, const char *name,
                       const TType *ptype1, const TType *ptype2 = 0, const TType *ptype3 = 0, const TType *ptype4 = 0, const TType *ptype5 = 0)
    {
        insertUnmangledBuiltIn(name);
        insertBuiltIn(level, EOpNull, "", rvalue, name, ptype1, ptype2, ptype3, ptype4, ptype5);
    }

    void insertBuiltIn(ESymbolLevel level, const char *ext, const TType *rvalue, const char *name,
                       const TType *ptype1, const TType *ptype2 = 0, const TType *ptype3 = 0, const TType *ptype4 = 0, const TType *ptype5 = 0)
    {
        insertUnmangledBuiltIn(name);
        insertBuiltIn(level, EOpNull, ext, rvalue, name, ptype1, ptype2, ptype3, ptype4, ptype5);
    }

    void insertBuiltIn(ESymbolLevel level, TOperator op, const TType *rvalue, const char *name,
                       const TType *ptype1, const TType *ptype2 = 0, const TType *ptype3 = 0, const TType *ptype4 = 0, const TType *ptype5 = 0)
    {
        insertUnmangledBuiltIn(name);
        insertBuiltIn(level, op, "", rvalue, name, ptype1, ptype2, ptype3, ptype4, ptype5);
    }

    TSymbol *find(const TString &name, int shaderVersion,
                  bool *builtIn = NULL, bool *sameScope = NULL) const;

    TSymbol *findGlobal(const TString &name) const;

    TSymbol *findBuiltIn(const TString &name, int shaderVersion) const;

    TSymbolTableLevel *getOuterLevel()
    {
        assert(currentLevel() >= 1);
        return table[currentLevel() - 1];
    }

    void dump(TInfoSink &infoSink) const;

    bool setDefaultPrecision(const TPublicType &type, TPrecision prec)
    {
        if (!SupportsPrecision(type.getBasicType()))
            return false;
        if (type.getBasicType() == EbtUInt)
            return false;  // ESSL 3.00.4 section 4.5.4
        if (type.isAggregate())
            return false; // Not allowed to set for aggregate types
        int indexOfLastElement = static_cast<int>(precisionStack.size()) - 1;
        // Uses map operator [], overwrites the current value
        (*precisionStack[indexOfLastElement])[type.getBasicType()] = prec;
        return true;
    }

    // Searches down the precisionStack for a precision qualifier
    // for the specified TBasicType
    TPrecision getDefaultPrecision(TBasicType type) const;

    // This records invariant varyings declared through
    // "invariant varying_name;".
    void addInvariantVarying(const std::string &originalName)
    {
        ASSERT(atGlobalLevel());
        table[currentLevel()]->addInvariantVarying(originalName);
    }
    // If this returns false, the varying could still be invariant
    // if it is set as invariant during the varying variable
    // declaration - this piece of information is stored in the
    // variable's type, not here.
    bool isVaryingInvariant(const std::string &originalName) const
    {
        ASSERT(atGlobalLevel());
        return table[currentLevel()]->isVaryingInvariant(originalName);
    }

    void setGlobalInvariant(bool invariant)
    {
        ASSERT(atGlobalLevel());
        table[currentLevel()]->setGlobalInvariant(invariant);
    }

    static int nextUniqueId()
    {
        return ++uniqueIdCounter;
    }

    bool hasUnmangledBuiltIn(const char *name)
    {
        return mUnmangledBuiltinNames.count(std::string(name)) > 0;
    }

  private:
    ESymbolLevel currentLevel() const
    {
        return static_cast<ESymbolLevel>(table.size() - 1);
    }

    // Used to insert unmangled functions to check redeclaration of built-ins in ESSL 3.00.
    void insertUnmangledBuiltIn(const char *name)
    {
        mUnmangledBuiltinNames.insert(std::string(name));
    }

    std::vector<TSymbolTableLevel *> table;
    typedef TMap<TBasicType, TPrecision> PrecisionStackLevel;
    std::vector< PrecisionStackLevel *> precisionStack;

    std::set<std::string> mUnmangledBuiltinNames;

    static int uniqueIdCounter;
};

}  // namespace sh

#endif // COMPILER_TRANSLATOR_SYMBOLTABLE_H_
