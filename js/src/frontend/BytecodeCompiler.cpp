/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "frontend/BytecodeCompiler.h"

#include "mozilla/Attributes.h"
#include "mozilla/IntegerPrintfMacros.h"
#include "mozilla/Maybe.h"
#include "mozilla/Utf8.h"  // mozilla::Utf8Unit

#include "builtin/ModuleObject.h"
#if defined(JS_BUILD_BINAST)
#  include "frontend/BinASTParser.h"
#endif  // JS_BUILD_BINAST
#include "frontend/BytecodeCompilation.h"
#include "frontend/BytecodeEmitter.h"
#include "frontend/EitherParser.h"
#include "frontend/ErrorReporter.h"
#include "frontend/FoldConstants.h"
#ifdef JS_ENABLE_SMOOSH
#  include "frontend/Frontend2.h"  // Smoosh
#endif
#include "frontend/ModuleSharedContext.h"
#include "frontend/Parser.h"
#include "js/SourceText.h"
#include "vm/GeneratorAndAsyncKind.h"  // js::GeneratorKind, js::FunctionAsyncKind
#include "vm/GlobalObject.h"
#include "vm/JSContext.h"
#include "vm/JSScript.h"
#include "vm/ModuleBuilder.h"  // js::ModuleBuilder
#include "vm/TraceLogging.h"
#include "wasm/AsmJS.h"

#include "debugger/DebugAPI-inl.h"  // DebugAPI
#include "vm/EnvironmentObject-inl.h"
#include "vm/GeckoProfiler-inl.h"
#include "vm/JSContext-inl.h"

using namespace js;
using namespace js::frontend;

using mozilla::Maybe;
using mozilla::Nothing;
using mozilla::Utf8Unit;

using JS::CompileOptions;
using JS::ReadOnlyCompileOptions;
using JS::SourceText;

// RAII class to check the frontend reports an exception when it fails to
// compile a script.
class MOZ_RAII AutoAssertReportedException {
#ifdef DEBUG
  JSContext* cx_;
  bool check_;

 public:
  explicit AutoAssertReportedException(JSContext* cx) : cx_(cx), check_(true) {}
  void reset() { check_ = false; }
  ~AutoAssertReportedException() {
    if (!check_) {
      return;
    }

    if (!cx_->isHelperThreadContext()) {
      MOZ_ASSERT(cx_->isExceptionPending());
      return;
    }

    ParseTask* task = cx_->parseTask();
    MOZ_ASSERT(task->outOfMemory || task->overRecursed ||
               !task->errors.empty());
  }
#else
 public:
  explicit AutoAssertReportedException(JSContext*) {}
  void reset() {}
#endif
};

static bool EmplaceEmitter(CompilationInfo& compilationInfo,
                           Maybe<BytecodeEmitter>& emitter,
                           const EitherParser& parser, SharedContext* sc);

template <typename Unit>
class MOZ_STACK_CLASS frontend::SourceAwareCompiler {
 protected:
  SourceText<Unit>& sourceBuffer_;

  Maybe<Parser<SyntaxParseHandler, Unit>> syntaxParser;
  Maybe<Parser<FullParseHandler, Unit>> parser;

  using TokenStreamPosition = frontend::TokenStreamPosition<Unit>;

 protected:
  explicit SourceAwareCompiler(SourceText<Unit>& sourceBuffer)
      : sourceBuffer_(sourceBuffer) {
    MOZ_ASSERT(sourceBuffer_.get() != nullptr);
  }

  // Call this before calling compile{Global,Eval}Script.
  MOZ_MUST_USE bool createSourceAndParser(LifoAllocScope& allocScope,
                                          CompilationInfo& compilationInfo);

  void assertSourceAndParserCreated(CompilationInfo& compilationInfo) const {
    MOZ_ASSERT(compilationInfo.sourceObject != nullptr);
    MOZ_ASSERT(compilationInfo.sourceObject->source() != nullptr);
    MOZ_ASSERT(parser.isSome());
  }

  void assertSourceParserAndScriptCreated(CompilationInfo& compilationInfo) {
    assertSourceAndParserCreated(compilationInfo);
  }

  MOZ_MUST_USE bool emplaceEmitter(CompilationInfo& compilationInfo,
                                   Maybe<BytecodeEmitter>& emitter,
                                   SharedContext* sharedContext) {
    return EmplaceEmitter(compilationInfo, emitter, EitherParser(parser.ptr()),
                          sharedContext);
  }

  bool canHandleParseFailure(CompilationInfo& compilationInfo,
                             const Directives& newDirectives);

  void handleParseFailure(CompilationInfo& compilationInfo,
                          const Directives& newDirectives,
                          TokenStreamPosition& startPosition,
                          CompilationInfo::RewindToken& startObj);
};

template <typename Unit>
class MOZ_STACK_CLASS frontend::ScriptCompiler
    : public SourceAwareCompiler<Unit> {
  using Base = SourceAwareCompiler<Unit>;

 protected:
  using Base::parser;
  using Base::sourceBuffer_;

  using Base::assertSourceParserAndScriptCreated;
  using Base::canHandleParseFailure;
  using Base::emplaceEmitter;
  using Base::handleParseFailure;

  using typename Base::TokenStreamPosition;

 public:
  explicit ScriptCompiler(SourceText<Unit>& srcBuf) : Base(srcBuf) {}

  using Base::createSourceAndParser;

  JSScript* compileScript(CompilationInfo& compilationInfo, SharedContext* sc);
};

