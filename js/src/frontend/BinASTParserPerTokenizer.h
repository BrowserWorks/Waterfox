/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef frontend_BinASTParserPerTokenizer_h
#define frontend_BinASTParserPerTokenizer_h

/**
 * A Binary AST parser.
 *
 * At the time of this writing, this parser implements the grammar of ES5
 * and trusts its input (in particular, variable declarations).
 */

#include "mozilla/Maybe.h"

#include <type_traits>

#include "frontend/BCEParserHandle.h"
#include "frontend/BinASTEnum.h"
#include "frontend/BinASTParserBase.h"
#include "frontend/BinASTToken.h"
#include "frontend/BinASTTokenReaderContext.h"
#include "frontend/BinASTTokenReaderMultipart.h"
#include "frontend/FullParseHandler.h"
#include "frontend/FunctionSyntaxKind.h"  // FunctionSyntaxKind
#include "frontend/ParseContext.h"
#include "frontend/ParseNode.h"
#include "frontend/SharedContext.h"
#include "js/CompileOptions.h"
#include "js/GCHashTable.h"
#include "js/GCVector.h"
#include "js/Result.h"
#include "vm/ErrorReporting.h"
#include "vm/GeneratorAndAsyncKind.h"  // js::GeneratorKind, js::FunctionAsyncKind

