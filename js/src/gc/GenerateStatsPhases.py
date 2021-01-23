# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# flake8: noqa: F821

# Generate graph structures for GC statistics recording.
#
# Stats phases are nested and form a directed acyclic graph starting
# from a set of root phases. Importantly, a phase may appear under more
# than one parent phase.
#
# For example, the following arrangement is possible:
#
#            +---+
#            | A |
#            +---+
#              |
#      +-------+-------+
#      |       |       |
#      v       v       v
#    +---+   +---+   +---+
#    | B |   | C |   | D |
#    +---+   +---+   +---+
#              |       |
#              +---+---+
#                  |
#                  v
#                +---+
#                | E |
#                +---+
#
# This graph is expanded into a tree (or really a forest) and phases
# with multiple parents are duplicated.
#
# For example, the input example above would be expanded to:
#
#            +---+
#            | A |
#            +---+
#              |
#      +-------+-------+
#      |       |       |
#      v       v       v
#    +---+   +---+   +---+
#    | B |   | C |   | D |
#    +---+   +---+   +---+
#              |       |
#              v       v
#            +---+   +---+
#            | E |   | E'|
#            +---+   +---+

# NOTE: If you add new phases here the current next phase kind number can be
# found at the end of js/src/gc/StatsPhasesGenerated.inc
# You must also update
# toolkit/components/telemetry/other/GCTelemetry.jsm and
# toolkit/components/telemetry/tests/browser/browser_TelemetryGC.js

import re
import collections


class PhaseKind():
    def __init__(self, name, descr, bucket, children=[]):
        self.name = name
        self.descr = descr
        # For telemetry
        self.bucket = bucket
        self.children = children


# The root marking phase appears in several places in the graph.
MarkRootsPhaseKind = PhaseKind("MARK_ROOTS", "Mark Roots", 48, [
    PhaseKind("MARK_CCWS", "Mark Cross Compartment Wrappers", 50),
    PhaseKind("MARK_STACK", "Mark C and JS stacks", 51),
    PhaseKind("MARK_RUNTIME_DATA", "Mark Runtime-wide Data", 52),
    PhaseKind("MARK_EMBEDDING", "Mark Embedding", 53),
    PhaseKind("MARK_COMPARTMENTS", "Mark Compartments", 54)
])

JoinParallelTasksPhaseKind = PhaseKind("JOIN_PARALLEL_TASKS", "Join Parallel Tasks", 67)