/* If we're on main thread, tell the Debugger about a newly compiled script.
 *
 * See: finishSingleParseTask/finishMultiParseTask for the off-thread case.
 */
static void tellDebuggerAboutCompiledScript(JSContext* cx, bool hideScript,
                                            Handle<JSScript*> script) {
  if (cx->isHelperThreadContext()) {
    return;
  }

  // If hideScript then script may not be ready to be interrogated by the
  // debugger.
  if (!hideScript) {
    DebugAPI::onNewScript(cx, script);
  }
}

template <typename Unit>
static JSScript* CreateGlobalScript(CompilationInfo& compilationInfo,
                                    GlobalSharedContext& globalsc,
                                    JS::SourceText<Unit>& srcBuf) {
  AutoAssertReportedException assertException(compilationInfo.cx);

  LifoAllocScope allocScope(&compilationInfo.cx->tempLifoAlloc());
  frontend::ScriptCompiler<Unit> compiler(srcBuf);

  if (!compiler.createSourceAndParser(allocScope, compilationInfo)) {
    return nullptr;
  }

  if (!compiler.compileScript(compilationInfo, &globalsc)) {
    return nullptr;
  }

  tellDebuggerAboutCompiledScript(
      compilationInfo.cx, compilationInfo.options.hideScriptFromDebugger,
      compilationInfo.script);

  assertException.reset();
  return compilationInfo.script;
}

JSScript* frontend::CompileGlobalScript(CompilationInfo& compilationInfo,
                                        GlobalSharedContext& globalsc,
                                        JS::SourceText<char16_t>& srcBuf) {
  return CreateGlobalScript(compilationInfo, globalsc, srcBuf);
}

JSScript* frontend::CompileGlobalScript(CompilationInfo& compilationInfo,
                                        GlobalSharedContext& globalsc,
                                        JS::SourceText<Utf8Unit>& srcBuf) {
#ifdef JS_ENABLE_SMOOSH
  if (compilationInfo.cx->options().trySmoosh()) {
    bool unimplemented = false;
    JSContext* cx = compilationInfo.cx;
    JSRuntime* rt = cx->runtime();
    auto script =
        Smoosh::compileGlobalScript(compilationInfo, srcBuf, &unimplemented);
    if (!unimplemented) {
      if (compilationInfo.cx->options().trackNotImplemented()) {
        rt->parserWatcherFile.put("1");
      }
      return script;
    }

    if (compilationInfo.cx->options().trackNotImplemented()) {
      rt->parserWatcherFile.put("0");
    }
    fprintf(stderr, "Falling back!\n");
  }
#endif  // JS_ENABLE_SMOOSH

  return CreateGlobalScript(compilationInfo, globalsc, srcBuf);
}

template <typename Unit>
static JSScript* CreateEvalScript(CompilationInfo& compilationInfo,
                                  EvalSharedContext& evalsc,
                                  SourceText<Unit>& srcBuf) {
  AutoAssertReportedException assertException(compilationInfo.cx);
  LifoAllocScope allocScope(&compilationInfo.cx->tempLifoAlloc());

  frontend::ScriptCompiler<Unit> compiler(srcBuf);
  if (!compiler.createSourceAndParser(allocScope, compilationInfo)) {
    return nullptr;
  }

  if (!compiler.compileScript(compilationInfo, &evalsc)) {
    return nullptr;
  }

  tellDebuggerAboutCompiledScript(
      compilationInfo.cx, compilationInfo.options.hideScriptFromDebugger,
      compilationInfo.script);

  assertException.reset();
  return compilationInfo.script;
}

JSScript* frontend::CompileEvalScript(CompilationInfo& compilationInfo,
                                      EvalSharedContext& evalsc,
                                      JS::SourceText<char16_t>& srcBuf) {
  return CreateEvalScript(compilationInfo, evalsc, srcBuf);
}

template <typename Unit>
class MOZ_STACK_CLASS frontend::ModuleCompiler final
    : public SourceAwareCompiler<Unit> {
  using Base = SourceAwareCompiler<Unit>;

  using Base::assertSourceParserAndScriptCreated;
  using Base::createSourceAndParser;
  using Base::emplaceEmitter;
  using Base::parser;

 public:
  explicit ModuleCompiler(SourceText<Unit>& srcBuf) : Base(srcBuf) {}

  ModuleObject* compile(CompilationInfo& compilationInfo);
};

template <typename Unit>
class MOZ_STACK_CLASS frontend::StandaloneFunctionCompiler final
    : public SourceAwareCompiler<Unit> {
  using Base = SourceAwareCompiler<Unit>;

  using Base::assertSourceAndParserCreated;
  using Base::canHandleParseFailure;
  using Base::emplaceEmitter;
  using Base::handleParseFailure;
  using Base::parser;
  using Base::sourceBuffer_;

  using typename Base::TokenStreamPosition;

 public:
  explicit StandaloneFunctionCompiler(SourceText<Unit>& srcBuf)
      : Base(srcBuf) {}

  using Base::createSourceAndParser;

  FunctionNode* parse(CompilationInfo& compilationInfo, HandleFunction fun,
                      HandleScope enclosingScope, GeneratorKind generatorKind,
                      FunctionAsyncKind asyncKind,
                      const Maybe<uint32_t>& parameterListEnd);

  MOZ_MUST_USE bool compile(MutableHandleFunction fun, CompilationInfo& info,
                            FunctionNode* parsedFunction);
};

