/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 *
 * Copyright 2016 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "wasm/WasmCompartment.h"

#include "jscompartment.h"

#include "wasm/WasmInstance.h"

#include "vm/Debugger-inl.h"

using namespace js;
using namespace wasm;

// With tiering, instances can have one or two code segments, and code that
// searches the instance list will change.  Search for Tier::TBD below.

Compartment::Compartment(Zone* zone)
  : mutatingInstances_(false)
{}

Compartment::~Compartment()
{
    MOZ_ASSERT(instances_.empty());
    MOZ_ASSERT(!mutatingInstances_);
}

struct InstanceComparator
{
    const Instance& target;
    explicit InstanceComparator(const Instance& target) : target(target) {}

    int operator()(const Instance* instance) const {
        if (instance == &target)
            return 0;

        // Instances can share code, so the segments can be equal (though they
        // can't partially overlap).  If the codeBases are equal, we sort by
        // Instance address.  Thus a Code may map to many instances.
        if (instance->codeBase(Tier::TBD) == target.codeBase(Tier::TBD))
            return instance < &target ? -1 : 1;

        return target.codeBase(Tier::TBD) < instance->codeBase(Tier::TBD) ? -1 : 1;
    }
};

bool
Compartment::registerInstance(JSContext* cx, HandleWasmInstanceObject instanceObj)
{
    Instance& instance = instanceObj->instance();
    MOZ_ASSERT(this == &instance.compartment()->wasm);

    instance.ensureProfilingLabels(cx->runtime()->geckoProfiler().enabled());

    if (instance.debugEnabled() &&
        instance.compartment()->debuggerObservesAllExecution())
    {
        instance.ensureEnterFrameTrapsState(cx, true);
    }

    size_t index;
    if (BinarySearchIf(instances_, 0, instances_.length(), InstanceComparator(instance), &index))
        MOZ_CRASH("duplicate registration");

    {
        AutoMutateInstances guard(*this);
        if (!instances_.insert(instances_.begin() + index, &instance)) {
            ReportOutOfMemory(cx);
            return false;
        }
    }

    Debugger::onNewWasmInstance(cx, instanceObj);
    return true;
}

void
Compartment::unregisterInstance(Instance& instance)
{
    size_t index;
    if (!BinarySearchIf(instances_, 0, instances_.length(), InstanceComparator(instance), &index))
        return;

    AutoMutateInstances guard(*this);
    instances_.erase(instances_.begin() + index);
}

struct PCComparator
{
    const void* pc;
    explicit PCComparator(const void* pc) : pc(pc) {}

    int operator()(const Instance* instance) const {
        if (instance->codeSegment(Tier::TBD).containsCodePC(pc))
            return 0;
        return pc < instance->codeBase(Tier::TBD) ? -1 : 1;
    }
};

const Code*
Compartment::lookupCode(const void* pc, const CodeSegment** segmentp) const
{
    // lookupCode() can be called asynchronously from the interrupt signal
    // handler. In that case, the signal handler is just asking whether the pc
    // is in wasm code. If instances_ is being mutated then we can't be
    // executing wasm code so returning nullptr is fine.
    if (mutatingInstances_)
        return nullptr;

    size_t index;
    if (!BinarySearchIf(instances_, 0, instances_.length(), PCComparator(pc), &index))
        return nullptr;

    const Code& code = instances_[index]->code();
    if (segmentp)
        *segmentp = &code.segment(Tier::TBD);
    return &code;
}

void
Compartment::ensureProfilingLabels(bool profilingEnabled)
{
    for (Instance* instance : instances_)
        instance->ensureProfilingLabels(profilingEnabled);
}

void
Compartment::addSizeOfExcludingThis(MallocSizeOf mallocSizeOf, size_t* compartmentTables)
{
    *compartmentTables += instances_.sizeOfExcludingThis(mallocSizeOf);
}
