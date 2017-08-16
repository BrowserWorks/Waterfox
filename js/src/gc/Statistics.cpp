/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gc/Statistics.h"

#include "mozilla/ArrayUtils.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/IntegerRange.h"
#include "mozilla/PodOperations.h"
#include "mozilla/Sprintf.h"
#include "mozilla/TimeStamp.h"

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>

#include "jsprf.h"
#include "jsutil.h"

#include "gc/Memory.h"
#include "vm/Debugger.h"
#include "vm/HelperThreads.h"
#include "vm/Runtime.h"
#include "vm/Time.h"

using namespace js;
using namespace js::gc;
using namespace js::gcstats;

using mozilla::DebugOnly;
using mozilla::EnumeratedArray;
using mozilla::IntegerRange;
using mozilla::PodArrayZero;
using mozilla::PodZero;
using mozilla::TimeStamp;
using mozilla::TimeDuration;

/*
 * If this fails, then you can either delete this assertion and allow all
 * larger-numbered reasons to pile up in the last telemetry bucket, or switch
 * to GC_REASON_3 and bump the max value.
 */
JS_STATIC_ASSERT(JS::gcreason::NUM_TELEMETRY_REASONS >= JS::gcreason::NUM_REASONS);

static inline decltype(mozilla::MakeEnumeratedRange(PhaseKind::FIRST, PhaseKind::LIMIT))
AllPhaseKinds()
{
    return mozilla::MakeEnumeratedRange(PhaseKind::FIRST, PhaseKind::LIMIT);
}

const char*
js::gcstats::ExplainInvocationKind(JSGCInvocationKind gckind)
{
    MOZ_ASSERT(gckind == GC_NORMAL || gckind == GC_SHRINK);
    if (gckind == GC_NORMAL)
         return "Normal";
    else
         return "Shrinking";
}

JS_PUBLIC_API(const char*)
JS::gcreason::ExplainReason(JS::gcreason::Reason reason)
{
    switch (reason) {
#define SWITCH_REASON(name)                         \
        case JS::gcreason::name:                    \
          return #name;
        GCREASONS(SWITCH_REASON)

        default:
          MOZ_CRASH("bad GC reason");
#undef SWITCH_REASON
    }
}

const char*
js::gcstats::ExplainAbortReason(gc::AbortReason reason)
{
    switch (reason) {
#define SWITCH_REASON(name)                         \
        case gc::AbortReason::name:                 \
          return #name;
        GC_ABORT_REASONS(SWITCH_REASON)

        default:
          MOZ_CRASH("bad GC abort reason");
#undef SWITCH_REASON
    }
}

struct PhaseKindInfo
{
    Phase firstPhase;
    uint8_t telemetryBucket;
};

// PhaseInfo objects form a tree.
struct PhaseInfo
{
    Phase parent;
    Phase firstChild;
    Phase nextSibling;
    Phase nextInPhase;
    PhaseKind phaseKind;
    uint8_t depth;
    const char* name;
    const char* path;
};

// A table of PhaseInfo indexed by Phase.
using PhaseTable = EnumeratedArray<Phase, Phase::LIMIT, PhaseInfo>;

// A table of PhaseKindInfo indexed by PhaseKind.
using PhaseKindTable = EnumeratedArray<PhaseKind, PhaseKind::LIMIT, PhaseKindInfo>;

#include "gc/StatsPhasesGenerated.cpp"

static double
t(TimeDuration duration)
{
    return duration.ToMilliseconds();
}

inline Phase
Statistics::currentPhase() const
{
    return phaseStack.empty() ? Phase::NONE : phaseStack.back();
}

PhaseKind
Statistics::currentPhaseKind() const
{
    // Public API to get the current phase kind, suppressing the synthetic
    // PhaseKind::MUTATOR phase.

    Phase phase = currentPhase();
    MOZ_ASSERT_IF(phase == Phase::MUTATOR, phaseStack.length() == 1);
    if (phase == Phase::NONE || phase == Phase::MUTATOR)
        return PhaseKind::NONE;

    return phases[phase].phaseKind;
}

Phase
Statistics::lookupChildPhase(PhaseKind phaseKind) const
{
    if (phaseKind == PhaseKind::IMPLICIT_SUSPENSION)
        return Phase::IMPLICIT_SUSPENSION;
    if (phaseKind == PhaseKind::EXPLICIT_SUSPENSION)
        return Phase::EXPLICIT_SUSPENSION;

    MOZ_ASSERT(phaseKind < PhaseKind::LIMIT);

    // Most phases only correspond to a single expanded phase so check for that
    // first.
    Phase phase = phaseKinds[phaseKind].firstPhase;
    if (phases[phase].nextInPhase == Phase::NONE) {
        MOZ_ASSERT(phases[phase].parent == currentPhase());
        return phase;
    }

    // Otherwise search all expanded phases that correspond to the required
    // phase to find the one whose parent is the current expanded phase.
    Phase parent = currentPhase();
    while (phases[phase].parent != parent) {
        phase = phases[phase].nextInPhase;
        MOZ_ASSERT(phase != Phase::NONE);
    }

    return phase;
}

inline decltype(mozilla::MakeEnumeratedRange(Phase::FIRST, Phase::LIMIT))
AllPhases()
{
    return mozilla::MakeEnumeratedRange(Phase::FIRST, Phase::LIMIT);
}

void
Statistics::gcDuration(TimeDuration* total, TimeDuration* maxPause) const
{
    *total = *maxPause = 0;
    for (auto& slice : slices_) {
        *total += slice.duration();
        if (slice.duration() > *maxPause)
            *maxPause = slice.duration();
    }
    if (*maxPause > maxPauseInInterval)
        maxPauseInInterval = *maxPause;
}

void
Statistics::sccDurations(TimeDuration* total, TimeDuration* maxPause) const
{
    *total = *maxPause = 0;
    for (size_t i = 0; i < sccTimes.length(); i++) {
        *total += sccTimes[i];
        *maxPause = Max(*maxPause, sccTimes[i]);
    }
}