AutoFrontendTraceLog::AutoFrontendTraceLog(JSContext* cx,
                                           const TraceLoggerTextId id,
                                           const ErrorReporter& errorReporter)
#ifdef JS_TRACE_LOGGING
    : logger_(TraceLoggerForCurrentThread(cx)) {
  if (!logger_) {
    return;
  }

  // If the tokenizer hasn't yet gotten any tokens, use the line and column
  // numbers from CompileOptions.
  uint32_t line, column;
  if (errorReporter.hasTokenizationStarted()) {
    line = errorReporter.options().lineno;
    column = errorReporter.options().column;
  } else {
    errorReporter.currentLineAndColumn(&line, &column);
  }
  frontendEvent_.emplace(TraceLogger_Frontend, errorReporter.getFilename(),
                         line, column);
  frontendLog_.emplace(logger_, *frontendEvent_);
  typeLog_.emplace(logger_, id);
}
#else
{
}
#endif

AutoFrontendTraceLog::AutoFrontendTraceLog(JSContext* cx,
                                           const TraceLoggerTextId id,
                                           const ErrorReporter& errorReporter,
                                           FunctionBox* funbox)
#ifdef JS_TRACE_LOGGING
    : logger_(TraceLoggerForCurrentThread(cx)) {
  if (!logger_) {
    return;
  }

  frontendEvent_.emplace(TraceLogger_Frontend, errorReporter.getFilename(),
                         funbox->extent.lineno, funbox->extent.column);
  frontendLog_.emplace(logger_, *frontendEvent_);
  typeLog_.emplace(logger_, id);
}
#else
{
}
#endif

AutoFrontendTraceLog::AutoFrontendTraceLog(JSContext* cx,
                                           const TraceLoggerTextId id,
                                           const ErrorReporter& errorReporter,
                                           ParseNode* pn)
#ifdef JS_TRACE_LOGGING
    : logger_(TraceLoggerForCurrentThread(cx)) {
  if (!logger_) {
    return;
  }

  uint32_t line, column;
  errorReporter.lineAndColumnAt(pn->pn_pos.begin, &line, &column);
  frontendEvent_.emplace(TraceLogger_Frontend, errorReporter.getFilename(),
                         line, column);
  frontendLog_.emplace(logger_, *frontendEvent_);
  typeLog_.emplace(logger_, id);
}
#else
{
}
#endif

static bool CanLazilyParse(const CompilationInfo& compilationInfo) {
  return !compilationInfo.options.discardSource &&
         !compilationInfo.options.sourceIsLazy &&
         !compilationInfo.options.forceFullParse();
}

template <typename Unit>
bool frontend::SourceAwareCompiler<Unit>::createSourceAndParser(
    LifoAllocScope& allocScope, CompilationInfo& compilationInfo) {
  if (!compilationInfo.assignSource(sourceBuffer_)) {
    return false;
  }

  if (CanLazilyParse(compilationInfo)) {
    syntaxParser.emplace(compilationInfo.cx, compilationInfo.options,
                         sourceBuffer_.units(), sourceBuffer_.length(),
                         /* foldConstants = */ false, compilationInfo, nullptr,
                         nullptr);
    if (!syntaxParser->checkOptions()) {
      return false;
    }
  }

  parser.emplace(compilationInfo.cx, compilationInfo.options,
                 sourceBuffer_.units(), sourceBuffer_.length(),
                 /* foldConstants = */ true, compilationInfo,
                 syntaxParser.ptrOr(nullptr), nullptr);
  parser->ss = compilationInfo.sourceObject->source();
  return parser->checkOptions();
}

static bool EmplaceEmitter(CompilationInfo& compilationInfo,
                           Maybe<BytecodeEmitter>& emitter,
                           const EitherParser& parser, SharedContext* sc) {
  BytecodeEmitter::EmitterMode emitterMode =
      sc->selfHosted() ? BytecodeEmitter::SelfHosting : BytecodeEmitter::Normal;
  emitter.emplace(/* parent = */ nullptr, parser, sc, compilationInfo,
                  emitterMode);
  return emitter->init();
}

template <typename Unit>
bool frontend::SourceAwareCompiler<Unit>::canHandleParseFailure(
    CompilationInfo& compilationInfo, const Directives& newDirectives) {
  // Try to reparse if no parse errors were thrown and the directives changed.
  //
  // NOTE:
  // Only the following two directive changes force us to reparse the script:
  // - The "use asm" directive was encountered.
  // - The "use strict" directive was encountered and duplicate parameter names
  //   are present. We reparse in this case to display the error at the correct
  //   source location. See |Parser::hasValidSimpleStrictParameterNames()|.
  return !parser->anyChars.hadError() &&
         compilationInfo.directives != newDirectives;
}

