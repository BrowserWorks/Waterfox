/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "vm/CodeCoverage.h"

#include "mozilla/Atomics.h"
#include "mozilla/IntegerPrintfMacros.h"

#include <stdio.h>
#ifdef XP_WIN
#include <process.h>
#define getpid _getpid
#else
#include <unistd.h>
#endif

#include "jscompartment.h"
#include "jsopcode.h"
#include "jsprf.h"
#include "jsscript.h"

#include "vm/Runtime.h"
#include "vm/Time.h"

// This file contains a few functions which are used to produce files understood
// by lcov tools. A detailed description of the format is available in the man
// page for "geninfo" [1].  To make it short, the following paraphrases what is
// commented in the man page by using curly braces prefixed by for-each to
// express repeated patterns.
//
//   TN:<compartment name>
//   for-each <source file> {
//     SN:<filename>
//     for-each <script> {
//       FN:<line>,<name>
//     }
//     for-each <script> {
//       FNDA:<hits>,<name>
//     }
//     FNF:<number of scripts>
//     FNH:<sum of scripts hits>
//     for-each <script> {
//       for-each <branch> {
//         BRDA:<line>,<block id>,<target id>,<taken>
//       }
//     }
//     BRF:<number of branches>
//     BRH:<sum of branches hits>
//     for-each <script> {
//       for-each <line> {
//         DA:<line>,<hits>
//       }
//     }
//     LF:<number of lines>
//     LH:<sum of lines hits>
//   }
//
// [1] http://ltp.sourceforge.net/coverage/lcov/geninfo.1.php
//
namespace js {
namespace coverage {

LCovSource::LCovSource(LifoAlloc* alloc, JSObject* sso)
  : source_(sso),
    outSF_(alloc),
    outFN_(alloc),
    outFNDA_(alloc),
    numFunctionsFound_(0),
    numFunctionsHit_(0),
    outBRDA_(alloc),
    numBranchesFound_(0),
    numBranchesHit_(0),
    outDA_(alloc),
    numLinesInstrumented_(0),
    numLinesHit_(0),
    hasFilename_(false),
    hasTopLevelScript_(false)
{
}

void
LCovSource::exportInto(GenericPrinter& out) const
{
    // Only write if everything got recorded.
    if (!hasFilename_ || !hasTopLevelScript_)
        return;

    outSF_.exportInto(out);

    outFN_.exportInto(out);
    outFNDA_.exportInto(out);
    out.printf("FNF:%" PRIuSIZE "\n", numFunctionsFound_);
    out.printf("FNH:%" PRIuSIZE "\n", numFunctionsHit_);

    outBRDA_.exportInto(out);
    out.printf("BRF:%" PRIuSIZE "\n", numBranchesFound_);
    out.printf("BRH:%" PRIuSIZE "\n", numBranchesHit_);

    outDA_.exportInto(out);
    out.printf("LF:%" PRIuSIZE "\n", numLinesInstrumented_);
    out.printf("LH:%" PRIuSIZE "\n", numLinesHit_);

    out.put("end_of_record\n");
}

bool
LCovSource::writeSourceFilename(ScriptSourceObject* sso)
{
    outSF_.printf("SF:%s\n", sso->source()->filename());
    if (outSF_.hadOutOfMemory())
        return false;

    hasFilename_ = true;
    return true;
}

bool
LCovSource::writeScriptName(LSprinter& out, JSScript* script)
{
    JSFunction* fun = script->functionNonDelazifying();
    if (fun && fun->displayAtom())
        return EscapedStringPrinter(out, fun->displayAtom(), 0);
    out.printf("top-level");
    return true;
}

bool
LCovSource::writeScript(JSScript* script)
{
    numFunctionsFound_++;
    outFN_.printf("FN:%" PRIuSIZE ",", script->lineno());
    if (!writeScriptName(outFN_, script))
        return false;
    outFN_.put("\n", 1);

    uint64_t hits = 0;
    ScriptCounts* sc = nullptr;
    if (script->hasScriptCounts()) {
        sc = &script->getScriptCounts();
        numFunctionsHit_++;
        const PCCounts* counts = sc->maybeGetPCCounts(script->pcToOffset(script->main()));
        outFNDA_.printf("FNDA:%" PRIu64 ",", counts->numExec());
        if (!writeScriptName(outFNDA_, script))
            return false;
        outFNDA_.put("\n", 1);

        // Set the hit count of the pre-main code to 1, if the function ever got
        // visited.
        hits = 1;
    }

    jsbytecode* snpc = script->code();
    jssrcnote* sn = script->notes();
    if (!SN_IS_TERMINATOR(sn))
        snpc += SN_DELTA(sn);

    size_t lineno = script->lineno();
    jsbytecode* end = script->codeEnd();
    size_t branchId = 0;
    size_t tableswitchExitOffset = 0;
    for (jsbytecode* pc = script->code(); pc != end; pc = GetNextPc(pc)) {
        JSOp op = JSOp(*pc);
        bool jump = IsJumpOpcode(op) || op == JSOP_TABLESWITCH;
        bool fallsthrough = BytecodeFallsThrough(op) && op != JSOP_GOSUB;

        // If the current script & pc has a hit-count report, then update the
        // current number of hits.
        if (sc) {
            const PCCounts* counts = sc->maybeGetPCCounts(script->pcToOffset(pc));
            if (counts)
                hits = counts->numExec();
        }

        // If we have additional source notes, walk all the source notes of the
        // current pc.
        if (snpc <= pc) {
            size_t oldLine = lineno;
            while (!SN_IS_TERMINATOR(sn) && snpc <= pc) {
                SrcNoteType type = (SrcNoteType) SN_TYPE(sn);
                if (type == SRC_SETLINE)
                    lineno = size_t(GetSrcNoteOffset(sn, 0));
                else if (type == SRC_NEWLINE)
                    lineno++;
                else if (type == SRC_TABLESWITCH)
                    tableswitchExitOffset = GetSrcNoteOffset(sn, 0);

                sn = SN_NEXT(sn);
                snpc += SN_DELTA(sn);
            }

            if (oldLine != lineno && fallsthrough) {
                outDA_.printf("DA:%" PRIuSIZE ",%" PRIu64 "\n", lineno, hits);

                // Count the number of lines instrumented & hit.
                numLinesInstrumented_++;
                if (hits)
                    numLinesHit_++;
            }
        }

        // If the current instruction has thrown, then decrement the hit counts
        // with the number of throws.
        if (sc) {
            const PCCounts* counts = sc->maybeGetThrowCounts(script->pcToOffset(pc));
            if (counts)
                hits -= counts->numExec();
        }

        // If the current pc corresponds to a conditional jump instruction, then reports
        // branch hits.
        if (jump && fallsthrough) {
            jsbytecode* fallthroughTarget = GetNextPc(pc);
            uint64_t fallthroughHits = 0;
            if (sc) {
                const PCCounts* counts = sc->maybeGetPCCounts(script->pcToOffset(fallthroughTarget));
                if (counts)
                    fallthroughHits = counts->numExec();
            }

            uint64_t taken = hits - fallthroughHits;
            outBRDA_.printf("BRDA:%" PRIuSIZE ",%" PRIuSIZE ",0,", lineno, branchId);
            if (taken)
                outBRDA_.printf("%" PRIu64 "\n", taken);
            else
                outBRDA_.put("-\n", 2);

            outBRDA_.printf("BRDA:%" PRIuSIZE ",%" PRIuSIZE ",1,", lineno, branchId);
            if (fallthroughHits)
                outBRDA_.printf("%" PRIu64 "\n", fallthroughHits);
            else
                outBRDA_.put("-\n", 2);

            // Count the number of branches, and the number of branches hit.
            numBranchesFound_ += 2;
            if (hits)
                numBranchesHit_ += !!taken + !!fallthroughHits;
            branchId++;
        }

        // If the current pc corresponds to a pre-computed switch case, then
        // reports branch hits for each case statement.
        if (jump && op == JSOP_TABLESWITCH) {
            MOZ_ASSERT(tableswitchExitOffset != 0);

            // Get the default and exit pc
            jsbytecode* exitpc = pc + tableswitchExitOffset;
            jsbytecode* defaultpc = pc + GET_JUMP_OFFSET(pc);
            MOZ_ASSERT(defaultpc > pc && defaultpc <= exitpc);

            // Get the low and high from the tableswitch
            int32_t low = GET_JUMP_OFFSET(pc + JUMP_OFFSET_LEN * 1);
            int32_t high = GET_JUMP_OFFSET(pc + JUMP_OFFSET_LEN * 2);
            MOZ_ASSERT(high - low + 1 >= 0);
            size_t numCases = high - low + 1;
            jsbytecode* jumpTable = pc + JUMP_OFFSET_LEN * 3;

            jsbytecode* firstcasepc = exitpc;
            for (size_t j = 0; j < numCases; j++) {
                jsbytecode* testpc = pc + GET_JUMP_OFFSET(jumpTable + JUMP_OFFSET_LEN * j);
                if (testpc < firstcasepc)
                    firstcasepc = testpc;
            }

            // Count the number of hits of the default branch, by subtracting
            // the number of hits of each cases.
            uint64_t defaultHits = hits;

            // Count the number of hits of the previous case entry.
            uint64_t fallsThroughHits = 0;

            // Record branches for each cases.
            size_t caseId = 0;
            for (size_t i = 0; i < numCases; i++) {
                jsbytecode* casepc = pc + GET_JUMP_OFFSET(jumpTable + JUMP_OFFSET_LEN * i);
                // The case is not present, and jumps to the default pc if used.
                if (casepc == pc)
                    continue;

                // PCs might not be in increasing order of case indexes.
                jsbytecode* lastcasepc = firstcasepc - 1;
                for (size_t j = 0; j < numCases; j++) {
                    jsbytecode* testpc = pc + GET_JUMP_OFFSET(jumpTable + JUMP_OFFSET_LEN * j);
                    if (lastcasepc < testpc && (testpc < casepc || (j < i && testpc == casepc)))
                        lastcasepc = testpc;
                }

                if (casepc != lastcasepc) {
                    // Case (i + low)
                    uint64_t caseHits = 0;
                    if (sc) {
                        const PCCounts* counts = sc->maybeGetPCCounts(script->pcToOffset(casepc));
                        if (counts)
                            caseHits = counts->numExec();

                        // Remove fallthrough.
                        fallsThroughHits = 0;
                        if (casepc != firstcasepc) {
                            jsbytecode* endpc = lastcasepc;
                            while (GetNextPc(endpc) < casepc)
                                endpc = GetNextPc(endpc);

                            if (BytecodeFallsThrough(JSOp(*endpc)))
                                fallsThroughHits = script->getHitCount(endpc);
                        }

                        caseHits -= fallsThroughHits;
                    }

                    outBRDA_.printf("BRDA:%" PRIuSIZE ",%" PRIuSIZE ",%" PRIuSIZE ",",
                                    lineno, branchId, caseId);
                    if (caseHits)
                        outBRDA_.printf("%" PRIu64 "\n", caseHits);
                    else
                        outBRDA_.put("-\n", 2);

                    numBranchesFound_++;
                    numBranchesHit_ += !!caseHits;
                    defaultHits -= caseHits;
                    caseId++;
                }
            }

            // Compute the number of hits of the default branch, if it has its
            // own case clause.
            bool defaultHasOwnClause = true;
            if (defaultpc != exitpc) {
                defaultHits = 0;

                // Look for the last case entry before the default pc.
                jsbytecode* lastcasepc = firstcasepc - 1;
                for (size_t j = 0; j < numCases; j++) {
                    jsbytecode* testpc = pc + GET_JUMP_OFFSET(jumpTable + JUMP_OFFSET_LEN * j);
                    if (lastcasepc < testpc && testpc <= defaultpc)
                        lastcasepc = testpc;
                }

                if (lastcasepc == defaultpc)
                    defaultHasOwnClause = false;

                // Look if the last case entry fallthrough to the default case,
                // in which case we have to remove the number of fallthrough
                // hits out of the default case hits.
                if (sc && lastcasepc != pc) {
                    jsbytecode* endpc = lastcasepc;
                    while (GetNextPc(endpc) < defaultpc)
                        endpc = GetNextPc(endpc);

                    if (BytecodeFallsThrough(JSOp(*endpc)))
                        fallsThroughHits = script->getHitCount(endpc);
                }

                if (sc) {
                    const PCCounts* counts = sc->maybeGetPCCounts(script->pcToOffset(defaultpc));
                    if (counts)
                        defaultHits = counts->numExec();
                }
                defaultHits -= fallsThroughHits;
            }

            if (defaultHasOwnClause) {
                outBRDA_.printf("BRDA:%" PRIuSIZE ",%" PRIuSIZE ",%" PRIuSIZE ",",
                                lineno, branchId, caseId);
                if (defaultHits)
                    outBRDA_.printf("%" PRIu64 "\n", defaultHits);
                else
                    outBRDA_.put("-\n", 2);
                numBranchesFound_++;
                numBranchesHit_ += !!defaultHits;
            }

            // Increment the branch identifier, and go to the next instruction.
            branchId++;
            tableswitchExitOffset = 0;
        }
    }

    // Report any new OOM.
    if (outFN_.hadOutOfMemory() ||
        outFNDA_.hadOutOfMemory() ||
        outBRDA_.hadOutOfMemory() ||
        outDA_.hadOutOfMemory())
    {
        return false;
    }

    // If this script is the top-level script, then record it such that we can
    // assume that the code coverage report is complete, as this script has
    // references on all inner scripts.
    if (script->isTopLevel())
        hasTopLevelScript_ = true;

    return true;
}

LCovCompartment::LCovCompartment()
  : alloc_(4096),
    outTN_(&alloc_),
    sources_(nullptr)
{
    MOZ_ASSERT(alloc_.isEmpty());
}

void
LCovCompartment::collectCodeCoverageInfo(JSCompartment* comp, JSObject* sso,
                                         JSScript* script)
{
    // Skip any operation if we already some out-of memory issues.
    if (outTN_.hadOutOfMemory())
        return;

    if (!script->code())
        return;

    // Get the existing source LCov summary, or create a new one.
    LCovSource* source = lookupOrAdd(comp, sso);
    if (!source)
        return;

    // Write code coverage data into the LCovSource.
    if (!source->writeScript(script)) {
        outTN_.reportOutOfMemory();
        return;
    }
}

void
LCovCompartment::collectSourceFile(JSCompartment* comp, ScriptSourceObject* sso)
{
    // Do not add sources if there is no file name associated to it.
    if (!sso->source()->filename())
        return;

    // Skip any operation if we already some out-of memory issues.
    if (outTN_.hadOutOfMemory())
        return;

    // Get the existing source LCov summary, or create a new one.
    LCovSource* source = lookupOrAdd(comp, sso);
    if (!source)
        return;

    // Write source filename into the LCovSource.
    if (!source->writeSourceFilename(sso)) {
        outTN_.reportOutOfMemory();
        return;
    }
}

LCovSource*
LCovCompartment::lookupOrAdd(JSCompartment* comp, JSObject* sso)
{
    // On the first call, write the compartment name, and allocate a LCovSource
    // vector in the LifoAlloc.
    if (!sources_) {
        if (!writeCompartmentName(comp))
            return nullptr;

        LCovSourceVector* raw = alloc_.pod_malloc<LCovSourceVector>();
        if (!raw) {
            outTN_.reportOutOfMemory();
            return nullptr;
        }

        sources_ = new(raw) LCovSourceVector(alloc_);
    } else {
        // Find the first matching source.
        for (LCovSource& source : *sources_) {
            if (source.match(sso))
                return &source;
        }
    }

    // Allocate a new LCovSource for the current top-level.
    if (!sources_->append(Move(LCovSource(&alloc_, sso)))) {
        outTN_.reportOutOfMemory();
        return nullptr;
    }

    return &sources_->back();
}

void
LCovCompartment::exportInto(GenericPrinter& out, bool* isEmpty) const
{
    if (!sources_ || outTN_.hadOutOfMemory())
        return;

    // If we only have cloned function, then do not serialize anything.
    bool someComplete = false;
    for (const LCovSource& sc : *sources_) {
        if (sc.isComplete()) {
            someComplete = true;
            break;
        };
    }

    if (!someComplete)
        return;

    *isEmpty = false;
    outTN_.exportInto(out);
    for (const LCovSource& sc : *sources_) {
        if (sc.isComplete())
            sc.exportInto(out);
    }
}

bool
LCovCompartment::writeCompartmentName(JSCompartment* comp)
{
    JSContext* cx = TlsContext.get();

    // lcov trace files are starting with an optional test case name, that we
    // recycle to be a compartment name.
    //
    // Note: The test case name has some constraint in terms of valid character,
    // thus we escape invalid chracters with a "_" symbol in front of its
    // hexadecimal code.
    outTN_.put("TN:");
    if (cx->runtime()->compartmentNameCallback) {
        char name[1024];
        {
            // Hazard analysis cannot tell that the callback does not GC.
            JS::AutoSuppressGCAnalysis nogc;
            (*cx->runtime()->compartmentNameCallback)(cx, comp, name, sizeof(name));
        }
        for (char *s = name; s < name + sizeof(name) && *s; s++) {
            if (('a' <= *s && *s <= 'z') ||
                ('A' <= *s && *s <= 'Z') ||
                ('0' <= *s && *s <= '9'))
            {
                outTN_.put(s, 1);
                continue;
            }
            outTN_.printf("_%p", (void*) size_t(*s));
        }
        outTN_.put("\n", 1);
    } else {
        outTN_.printf("Compartment_%p%p\n", (void*) size_t('_'), comp);
    }

    return !outTN_.hadOutOfMemory();
}

LCovRuntime::LCovRuntime()
  : out_(),
    pid_(getpid()),
    isEmpty_(false)
{
}

LCovRuntime::~LCovRuntime()
{
    if (out_.isInitialized())
        finishFile();
}

bool
LCovRuntime::fillWithFilename(char *name, size_t length)
{
    const char* outDir = getenv("JS_CODE_COVERAGE_OUTPUT_DIR");
    if (!outDir || *outDir == 0)
        return false;

    int64_t timestamp = static_cast<double>(PRMJ_Now()) / PRMJ_USEC_PER_SEC;
    static mozilla::Atomic<size_t> globalRuntimeId(0);
    size_t rid = globalRuntimeId++;

    int len = snprintf(name, length, "%s/%" PRId64 "-%" PRIu32 "-%" PRIuSIZE ".info",
                       outDir, timestamp, pid_, rid);
    if (len < 0 || size_t(len) >= length) {
        fprintf(stderr, "Warning: LCovRuntime::init: Cannot serialize file name.");
        return false;
    }

    return true;
}

void
LCovRuntime::init()
{
    char name[1024];
    if (!fillWithFilename(name, sizeof(name)))
        return;

    // If we cannot open the file, report a warning.
    if (!out_.init(name))
        fprintf(stderr, "Warning: LCovRuntime::init: Cannot open file named '%s'.", name);
    isEmpty_ = true;
}

void
LCovRuntime::finishFile()
{
    MOZ_ASSERT(out_.isInitialized());
    out_.finish();

    if (isEmpty_) {
        char name[1024];
        if (!fillWithFilename(name, sizeof(name)))
            return;
        remove(name);
    }
}

void
LCovRuntime::writeLCovResult(LCovCompartment& comp)
{
    if (!out_.isInitialized())
        return;

    uint32_t p = getpid();
    if (pid_ != p) {
        pid_ = p;
        finishFile();
        init();
        if (!out_.isInitialized())
            return;
    }

    comp.exportInto(out_, &isEmpty_);
    out_.flush();
}

} // namespace coverage
} // namespace js