typedef Vector<UniqueChars, 8, SystemAllocPolicy> FragmentVector;

static UniqueChars
Join(const FragmentVector& fragments, const char* separator = "")
{
    const size_t separatorLength = strlen(separator);
    size_t length = 0;
    for (size_t i = 0; i < fragments.length(); ++i) {
        length += fragments[i] ? strlen(fragments[i].get()) : 0;
        if (i < (fragments.length() - 1))
            length += separatorLength;
    }

    char* joined = js_pod_malloc<char>(length + 1);
    if (!joined)
        return UniqueChars();

    joined[length] = '\0';
    char* cursor = joined;
    for (size_t i = 0; i < fragments.length(); ++i) {
        if (fragments[i])
            strcpy(cursor, fragments[i].get());
        cursor += fragments[i] ? strlen(fragments[i].get()) : 0;
        if (i < (fragments.length() - 1)) {
            if (separatorLength)
                strcpy(cursor, separator);
            cursor += separatorLength;
        }
    }

    return UniqueChars(joined);
}

static TimeDuration
SumChildTimes(Phase phase, const Statistics::PhaseTimeTable& phaseTimes)
{
    TimeDuration total = 0;
    for (phase = phases[phase].firstChild;
         phase != Phase::NONE;
         phase = phases[phase].nextSibling)
    {
        total += phaseTimes[phase];
    }
    return total;
}

UniqueChars
Statistics::formatCompactSliceMessage() const
{
    // Skip if we OOM'ed.
    if (slices_.length() == 0)
        return UniqueChars(nullptr);

    const size_t index = slices_.length() - 1;
    const SliceData& slice = slices_.back();

    char budgetDescription[200];
    slice.budget.describe(budgetDescription, sizeof(budgetDescription) - 1);

    const char* format =
        "GC Slice %u - Pause: %.3fms of %s budget (@ %.3fms); Reason: %s; Reset: %s%s; Times: ";
    char buffer[1024];
    SprintfLiteral(buffer, format, index,
                   t(slice.duration()), budgetDescription, t(slice.start - slices_[0].start),
                   ExplainReason(slice.reason),
                   slice.wasReset() ? "yes - " : "no",
                   slice.wasReset() ? ExplainAbortReason(slice.resetReason) : "");

    FragmentVector fragments;
    if (!fragments.append(DuplicateString(buffer)) ||
        !fragments.append(formatCompactSlicePhaseTimes(slices_[index].phaseTimes)))
    {
        return UniqueChars(nullptr);
    }
    return Join(fragments);
}

UniqueChars
Statistics::formatCompactSummaryMessage() const
{
    const double bytesPerMiB = 1024 * 1024;

    FragmentVector fragments;
    if (!fragments.append(DuplicateString("Summary - ")))
        return UniqueChars(nullptr);

    TimeDuration total, longest;
    gcDuration(&total, &longest);

    const double mmu20 = computeMMU(TimeDuration::FromMilliseconds(20));
    const double mmu50 = computeMMU(TimeDuration::FromMilliseconds(50));

    char buffer[1024];
    if (!nonincremental()) {
        SprintfLiteral(buffer,
                       "Max Pause: %.3fms; MMU 20ms: %.1f%%; MMU 50ms: %.1f%%; Total: %.3fms; ",
                       t(longest), mmu20 * 100., mmu50 * 100., t(total));
    } else {
        SprintfLiteral(buffer, "Non-Incremental: %.3fms (%s); ",
                       t(total), ExplainAbortReason(nonincrementalReason_));
    }
    if (!fragments.append(DuplicateString(buffer)))
        return UniqueChars(nullptr);

    SprintfLiteral(buffer,
                   "Zones: %d of %d (-%d); Compartments: %d of %d (-%d); HeapSize: %.3f MiB; " \
                   "HeapChange (abs): %+d (%d); ",
                   zoneStats.collectedZoneCount, zoneStats.zoneCount, zoneStats.sweptZoneCount,
                   zoneStats.collectedCompartmentCount, zoneStats.compartmentCount,
                   zoneStats.sweptCompartmentCount,
                   double(preBytes) / bytesPerMiB,
                   counts[STAT_NEW_CHUNK] - counts[STAT_DESTROY_CHUNK],
                   counts[STAT_NEW_CHUNK] + counts[STAT_DESTROY_CHUNK]);
    if (!fragments.append(DuplicateString(buffer)))
        return UniqueChars(nullptr);

    MOZ_ASSERT_IF(counts[STAT_ARENA_RELOCATED], gckind == GC_SHRINK);
    if (gckind == GC_SHRINK) {
        SprintfLiteral(buffer,
                       "Kind: %s; Relocated: %.3f MiB; ",
                       ExplainInvocationKind(gckind),
                       double(ArenaSize * counts[STAT_ARENA_RELOCATED]) / bytesPerMiB);
        if (!fragments.append(DuplicateString(buffer)))
            return UniqueChars(nullptr);
    }

    return Join(fragments);
}

UniqueChars
Statistics::formatCompactSlicePhaseTimes(const PhaseTimeTable& phaseTimes) const
{
    static const TimeDuration MaxUnaccountedTime = TimeDuration::FromMicroseconds(100);

    FragmentVector fragments;
    char buffer[128];
    for (auto phase : AllPhases()) {
        DebugOnly<uint8_t> level = phases[phase].depth;
        MOZ_ASSERT(level < 4);

        TimeDuration ownTime = phaseTimes[phase];
        TimeDuration childTime = SumChildTimes(phase, phaseTimes);
        if (ownTime > MaxUnaccountedTime) {
            SprintfLiteral(buffer, "%s: %.3fms", phases[phase].name, t(ownTime));
            if (!fragments.append(DuplicateString(buffer)))
                return UniqueChars(nullptr);

            if (childTime && (ownTime - childTime) > MaxUnaccountedTime) {
                MOZ_ASSERT(level < 3);
                SprintfLiteral(buffer, "%s: %.3fms", "Other", t(ownTime - childTime));
                if (!fragments.append(DuplicateString(buffer)))
                    return UniqueChars(nullptr);
            }
        }
    }
    return Join(fragments, ", ");
}