namespace js {
namespace frontend {

template <typename Tok>
class BinASTParser;

/**
 * The parser for a Binary AST.
 *
 * By design, this parser never needs to backtrack or look ahead. Errors are not
 * recoverable.
 */
template <typename Tok>
class BinASTParserPerTokenizer : public BinASTParserBase,
                                 public ErrorReporter,
                                 public BCEParserHandle {
 public:
  using Tokenizer = Tok;

  using AutoList = typename Tokenizer::AutoList;
  using AutoTaggedTuple = typename Tokenizer::AutoTaggedTuple;
  using Chars = typename Tokenizer::Chars;
  using RootContext = BinASTTokenReaderBase::RootContext;
  using FieldOrRootContext = BinASTTokenReaderBase::FieldOrRootContext;

 public:
  // Auto-generated types.
  using AssertedDeclaredKind = binast::AssertedDeclaredKind;
  using VariableDeclarationKind = binast::VariableDeclarationKind;

 public:
  BinASTParserPerTokenizer(JSContext* cx, CompilationInfo& compilationInfo,
                           const JS::ReadOnlyCompileOptions& options,
                           Handle<BaseScript*> lazyScript = nullptr);

  /**
   * Parse a buffer, returning a node (which may be nullptr) in case of success
   * or Nothing() in case of error.
   *
   * The instance of `ParseNode` MAY NOT survive the
   * `BinASTParserPerTokenizer`. Indeed, destruction of the
   * `BinASTParserPerTokenizer` will also destroy the `ParseNode`.
   *
   * In case of error, the parser reports the JS error.
   */
  JS::Result<ParseNode*> parse(GlobalSharedContext* globalsc,
                               const uint8_t* start, const size_t length,
                               BinASTSourceMetadata** metadataPtr = nullptr);
  JS::Result<ParseNode*> parse(GlobalSharedContext* globalsc,
                               const Vector<uint8_t>& data,
                               BinASTSourceMetadata** metadataPtr = nullptr);

  JS::Result<FunctionNode*> parseLazyFunction(ScriptSource* scriptSource,
                                              const size_t firstOffset);

 protected:
  MOZ_MUST_USE JS::Result<ParseNode*> parseAux(
      GlobalSharedContext* globalsc, const uint8_t* start, const size_t length,
      BinASTSourceMetadata** metadataPtr = nullptr);

  // --- Raise errors.
  //
  // These methods return a (failed) JS::Result for convenience.

  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&> raiseInvalidClosedVar(
      JSAtom* name);
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&>
  raiseMissingVariableInAssertedScope(JSAtom* name);
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&>
  raiseMissingDirectEvalInAssertedScope();
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&> raiseInvalidKind(
      const char* superKind, const BinASTKind kind);
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&> raiseInvalidVariant(
      const char* kind, const BinASTVariant value);
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&> raiseMissingField(
      const char* kind, const BinASTField field);
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&> raiseEmpty(
      const char* description);
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&> raiseOOM();
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&> raiseError(
      const char* description);
  MOZ_MUST_USE mozilla::GenericErrorResult<JS::Error&> raiseError(
      BinASTKind kind, const char* description);

  // Ensure that this parser will never be used again.
  void poison();

  // The owner or the target of Asserted*Scope.
  enum class AssertedScopeKind {
    Block,
    Catch,
    Global,
    Parameter,
    Var,
  };

  // --- Auxiliary parsing functions

  // Build a function object for a function-producing production. Called AFTER
  // creating the scope.
  JS::Result<FunctionBox*> buildFunctionBox(GeneratorKind generatorKind,
                                            FunctionAsyncKind functionAsyncKind,
                                            FunctionSyntaxKind syntax,
                                            ParseNode* name);

  JS::Result<FunctionNode*> makeEmptyFunctionNode(
      const size_t start, const FunctionSyntaxKind syntaxKind,
      FunctionBox* funbox);
  MOZ_MUST_USE JS::Result<Ok> setFunctionParametersAndBody(FunctionNode* fun,
                                                           ListNode* params,
                                                           ParseNode* body);

  MOZ_MUST_USE JS::Result<Ok> finishEagerFunction(FunctionBox* funbox,
                                                  uint32_t nargs);
  MOZ_MUST_USE JS::Result<Ok> finishLazyFunction(FunctionBox* funbox,
                                                 uint32_t nargs, size_t start,
                                                 size_t end);

  // Add name to a given scope.
  MOZ_MUST_USE JS::Result<Ok> addScopeName(
      AssertedScopeKind scopeKind, HandleAtom name, ParseContext::Scope* scope,
      DeclarationKind declKind, bool isCaptured, bool allowDuplicateName);

  void captureFunctionName();

  // Map AssertedScopeKind and AssertedDeclaredKind for single binding to
  // corresponding ParseContext::Scope to store the binding, and
  // DeclarationKind for the binding.
  MOZ_MUST_USE JS::Result<Ok> getDeclaredScope(AssertedScopeKind scopeKind,
                                               AssertedDeclaredKind kind,
                                               ParseContext::Scope*& scope,
                                               DeclarationKind& declKind);
  MOZ_MUST_USE JS::Result<Ok> getBoundScope(AssertedScopeKind scopeKind,
                                            ParseContext::Scope*& scope,
                                            DeclarationKind& declKind);

  MOZ_MUST_USE JS::Result<Ok> checkBinding(JSAtom* name);

  MOZ_MUST_USE JS::Result<Ok> checkPositionalParameterIndices(
      Handle<GCVector<JSAtom*>> positionalParams, ListNode* params);

  MOZ_MUST_USE JS::Result<Ok> checkFunctionLength(uint32_t expectedLength);

  // When leaving a scope, check that none of its bindings are known closed over
  // and un-marked.
  MOZ_MUST_USE JS::Result<Ok> checkClosedVars(ParseContext::Scope& scope);

  // As a convenience, a helper that checks the body, parameter, and recursive
  // binding scopes.
  MOZ_MUST_USE JS::Result<Ok> checkFunctionClosedVars();

  // --- Utilities.

  MOZ_MUST_USE JS::Result<Ok> prependDirectivesToBody(ListNode* body,
                                                      ListNode* directives);

  MOZ_MUST_USE JS::Result<Ok> prependDirectivesImpl(ListNode* body,
                                                    ParseNode* directive);

  // Optionally force a strict context without restarting the parse when we see
  // a strict directive.
  void forceStrictIfNecessary(SharedContext* sc, ListNode* directives);

  // Whether invalid BinASTKind/BinASTVariant can be encoded in the file.
  // This is used to avoid generating unnecessary branches for more
  // optimized format.
  static constexpr bool isInvalidKindPossible() {
    return std::is_same_v<Tok, BinASTTokenReaderMultipart>;
  }
  static constexpr bool isInvalidVariantPossible() {
    return std::is_same_v<Tok, BinASTTokenReaderMultipart>;
  }

 protected:
  // Implement ErrorReportMixin.
  const JS::ReadOnlyCompileOptions& options_;

  const JS::ReadOnlyCompileOptions& options() const override {
    return this->options_;
  }

  JSContext* getContext() const override { return cx_; };

  MOZ_MUST_USE bool strictMode() const override { return pc_->sc()->strict(); }

  MOZ_MUST_USE bool computeErrorMetadata(ErrorMetadata* err,
                                         const ErrorOffset& offset) override;

 private:
  void trace(JSTracer* trc) final;

 public:
  virtual ErrorReporter& errorReporter() override { return *this; }
  virtual const ErrorReporter& errorReporter() const override { return *this; }

  virtual FullParseHandler& astGenerator() override { return handler_; }

 public:
  // Implement ErrorReporter.

  virtual void lineAndColumnAt(size_t offset, uint32_t* line,
                               uint32_t* column) const override {
    *line = lineAt(offset);
    *column = columnAt(offset);
  }
  virtual uint32_t lineAt(size_t offset) const override { return 0; }
  virtual uint32_t columnAt(size_t offset) const override { return offset; }

  virtual bool isOnThisLine(size_t offset, uint32_t lineNum,
                            bool* isOnSameLine) const override {
    if (lineNum != 0) {
      return false;
    }
    *isOnSameLine = true;
    return true;
  }

  virtual void currentLineAndColumn(uint32_t* line,
                                    uint32_t* column) const override {
    *line = 0;
    *column = offset();
  }
  size_t offset() const {
    if (tokenizer_.isSome()) {
      return tokenizer_->offset();
    }

    return 0;
  }
  virtual bool hasTokenizationStarted() const override {
    return tokenizer_.isSome();
  }
  virtual const char* getFilename() const override {
    return this->options_.filename();
  }

 protected:
  Rooted<BaseScript*> lazyScript_;
  FullParseHandler handler_;

  mozilla::Maybe<Tokenizer> tokenizer_;
  VariableDeclarationKind variableDeclarationKind_;

  friend class BinASTParseContext;
  friend class AutoVariableDeclarationKind;

  // Helper class: Restore field `variableDeclarationKind` upon leaving a scope.
  class MOZ_RAII AutoVariableDeclarationKind {
   public:
    explicit AutoVariableDeclarationKind(
        BinASTParserPerTokenizer<Tok>* parser MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
        : parser_(parser), kind(parser->variableDeclarationKind_) {
      MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    }
    ~AutoVariableDeclarationKind() { parser_->variableDeclarationKind_ = kind; }

   private:
    BinASTParserPerTokenizer<Tok>* parser_;
    BinASTParserPerTokenizer<Tok>::VariableDeclarationKind kind;
    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
  };

  template <typename CharsT>
  bool parseRegExpFlags(CharsT flags, size_t length, JS::RegExpFlags* reflags) {
    MOZ_ASSERT(*reflags == JS::RegExpFlag::NoFlags);
    for (size_t i = 0; i < length; i++) {
      auto c = flags[i];
      if (c == 'g' && !reflags->global()) {
        *reflags |= JS::RegExpFlag::Global;
      } else if (c == 'i' && !reflags->ignoreCase()) {
        *reflags |= JS::RegExpFlag::IgnoreCase;
      } else if (c == 'm' && !reflags->multiline()) {
        *reflags |= JS::RegExpFlag::Multiline;
      }
#ifdef ENABLE_NEW_REGEXP
      else if (c == 's' && !reflags->dotAll()) {
        *reflags |= JS::RegExpFlag::DotAll;
      }
#endif
      else if (c == 'u' && !reflags->unicode()) {
        *reflags |= JS::RegExpFlag::Unicode;
      } else if (c == 'y' && !reflags->sticky()) {
        *reflags |= JS::RegExpFlag::Sticky;
      } else {
        return false;
      }
    }

    return true;
  }

  bool parseRegExpFlags(Chars flags, JS::RegExpFlags* reflags) {
    return parseRegExpFlags(flags.begin(), flags.end() - flags.begin(),
                            reflags);
  }

  bool parseRegExpFlags(HandleAtom flags, JS::RegExpFlags* reflags) {
    JS::AutoCheckCannotGC nogc;
    if (flags->hasLatin1Chars()) {
      return parseRegExpFlags(flags->latin1Chars(nogc), flags->length(),
                              reflags);
    }
    return parseRegExpFlags(flags->twoByteChars(nogc), flags->length(),
                            reflags);
  }

 private:
  // Some methods in this class require access to auto-generated methods in
  // BinASTParser which derives this class.
  // asFinalParser methods provide the access to BinASTParser class methods
  // of this instance.
  using FinalParser = BinASTParser<Tok>;

  inline FinalParser* asFinalParser();
  inline const FinalParser* asFinalParser() const;
};

class BinASTParseContext : public ParseContext {
 public:
  template <typename Tok>
  BinASTParseContext(JSContext* cx, BinASTParserPerTokenizer<Tok>* parser,
                     SharedContext* sc, Directives* newDirectives)
      : ParseContext(cx, parser->pc_, sc, *parser, parser->getCompilationInfo(),
                     newDirectives, /* isFull = */ true) {}
};

extern template class BinASTParserPerTokenizer<BinASTTokenReaderContext>;
extern template class BinASTParserPerTokenizer<BinASTTokenReaderMultipart>;

}  // namespace frontend
}  // namespace js

#endif  // frontend_BinASTParserPerTokenizer_h