template <typename Unit>
void frontend::SourceAwareCompiler<Unit>::handleParseFailure(
    CompilationInfo& compilationInfo, const Directives& newDirectives,
    TokenStreamPosition& startPosition,
    CompilationInfo::RewindToken& startObj) {
  MOZ_ASSERT(canHandleParseFailure(compilationInfo, newDirectives));

  // Rewind to starting position to retry.
  parser->tokenStream.rewind(startPosition);
  compilationInfo.rewind(startObj);

  // Assignment must be monotonic to prevent reparsing iloops
  MOZ_ASSERT_IF(compilationInfo.directives.strict(), newDirectives.strict());
  MOZ_ASSERT_IF(compilationInfo.directives.asmJS(), newDirectives.asmJS());
  compilationInfo.directives = newDirectives;
}

template <typename Unit>
JSScript* frontend::ScriptCompiler<Unit>::compileScript(
    CompilationInfo& compilationInfo, SharedContext* sc) {
  assertSourceParserAndScriptCreated(compilationInfo);

  TokenStreamPosition startPosition(compilationInfo.keepAtoms,
                                    parser->tokenStream);

  JSContext* cx = compilationInfo.cx;

  ParseNode* pn;
  {
    AutoGeckoProfilerEntry pseudoFrame(cx, "script parsing",
                                       JS::ProfilingCategoryPair::JS_Parsing);
    if (sc->isEvalContext()) {
      pn = parser->evalBody(sc->asEvalContext());
    } else {
      pn = parser->globalBody(sc->asGlobalContext());
    }
  }

  if (!pn) {
    // Global and eval scripts don't get reparsed after a new directive was
    // encountered:
    // - "use strict" doesn't require any special error reporting for scripts.
    // - "use asm" directives don't have an effect in global/eval contexts.
    MOZ_ASSERT(
        !canHandleParseFailure(compilationInfo, compilationInfo.directives));
    return nullptr;
  }

  {
    // Successfully parsed. Emit the script.
    AutoGeckoProfilerEntry pseudoFrame(cx, "script emit",
                                       JS::ProfilingCategoryPair::JS_Parsing);

    Maybe<BytecodeEmitter> emitter;
    if (!emplaceEmitter(compilationInfo, emitter, sc)) {
      return nullptr;
    }

    if (!emitter->emitScript(pn)) {
      return nullptr;
    }

    if (!compilationInfo.instantiateStencils()) {
      return nullptr;
    }

    MOZ_ASSERT(compilationInfo.script);
  }

  // We have just finished parsing the source. Inform the source so that we
  // can compute statistics (e.g. how much time our functions remain lazy).
  compilationInfo.sourceObject->source()->recordParseEnded();

  // Enqueue an off-thread source compression task after finishing parsing.
  if (!compilationInfo.sourceObject->source()->tryCompressOffThread(cx)) {
    return nullptr;
  }

  MOZ_ASSERT_IF(!cx->isHelperThreadContext(), !cx->isExceptionPending());

  return compilationInfo.script;
}

template <typename Unit>
ModuleObject* frontend::ModuleCompiler<Unit>::compile(
    CompilationInfo& compilationInfo) {
  if (!createSourceAndParser(compilationInfo.allocScope, compilationInfo)) {
    return nullptr;
  }
  JSContext* cx = compilationInfo.cx;

  Rooted<ModuleObject*> module(cx, ModuleObject::create(cx));
  if (!module) {
    return nullptr;
  }

  ModuleBuilder builder(cx, parser.ptr());

  RootedScope enclosingScope(cx, &cx->global()->emptyGlobalScope());
  uint32_t len = this->sourceBuffer_.length();
  SourceExtent extent =
      SourceExtent::makeGlobalExtent(len, compilationInfo.options);
  ModuleSharedContext modulesc(cx, module, compilationInfo, enclosingScope,
                               builder, extent);

  ParseNode* pn = parser->moduleBody(&modulesc);
  if (!pn) {
    return nullptr;
  }

  Maybe<BytecodeEmitter> emitter;
  if (!emplaceEmitter(compilationInfo, emitter, &modulesc)) {
    return nullptr;
  }

  if (!emitter->emitScript(pn->as<ModuleNode>().body())) {
    return nullptr;
  }

  if (!compilationInfo.instantiateStencils()) {
    return nullptr;
  }

  MOZ_ASSERT(compilationInfo.script);

  if (!builder.initModule(module)) {
    return nullptr;
  }

  module->initScriptSlots(compilationInfo.script);
  module->initStatusSlot();

  if (!ModuleObject::createEnvironment(cx, module)) {
    return nullptr;
  }

  // Enqueue an off-thread source compression task after finishing parsing.
  if (!compilationInfo.sourceObject->source()->tryCompressOffThread(cx)) {
    return nullptr;
  }

  MOZ_ASSERT_IF(!cx->isHelperThreadContext(), !cx->isExceptionPending());
  return module;
}