UniqueChars
Statistics::formatDetailedMessage() const
{
    FragmentVector fragments;

    if (!fragments.append(formatDetailedDescription()))
        return UniqueChars(nullptr);

    if (!slices_.empty()) {
        for (unsigned i = 0; i < slices_.length(); i++) {
            if (!fragments.append(formatDetailedSliceDescription(i, slices_[i])))
                return UniqueChars(nullptr);
            if (!fragments.append(formatDetailedPhaseTimes(slices_[i].phaseTimes)))
                return UniqueChars(nullptr);
        }
    }
    if (!fragments.append(formatDetailedTotals()))
        return UniqueChars(nullptr);
    if (!fragments.append(formatDetailedPhaseTimes(phaseTimes)))
        return UniqueChars(nullptr);

    return Join(fragments);
}

UniqueChars
Statistics::formatDetailedDescription() const
{
    const double bytesPerMiB = 1024 * 1024;

    TimeDuration sccTotal, sccLongest;
    sccDurations(&sccTotal, &sccLongest);

    const double mmu20 = computeMMU(TimeDuration::FromMilliseconds(20));
    const double mmu50 = computeMMU(TimeDuration::FromMilliseconds(50));

    const char* format =
"=================================================================\n\
  Invocation Kind: %s\n\
  Reason: %s\n\
  Incremental: %s%s\n\
  Zones Collected: %d of %d (-%d)\n\
  Compartments Collected: %d of %d (-%d)\n\
  MinorGCs since last GC: %d\n\
  Store Buffer Overflows: %d\n\
  MMU 20ms:%.1f%%; 50ms:%.1f%%\n\
  SCC Sweep Total (MaxPause): %.3fms (%.3fms)\n\
  HeapSize: %.3f MiB\n\
  Chunk Delta (magnitude): %+d  (%d)\n\
  Arenas Relocated: %.3f MiB\n\
";
    char buffer[1024];
    SprintfLiteral(buffer, format,
                   ExplainInvocationKind(gckind),
                   ExplainReason(slices_[0].reason),
                   nonincremental() ? "no - " : "yes",
                   nonincremental() ? ExplainAbortReason(nonincrementalReason_) : "",
                   zoneStats.collectedZoneCount, zoneStats.zoneCount, zoneStats.sweptZoneCount,
                   zoneStats.collectedCompartmentCount, zoneStats.compartmentCount,
                   zoneStats.sweptCompartmentCount,
                   getCount(STAT_MINOR_GC),
                   getCount(STAT_STOREBUFFER_OVERFLOW),
                   mmu20 * 100., mmu50 * 100.,
                   t(sccTotal), t(sccLongest),
                   double(preBytes) / bytesPerMiB,
                   getCount(STAT_NEW_CHUNK) - getCount(STAT_DESTROY_CHUNK),
                   getCount(STAT_NEW_CHUNK) + getCount(STAT_DESTROY_CHUNK),
                   double(ArenaSize * getCount(STAT_ARENA_RELOCATED)) / bytesPerMiB);
    return DuplicateString(buffer);
}

UniqueChars
Statistics::formatDetailedSliceDescription(unsigned i, const SliceData& slice) const
{
    char budgetDescription[200];
    slice.budget.describe(budgetDescription, sizeof(budgetDescription) - 1);

    const char* format =
"\
  ---- Slice %u ----\n\
    Reason: %s\n\
    Reset: %s%s\n\
    State: %s -> %s\n\
    Page Faults: %ld\n\
    Pause: %.3fms of %s budget (@ %.3fms)\n\
";
    char buffer[1024];
    SprintfLiteral(buffer, format, i, ExplainReason(slice.reason),
                   slice.wasReset() ? "yes - " : "no",
                   slice.wasReset() ? ExplainAbortReason(slice.resetReason) : "",
                   gc::StateName(slice.initialState), gc::StateName(slice.finalState),
                   uint64_t(slice.endFaults - slice.startFaults),
                   t(slice.duration()), budgetDescription, t(slice.start - slices_[0].start));
    return DuplicateString(buffer);
}

UniqueChars
Statistics::formatDetailedPhaseTimes(const PhaseTimeTable& phaseTimes) const
{
    static const TimeDuration MaxUnaccountedChildTime = TimeDuration::FromMicroseconds(50);

    FragmentVector fragments;
    char buffer[128];
    for (auto phase : AllPhases()) {
        uint8_t level = phases[phase].depth;
        TimeDuration ownTime = phaseTimes[phase];
        TimeDuration childTime = SumChildTimes(phase, phaseTimes);
        if (!ownTime.IsZero()) {
            SprintfLiteral(buffer, "      %*s: %.3fms\n",
                           level * 2, phases[phase].name, t(ownTime));
            if (!fragments.append(DuplicateString(buffer)))
                return UniqueChars(nullptr);

            if (childTime && (ownTime - childTime) > MaxUnaccountedChildTime) {
                SprintfLiteral(buffer, "      %*s: %.3fms\n",
                               (level + 1) * 2, "Other", t(ownTime - childTime));
                if (!fragments.append(DuplicateString(buffer)))
                    return UniqueChars(nullptr);
            }
        }
    }
    return Join(fragments);
}

UniqueChars
Statistics::formatDetailedTotals() const
{
    TimeDuration total, longest;
    gcDuration(&total, &longest);

    const char* format =
"\
  ---- Totals ----\n\
    Total Time: %.3fms\n\
    Max Pause: %.3fms\n\
";
    char buffer[1024];
    SprintfLiteral(buffer, format, t(total), t(longest));
    return DuplicateString(buffer);
}