PhaseKindGraphRoots = [
    PhaseKind("MUTATOR", "Mutator Running", 0),
    PhaseKind("GC_BEGIN", "Begin Callback", 1),
    PhaseKind("EVICT_NURSERY_FOR_MAJOR_GC", "Evict Nursery For Major GC", 70, [
        MarkRootsPhaseKind,
    ]),
    PhaseKind("WAIT_BACKGROUND_THREAD", "Wait Background Thread", 2),
    PhaseKind("PREPARE", "Prepare For Collection", 69, [
        PhaseKind("UNMARK", "Unmark", 7),
        PhaseKind("UNMARK_WEAKMAPS", "Unmark WeakMaps", 76),
        PhaseKind("BUFFER_GRAY_ROOTS", "Buffer Gray Roots", 49),
        PhaseKind("MARK_DISCARD_CODE", "Mark Discard Code", 3),
        PhaseKind("RELAZIFY_FUNCTIONS", "Relazify Functions", 4),
        PhaseKind("PURGE", "Purge", 5),
        PhaseKind("PURGE_SHAPE_CACHES", "Purge ShapeCaches", 60),
        PhaseKind("PURGE_SOURCE_URLS", "Purge Source URLs", 73),
        JoinParallelTasksPhaseKind
    ]),
    PhaseKind("MARK", "Mark", 6, [
        MarkRootsPhaseKind,
        PhaseKind("MARK_DELAYED", "Mark Delayed", 8)
    ]),
    PhaseKind("SWEEP", "Sweep", 9, [
        PhaseKind("SWEEP_MARK", "Mark During Sweeping", 10, [
            PhaseKind("SWEEP_MARK_INCOMING_BLACK", "Mark Incoming Black Pointers", 12),
            PhaseKind("SWEEP_MARK_WEAK", "Mark Weak", 13, [
                PhaseKind("SWEEP_MARK_GRAY_WEAK", "Mark Gray and Weak", 16)
            ]),
            PhaseKind("SWEEP_MARK_INCOMING_GRAY", "Mark Incoming Gray Pointers", 14),
            PhaseKind("SWEEP_MARK_GRAY", "Mark Gray", 15),
        ]),
        PhaseKind("FINALIZE_START", "Finalize Start Callbacks", 17, [
            PhaseKind("WEAK_ZONES_CALLBACK", "Per-Slice Weak Callback", 57),
            PhaseKind("WEAK_COMPARTMENT_CALLBACK", "Per-Compartment Weak Callback", 58)
        ]),
        PhaseKind("UPDATE_ATOMS_BITMAP", "Sweep Atoms Bitmap", 68),
        PhaseKind("SWEEP_ATOMS_TABLE", "Sweep Atoms Table", 18),
        PhaseKind("SWEEP_COMPARTMENTS", "Sweep Compartments", 20, [
            PhaseKind("SWEEP_DISCARD_CODE", "Sweep Discard Code", 21),
            PhaseKind("SWEEP_INNER_VIEWS", "Sweep Inner Views", 22),
            PhaseKind("SWEEP_CC_WRAPPER", "Sweep Cross Compartment Wrappers", 23),
            PhaseKind("SWEEP_BASE_SHAPE", "Sweep Base Shapes", 24),
            PhaseKind("SWEEP_INITIAL_SHAPE", "Sweep Initial Shapes", 25),
            PhaseKind("SWEEP_TYPE_OBJECT", "Sweep Type Objects", 26),
            PhaseKind("SWEEP_REGEXP", "Sweep Regexps", 28),
            PhaseKind("SWEEP_COMPRESSION", "Sweep Compression Tasks", 62),
            PhaseKind("SWEEP_WEAKMAPS", "Sweep WeakMaps", 63),
            PhaseKind("SWEEP_UNIQUEIDS", "Sweep Unique IDs", 64),
            PhaseKind("SWEEP_FINALIZATION_REGISTRIES", "Sweep FinalizationRegistries", 74),
            PhaseKind("SWEEP_WEAKREFS", "Sweep WeakRefs", 75),
            PhaseKind("SWEEP_JIT_DATA", "Sweep JIT Data", 65),
            PhaseKind("SWEEP_WEAK_CACHES", "Sweep Weak Caches", 66),
            PhaseKind("SWEEP_MISC", "Sweep Miscellaneous", 29),
            PhaseKind("SWEEP_TYPES", "Sweep type information", 30, [
                PhaseKind("SWEEP_TYPES_BEGIN", "Sweep type tables and compilations", 31),
                PhaseKind("SWEEP_TYPES_END", "Free type arena", 32),
            ]),
            JoinParallelTasksPhaseKind
        ]),
        PhaseKind("SWEEP_OBJECT", "Sweep Object", 33),
        PhaseKind("SWEEP_STRING", "Sweep String", 34),
        PhaseKind("SWEEP_SCRIPT", "Sweep Script", 35),
        PhaseKind("SWEEP_SCOPE", "Sweep Scope", 59),
        PhaseKind("SWEEP_REGEXP_SHARED", "Sweep RegExpShared", 61),
        PhaseKind("SWEEP_SHAPE", "Sweep Shape", 36),
        PhaseKind("FINALIZE_END", "Finalize End Callback", 38),
        PhaseKind("DESTROY", "Deallocate", 39),
        JoinParallelTasksPhaseKind
    ]),
    PhaseKind("COMPACT", "Compact", 40, [
        PhaseKind("COMPACT_MOVE", "Compact Move", 41),
        PhaseKind("COMPACT_UPDATE", "Compact Update", 42, [
            MarkRootsPhaseKind,
            PhaseKind("COMPACT_UPDATE_CELLS", "Compact Update Cells", 43),
            JoinParallelTasksPhaseKind
        ]),
    ]),
    PhaseKind("DECOMMIT", "Decommit", 72),
    PhaseKind("GC_END", "End Callback", 44),
    PhaseKind("MINOR_GC", "All Minor GCs", 45, [
        MarkRootsPhaseKind,
    ]),
    PhaseKind("EVICT_NURSERY", "Minor GCs to Evict Nursery", 46, [
        MarkRootsPhaseKind,
    ]),
    PhaseKind("TRACE_HEAP", "Trace Heap", 47, [
        MarkRootsPhaseKind,
    ]),
    PhaseKind("BARRIER", "Barriers", 55, [
        PhaseKind("UNMARK_GRAY", "Unmark gray", 56)
    ])
]


def findAllPhaseKinds():
    # Make a linear list of all unique phases by performing a depth first
    # search on the phase graph starting at the roots.  This will be used to
    # generate the PhaseKind enum.
    phases = []
    seen = set()

    def dfs(phase):
        if phase in seen:
            return
        phases.append(phase)
        seen.add(phase)
        for child in phase.children:
            dfs(child)

    for phase in PhaseKindGraphRoots:
        dfs(phase)
    return phases


AllPhaseKinds = findAllPhaseKinds()