// Parse a standalone JS function, which might appear as the value of an
// event handler attribute in an HTML <INPUT> tag, or in a Function()
// constructor.
template <typename Unit>
FunctionNode* frontend::StandaloneFunctionCompiler<Unit>::parse(
    CompilationInfo& compilationInfo, HandleFunction fun,
    HandleScope enclosingScope, GeneratorKind generatorKind,
    FunctionAsyncKind asyncKind, const Maybe<uint32_t>& parameterListEnd) {
  MOZ_ASSERT(fun);
  MOZ_ASSERT(fun->isTenured());

  assertSourceAndParserCreated(compilationInfo);

  TokenStreamPosition startPosition(compilationInfo.keepAtoms,
                                    parser->tokenStream);
  CompilationInfo::RewindToken startObj = compilationInfo.getRewindToken();

  // Speculatively parse using the default directives implied by the context.
  // If a directive is encountered (e.g., "use strict") that changes how the
  // function should have been parsed, we backup and reparse with the new set
  // of directives.

  FunctionNode* fn;
  for (;;) {
    Directives newDirectives = compilationInfo.directives;
    fn = parser->standaloneFunction(fun, enclosingScope, parameterListEnd,
                                    generatorKind, asyncKind,
                                    compilationInfo.directives, &newDirectives);
    if (fn) {
      break;
    }

    // Maybe we encountered a new directive. See if we can try again.
    if (!canHandleParseFailure(compilationInfo, newDirectives)) {
      return nullptr;
    }

    handleParseFailure(compilationInfo, newDirectives, startPosition, startObj);
  }

  return fn;
}

// Compile a standalone JS function.
template <typename Unit>
bool frontend::StandaloneFunctionCompiler<Unit>::compile(
    MutableHandleFunction fun, CompilationInfo& compilationInfo,
    FunctionNode* parsedFunction) {
  FunctionBox* funbox = parsedFunction->funbox();
  if (funbox->isInterpreted()) {
    MOZ_ASSERT(fun == funbox->function());

    // The parser extent has stripped off the leading `function...` but
    // we want the SourceExtent used in the final standalone script to
    // start from the beginning of the buffer, and use the provided
    // line and column.
    compilationInfo.topLevelExtent =
        SourceExtent{/* sourceStart = */ 0,
                     sourceBuffer_.length(),
                     funbox->extent.toStringStart,
                     funbox->extent.toStringEnd,
                     compilationInfo.options.lineno,
                     compilationInfo.options.column};

    Maybe<BytecodeEmitter> emitter;
    if (!emplaceEmitter(compilationInfo, emitter, funbox)) {
      return false;
    }

    if (!emitter->emitFunctionScript(parsedFunction, TopLevelFunction::Yes)) {
      return false;
    }

    funbox->synchronizeArgCount();

    if (!compilationInfo.instantiateStencils()) {
      return false;
    }

    MOZ_ASSERT(compilationInfo.script);
  } else {
    fun.set(funbox->function());
    MOZ_ASSERT(IsAsmJSModule(fun));
  }

  // Enqueue an off-thread source compression task after finishing parsing.
  return compilationInfo.sourceObject->source()->tryCompressOffThread(
      compilationInfo.cx);
}

ScriptSourceObject* frontend::CreateScriptSourceObject(
    JSContext* cx, const ReadOnlyCompileOptions& options) {
  ScriptSource* ss = cx->new_<ScriptSource>();
  if (!ss) {
    return nullptr;
  }
  ScriptSourceHolder ssHolder(ss);

  if (!ss->initFromOptions(cx, options)) {
    return nullptr;
  }

  RootedScriptSourceObject sso(cx, ScriptSourceObject::create(cx, ss));
  if (!sso) {
    return nullptr;
  }

  // Off-thread compilations do all their GC heap allocation, including the
  // SSO, in a temporary compartment. Hence, for the SSO to refer to the
  // gc-heap-allocated values in |options|, it would need cross-compartment
  // wrappers from the temporary compartment to the real compartment --- which
  // would then be inappropriate once we merged the temporary and real
  // compartments.
  //
  // Instead, we put off populating those SSO slots in off-thread compilations
  // until after we've merged compartments.
  if (!cx->isHelperThreadContext()) {
    if (!ScriptSourceObject::initFromOptions(cx, sso, options)) {
      return nullptr;
    }
  }

  return sso;
}

#if defined(JS_BUILD_BINAST)

template <class ParserT>
static JSScript* CompileGlobalBinASTScriptImpl(
    JSContext* cx, const ReadOnlyCompileOptions& options, const uint8_t* src,
    size_t len, JS::BinASTFormat format, ScriptSourceObject** sourceObjectOut) {
  AutoAssertReportedException assertException(cx);

  LifoAllocScope allocScope(&cx->tempLifoAlloc());
  CompilationInfo compilationInfo(cx, allocScope, options);
  if (!compilationInfo.init(cx)) {
    return nullptr;
  }

  if (!compilationInfo.sourceObject->source()->setBinASTSourceCopy(cx, src,
                                                                   len)) {
    return nullptr;
  }

  SourceExtent extent = SourceExtent::makeGlobalExtent(len);
  extent.lineno = 0;
  GlobalSharedContext globalsc(cx, ScopeKind::Global, compilationInfo,
                               compilationInfo.directives, extent);

  frontend::BinASTParser<ParserT> parser(cx, compilationInfo, options);

  // Metadata stores internal pointers, so we must use the same buffer every
  // time, including for lazy parses
  ScriptSource* ss = compilationInfo.sourceObject->source();
  BinASTSourceMetadata* metadata = nullptr;
  auto parsed =
      parser.parse(&globalsc, ss->binASTSource(), ss->length(), &metadata);

  if (parsed.isErr()) {
    return nullptr;
  }

  compilationInfo.sourceObject->source()->setBinASTSourceMetadata(metadata);

  BytecodeEmitter bce(nullptr, &parser, &globalsc, compilationInfo);

  if (!bce.init()) {
    return nullptr;
  }

  ParseNode* pn = parsed.unwrap();
  if (!bce.emitScript(pn)) {
    return nullptr;
  }

  if (!compilationInfo.instantiateStencils()) {
    return nullptr;
  }

  if (sourceObjectOut) {
    *sourceObjectOut = compilationInfo.sourceObject;
  }

  tellDebuggerAboutCompiledScript(cx, options.hideScriptFromDebugger,
                                  compilationInfo.script);

  assertException.reset();
  return compilationInfo.script;
}