void
Statistics::formatJsonSlice(size_t sliceNum, JSONPrinter& json) const
{
    json.beginObject();
    formatJsonSliceDescription(sliceNum, slices_[sliceNum], json);

    json.beginObjectProperty("times");
    formatJsonPhaseTimes(slices_[sliceNum].phaseTimes, json);
    json.endObject();

    json.endObject();
}

UniqueChars
Statistics::renderJsonSlice(size_t sliceNum) const
{
    Sprinter printer(nullptr, false);
    if (!printer.init())
        return UniqueChars(nullptr);
    JSONPrinter json(printer);

    formatJsonSlice(sliceNum, json);
    return UniqueChars(printer.release());
}

UniqueChars
Statistics::renderNurseryJson(JSRuntime* rt) const
{
    Sprinter printer(nullptr, false);
    if (!printer.init())
        return UniqueChars(nullptr);
    JSONPrinter json(printer);
    rt->gc.nursery().renderProfileJSON(json);
    return UniqueChars(printer.release());
}

UniqueChars
Statistics::renderJsonMessage(uint64_t timestamp, bool includeSlices) const
{
    if (aborted)
        return DuplicateString("{status:\"aborted\"}"); // May return nullptr

    Sprinter printer(nullptr, false);
    if (!printer.init())
        return UniqueChars(nullptr);
    JSONPrinter json(printer);

    json.beginObject();
    formatJsonDescription(timestamp, json);

    if (includeSlices) {
        json.beginListProperty("slices");
        for (unsigned i = 0; i < slices_.length(); i++)
            formatJsonSlice(i, json);
        json.endList();
    }

    json.beginObjectProperty("totals");
    formatJsonPhaseTimes(phaseTimes, json);
    json.endObject();

    json.endObject();

    return UniqueChars(printer.release());
}

void
Statistics::formatJsonDescription(uint64_t timestamp, JSONPrinter& json) const
{
    json.property("timestamp", timestamp);

    TimeDuration total, longest;
    gcDuration(&total, &longest);
    json.property("max_pause", longest, JSONPrinter::MILLISECONDS);
    json.property("total_time", total, JSONPrinter::MILLISECONDS);

    json.property("reason", ExplainReason(slices_[0].reason));
    json.property("zones_collected", zoneStats.collectedZoneCount);
    json.property("total_zones", zoneStats.zoneCount);
    json.property("total_compartments", zoneStats.compartmentCount);
    json.property("minor_gcs", counts[STAT_MINOR_GC]);
    json.property("store_buffer_overflows", counts[STAT_STOREBUFFER_OVERFLOW]);
    json.property("slices", slices_.length());

    const double mmu20 = computeMMU(TimeDuration::FromMilliseconds(20));
    const double mmu50 = computeMMU(TimeDuration::FromMilliseconds(50));
    json.property("mmu_20ms", int(mmu20 * 100));
    json.property("mmu_50ms", int(mmu50 * 100));

    TimeDuration sccTotal, sccLongest;
    sccDurations(&sccTotal, &sccLongest);
    json.property("scc_sweep_total", sccTotal, JSONPrinter::MILLISECONDS);
    json.property("scc_sweep_max_pause", sccLongest, JSONPrinter::MILLISECONDS);

    json.property("nonincremental_reason", ExplainAbortReason(nonincrementalReason_));
    json.property("allocated", uint64_t(preBytes) / 1024 / 1024);
    json.property("added_chunks", getCount(STAT_NEW_CHUNK));
    json.property("removed_chunks", getCount(STAT_DESTROY_CHUNK));
    json.property("major_gc_number", startingMajorGCNumber);
    json.property("minor_gc_number", startingMinorGCNumber);
}

void
Statistics::formatJsonSliceDescription(unsigned i, const SliceData& slice, JSONPrinter& json) const
{
    TimeDuration when = slice.start - slices_[0].start;
    char budgetDescription[200];
    slice.budget.describe(budgetDescription, sizeof(budgetDescription) - 1);
    TimeStamp originTime = TimeStamp::ProcessCreation();

    json.property("slice", i);
    json.property("pause", slice.duration(), JSONPrinter::MILLISECONDS);
    json.property("when", when, JSONPrinter::MILLISECONDS);
    json.property("reason", ExplainReason(slice.reason));
    json.property("initial_state", gc::StateName(slice.initialState));
    json.property("final_state", gc::StateName(slice.finalState));
    json.property("budget", budgetDescription);
    json.property("page_faults", int64_t(slice.endFaults - slice.startFaults));
    json.property("start_timestamp", slice.start - originTime, JSONPrinter::SECONDS);
    json.property("end_timestamp", slice.end - originTime, JSONPrinter::SECONDS);
}

void
Statistics::formatJsonPhaseTimes(const PhaseTimeTable& phaseTimes, JSONPrinter& json) const
{
    for (auto phase : AllPhases()) {
        TimeDuration ownTime = phaseTimes[phase];
        if (!ownTime.IsZero())
            json.property(phases[phase].path, ownTime, JSONPrinter::MILLISECONDS);
    }
}