class Phase:
    # Expand the DAG into a tree, duplicating phases which have more than
    # one parent.
    def __init__(self, phaseKind, parent):
        self.phaseKind = phaseKind
        self.parent = parent
        self.depth = parent.depth + 1 if parent else 0
        self.children = []
        self.nextSibling = None
        self.nextInPhaseKind = None

        self.path = re.sub(r'\W+', '_', phaseKind.name.lower())
        if parent is not None:
            self.path = parent.path + '.' + self.path


def expandPhases():
    phases = []
    phasesForKind = collections.defaultdict(list)

    def traverse(phaseKind, parent):
        ep = Phase(phaseKind, parent)
        phases.append(ep)

        # Update list of expanded phases for this phase kind.
        if phasesForKind[phaseKind]:
            phasesForKind[phaseKind][-1].nextInPhaseKind = ep
        phasesForKind[phaseKind].append(ep)

        # Recurse over children.
        for child in phaseKind.children:
            child_ep = traverse(child, ep)
            if ep.children:
                ep.children[-1].nextSibling = child_ep
            ep.children.append(child_ep)
        return ep

    for phaseKind in PhaseKindGraphRoots:
        traverse(phaseKind, None)

    return phases, phasesForKind


AllPhases, PhasesForPhaseKind = expandPhases()

# Name phases based on phase kind name and index if there are multiple phases
# corresponding to a single phase kind.

for phaseKind in AllPhaseKinds:
    phases = PhasesForPhaseKind[phaseKind]
    if len(phases) == 1:
        phases[0].name = "%s" % phaseKind.name
    else:
        for index, phase in enumerate(phases):
            phase.name = "%s_%d" % (phaseKind.name, index + 1)

# Find the maximum phase nesting.
MaxPhaseNesting = max(phase.depth for phase in AllPhases) + 1

# And the maximum bucket number.
MaxBucket = max(kind.bucket for kind in AllPhaseKinds)

# Generate code.


def writeList(out, items):
    if items:
        out.write(",\n".join("  " + item for item in items) + "\n")


def writeEnumClass(out, name, type, items, extraItems):
    items = ["FIRST"] + list(items) + ["LIMIT"] + list(extraItems)
    items[1] += " = " + items[0]
    out.write("enum class %s : %s {\n" % (name, type))
    writeList(out, items)
    out.write("};\n")


def generateHeader(out):
    #
    # Generate PhaseKind enum.
    #
    phaseKindNames = map(lambda phaseKind: phaseKind.name, AllPhaseKinds)
    extraPhaseKinds = [
        "NONE = LIMIT",
        "EXPLICIT_SUSPENSION = LIMIT",
        "IMPLICIT_SUSPENSION"
    ]
    writeEnumClass(out, "PhaseKind", "uint8_t", phaseKindNames, extraPhaseKinds)
    out.write("\n")

    #
    # Generate Phase enum.
    #
    phaseNames = map(lambda phase: phase.name, AllPhases)
    extraPhases = [
        "NONE = LIMIT",
        "EXPLICIT_SUSPENSION = LIMIT",
        "IMPLICIT_SUSPENSION"
    ]
    writeEnumClass(out, "Phase", "uint8_t", phaseNames, extraPhases)
    out.write("\n")

    #
    # Generate MAX_PHASE_NESTING constant.
    #
    out.write("static const size_t MAX_PHASE_NESTING = %d;\n" % MaxPhaseNesting)


def generateCpp(out):
    #
    # Generate the PhaseKindInfo table.
    #
    out.write("static constexpr PhaseKindTable phaseKinds = {\n")
    for phaseKind in AllPhaseKinds:
        phase = PhasesForPhaseKind[phaseKind][0]
        out.write("    /* PhaseKind::%s */ PhaseKindInfo { Phase::%s, %d },\n" %
                  (phaseKind.name, phase.name, phaseKind.bucket))
    out.write("};\n")
    out.write("\n")

    #
    # Generate the PhaseInfo tree.
    #
    def name(phase):
        return "Phase::" + phase.name if phase else "Phase::NONE"

    out.write("static constexpr PhaseTable phases = {\n")
    for phase in AllPhases:
        firstChild = phase.children[0] if phase.children else None
        phaseKind = phase.phaseKind
        out.write("    /* %s */ PhaseInfo { %s, %s, %s, %s, PhaseKind::%s, %d, \"%s\", \"%s\" },\n" %  # NOQA: E501
                  (name(phase),
                   name(phase.parent),
                   name(firstChild),
                   name(phase.nextSibling),
                   name(phase.nextInPhaseKind),
                   phaseKind.name,
                   phase.depth,
                   phaseKind.descr,
                   phase.path))
    out.write("};\n")

    #
    # Print in a comment the next available phase kind number.
    #
    out.write("// The next available phase kind number is: %d\n" %
            (MaxBucket + 1))