JSScript* frontend::CompileGlobalBinASTScript(
    JSContext* cx, const ReadOnlyCompileOptions& options, const uint8_t* src,
    size_t len, JS::BinASTFormat format, ScriptSourceObject** sourceObjectOut) {
  if (format == JS::BinASTFormat::Multipart) {
    return CompileGlobalBinASTScriptImpl<BinASTTokenReaderMultipart>(
        cx, options, src, len, format, sourceObjectOut);
  }

  MOZ_ASSERT(format == JS::BinASTFormat::Context);
  return CompileGlobalBinASTScriptImpl<BinASTTokenReaderContext>(
      cx, options, src, len, format, sourceObjectOut);
}

#endif  // JS_BUILD_BINAST

template <typename Unit>
static ModuleObject* InternalParseModule(
    JSContext* cx, const ReadOnlyCompileOptions& optionsInput,
    SourceText<Unit>& srcBuf, ScriptSourceObject** sourceObjectOut) {
  MOZ_ASSERT(srcBuf.get());
  MOZ_ASSERT_IF(sourceObjectOut, *sourceObjectOut == nullptr);

  AutoAssertReportedException assertException(cx);

  CompileOptions options(cx, optionsInput);
  options.setForceStrictMode();  // ES6 10.2.1 Module code is always strict mode
                                 // code.
  options.setIsRunOnce(true);
  options.allowHTMLComments = false;

  LifoAllocScope allocScope(&cx->tempLifoAlloc());
  CompilationInfo compilationInfo(cx, allocScope, options);
  if (!compilationInfo.init(cx)) {
    return nullptr;
  }

  if (sourceObjectOut) {
    *sourceObjectOut = compilationInfo.sourceObject;
  }

  ModuleCompiler<Unit> compiler(srcBuf);
  Rooted<ModuleObject*> module(cx, compiler.compile(compilationInfo));
  if (!module) {
    return nullptr;
  }

  tellDebuggerAboutCompiledScript(cx, options.hideScriptFromDebugger,
                                  compilationInfo.script);

  assertException.reset();
  return module;
}

ModuleObject* frontend::ParseModule(JSContext* cx,
                                    const ReadOnlyCompileOptions& optionsInput,
                                    SourceText<char16_t>& srcBuf,
                                    ScriptSourceObject** sourceObjectOut) {
  return InternalParseModule(cx, optionsInput, srcBuf, sourceObjectOut);
}

ModuleObject* frontend::ParseModule(JSContext* cx,
                                    const ReadOnlyCompileOptions& optionsInput,
                                    SourceText<Utf8Unit>& srcBuf,
                                    ScriptSourceObject** sourceObjectOut) {
  return InternalParseModule(cx, optionsInput, srcBuf, sourceObjectOut);
}

template <typename Unit>
static ModuleObject* CreateModule(JSContext* cx,
                                  const JS::ReadOnlyCompileOptions& options,
                                  SourceText<Unit>& srcBuf) {
  AutoAssertReportedException assertException(cx);

  if (!GlobalObject::ensureModulePrototypesCreated(cx, cx->global())) {
    return nullptr;
  }

  RootedModuleObject module(cx, ParseModule(cx, options, srcBuf, nullptr));
  if (!module) {
    return nullptr;
  }

  // This happens in GlobalHelperThreadState::finishModuleParseTask() when a
  // module is compiled off thread.
  if (!ModuleObject::Freeze(cx, module)) {
    return nullptr;
  }

  assertException.reset();
  return module;
}

ModuleObject* frontend::CompileModule(JSContext* cx,
                                      const JS::ReadOnlyCompileOptions& options,
                                      SourceText<char16_t>& srcBuf) {
  return CreateModule(cx, options, srcBuf);
}

ModuleObject* frontend::CompileModule(JSContext* cx,
                                      const JS::ReadOnlyCompileOptions& options,
                                      SourceText<Utf8Unit>& srcBuf) {
  return CreateModule(cx, options, srcBuf);
}