Statistics::Statistics(JSRuntime* rt)
  : runtime(rt),
    fp(nullptr),
    nonincrementalReason_(gc::AbortReason::None),
    preBytes(0),
    maxPauseInInterval(0),
    sliceCallback(nullptr),
    nurseryCollectionCallback(nullptr),
    aborted(false),
    enableProfiling_(false),
    sliceCount_(0)
{
    for (auto& count : counts)
        count = 0;
    PodZero(&totalTimes_);

    MOZ_ALWAYS_TRUE(phaseStack.reserve(MAX_PHASE_NESTING));
    MOZ_ALWAYS_TRUE(suspendedPhases.reserve(MAX_SUSPENDED_PHASES));

    const char* env = getenv("MOZ_GCTIMER");
    if (env) {
        if (strcmp(env, "none") == 0) {
            fp = nullptr;
        } else if (strcmp(env, "stdout") == 0) {
            fp = stdout;
        } else if (strcmp(env, "stderr") == 0) {
            fp = stderr;
        } else {
            fp = fopen(env, "a");
            if (!fp)
                MOZ_CRASH("Failed to open MOZ_GCTIMER log file.");
        }
    }

    env = getenv("JS_GC_PROFILE");
    if (env) {
        if (0 == strcmp(env, "help")) {
            fprintf(stderr, "JS_GC_PROFILE=N\n"
                    "\tReport major GC's taking more than N milliseconds.\n");
            exit(0);
        }
        enableProfiling_ = true;
        profileThreshold_ = TimeDuration::FromMilliseconds(atoi(env));
    }
}

Statistics::~Statistics()
{
    if (fp && fp != stdout && fp != stderr)
        fclose(fp);
}

/* static */ bool
Statistics::initialize()
{
#ifdef DEBUG
    // Sanity check generated tables.
    for (auto i : AllPhases()) {
        auto parent = phases[i].parent;
        if (parent != Phase::NONE) {
            MOZ_ASSERT(phases[i].depth == phases[parent].depth + 1);
        }
        auto firstChild = phases[i].firstChild;
        if (firstChild != Phase::NONE) {
            MOZ_ASSERT(i == phases[firstChild].parent);
            MOZ_ASSERT(phases[i].depth == phases[firstChild].depth - 1);
        }
        auto nextSibling = phases[i].nextSibling;
        if (nextSibling != Phase::NONE) {
            MOZ_ASSERT(parent == phases[nextSibling].parent);
            MOZ_ASSERT(phases[i].depth == phases[nextSibling].depth);
        }
        auto nextInPhase = phases[i].nextInPhase;
        if (nextInPhase != Phase::NONE) {
            MOZ_ASSERT(phases[i].phaseKind == phases[nextInPhase].phaseKind);
            MOZ_ASSERT(parent != phases[nextInPhase].parent);
        }
    }
    for (auto i : AllPhaseKinds()) {
        MOZ_ASSERT(phases[phaseKinds[i].firstPhase].phaseKind == i);
        for (auto j : AllPhaseKinds()) {
            MOZ_ASSERT_IF(i != j,
                          phaseKinds[i].telemetryBucket != phaseKinds[j].telemetryBucket);
        }
    }
#endif

    return true;
}

JS::GCSliceCallback
Statistics::setSliceCallback(JS::GCSliceCallback newCallback)
{
    JS::GCSliceCallback oldCallback = sliceCallback;
    sliceCallback = newCallback;
    return oldCallback;
}

JS::GCNurseryCollectionCallback
Statistics::setNurseryCollectionCallback(JS::GCNurseryCollectionCallback newCallback)
{
    auto oldCallback = nurseryCollectionCallback;
    nurseryCollectionCallback = newCallback;
    return oldCallback;
}

TimeDuration
Statistics::clearMaxGCPauseAccumulator()
{
    TimeDuration prior = maxPauseInInterval;
    maxPauseInInterval = 0;
    return prior;
}

TimeDuration
Statistics::getMaxGCPauseSinceClear()
{
    return maxPauseInInterval;
}

// Sum up the time for a phase, including instances of the phase with different
// parents.
static TimeDuration
SumPhase(PhaseKind phaseKind, const Statistics::PhaseTimeTable& times)
{
    TimeDuration sum = 0;
    for (Phase phase = phaseKinds[phaseKind].firstPhase;
         phase != Phase::NONE;
         phase = phases[phase].nextInPhase)
    {
        sum += times[phase];
    }
    return sum;
}

static void
CheckSelfTime(Phase parent,
              Phase child,
              const Statistics::PhaseTimeTable& times,
              const Statistics::PhaseTimeTable& selfTimes,
              TimeDuration childTime)
{
    if (selfTimes[parent] < childTime) {
        fprintf(stderr,
                "Parent %s time = %.3fms with %.3fms remaining, child %s time %.3fms\n",
                phases[parent].name,
                times[parent].ToMilliseconds(),
                selfTimes[parent].ToMilliseconds(),
                phases[child].name,
                childTime.ToMilliseconds());
        fflush(stderr);
        MOZ_CRASH();
    }
}

static PhaseKind
LongestPhaseSelfTime(const Statistics::PhaseTimeTable& times)
{
    // Start with total times per expanded phase, including children's times.
    Statistics::PhaseTimeTable selfTimes(times);

    // We have the total time spent in each phase, including descendant times.
    // Loop over the children and subtract their times from their parent's self
    // time.
    for (auto i : AllPhases()) {
        Phase parent = phases[i].parent;
        if (parent != Phase::NONE) {
            CheckSelfTime(parent, i, times, selfTimes, times[i]);
            selfTimes[parent] -= times[i];
        }
    }

    // Sum expanded phases corresponding to the same phase.
    EnumeratedArray<PhaseKind, PhaseKind::LIMIT, TimeDuration> phaseTimes;
    for (auto i : AllPhaseKinds())
        phaseTimes[i] = SumPhase(i, selfTimes);

    // Loop over this table to find the longest phase.
    TimeDuration longestTime = 0;
    PhaseKind longestPhase = PhaseKind::NONE;
    for (auto i : AllPhaseKinds()) {
        if (phaseTimes[i] > longestTime) {
            longestTime = phaseTimes[i];
            longestPhase = i;
        }
    }

    return longestPhase;
}

void
Statistics::printStats()
{
    if (aborted) {
        fprintf(fp, "OOM during GC statistics collection. The report is unavailable for this GC.\n");
    } else {
        UniqueChars msg = formatDetailedMessage();
        if (msg) {
            double secSinceStart =
                (slices_[0].start - TimeStamp::ProcessCreation()).ToSeconds();
            fprintf(fp, "GC(T+%.3fs) %s\n", secSinceStart, msg.get());
        }
    }
    fflush(fp);
}

void
Statistics::beginGC(JSGCInvocationKind kind)
{
    slices_.clearAndFree();
    sccTimes.clearAndFree();
    gckind = kind;
    nonincrementalReason_ = gc::AbortReason::None;

    preBytes = runtime->gc.usage.gcBytes();
    startingMajorGCNumber = runtime->gc.majorGCCount();
}

void
Statistics::endGC()
{
    TimeDuration sccTotal, sccLongest;
    sccDurations(&sccTotal, &sccLongest);

    runtime->addTelemetry(JS_TELEMETRY_GC_IS_ZONE_GC, !zoneStats.isCollectingAllZones());
    TimeDuration markTotal = SumPhase(PhaseKind::MARK, phaseTimes);
    TimeDuration markRootsTotal = SumPhase(PhaseKind::MARK_ROOTS, phaseTimes);
    runtime->addTelemetry(JS_TELEMETRY_GC_MARK_MS, t(markTotal));
    runtime->addTelemetry(JS_TELEMETRY_GC_SWEEP_MS, t(phaseTimes[Phase::SWEEP]));
    if (runtime->gc.isCompactingGc()) {
        runtime->addTelemetry(JS_TELEMETRY_GC_COMPACT_MS,
                              t(phaseTimes[Phase::COMPACT]));
    }
    runtime->addTelemetry(JS_TELEMETRY_GC_MARK_ROOTS_MS, t(markRootsTotal));
    runtime->addTelemetry(JS_TELEMETRY_GC_MARK_GRAY_MS, t(phaseTimes[Phase::SWEEP_MARK_GRAY]));
    runtime->addTelemetry(JS_TELEMETRY_GC_NON_INCREMENTAL, nonincremental());
    if (nonincremental())
        runtime->addTelemetry(JS_TELEMETRY_GC_NON_INCREMENTAL_REASON, uint32_t(nonincrementalReason_));
    runtime->addTelemetry(JS_TELEMETRY_GC_INCREMENTAL_DISABLED, !runtime->gc.isIncrementalGCAllowed());
    runtime->addTelemetry(JS_TELEMETRY_GC_SCC_SWEEP_TOTAL_MS, t(sccTotal));
    runtime->addTelemetry(JS_TELEMETRY_GC_SCC_SWEEP_MAX_PAUSE_MS, t(sccLongest));

    if (!aborted) {
        TimeDuration total, longest;
        gcDuration(&total, &longest);

        runtime->addTelemetry(JS_TELEMETRY_GC_MS, t(total));
        runtime->addTelemetry(JS_TELEMETRY_GC_MAX_PAUSE_MS, t(longest));
        runtime->addTelemetry(JS_TELEMETRY_GC_MAX_PAUSE_MS_2, t(longest));

        const double mmu50 = computeMMU(TimeDuration::FromMilliseconds(50));
        runtime->addTelemetry(JS_TELEMETRY_GC_MMU_50, mmu50 * 100);
    }

    if (fp)
        printStats();

    // Clear the OOM flag.
    aborted = false;
}

void
Statistics::beginNurseryCollection(JS::gcreason::Reason reason)
{
    count(STAT_MINOR_GC);
    startingMinorGCNumber = runtime->gc.minorGCCount();
    if (nurseryCollectionCallback) {
        (*nurseryCollectionCallback)(TlsContext.get(),
                                     JS::GCNurseryProgress::GC_NURSERY_COLLECTION_START,
                                     reason);
    }
}

void
Statistics::endNurseryCollection(JS::gcreason::Reason reason)
{
    if (nurseryCollectionCallback) {
        (*nurseryCollectionCallback)(TlsContext.get(),
                                     JS::GCNurseryProgress::GC_NURSERY_COLLECTION_END,
                                     reason);
    }
}

void
Statistics::beginSlice(const ZoneGCStats& zoneStats, JSGCInvocationKind gckind,
                       SliceBudget budget, JS::gcreason::Reason reason)
{
    this->zoneStats = zoneStats;

    bool first = !runtime->gc.isIncrementalGCInProgress();
    if (first)
        beginGC(gckind);

    if (!slices_.emplaceBack(budget,
                             reason,
                             TimeStamp::Now(),
                             GetPageFaultCount(),
                             runtime->gc.state()))
    {
        // If we are OOM, set a flag to indicate we have missing slice data.
        aborted = true;
        return;
    }

    runtime->addTelemetry(JS_TELEMETRY_GC_REASON, reason);

    // Slice callbacks should only fire for the outermost level.
    bool wasFullGC = zoneStats.isCollectingAllZones();
    if (sliceCallback) {
        JSContext* cx = TlsContext.get();
        JS::GCDescription desc(!wasFullGC, false, gckind, reason);
        if (first)
            (*sliceCallback)(cx, JS::GC_CYCLE_BEGIN, desc);
        (*sliceCallback)(cx, JS::GC_SLICE_BEGIN, desc);
    }
}