template <typename Unit>
static bool CompileLazyFunctionImpl(JSContext* cx, Handle<BaseScript*> lazy,
                                    const Unit* units, size_t length) {
  MOZ_ASSERT(cx->compartment() == lazy->compartment());

  // We can only compile functions whose parents have previously been
  // compiled, because compilation requires full information about the
  // function's immediately enclosing scope.
  MOZ_ASSERT(lazy->isReadyForDelazification());
  MOZ_ASSERT(!lazy->isBinAST());

  AutoAssertReportedException assertException(cx);
  Rooted<JSFunction*> fun(cx, lazy->function());

  JS::CompileOptions options(cx);
  options.setMutedErrors(lazy->mutedErrors())
      .setFileAndLine(lazy->filename(), lazy->lineno())
      .setColumn(lazy->column())
      .setScriptSourceOffset(lazy->sourceStart())
      .setNoScriptRval(false)
      .setSelfHostingMode(false);

  // Update statistics to find out if we are delazifying just after having
  // lazified. Note that we are interested in the delta between end of
  // syntax parsing and start of full parsing, so we do this now rather than
  // after parsing below.
  if (!lazy->scriptSource()->parseEnded().IsNull()) {
    const mozilla::TimeDuration delta =
        ReallyNow() - lazy->scriptSource()->parseEnded();

    // Differentiate between web-facing and privileged code, to aid
    // with optimization. Due to the number of calls to this function,
    // we use `cx->runningWithTrustedPrincipals`, which is fast but
    // will classify addons alongside with web-facing code.
    const int HISTOGRAM =
        cx->runningWithTrustedPrincipals()
            ? JS_TELEMETRY_PRIVILEGED_PARSER_COMPILE_LAZY_AFTER_MS
            : JS_TELEMETRY_WEB_PARSER_COMPILE_LAZY_AFTER_MS;
    cx->runtime()->addTelemetry(HISTOGRAM, delta.ToMilliseconds());
  }

  LifoAllocScope allocScope(&cx->tempLifoAlloc());
  CompilationInfo compilationInfo(cx, allocScope, options,
                                  fun->enclosingScope());
  compilationInfo.initFromLazy(lazy);

  Parser<FullParseHandler, Unit> parser(cx, options, units, length,
                                        /* foldConstants = */ true,
                                        compilationInfo, nullptr, lazy);
  if (!parser.checkOptions()) {
    return false;
  }

  FunctionNode* pn =
      parser.standaloneLazyFunction(fun, lazy->toStringStart(), lazy->strict(),
                                    lazy->generatorKind(), lazy->asyncKind());
  if (!pn) {
    return false;
  }

  mozilla::DebugOnly<uint32_t> lazyFlags =
      static_cast<uint32_t>(lazy->immutableFlags());

  BytecodeEmitter bce(/* parent = */ nullptr, &parser, pn->funbox(),
                      compilationInfo, BytecodeEmitter::LazyFunction);
  if (!bce.init(pn->pn_pos)) {
    return false;
  }

  if (!bce.emitFunctionScript(pn, TopLevelFunction::Yes)) {
    return false;
  }

  if (!compilationInfo.instantiateStencils()) {
    return false;
  }

  MOZ_ASSERT(lazyFlags == compilationInfo.script->immutableFlags());
  MOZ_ASSERT(compilationInfo.script->outermostScope()->hasOnChain(
                 ScopeKind::NonSyntactic) ==
             compilationInfo.script->immutableFlags().hasFlag(
                 JSScript::ImmutableFlags::HasNonSyntacticScope));

  assertException.reset();
  return true;
}

bool frontend::CompileLazyFunction(JSContext* cx, Handle<BaseScript*> lazy,
                                   const char16_t* units, size_t length) {
  return CompileLazyFunctionImpl(cx, lazy, units, length);
}

bool frontend::CompileLazyFunction(JSContext* cx, Handle<BaseScript*> lazy,
                                   const Utf8Unit* units, size_t length) {
  return CompileLazyFunctionImpl(cx, lazy, units, length);
}

#ifdef JS_BUILD_BINAST

template <class ParserT>
static bool CompileLazyBinASTFunctionImpl(JSContext* cx,
                                          Handle<BaseScript*> lazy,
                                          const uint8_t* buf, size_t length) {
  MOZ_ASSERT(cx->compartment() == lazy->compartment());

  // We can only compile functions whose parents have previously been
  // compiled, because compilation requires full information about the
  // function's immediately enclosing scope.
  MOZ_ASSERT(lazy->isReadyForDelazification());
  MOZ_ASSERT(lazy->isBinAST());

  AutoAssertReportedException assertException(cx);
  Rooted<JSFunction*> fun(cx, lazy->function());

  mozilla::DebugOnly<bool> lazyIsLikelyConstructorWrapper =
      lazy->isLikelyConstructorWrapper();

  CompileOptions options(cx);
  options.setMutedErrors(lazy->mutedErrors())
      .setFileAndLine(lazy->filename(), lazy->lineno())
      .setColumn(lazy->column())
      .setScriptSourceOffset(lazy->sourceStart())
      .setNoScriptRval(false)
      .setSelfHostingMode(false);

  LifoAllocScope allocScope(&cx->tempLifoAlloc());
  CompilationInfo compilationInfo(cx, allocScope, options);
  compilationInfo.initFromLazy(lazy);

  frontend::BinASTParser<ParserT> parser(cx, compilationInfo, options, lazy);

  auto parsed =
      parser.parseLazyFunction(lazy->scriptSource(), lazy->sourceStart());

  if (parsed.isErr()) {
    return false;
  }

  FunctionNode* pn = parsed.unwrap();

  BytecodeEmitter bce(nullptr, &parser, pn->funbox(), compilationInfo,
                      BytecodeEmitter::LazyFunction);

  if (!bce.init(pn->pn_pos)) {
    return false;
  }

  if (!bce.emitFunctionScript(pn, TopLevelFunction::Yes)) {
    return false;
  }

  if (!compilationInfo.instantiateStencils()) {
    return false;
  }

  // This value *must* not change after the lazy function is first created.
  MOZ_ASSERT(lazyIsLikelyConstructorWrapper ==
             compilationInfo.script->isLikelyConstructorWrapper());

  assertException.reset();
  return true;
}