void
Statistics::endSlice()
{
    if (!aborted) {
        auto& slice = slices_.back();
        slice.end = TimeStamp::Now();
        slice.endFaults = GetPageFaultCount();
        slice.finalState = runtime->gc.state();

        TimeDuration sliceTime = slice.end - slice.start;
        runtime->addTelemetry(JS_TELEMETRY_GC_SLICE_MS, t(sliceTime));
        runtime->addTelemetry(JS_TELEMETRY_GC_RESET, slice.wasReset());
        if (slice.wasReset())
            runtime->addTelemetry(JS_TELEMETRY_GC_RESET_REASON, uint32_t(slice.resetReason));

        if (slice.budget.isTimeBudget()) {
            int64_t budget_ms = slice.budget.timeBudget.budget;
            runtime->addTelemetry(JS_TELEMETRY_GC_BUDGET_MS, budget_ms);
            if (budget_ms == runtime->gc.defaultSliceBudget())
                runtime->addTelemetry(JS_TELEMETRY_GC_ANIMATION_MS, t(sliceTime));

            // Record any phase that goes more than 2x over its budget.
            if (sliceTime.ToMilliseconds() > 2 * budget_ms) {
                reportLongestPhase(slice.phaseTimes, JS_TELEMETRY_GC_SLOW_PHASE);
                // If we spend a significant length of time waiting for parallel
                // tasks then report the longest task.
                TimeDuration joinTime = SumPhase(PhaseKind::JOIN_PARALLEL_TASKS, slice.phaseTimes);
                if (joinTime.ToMilliseconds() > budget_ms)
                    reportLongestPhase(slice.parallelTimes, JS_TELEMETRY_GC_SLOW_TASK);
            }
        }

        sliceCount_++;
    }

    bool last = !runtime->gc.isIncrementalGCInProgress();
    if (last)
        endGC();

    if (enableProfiling_ && !aborted && slices_.back().duration() >= profileThreshold_)
        printSliceProfile();

    // Slice callbacks should only fire for the outermost level.
    if (!aborted) {
        bool wasFullGC = zoneStats.isCollectingAllZones();
        if (sliceCallback) {
            JSContext* cx = TlsContext.get();
            JS::GCDescription desc(!wasFullGC, last, gckind, slices_.back().reason);
            (*sliceCallback)(cx, JS::GC_SLICE_END, desc);
            if (last)
                (*sliceCallback)(cx, JS::GC_CYCLE_END, desc);
        }
    }

    // Do this after the slice callback since it uses these values.
    if (last) {
        for (auto& count : counts)
            count = 0;

        // Clear the timers at the end of a GC, preserving the data for PhaseKind::MUTATOR.
        auto mutatorStartTime = phaseStartTimes[Phase::MUTATOR];
        auto mutatorTime = phaseTimes[Phase::MUTATOR];
        PodZero(&phaseStartTimes);
        PodZero(&phaseTimes);
        phaseStartTimes[Phase::MUTATOR] = mutatorStartTime;
        phaseTimes[Phase::MUTATOR] = mutatorTime;
    }
}

void
Statistics::reportLongestPhase(const PhaseTimeTable& times, int telemetryId)
{
    PhaseKind longest = LongestPhaseSelfTime(times);
    if (longest == PhaseKind::NONE)
        return;

    uint8_t bucket = phaseKinds[longest].telemetryBucket;
    runtime->addTelemetry(telemetryId, bucket);
}

bool
Statistics::startTimingMutator()
{
    if (phaseStack.length() != 0) {
        // Should only be called from outside of GC.
        MOZ_ASSERT(phaseStack.length() == 1);
        MOZ_ASSERT(phaseStack[0] == Phase::MUTATOR);
        return false;
    }

    MOZ_ASSERT(suspendedPhases.empty());

    timedGCTime = 0;
    phaseStartTimes[Phase::MUTATOR] = TimeStamp();
    phaseTimes[Phase::MUTATOR] = 0;
    timedGCStart = TimeStamp();

    beginPhase(PhaseKind::MUTATOR);
    return true;
}

bool
Statistics::stopTimingMutator(double& mutator_ms, double& gc_ms)
{
    // This should only be called from outside of GC, while timing the mutator.
    if (phaseStack.length() != 1 || phaseStack[0] != Phase::MUTATOR)
        return false;

    endPhase(PhaseKind::MUTATOR);
    mutator_ms = t(phaseTimes[Phase::MUTATOR]);
    gc_ms = t(timedGCTime);

    return true;
}

void
Statistics::suspendPhases(PhaseKind suspension)
{
    MOZ_ASSERT(suspension == PhaseKind::EXPLICIT_SUSPENSION ||
               suspension == PhaseKind::IMPLICIT_SUSPENSION);
    while (!phaseStack.empty()) {
        MOZ_ASSERT(suspendedPhases.length() < MAX_SUSPENDED_PHASES);
        Phase parent = phaseStack.back();
        suspendedPhases.infallibleAppend(parent);
        recordPhaseEnd(parent);
    }
    suspendedPhases.infallibleAppend(lookupChildPhase(suspension));
}

void
Statistics::resumePhases()
{
    MOZ_ASSERT(suspendedPhases.back() == Phase::EXPLICIT_SUSPENSION ||
               suspendedPhases.back() == Phase::IMPLICIT_SUSPENSION);
    suspendedPhases.popBack();

    while (!suspendedPhases.empty() &&
           suspendedPhases.back() != Phase::EXPLICIT_SUSPENSION &&
           suspendedPhases.back() != Phase::IMPLICIT_SUSPENSION)
    {
        Phase resumePhase = suspendedPhases.popCopy();
        if (resumePhase == Phase::MUTATOR)
            timedGCTime += TimeStamp::Now() - timedGCStart;
        recordPhaseBegin(resumePhase);
    }
}

void
Statistics::beginPhase(PhaseKind phaseKind)
{
    // No longer timing these phases. We should never see these.
    MOZ_ASSERT(phaseKind != PhaseKind::GC_BEGIN && phaseKind != PhaseKind::GC_END);

    // PhaseKind::MUTATOR is suspended while performing GC.
    if (currentPhase() == Phase::MUTATOR)
        suspendPhases(PhaseKind::IMPLICIT_SUSPENSION);

    recordPhaseBegin(lookupChildPhase(phaseKind));
}

void
Statistics::recordPhaseBegin(Phase phase)
{
    // Guard against any other re-entry.
    MOZ_ASSERT(!phaseStartTimes[phase]);

    MOZ_ASSERT(phaseStack.length() < MAX_PHASE_NESTING);
    MOZ_ASSERT(phases[phase].parent == currentPhase());

    phaseStack.infallibleAppend(phase);
    phaseStartTimes[phase] = TimeStamp::Now();
}

void
Statistics::recordPhaseEnd(Phase phase)
{
    TimeStamp now = TimeStamp::Now();

    if (phase == Phase::MUTATOR)
        timedGCStart = now;

    phaseStack.popBack();

    TimeDuration t = now - phaseStartTimes[phase];
    if (!slices_.empty())
        slices_.back().phaseTimes[phase] += t;
    phaseTimes[phase] += t;
    phaseStartTimes[phase] = TimeStamp();
}

void
Statistics::endPhase(PhaseKind phaseKind)
{
    Phase phase = currentPhase();
    MOZ_ASSERT(phase != Phase::NONE);
    MOZ_ASSERT(phases[phase].phaseKind == phaseKind);

    recordPhaseEnd(phase);

    // When emptying the stack, we may need to return to timing the mutator
    // (PhaseKind::MUTATOR).
    if (phaseStack.empty() &&
        !suspendedPhases.empty() &&
        suspendedPhases.back() == Phase::IMPLICIT_SUSPENSION)
    {
        resumePhases();
    }
}

void
Statistics::recordParallelPhase(PhaseKind phaseKind, TimeDuration duration)
{
    Phase phase = lookupChildPhase(phaseKind);

    // Record the duration for all phases in the tree up to the root. This is
    // not strictly necessary but makes the invariant that parent phase times
    // include their children apply to both phaseTimes and parallelTimes.
    while (phase != Phase::NONE) {
        if (!slices_.empty())
            slices_.back().parallelTimes[phase] += duration;
        parallelTimes[phase] += duration;
        phase = phases[phase].parent;
    }
}

void
Statistics::endParallelPhase(PhaseKind phaseKind, const GCParallelTask* task)
{
    Phase phase = lookupChildPhase(phaseKind);
    phaseStack.popBack();

    if (!slices_.empty())
        slices_.back().phaseTimes[phase] += task->duration();
    phaseTimes[phase] += task->duration();
    phaseStartTimes[phase] = TimeStamp();
}

TimeStamp
Statistics::beginSCC()
{
    return TimeStamp::Now();
}

void
Statistics::endSCC(unsigned scc, TimeStamp start)
{
    if (scc >= sccTimes.length() && !sccTimes.resize(scc + 1))
        return;

    sccTimes[scc] += TimeStamp::Now() - start;
}

/*
 * MMU (minimum mutator utilization) is a measure of how much garbage collection
 * is affecting the responsiveness of the system. MMU measurements are given
 * with respect to a certain window size. If we report MMU(50ms) = 80%, then
 * that means that, for any 50ms window of time, at least 80% of the window is
 * devoted to the mutator. In other words, the GC is running for at most 20% of
 * the window, or 10ms. The GC can run multiple slices during the 50ms window
 * as long as the total time it spends is at most 10ms.
 */
double
Statistics::computeMMU(TimeDuration window) const
{
    MOZ_ASSERT(!slices_.empty());

    TimeDuration gc = slices_[0].end - slices_[0].start;
    TimeDuration gcMax = gc;

    if (gc >= window)
        return 0.0;

    int startIndex = 0;
    for (size_t endIndex = 1; endIndex < slices_.length(); endIndex++) {
        auto* startSlice = &slices_[startIndex];
        auto& endSlice = slices_[endIndex];
        gc += endSlice.end - endSlice.start;

        while (endSlice.end - startSlice->end >= window) {
            gc -= startSlice->end - startSlice->start;
            startSlice = &slices_[++startIndex];
        }

        TimeDuration cur = gc;
        if (endSlice.end - startSlice->start > window)
            cur -= (endSlice.end - startSlice->start - window);
        if (cur > gcMax)
            gcMax = cur;
    }

    return double((window - gcMax) / window);
}

void
Statistics::maybePrintProfileHeaders()
{
    static int printedHeader = 0;
    if ((printedHeader++ % 200) == 0) {
        printProfileHeader();
        for (ZoneGroupsIter group(runtime); !group.done(); group.next()) {
            if (group->nursery().enableProfiling()) {
                Nursery::printProfileHeader();
                break;
            }
        }
    }
}

void
Statistics::printProfileHeader()
{
    if (!enableProfiling_)
        return;

    fprintf(stderr, "MajorGC:               Reason States      ");
    fprintf(stderr, " %6s", "total");
#define PRINT_PROFILE_HEADER(name, text, phase)                               \
    fprintf(stderr, " %6s", text);
FOR_EACH_GC_PROFILE_TIME(PRINT_PROFILE_HEADER)
#undef PRINT_PROFILE_HEADER
    fprintf(stderr, "\n");
}

/* static */ void
Statistics::printProfileTimes(const ProfileDurations& times)
{
    for (auto time : times)
        fprintf(stderr, " %6" PRIi64, static_cast<int64_t>(time.ToMilliseconds()));
    fprintf(stderr, "\n");
}

void
Statistics::printSliceProfile()
{
    const SliceData& slice = slices_.back();

    maybePrintProfileHeaders();

    fprintf(stderr, "MajorGC: %20s %1d -> %1d      ",
            ExplainReason(slice.reason), int(slice.initialState), int(slice.finalState));

    ProfileDurations times;
    times[ProfileKey::Total] = slice.duration();
    totalTimes_[ProfileKey::Total] += times[ProfileKey::Total];

#define GET_PROFILE_TIME(name, text, phase)                                   \
    times[ProfileKey::name] = SumPhase(phase, slice.phaseTimes);              \
    totalTimes_[ProfileKey::name] += times[ProfileKey::name];
FOR_EACH_GC_PROFILE_TIME(GET_PROFILE_TIME)
#undef GET_PROFILE_TIME

    printProfileTimes(times);
}

void
Statistics::printTotalProfileTimes()
{
    if (enableProfiling_) {
        fprintf(stderr, "MajorGC TOTALS: %7" PRIu64 " slices:           ", sliceCount_);
        printProfileTimes(totalTimes_);
    }
}