bool frontend::CompileLazyBinASTFunction(JSContext* cx,
                                         Handle<BaseScript*> lazy,
                                         const uint8_t* buf, size_t length) {
  if (lazy->scriptSource()->binASTSourceMetadata()->isMultipart()) {
    return CompileLazyBinASTFunctionImpl<BinASTTokenReaderMultipart>(
        cx, lazy, buf, length);
  }

  MOZ_ASSERT(lazy->scriptSource()->binASTSourceMetadata()->isContext());
  return CompileLazyBinASTFunctionImpl<BinASTTokenReaderContext>(cx, lazy, buf,
                                                                 length);
}

#endif  // JS_BUILD_BINAST

static bool CompileStandaloneFunction(JSContext* cx, MutableHandleFunction fun,
                                      const JS::ReadOnlyCompileOptions& options,
                                      JS::SourceText<char16_t>& srcBuf,
                                      const Maybe<uint32_t>& parameterListEnd,
                                      GeneratorKind generatorKind,
                                      FunctionAsyncKind asyncKind,
                                      HandleScope enclosingScope = nullptr) {
  AutoAssertReportedException assertException(cx);

  LifoAllocScope allocScope(&cx->tempLifoAlloc());
  CompilationInfo compilationInfo(cx, allocScope, options, enclosingScope);
  if (!compilationInfo.init(cx)) {
    return false;
  }

  StandaloneFunctionCompiler<char16_t> compiler(srcBuf);
  if (!compiler.createSourceAndParser(allocScope, compilationInfo)) {
    return false;
  }

  RootedScope scope(cx, enclosingScope);
  if (!scope) {
    scope = &cx->global()->emptyGlobalScope();
  }

  FunctionNode* parsedFunction = compiler.parse(
      compilationInfo, fun, scope, generatorKind, asyncKind, parameterListEnd);
  if (!parsedFunction ||
      !compiler.compile(fun, compilationInfo, parsedFunction)) {
    return false;
  }

  // Note: If AsmJS successfully compiles, the into.script will still be
  // nullptr. In this case we have compiled to a native function instead of an
  // interpreted script.
  if (compilationInfo.script) {
    if (parameterListEnd) {
      compilationInfo.sourceObject->source()->setParameterListEnd(
          *parameterListEnd);
    }
    tellDebuggerAboutCompiledScript(cx, options.hideScriptFromDebugger,
                                    compilationInfo.script);
  }

  assertException.reset();
  return true;
}

bool frontend::CompileStandaloneFunction(
    JSContext* cx, MutableHandleFunction fun,
    const JS::ReadOnlyCompileOptions& options, JS::SourceText<char16_t>& srcBuf,
    const Maybe<uint32_t>& parameterListEnd,
    HandleScope enclosingScope /* = nullptr */) {
  return CompileStandaloneFunction(
      cx, fun, options, srcBuf, parameterListEnd, GeneratorKind::NotGenerator,
      FunctionAsyncKind::SyncFunction, enclosingScope);
}

bool frontend::CompileStandaloneGenerator(
    JSContext* cx, MutableHandleFunction fun,
    const JS::ReadOnlyCompileOptions& options, JS::SourceText<char16_t>& srcBuf,
    const Maybe<uint32_t>& parameterListEnd) {
  return CompileStandaloneFunction(cx, fun, options, srcBuf, parameterListEnd,
                                   GeneratorKind::Generator,
                                   FunctionAsyncKind::SyncFunction);
}

bool frontend::CompileStandaloneAsyncFunction(
    JSContext* cx, MutableHandleFunction fun,
    const ReadOnlyCompileOptions& options, JS::SourceText<char16_t>& srcBuf,
    const Maybe<uint32_t>& parameterListEnd) {
  return CompileStandaloneFunction(cx, fun, options, srcBuf, parameterListEnd,
                                   GeneratorKind::NotGenerator,
                                   FunctionAsyncKind::AsyncFunction);
}

bool frontend::CompileStandaloneAsyncGenerator(
    JSContext* cx, MutableHandleFunction fun,
    const ReadOnlyCompileOptions& options, JS::SourceText<char16_t>& srcBuf,
    const Maybe<uint32_t>& parameterListEnd) {
  return CompileStandaloneFunction(cx, fun, options, srcBuf, parameterListEnd,
                                   GeneratorKind::Generator,
                                   FunctionAsyncKind::AsyncFunction);
}

bool frontend::CompilationInfo::init(JSContext* cx) {
  sourceObject = CreateScriptSourceObject(cx, options);
  return !!sourceObject;
}
